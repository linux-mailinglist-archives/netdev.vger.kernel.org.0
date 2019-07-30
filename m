Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1259D7AB35
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbfG3Okj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:40:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10048 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729167AbfG3Okj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:40:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UEcNld003493
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:38 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2q1xr6bb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:37 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 07:40:35 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 974672576FD13; Tue, 30 Jul 2019 07:40:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <willy@infradead.org>, <davem@davemloft.net>,
        <jakub.kicinski@netronome.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v2 3/3 net-next] linux: Remove bvec page_offset, use bv_offset
Date:   Tue, 30 Jul 2019 07:40:34 -0700
Message-ID: <20190730144034.444022-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730144034.444022-1-jonathan.lemon@gmail.com>
References: <20190730144034.444022-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300152
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
index 2957cdd6c032..3aef8d82ea59 100644
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
 static inline void skb_frag_off_copy(skb_frag_t *fragto,
 				     const skb_frag_t *fragfrom)
 {
-	fragto->page_offset = fragfrom->page_offset;
+	fragto->bv_offset = fragfrom->bv_offset;
 }
 
 /**
-- 
2.17.1

