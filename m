Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC71FF8DC
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgFRQK3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20596 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729093AbgFRQJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG8Ld3014326
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q64evsdq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 76DB53D44E156; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 20/21] core/skbuff: use skb_zdata for testing whether skb is zerocopy
Date:   Thu, 18 Jun 2020 09:09:40 -0700
Message-ID: <20200618160941.879717-21-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=1 adultscore=0 phishscore=0
 mlxlogscore=633 clxscore=1034 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_zcopy() flag indicates whether the skb has a zerocopy ubuf.
netgpu does not use ubufs, so skb_zdata() indicates whether the
skb is carrying zero copy data, and should be left alone, while
skb_zcopy() indicates whhether there is an attached ubuf.

Also, when a write() on a zero-copy socket returns EWOULDBLOCK,
this is not synchronized with select(), which will only look at
the send buffer, and return writability if there is tcp space.

This appears to be caused by some ubuf logic, leading to iperf
spending 70% of its time in select() for ZC transmits.  With this
change, the time spent drops to 20%.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 24 +++++++++++++++++++++++-
 net/core/skbuff.c      | 16 ++++++++++++----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ba41d1a383f8..3c2efd45655b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -443,8 +443,12 @@ enum {
 
 	/* generate software time stamp when entering packet scheduling */
 	SKBTX_SCHED_TSTAMP = 1 << 6,
+
+	/* fragments are accessed only via DMA */
+	SKBTX_DEV_NETDMA = 1 << 7,
 };
 
+#define SKBTX_ZERODATA_FRAG	(SKBTX_DEV_ZEROCOPY | SKBTX_DEV_NETDMA)
 #define SKBTX_ZEROCOPY_FRAG	(SKBTX_DEV_ZEROCOPY | SKBTX_SHARED_FRAG)
 #define SKBTX_ANY_SW_TSTAMP	(SKBTX_SW_TSTAMP    | \
 				 SKBTX_SCHED_TSTAMP)
@@ -1416,6 +1420,24 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
 	return &skb_shinfo(skb)->hwtstamps;
 }
 
+static inline bool skb_netdma(struct sk_buff *skb)
+{
+	return skb && skb_shinfo(skb)->tx_flags & SKBTX_DEV_NETDMA;
+}
+
+static inline bool skb_zdata(struct sk_buff *skb)
+{
+	return skb && skb_shinfo(skb)->tx_flags & SKBTX_ZERODATA_FRAG;
+}
+
+static inline void skb_netdma_set(struct sk_buff *skb, bool netdma)
+{
+	if (skb && netdma) {
+		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_NETDMA;
+		skb_shinfo(skb)->destructor_arg = NULL;
+	}
+}
+
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
 	bool is_zcopy = skb && skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY;
@@ -3260,7 +3282,7 @@ static inline int skb_add_data(struct sk_buff *skb,
 static inline bool skb_can_coalesce(struct sk_buff *skb, int i,
 				    const struct page *page, int off)
 {
-	if (skb_zcopy(skb))
+	if (skb_zdata(skb))
 		return false;
 	if (i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2b4176cab578..67a421257a27 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1323,6 +1323,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 	}
 
 	skb_zcopy_set(skb, uarg, NULL);
+	skb_netdma_set(skb, sk->sk_user_data);
+
 	return skb->len - orig_len;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
@@ -1330,8 +1332,8 @@ EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
 static int skb_zerocopy_clone(struct sk_buff *nskb, struct sk_buff *orig,
 			      gfp_t gfp_mask)
 {
-	if (skb_zcopy(orig)) {
-		if (skb_zcopy(nskb)) {
+	if (skb_zdata(orig)) {
+		if (skb_zdata(nskb)) {
 			/* !gfp_mask callers are verified to !skb_zcopy(nskb) */
 			if (!gfp_mask) {
 				WARN_ON_ONCE(1);
@@ -1343,6 +1345,7 @@ static int skb_zerocopy_clone(struct sk_buff *nskb, struct sk_buff *orig,
 				return -EIO;
 		}
 		skb_zcopy_set(nskb, skb_uarg(orig), NULL);
+		skb_netdma_set(nskb, skb_netdma(orig));
 	}
 	return 0;
 }
@@ -1372,6 +1375,9 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
 		return -EINVAL;
 
+	if (!skb_has_shared_frag(skb))
+		return -EINVAL;
+
 	if (!num_frags)
 		goto release;
 
@@ -2078,6 +2084,8 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 	 */
 	int i, k, eat = (skb->tail + delta) - skb->end;
 
+	BUG_ON(skb_netdma(skb));
+
 	if (eat > 0 || skb_cloned(skb)) {
 		if (pskb_expand_head(skb, 0, eat > 0 ? eat + 128 : 0,
 				     GFP_ATOMIC))
@@ -3328,7 +3336,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 	if (skb_headlen(skb))
 		return 0;
-	if (skb_zcopy(tgt) || skb_zcopy(skb))
+	if (skb_zdata(tgt) || skb_zdata(skb))
 		return 0;
 
 	todo = shiftlen;
@@ -5171,7 +5179,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	from_shinfo = skb_shinfo(from);
 	if (to_shinfo->frag_list || from_shinfo->frag_list)
 		return false;
-	if (skb_zcopy(to) || skb_zcopy(from))
+	if (skb_zdata(to) || skb_zdata(from))
 		return false;
 
 	if (skb_headlen(from) != 0) {
-- 
2.24.1

