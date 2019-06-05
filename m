Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8788235645
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 07:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFEFgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 01:36:53 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42164 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfFEFgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 01:36:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id go2so9264319plb.9;
        Tue, 04 Jun 2019 22:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jX5BJvQUurxukycMtLItq+NU98sEO94qqN9cwopDYrI=;
        b=mPaOiHyqqsmV0v7MBNEJMXYYyz7vAIU7W2Zs6utC6ZxTlWKWs9KooIntXW+Ny+zEuL
         JSSVqzWXvLhOi8/+FoefWjrSa6Ag5Q0o4fM6r2GNBnlsTxLTtRRCbcX/lubJleJMk6MK
         OpHtFGiZ3wazZxItVDzJjvvm6Jn1sSCf8zod+T0v885VWE99OsIu35jNB9zZh8BRdquR
         sQBDHOanwIEovo5/dp+LbNSWSnzntd1iY382hzLsEz/qX/Z+Kp66s21XoTbMaM6aCqui
         IvonpWyDuRF8rq0Ruv7O6c7byIyjhpzIb6nhfY28xuXe2t32hcJJR5bKMYMY7GsRE5E9
         6x8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jX5BJvQUurxukycMtLItq+NU98sEO94qqN9cwopDYrI=;
        b=WENmbReSwFVlOvMSvfRIQakGjdJ0OZUYgXjrBK+1pEE9+fJIEt1aNxg00A3lJxwxOg
         zl1V/xhiuboa1c6OTRqKshExS+Xo0RTZLyJE+1lnaAA2aWZvywWqV4EfoCVDvaBD/7My
         DURN6ifxZrvkH/eaB6p5ZU7pbgyC0QHwcNTLmJmuDpaAhpQ/GQAMLYXs7MUATc3rqksU
         7FRtE0DhhczcHoiZKQNU2kUmkdVCoeVgFqWTJTazkRAG1vMcyGB8t9t3EG+CmurI0MsE
         UtW12Rh4UB0Gr/nl4Z3UWXXLRPIRlye4nRzH7tFiHyFwFP0y0U6znJvyz5vzJAXOtjF0
         65jA==
X-Gm-Message-State: APjAAAXBSV3FqQNm1e+PHbkQ+CHX1Otm6NvgMLR88/aDiEVJAobuLLm6
        9guWh4VN/xmCxJTNyj52xAU=
X-Google-Smtp-Source: APXvYqysssTuXcHMEqfpspOWutdRsgs1r/8YvW1p5riWnqPgwe2Z9KPqhtSB/nyZQz2wnrL4HEMfmg==
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr41582807plp.241.1559713011780;
        Tue, 04 Jun 2019 22:36:51 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id j15sm22745816pfn.187.2019.06.04.22.36.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 22:36:51 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 bpf-next 2/2] veth: Support bulk XDP_TX
Date:   Wed,  5 Jun 2019 14:36:13 +0900
Message-Id: <20190605053613.22888-3-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP_TX is similar to XDP_REDIRECT as it essentially redirects packets to
the device itself. XDP_REDIRECT has bulk transmit mechanism to avoid the
heavy cost of indirect call but it also reduces lock acquisition on the
destination device that needs locks like veth and tun.

XDP_TX does not use indirect calls but drivers which require locks can
benefit from the bulk transmit for XDP_TX as well.

This patch introduces bulk transmit mechanism in veth using bulk queue
on stack, and improves XDP_TX performance by about 9%.

Here are single-core/single-flow XDP_TX test results. CPU consumptions
are taken from "perf report --no-child".

- Before:

  7.26 Mpps

  _raw_spin_lock  7.83%
  veth_xdp_xmit  12.23%

- After:

  7.94 Mpps

  _raw_spin_lock  1.08%
  veth_xdp_xmit   6.10%

v2:
- Use stack for bulk queue instead of a global variable.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 drivers/net/veth.c | 60 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 52110e5..b363a84 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -38,6 +38,8 @@
 #define VETH_XDP_TX		BIT(0)
 #define VETH_XDP_REDIR		BIT(1)
 
+#define VETH_XDP_TX_BULK_SIZE	16
+
 struct veth_rq_stats {
 	u64			xdp_packets;
 	u64			xdp_bytes;
@@ -64,6 +66,11 @@ struct veth_priv {
 	unsigned int		requested_headroom;
 };
 
+struct veth_xdp_tx_bq {
+	struct xdp_frame *q[VETH_XDP_TX_BULK_SIZE];
+	unsigned int count;
+};
+
 /*
  * ethtool interface
  */
@@ -442,13 +449,30 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	return ret;
 }
 
