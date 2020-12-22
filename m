Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB2F2E0339
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgLVAKN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54444 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgLVAKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:12 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM002L7012803
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:32 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0e81tdx-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:32 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:28 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 22F285BD9C30; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 05/12 v2 RFC] skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
Date:   Mon, 21 Dec 2020 16:09:19 -0800
Message-ID: <20201222000926.1054993-6-jonathan.lemon@gmail.com>
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
 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=482 suspectscore=0
 clxscore=1034 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

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
index c9d7de9d624d..238166b522f7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -499,7 +499,6 @@ static inline void sock_zerocopy_get(struct ubuf_info *uarg)
 	refcount_inc(&uarg->refcnt);
 }
 
-void sock_zerocopy_put(struct ubuf_info *uarg);
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
 void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
@@ -1474,6 +1473,12 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
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
index 73699dbdc4a1..984760dd670b 100644
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

