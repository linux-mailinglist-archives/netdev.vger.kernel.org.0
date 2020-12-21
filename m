Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD712DFBE7
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 13:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgLUMgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 07:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgLUMgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 07:36:07 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B50C0613D6;
        Mon, 21 Dec 2020 04:35:27 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p18so6267591pgm.11;
        Mon, 21 Dec 2020 04:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f4kjwop6IbllVhWi4zNa62tgtBffcKbDbNsFSqWceRI=;
        b=WAe/DrzYyzCQkyjEvNURosHMXSb9Y5ZH4KhPf+acs/tR+lv7fuCJbxOIt/jSFvZvEq
         nrIraKPodQ8ZeTbCnS5QZlUCApCFi+os4eCqzRvurw+lwZHLejJz1DNZr+tHB5jSVDm/
         xFf6MIuE77ESpHM6mNwaXmbJKXhO57gF/HUlPxfGmiwyuSxRYjV9Q3KTF51Q12tclFS+
         9wEeVoF0HTrYNJDDIXYGuXtNspUk/amem6WwPGTftT3jiT34mruU4sGo6ZdrQSEiUwhx
         YIgFwXEG4Kf3PQNXHu1iU8vaf583u5R+AXrv0RBJ+5uOkKmugHfFDSMkXz6xXu1ByRnB
         Xopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f4kjwop6IbllVhWi4zNa62tgtBffcKbDbNsFSqWceRI=;
        b=IwFpfjDaJFIj9E3lW0c2xfQYPu4WLydjtyHVnEbEVgfkufue9lAgXxrpLcm1GFxrkK
         qDUebJxDo9GlMzOWyOC9EvBZlytWhbP4FWWi17Il8BsFX/sP4QMLU0JPXd1q0gIDBDyO
         5J2ud3Ine88bTl3D6vVyhojS8lJ/35MYEJijI+JJZRwdRswUiPfiyPSLbHFWtMtGY6K6
         64F4+dA4VxZknxWZDfyFeZ6qKeaAxG2xSBZvZcpcbrPN6vGl6w2tR+XtkkZGhxaOflSV
         dXwcCWaLiB6vGGt85EBUYGX97H6goRg7G0ovlNzzRCPsxNDNFJpLHNlxl7QHefHI8xg5
         WTXQ==
X-Gm-Message-State: AOAM533WaSCd8t13QiRKoqrqspn+ZLZj38O2boYhCbQHLWivBeWBiWlr
        sc9PYZ0Yp6wr22PpHvAtktToLeY9ClO69tYg
X-Google-Smtp-Source: ABdhPJyQLzmjMRdfR6EXCSsoD+7LuAhOKuecNFTu7xb+tUkuOYbtQn4HooKLXKDeQ4YMmP/Bo/REpw==
X-Received: by 2002:a63:643:: with SMTP id 64mr15058212pgg.422.1608554127016;
        Mon, 21 Dec 2020 04:35:27 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a26sm15382204pgd.64.2020.12.21.04.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 04:35:26 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv13 bpf-next 1/6] bpf: run devmap xdp_prog on flush instead of bulk enqueue
Date:   Mon, 21 Dec 2020 20:35:00 +0800
Message-Id: <20201221123505.1962185-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201221123505.1962185-1-liuhangbin@gmail.com>
References: <20201216143036.2296568-1-liuhangbin@gmail.com>
 <20201221123505.1962185-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

This changes the devmap XDP program support to run the program when the
bulk queue is flushed instead of before the frame is enqueued. This has
a couple of benefits:

- It "sorts" the packets by destination devmap entry, and then runs the
  same BPF program on all the packets in sequence. This ensures that we
  keep the XDP program and destination device properties hot in I-cache.

- It makes the multicast implementation simpler because it can just
  enqueue packets using bq_enqueue() without having to deal with the
  devmap program at all.

The drawback is that if the devmap program drops the packet, the enqueue
step is redundant. However, arguably this is mostly visible in a
micro-benchmark, and with more mixed traffic the I-cache benefit should
win out. The performance impact of just this patch is as follows:

Using xdp_redirect_map(with a 2nd xdp_prog patch[1]) in sample/bpf and send
pkts via pktgen cmd:
./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64

There are about +/- 0.1M deviation for native testing, the performance
improved for the base-case, but some drop back with xdp devmap prog attached.

Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9.1M |  8.0M
5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11.0M |  9.7M
5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9.5M |  7.5M
5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11.6M |  9.1M

[1] https://patchwork.ozlabs.org/project/netdev/patch/20201208120159.2278277-1-liuhangbin@gmail.com/

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v13: pass in xdp_prog through __xdp_enqueue()
v2-v12: no this patch
---
 kernel/bpf/devmap.c | 115 +++++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 43 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f6e9c68afdd4..84fe15950e44 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -57,6 +57,7 @@ struct xdp_dev_bulk_queue {
 	struct list_head flush_node;
 	struct net_device *dev;
 	struct net_device *dev_rx;
+	struct bpf_prog *xdp_prog;
 	unsigned int count;
 };
 
