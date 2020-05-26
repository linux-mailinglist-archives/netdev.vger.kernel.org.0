Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D556C1E23F9
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgEZOU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:20:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726962AbgEZOU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590502824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0EUB5bu69vDYrvOl3gojrIhkF/QAHgRV/oBluKdE8EY=;
        b=TJOFLTmhZyawBjY73Oh7dBfKHSFiFe8xhk9MXzgZVWVYomuJnaFbCRPjWrCx2Ym3u1l/wX
        GbOg0hQKUHRN7guhhFCPmMOvWDfDgXpKQY2SFtoZ6KCnpYd2CKS/4WJ5s1W42WYw5NHOXc
        O9LMDeq/Mh32gYmTI8OppG/wwFcnjZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-8567DumrP0W2qT19_AC_9g-1; Tue, 26 May 2020 10:20:20 -0400
X-MC-Unique: 8567DumrP0W2qT19_AC_9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 221DA1902EA0;
        Tue, 26 May 2020 14:20:19 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9692479C4F;
        Tue, 26 May 2020 14:20:10 +0000 (UTC)
Date:   Tue, 26 May 2020 16:20:08 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        toshiaki.makita1@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next] xdp: introduce convert_to_xdp_buff utility
 routine
Message-ID: <20200526162008.7bd2d18f@carbon>
In-Reply-To: <26bcdba277dc23a57298218b7617cd8ebe03676e.1590500470.git.lorenzo@kernel.org>
References: <26bcdba277dc23a57298218b7617cd8ebe03676e.1590500470.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 15:48:13 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce convert_to_xdp_buff utility routine to initialize xdp_buff
> fields from xdp_frames ones. Rely on convert_to_xdp_buff in veth xdp
> code
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 12 ++----------
>  include/net/xdp.h  | 10 ++++++++++
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b586d2fa5551..dfbe553f967e 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -559,27 +559,19 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  					struct veth_xdp_tx_bq *bq,
>  					struct veth_stats *stats)
>  {
> -	void *hard_start = frame->data - frame->headroom;
>  	int len = frame->len, delta = 0;
>  	struct xdp_frame orig_frame;
>  	struct bpf_prog *xdp_prog;
>  	unsigned int headroom;
>  	struct sk_buff *skb;
>  
> -	/* bpf_xdp_adjust_head() assures BPF cannot access xdp_frame area */
> -	hard_start -= sizeof(struct xdp_frame);
> -
>  	rcu_read_lock();
>  	xdp_prog = rcu_dereference(rq->xdp_prog);
>  	if (likely(xdp_prog)) {
>  		struct xdp_buff xdp;
>  		u32 act;
>  
> -		xdp.data_hard_start = hard_start;
> -		xdp.data = frame->data;
> -		xdp.data_end = frame->data + frame->len;
> -		xdp.data_meta = frame->data - frame->metasize;
> -		xdp.frame_sz = frame->frame_sz;
> +		convert_to_xdp_buff(frame, &xdp);
>  		xdp.rxq = &rq->xdp_rxq;
>  
>  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -626,7 +618,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  	rcu_read_unlock();
>  
>  	headroom = sizeof(struct xdp_frame) + frame->headroom - delta;
> -	skb = veth_build_skb(hard_start, headroom, len, frame->frame_sz);
> +	skb = veth_build_skb(frame, headroom, len, frame->frame_sz);
>  	if (!skb) {
>  		xdp_return_frame(frame);
>  		stats->rx_drops++;
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 90f11760bd12..5dbdd65866a9 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -106,6 +106,16 @@ void xdp_warn(const char *msg, const char *func, const int line);
>  
>  struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
>  
> +static inline
> +void convert_to_xdp_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> +{
> +	xdp->data_hard_start = (void *)frame;

This assumption is problematic.  You are suppose to deduct this from
frame->data pointer.

Currently the xdp_frame is designed and access such that is is possible
to use another memory area for xdp_frame.  That would break after this
change.

This should instead be:

 xdp->data_hard_start = frame->data - (frame->headroom + sizeof(struct xdp_frame));

> +	xdp->data = frame->data;
> +	xdp->data_end = frame->data + frame->len;
> +	xdp->data_meta = frame->data - frame->metasize;
> +	xdp->frame_sz = frame->frame_sz;
> +}
> +

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

