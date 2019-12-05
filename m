Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE2A114186
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfLENdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:33:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729099AbfLENdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:33:45 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB5DMLSS081036
        for <netdev@vger.kernel.org>; Thu, 5 Dec 2019 08:33:44 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wkrj84455-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 08:33:42 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 5 Dec 2019 13:33:23 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Dec 2019 13:33:20 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB5DXIQ854132852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Dec 2019 13:33:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 983A811C04A;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56BCE11C05C;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/3] s390/qeth: ensure linear access to packet headers
Date:   Thu,  5 Dec 2019 14:33:03 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205133304.58895-1-jwi@linux.ibm.com>
References: <20191205133304.58895-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19120513-4275-0000-0000-0000038BC0C9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120513-4276-0000-0000-0000389F6609
Message-Id: <20191205133304.58895-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_03:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912050113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the RX path builds non-linear skbs, the packet headers can
currently spill over into page fragments. Depending on the packet type
and what fields we need to access in the headers, this could cause us
to go past the end of skb->data.

So for non-linear packets, copy precisely the length of the necessary
headers ('linear_len') into skb->data.
And don't copy more, upper-level protocols will peel whatever additional
packet headers they need.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 64 +++++++++++++++----------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 7285484212de..634913112441 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5028,27 +5028,15 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 }
 EXPORT_SYMBOL_GPL(qeth_core_hardsetup_card);
 
-static void qeth_create_skb_frag(struct qdio_buffer_element *element,
-				 struct sk_buff *skb, int offset, int data_len)
+static void qeth_create_skb_frag(struct sk_buff *skb, char *data, int data_len)
 {
-	struct page *page = virt_to_page(element->addr);
+	struct page *page = virt_to_page(data);
 	unsigned int next_frag;
 
-	/* first fill the linear space */
-	if (!skb->len) {
-		unsigned int linear = min(data_len, skb_tailroom(skb));
-
-		skb_put_data(skb, element->addr + offset, linear);
-		data_len -= linear;
-		if (!data_len)
-			return;
-		offset += linear;
-		/* fall through to add page frag for remaining data */
-	}
-
 	next_frag = skb_shinfo(skb)->nr_frags;
 	get_page(page);
-	skb_add_rx_frag(skb, next_frag, page, offset, data_len, data_len);
+	skb_add_rx_frag(skb, next_frag, page, offset_in_page(data), data_len,
+			data_len);
 }
 
 static inline int qeth_is_last_sbale(struct qdio_buffer_element *sbale)
@@ -5063,13 +5051,12 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 {
 	struct qdio_buffer_element *element = *__element;
 	struct qdio_buffer *buffer = qethbuffer->buffer;
-	unsigned int headroom, linear_len;
+	unsigned int linear_len = 0;
 	int offset = *__offset;
 	bool use_rx_sg = false;
+	unsigned int headroom;
 	struct sk_buff *skb;
 	int skb_len = 0;
-	void *data_ptr;
-	int data_len;
 
 next_packet:
 	/* qeth_hdr must not cross element boundaries */
@@ -5144,9 +5131,9 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		skb = qethbuffer->rx_skb;
 		qethbuffer->rx_skb = NULL;
 	} else {
-		unsigned int linear = (use_rx_sg) ? QETH_RX_PULL_LEN : skb_len;
-
-		skb = napi_alloc_skb(&card->napi, linear + headroom);
+		if (!use_rx_sg)
+			linear_len = skb_len;
+		skb = napi_alloc_skb(&card->napi, linear_len + headroom);
 	}
 
 	if (!skb)
@@ -5155,18 +5142,32 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		skb_reserve(skb, headroom);
 
 walk_packet:
-	data_ptr = element->addr + offset;
 	while (skb_len) {
-		data_len = min(skb_len, (int)(element->length - offset));
+		int data_len = min(skb_len, (int)(element->length - offset));
+		char *data = element->addr + offset;
+
+		skb_len -= data_len;
+		offset += data_len;
 
+		/* Extract data from current element: */
 		if (skb && data_len) {
-			if (use_rx_sg)
-				qeth_create_skb_frag(element, skb, offset,
-						     data_len);
-			else
-				skb_put_data(skb, data_ptr, data_len);
+			if (linear_len) {
+				unsigned int copy_len;
+
+				copy_len = min_t(unsigned int, linear_len,
+						 data_len);
+
+				skb_put_data(skb, data, copy_len);
+				linear_len -= copy_len;
+				data_len -= copy_len;
+				data += copy_len;
+			}
+
+			if (data_len)
+				qeth_create_skb_frag(skb, data, data_len);
 		}
-		skb_len -= data_len;
+
+		/* Step forward to next element: */
 		if (skb_len) {
 			if (qeth_is_last_sbale(element)) {
 				QETH_CARD_TEXT(card, 4, "unexeob");
@@ -5180,9 +5181,6 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 			}
 			element++;
 			offset = 0;
-			data_ptr = element->addr;
-		} else {
-			offset += data_len;
 		}
 	}
 
-- 
2.17.1

