Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78715170EF8
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgB0DUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgB0DUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:30 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 918CC24689;
        Thu, 27 Feb 2020 03:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773629;
        bh=FdWcrLPr2yzbk1x2CJSs9kf+dvzwzChvIylhXWwj6BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfjprqdo3a3Q1+GT7q2Fw7dWND5mk6ZsXlUTFzLPXtK2c74SHAT3WmecPParv4MXc
         Hjn9M/gECkwDC/DqlryxH5BwIVFJzQCR9r65lTnfUXHZzNh5vbwD/Gwmu3Nat61ZVR
         uQKOBunxGkKIvjff48Vu88h6lEB+vv/JOM+O9cyI=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 08/11] tun: Support xdp in the Tx path for skb
Date:   Wed, 26 Feb 2020 20:20:10 -0700
Message-Id: <20200227032013.12385-9-dsahern@kernel.org>
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
device as an skb.

XDP_TX return code means move the packet to the Tx path of the device.
For a program run in the Tx / egress path, XDP_TX is essentially the
same as "continue on" which is XDP_PASS.

Conceptually, XDP_REDIRECT for this path can work the same as it
does for the Rx path, but that return code is left for a follow
on series.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 drivers/net/tun.c | 69 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6aae398b904b..dcae6521a39d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1059,6 +1059,63 @@ static unsigned int run_ebpf_filter(struct tun_struct *tun,
 	return len;
 }
 
+static struct sk_buff *tun_prepare_xdp_skb(struct sk_buff *skb)
+{
+	if (skb_shared(skb) || skb_cloned(skb)) {
+		struct sk_buff *nskb;
+
+		nskb = skb_copy(skb, GFP_ATOMIC);
+		consume_skb(skb);
+		return nskb;
+	}
+
+	return skb;
+}
+
+static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
+				 struct net_device *dev,
+				 struct sk_buff *skb)
+{
+	struct bpf_prog *xdp_prog;
+	u32 act = XDP_PASS;
+
+	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
+	if (xdp_prog) {
+		struct xdp_txq_info txq = { .dev = dev };
+		struct xdp_buff xdp;
+
+		skb = tun_prepare_xdp_skb(skb);
+		if (!skb) {
+			act = XDP_DROP;
+			goto out;
+		}
+
+		xdp.txq = &txq;
+
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
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
+out:
+	return act;
+}
+
 /* Net device start xmit */
 static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -1066,6 +1123,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	int txq = skb->queue_mapping;
 	struct tun_file *tfile;
 	int len = skb->len;
+	u32 act;
 
 	rcu_read_lock();
 	tfile = rcu_dereference(tun->tfiles[txq]);
@@ -1107,9 +1165,13 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb))
+	act = tun_do_xdp_tx_generic(tun, dev, skb);
+	if (act != XDP_PASS)
 		goto drop;
 
+	if (ptr_ring_produce(&tfile->tx_ring, skb))
+		goto err_out;
+
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
@@ -1118,10 +1180,11 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	rcu_read_unlock();
 	return NETDEV_TX_OK;
 
-drop:
-	this_cpu_inc(tun->pcpu_stats->tx_dropped);
+err_out:
 	skb_tx_error(skb);
 	kfree_skb(skb);
+drop:
+	this_cpu_inc(tun->pcpu_stats->tx_dropped);
 	rcu_read_unlock();
 	return NET_XMIT_DROP;
 }
-- 
2.21.1 (Apple Git-122.3)

