Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1772DEA1C
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbgLRURd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 15:17:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42860 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727940AbgLRURS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:17:18 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BIKFVDx015791
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:37 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 35gjvbmarm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:37 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 12:16:35 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id D162559FBE6D; Fri, 18 Dec 2020 12:16:33 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 1/9 v1 RFC] net: group skb_shinfo zerocopy related bits together.
Date:   Fri, 18 Dec 2020 12:16:25 -0800
Message-ID: <20201218201633.2735367-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_12:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 clxscore=1034 mlxlogscore=999 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012180136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

In preparation for expanded zerocopy (TX and RX), move
the ZC related bits out of tx_flags into their own flag
word.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/tap.c                   |  3 +--
 drivers/net/tun.c                   |  3 +--
 drivers/net/xen-netback/interface.c |  4 ++--
 include/linux/skbuff.h              | 33 ++++++++++++++++-------------
 net/core/skbuff.c                   | 10 ++++-----
 net/ipv4/tcp.c                      |  2 +-
 net/kcm/kcmsock.c                   |  4 ++--
 7 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1f4bdd94407a..3e9fb753ce88 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -723,8 +723,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
-		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(uarg, false);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fbed05ae7b0f..80cb3bef3afd 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1815,8 +1815,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
-		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(uarg, false);
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index acb786d8b1d8..ec790df75be3 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -47,7 +47,7 @@
 /* Number of bytes allowed on the internal guest Rx queue. */
 #define XENVIF_RX_QUEUE_BYTES (XEN_NETIF_RX_RING_SIZE/2 * PAGE_SIZE)
 
-/* This function is used to set SKBTX_DEV_ZEROCOPY as well as
+/* This function is used to set SKBZC_ENABLE as well as
  * increasing the inflight counter. We need to increase the inflight
  * counter because core driver calls into xenvif_zerocopy_callback
  * which calls xenvif_skb_zerocopy_complete.
@@ -55,7 +55,7 @@
 void xenvif_skb_zerocopy_prepare(struct xenvif_queue *queue,
 				 struct sk_buff *skb)
 {
-	skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
+	skb_shinfo(skb)->zc_flags |= SKBZC_ENABLE;
 	atomic_inc(&queue->inflight_packets);
 }
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 333bcdc39635..69588b304f83 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -430,24 +430,27 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS = 1 << 2,
 
-	/* device driver supports TX zero-copy buffers */
-	SKBTX_DEV_ZEROCOPY = 1 << 3,
-
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS = 1 << 4,
 
+	/* generate software time stamp when entering packet scheduling */
+	SKBTX_SCHED_TSTAMP = 1 << 6,
+};
+
+/* Definitions for zc_flags in struct skb_shared_info */
+enum {
+	/* use zcopy routines */
+	SKBZC_ENABLE = BIT(0),
+
 	/* This indicates at least one fragment might be overwritten
 	 * (as in vmsplice(), sendfile() ...)
 	 * If we need to compute a TX checksum, we'll need to copy
 	 * all frags to avoid possible bad checksum
 	 */
-	SKBTX_SHARED_FRAG = 1 << 5,
-
-	/* generate software time stamp when entering packet scheduling */
-	SKBTX_SCHED_TSTAMP = 1 << 6,
+	SKBZC_SHARED_FRAG = BIT(1),
 };
 
-#define SKBTX_ZEROCOPY_FRAG	(SKBTX_DEV_ZEROCOPY | SKBTX_SHARED_FRAG)
+#define SKBZC_FRAGMENTS		(SKBZC_ENABLE | SKBZC_SHARED_FRAG)
 #define SKBTX_ANY_SW_TSTAMP	(SKBTX_SW_TSTAMP    | \
 				 SKBTX_SCHED_TSTAMP)
 #define SKBTX_ANY_TSTAMP	(SKBTX_HW_TSTAMP | SKBTX_ANY_SW_TSTAMP)
@@ -510,7 +513,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
  * the end of the header data, ie. at skb->end.
  */
 struct skb_shared_info {
-	__u8		__unused;
+	__u8		zc_flags;
 	__u8		meta_len;
 	__u8		nr_frags;
 	__u8		tx_flags;
@@ -1437,7 +1440,7 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
 
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
-	bool is_zcopy = skb && skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY;
+	bool is_zcopy = skb && skb_shinfo(skb)->zc_flags & SKBZC_ENABLE;
 
 	return is_zcopy ? skb_uarg(skb) : NULL;
 }
