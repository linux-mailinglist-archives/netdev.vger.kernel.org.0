Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3812DFA06
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 09:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgLUIid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 03:38:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbgLUIid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 03:38:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608539826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4SXCl0QIzH64Vxn0oBAU/MjIwf7VvPol07R1vFHiaYg=;
        b=Ya8dw3RrKNpijboc7v61e21zIjcudMObwRciXu/CIcEiHtrKGWY5ANcRFTRVi2io0vrzrE
        JmwO2YsD+pA5s/DAuCJjHg/pAZqMuq2Du6ayg2i9/e8sCuHEz2uoRyCpBgsoaOm34M0XQ/
        UgwnsSuQoX6CROo8LfWrqN6hbUW/j0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-znt9a7rBN72WbXd9PzaLZA-1; Mon, 21 Dec 2020 03:37:04 -0500
X-MC-Unique: znt9a7rBN72WbXd9PzaLZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5505D801817;
        Mon, 21 Dec 2020 08:37:02 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5C7810016FB;
        Mon, 21 Dec 2020 08:36:52 +0000 (UTC)
Date:   Mon, 21 Dec 2020 09:36:51 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v4 bpf-next 1/2] net: xdp: introduce xdp_init_buff
 utility routine
Message-ID: <20201221093651.44ff4195@carbon>
In-Reply-To: <7f8329b6da1434dc2b05a77f2e800b29628a8913.1608399672.git.lorenzo@kernel.org>
References: <cover.1608399672.git.lorenzo@kernel.org>
        <7f8329b6da1434dc2b05a77f2e800b29628a8913.1608399672.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Dec 2020 18:55:00 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 11ec93f827c0..323340caef88 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -76,6 +76,13 @@ struct xdp_buff {
>  	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
>  };
>  
> +static __always_inline void
> +xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
> +{
> +	xdp->frame_sz = frame_sz;
> +	xdp->rxq = rxq;

Later you will add 'xdp->mb = 0' here.

> +}

Via the names of your functions, I assume that xdp_init_buff() is
called before xdp_prepare_buff(), right?
(And your pending 'xdp->mb = 0' also prefer this.)

Below in bpf_prog_test_run_xdp() and netif_receive_generic_xdp() you
violate this order... which will give you headaches when implementing
the multi-buff support.  It is also a bad example for driver developer
that need to figure out this calling-order from the function names.

Below, will it be possible to have 'init' before 'prepare'?


> +
>  /* Reserve memory area at end-of data area.
>   *
>   * This macro reserves tailroom in the XDP buffer by limiting the
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index c1c30a9f76f3..a8fa5a9e4137 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -640,10 +640,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	xdp.data = data + headroom;
>  	xdp.data_meta = xdp.data;
>  	xdp.data_end = xdp.data + size;
> -	xdp.frame_sz = headroom + max_data_sz + tailroom;
>  
>  	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
> -	xdp.rxq = &rxqueue->xdp_rxq;
> +	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
> +		      &rxqueue->xdp_rxq);
>  	bpf_prog_change_xdp(NULL, prog);
>  	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
>  	if (ret)
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a46334906c94..b1a765900c01 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4588,11 +4588,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	struct netdev_rx_queue *rxqueue;
>  	void *orig_data, *orig_data_end;
>  	u32 metalen, act = XDP_DROP;
> +	u32 mac_len, frame_sz;
>  	__be16 orig_eth_type;
>  	struct ethhdr *eth;
>  	bool orig_bcast;
>  	int hlen, off;
> -	u32 mac_len;
>  
>  	/* Reinjected packets coming from act_mirred or similar should
>  	 * not get XDP generic processing.
> @@ -4631,8 +4631,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	xdp->data_hard_start = skb->data - skb_headroom(skb);
>  
>  	/* SKB "head" area always have tailroom for skb_shared_info */
> -	xdp->frame_sz  = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
> -	xdp->frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +	frame_sz = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
> +	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  
>  	orig_data_end = xdp->data_end;
>  	orig_data = xdp->data;
> @@ -4641,7 +4641,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	orig_eth_type = eth->h_proto;
>  
>  	rxqueue = netif_get_rxqueue(skb);
> -	xdp->rxq = &rxqueue->xdp_rxq;
> +	xdp_init_buff(xdp, frame_sz, &rxqueue->xdp_rxq);
>  
>  	act = bpf_prog_run_xdp(xdp_prog, xdp);



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

