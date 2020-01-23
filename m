Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727DA146084
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAWBmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729028AbgAWBm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:28 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D811724692;
        Thu, 23 Jan 2020 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743746;
        bh=sm3tMod1fApP+g+Kg7bYgttxScTKBJlMjSBJEZ4peJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuJV6GBxJyNwVqN9yTfZvVSV2sdHQAsMIEwWly5+6PBQnTrIPrW6BaIjnWYvlKJ7g
         0kUFZWpq4xEPdTUNhHy+cvLBto2EjE7mpOKDYruzSGtdktThFFlSFVGOt9CUuVtsSz
         +a/5edT5B1Jj/R3Moq7tn2+elDrDOMp4E2wIyz3U=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH bpf-next 10/12] tun: run XDP program in tx path
Date:   Wed, 22 Jan 2020 18:42:08 -0700
Message-Id: <20200123014210.38412-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

Run the XDP program as soon as packet is removed from the ptr
ring. Since this is XDP in tx path, the traditional handling of
XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
just runs the program and leaves the action handling to us.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 153 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 150 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index b6bac773f2a0..71bcd4ec2571 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -130,6 +130,7 @@ struct tap_filter {
 /* MAX_TAP_QUEUES 256 is chosen to allow rx/tx queues to be equal
  * to max number of VCPUs in guest. */
 #define MAX_TAP_QUEUES 256
+#define MAX_TAP_BATCH 64
 #define MAX_TAP_FLOWS  4096
 
 #define TUN_FLOW_EXPIRE (3 * HZ)
@@ -175,6 +176,7 @@ struct tun_file {
 	struct tun_struct *detached;
 	struct ptr_ring tx_ring;
 	struct xdp_rxq_info xdp_rxq;
+	void *pkt_ptrs[MAX_TAP_BATCH];
 };
 
 struct tun_page {
@@ -2140,6 +2142,107 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	return total;
 }
 
+static struct sk_buff *tun_prepare_xdp_skb(struct sk_buff *skb)
+{
+	struct sk_buff *nskb;
+
+	if (skb_shared(skb) || skb_cloned(skb)) {
+		nskb = skb_copy(skb, GFP_ATOMIC);
+		consume_skb(skb);
+		return nskb;
+	}
+
+	return skb;
+}
+
+static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
+				 struct sk_buff *skb)
+{
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 act = XDP_PASS;
+
+	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
+	if (xdp_prog) {
+		skb = tun_prepare_xdp_skb(skb);
+		if (!skb) {
+			act = XDP_DROP;
+			kfree_skb(skb);
+			goto drop;
+		}
+
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
+		switch (act) {
+		case XDP_TX:
+			/* Rx path generic XDP will be called in this path
+			 */
+			local_bh_disable();
+			netif_receive_skb(skb);
+			local_bh_enable();
+			break;
+		case XDP_PASS:
+			break;
+		case XDP_REDIRECT:
+			/* Since we are not handling this case yet, let's free
+			 * skb here. In case of XDP_DROP/XDP_ABORTED, the skb
+			 * was already freed in do_xdp_generic_core()
+			 */
+			kfree_skb(skb);
+			/* fall through */
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			/* fall through */
+		case XDP_ABORTED:
+			trace_xdp_exception(tun->dev, xdp_prog, act);
+			/* fall through */
+		case XDP_DROP:
+			goto drop;
+		}
+	}
+
+	return act;
+drop:
+	this_cpu_inc(tun->pcpu_stats->tx_dropped);
+	return act;
+}
+
+static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
+			 struct xdp_frame *frame)
+{
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 act = XDP_PASS;
+
+	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
+	if (xdp_prog) {
+		xdp.data_hard_start = frame->data - frame->headroom;
+		xdp.data = frame->data;
+		xdp.data_end = xdp.data + frame->len;
+		xdp.data_meta = xdp.data - frame->metasize;
+
+		act = bpf_prog_run_xdp(xdp_prog, &xdp);
+		switch (act) {
+		case XDP_PASS:
+			break;
+		case XDP_TX:
+			/* fall through */
+		case XDP_REDIRECT:
+			/* fall through */
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			/* fall through */
+		case XDP_ABORTED:
+			trace_xdp_exception(tun->dev, xdp_prog, act);
+			/* fall through */
+		case XDP_DROP:
+			xdp_return_frame_rx_napi(frame);
+			break;
+		}
+	}
+
+	return act;
+}
+
 static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -2557,6 +2660,52 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return ret;
 }
 
+static int tun_consume_packets(struct tun_file *tfile, void **ptr_array, int n)
+{
+	void **pkts = tfile->pkt_ptrs;
+	struct xdp_frame *frame;
+	struct tun_struct *tun;
+	int i, num_ptrs;
+	int pkt_cnt = 0;
+	void *ptr;
+	u32 act;
+	int batchsz;
+
+	if (unlikely(!tfile))
+		return 0;
+
+	rcu_read_lock();
+	tun = rcu_dereference(tfile->tun);
+	if (unlikely(!tun)) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	while (n) {
+		batchsz = (n > MAX_TAP_BATCH) ? MAX_TAP_BATCH : n;
+		n -= batchsz;
+		num_ptrs = ptr_ring_consume_batched(&tfile->tx_ring, pkts,
+						    batchsz);
+		if (!num_ptrs)
+			break;
+		for (i = 0; i < num_ptrs; i++) {
+			ptr = pkts[i];
+			if (tun_is_xdp_frame(ptr)) {
+				frame = tun_ptr_to_xdp(ptr);
+				act = tun_do_xdp_tx(tun, tfile, frame);
+			} else {
+				act = tun_do_xdp_tx_generic(tun, ptr);
+			}
+
+			if (act == XDP_PASS)
+				ptr_array[pkt_cnt++] = ptr;
+		}
+	}
+
+	rcu_read_unlock();
+	return pkt_cnt;
+}
+
 static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
 		       int flags)
 {
@@ -2577,9 +2726,7 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
 			ptr = ctl->ptr;
 			break;
 		case TUN_MSG_CONSUME_PKTS:
-			ret = ptr_ring_consume_batched(&tfile->tx_ring,
-						       ctl->ptr,
-						       ctl->num);
+			ret = tun_consume_packets(tfile, ctl->ptr, ctl->num);
 			goto out;
 		case TUN_MSG_UNCONSUME_PKTS:
 			ptr_ring_unconsume(&tfile->tx_ring, ctl->ptr,
-- 
2.21.1 (Apple Git-122.3)