@@ -327,40 +328,92 @@ bool dev_map_can_have_prog(struct bpf_map *map)
 	return false;
 }
 
+static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
+				struct xdp_frame **frames, int n,
+				struct net_device *dev)
+{
+	struct xdp_txq_info txq = { .dev = dev };
+	struct xdp_buff xdp;
+	int i, nframes = 0;
+
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		u32 act;
+		int err;
+
+		xdp_convert_frame_to_buff(xdpf, &xdp);
+		xdp.txq = &txq;
+
+		act = bpf_prog_run_xdp(xdp_prog, &xdp);
+		switch (act) {
+		case XDP_PASS:
+			err = xdp_update_frame_from_buff(&xdp, xdpf);
+			if (unlikely(err < 0))
+				xdp_return_frame_rx_napi(xdpf);
+			else
+				frames[nframes++] = xdpf;
+			break;
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			fallthrough;
+		case XDP_ABORTED:
+			trace_xdp_exception(dev, xdp_prog, act);
+			fallthrough;
+		case XDP_DROP:
+			xdp_return_frame_rx_napi(xdpf);
+			break;
+		}
+	}
+	return n - nframes; /* dropped frames count */
+}
+
 static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
 	int sent = 0, drops = 0, err = 0;
+	unsigned int cnt = bq->count;
+	unsigned int xdp_drop;
 	int i;
 
-	if (unlikely(!bq->count))
+	if (unlikely(!cnt))
 		return;
 
-	for (i = 0; i < bq->count; i++) {
+	for (i = 0; i < cnt; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
 		prefetch(xdpf);
 	}
 
-	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
+	if (unlikely(bq->xdp_prog)) {
+		xdp_drop = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
+		cnt -= xdp_drop;
+		if (!cnt) {
+			sent = 0;
+			drops = xdp_drop;
+			goto out;
+		}
+	}
+
+	sent = dev->netdev_ops->ndo_xdp_xmit(dev, cnt, bq->q, flags);
 	if (sent < 0) {
 		err = sent;
 		sent = 0;
 		goto error;
 	}
-	drops = bq->count - sent;
+	drops = (cnt - sent) + xdp_drop;
 out:
 	bq->count = 0;
 
 	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
 	bq->dev_rx = NULL;
+	bq->xdp_prog = NULL;
 	__list_del_clearprev(&bq->flush_node);
 	return;
 error:
 	/* If ndo_xdp_xmit fails with an errno, no frames have been
 	 * xmit'ed and it's our responsibility to them free all.
 	 */
-	for (i = 0; i < bq->count; i++) {
+	for (i = 0; i < cnt; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
 		xdp_return_frame_rx_napi(xdpf);
@@ -408,7 +461,7 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
  * Thus, safe percpu variable access.
  */
 static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
-		       struct net_device *dev_rx)
+		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
@@ -423,6 +476,14 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	if (!bq->dev_rx)
 		bq->dev_rx = dev_rx;
 
+	/* Store (potential) xdp_prog that run before egress to dev as
+	 * part of bulk_queue.  This will be same xdp_prog for all
+	 * xdp_frame's in bulk_queue, because this per-CPU store must
+	 * be flushed from net_device drivers NAPI func end.
+	 */
+	if (!bq->xdp_prog)
+		bq->xdp_prog = xdp_prog;
+
 	bq->q[bq->count++] = xdpf;
 
 	if (!bq->flush_node.prev)
@@ -430,7 +491,8 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 }
 
 static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
-			       struct net_device *dev_rx)
+				struct net_device *dev_rx,
+				struct bpf_prog *xdp_prog)
 {
 	struct xdp_frame *xdpf;
 	int err;
@@ -446,42 +508,14 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
-	bq_enqueue(dev, xdpf, dev_rx);
+	bq_enqueue(dev, xdpf, dev_rx, xdp_prog);
 	return 0;
 }
 
-static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
-					 struct xdp_buff *xdp,
-					 struct bpf_prog *xdp_prog)
-{
-	struct xdp_txq_info txq = { .dev = dev };
-	u32 act;
-
-	xdp_set_data_meta_invalid(xdp);
-	xdp->txq = &txq;
-
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
-	switch (act) {
-	case XDP_PASS:
-		return xdp;
-	case XDP_DROP:
-		break;
-	default:
-		bpf_warn_invalid_xdp_action(act);
-		fallthrough;
-	case XDP_ABORTED:
-		trace_xdp_exception(dev, xdp_prog, act);
-		break;
-	}
-
-	xdp_return_buff(xdp);
-	return NULL;
-}
-
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx)
 {
-	return __xdp_enqueue(dev, xdp, dev_rx);
+	return __xdp_enqueue(dev, xdp, dev_rx, NULL);
 }
 
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
@@ -489,12 +523,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 {
 	struct net_device *dev = dst->dev;
 
-	if (dst->xdp_prog) {
-		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
-		if (!xdp)
-			return 0;
-	}
-	return __xdp_enqueue(dev, xdp, dev_rx);
+	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
 }
 
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
-- 
2.26.2