@@ -1451,14 +1454,14 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 		else
 			sock_zerocopy_get(uarg);
 		skb_shinfo(skb)->destructor_arg = uarg;
-		skb_shinfo(skb)->tx_flags |= SKBTX_ZEROCOPY_FRAG;
+		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
 	}
 }
 
 static inline void skb_zcopy_set_nouarg(struct sk_buff *skb, void *val)
 {
 	skb_shinfo(skb)->destructor_arg = (void *)((uintptr_t) val | 0x1UL);
-	skb_shinfo(skb)->tx_flags |= SKBTX_ZEROCOPY_FRAG;
+	skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
 }
 
 static inline bool skb_zcopy_is_nouarg(struct sk_buff *skb)
@@ -1486,7 +1489,7 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
 			uarg->callback(uarg, zerocopy);
 		}
 
-		skb_shinfo(skb)->tx_flags &= ~SKBTX_ZEROCOPY_FRAG;
+		skb_shinfo(skb)->zc_flags &= ~SKBZC_FRAGMENTS;
 	}
 }
 
@@ -1497,7 +1500,7 @@ static inline void skb_zcopy_abort(struct sk_buff *skb)
 
 	if (uarg) {
 		sock_zerocopy_put_abort(uarg, false);
-		skb_shinfo(skb)->tx_flags &= ~SKBTX_ZEROCOPY_FRAG;
+		skb_shinfo(skb)->zc_flags &= ~SKBZC_FRAGMENTS;
 	}
 }
 
@@ -3323,7 +3326,7 @@ static inline int skb_linearize(struct sk_buff *skb)
 static inline bool skb_has_shared_frag(const struct sk_buff *skb)
 {
 	return skb_is_nonlinear(skb) &&
-	       skb_shinfo(skb)->tx_flags & SKBTX_SHARED_FRAG;
+	       skb_shinfo(skb)->zc_flags & SKBZC_SHARED_FRAG;
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f62cae3f75d8..327ee8938f78 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1330,7 +1330,7 @@ static int skb_zerocopy_clone(struct sk_buff *nskb, struct sk_buff *orig,
  *	@skb: the skb to modify
  *	@gfp_mask: allocation priority
  *
- *	This must be called on SKBTX_DEV_ZEROCOPY skb.
+ *	This must be called on SKBZC_ENABLE skb.
  *	It will copy all frags into kernel and drop the reference
  *	to userspace pages.
  *
@@ -3267,8 +3267,8 @@ void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 {
 	int pos = skb_headlen(skb);
 
-	skb_shinfo(skb1)->tx_flags |= skb_shinfo(skb)->tx_flags &
-				      SKBTX_SHARED_FRAG;
+	skb_shinfo(skb1)->zc_flags |= skb_shinfo(skb)->zc_flags &
+				      SKBZC_SHARED_FRAG;
 	skb_zerocopy_clone(skb1, skb, 0);
 	if (len < pos)	/* Split line is inside header. */
 		skb_split_inside_header(skb, skb1, len, pos);
@@ -3957,8 +3957,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		skb_copy_from_linear_data_offset(head_skb, offset,
 						 skb_put(nskb, hsize), hsize);
 
-		skb_shinfo(nskb)->tx_flags |= skb_shinfo(head_skb)->tx_flags &
-					      SKBTX_SHARED_FRAG;
+		skb_shinfo(nskb)->zc_flags |= skb_shinfo(head_skb)->zc_flags &
+					      SKBZC_SHARED_FRAG;
 
 		if (skb_orphan_frags(frag_skb, GFP_ATOMIC) ||
 		    skb_zerocopy_clone(nskb, frag_skb, GFP_ATOMIC))
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ed42d2193c5c..fea9bae370e4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1010,7 +1010,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 	}
 
 	if (!(flags & MSG_NO_SHARED_FRAGS))
-		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+		skb_shinfo(skb)->zc_flags |= SKBZC_SHARED_FRAG;
 
 	skb->len += copy;
 	skb->data_len += copy;
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 56dad9565bc9..55c04d8c659a 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -786,7 +786,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 
 		if (skb_can_coalesce(skb, i, page, offset)) {
 			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
-			skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+			skb_shinfo(skb)->zc_flags |= SKBZC_SHARED_FRAG;
 			goto coalesced;
 		}
 
@@ -834,7 +834,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 
 	get_page(page);
 	skb_fill_page_desc(skb, i, page, offset, size);
-	skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+	skb_shinfo(skb)->zc_flags |= SKBZC_SHARED_FRAG;
 
 coalesced:
 	skb->len += size;
-- 
2.24.1

