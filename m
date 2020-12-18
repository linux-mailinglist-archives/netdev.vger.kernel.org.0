Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D42DEA1A
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgLRURX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 15:17:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387454AbgLRURW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:17:22 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BIKC2d3027460
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:41 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35g1vcsb1g-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:41 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 12:16:38 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id E005559FBE73; Fri, 18 Dec 2020 12:16:33 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 4/9 v1 RFC] skbuff: replace sock_zerocopy_get with skb_zcopy_get
Date:   Fri, 18 Dec 2020 12:16:28 -0800
Message-ID: <20201218201633.2735367-5-jonathan.lemon@gmail.com>
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
 impostorscore=0 spamscore=0 phishscore=0 mlxlogscore=384 clxscore=1034
 suspectscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Rename the get routines for consistency.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 4 ++--
 net/core/skbuff.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index df98d61e8c51..638feaf98f17 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -494,7 +494,7 @@ struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size);
 struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 					struct ubuf_info *uarg);
 
-static inline void sock_zerocopy_get(struct ubuf_info *uarg)
+static inline void skb_zcopy_get(struct ubuf_info *uarg)
 {
 	refcount_inc(&uarg->refcnt);
 }
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

