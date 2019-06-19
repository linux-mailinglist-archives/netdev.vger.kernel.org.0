Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B8A4BF94
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfFSRZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfFSRZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 13:25:42 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21A9206E0;
        Wed, 19 Jun 2019 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560965141;
        bh=uchaO/9EZShyrzG9yuh3hTznaXKVjy1sKlpIJ0tQ3Bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TpqKRz9ParHJz0TXk1T5Y+Ro+RnOT/hdUjUfRBGqPQZM4ZrEzByhAhN9rTwpGlJ6m
         DgBSIetc7h2ywycoF6S9swp6nH4Rk/qCy/ZC8tpSaElDB6XigK/OygrW0VytAuUpgZ
         6KvTdzfGhdRu7oixUiBqBT/g4cKJAZ+2J/8G9T8U=
Date:   Wed, 19 Jun 2019 10:25:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, edumazet@google.com,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com,
        ycheng@google.com
Subject: Re: [PATCH net-next v2 1/1] net: fastopen: robustness and endianness
 fixes for SipHash
Message-ID: <20190619172538.GA33328@gmail.com>
References: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
 <20190619065510.23514-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190619065510.23514-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 08:55:10AM +0200, Ard Biesheuvel wrote:
>  int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
> -			      void *primary_key, void *backup_key,
> -			      unsigned int len)
> +			      void *primary_key, void *backup_key)
>  {
>  	struct tcp_fastopen_context *ctx, *octx;
>  	struct fastopen_queue *q;
> @@ -81,9 +79,15 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
>  		goto out;
>  	}
>  
> -	memcpy(ctx->key[0], primary_key, len);
> +	ctx->key[0] = (siphash_key_t){
> +		get_unaligned_le64(primary_key),
> +		get_unaligned_le64(primary_key + 8)
> +	};
>  	if (backup_key) {
> -		memcpy(ctx->key[1], backup_key, len);
> +		ctx->key[1] = (siphash_key_t){
> +			get_unaligned_le64(backup_key),
> +			get_unaligned_le64(backup_key + 8)
> +		};
>  		ctx->num = 2;
>  	} else {
>  		ctx->num = 1;

These initializers are missing a level of braces.

Otherwise this patch looks good to me.

net/ipv4/tcp_fastopen.c: In function ‘tcp_fastopen_reset_cipher’:
net/ipv4/tcp_fastopen.c:82:16: warning: missing braces around initializer [-Wmissing-braces]
  ctx->key[0] = (siphash_key_t){
                ^
   get_unaligned_le64(primary_key),
   {
net/ipv4/tcp_fastopen.c:85:2:
  };
  }
net/ipv4/tcp_fastopen.c:87:17: warning: missing braces around initializer [-Wmissing-braces]
   ctx->key[1] = (siphash_key_t){
                 ^
    get_unaligned_le64(backup_key),
    {
net/ipv4/tcp_fastopen.c:90:3:
   };
   }
