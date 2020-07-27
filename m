Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A706A22FC6B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgG0WpS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:45:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727844AbgG0Wox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:53 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfdDk010756
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:53 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h50vprn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:53 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id CF3573FAB6F69; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 08/21] skbuff: add a zc_netgpu bitflag
Date:   Mon, 27 Jul 2020 15:44:31 -0700
Message-ID: <20200727224444.2987641-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=664 priorityscore=1501 adultscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This could likely be moved elsewhere.  The presence of the flag on
the skb indicates that one of the fragments may contain zerocopy
RX data, where the data is not accessible to the cpu.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 3 ++-
 net/core/skbuff.c      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fa817a105517..006e10fcc7d9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -782,7 +782,8 @@ struct sk_buff {
 				fclone:2,
 				peeked:1,
 				head_frag:1,
-				pfmemalloc:1;
+				pfmemalloc:1,
+				zc_netgpu:1;
 #ifdef CONFIG_SKB_EXTENSIONS
 	__u8			active_extensions;
 #endif
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b8afefe6f6b6..2a391042be53 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -992,6 +992,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->cloned = 1;
 	n->nohdr = 0;
 	n->peeked = 0;
+	C(zc_netgpu);
 	C(pfmemalloc);
 	n->destructor = NULL;
 	C(tail);
-- 
2.24.1

