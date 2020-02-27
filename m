Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A49170EF7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgB0DUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbgB0DUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:31 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94B52468C;
        Thu, 27 Feb 2020 03:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773630;
        bh=BRAcxaHdqLTu0GKE1Tp6sLy12I2VCkDQCH/d2A4T1OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWBE5P+YKf2k9rC6FRxSHqHvIpcFMi2CDtC6nMtqSgLcRfbj60/JdLwF6s7zEmaGM
         S+d9Mb8EIsvtfMYHIbNHcXP9ZpAJgTpTWrIqPKwf8rHRCtidJezCTBbhoD42UKmMy+
         uGqgQ5XCQXdlY2VE7jGfJO1NvHsswadrjm29LiRI=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path for xdp_frames
Date:   Wed, 26 Feb 2020 20:20:11 -0700
Message-Id: <20200227032013.12385-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add support to run Tx path program on packets arriving at a tun
device via XDP redirect.

XDP_TX return code means move the packet to the Tx path of the device.
For a program run in the Tx / egress path, XDP_TX is essentially the
same as "continue on" which is XDP_PASS.

Conceptually, XDP_REDIRECT for this path can work the same as it
does for the Rx path, but that return code is left for a follow
on series.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 drivers/net/tun.c | 49 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dcae6521a39d..d3fc7e921c85 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1359,10 +1359,50 @@ static void __tun_xdp_flush_tfile(struct tun_file *tfile)
 	tfile->socket.sk->sk_data_ready(tfile->socket.sk);
 }
 
+static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
+			 struct xdp_frame *frame, struct xdp_txq_info *txq)
+{
+	struct bpf_prog *xdp_prog;
+	u32 act = XDP_PASS;
+
+	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
+	if (xdp_prog) {
+		struct xdp_buff xdp;
+
+		xdp.data_hard_start = frame->data - frame->headroom;
+		xdp.data = frame->data;
+		xdp.data_end = xdp.data + frame->len;
+		xdp_set_data_meta_invalid(&xdp);
+		xdp.txq = txq;
+
+		act = bpf_prog_run_xdp(xdp_prog, &xdp);
+		switch (act) {
+		case XDP_TX:    /* for Tx path, XDP_TX == XDP_PASS */
+			act = XDP_PASS;
+			break;
+		case XDP_PASS:
+			break;
+		case XDP_REDIRECT:
+			/* fall through */
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			/* fall through */
+		case XDP_ABORTED:
+			trace_xdp_exception(tun->dev, xdp_prog, act);
+			/* fall through */
+		case XDP_DROP:
+			break;
+		}
+	}
+
+	return act;
+}
+
 static int tun_xdp_xmit(struct net_device *dev, int n,
 			struct xdp_frame **frames, u32 flags)
 {
 	struct tun_struct *tun = netdev_priv(dev);
+	struct xdp_txq_info txq = { .dev = dev };
 	struct tun_file *tfile;
 	u32 numqueues;
 	int drops = 0;
@@ -1389,12 +1429,17 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 	spin_lock(&tfile->tx_ring.producer_lock);
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdp = frames[i];
+		void *frame;
+
+		if (tun_do_xdp_tx(tun, tfile, xdp, &txq) != XDP_PASS)
+			goto drop;
+
 		/* Encode the XDP flag into lowest bit for consumer to differ
 		 * XDP buffer from sk_buff.
 		 */
-		void *frame = tun_xdp_to_ptr(xdp);
-
+		frame = tun_xdp_to_ptr(xdp);
 		if (__ptr_ring_produce(&tfile->tx_ring, frame)) {
+drop:
 			this_cpu_inc(tun->pcpu_stats->tx_dropped);
 			xdp_return_frame_rx_napi(xdp);
 			drops++;
-- 
2.21.1 (Apple Git-122.3)

