Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A2F2EC61F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbhAFWTd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jan 2021 17:19:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63446 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727738AbhAFWTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:32 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 106MIm5F005149
        for <netdev@vger.kernel.org>; Wed, 6 Jan 2021 14:18:50 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35wjnj13n9-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:18:50 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 14:18:47 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id EF7836556F43; Wed,  6 Jan 2021 14:18:41 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RESEND PATCH net-next v1 10/13] net: group skb_shinfo zerocopy related bits together.
Date:   Wed, 6 Jan 2021 14:18:38 -0800
Message-ID: <20210106221841.1880536-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
References: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1034
 lowpriorityscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for expanded zerocopy (TX and RX), move
the zerocopy related bits out of tx_flags into their own
flag word.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/tap.c                   |  3 +--
 drivers/net/tun.c                   |  3 +--
 drivers/net/xen-netback/interface.c |  4 +--
 include/linux/skbuff.h              | 38 ++++++++++++++++-------------
 net/core/skbuff.c                   |  9 +++----
 net/ipv4/tcp.c                      |  2 +-
 net/kcm/kcmsock.c                   |  4 +--
 7 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 3f51f3766d18..f7a19d9b7c27 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -723,8 +723,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
-		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+		skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(NULL, uarg, false);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 862c9063aa09..d8f1c3d34612 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1815,8 +1815,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
-		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+		skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(NULL, uarg, false);
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index acb786d8b1d8..08b0e3d0b7eb 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -47,7 +47,7 @@
 /* Number of bytes allowed on the internal guest Rx queue. */
 #define XENVIF_RX_QUEUE_BYTES (XEN_NETIF_RX_RING_SIZE/2 * PAGE_SIZE)
 
-/* This function is used to set SKBTX_DEV_ZEROCOPY as well as
+/* This function is used to set SKBFL_ZEROCOPY_ENABLE as well as
  * increasing the inflight counter. We need to increase the inflight
  * counter because core driver calls into xenvif_zerocopy_callback
  * which calls xenvif_skb_zerocopy_complete.
@@ -55,7 +55,7 @@
 void xenvif_skb_zerocopy_prepare(struct xenvif_queue *queue,
 				 struct sk_buff *skb)
 {
-	skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
+	skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_ENABLE;
 	atomic_inc(&queue->inflight_packets);
 }
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3c34c75ab004..66fde9a7b851 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -430,28 +430,32 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS = 1 << 2,
 
-	/* device driver supports TX zero-copy buffers */
-	SKBTX_DEV_ZEROCOPY = 1 << 3,
-
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS = 1 << 4,
 
-	/* This indicates at least one fragment might be overwritten
-	 * (as in vmsplice(), sendfile() ...)
-	 * If we need to compute a TX checksum, we'll need to copy
-	 * all frags to avoid possible bad checksum
-	 */
-	SKBTX_SHARED_FRAG = 1 << 5,
-
 	/* generate software time stamp when entering packet scheduling */
 	SKBTX_SCHED_TSTAMP = 1 << 6,
 };
 
-#define SKBTX_ZEROCOPY_FRAG	(SKBTX_DEV_ZEROCOPY | SKBTX_SHARED_FRAG)
 #define SKBTX_ANY_SW_TSTAMP	(SKBTX_SW_TSTAMP    | \
 				 SKBTX_SCHED_TSTAMP)
 #define SKBTX_ANY_TSTAMP	(SKBTX_HW_TSTAMP | SKBTX_ANY_SW_TSTAMP)
 
+/* Definitions for flags in struct skb_shared_info */
+enum {
+	/* use zcopy routines */
+	SKBFL_ZEROCOPY_ENABLE = BIT(0),
+
+	/* This indicates at least one fragment might be overwritten
+	 * (as in vmsplice(), sendfile() ...)
+	 * If we need to compute a TX checksum, we'll need to copy
+	 * all frags to avoid possible bad checksum
+	 */
+	SKBFL_SHARED_FRAG = BIT(1),
+};
+
+#define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
+
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
  * lower device, the skb last reference should be 0 when calling this.
