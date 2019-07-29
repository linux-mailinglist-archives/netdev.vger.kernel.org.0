Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF02791E7
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfG2RTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:19:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726601AbfG2RTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:19:45 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6THIr3R017846
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 10:19:44 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2u1tf12d2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 10:19:44 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 29 Jul 2019 10:19:42 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8D8E025693E8B; Mon, 29 Jul 2019 10:19:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <willy@infraded.org>, <davem@davemloft.net>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 3/3 net-next] linux: Remove bvec page_offset, use bv_offset
Date:   Mon, 29 Jul 2019 10:19:41 -0700
Message-ID: <20190729171941.250569-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190729171941.250569-1-jonathan.lemon@gmail.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907290189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that page_offset is referenced through accessors, remove
the union, and use bv_offset.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/bvec.h   |  5 +----
 include/linux/skbuff.h | 10 +++++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 7f2b2ea9399c..a032f01e928c 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -18,10 +18,7 @@
 struct bio_vec {
 	struct page	*bv_page;
 	unsigned int	bv_len;
-	union {
-		__u32		page_offset;
-		unsigned int	bv_offset;
-	};
+	unsigned int	bv_offset;
 };
 
 struct bvec_iter {
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7d94a78067ee..68334e56a697 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2078,7 +2078,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 	 * on page_is_pfmemalloc doing the right thing(tm).
 	 */
 	frag->bv_page		  = page;
-	frag->page_offset	  = off;
+	frag->bv_offset		  = off;
 	skb_frag_size_set(frag, size);
 
 	page = compound_head(page);
@@ -2863,7 +2863,7 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
  */
 static inline unsigned int skb_frag_off(const skb_frag_t *frag)
 {
-	return frag->page_offset;
+	return frag->bv_offset;
 }
 
 /**
@@ -2873,7 +2873,7 @@ static inline unsigned int skb_frag_off(const skb_frag_t *frag)
  */
 static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
 {
-	frag->page_offset += delta;
+	frag->bv_offset += delta;
 }
 
 /**
@@ -2883,7 +2883,7 @@ static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
  */
 static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
 {
-	frag->page_offset = offset;
+	frag->bv_offset = offset;
 }
 
 /**
@@ -2894,7 +2894,7 @@ static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
 static inline void skb_frag_off_set_from(skb_frag_t *fragto,
 					 const skb_frag_t *fragfrom)
 {
-	fragto->page_offset = fragfrom->page_offset;
+	fragto->bv_offset = fragfrom->bv_offset;
 }
 
 /**
-- 
2.17.1

