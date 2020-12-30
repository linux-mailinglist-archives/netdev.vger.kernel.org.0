Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BB22E7C15
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgL3TNw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Dec 2020 14:13:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26518 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgL3TNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:13:34 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BUJB4nS008357
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:53 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35rr9e1uxu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:53 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Dec 2020 11:12:52 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 50568610FBC0; Wed, 30 Dec 2020 11:12:44 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <edumazet@google.com>, <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RFC PATCH v3 09/12] skbuff: rename sock_zerocopy_* to msg_zerocopy_*
Date:   Wed, 30 Dec 2020 11:12:41 -0800
Message-ID: <20201230191244.610449-10-jonathan.lemon@gmail.com>
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
 mlxlogscore=958 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 clxscore=1034 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012300118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

At Willem's suggestion, rename the sock_zerocopy_* functions
so that they match the MSG_ZEROCOPY flag, which makes it clear
they are specific to this zerocopy implementation.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/skbuff.h | 16 ++++++++--------
 net/core/skbuff.c      | 28 ++++++++++++++--------------
 net/ipv4/ip_output.c   |  2 +-
 net/ipv4/tcp.c         |  2 +-
 net/ipv6/ip6_output.c  |  2 +-
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9f7393167f0a..3c34c75ab004 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -488,13 +488,13 @@ struct ubuf_info {
 int mm_account_pinned_pages(struct mmpin *mmp, size_t size);
 void mm_unaccount_pinned_pages(struct mmpin *mmp);
 
-struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size);
-struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
-					struct ubuf_info *uarg);
+struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size);
+struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
+				       struct ubuf_info *uarg);
 
-void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
+void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
-void sock_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 			    bool success);
 
 int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len);
@@ -1481,8 +1481,8 @@ static inline void skb_zcopy_put(struct ubuf_info *uarg)
 static inline void skb_zcopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
 	if (uarg) {
-		if (uarg->callback == sock_zerocopy_callback)
-			sock_zerocopy_put_abort(uarg, have_uref);
+		if (uarg->callback == msg_zerocopy_callback)
+			msg_zerocopy_put_abort(uarg, have_uref);
 		else if (have_uref)
 			skb_zcopy_put(uarg);
 	}
@@ -2776,7 +2776,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 	if (likely(!skb_zcopy(skb)))
 		return 0;
 	if (!skb_zcopy_is_nouarg(skb) &&
-	    skb_uarg(skb)->callback == sock_zerocopy_callback)
+	    skb_uarg(skb)->callback == msg_zerocopy_callback)
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6d031ed99182..d520168accf9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1094,7 +1094,7 @@ void mm_unaccount_pinned_pages(struct mmpin *mmp)
 }
 EXPORT_SYMBOL_GPL(mm_unaccount_pinned_pages);
 
-struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size)
+struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 {
 	struct ubuf_info *uarg;
 	struct sk_buff *skb;
@@ -1114,7 +1114,7 @@ struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size)
 		return NULL;
 	}
 
-	uarg->callback = sock_zerocopy_callback;
+	uarg->callback = msg_zerocopy_callback;
 	uarg->id = ((u32)atomic_inc_return(&sk->sk_zckey)) - 1;
 	uarg->len = 1;
 	uarg->bytelen = size;
@@ -1124,15 +1124,15 @@ struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size)
 
 	return uarg;
 }
-EXPORT_SYMBOL_GPL(sock_zerocopy_alloc);
+EXPORT_SYMBOL_GPL(msg_zerocopy_alloc);
 
 static inline struct sk_buff *skb_from_uarg(struct ubuf_info *uarg)
 {
 	return container_of((void *)uarg, struct sk_buff, cb);
 }
 
-struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
-					struct ubuf_info *uarg)
+struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
+				       struct ubuf_info *uarg)
 {
 	if (uarg) {
 		const u32 byte_limit = 1 << 19;		/* limit to a few TSO */
@@ -1171,9 +1171,9 @@ struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 	}
 
 new_alloc:
-	return sock_zerocopy_alloc(sk, size);
+	return msg_zerocopy_alloc(sk, size);
 }
-EXPORT_SYMBOL_GPL(sock_zerocopy_realloc);
+EXPORT_SYMBOL_GPL(msg_zerocopy_realloc);
 
 static bool skb_zerocopy_notify_extend(struct sk_buff *skb, u32 lo, u16 len)
 {
@@ -1195,7 +1195,7 @@ static bool skb_zerocopy_notify_extend(struct sk_buff *skb, u32 lo, u16 len)
 	return true;
 }
 
-static void __sock_zerocopy_callback(struct ubuf_info *uarg)
+static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 {
 	struct sk_buff *tail, *skb = skb_from_uarg(uarg);
 	struct sock_exterr_skb *serr;
@@ -1243,17 +1243,17 @@ static void __sock_zerocopy_callback(struct ubuf_info *uarg)
 	sock_put(sk);
 }
 
-void sock_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 			    bool success)
 {
 	uarg->zerocopy = uarg->zerocopy & success;
 
 	if (refcount_dec_and_test(&uarg->refcnt))
-		__sock_zerocopy_callback(uarg);
+		__msg_zerocopy_callback(uarg);
 }
-EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
+EXPORT_SYMBOL_GPL(msg_zerocopy_callback);
 
-void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
+void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
 	struct sock *sk = skb_from_uarg(uarg)->sk;
 
@@ -1261,9 +1261,9 @@ void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 	uarg->len--;
 
 	if (have_uref)
-		sock_zerocopy_callback(NULL, uarg, true);
+		msg_zerocopy_callback(NULL, uarg, true);
 }
-EXPORT_SYMBOL_GPL(sock_zerocopy_put_abort);
+EXPORT_SYMBOL_GPL(msg_zerocopy_put_abort);
 
 int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len)
 {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 65f2299fd682..d8eb8b827794 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1018,7 +1018,7 @@ static int __ip_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
+		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
 		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fb58215972ba..2882d520f5b1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1217,7 +1217,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {
 		skb = tcp_write_queue_tail(sk);
-		uarg = sock_zerocopy_realloc(sk, size, skb_zcopy(skb));
+		uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
 		if (!uarg) {
 			err = -ENOBUFS;
 			goto out_err;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c8c87891533a..f59cfa39686a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1471,7 +1471,7 @@ static int __ip6_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
+		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
 		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-- 
2.24.1

