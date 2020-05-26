Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A921D047C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgEMBqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732066AbgEMBqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:46:17 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 371122492D;
        Wed, 13 May 2020 01:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589334377;
        bh=qIGnmqx/IfZtLlSpPlOo4jKzm4xSYh6U82yhLyybz/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqylJf96jgDM54ECOZXhXF0nxdK6gtGvkkMwaB0z0zgxjQ60PK9SFVgIosvWIaEvw
         cfzS5jrHh0s8eP9c1FQ1P6WFDDeYWePWjE/mmS6mEyAipet5T9LR+Sp2QGbh1FBD9u
         Zc8kcDlcQkBPwQwqpUtNduR1MdZxhLnFDyS+NBoU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v5 bpf-next 07/11] net: Support xdp in the Tx path for xdp_frames
Date:   Tue, 12 May 2020 19:46:03 -0600
Message-Id: <20200513014607.40418-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200513014607.40418-1-dsahern@kernel.org>
References: <20200513014607.40418-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add support to run Tx path program on xdp_frames by adding a hook to
bq_xmit_all before xdp_frames are passed to ndo_xdp_xmit for the device.

If an xdp_frame is dropped by the program, it is removed from the
xdp_frames array with subsequent entries moved up.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/linux/netdevice.h |  2 ++
 kernel/bpf/devmap.c       | 19 +++++++---
 net/core/dev.c            | 74 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 651baeb36729..042190df23d5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3717,6 +3717,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+unsigned int do_xdp_egress(struct net_device *dev, struct xdp_frame **frames,
+			   unsigned int count);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a51d9fb7a359..513dec5f67b9 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -321,24 +321,33 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
 	int sent = 0, drops = 0, err = 0;
+	unsigned int count = bq->count;
 	int i;
 
-	if (unlikely(!bq->count))
+	if (unlikely(!count))
 		return 0;
 
-	for (i = 0; i < bq->count; i++) {
+	for (i = 0; i < count; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
 		prefetch(xdpf);
 	}
 
-	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
+	if (static_branch_unlikely(&xdp_egress_needed_key)) {
+		count = do_xdp_egress(dev, bq->q, count);
+		drops += bq->count - count;
+		/* all frames consumed by the xdp program? */
+		if (!count)
+			goto out;
+	}
+
+	sent = dev->netdev_ops->ndo_xdp_xmit(dev, count, bq->q, flags);
 	if (sent < 0) {
 		err = sent;
 		sent = 0;
 		goto error;
 	}
-	drops = bq->count - sent;
+	drops += count - sent;
 out:
 	bq->count = 0;
 
@@ -350,7 +359,7 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 	/* If ndo_xdp_xmit fails with an errno, no frames have been
 	 * xmit'ed and it's our responsibility to them free all.
 	 */
-	for (i = 0; i < bq->count; i++) {
+	for (i = 0; i < count; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
 		xdp_return_frame_rx_napi(xdpf);
diff --git a/net/core/dev.c b/net/core/dev.c
index 97954f835ceb..e6a737b84768 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4673,6 +4673,80 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(do_xdp_generic);
 
+static u32 __xdp_egress_frame(struct net_device *dev,
+			      struct bpf_prog *xdp_prog,
+			      struct xdp_frame *xdp_frame,
+			      struct xdp_txq_info *txq)
+{
+	struct xdp_buff xdp;
+	u32 act;
+
+	xdp.data_hard_start = xdp_frame->data - xdp_frame->headroom
+			      - sizeof(*xdp_frame);
+	xdp.data = xdp_frame->data;
+	xdp.data_end = xdp.data + xdp_frame->len;
+	xdp.data_meta = xdp.data - xdp_frame->metasize;
+	xdp.txq = txq;
+
+	act = bpf_prog_run_xdp(xdp_prog, &xdp);
+	switch (act) {
+	case XDP_DROP:
+		fallthrough;
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		fallthrough;
+	case XDP_REDIRECT:
+		fallthrough;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(dev, xdp_prog, act);
+		act = XDP_DROP;
+		break;
+	}
+
+	/* if not dropping frame, readjust pointers in case
+	 * program made changes to the buffer
+	 */
+	if (act != XDP_DROP) {
+		if (unlikely(!update_xdp_frame(&xdp, xdp_frame)))
+			return XDP_DROP;
+	}
+
+	return act;
+}
+
+unsigned int do_xdp_egress(struct net_device *dev, struct xdp_frame **frames,
+			   unsigned int count)
+{
+	struct bpf_prog *xdp_prog;
+
+	xdp_prog = rcu_dereference(dev->xdp_egress_prog);
+	if (xdp_prog) {
+		struct xdp_txq_info txq = { .dev = dev };
+		unsigned int i, j;
+		u32 act;
+
+		for (i = 0, j = 0; i < count; i++) {
+			struct xdp_frame *frame = frames[i];
+
+			act = __xdp_egress_frame(dev, xdp_prog, frame, &txq);
+			if (act == XDP_DROP) {
+				xdp_return_frame_rx_napi(frame);
+				continue;
+			}
+
+			frames[j] = frame;
+			j++;
+		}
+		count = j;
+	}
+
+	return count;
+}
+
 static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
-- 
2.21.1 (Apple Git-122.3)

