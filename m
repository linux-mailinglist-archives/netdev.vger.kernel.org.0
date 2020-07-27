Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7864922FC61
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgG0Wo7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:44:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727846AbgG0Woy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:54 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfd9U010757
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:53 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h50vprn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:53 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id DC59B3FAB6F6F; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 11/21] core/skbuff: add page recycling logic for netgpu pages
Date:   Mon, 27 Jul 2020 15:44:34 -0700
Message-ID: <20200727224444.2987641-12-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=3
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

netgpu pages will always have a refcount of at least one (held by
the netgpu module).  If the skb is marked as containing netgpu ZC
pages, recycle them back to netgpu.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/core/skbuff.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1422b99b7090..50dbb7ce1965 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -591,6 +591,27 @@ static void skb_free_head(struct sk_buff *skb)
 		kfree(head);
 }
 
+#if IS_ENABLED(CONFIG_NETGPU)
+static void skb_netgpu_unref(struct skb_shared_info *shinfo)
+{
+	struct netgpu_ifq *ifq = shinfo->destructor_arg;
+	struct page *page;
+	int i;
+
+	/* pages attached for skbs for TX shouldn't come here, since
+	 * the skb is not marked as "zc_netgpu". (only RX skbs have this).
+	 * dummy page does come here, but always has elevated refc.
+	 *
+	 * Undelivered zc skb's will arrive at this point.
+	 */
+	for (i = 0; i < shinfo->nr_frags; i++) {
+		page = skb_frag_page(&shinfo->frags[i]);
+		if (page && page_ref_dec_return(page) <= 2)
+			netgpu_put_page(ifq, page, false);
+	}
+}
+#endif
+
 static void skb_release_data(struct sk_buff *skb)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
@@ -601,8 +622,15 @@ static void skb_release_data(struct sk_buff *skb)
 			      &shinfo->dataref))
 		return;
 
-	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i]);
+#if IS_ENABLED(CONFIG_NETGPU)
+	if (skb->zc_netgpu && shinfo->nr_frags) {
+		skb_netgpu_unref(shinfo);
+	} else
+#endif
+	{
+		for (i = 0; i < shinfo->nr_frags; i++)
+			__skb_frag_unref(&shinfo->frags[i]);
+	}
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
-- 
2.24.1

