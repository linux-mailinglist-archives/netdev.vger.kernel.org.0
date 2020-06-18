Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5AF1FF8D9
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731994AbgFRQKS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19144 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731766AbgFRQKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:01 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9kd8004695
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:00 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q653msbn-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:00 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 5321C3D44E144; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 11/21] skbuff: add a zc_netgpu bitflag
Date:   Thu, 18 Jun 2020 09:09:31 -0700
Message-ID: <20200618160941.879717-12-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 priorityscore=1501 impostorscore=0 cotscore=-2147483648 suspectscore=1
 spamscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=581 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This could likely be moved elsewhere.  The presence of the flag on
the skb indicates that one of the fragments may contain zerocopy
data (where the data is not accessible to the cpu).

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 3 ++-
 net/core/skbuff.c      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0c0377fc00c2..ba41d1a383f8 100644
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

