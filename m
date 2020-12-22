Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB65F2E033A
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgLVAKO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbgLVAKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:13 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM08aru022935
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:33 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0du9tce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:32 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:32 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 273485BD9C32; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 06/12 v2 RFC] skbuff: replace sock_zerocopy_get with skb_zcopy_get
Date:   Mon, 21 Dec 2020 16:09:20 -0800
Message-ID: <20201222000926.1054993-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_13:2020-12-21,2020-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 suspectscore=0 mlxlogscore=283 adultscore=0 phishscore=0 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210164
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
index 238166b522f7..42e8dbde9504 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -494,11 +494,6 @@ struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size);
 struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 					struct ubuf_info *uarg);
 
-static inline void sock_zerocopy_get(struct ubuf_info *uarg)
-{
-	refcount_inc(&uarg->refcnt);
-}
-
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
 void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
@@ -1444,6 +1439,11 @@ static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
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
@@ -1451,7 +1451,7 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 		if (unlikely(have_ref && *have_ref))
 			*have_ref = false;
 		else
-			sock_zerocopy_get(uarg);
+			skb_zcopy_get(uarg);
 		skb_shinfo(skb)->destructor_arg = uarg;
 		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 984760dd670b..fbf0a145467a 100644
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