@@ -506,7 +510,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
  * the end of the header data, ie. at skb->end.
  */
 struct skb_shared_info {
-	__u8		__unused;
+	__u8		flags;
 	__u8		meta_len;
 	__u8		nr_frags;
 	__u8		tx_flags;
@@ -1433,7 +1437,7 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
 
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
-	bool is_zcopy = skb && skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY;
+	bool is_zcopy = skb && skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
 
 	return is_zcopy ? skb_uarg(skb) : NULL;
 }
@@ -1452,14 +1456,14 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 		else
 			skb_zcopy_get(uarg);
 		skb_shinfo(skb)->destructor_arg = uarg;
-		skb_shinfo(skb)->tx_flags |= SKBTX_ZEROCOPY_FRAG;
+		skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
 	}
 }
 
 static inline void skb_zcopy_set_nouarg(struct sk_buff *skb, void *val)
 {
 	skb_shinfo(skb)->destructor_arg = (void *)((uintptr_t) val | 0x1UL);
-	skb_shinfo(skb)->tx_flags |= SKBTX_ZEROCOPY_FRAG;
+	skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
 }
 
 static inline bool skb_zcopy_is_nouarg(struct sk_buff *skb)
@@ -1497,7 +1501,7 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy_success)
 		if (!skb_zcopy_is_nouarg(skb))
 			uarg->callback(skb, uarg, zerocopy_success);
 
-		skb_shinfo(skb)->tx_flags &= ~SKBTX_ZEROCOPY_FRAG;
+		skb_shinfo(skb)->flags &= ~SKBFL_ZEROCOPY_FRAG;
 	}
 }
 
@@ -3323,7 +3327,7 @@ static inline int skb_linearize(struct sk_buff *skb)
 static inline bool skb_has_shared_frag(const struct sk_buff *skb)
 {
 	return skb_is_nonlinear(skb) &&
-	       skb_shinfo(skb)->tx_flags & SKBTX_SHARED_FRAG;
+	       skb_shinfo(skb)->flags & SKBFL_SHARED_FRAG;
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d520168accf9..124e4752afb6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1327,7 +1327,7 @@ static int skb_zerocopy_clone(struct sk_buff *nskb, struct sk_buff *orig,
  *	@skb: the skb to modify
  *	@gfp_mask: allocation priority
  *
- *	This must be called on SKBTX_DEV_ZEROCOPY skb.
+ *	This must be called on skb with SKBFL_ZEROCOPY_ENABLE.
  *	It will copy all frags into kernel and drop the reference
  *	to userspace pages.
  *
@@ -3264,8 +3264,7 @@ void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 {
 	int pos = skb_headlen(skb);
 
-	skb_shinfo(skb1)->tx_flags |= skb_shinfo(skb)->tx_flags &
-				      SKBTX_SHARED_FRAG;
+	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & SKBFL_SHARED_FRAG;
 	skb_zerocopy_clone(skb1, skb, 0);
 	if (len < pos)	/* Split line is inside header. */
 		skb_split_inside_header(skb, skb1, len, pos);
@@ -3954,8 +3953,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		skb_copy_from_linear_data_offset(head_skb, offset,
 						 skb_put(nskb, hsize), hsize);
 
-		skb_shinfo(nskb)->tx_flags |= skb_shinfo(head_skb)->tx_flags &
-					      SKBTX_SHARED_FRAG;
+		skb_shinfo(nskb)->flags |= skb_shinfo(head_skb)->flags &
+					   SKBFL_SHARED_FRAG;
 
 		if (skb_orphan_frags(frag_skb, GFP_ATOMIC) ||
 		    skb_zerocopy_clone(nskb, frag_skb, GFP_ATOMIC))
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2882d520f5b1..1954190b33c7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1010,7 +1010,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 	}
 
 	if (!(flags & MSG_NO_SHARED_FRAGS))
-		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+		skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 
 	skb->len += copy;
 	skb->data_len += copy;
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index a9eb616f5521..d0b56ffbb057 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -786,7 +786,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 
 		if (skb_can_coalesce(skb, i, page, offset)) {
 			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
-			skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+			skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 			goto coalesced;
 		}
 
@@ -834,7 +834,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 
 	get_page(page);
 	skb_fill_page_desc(skb, i, page, offset, size);
-	skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+	skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 
 coalesced:
 	skb->len += size;
-- 
2.24.1

