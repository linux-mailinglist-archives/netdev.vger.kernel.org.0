Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9345A2E0346
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgLVAKj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbgLVAKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:11 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM00ghU013717
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:31 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0e8ssbw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:31 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:30 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 1E5955BD9C2E; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 04/12 v2 RFC] skbuff: Push status and refcounts into sock_zerocopy_callback
Date:   Mon, 21 Dec 2020 16:09:18 -0800
Message-ID: <20201222000926.1054993-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_13:2020-12-21,2020-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 clxscore=1034
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Before this change, the caller of sock_zerocopy_callback would
need to save the zerocopy status, decrement and check the refcount,
and then call the callback function - the callback was only invoked
when the refcount reached zero.

Now, the caller just passes the status into the callback function,
which saves the status and handles its own refcounts.

This makes the behavior of the sock_zerocopy_callback identical
to the tpacket and vhost callbacks.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h |  3 ---
 net/core/skbuff.c      | 14 +++++++++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fb6dd6af0f82..c9d7de9d624d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1482,9 +1482,6 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
 	if (uarg) {
 		if (skb_zcopy_is_nouarg(skb)) {
 			/* no notification callback */
-		} else if (uarg->callback == sock_zerocopy_callback) {
-			uarg->zerocopy = uarg->zerocopy && zerocopy;
-			sock_zerocopy_put(uarg);
 		} else {
 			uarg->callback(uarg, zerocopy);
 		}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ea32b3414ad6..73699dbdc4a1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1194,7 +1194,7 @@ static bool skb_zerocopy_notify_extend(struct sk_buff *skb, u32 lo, u16 len)
 	return true;
 }
 
-void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
+static void __sock_zerocopy_callback(struct ubuf_info *uarg)
 {
 	struct sk_buff *tail, *skb = skb_from_uarg(uarg);
 	struct sock_exterr_skb *serr;
@@ -1222,7 +1222,7 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
 	serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
 	serr->ee.ee_data = hi;
 	serr->ee.ee_info = lo;
-	if (!success)
+	if (!uarg->zerocopy)
 		serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
 
 	q = &sk->sk_error_queue;
@@ -1241,11 +1241,19 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
 	consume_skb(skb);
 	sock_put(sk);
 }
+
+void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
+{
+	uarg->zerocopy = uarg->zerocopy & success;
+
+	if (refcount_dec_and_test(&uarg->refcnt))
+		__sock_zerocopy_callback(uarg);
+}
 EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
 
 void sock_zerocopy_put(struct ubuf_info *uarg)
 {
-	if (uarg && refcount_dec_and_test(&uarg->refcnt))
+	if (uarg)
 		uarg->callback(uarg, uarg->zerocopy);
 }
 EXPORT_SYMBOL_GPL(sock_zerocopy_put);
-- 
2.24.1

