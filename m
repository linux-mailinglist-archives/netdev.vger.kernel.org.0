Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EC82EC620
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbhAFWTe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jan 2021 17:19:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727511AbhAFWTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:33 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 106MIm5K005149
        for <netdev@vger.kernel.org>; Wed, 6 Jan 2021 14:18:52 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35wjnj13n9-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:18:52 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 14:18:47 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id D16846556F37; Wed,  6 Jan 2021 14:18:41 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RESEND PATCH net-next v1 04/13] skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
Date:   Wed, 6 Jan 2021 14:18:32 -0800
Message-ID: <20210106221841.1880536-5-jonathan.lemon@gmail.com>
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
 mlxlogscore=563 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1034
 lowpriorityscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace sock_zerocopy_put with the generic skb_zcopy_put()
function.  Pass 'true' as the success argument, as this
is identical to no change.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 7 ++++++-
 net/core/skbuff.c      | 9 +--------
 net/ipv4/tcp.c         | 2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 52e96c35f5af..a6c86839035b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -496,7 +496,6 @@ static inline void sock_zerocopy_get(struct ubuf_info *uarg)
 	refcount_inc(&uarg->refcnt);
 }
 
-void sock_zerocopy_put(struct ubuf_info *uarg);
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
 void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
@@ -1471,6 +1470,12 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
 	return (void *)((uintptr_t) skb_shinfo(skb)->destructor_arg & ~0x1UL);
 }
 
+static inline void skb_zcopy_put(struct ubuf_info *uarg)
+{
+	if (uarg)
+		uarg->callback(uarg, true);
+}
+
 /* Release a reference on a zerocopy structure */
 static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8c18940723ff..0e028825367a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1251,13 +1251,6 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
 }
 EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
 
-void sock_zerocopy_put(struct ubuf_info *uarg)
-{
-	if (uarg)
-		uarg->callback(uarg, uarg->zerocopy);
-}
-EXPORT_SYMBOL_GPL(sock_zerocopy_put);
-
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
 	if (uarg) {
@@ -1267,7 +1260,7 @@ void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 		uarg->len--;
 
 		if (have_uref)
-			sock_zerocopy_put(uarg);
+			skb_zcopy_put(uarg);
 	}
 }
 EXPORT_SYMBOL_GPL(sock_zerocopy_put_abort);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ed42d2193c5c..298a1fae841c 100644
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

