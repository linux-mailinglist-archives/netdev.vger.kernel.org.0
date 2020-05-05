Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766011C5D87
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgEEQ0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730671AbgEEQ0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:11 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045G3MeP056942;
        Tue, 5 May 2020 12:26:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8snf060-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:26:08 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045GJvB8003105;
        Tue, 5 May 2020 16:26:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5qakv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 16:26:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045GQ30P60293272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 16:26:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96E7542047;
        Tue,  5 May 2020 16:26:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57B4442042;
        Tue,  5 May 2020 16:26:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 16:26:03 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 06/11] s390/qeth: merge TX skb mapping code
Date:   Tue,  5 May 2020 18:25:54 +0200
Message-Id: <20200505162559.14138-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505162559.14138-1-jwi@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_09:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=2 lowpriorityscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the __qeth_fill_buffer() helper into its only caller. This way all
mapping-related context is in one place, and we can make some more use
of it in a subsequent patch.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 64 +++++++++++++------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 1f18b38047a0..9c9a6edb5384 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4081,15 +4081,39 @@ static bool qeth_iqd_may_bulk(struct qeth_qdio_out_q *queue,
 	       qeth_l3_iqd_same_vlan(&prev_hdr->hdr.l3, &curr_hdr->hdr.l3);
 }
 
-static unsigned int __qeth_fill_buffer(struct sk_buff *skb,
-				       struct qeth_qdio_out_buffer *buf,
-				       bool is_first_elem, unsigned int offset)
+/**
+ * qeth_fill_buffer() - map skb into an output buffer
+ * @buf:	buffer to transport the skb
+ * @skb:	skb to map into the buffer
+ * @hdr:	qeth_hdr for this skb. Either at skb->data, or allocated
+ *		from qeth_core_header_cache.
+ * @offset:	when mapping the skb, start at skb->data + offset
+ * @hd_len:	if > 0, build a dedicated header element of this size
+ */
+static unsigned int qeth_fill_buffer(struct qeth_qdio_out_buffer *buf,
+				     struct sk_buff *skb, struct qeth_hdr *hdr,
+				     unsigned int offset, unsigned int hd_len)
 {
 	struct qdio_buffer *buffer = buf->buffer;
 	int element = buf->next_element_to_fill;
 	int length = skb_headlen(skb) - offset;
 	char *data = skb->data + offset;
 	unsigned int elem_length, cnt;
+	bool is_first_elem = true;
+
+	__skb_queue_tail(&buf->skb_list, skb);
+
+	/* build dedicated element for HW Header */
+	if (hd_len) {
+		is_first_elem = false;
+
+		buffer->element[element].addr = virt_to_phys(hdr);
+		buffer->element[element].length = hd_len;
+		buffer->element[element].eflags = SBAL_EFLAGS_FIRST_FRAG;
+		/* remember to free cache-allocated HW header: */
+		buf->is_header[element] = ((void *)hdr != skb->data);
+		element++;
+	}
 
 	/* map linear part into buffer element(s) */
 	while (length > 0) {
@@ -4143,40 +4167,6 @@ static unsigned int __qeth_fill_buffer(struct sk_buff *skb,
 	return element;
 }
 
-/**
- * qeth_fill_buffer() - map skb into an output buffer
- * @buf:	buffer to transport the skb
- * @skb:	skb to map into the buffer
- * @hdr:	qeth_hdr for this skb. Either at skb->data, or allocated
- *		from qeth_core_header_cache.
- * @offset:	when mapping the skb, start at skb->data + offset
- * @hd_len:	if > 0, build a dedicated header element of this size
- */
-static unsigned int qeth_fill_buffer(struct qeth_qdio_out_buffer *buf,
-				     struct sk_buff *skb, struct qeth_hdr *hdr,
-				     unsigned int offset, unsigned int hd_len)
-{
-	struct qdio_buffer *buffer = buf->buffer;
-	bool is_first_elem = true;
-
-	__skb_queue_tail(&buf->skb_list, skb);
-
-	/* build dedicated header element */
-	if (hd_len) {
-		int element = buf->next_element_to_fill;
-		is_first_elem = false;
-
-		buffer->element[element].addr = virt_to_phys(hdr);
-		buffer->element[element].length = hd_len;
-		buffer->element[element].eflags = SBAL_EFLAGS_FIRST_FRAG;
-		/* remember to free cache-allocated qeth_hdr: */
-		buf->is_header[element] = ((void *)hdr != skb->data);
-		buf->next_element_to_fill++;
-	}
-
-	return __qeth_fill_buffer(skb, buf, is_first_elem, offset);
-}
-
 static int __qeth_xmit(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 		       struct sk_buff *skb, unsigned int elements,
 		       struct qeth_hdr *hdr, unsigned int offset,
-- 
2.17.1

