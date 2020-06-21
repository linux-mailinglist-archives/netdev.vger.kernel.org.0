Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AFF202B4C
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgFUPPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:15:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730255AbgFUPPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 11:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592752532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zasjBbKc5HCggRAKraXGEFWYp6Xob3zmzKq6nO0rQ8o=;
        b=KO9SOf9MobhHTCssTmJJ/IxCXBN0PiUif4a2corhZ19v2SD9UjlPAiig5TvGi2Iz/qHpra
        KUq843uxkoI3zgV+lG6Pb5QOFrqZ8VwA/yn1NIG+iv9zhfIDmFybufHS5HP0KfCFjzanA0
        4OL8M3QzqCypgsblNEiQaGzgTdVsHIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-RCIhFm_oNlOKCzRSEQPLLA-1; Sun, 21 Jun 2020 11:15:28 -0400
X-MC-Unique: RCIhFm_oNlOKCzRSEQPLLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C9B3835B41;
        Sun, 21 Jun 2020 15:15:27 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83F3B5D9D5;
        Sun, 21 Jun 2020 15:15:15 +0000 (UTC)
Date:   Sun, 21 Jun 2020 17:15:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        David Ahern <dahern@digitalocean.com>, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 1/8] net: Refactor xdp_convert_buff_to_frame
Message-ID: <20200621171513.066e78ed@carbon>
In-Reply-To: <dfeb25e5274b0895f29fc1960e1cbd6c01157f8a.1592606391.git.lorenzo@kernel.org>
References: <cover.1592606391.git.lorenzo@kernel.org>
        <dfeb25e5274b0895f29fc1960e1cbd6c01157f8a.1592606391.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 00:57:17 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> From: David Ahern <dahern@digitalocean.com>
> 
> Move the guts of xdp_convert_buff_to_frame to a new helper,
> xdp_update_frame_from_buff so it can be reused removing code duplication
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/net/xdp.h | 35 ++++++++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 609f819ed08b..ab1c503808a4 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -121,39 +121,48 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
>  	xdp->frame_sz = frame->frame_sz;
>  }
>  
> -/* Convert xdp_buff to xdp_frame */
>  static inline
> -struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
> +int xdp_update_frame_from_buff(struct xdp_buff *xdp,
> +			       struct xdp_frame *xdp_frame)
>  {
> -	struct xdp_frame *xdp_frame;
> -	int metasize;
> -	int headroom;
> -
> -	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
> -		return xdp_convert_zc_to_xdp_frame(xdp);
> +	int metasize, headroom;
>  
>  	/* Assure headroom is available for storing info */
>  	headroom = xdp->data - xdp->data_hard_start;
>  	metasize = xdp->data - xdp->data_meta;
>  	metasize = metasize > 0 ? metasize : 0;
>  	if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
> -		return NULL;
> +		return -ENOMEM;

IMHO I think ENOMEM is reserved for memory allocations failures.
I think ENOSPC will be more appropriate here (or EOVERFLOW).

>  
>  	/* Catch if driver didn't reserve tailroom for skb_shared_info */
>  	if (unlikely(xdp->data_end > xdp_data_hard_end(xdp))) {
>  		XDP_WARN("Driver BUG: missing reserved tailroom");
> -		return NULL;
> +		return -ENOMEM;

Same here.

>  	}
>  
> -	/* Store info in top of packet */
> -	xdp_frame = xdp->data_hard_start;
> -
>  	xdp_frame->data = xdp->data;
>  	xdp_frame->len  = xdp->data_end - xdp->data;
>  	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>  	xdp_frame->metasize = metasize;
>  	xdp_frame->frame_sz = xdp->frame_sz;
>  
> +	return 0;
> +}
> +
> +/* Convert xdp_buff to xdp_frame */
> +static inline
> +struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdp_frame;
> +
> +	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
> +		return xdp_convert_zc_to_xdp_frame(xdp);
> +
> +	/* Store info in top of packet */
> +	xdp_frame = xdp->data_hard_start;
> +	if (unlikely(xdp_update_frame_from_buff(xdp, xdp_frame) < 0))
> +		return NULL;
> +
>  	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
>  	xdp_frame->mem = xdp->rxq->mem;
>  



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

