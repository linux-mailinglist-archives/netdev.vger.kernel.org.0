Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986F727B3D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 12:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbfEWK7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 06:59:02 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:48950 "EHLO
        tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWK7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 06:59:02 -0400
Received: from vc2.ecl.ntt.co.jp (vc2.ecl.ntt.co.jp [129.60.86.154])
        by tama50.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id x4NAwdNp024516;
        Thu, 23 May 2019 19:58:39 +0900
Received: from vc2.ecl.ntt.co.jp (localhost [127.0.0.1])
        by vc2.ecl.ntt.co.jp (Postfix) with ESMTP id 4D5D8639047;
        Thu, 23 May 2019 19:58:39 +0900 (JST)
Received: from jcms-pop21.ecl.ntt.co.jp (jcms-pop21.ecl.ntt.co.jp [129.60.87.134])
        by vc2.ecl.ntt.co.jp (Postfix) with ESMTP id 41CC7639042;
        Thu, 23 May 2019 19:58:39 +0900 (JST)
Received: from makita-ubuntu.m.ecl.ntt.co.jp (eb8460w-makita.sic.ecl.ntt.co.jp [129.60.241.47])
        by jcms-pop21.ecl.ntt.co.jp (Postfix) with ESMTPSA id 372EF4007AA;
        Thu, 23 May 2019 19:58:39 +0900 (JST)
From:   Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Subject: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
Date:   Thu, 23 May 2019 19:56:48 +0900
Message-Id: <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
X-CC-Mail-RelayStamp: 1
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This improves XDP_TX performance by about 8%.

Here are single core XDP_TX test results. CPU consumptions are taken
from "perf report --no-child".

- Before:

  7.26 Mpps

  _raw_spin_lock  7.83%
  veth_xdp_xmit  12.23%

- After:

  7.84 Mpps

  _raw_spin_lock  1.17%
  veth_xdp_xmit   6.45%

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
---
 drivers/net/veth.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 52110e5..4edc75f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	return ret;
 }
 
+static void veth_xdp_flush_bq(struct net_device *dev)
+{
+	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
+	int sent, i, err = 0;
+
+	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
+	if (sent < 0) {
+		err = sent;
+		sent = 0;
+		for (i = 0; i < bq->count; i++)
+			xdp_return_frame(bq->q[i]);
+	}
+	trace_xdp_bulk_tx(dev, sent, bq->count - sent, err);
+
+	bq->count = 0;
+}
+
 static void veth_xdp_flush(struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
@@ -449,6 +466,7 @@ static void veth_xdp_flush(struct net_device *dev)
 	struct veth_rq *rq;
 
 	rcu_read_lock();
+	veth_xdp_flush_bq(dev);
 	rcv = rcu_dereference(priv->peer);
 	if (unlikely(!rcv))
 		goto out;
@@ -466,12 +484,18 @@ static void veth_xdp_flush(struct net_device *dev)
 
 static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 {
+	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
 	struct xdp_frame *frame = convert_to_xdp_frame(xdp);
 
 	if (unlikely(!frame))
 		return -EOVERFLOW;
 
-	return veth_xdp_xmit(dev, 1, &frame, 0);
+	if (unlikely(bq->count == XDP_TX_BULK_SIZE))
+		veth_xdp_flush_bq(dev);
+
+	bq->q[bq->count++] = frame;
+
+	return 0;
 }
 
 static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
-- 
1.8.3.1


