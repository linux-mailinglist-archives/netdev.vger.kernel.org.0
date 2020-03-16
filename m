Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412FE186F4A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 16:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgCPPvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 11:51:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:43568 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732059AbgCPPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 11:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584373864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E437h4AXVPurdxkEZm+wlXmFwURlSgsNRNuhrB2sfJw=;
        b=M0LSdkNnZy1sLx7OIVZ9moPfwCQGJkJqQ0a/IJaG7JLkQr3fRNuynbCJTSergx0LwG+OWj
        80OHvNgiQgLQ9M5qXkuWiyaK+QkMKTY6+O32roRerG5IdSiS9hDpO1yS+sd/qq83NhvxxF
        0KQtoCUSDop37MAySSI93qAaEdvmDh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-t_Yyfeu5NZWwneY33GaOgw-1; Mon, 16 Mar 2020 11:44:44 -0400
X-MC-Unique: t_Yyfeu5NZWwneY33GaOgw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6668144D8C;
        Mon, 16 Mar 2020 15:44:42 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44B348FBF9;
        Mon, 16 Mar 2020 15:44:37 +0000 (UTC)
Date:   Mon, 16 Mar 2020 16:44:35 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org, wei.liu@kernel.org, paul@xen.org
Subject: Re: [PATCH net-next v4] xen networking: add basic XDP support for
 xen-netfront
Message-ID: <20200316164435.27751dbf@carbon>
In-Reply-To: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 16:09:36 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 482c6c8..c06ae57 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
[...]
> @@ -778,6 +790,52 @@ static int xennet_get_extras(struct netfront_queue *queue,
>  	return err;
>  }
>  
> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> +		   struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf;
> +	u32 len = rx->status;
> +	u32 act = XDP_PASS;
> +	int err;
> +
> +	xdp->data_hard_start = page_address(pdata);
> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->rxq = &queue->xdp_rxq;
> +	xdp->handle = 0;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_TX:
> +		xdpf = convert_to_xdp_frame(xdp);
> +		err = xennet_xdp_xmit(queue->info->netdev, 1,
> +				&xdpf, 0);

Strange line wrap, I don't think this is needed, please fix.


> +		if (unlikely(err < 0))
> +			trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(queue->info->netdev, xdp, prog);

What is the frame size of the packet memory?


> +		if (unlikely(err))
> +			trace_xdp_exception(queue->info->netdev, prog, act);
> +		xdp_do_flush();
> +		break;
> +	case XDP_PASS:
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
> +	return act;
> +}
> +

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

