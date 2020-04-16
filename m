Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4141AB5DF
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 04:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733094AbgDPCaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 22:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgDPCaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 22:30:03 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44D1D2076C;
        Thu, 16 Apr 2020 02:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587004203;
        bh=OXGg7eR7rpnYEOHQQRC8srzEO8FNkP9vr1L2UnkFujU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ElY3azHpAvbSu3W8U2E23nlw5nvSd0gZZ+Q0c0W7EBWlRPPqYK861dhq7aS0wfaD5
         noU97q53323TVvkztI9ZXbB7/yyiSbL8aZElVqutLBPH2QMVsSqVmAned+ox7GCwI+
         d/+8gWmraGNyV3FatuK0U1WY6OIaG9tGDhjbCVZQ=
Date:   Wed, 15 Apr 2020 19:30:01 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: crypto: api - Fix use-after-free and race in crypto_spawn_alg
Message-ID: <20200416023001.GE816@sol.localdomain>
References: <0000000000002656a605a2a34356@google.com>
 <20200410060942.GA4048@gondor.apana.org.au>
 <20200416021703.GD816@sol.localdomain>
 <20200416022502.GA18386@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416022502.GA18386@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 12:25:02PM +1000, Herbert Xu wrote:
> On Wed, Apr 15, 2020 at 07:17:03PM -0700, Eric Biggers wrote:
> > 
> > Wouldn't it be a bit simpler to set 'target = NULL', remove 'shoot',
> > and use 'if (target)' instead of 'if (shoot)'?
> 
> Yes it is simpler but it's actually semantically different because
> the compiler doesn't know that spawn->alg cannot be NULL in this
> case.
> 

I'm not sure what you mean here.  crypto_alg_get() is:

static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
{
        refcount_inc(&alg->cra_refcnt);
        return alg;
}

So given:

	target = crypto_alg_get(alg);

Both alg and target have to be non-NULL.

- Eric
