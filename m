Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C907BFC3F0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKNKUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:20:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727049AbfKNKUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:20:06 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAILfG082428
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:20:05 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w94y20auy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:20:05 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:33 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:31 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAIqQr26345844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:18:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29B6DA405D;
        Thu, 14 Nov 2019 10:19:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E21E2A4053;
        Thu, 14 Nov 2019 10:19:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 10:19:28 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 03/11] s390/qeth: drop unwanted packets earlier in RX path
Date:   Thu, 14 Nov 2019 11:19:16 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0008-0000-0000-0000032EF022
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0009-0000-0000-00004A4DFDFF
Message-Id: <20191114101924.29558-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=890 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets with an unexpected HW format are currently first extracted from
the RX buffer, passed upwards to the layer-specific driver and only then
finally dropped.

Enhance the RX path so that we can drop such packets before even
allocating an skb. For this, add some additional logic so that when a
packet is meant to be dropped, we can still walk along the packet's data
chunks in the RX buffer. This allows us to extract the following
packet(s) from the buffer.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 32 +++++++++++++++++++++++++++----
 drivers/s390/net/qeth_l2_main.c   | 27 ++++++++------------------
 drivers/s390/net/qeth_l3_main.c   | 26 ++++++++-----------------
 3 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index c52241df980b..467a9173058c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5072,6 +5072,7 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	int headroom = 0;
 	int use_rx_sg = 0;
 
+next_packet:
 	/* qeth_hdr must not cross element boundaries */
 	while (element->length < offset + sizeof(struct qeth_hdr)) {
 		if (qeth_is_last_sbale(element))
@@ -5088,10 +5089,22 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		break;
 	case QETH_HEADER_TYPE_LAYER3:
 		skb_len = (*hdr)->hdr.l3.length;
+		if (!IS_LAYER3(card)) {
+			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
+			skb = NULL;
+			goto walk_packet;
+		}
+
 		headroom = ETH_HLEN;
 		break;
 	case QETH_HEADER_TYPE_OSN:
 		skb_len = (*hdr)->hdr.osn.pdu_length;
+		if (!IS_OSN(card)) {
+			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
+			skb = NULL;
+			goto walk_packet;
+		}
+
 		headroom = sizeof(struct qeth_hdr);
 		break;
 	default:
@@ -5100,7 +5113,8 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		else
 			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 
-		break;
+		/* Can't determine packet length, drop the whole buffer. */
+		return NULL;
 	}
 
 	if (!skb_len)
@@ -5126,10 +5140,12 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	if (headroom)
 		skb_reserve(skb, headroom);
 
+walk_packet:
 	data_ptr = element->addr + offset;
 	while (skb_len) {
 		data_len = min(skb_len, (int)(element->length - offset));
-		if (data_len) {
+
+		if (skb && data_len) {
 			if (use_rx_sg)
 				qeth_create_skb_frag(element, skb, offset,
 						     data_len);
@@ -5141,8 +5157,11 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 			if (qeth_is_last_sbale(element)) {
 				QETH_CARD_TEXT(card, 4, "unexeob");
 				QETH_CARD_HEX(card, 2, buffer, sizeof(void *));
-				dev_kfree_skb_any(skb);
-				QETH_CARD_STAT_INC(card, rx_length_errors);
+				if (skb) {
+					dev_kfree_skb_any(skb);
+					QETH_CARD_STAT_INC(card,
+							   rx_length_errors);
+				}
 				return NULL;
 			}
 			element++;
@@ -5152,6 +5171,11 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 			offset += data_len;
 		}
 	}
+
+	/* This packet was skipped, go get another one: */
+	if (!skb)
+		goto next_packet;
+
 	*__element = element;
 	*__offset = offset;
 	if (use_rx_sg) {
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 1e85956f95c6..ae69c981650d 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -315,30 +315,19 @@ static int qeth_l2_process_inbound_buffer(struct qeth_card *card,
 			*done = 1;
 			break;
 		}
-		switch (hdr->hdr.l2.id) {
-		case QETH_HEADER_TYPE_LAYER2:
+
+		if (hdr->hdr.l2.id == QETH_HEADER_TYPE_LAYER2) {
 			skb->protocol = eth_type_trans(skb, skb->dev);
 			qeth_rx_csum(card, skb, hdr->hdr.l2.flags[1]);
 			len = skb->len;
 			napi_gro_receive(&card->napi, skb);
-			break;
-		case QETH_HEADER_TYPE_OSN:
-			if (IS_OSN(card)) {
-				skb_push(skb, sizeof(struct qeth_hdr));
-				skb_copy_to_linear_data(skb, hdr,
-						sizeof(struct qeth_hdr));
-				len = skb->len;
-				card->osn_info.data_cb(skb);
-				break;
-			}
-			/* Else, fall through */
-		default:
-			dev_kfree_skb_any(skb);
-			QETH_CARD_TEXT(card, 3, "inbunkno");
-			QETH_DBF_HEX(CTRL, 3, hdr, sizeof(*hdr));
-			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
-			continue;
+		} else {
+			skb_push(skb, sizeof(*hdr));
+			skb_copy_to_linear_data(skb, hdr, sizeof(*hdr));
+			len = skb->len;
+			card->osn_info.data_cb(skb);
 		}
+
 		work_done++;
 		budget--;
 		QETH_CARD_STAT_INC(card, rx_packets);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 72c61faae3f9..3b901f3676c1 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1366,7 +1366,6 @@ static int qeth_l3_process_inbound_buffer(struct qeth_card *card,
 	int work_done = 0;
 	struct sk_buff *skb;
 	struct qeth_hdr *hdr;
-	unsigned int len;
 
 	*done = 0;
 	WARN_ON_ONCE(!budget);
@@ -1378,26 +1377,17 @@ static int qeth_l3_process_inbound_buffer(struct qeth_card *card,
 			*done = 1;
 			break;
 		}
-		switch (hdr->hdr.l3.id) {
-		case QETH_HEADER_TYPE_LAYER3:
+
+		if (hdr->hdr.l3.id == QETH_HEADER_TYPE_LAYER3)
 			qeth_l3_rebuild_skb(card, skb, hdr);
-			/* fall through */
-		case QETH_HEADER_TYPE_LAYER2: /* for HiperSockets sniffer */
-			skb->protocol = eth_type_trans(skb, skb->dev);
-			len = skb->len;
-			napi_gro_receive(&card->napi, skb);
-			break;
-		default:
-			dev_kfree_skb_any(skb);
-			QETH_CARD_TEXT(card, 3, "inbunkno");
-			QETH_DBF_HEX(CTRL, 3, hdr, sizeof(*hdr));
-			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
-			continue;
-		}
+
+		skb->protocol = eth_type_trans(skb, skb->dev);
+		QETH_CARD_STAT_INC(card, rx_packets);
+		QETH_CARD_STAT_ADD(card, rx_bytes, skb->len);
+
+		napi_gro_receive(&card->napi, skb);
 		work_done++;
 		budget--;
-		QETH_CARD_STAT_INC(card, rx_packets);
-		QETH_CARD_STAT_ADD(card, rx_bytes, len);
 	}
 	return work_done;
 }
-- 
2.17.1

