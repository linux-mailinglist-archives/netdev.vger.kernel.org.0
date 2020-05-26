Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307531E234D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgEZNsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 09:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgEZNsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 09:48:45 -0400
Received: from localhost.localdomain.com (unknown [151.48.148.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F005C206C3;
        Tue, 26 May 2020 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590500925;
        bh=br5hq+/xboZF0mD2QUl2IO6kSUPYhmSavWgQKk2qyHI=;
        h=From:To:Cc:Subject:Date:From;
        b=M1SeeFfc1Rw2KRirnWiVrqJgHAtdguFWcngU5eIiCC7fYkBQ7A3HsLO7JUO7nY+26
         Jwuu4pF1kQMzYhcMbs3oA06OQSRXWake/moGzpCyyKtwC26HQfhFKk5m1EOJgt/q2P
         d7P2qtceu2sWZUL88TdaDWnnOHr/yz+4TfDjV8sw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, toshiaki.makita1@gmail.com
Subject: [PATCH bpf-next] xdp: introduce convert_to_xdp_buff utility routine
Date:   Tue, 26 May 2020 15:48:13 +0200
Message-Id: <26bcdba277dc23a57298218b7617cd8ebe03676e.1590500470.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce convert_to_xdp_buff utility routine to initialize xdp_buff
fields from xdp_frames ones. Rely on convert_to_xdp_buff in veth xdp
code

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 12 ++----------
 include/net/xdp.h  | 10 ++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b586d2fa5551..dfbe553f967e 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -559,27 +559,19 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 					struct veth_xdp_tx_bq *bq,
 					struct veth_stats *stats)
 {
-	void *hard_start = frame->data - frame->headroom;
 	int len = frame->len, delta = 0;
 	struct xdp_frame orig_frame;
 	struct bpf_prog *xdp_prog;
 	unsigned int headroom;
 	struct sk_buff *skb;
 
-	/* bpf_xdp_adjust_head() assures BPF cannot access xdp_frame area */
-	hard_start -= sizeof(struct xdp_frame);
-
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (likely(xdp_prog)) {
 		struct xdp_buff xdp;
 		u32 act;
 
-		xdp.data_hard_start = hard_start;
-		xdp.data = frame->data;
-		xdp.data_end = frame->data + frame->len;
-		xdp.data_meta = frame->data - frame->metasize;
-		xdp.frame_sz = frame->frame_sz;
+		convert_to_xdp_buff(frame, &xdp);
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -626,7 +618,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	rcu_read_unlock();
 
 	headroom = sizeof(struct xdp_frame) + frame->headroom - delta;
-	skb = veth_build_skb(hard_start, headroom, len, frame->frame_sz);
+	skb = veth_build_skb(frame, headroom, len, frame->frame_sz);
 	if (!skb) {
 		xdp_return_frame(frame);
 		stats->rx_drops++;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 90f11760bd12..5dbdd65866a9 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -106,6 +106,16 @@ void xdp_warn(const char *msg, const char *func, const int line);
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 
+static inline
+void convert_to_xdp_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
+{
+	xdp->data_hard_start = (void *)frame;
+	xdp->data = frame->data;
+	xdp->data_end = frame->data + frame->len;
+	xdp->data_meta = frame->data - frame->metasize;
+	xdp->frame_sz = frame->frame_sz;
+}
+
 /* Convert xdp_buff to xdp_frame */
 static inline
 struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
-- 
2.26.2

