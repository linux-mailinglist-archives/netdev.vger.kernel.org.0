Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF802E0340
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgLVAKW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgLVAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM09d31014052
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:39 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0dv1t00-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:39 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:28 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 2C38E5BD9C34; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 07/12 v2 RFC] skbuff: Add skb parameter to the ubuf zerocopy callback
Date:   Mon, 21 Dec 2020 16:09:21 -0800
Message-ID: <20201222000926.1054993-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_13:2020-12-21,2020-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1034 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=763 phishscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210164
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Add an optional skb parameter to the zerocopy callback parameter,
which is passed down from skb_zcopy_clear().  This gives access
to the original skb, which is needed for upcoming RX zero-copy
error handling.

Make the name of the the zerocopy success pararmeter consistent
for all callbacks.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/tap.c                 |  2 +-
 drivers/net/tun.c                 |  2 +-
 drivers/net/xen-netback/common.h  |  3 ++-
 drivers/net/xen-netback/netback.c |  7 ++++---
 drivers/vhost/net.c               |  3 ++-
 include/linux/skbuff.h            | 20 +++++++++-----------
 net/core/skbuff.c                 |  3 ++-
 7 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 3e9fb753ce88..c2bcbf9218dc 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -726,7 +726,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
-		uarg->callback(uarg, false);
+		uarg->callback(NULL, uarg, false);
 	}
 
 	if (tap) {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 80cb3bef3afd..bad4b0229584 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1818,7 +1818,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
-		uarg->callback(uarg, false);
+		uarg->callback(NULL, uarg, false);
 	}
 
 	skb_reset_network_header(skb);
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 8ee24e351bdc..4df001e960ca 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -399,7 +399,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 void xenvif_carrier_on(struct xenvif *vif);
 
 /* Callback from stack when TX packet can be released */
-void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success);
+void xenvif_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *ubuf,
+			      bool success);
 
 /* Unmap a pending page and release it back to the guest */
 void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index bc3421d14576..49288ae2c4dd 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1091,7 +1091,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 	uarg = skb_shinfo(skb)->destructor_arg;
 	/* increase inflight counter to offset decrement in callback */
 	atomic_inc(&queue->inflight_packets);
-	uarg->callback(uarg, true);
+	uarg->callback(NULL, uarg, true);
 	skb_shinfo(skb)->destructor_arg = NULL;
 
 	/* Fill the skb with the new (local) frags. */
@@ -1228,7 +1228,8 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 	return work_done;
 }
 
-void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success)
+void xenvif_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *ubuf,
+			      bool success)
 {
 	unsigned long flags;
 	pending_ring_idx_t index;
@@ -1253,7 +1254,7 @@ void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success)
 	} while (ubuf);
 	spin_unlock_irqrestore(&queue->callback_lock, flags);
 
-	if (likely(zerocopy_success))
+	if (likely(success))
 		queue->stats.tx_zerocopy_success++;
 	else
 		queue->stats.tx_zerocopy_fail++;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d703cd..bf28d0b75c1b 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -381,7 +381,8 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 	}
 }
 
-static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
+static void vhost_zerocopy_callback(struct sk_buff *skb,
+				    struct ubuf_info *ubuf, bool success)
 {
 	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 42e8dbde9504..8403ea509cee 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -458,13 +458,13 @@ enum {
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
  * lower device, the skb last reference should be 0 when calling this.
- * The zerocopy_success argument is true if zero copy transmit occurred,
- * false on data copy or out of memory error caused by data copy attempt.
+ * The success argument is true if zero copy transmit occurred, false on
+ * data copy or out of memory error caused by data copy attempt.
  * The ctx field is used to track device context.
  * The desc field is used to track userspace buffer index.
  */
 struct ubuf_info {
-	void (*callback)(struct ubuf_info *, bool zerocopy_success);
+	void (*callback)(struct sk_buff *, struct ubuf_info *, bool success);
 	union {
 		struct {
 			unsigned long desc;
@@ -496,7 +496,8 @@ struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
-void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
+void sock_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+			    bool success);
 
 int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len);
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
@@ -1476,20 +1477,17 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
 static inline void skb_zcopy_put(struct ubuf_info *uarg)
 {
 	if (uarg)
-		uarg->callback(uarg, true);
+		uarg->callback(NULL, uarg, true);
 }
 
 /* Release a reference on a zerocopy structure */
-static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
+static inline void skb_zcopy_clear(struct sk_buff *skb, bool success)
 {
 	struct ubuf_info *uarg = skb_zcopy(skb);
 
 	if (uarg) {
-		if (skb_zcopy_is_nouarg(skb)) {
-			/* no notification callback */
-		} else {
-			uarg->callback(uarg, zerocopy);
-		}
+		if (!skb_zcopy_is_nouarg(skb))
+			uarg->callback(skb, uarg, success);
 
 		skb_shinfo(skb)->zc_flags &= ~SKBZC_FRAGMENTS;
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fbf0a145467a..328385cd141e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1242,7 +1242,8 @@ static void __sock_zerocopy_callback(struct ubuf_info *uarg)
 	sock_put(sk);
 }
 
-void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
+void sock_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+			    bool success)
 {
 	uarg->zerocopy = uarg->zerocopy & success;
 
-- 
2.24.1

