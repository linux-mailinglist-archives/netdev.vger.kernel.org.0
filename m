Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28F412973D
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLWOWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:22:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbfLWOWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:22:36 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNEK0nD127820
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:22:36 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x21bxp7se-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:22:35 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 23 Dec 2019 14:22:33 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Dec 2019 14:22:31 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBNEMTNs34209848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 14:22:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90E794C044;
        Mon, 23 Dec 2019 14:22:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 528A14C040;
        Mon, 23 Dec 2019 14:22:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Dec 2019 14:22:29 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/3] s390/qeth: use napi_gro_frags() for SG skbs
Date:   Mon, 23 Dec 2019 15:22:26 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191223142227.19500-1-jwi@linux.ibm.com>
References: <20191223142227.19500-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19122314-0008-0000-0000-000003439B81
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19122314-0009-0000-0000-00004A63BF1B
Message-Id: <20191223142227.19500-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_06:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For non-linear packets, get the skb for attaching the page fragments
from napi_get_frags() so that it can be recycled during GRO.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 67 +++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 8e2c0588525f..b32b50384c5c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5106,8 +5106,9 @@ static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
 #endif
 
 static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
-			     struct qeth_hdr *hdr)
+			     struct qeth_hdr *hdr, bool uses_frags)
 {
+	struct napi_struct *napi = &card->napi;
 	bool is_cso;
 
 	switch (hdr->hdr.l2.id) {
@@ -5130,7 +5131,10 @@ static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
 		break;
 	default:
 		/* never happens */
-		dev_kfree_skb_any(skb);
+		if (uses_frags)
+			napi_free_frags(napi);
+		else
+			dev_kfree_skb_any(skb);
 		return;
 	}
 
@@ -5141,8 +5145,6 @@ static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
 		skb->ip_summed = CHECKSUM_NONE;
 	}
 
-	skb->protocol = eth_type_trans(skb, skb->dev);
-
 	QETH_CARD_STAT_ADD(card, rx_bytes, skb->len);
 	QETH_CARD_STAT_INC(card, rx_packets);
 	if (skb_is_nonlinear(skb)) {
@@ -5151,7 +5153,12 @@ static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
 				   skb_shinfo(skb)->nr_frags);
 	}
 
-	napi_gro_receive(&card->napi, skb);
+	if (uses_frags) {
+		napi_gro_frags(napi);
+	} else {
+		skb->protocol = eth_type_trans(skb, skb->dev);
+		napi_gro_receive(napi, skb);
+	}
 }
 
 static void qeth_create_skb_frag(struct sk_buff *skb, char *data, int data_len)
@@ -5177,7 +5184,9 @@ static int qeth_extract_skb(struct qeth_card *card,
 {
 	struct qdio_buffer_element *element = *__element;
 	struct qdio_buffer *buffer = qethbuffer->buffer;
+	struct napi_struct *napi = &card->napi;
 	unsigned int linear_len = 0;
+	bool uses_frags = false;
 	int offset = *__offset;
 	bool use_rx_sg = false;
 	unsigned int headroom;
@@ -5253,21 +5262,42 @@ static int qeth_extract_skb(struct qeth_card *card,
 		     !atomic_read(&card->force_alloc_skb) &&
 		     !IS_OSN(card));
 
-	if (use_rx_sg && qethbuffer->rx_skb) {
+	if (use_rx_sg) {
 		/* QETH_CQ_ENABLED only: */
-		skb = qethbuffer->rx_skb;
-		qethbuffer->rx_skb = NULL;
-	} else {
-		if (!use_rx_sg)
-			linear_len = skb_len;
-		skb = napi_alloc_skb(&card->napi, linear_len + headroom);
+		if (qethbuffer->rx_skb) {
+			skb = qethbuffer->rx_skb;
+			qethbuffer->rx_skb = NULL;
+			goto use_skb;
+		}
+
+		skb = napi_get_frags(napi);
+		if (!skb) {
+			/* -ENOMEM, no point in falling back further. */
+			QETH_CARD_STAT_INC(card, rx_dropped_nomem);
+			goto walk_packet;
+		}
+
+		if (skb_tailroom(skb) >= linear_len + headroom) {
+			uses_frags = true;
+			goto use_skb;
+		}
+
+		netdev_info_once(card->dev,
+				 "Insufficient linear space in NAPI frags skb, need %u but have %u\n",
+				 linear_len + headroom, skb_tailroom(skb));
+		/* Shouldn't happen. Don't optimize, fall back to linear skb. */
 	}
 
-	if (!skb)
+	linear_len = skb_len;
+	skb = napi_alloc_skb(napi, linear_len + headroom);
+	if (!skb) {
 		QETH_CARD_STAT_INC(card, rx_dropped_nomem);
-	else if (headroom)
-		skb_reserve(skb, headroom);
+		goto walk_packet;
+	}
 
+use_skb:
+	if (headroom)
+		skb_reserve(skb, headroom);
 walk_packet:
 	while (skb_len) {
 		int data_len = min(skb_len, (int)(element->length - offset));
@@ -5300,7 +5330,10 @@ static int qeth_extract_skb(struct qeth_card *card,
 				QETH_CARD_TEXT(card, 4, "unexeob");
 				QETH_CARD_HEX(card, 2, buffer, sizeof(void *));
 				if (skb) {
-					dev_kfree_skb_any(skb);
+					if (uses_frags)
+						napi_free_frags(napi);
+					else
+						dev_kfree_skb_any(skb);
 					QETH_CARD_STAT_INC(card,
 							   rx_length_errors);
 				}
@@ -5318,7 +5351,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 	*__element = element;
 	*__offset = offset;
 
-	qeth_receive_skb(card, skb, hdr);
+	qeth_receive_skb(card, skb, hdr, uses_frags);
 	return 0;
 }
 
-- 
2.17.1

