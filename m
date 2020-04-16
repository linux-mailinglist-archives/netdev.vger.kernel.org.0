Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BB71AC6A3
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394513AbgDPOme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:42:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37828 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389838AbgDPOAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:00:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jTBfmRvBoWhtY7ibPYORYZ0NP6xKqRYpk6tRTXIzMoU=;
        b=fYunJaTPla/CFFBf1iISASX5MKCADRPCDZUx790gSVrG1Q21sqBFoCT5K3vyHFCF7VWmtU
        GP9AybUXt4TrmfaXCMsR7/FxjsofkkOccd2PO+qy2M3UcIATl7RTL/W4B/l/J4WOl36EMw
        RvGVsO4NVs29Xb15/gox0ebrpw/lz1I=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-epS7NX1yOW6TIfvsu-ly_w-1; Thu, 16 Apr 2020 10:00:42 -0400
X-MC-Unique: epS7NX1yOW6TIfvsu-ly_w-1
Received: by mail-lj1-f197.google.com with SMTP id v22so1639696ljh.18
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jTBfmRvBoWhtY7ibPYORYZ0NP6xKqRYpk6tRTXIzMoU=;
        b=pxTY+dBm4pk+eTLMHujmn4MLOYDNdefrKRuwPKL/x1fMmQOz4n6IyLOG5khEAuuuBV
         kmuxPbir9+NpzkpOzJGl3MZPjFZgkR0YACTkZ/lesoTgg7EgEC1gODGzJogUfS6Nwxh0
         vtuPwMuVQw52dtnDQXPwE0/z0F2qNn9INejX4v8wPpm5et862l6NAcuHnQCV2q3Ku2A5
         Y2Id6RaAsdtERrqPxbELH8LgliIkTZYPnciNBbvomEcUepBatwXOJEQOG91Nsw4sybqa
         WpS7XeCDRLMRx1JuxDciHUq32CcInUVhLRiFjqcINJoTY2o93NT7NZG7P2h0yGgR0clZ
         b+nQ==
X-Gm-Message-State: AGi0PuaYmR7Im6OKf5gl+BpzRzogoapxjELEj25fSxZswQUlIgo3JPLa
        mIVEOISeP5f/QvJ1lcnlPNcq3ASO9iaYhae+w/bpxK1HqlQytGK+0GrSJf53zFmMXKyNUtWx9JA
        iEWVk6A7/9oyNmyFx
X-Received: by 2002:a19:7507:: with SMTP id y7mr6098340lfe.121.1587045641227;
        Thu, 16 Apr 2020 07:00:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ35pciRr7iqgGXYQERbbXgG5Q2Om80xcHg7l+jjf3iwf13Upj6OmsZualCNUw7qvUqvu8O9Q==
X-Received: by 2002:a19:7507:: with SMTP id y7mr6098317lfe.121.1587045640960;
        Thu, 16 Apr 2020 07:00:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t24sm18325872lfk.90.2020.04.16.07.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 07:00:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7D9C4181587; Thu, 16 Apr 2020 16:00:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC-v5 bpf-next 05/12] net: core: rename netif_receive_generic_xdp to do_generic_xdp_core
In-Reply-To: <20200413171801.54406-6-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org> <20200413171801.54406-6-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 16:00:38 +0200
Message-ID: <87mu7bled5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> In skb generic path, we need a way to run XDP program on skb but
> to have customized handling of XDP actions. netif_receive_generic_xdp
> will be more helpful in such cases than do_xdp_generic.
>
> This patch prepares netif_receive_generic_xdp() to be used as general
> purpose function for running xdp programs on skbs by renaming it to
> do_xdp_generic_core, moving skb_is_redirected and rxq settings as well
> as XDP return code checks to the callers.
>
> This allows this core function to be used from both Rx and Tx paths
> with rxq and txq set based on context.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  net/core/dev.c | 52 ++++++++++++++++++++++++--------------------------
>  1 file changed, 25 insertions(+), 27 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index e763b6cea8ff..4f0c4fee1125 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4500,25 +4500,17 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
>  	return rxqueue;
>  }
>  
> -static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> -				     struct xdp_buff *xdp,
> -				     struct bpf_prog *xdp_prog)
> +static u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
> +			       struct bpf_prog *xdp_prog)
>  {
> -	struct netdev_rx_queue *rxqueue;
>  	void *orig_data, *orig_data_end;
> -	u32 metalen, act = XDP_DROP;
>  	__be16 orig_eth_type;
>  	struct ethhdr *eth;
> +	u32 metalen, act;
>  	bool orig_bcast;
>  	int hlen, off;
>  	u32 mac_len;
>  
> -	/* Reinjected packets coming from act_mirred or similar should
> -	 * not get XDP generic processing.
> -	 */
> -	if (skb_is_redirected(skb))
> -		return XDP_PASS;
> -
>  	/* XDP packets must be linear and must have sufficient headroom
>  	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
>  	 * native XDP provides, thus we need to do it here as well.
> @@ -4534,9 +4526,9 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  		if (pskb_expand_head(skb,
>  				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
>  				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
> -			goto do_drop;
> +			return XDP_DROP;
>  		if (skb_linearize(skb))
> -			goto do_drop;
> +			return XDP_DROP;
>  	}
>  
>  	/* The XDP program wants to see the packet starting at the MAC
> @@ -4554,9 +4546,6 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
>  	orig_eth_type = eth->h_proto;
>  
> -	rxqueue = netif_get_rxqueue(skb);
> -	xdp->rxq = &rxqueue->xdp_rxq;
> -
>  	act = bpf_prog_run_xdp(xdp_prog, xdp);
>  
>  	/* check if bpf_xdp_adjust_head was used */
> @@ -4599,16 +4588,6 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  		if (metalen)
>  			skb_metadata_set(skb, metalen);
>  		break;
> -	default:
> -		bpf_warn_invalid_xdp_action(act);
> -		/* fall through */
> -	case XDP_ABORTED:
> -		trace_xdp_exception(skb->dev, xdp_prog, act);
> -		/* fall through */
> -	case XDP_DROP:
> -	do_drop:
> -		kfree_skb(skb);
> -		break;
>  	}
>  
>  	return act;
> @@ -4643,12 +4622,22 @@ static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
>  
>  int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
>  {
> +	/* Reinjected packets coming from act_mirred or similar should
> +	 * not get XDP generic processing.
> +	 */

My immediate thought when reading this was "wait, we're doing TX now, is
this still true?". And then I saw the next patch where you're renaming
the function; so maybe switch those two patches, or merge them?

-Toke

