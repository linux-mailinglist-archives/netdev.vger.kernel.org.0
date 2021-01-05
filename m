Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2511E2EB530
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 23:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731663AbhAEWH5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 17:07:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731633AbhAEWH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 17:07:56 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105LiBZn001092
        for <netdev@vger.kernel.org>; Tue, 5 Jan 2021 14:07:15 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35u9rckun2-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 14:07:15 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 14:07:13 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 449B46489D2C; Tue,  5 Jan 2021 14:07:06 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH net-next v1 11/13] skbuff: add flags to ubuf_info for ubuf setup
Date:   Tue, 5 Jan 2021 14:07:04 -0800
Message-ID: <20210105220706.998374-12-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210105220706.998374-1-jonathan.lemon@gmail.com>
References: <20210105220706.998374-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_07:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=630 suspectscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Currently, when an ubuf is attached to a new skb, the shared
flags word is initialized to a fixed value.  Instead of doing
this, set the default flags in the ubuf, and have new skbs
inherit from this default.

This is needed when setting up different zerocopy types.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 3 ++-
 net/core/skbuff.c      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 66fde9a7b851..58010df9d183 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -480,6 +480,7 @@ struct ubuf_info {
 		};
 	};
 	refcount_t refcnt;
+	u8 flags;
 
 	struct mmpin {
 		struct user_struct *user;
@@ -1456,7 +1457,7 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 		else
 			skb_zcopy_get(uarg);
 		skb_shinfo(skb)->destructor_arg = uarg;
-		skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
+		skb_shinfo(skb)->flags |= uarg->flags;
 	}
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 124e4752afb6..ee288af095f0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1119,6 +1119,7 @@ struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg->len = 1;
 	uarg->bytelen = size;
 	uarg->zerocopy = 1;
+	uarg->flags = SKBFL_ZEROCOPY_FRAG;
 	refcount_set(&uarg->refcnt, 1);
 	sock_hold(sk);
 
-- 
2.24.1

