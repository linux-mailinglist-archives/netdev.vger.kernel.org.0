Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B882EB53B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 23:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbhAEWIU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 17:08:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731606AbhAEWHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 17:07:54 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 105LmBl8007788
        for <netdev@vger.kernel.org>; Tue, 5 Jan 2021 14:07:13 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35tncue3py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 14:07:13 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 14:07:12 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 355666489D26; Tue,  5 Jan 2021 14:07:06 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH net-next v1 08/13] skbuff: Call skb_zcopy_clear() before unref'ing fragments
Date:   Tue, 5 Jan 2021 14:07:01 -0800
Message-ID: <20210105220706.998374-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210105220706.998374-1-jonathan.lemon@gmail.com>
References: <20210105220706.998374-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_07:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=547 priorityscore=1501 clxscore=1034
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

RX zerocopy fragment pages which are not allocated from the
system page pool require special handling.  Give the callback
in skb_zcopy_clear() a chance to process them first.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b9cd528d6a6..6d031ed99182 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -605,13 +605,14 @@ static void skb_release_data(struct sk_buff *skb)
 			      &shinfo->dataref))
 		return;
 
+	skb_zcopy_clear(skb, true);
+
 	for (i = 0; i < shinfo->nr_frags; i++)
 		__skb_frag_unref(&shinfo->frags[i]);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
 
-	skb_zcopy_clear(skb, true);
 	skb_free_head(skb);
 }
 
-- 
2.24.1

