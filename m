Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D2D109BD0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfKZKJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:14 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37051 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfKZKJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:13 -0500
Received: by mail-pg1-f196.google.com with SMTP id b10so8756108pgd.4;
        Tue, 26 Nov 2019 02:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B6QMMXb6Lc0tWH98wR58tzl2/7IOcJXsAUoOf1rCNto=;
        b=TcQUjhhkWtAHHBo7BGhoPxdH+OkQBuhIxzcHX5EgouRjPkgbXzarm0y1vo1NhR8gDf
         eG2Lo7ddCpKcjSeJMFMlcP8tJQ/55Jt0TGNgznW4/XjmDldCe92mvnBxFGEghuAeWujG
         7zNia4tH4IGRLOy70KvJXM+j82tbJ8nUIicPouLS6TjkV6HD27P/W/h6R5O7MmSu2k+V
         143iMJdLR6+6bv9luW2P50ryb4MAyiIUafw49CErl7oj+EMEJ7fXiv42whVv9WX7vO8P
         re3ksZIi50XxOCmuXJZr+0KLAm6i5NuOZT8Bux4mTYLARNU4OGVu3EBoIPihOhj+s8jc
         e7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B6QMMXb6Lc0tWH98wR58tzl2/7IOcJXsAUoOf1rCNto=;
        b=V8nrArMfNn9l63g2ccOY/4Y/ynfagcMRUL4IYpvkBHFEG5wgUWs0uJWX6DGNIqgEa7
         61TsaQi3utWaD4pqwHJFAnar0zobwLYA+Gv+9UZJDy/zksTL1tDa7Qvy1k64CVYyC0kN
         bnPhFyDPmsfGT9Wx02bRDsnxtxx83WhwlmGp2RjPtLxfdJ+Ko63a3DYGdGk/t/+g5DvE
         ijUnkgQ2kbY4AxL/Fw+SXgOAl63Ffv6CLiK2WagArcXZuN3izPPCCt5VeR37UWvmRjCo
         iGM72w7xPq0WOKiR+7xdQS6Dqu/H1PsUhwbVtefetTid72itYwS/FIawBAXKEtNGo5QE
         sK6w==
X-Gm-Message-State: APjAAAXRZjHKEs66usO4UK+Juo3xnc27mB4tspUwMhI4IXnN5E1zeDT/
        0I8M3ihaWHZWnb0Dk5l0YZc=
X-Google-Smtp-Source: APXvYqzpyS68KcI5oBdWBrSJfaGRRiRmODA4vA4zTy1YjkKqKqQWp2z/hxWs5tczO+UmDNsD9QUaSw==
X-Received: by 2002:a63:d14d:: with SMTP id c13mr18566161pgj.227.1574762953032;
        Tue, 26 Nov 2019 02:09:13 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:12 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
Date:   Tue, 26 Nov 2019 19:07:34 +0900
Message-Id: <20191126100744.5083-9-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

run offloaded XDP program as soon as packet is removed from the ptr
ring. Since this is XDP in Tx path, the traditional handling of
XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
just runs the program and leaves the action handling to us.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 149 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ecb49101b0b5..466ea69f00ee 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -131,6 +131,7 @@ struct tap_filter {
 /* MAX_TAP_QUEUES 256 is chosen to allow rx/tx queues to be equal
  * to max number of VCPUs in guest. */
 #define MAX_TAP_QUEUES 256
+#define MAX_TAP_BATCH 64
 #define MAX_TAP_FLOWS  4096
 
 #define TUN_FLOW_EXPIRE (3 * HZ)
@@ -2156,6 +2157,109 @@ static ssize_t tun_put_user(struct tun_struct *tun,
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
+static u32 tun_do_xdp_offload_generic(struct tun_struct *tun,
+				      struct sk_buff *skb)
+{
+	struct tun_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 act = XDP_PASS;
+
+	xdp_prog = rcu_dereference(tun->offloaded_xdp_prog);
+	if (xdp_prog) {
+		skb = tun_prepare_xdp_skb(skb);
+		if (!skb) {
+			act = XDP_DROP;
+			kfree_skb(skb);
+			goto drop;
+		}
+
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog->prog);
+		switch (act) {
+		case XDP_TX:
+			/*
+			 * Rx path generic XDP will be called in this path
+			 */
+			netif_receive_skb(skb);
+			break;
+		case XDP_PASS:
+			break;
+		case XDP_REDIRECT:
+			/*
+			 * Since we are not handling this case yet, let's free
+			 * skb here. In case of XDP_DROP/XDP_ABORTED, the skb
+			 * was already freed in do_xdp_generic_core()
+			 */
+			kfree_skb(skb);
+			/* fall through */
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			/* fall through */
+		case XDP_ABORTED:
+			trace_xdp_exception(tun->dev, xdp_prog->prog, act);
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
+static u32 tun_do_xdp_offload(struct tun_struct *tun, struct tun_file *tfile,
+			      struct xdp_frame *frame)
+{
+	struct tun_prog *xdp_prog;
+	struct tun_page tpage;
+	struct xdp_buff xdp;
+	u32 act = XDP_PASS;
+	int flush = 0;
+
+	xdp_prog = rcu_dereference(tun->offloaded_xdp_prog);
+	if (xdp_prog) {
+		xdp.data_hard_start = frame->data - frame->headroom;
+		xdp.data = frame->data;
+		xdp.data_end = xdp.data + frame->len;
+		xdp.data_meta = xdp.data - frame->metasize;
+
+		act = bpf_prog_run_xdp(xdp_prog->prog, &xdp);
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
+			trace_xdp_exception(tun->dev, xdp_prog->prog, act);
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
@@ -2574,6 +2678,47 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return ret;
 }
 
+static int tun_consume_packets(struct tun_file *tfile, void **ptr_array, int n)
+{
+	struct tun_prog *xdp_prog;
+	struct xdp_frame *frame;
+	struct tun_struct *tun;
+	int i, num_ptrs;
+	int pkt_cnt = 0;
+	void *pkts[MAX_TAP_BATCH];
+	void *ptr;
+	u32 act;
+
+	if (unlikely(!tfile))
+		return 0;
+
+	if (n > MAX_TAP_BATCH)
+		n = MAX_TAP_BATCH;
+
+	rcu_read_lock();
+	tun = rcu_dereference(tfile->tun);
+	if (unlikely(!tun))
+		return 0;
+	xdp_prog = rcu_dereference(tun->offloaded_xdp_prog);
+
+	num_ptrs = ptr_ring_consume_batched(&tfile->tx_ring, pkts, n);
+	for (i = 0; i < num_ptrs; i++) {
+		ptr = pkts[i];
+		if (tun_is_xdp_frame(ptr)) {
+			frame = tun_ptr_to_xdp(ptr);
+			act = tun_do_xdp_offload(tun, tfile, frame);
+		} else {
+			act = tun_do_xdp_offload_generic(tun, ptr);
+		}
+
+		if (act == XDP_PASS)
+			ptr_array[pkt_cnt++] = ptr;
+	}
+
+	rcu_read_unlock();
+	return pkt_cnt;
+}
+
 static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
 		       int flags)
 {
@@ -2594,9 +2739,7 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
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
2.20.1

