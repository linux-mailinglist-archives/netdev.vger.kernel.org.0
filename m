Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D61E2E033D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgLVAKS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgLVAKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:17 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM00fiC013676
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:37 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0e8ssby-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:37 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:33 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 34C875BD9C38; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 09/12 v2 RFC] skbuff: add zc_flags to ubuf_info for ubuf setup
Date:   Mon, 21 Dec 2020 16:09:23 -0800
Message-ID: <20201222000926.1054993-10-jonathan.lemon@gmail.com>
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
 spamscore=0 mlxlogscore=466 malwarescore=0 adultscore=0 clxscore=1034
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210163
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
index da0c1dddd0da..b90be4b0b2de 100644
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

