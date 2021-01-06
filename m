Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CA12EC624
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbhAFWTd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jan 2021 17:19:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5622 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727707AbhAFWTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:32 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 106M9LQb014913
        for <netdev@vger.kernel.org>; Wed, 6 Jan 2021 14:18:51 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35vwxmpn98-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:18:51 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 14:18:48 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id C82CA6556F33; Wed,  6 Jan 2021 14:18:41 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RESEND PATCH net-next v1 02/13] skbuff: simplify sock_zerocopy_put
Date:   Wed, 6 Jan 2021 14:18:30 -0800
Message-ID: <20210106221841.1880536-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
References: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All 'struct ubuf_info' users should have a callback defined
as of commit 0a4a060bb204 ("sock: fix zerocopy_success regression
with msg_zerocopy").

Remove the dead code path to consume_skb(), which makes
assumptions about how the structure was allocated.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f62cae3f75d8..d88963f47f7d 100644
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

