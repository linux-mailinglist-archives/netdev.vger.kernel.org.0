Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE6C2E7C0E
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgL3TNg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Dec 2020 14:13:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5938 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbgL3TNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:13:31 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BUJ9A7x011915
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:50 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35rgds30g3-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:50 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Dec 2020 11:12:49 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 43480610FBBA; Wed, 30 Dec 2020 11:12:44 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <edumazet@google.com>, <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RFC PATCH v3 06/12] skbuff: Add skb parameter to the ubuf zerocopy callback
Date:   Wed, 30 Dec 2020 11:12:38 -0800
Message-ID: <20201230191244.610449-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201230191244.610449-1-jonathan.lemon@gmail.com>
References: <20201230191244.610449-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-30_12:2020-12-30,2020-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1034 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=937
 bulkscore=0 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012300118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Add an optional skb parameter to the zerocopy callback parameter,
which is passed down from skb_zcopy_clear().  This gives access
to the original skb, which is needed for upcoming RX zero-copy
error handling.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/tap.c                 |  2 +-
 drivers/net/tun.c                 |  2 +-
 drivers/net/xen-netback/common.h  |  3 ++-
 drivers/net/xen-netback/netback.c |  5 +++--
 drivers/vhost/net.c               |  3 ++-
 include/linux/skbuff.h            | 17 ++++++++---------
 net/core/skbuff.c                 |  3 ++-
 7 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1f4bdd94407a..3f51f3766d18 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -727,7 +727,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
-		uarg->callback(uarg, false);
+		uarg->callback(NULL, uarg, false);
 	}
 
 	if (tap) {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fbed05ae7b0f..b64e2cc85751 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1819,7 +1819,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
-		uarg->callback(uarg, false);
+		uarg->callback(NULL, uarg, false);
 	}
 
 	skb_reset_network_header(skb);
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 8ee24e351bdc..4a16d6e33c09 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -399,7 +399,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 void xenvif_carrier_on(struct xenvif *vif);
 
 /* Callback from stack when TX packet can be released */
-void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success);
+void xenvif_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *ubuf,
+			      bool zerocopy_success);
 
 /* Unmap a pending page and release it back to the guest */
 void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index bc3421d14576..19a27dce79d2 100644
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
+			      bool zerocopy_success)
 {
 	unsigned long flags;
 	pending_ring_idx_t index;
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
index 5b8a53ab51fd..b23c3b4b3209 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -461,7 +461,8 @@ enum {
  * The desc field is used to track userspace buffer index.
  */
 struct ubuf_info {
-	void (*callback)(struct ubuf_info *, bool zerocopy_success);
+	void (*callback)(struct sk_buff *, struct ubuf_info *,
+			 bool zerocopy_success);
 	union {
 		struct {
 			unsigned long desc;
@@ -493,7 +494,8 @@ struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
-void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
+void sock_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+			    bool success);
 
 int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len);
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
@@ -1473,20 +1475,17 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
 static inline void skb_zcopy_put(struct ubuf_info *uarg)
 {
 	if (uarg)
-		uarg->callback(uarg, true);
+		uarg->callback(NULL, uarg, true);
 }
 
 /* Release a reference on a zerocopy structure */
-static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
+static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy_success)
 {
 	struct ubuf_info *uarg = skb_zcopy(skb);
 
 	if (uarg) {
-		if (skb_zcopy_is_nouarg(skb)) {
-			/* no notification callback */
-		} else {
-			uarg->callback(uarg, zerocopy);
-		}
+		if (!skb_zcopy_is_nouarg(skb))
+			uarg->callback(skb, uarg, zerocopy_success);
 
 		skb_shinfo(skb)->tx_flags &= ~SKBTX_ZEROCOPY_FRAG;
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 00f195908e79..89130b21d9f0 100644
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

