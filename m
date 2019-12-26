Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D99F12A9D4
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLZCd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:58 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43667 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZCd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id x6so11459446pfo.10
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dAlaZyCa1d1/7R6nqGa0pGAEkYvGJcj7IgrbAu+7dr8=;
        b=gufaUfgiV0Z1gcKUO1l9TyLB4v6HJzp/ygSEBSrb6XYwZ9cRhy+Ax1LB3VFI18ZSph
         Fujavtn7eU7dm7AKyTce1Y5JRKqJqiEnYKn8j+g22hMK3iwG7io8JDDYcWQAijF28l/Z
         A3g+cNhDctq5kopF7r/I8c53ZV58xbKk1DAStRwTcHKO2EsYpMbQCy6kY+P3AsRcOlua
         ymeeRSDG9sToIg6dBfX9ZXJGNROj3o3YnRwejewtO1y7I5Qsf6eW2Jev6AROxOhlb++I
         sbErClUTlNY8AZ5MqpH46GItmDq+00DnF7QMmNn55q+ed+uH1XYT5xNEIvwPs0gGY350
         z8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dAlaZyCa1d1/7R6nqGa0pGAEkYvGJcj7IgrbAu+7dr8=;
        b=kZQTil4HT9NrJHyv0UvYcHQAu0PCCXqSRcMk8u8pJkiDL05bn7vjdMSwoZofXnomGP
         R8C4+3f1nKeLRvNM1Tys9G4qkCL/8R0c5M7Vv8NvEMNOLwSluvni0+V7cN1hSDX9r2b2
         e/ZY0GnwecabLjoMb4CYHCuaeWMINLIcGPHWLyduk7anKc3l7XzvhoQ6ZlGIeh0M/zTs
         cCOUlSy6Z4Rat1TWBvfAjJlpoQEB+Yow+Yf4L+NFiHpA6ccWF76B7Vcp9OGZgKXCnCUE
         nnJhSofhPxM42WP5haAWEFlgjzsI2PKiVX7AvOx+DQrEcNG1fx+aIZiNvnOTUxiyg4Kq
         UjpA==
X-Gm-Message-State: APjAAAW245/PEBYDxDaEFbDX+Dm+NM5CtjdoxTrExxPm5YnY5NbL0mA/
        Qsgjh7jeniG+z6XnxCvuhEs=
X-Google-Smtp-Source: APXvYqwXQ1imthBUWGVXXdF0MNocUt6lKshlK36OlK9NfosNy1xRG4jBWfAjjgZep1DY3kgbzi+eCw==
X-Received: by 2002:a65:620d:: with SMTP id d13mr28117039pgv.252.1577327637741;
        Wed, 25 Dec 2019 18:33:57 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:57 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC v2 net-next 12/12] tun: run XDP program in tx path
Date:   Thu, 26 Dec 2019 11:32:00 +0900
Message-Id: <20191226023200.21389-13-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run the XDP program as soon as packet is removed from the ptr
ring. Since this is XDP in tx path, the traditional handling of
XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
just runs the program and leaves the action handling to us.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 149 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8aee7abd53a2..1afded9252f5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -131,6 +131,7 @@ struct tap_filter {
 /* MAX_TAP_QUEUES 256 is chosen to allow rx/tx queues to be equal
  * to max number of VCPUs in guest. */
 #define MAX_TAP_QUEUES 256
+#define MAX_TAP_BATCH 64
 #define MAX_TAP_FLOWS  4096
 
 #define TUN_FLOW_EXPIRE (3 * HZ)
@@ -2173,6 +2174,109 @@ static ssize_t tun_put_user(struct tun_struct *tun,
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
+	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
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
+	struct tun_page tpage;
+	struct xdp_buff xdp;
+	u32 act = XDP_PASS;
+	int flush = 0;
+
+	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
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
@@ -2590,6 +2694,47 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return ret;
 }
 
+static int tun_consume_packets(struct tun_file *tfile, void **ptr_array, int n)
+{
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
+	if (unlikely(!tun)) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	num_ptrs = ptr_ring_consume_batched(&tfile->tx_ring, pkts, n);
+	for (i = 0; i < num_ptrs; i++) {
+		ptr = pkts[i];
+		if (tun_is_xdp_frame(ptr)) {
+			frame = tun_ptr_to_xdp(ptr);
+			act = tun_do_xdp_tx(tun, tfile, frame);
+		} else {
+			act = tun_do_xdp_tx_generic(tun, ptr);
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
@@ -2610,9 +2755,7 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
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
2.21.0

