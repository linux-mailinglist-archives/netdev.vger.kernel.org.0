Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D7A2E0338
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgLVAKL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3370 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgLVAKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:11 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM002L3012803
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:30 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0e81tdx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:30 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:28 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 1966E5BD9C2C; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 03/12 v2 RFC] skbuff: simplify sock_zerocopy_put
Date:   Mon, 21 Dec 2020 16:09:17 -0800
Message-ID: <20201222000926.1054993-4-jonathan.lemon@gmail.com>
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
 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=767 suspectscore=0
 clxscore=1034 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

All 'struct ubuf_info' users should have a callback defined.
Remove the dead code path to consume_skb(), which makes
unwarranted assumptions about how the structure was allocated.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/core/skbuff.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 327ee8938f78..ea32b3414ad6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1245,12 +1245,8 @@ EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
 
 void sock_zerocopy_put(struct ubuf_info *uarg)
 {
-	if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
-		if (uarg->callback)
-			uarg->callback(uarg, uarg->zerocopy);
-		else
-			consume_skb(skb_from_uarg(uarg));
-	}
+	if (uarg && refcount_dec_and_test(&uarg->refcnt))
+		uarg->callback(uarg, uarg->zerocopy);
 }
 EXPORT_SYMBOL_GPL(sock_zerocopy_put);
 
-- 
2.24.1