-static void veth_xdp_flush(struct net_device *dev)
+static void veth_xdp_flush_bq(struct net_device *dev, struct veth_xdp_tx_bq *bq)
+{
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
+static void veth_xdp_flush(struct net_device *dev, struct veth_xdp_tx_bq *bq)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
 	struct net_device *rcv;
 	struct veth_rq *rq;
 
 	rcu_read_lock();
+	veth_xdp_flush_bq(dev, bq);
 	rcv = rcu_dereference(priv->peer);
 	if (unlikely(!rcv))
 		goto out;
@@ -464,19 +488,26 @@ static void veth_xdp_flush(struct net_device *dev)
 	rcu_read_unlock();
 }
 
-static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
+static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp,
+		       struct veth_xdp_tx_bq *bq)
 {
 	struct xdp_frame *frame = convert_to_xdp_frame(xdp);
 
 	if (unlikely(!frame))
 		return -EOVERFLOW;
 
-	return veth_xdp_xmit(dev, 1, &frame, 0);
+	if (unlikely(bq->count == VETH_XDP_TX_BULK_SIZE))
+		veth_xdp_flush_bq(dev, bq);
+
+	bq->q[bq->count++] = frame;
+
+	return 0;
 }
 
 static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 					struct xdp_frame *frame,
-					unsigned int *xdp_xmit)
+					unsigned int *xdp_xmit,
+					struct veth_xdp_tx_bq *bq)
 {
 	void *hard_start = frame->data - frame->headroom;
 	void *head = hard_start - sizeof(struct xdp_frame);
@@ -509,7 +540,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			orig_frame = *frame;
 			xdp.data_hard_start = head;
 			xdp.rxq->mem = frame->mem;
-			if (unlikely(veth_xdp_tx(rq->dev, &xdp) < 0)) {
+			if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
 				frame = &orig_frame;
 				goto err_xdp;
@@ -559,7 +590,8 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 }
 
 static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
-					unsigned int *xdp_xmit)
+					unsigned int *xdp_xmit,
+					struct veth_xdp_tx_bq *bq)
 {
 	u32 pktlen, headroom, act, metalen;
 	void *orig_data, *orig_data_end;
@@ -635,7 +667,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 		get_page(virt_to_page(xdp.data));
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
-		if (unlikely(veth_xdp_tx(rq->dev, &xdp) < 0)) {
+		if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
 			trace_xdp_exception(rq->dev, xdp_prog, act);
 			goto err_xdp;
 		}
@@ -690,7 +722,8 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 	return NULL;
 }
 
-static int veth_xdp_rcv(struct veth_rq *rq, int budget, unsigned int *xdp_xmit)
+static int veth_xdp_rcv(struct veth_rq *rq, int budget, unsigned int *xdp_xmit,
+			struct veth_xdp_tx_bq *bq)
 {
 	int i, done = 0, drops = 0, bytes = 0;
 
@@ -706,11 +739,11 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget, unsigned int *xdp_xmit)
 			struct xdp_frame *frame = veth_ptr_to_xdp(ptr);
 
 			bytes += frame->len;
-			skb = veth_xdp_rcv_one(rq, frame, &xdp_xmit_one);
+			skb = veth_xdp_rcv_one(rq, frame, &xdp_xmit_one, bq);
 		} else {
 			skb = ptr;
 			bytes += skb->len;
-			skb = veth_xdp_rcv_skb(rq, skb, &xdp_xmit_one);
+			skb = veth_xdp_rcv_skb(rq, skb, &xdp_xmit_one, bq);
 		}
 		*xdp_xmit |= xdp_xmit_one;
 
@@ -736,10 +769,13 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	struct veth_rq *rq =
 		container_of(napi, struct veth_rq, xdp_napi);
 	unsigned int xdp_xmit = 0;
+	struct veth_xdp_tx_bq bq;
 	int done;
 
+	bq.count = 0;
+
 	xdp_set_return_frame_no_direct();
-	done = veth_xdp_rcv(rq, budget, &xdp_xmit);
+	done = veth_xdp_rcv(rq, budget, &xdp_xmit, &bq);
 
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
@@ -751,7 +787,7 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	}
 
 	if (xdp_xmit & VETH_XDP_TX)
-		veth_xdp_flush(rq->dev);
+		veth_xdp_flush(rq->dev, &bq);
 	if (xdp_xmit & VETH_XDP_REDIR)
 		xdp_do_flush_map();
 	xdp_clear_return_frame_no_direct();
-- 
1.8.3.1

