Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805D5FC40A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfKNKYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:24:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbfKNKYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:24:11 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAL8lG076311
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:24:09 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w92a5pfdw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:22:15 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:34 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:31 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAIrlU12583308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:18:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70225A4055;
        Thu, 14 Nov 2019 10:19:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34278A4065;
        Thu, 14 Nov 2019 10:19:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 10:19:29 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 04/11] s390/qeth: handle skb allocation error gracefully
Date:   Thu, 14 Nov 2019 11:19:17 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0028-0000-0000-000003B6CD1C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0029-0000-0000-00002479D96D
Message-Id: <20191114101924.29558-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When current code fails to allocate an skb in the RX path, it drops the
whole RX buffer. Considering the large number of packets that a single
RX buffer might contain, this is quite drastic.

Skip over the packet instead, and try to extract the next packet from
the RX buffer.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 467a9173058c..08185f76a727 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5065,12 +5065,12 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	struct qdio_buffer_element *element = *__element;
 	struct qdio_buffer *buffer = qethbuffer->buffer;
 	int offset = *__offset;
+	bool use_rx_sg = false;
+	unsigned int headroom;
 	struct sk_buff *skb;
 	int skb_len = 0;
 	void *data_ptr;
 	int data_len;
-	int headroom = 0;
-	int use_rx_sg = 0;
 
 next_packet:
 	/* qeth_hdr must not cross element boundaries */
@@ -5086,6 +5086,7 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	switch ((*hdr)->hdr.l2.id) {
 	case QETH_HEADER_TYPE_LAYER2:
 		skb_len = (*hdr)->hdr.l2.pkt_length;
+		headroom = 0;
 		break;
 	case QETH_HEADER_TYPE_LAYER3:
 		skb_len = (*hdr)->hdr.l3.length;
@@ -5120,11 +5121,10 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	if (!skb_len)
 		return NULL;
 
-	if (((skb_len >= card->options.rx_sg_cb) &&
-	     !IS_OSN(card) &&
-	     (!atomic_read(&card->force_alloc_skb))) ||
-	    (card->options.cq == QETH_CQ_ENABLED))
-		use_rx_sg = 1;
+	use_rx_sg = (card->options.cq == QETH_CQ_ENABLED) ||
+		    ((skb_len >= card->options.rx_sg_cb) &&
+		     !atomic_read(&card->force_alloc_skb) &&
+		     !IS_OSN(card));
 
 	if (use_rx_sg && qethbuffer->rx_skb) {
 		/* QETH_CQ_ENABLED only: */
@@ -5135,9 +5135,10 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 
 		skb = napi_alloc_skb(&card->napi, linear + headroom);
 	}
+
 	if (!skb)
-		goto no_mem;
-	if (headroom)
+		QETH_CARD_STAT_INC(card, rx_dropped_nomem);
+	else if (headroom)
 		skb_reserve(skb, headroom);
 
 walk_packet:
@@ -5184,12 +5185,6 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 				   skb_shinfo(skb)->nr_frags);
 	}
 	return skb;
-no_mem:
-	if (net_ratelimit()) {
-		QETH_CARD_TEXT(card, 2, "noskbmem");
-	}
-	QETH_CARD_STAT_INC(card, rx_dropped_nomem);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(qeth_core_get_next_skb);
 
-- 
2.17.1

