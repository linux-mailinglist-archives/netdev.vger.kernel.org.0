Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54C11D2D4B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgENKuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:50:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49978 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgENKuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:50:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589453402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJozLp805Mg43nuJXEWPGCbqITfHTnXTSkM+tXIxIWA=;
        b=TW+f/tao/EffECi/Xm+oCKpVpBbRRhcE16qoYArOgOPwvKgEAyujO8olBfQcf1lna6ioOK
        5aB6w4NaxZtcmXR/WcCToyQy6pHReohXjQtqK21dfV4keqIAXGSmC2S7gifegA9trmob0E
        5al7rIOyTuDSifFpE2MwvxidFp7+/W0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-8UYhJpY-N-a0C-soXTwoyw-1; Thu, 14 May 2020 06:49:58 -0400
X-MC-Unique: 8UYhJpY-N-a0C-soXTwoyw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE58B80058A;
        Thu, 14 May 2020 10:49:56 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BAE476C38;
        Thu, 14 May 2020 10:49:49 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7419C325159C9;
        Thu, 14 May 2020 12:49:48 +0200 (CEST)
Subject: [PATCH net-next v4 10/33] veth: xdp using frame_sz in veth driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Thu, 14 May 2020 12:49:48 +0200
Message-ID: <158945338840.97035.935897116345700902.stgit@firesoul>
In-Reply-To: <158945314698.97035.5286827951225578467.stgit@firesoul>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The veth driver can run XDP in "native" mode in it's own NAPI
handler, and since commit 9fc8d518d9d5 ("veth: Handle xdp_frames in
xdp napi ring") packets can come in two forms either xdp_frame or
skb, calling respectively veth_xdp_rcv_one() or veth_xdp_rcv_skb().

For packets to arrive in xdp_frame format, they will have been
redirected from an XDP native driver. In case of XDP_PASS or no
XDP-prog attached, the veth driver will allocate and create an SKB.

The current code in veth_xdp_rcv_one() xdp_frame case, had to guess
the frame truesize of the incoming xdp_frame, when using
veth_build_skb(). With xdp_frame->frame_sz this is not longer
necessary.

Calculating the frame_sz in veth_xdp_rcv_skb() skb case, is done
similar to the XDP-generic handling code in net/core/dev.c.

Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 drivers/net/veth.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d5691bb84448..b586d2fa5551 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -405,10 +405,6 @@ static struct sk_buff *veth_build_skb(void *head, int headroom, int len,
 {
 	struct sk_buff *skb;
 
-	if (!buflen) {
-		buflen = SKB_DATA_ALIGN(headroom + len) +
-			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	}
 	skb = build_skb(head, buflen);
 	if (!skb)
 		return NULL;
@@ -583,6 +579,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 		xdp.data = frame->data;
 		xdp.data_end = frame->data + frame->len;
 		xdp.data_meta = frame->data - frame->metasize;
+		xdp.frame_sz = frame->frame_sz;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -629,7 +626,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	rcu_read_unlock();
 
 	headroom = sizeof(struct xdp_frame) + frame->headroom - delta;
-	skb = veth_build_skb(hard_start, headroom, len, 0);
+	skb = veth_build_skb(hard_start, headroom, len, frame->frame_sz);
 	if (!skb) {
 		xdp_return_frame(frame);
 		stats->rx_drops++;
@@ -695,9 +692,8 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 			goto drop;
 		}
 
-		nskb = veth_build_skb(head,
-				      VETH_XDP_HEADROOM + mac_len, skb->len,
-				      PAGE_SIZE);
+		nskb = veth_build_skb(head, VETH_XDP_HEADROOM + mac_len,
+				      skb->len, PAGE_SIZE);
 		if (!nskb) {
 			page_frag_free(head);
 			goto drop;
@@ -715,6 +711,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	xdp.data_end = xdp.data + pktlen;
 	xdp.data_meta = xdp.data;
 	xdp.rxq = &rq->xdp_rxq;
+
+	/* SKB "head" area always have tailroom for skb_shared_info */
+	xdp.frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
+	xdp.frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
 
@@ -758,6 +759,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	}
 	rcu_read_unlock();
 
+	/* check if bpf_xdp_adjust_head was used */
 	delta = orig_data - xdp.data;
 	off = mac_len + delta;
 	if (off > 0)
@@ -765,9 +767,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	else if (off < 0)
 		__skb_pull(skb, -off);
 	skb->mac_header -= delta;
+
+	/* check if bpf_xdp_adjust_tail was used */
 	off = xdp.data_end - orig_data_end;
 	if (off != 0)
-		__skb_put(skb, off);
+		__skb_put(skb, off); /* positive on grow, negative on shrink */
 	skb->protocol = eth_type_trans(skb, rq->dev);
 
 	metalen = xdp.data - xdp.data_meta;


