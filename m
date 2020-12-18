Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DDC2DEA13
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgLRURU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 15:17:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4122 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727788AbgLRURS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:17:18 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIKDFVL010154
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:37 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35h01ps7f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:16:37 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 12:16:36 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id EF5ED59FBE79; Fri, 18 Dec 2020 12:16:33 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 7/9 v1 RFC] skbuff: add zc_flags to ubuf_info for ubuf setup
Date:   Fri, 18 Dec 2020 12:16:31 -0800
Message-ID: <20201218201633.2735367-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_12:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 suspectscore=0 mlxscore=0 clxscore=1034
 phishscore=0 mlxlogscore=416 priorityscore=1501 impostorscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Currently, an ubuf is attached to a new skb, the skb zc_flags
is initialized to a fixed value.  Instead of doing this, set
the default zc_flags in the ubuf, and have new skb's inherit
from this default.

This is needed when setting up different zerocopy types.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 3 ++-
 net/core/skbuff.c      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a50d52b796a7..65ef46b02f65 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -478,6 +478,7 @@ struct ubuf_info {
 		};
 	};
 	refcount_t refcnt;
+	u8 zc_flags;
 
 	struct mmpin {
 		struct user_struct *user;
@@ -1454,7 +1455,7 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 		else
 			skb_zcopy_get(uarg);
 		skb_shinfo(skb)->destructor_arg = uarg;
-		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
+		skb_shinfo(skb)->zc_flags |= uarg->zc_flags;
 	}
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8352da29f052..463078ba663f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1118,6 +1118,7 @@ struct ubuf_info *sock_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg->len = 1;
 	uarg->bytelen = size;
 	uarg->zerocopy = 1;
+	uarg->zc_flags = SKBZC_FRAGMENTS;
 	refcount_set(&uarg->refcnt, 1);
 	sock_hold(sk);
 
-- 
2.24.1

