Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719FC22FC5D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgG0Wou convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:44:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2648 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgG0Wot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:49 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfs9T003723
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:49 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4ed6t0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:48 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:47 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id D32133FAB6F6B; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 09/21] core/skbuff: use skb_zdata for testing whether skb is zerocopy
Date:   Mon, 27 Jul 2020 15:44:32 -0700
Message-ID: <20200727224444.2987641-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1034
 suspectscore=1 mlxlogscore=771 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

skb_zcopy() flag indicates whether the skb has a zerocopy ubuf.
netgpu does not use ubufs, so skb_zdata() indicates whether the
skb is carrying zero copy data, and should be left alone, while
skb_zcopy() indicates whether there is an attached ubuf.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 24 +++++++++++++++++++++++-
 net/core/skbuff.c      | 17 ++++++++++++++++-
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 006e10fcc7d9..017c20792c23 100644
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
@@ -1420,6 +1424,24 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
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
+static inline void skb_netdma_set(struct sk_buff *skb, void *arg)
+{
+	if (skb && arg) {
+		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_NETDMA;
+		skb_shinfo(skb)->destructor_arg = arg;
+	}
+}
+
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
 	bool is_zcopy = skb && skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY;
@@ -3264,7 +3286,7 @@ static inline int skb_add_data(struct sk_buff *skb,
 static inline bool skb_can_coalesce(struct sk_buff *skb, int i,
 				    const struct page *page, int off)
 {
-	if (skb_zcopy(skb))
+	if (skb_zdata(skb))
 		return false;
 	if (i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2a391042be53..1422b99b7090 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,6 +69,7 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#include <net/netgpu.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -1300,6 +1301,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 	}
 
 	skb_zcopy_set(skb, uarg, NULL);
+	skb_netdma_set(skb, sk->sk_user_data);
+
 	return skb->len - orig_len;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
@@ -1307,6 +1310,16 @@ EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
 static int skb_zerocopy_clone(struct sk_buff *nskb, struct sk_buff *orig,
 			      gfp_t gfp_mask)
 {
+	if (skb_netdma(orig)) {
+		if (skb_netdma(nskb)) {
+			WARN_ONCE(1, "zc clone, dst skb is set\n");
+			if (skb_uarg(nskb) != skb_uarg(orig))
+				return -EIO;
+		}
+		skb_netdma_set(nskb, skb_shinfo(orig)->destructor_arg);
+		return 0;
+	}
+
 	if (skb_zcopy(orig)) {
 		if (skb_zcopy(nskb)) {
 			/* !gfp_mask callers are verified to !skb_zcopy(nskb) */
@@ -2055,6 +2068,8 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 	 */
 	int i, k, eat = (skb->tail + delta) - skb->end;
 
+	BUG_ON(skb_netdma(skb));
+
 	if (eat > 0 || skb_cloned(skb)) {
 		if (pskb_expand_head(skb, 0, eat > 0 ? eat + 128 : 0,
 				     GFP_ATOMIC))
@@ -3305,7 +3320,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 	if (skb_headlen(skb))
 		return 0;
-	if (skb_zcopy(tgt) || skb_zcopy(skb))
+	if (skb_zdata(tgt) || skb_zdata(skb))
 		return 0;
 
 	todo = shiftlen;
-- 
2.24.1

