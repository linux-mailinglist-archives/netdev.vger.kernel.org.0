Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932201AB5CC
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 04:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732220AbgDPCRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 22:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732005AbgDPCRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 22:17:07 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6320A20656;
        Thu, 16 Apr 2020 02:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587003425;
        bh=7jbHIbkIv+g7KwSbl0G4SwQ+s3EbSDnsxuzrtjKoAkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vuojUktZ+aZ0sgh2r1xUOcuxkaqXBRVoYIySFcbjU4d+99EUVZSMPiYl9Pp4ubLeg
         CshgWl4eWJIRP0iC25Ks7DmXqGlZa7pJMJ8O3kIqhdm8BX8mRT2+W2Ui/DiAUTIn+U
         +Q/jNYaLiSOPsTSjlwCcQnzgxcf7OdW602yH0vEE=
Date:   Wed, 15 Apr 2020 19:17:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: crypto: api - Fix use-after-free and race in crypto_spawn_alg
Message-ID: <20200416021703.GD816@sol.localdomain>
References: <0000000000002656a605a2a34356@google.com>
 <20200410060942.GA4048@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410060942.GA4048@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 04:09:42PM +1000, Herbert Xu wrote:
> There are two problems in crypto_spawn_alg.  First of all it may
> return spawn->alg even if spawn->dead is set.  This results in a
> double-free as detected by syzbot.
> 
> Secondly the setting of the DYING flag is racy because we hold
> the read-lock instead of the write-lock.  We should instead call
> crypto_shoot_alg in a safe manner by gaining a refcount, dropping
> the lock, and then releasing the refcount.
> 
> This patch fixes both problems.
> 
> Reported-by: syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com
> Fixes: 4f87ee118d16 ("crypto: api - Do not zap spawn->alg")
> Fixes: 73669cc55646 ("crypto: api - Fix race condition in...")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 69605e21af92..f8b4dc161c02 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -716,17 +716,27 @@ EXPORT_SYMBOL_GPL(crypto_drop_spawn);
>  
>  static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
>  {
> -	struct crypto_alg *alg;
> +	struct crypto_alg *alg = ERR_PTR(-EAGAIN);
> +	struct crypto_alg *target;
> +	bool shoot = false;
>  
>  	down_read(&crypto_alg_sem);
> -	alg = spawn->alg;
> -	if (!spawn->dead && !crypto_mod_get(alg)) {
> -		alg->cra_flags |= CRYPTO_ALG_DYING;
> -		alg = NULL;
> +	if (!spawn->dead) {
> +		alg = spawn->alg;
> +		if (!crypto_mod_get(alg)) {
> +			target = crypto_alg_get(alg);
> +			shoot = true;
> +			alg = ERR_PTR(-EAGAIN);
> +		}
>  	}
>  	up_read(&crypto_alg_sem);
>  
> -	return alg ?: ERR_PTR(-EAGAIN);
> +	if (shoot) {
> +		crypto_shoot_alg(target);
> +		crypto_alg_put(target);
> +	}
> +
> +	return alg;
>  }

Wouldn't it be a bit simpler to set 'target = NULL', remove 'shoot',
and use 'if (target)' instead of 'if (shoot)'?

- Eric
