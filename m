Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18C317A78E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgCEOfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:35:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725990AbgCEOfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:35:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583418941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tves5v0+rGKM6v1Y/AU4Uiwb4uE27U7fh/WSNa6f2Is=;
        b=JRVjDaWlqU6dLoVB6oNxdGMywEwb682wLYU3/bXBfFX5bTvNsDvEYFVjI7glNuEELn8KPD
        3hedFGBmj+igKjsACJNMegoErGvEPdzK99/pghGYE5d6FJFLp+NyRFzFS+NekOZ5dbqNeE
        RT952bFlu1WG/8zZu08j9c232vGtWhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-fnNvNrsQOvyq1_j7ZWyPKg-1; Thu, 05 Mar 2020 09:35:39 -0500
X-MC-Unique: fnNvNrsQOvyq1_j7ZWyPKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 482C5800D4E;
        Thu,  5 Mar 2020 14:35:37 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D8AD1001902;
        Thu,  5 Mar 2020 14:35:29 +0000 (UTC)
Date:   Thu, 5 Mar 2020 15:35:27 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
Message-ID: <20200305153515.4ce0ecf4@carbon>
In-Reply-To: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Mar 2020 17:21:14 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 482c6c8..db8a280 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
[...]
> @@ -778,6 +782,40 @@ static int xennet_get_extras(struct netfront_queue *queue,
>  	return err;
>  }
>  
> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> +		   struct xdp_buff *xdp)
> +{
> +	u32 len = rx->status;
> +	u32 act = XDP_PASS;
> +
> +	xdp->data_hard_start = page_address(pdata);
> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->handle = 0;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +	case XDP_TX:
> +	case XDP_DROP:
> +		break;
> +
> +	case XDP_ABORTED:
> +		trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +	}
> +
> +	if (act != XDP_PASS && act != XDP_TX)
> +		xdp->data_hard_start = NULL;
> +
> +	return act;
> +}
> +
>  static int xennet_get_responses(struct netfront_queue *queue,
>  				struct netfront_rx_info *rinfo, RING_IDX rp,
>  				struct sk_buff_head *list)
> @@ -792,6 +830,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  	int slots = 1;
>  	int err = 0;
>  	unsigned long ret;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 verdict;
>  
>  	if (rx->flags & XEN_NETRXF_extra_info) {
>  		err = xennet_get_extras(queue, extras, rp);
> @@ -827,6 +868,22 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  
>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>  
> +		rcu_read_lock();
> +		xdp_prog = rcu_dereference(queue->xdp_prog);
> +		if (xdp_prog) {
> +			/* currently only a single page contains data */
> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
> +			verdict = xennet_run_xdp(queue,
> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),

This looks really weird, skb_shinfo(skb)->frags[0], you already have an
SKB and you are sending fragment-0 to the xennet_run_xdp() function.

XDP meant to run before an SKB is allocated...

> +				       rx, xdp_prog, &xdp);
> +
> +			if (verdict != XDP_PASS && verdict != XDP_TX) {
> +				err = -EINVAL;
> +				goto next;
> +			}
> +
> +		}
> +		rcu_read_unlock();
>  		__skb_queue_tail(list, skb);


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

