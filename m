Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBAB2DEA12
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgLRURS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 15:17:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57970 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727875AbgLRURR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:17:17 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BIKCQO0027721
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:36 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35g1vcsb1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:36 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 12:16:35 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id DB5E459FBE71; Fri, 18 Dec 2020 12:16:33 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 3/9 v1 RFC] skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
Date:   Fri, 18 Dec 2020 12:16:27 -0800
Message-ID: <20201218201633.2735367-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_12:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 impostorscore=0 spamscore=0 phishscore=0 mlxlogscore=667 clxscore=1034
 suspectscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

In preparation for further work, the zcopy* routines will
become basic building blocks, while the zerocopy* ones will
be specific for the existing zerocopy implementation.

All uargs should have a callback function, (unless nouarg
is set), so push all special case logic handling down into
the callbacks.  This slightly pessimizes the refcounted cases,
but makes the skb_zcopy_*() routines clearer.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 19 +++++++++----------
 net/core/skbuff.c      | 21 +++++++++------------
 net/ipv4/tcp.c         |  2 +-
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fb6dd6af0f82..df98d61e8c51 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -499,7 +499,6 @@ static inline void sock_zerocopy_get(struct ubuf_info *uarg)
 	refcount_inc(&uarg->refcnt);
 }
 
-void sock_zerocopy_put(struct ubuf_info *uarg);
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
 void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
@@ -1474,20 +1473,20 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
 	return (void *)((uintptr_t) skb_shinfo(skb)->destructor_arg & ~0x1UL);
 }
 
+static inline void skb_zcopy_put(struct ubuf_info *uarg)
+{
+	if (uarg)
+		uarg->callback(uarg, true);
+}
+
 /* Release a reference on a zerocopy structure */
-static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
+static inline void skb_zcopy_clear(struct sk_buff *skb, bool succsss)
 {
 	struct ubuf_info *uarg = skb_zcopy(skb);
 
 	if (uarg) {
-		if (skb_zcopy_is_nouarg(skb)) {
-			/* no notification callback */
-		} else if (uarg->callback == sock_zerocopy_callback) {
-			uarg->zerocopy = uarg->zerocopy && zerocopy;
-			sock_zerocopy_put(uarg);
-		} else {
-			uarg->callback(uarg, zerocopy);
-		}
+		if (!skb_zcopy_is_nouarg(skb))
+			uarg->callback(uarg, succsss);
 
 		skb_shinfo(skb)->zc_flags &= ~SKBZC_FRAGMENTS;
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 327ee8938f78..984760dd670b 100644
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
@@ -1241,18 +1241,15 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
 	consume_skb(skb);
 	sock_put(sk);
 }
-EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
 
-void sock_zerocopy_put(struct ubuf_info *uarg)
+void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
 {
-	if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
-		if (uarg->callback)
-			uarg->callback(uarg, uarg->zerocopy);
-		else
-			consume_skb(skb_from_uarg(uarg));
-	}
+	uarg->zerocopy = uarg->zerocopy & success;
+
+	if (refcount_dec_and_test(&uarg->refcnt))
+		__sock_zerocopy_callback(uarg);
 }
-EXPORT_SYMBOL_GPL(sock_zerocopy_put);
+EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
 
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
@@ -1263,7 +1260,7 @@ void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 		uarg->len--;
 
 		if (have_uref)
-			sock_zerocopy_put(uarg);
+			skb_zcopy_put(uarg);
 	}
 }
 EXPORT_SYMBOL_GPL(sock_zerocopy_put_abort);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fea9bae370e4..5c38080df13f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1429,7 +1429,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
 	}
 out_nopush:
-	sock_zerocopy_put(uarg);
+	skb_zcopy_put(uarg);
 	return copied + copied_syn;
 
 do_error:
-- 
2.24.1

