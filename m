Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD4C1C6B0E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgEFIKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:10:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728707AbgEFIKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:10:00 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04681g8i077692;
        Wed, 6 May 2020 04:09:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8t6nkak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:09:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04686ECF019049;
        Wed, 6 May 2020 08:09:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5rpeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 08:09:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04689rxQ65274112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 08:09:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7D44A405B;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C703A4062;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 06/10] s390/qeth: merge TX skb mapping code
Date:   Wed,  6 May 2020 10:09:45 +0200
Message-Id: <20200506080949.3915-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506080949.3915-1-jwi@linux.ibm.com>
References: <20200506080949.3915-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 suspectscore=2 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 phishscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060058
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

