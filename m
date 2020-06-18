Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251061FF8C9
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731909AbgFRQJ4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:09:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3940 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729548AbgFRQJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG1rEM013588
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31q660vyhg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:49 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 72AD73D44E154; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 19/21] core: add page recycling logic for netgpu pages
Date:   Thu, 18 Jun 2020 09:09:39 -0700
Message-ID: <20200618160941.879717-20-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=3
 clxscore=1034 mlxscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0
 cotscore=-2147483648 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netgpu pages will always have a refcount of at least one (held by
the netgpu module).  This logic and the codepath obviously needs
work, but suffices for a proof-of-concept.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/core/skbuff.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2a391042be53..2b4176cab578 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,6 +69,7 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#include <net/netgpu.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -590,6 +591,24 @@ static void skb_free_head(struct sk_buff *skb)
 		kfree(head);
 }
 
+static void skb_netgpu_unref(struct skb_shared_info *shinfo)
+{
+	struct page *page;
+	int count;
+	int i;
+
+	/* pages attached for skbs for TX shouldn't come here, since
+	 * the skb is not marked as "zc_netgpu". (only RX skbs have this).
+	 * dummy page does come here, but always has elevated refc.
+	 */
+	for (i = 0; i < shinfo->nr_frags; i++) {
+		page = skb_frag_page(&shinfo->frags[i]);
+		count = page_ref_dec_return(page);
+		if (count <= 2)
+			__netgpu_put_page(g_ctx, page, false);
+	}
+}
+
 static void skb_release_data(struct sk_buff *skb)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
@@ -600,8 +619,12 @@ static void skb_release_data(struct sk_buff *skb)
 			      &shinfo->dataref))
 		return;
 
-	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i]);
+	if (skb->zc_netgpu && shinfo->nr_frags) {
+		skb_netgpu_unref(shinfo);
+	} else {
+		for (i = 0; i < shinfo->nr_frags; i++)
+			__skb_frag_unref(&shinfo->frags[i]);
+	}
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
-- 
2.24.1

