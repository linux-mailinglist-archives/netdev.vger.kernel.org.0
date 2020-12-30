Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3012E7C0C
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgL3TNf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Dec 2020 14:13:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgL3TNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:13:33 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BUJAZuB017374
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:52 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35rk9ytnc0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:12:52 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Dec 2020 11:12:51 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 3E6CA610FBB8; Wed, 30 Dec 2020 11:12:44 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <edumazet@google.com>, <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RFC PATCH v3 05/12] skbuff: replace sock_zerocopy_get with skb_zcopy_get
Date:   Wed, 30 Dec 2020 11:12:37 -0800
Message-ID: <20201230191244.610449-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201230191244.610449-1-jonathan.lemon@gmail.com>
References: <20201230191244.610449-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-30_12:2020-12-30,2020-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=294
 impostorscore=0 spamscore=0 clxscore=1034 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012300118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Rename the get routines for consistency.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 12 ++++++------
 net/core/skbuff.c      |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a6c86839035b..5b8a53ab51fd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -491,11 +491,6 @@ struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size);
 struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 					struct ubuf_info *uarg);
 
-static inline void sock_zerocopy_get(struct ubuf_info *uarg)
-{
-	refcount_inc(&uarg->refcnt);
-}
-
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
 void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
@@ -1441,6 +1436,11 @@ static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 	return is_zcopy ? skb_uarg(skb) : NULL;
 }
 
+static inline void skb_zcopy_get(struct ubuf_info *uarg)
+{
+	refcount_inc(&uarg->refcnt);
+}
+
 static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 				 bool *have_ref)
 {
@@ -1448,7 +1448,7 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 		if (unlikely(have_ref && *have_ref))
 			*have_ref = false;
 		else
-			sock_zerocopy_get(uarg);
+			skb_zcopy_get(uarg);
 		skb_shinfo(skb)->destructor_arg = uarg;
 		skb_shinfo(skb)->tx_flags |= SKBTX_ZEROCOPY_FRAG;
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0e028825367a..00f195908e79 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1163,7 +1163,7 @@ struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 
 			/* no extra ref when appending to datagram (MSG_MORE) */
 			if (sk->sk_type == SOCK_STREAM)
-				sock_zerocopy_get(uarg);
+				skb_zcopy_get(uarg);
 
 			return uarg;
 		}
-- 
2.24.1

