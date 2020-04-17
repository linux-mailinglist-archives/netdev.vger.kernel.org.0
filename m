Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D851AD894
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgDQIbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:31:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729658AbgDQIbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 04:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587112274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Hz1FVmecgDM5I61Cq/JKwdycA+GFY9QwoOXaqszi10=;
        b=Gqe8B2apuRFIgqNTCYUktUG5TvL+K2oBuvva9NnI+nvYU9AvqE3C0+ORdbSm5Misl49ed2
        0aYOl1IvJcT9gNmkZjXmEP/4bAwB728Vmg0bhl/pvHa4MWFJ/NqMxfT7mxxS/Q/ERqYYyc
        SBbN/fnMR5nHAhSVtIAktGjGmnLaKH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-ybOQDvzMMl6M_xOmH1Nj7Q-1; Fri, 17 Apr 2020 04:31:10 -0400
X-MC-Unique: ybOQDvzMMl6M_xOmH1Nj7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3831E802560;
        Fri, 17 Apr 2020 08:31:08 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB7418D57F;
        Fri, 17 Apr 2020 08:30:56 +0000 (UTC)
Date:   Fri, 17 Apr 2020 10:30:55 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH RFC-v5 bpf-next 09/12] dev: Support xdp in the Tx path
 for xdp_frames
Message-ID: <20200417103055.51a25b2d@carbon>
In-Reply-To: <20200413171801.54406-10-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org>
        <20200413171801.54406-10-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Apr 2020 11:17:58 -0600
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dahern@digitalocean.com>
> 
> Add support to run Tx path program on xdp_frames by adding a hook to
> bq_xmit_all before xdp_frames are passed to ndo_xdp_xmit for the device.
> 
> If an xdp_frame is dropped by the program, it is removed from the
> xdp_frames array with subsequent entries moved up.
> 
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/linux/netdevice.h |  3 ++
>  kernel/bpf/devmap.c       | 19 ++++++++---
>  net/core/dev.c            | 70 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 87 insertions(+), 5 deletions(-)
> 
[...]
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1bbaeb8842ed..f23dc6043329 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4720,6 +4720,76 @@ u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL_GPL(do_xdp_egress_skb);
>  
> +static u32 __xdp_egress_frame(struct net_device *dev,
> +			      struct bpf_prog *xdp_prog,
> +			      struct xdp_frame *xdp_frame,
> +			      struct xdp_txq_info *txq)
> +{
> +	struct xdp_buff xdp;
> +	u32 act;
> +
> +	xdp.data_hard_start = xdp_frame->data - xdp_frame->headroom;

You also need: minus sizeof(*xdp_frame).

The BPF-helper xdp_adjust_head will not allow BPF-prog to access the
memory area that is used for xdp_frame, thus it still is safe.


> +	xdp.data = xdp_frame->data;
> +	xdp.data_end = xdp.data + xdp_frame->len;
> +	xdp_set_data_meta_invalid(&xdp);
> +	xdp.txq = txq;

I think this will be the 3rd place we convert xdp-frame to xdp_buff,
perhaps we should introduce a helper function call.

> +	act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +	act = handle_xdp_egress_act(act, dev, xdp_prog);
> +
> +	/* if not dropping frame, readjust pointers in case
> +	 * program made changes to the buffer
> +	 */
> +	if (act != XDP_DROP) {
> +		int headroom = xdp.data - xdp.data_hard_start;
> +		int metasize = xdp.data - xdp.data_meta;
> +
> +		metasize = metasize > 0 ? metasize : 0;
> +		if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
> +			return XDP_DROP;
> +
> +		xdp_frame = xdp.data_hard_start;

Is this needed?

> +		xdp_frame->data = xdp.data;
> +		xdp_frame->len  = xdp.data_end - xdp.data;
> +		xdp_frame->headroom = headroom - sizeof(*xdp_frame);
> +		xdp_frame->metasize = metasize;
> +		/* xdp_frame->mem is unchanged */

This looks very similar to convert_to_xdp_frame.
Maybe we need an central update_xdp_frame(xdp_buff) call?


Untested code-up:

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..180800c4e7d1 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -93,6 +93,24 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 
+static inline
+bool update_xdp_frame(struct xdp_buff *xdp, struct xdp_frame *xdp_frame)
+{
+       /* Assure headroom is available for storing info */
+       headroom = xdp->data - xdp->data_hard_start;
+       metasize = xdp->data - xdp->data_meta;
+       metasize = metasize > 0 ? metasize : 0;
+       if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
+               return false;
+
+       xdp_frame->data = xdp->data;
+       xdp_frame->len  = xdp->data_end - xdp->data;
+       xdp_frame->headroom = headroom - sizeof(*xdp_frame);
+       xdp_frame->metasize = metasize;
+
+       return true;
+}
+
 /* Convert xdp_buff to xdp_frame */
 static inline
 struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
@@ -104,20 +122,11 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
        if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
                return xdp_convert_zc_to_xdp_frame(xdp);
 
-       /* Assure headroom is available for storing info */
-       headroom = xdp->data - xdp->data_hard_start;
-       metasize = xdp->data - xdp->data_meta;
-       metasize = metasize > 0 ? metasize : 0;
-       if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
-               return NULL;
-
        /* Store info in top of packet */
        xdp_frame = xdp->data_hard_start;
 
-       xdp_frame->data = xdp->data;
-       xdp_frame->len  = xdp->data_end - xdp->data;
-       xdp_frame->headroom = headroom - sizeof(*xdp_frame);
-       xdp_frame->metasize = metasize;
+       if (unlikely(!update_xdp_frame(xdp, xdp_frame))
+           return NULL;
 
        /* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
        xdp_frame->mem = xdp->rxq->mem;

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

