Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30428A9A0
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgJKTY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgJKTY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 15:24:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968B7215A4;
        Sun, 11 Oct 2020 19:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602444267;
        bh=lIyrERL8qtiZlMwGF3ntzR7YeVgWEwXb4hhEOmy8iLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I4M24RjvnAeBc0UvrwMQqtugtT4wTMes5cWkqEewioNjMOZR6XBJGZMg1gwVSPG4a
         wp9zAnqmniYBC5NBYErFBgEiYpBxiNebRLn/r1y+TI+EmwERmOuLIVO61pqBGfhYeC
         VNiriIEZEd1IthizBVCz854NGpsp1ohbyoEM16R0=
Date:   Sun, 11 Oct 2020 12:24:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next] cxgb4/ch_ipsec: Replace the module name to
 ch_ipsec from chcr
Message-ID: <20201011122422.56beacaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008140016.17918-1-ayush.sawal@chelsio.com>
References: <20201008140016.17918-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 19:30:15 +0530 Ayush Sawal wrote:
> @@ -140,8 +141,8 @@ static int ch_ipsec_uld_state_change(void *handle, enum cxgb4_state new_state)
>  	return 0;
>  }
>  
> -static inline int chcr_ipsec_setauthsize(struct xfrm_state *x,
> -					 struct ipsec_sa_entry *sa_entry)
> +static inline int ch_ipsec_setauthsize(struct xfrm_state *x,
> +				       struct ipsec_sa_entry *sa_entry)
>  {
>  	int hmac_ctrl;
>  	int authsize = x->aead->alg_icv_len / 8;
> @@ -164,8 +165,8 @@ static inline int chcr_ipsec_setauthsize(struct xfrm_state *x,
>  	return hmac_ctrl;
>  }
>  
> -static inline int chcr_ipsec_setkey(struct xfrm_state *x,
> -				    struct ipsec_sa_entry *sa_entry)
> +static inline int ch_ipsec_setkey(struct xfrm_state *x,
> +				  struct ipsec_sa_entry *sa_entry)

Please remove the inline keywords while at it, and let the compiler
decide what to inline.

>  {
>  	int keylen = (x->aead->alg_key_len + 7) / 8;
>  	unsigned char *key = x->aead->alg_key;

>  	if (x->props.aalgo != SADB_AALG_NONE) {
> -		pr_debug("CHCR: Cannot offload authenticated xfrm states\n");
> +		pr_debug("CH_IPSEC: Cannot offload authenticated xfrm states\n");
>  		return -EINVAL;
>  	}
>  	if (x->props.calgo != SADB_X_CALG_NONE) {
> -		pr_debug("CHCR: Cannot offload compressed xfrm states\n");
> +		pr_debug("CH_IPSEC: Cannot offload compressed xfrm states\n");
>  		return -EINVAL;
>  	}
>  	if (x->props.family != AF_INET &&
>  	    x->props.family != AF_INET6) {
> -		pr_debug("CHCR: Only IPv4/6 xfrm state offloaded\n");
> +		pr_debug("CH_IPSEC: Only IPv4/6 xfrm state offloaded\n");
>  		return -EINVAL;
>  	}
>  	if (x->props.mode != XFRM_MODE_TRANSPORT &&
>  	    x->props.mode != XFRM_MODE_TUNNEL) {
> -		pr_debug("CHCR: Only transport and tunnel xfrm offload\n");
> +		pr_debug("CH_IPSEC: Only transport and tunnel xfrm offload\n");
>  		return -EINVAL;
>  	}
>  	if (x->id.proto != IPPROTO_ESP) {
> -		pr_debug("CHCR: Only ESP xfrm state offloaded\n");
> +		pr_debug("CH_IPSEC: Only ESP xfrm state offloaded\n");
>  		return -EINVAL;
>  	}
>  	if (x->encap) {
> -		pr_debug("CHCR: Encapsulated xfrm state not offloaded\n");
> +		pr_debug("CH_IPSEC: Encapsulated xfrm state not offloaded\n");
>  		return -EINVAL;
>  	}
>  	if (!x->aead) {
> -		pr_debug("CHCR: Cannot offload xfrm states without aead\n");
> +		pr_debug("CH_IPSEC: Cannot offload xfrm states without aead\n");

Why is this printing the "CH_IPSEC: " prefix if you already have:

+#define pr_fmt(fmt) "ch_ipsec: " fmt

?

>  		return -EINVAL;
>  	}
>  	if (x->aead->alg_icv_len != 128 &&
>  	    x->aead->alg_icv_len != 96) {
> -		pr_debug("CHCR: Cannot offload xfrm states with AEAD ICV length other than 96b & 128b\n");
> +		pr_debug("CH_IPSEC: Cannot offload xfrm states with AEAD ICV length other than 96b & 128b\n");
>  	return -EINVAL;
>  	}
>  	if ((x->aead->alg_key_len != 128 + 32) &&
>  	    (x->aead->alg_key_len != 256 + 32)) {
> -		pr_debug("CHCR: Cannot offload xfrm states with AEAD key length other than 128/256 bit\n");
> +		pr_debug("CH_IPSEC: Cannot offload xfrm states with AEAD key length other than 128/256 bit\n");
>  		return -EINVAL;
>  	}
>  	if (x->tfcpad) {
> -		pr_debug("CHCR: Cannot offload xfrm states with tfc padding\n");
> +		pr_debug("CH_IPSEC: Cannot offload xfrm states with tfc padding\n");
>  		return -EINVAL;
>  	}
>  	if (!x->geniv) {
> -		pr_debug("CHCR: Cannot offload xfrm states without geniv\n");
> +		pr_debug("CH_IPSEC: Cannot offload xfrm states without geniv\n");
>  		return -EINVAL;
>  	}
>  	if (strcmp(x->geniv, "seqiv")) {
> -		pr_debug("CHCR: Cannot offload xfrm states with geniv other than seqiv\n");
> +		pr_debug("CH_IPSEC: Cannot offload xfrm states with geniv other than seqiv\n");
>  		return -EINVAL;
>  	}

> @@ -763,7 +764,7 @@ out_free:       dev_kfree_skb_any(skb);
>  	before = (u64 *)pos;
>  	end = (u64 *)pos + flits;
>  	/* Setup IPSec CPL */
> -	pos = (void *)chcr_crypto_wreq(skb, dev, (void *)pos,
> +	pos = (void *)ch_ipsec_crypto_wreq(skb, dev, (void *)pos,
>  				       credits, sa_entry);

The continuation line needs to be adjusted to match the position of
opening parenthesis.

>  	if (before > (u64 *)pos) {
>  		left = (u8 *)end - (u8 *)q->q.stat;
