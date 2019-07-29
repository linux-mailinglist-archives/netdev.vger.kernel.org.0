Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03773791E8
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbfG2RTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:19:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13802 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728335AbfG2RTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:19:48 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6THIsCd017854
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 10:19:46 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2u1tf12d2f-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 10:19:46 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 29 Jul 2019 10:19:43 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8491125693E87; Mon, 29 Jul 2019 10:19:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <willy@infraded.org>, <davem@davemloft.net>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset accessors
Date:   Mon, 29 Jul 2019 10:19:39 -0700
Message-ID: <20190729171941.250569-2-jonathan.lemon@gmail.com>
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

Add skb_frag_off(), skb_frag_off_add(), skb_frag_off_set(),
and skb_frag_off_set_from() accessors for page_offset.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 61 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 718742b1c505..7d94a78067ee 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -331,7 +331,7 @@ static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
 }
 
 /**
- * skb_frag_size_add - Incrementes the size of a skb fragment by %delta
+ * skb_frag_size_add - Increments the size of a skb fragment by %delta
  * @frag: skb fragment
  * @delta: value to add
  */
@@ -2857,6 +2857,46 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
 		skb->pfmemalloc = true;
 }
 
+/**
+ * skb_frag_off - Returns the offset of a skb fragment
+ * @frag: the paged fragment
+ */
+static inline unsigned int skb_frag_off(const skb_frag_t *frag)
+{
+	return frag->page_offset;
+}
+
+/**
+ * skb_frag_off_add - Increments the offset of a skb fragment by %delta
+ * @frag: skb fragment
+ * @delta: value to add
+ */
+static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
+{
+	frag->page_offset += delta;
+}
+
+/**
+ * skb_frag_off_set - Sets the offset of a skb fragment
+ * @frag: skb fragment
+ * @offset: offset of fragment
+ */
+static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
+{
+	frag->page_offset = offset;
+}
+
+/**
+ * skb_frag_off_set_from - Sets the offset of a skb fragment from another fragment
+ * @fragto: skb fragment where offset is set
+ * @fragfrom: skb fragment offset is copied from
+ */
+static inline void skb_frag_off_set_from(skb_frag_t *fragto,
+					 const skb_frag_t *fragfrom)
+{
+	fragto->page_offset = fragfrom->page_offset;
+}
+
 /**
  * skb_frag_page - retrieve the page referred to by a paged fragment
  * @frag: the paged fragment
@@ -2923,7 +2963,7 @@ static inline void skb_frag_unref(struct sk_buff *skb, int f)
  */
 static inline void *skb_frag_address(const skb_frag_t *frag)
 {
-	return page_address(skb_frag_page(frag)) + frag->page_offset;
+	return page_address(skb_frag_page(frag)) + skb_frag_off(frag);
 }
 
 /**
@@ -2939,7 +2979,18 @@ static inline void *skb_frag_address_safe(const skb_frag_t *frag)
 	if (unlikely(!ptr))
 		return NULL;
 
-	return ptr + frag->page_offset;
+	return ptr + skb_frag_off(frag);
+}
+
+/**
+ * skb_frag_page_set_from - sets the page in a fragment from another fragment
+ * @fragto: skb fragment where page is set
+ * @fragfrom: skb fragment page is copied from
+ */
+static inline void skb_frag_page_set_from(skb_frag_t *fragto,
+					  const skb_frag_t *fragfrom)
+{
+	fragto->bv_page = fragfrom->bv_page;
 }
 
 /**
@@ -2987,7 +3038,7 @@ static inline dma_addr_t skb_frag_dma_map(struct device *dev,
 					  enum dma_data_direction dir)
 {
 	return dma_map_page(dev, skb_frag_page(frag),
-			    frag->page_offset + offset, size, dir);
+			    skb_frag_off(frag) + offset, size, dir);
 }
 
 static inline struct sk_buff *pskb_copy(struct sk_buff *skb,
@@ -3157,7 +3208,7 @@ static inline bool skb_can_coalesce(struct sk_buff *skb, int i,
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
 		return page == skb_frag_page(frag) &&
-		       off == frag->page_offset + skb_frag_size(frag);
+		       off == skb_frag_off(frag) + skb_frag_size(frag);
 	}
 	return false;
 }
-- 
2.17.1

