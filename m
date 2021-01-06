Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1DF2EC61A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbhAFWT1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jan 2021 17:19:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62572 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbhAFWT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:26 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 106MFn1f003009
        for <netdev@vger.kernel.org>; Wed, 6 Jan 2021 14:18:46 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35w7v0m6th-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:18:46 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 14:18:43 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id CCE766556F35; Wed,  6 Jan 2021 14:18:41 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RESEND PATCH net-next v1 03/13] skbuff: Push status and refcounts into sock_zerocopy_callback
Date:   Wed, 6 Jan 2021 14:18:31 -0800
Message-ID: <20210106221841.1880536-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
References: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1034 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101060125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 3ca8d7c7b30c..52e96c35f5af 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1479,9 +1479,6 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
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
index d88963f47f7d..8c18940723ff 100644
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

