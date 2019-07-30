Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AB17AB37
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbfG3Oko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:40:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729812AbfG3Okj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:40:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6UEc2Qg020689
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:38 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u275g3231-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:38 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 07:40:35 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8E19A2576FD0F; Tue, 30 Jul 2019 07:40:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <willy@infradead.org>, <davem@davemloft.net>,
        <jakub.kicinski@netronome.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v2 1/3 net-next] linux: Add skb_frag_t page_offset accessors
Date:   Tue, 30 Jul 2019 07:40:32 -0700
Message-ID: <20190730144034.444022-2-jonathan.lemon@gmail.com>
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
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add skb_frag_off(), skb_frag_off_add(), skb_frag_off_set(),
and skb_frag_off_copy() accessors for page_offset.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 67 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 718742b1c505..2957cdd6c032 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -312,7 +312,7 @@ extern int sysctl_max_skb_frags;
 typedef struct bio_vec skb_frag_t;
 
 /**
- * skb_frag_size - Returns the size of a skb fragment
+ * skb_frag_size() - Returns the size of a skb fragment
  * @frag: skb fragment
  */
 static inline unsigned int skb_frag_size(const skb_frag_t *frag)
@@ -321,7 +321,7 @@ static inline unsigned int skb_frag_size(const skb_frag_t *frag)
 }
 
 /**
- * skb_frag_size_set - Sets the size of a skb fragment
+ * skb_frag_size_set() - Sets the size of a skb fragment
  * @frag: skb fragment
  * @size: size of fragment
  */
@@ -331,7 +331,7 @@ static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
 }
 
 /**
- * skb_frag_size_add - Incrementes the size of a skb fragment by %delta
+ * skb_frag_size_add() - Increments the size of a skb fragment by @delta
  * @frag: skb fragment
  * @delta: value to add
  */
@@ -341,7 +341,7 @@ static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
 }
 
 /**
- * skb_frag_size_sub - Decrements the size of a skb fragment by %delta
+ * skb_frag_size_sub() - Decrements the size of a skb fragment by @delta
  * @frag: skb fragment
  * @delta: value to subtract
  */
@@ -2857,6 +2857,46 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
 		skb->pfmemalloc = true;
 }
 
+/**
+ * skb_frag_off() - Returns the offset of a skb fragment
+ * @frag: the paged fragment
+ */
+static inline unsigned int skb_frag_off(const skb_frag_t *frag)
+{
+	return frag->page_offset;
+}
+
+/**
+ * skb_frag_off_add() - Increments the offset of a skb fragment by @delta
+ * @frag: skb fragment
+ * @delta: value to add
+ */
+static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
+{
+	frag->page_offset += delta;
+}
+
+/**
+ * skb_frag_off_set() - Sets the offset of a skb fragment
+ * @frag: skb fragment
+ * @offset: offset of fragment
+ */
+static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
+{
+	frag->page_offset = offset;
+}
+
+/**
+ * skb_frag_off_copy() - Sets the offset of a skb fragment from another fragment
+ * @fragto: skb fragment where offset is set
+ * @fragfrom: skb fragment offset is copied from
+ */
+static inline void skb_frag_off_copy(skb_frag_t *fragto,
+				     const skb_frag_t *fragfrom)
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
+ * skb_frag_page_copy() - sets the page in a fragment from another fragment
+ * @fragto: skb fragment where page is set
+ * @fragfrom: skb fragment page is copied from
+ */
+static inline void skb_frag_page_copy(skb_frag_t *fragto,
+				      const skb_frag_t *fragfrom)
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

