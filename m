Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8124A46B69C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhLGJI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:08:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9774 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233445AbhLGJIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:08:53 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B78HiGY007292;
        Tue, 7 Dec 2021 09:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pWr8llCGRHAH4wspFk/vZAsqni6mmMmJJmxPhP7Oz8o=;
 b=drGheSdwSvksuzHBzSPKQnWO5yGhWfampFuUGu/TIP2BNwzlUjGv3j4YUqYVyPVKWC5R
 Vg2uY6d8S5LfPBfVkw/QW5FFQCDcPAxzjM1M15otYs9k98vZamm4kcwTTOK2koo4FHkW
 WMFRHNfkddfmJkwnd0PgAA+BIXU11KQPlduNl2OQGAbPOzewYXMfpHmDoNZkUN1/4I8r
 JZYAI47GmFRFyeQohdu5VV7OoV3kO7mOBvH28tjo/vdMFzYZhbABV4CXHqBSp7aWJjvA
 TyXTXyMj0hHdfMwLmIFy4+fOVnNsWxxheM7pim1CTISWF32U9m9OaRDCEbdv6m0x1mVW +Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct3ysgv2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B792mIx013826;
        Tue, 7 Dec 2021 09:05:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykj4hkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B79581g20185508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 09:05:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2ABE42052;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFF014204D;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 71FA1E07D8; Tue,  7 Dec 2021 10:05:08 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 1/5] s390/qeth: simplify qeth_receive_skb()
Date:   Tue,  7 Dec 2021 10:04:48 +0100
Message-Id: <20211207090452.1155688-2-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207090452.1155688-1-wintera@linux.ibm.com>
References: <20211207090452.1155688-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hAX6lan8pL6FUiwlVvZB9QMfmmCywiBa
X-Proofpoint-GUID: hAX6lan8pL6FUiwlVvZB9QMfmmCywiBa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Now that the OSN code is gone, we don't need the second switch statement
in the RX path. And getting rid of its (unreachable) default case is a
nice simplification.

Also don't pass in the full HW header, all we still need is a flag to
indicate whether the skb can use CSO. This we can already obtain during
the first peek at the HW header.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 34 +++++++++++--------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d32aa8b705db..629a7f5c4d71 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5575,29 +5575,9 @@ static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
 #endif
 
 static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
-			     struct qeth_hdr *hdr, bool uses_frags)
+			     bool uses_frags, bool is_cso)
 {
 	struct napi_struct *napi = &card->napi;
-	bool is_cso;
-
-	switch (hdr->hdr.l2.id) {
-#if IS_ENABLED(CONFIG_QETH_L3)
-	case QETH_HEADER_TYPE_LAYER3:
-		qeth_l3_rebuild_skb(card, skb, hdr);
-		is_cso = hdr->hdr.l3.ext_flags & QETH_HDR_EXT_CSUM_TRANSP_REQ;
-		break;
-#endif
-	case QETH_HEADER_TYPE_LAYER2:
-		is_cso = hdr->hdr.l2.flags[1] & QETH_HDR_EXT_CSUM_TRANSP_REQ;
-		break;
-	default:
-		/* never happens */
-		if (uses_frags)
-			napi_free_frags(napi);
-		else
-			kfree_skb(skb);
-		return;
-	}
 
 	if (is_cso && (card->dev->features & NETIF_F_RXCSUM)) {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -5654,6 +5634,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 	struct qeth_hdr *hdr;
 	struct sk_buff *skb;
 	int skb_len = 0;
+	bool is_cso;
 
 	element = &buffer->element[*element_no];
 
@@ -5673,11 +5654,15 @@ static int qeth_extract_skb(struct qeth_card *card,
 	switch (hdr->hdr.l2.id) {
 	case QETH_HEADER_TYPE_LAYER2:
 		skb_len = hdr->hdr.l2.pkt_length;
+		is_cso = hdr->hdr.l2.flags[1] & QETH_HDR_EXT_CSUM_TRANSP_REQ;
+
 		linear_len = ETH_HLEN;
 		headroom = 0;
 		break;
 	case QETH_HEADER_TYPE_LAYER3:
 		skb_len = hdr->hdr.l3.length;
+		is_cso = hdr->hdr.l3.ext_flags & QETH_HDR_EXT_CSUM_TRANSP_REQ;
+
 		if (!IS_LAYER3(card)) {
 			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 			goto walk_packet;
@@ -5804,7 +5789,12 @@ static int qeth_extract_skb(struct qeth_card *card,
 	*element_no = element - &buffer->element[0];
 	*__offset = offset;
 
-	qeth_receive_skb(card, skb, hdr, uses_frags);
+#if IS_ENABLED(CONFIG_QETH_L3)
+	if (hdr->hdr.l2.id == QETH_HEADER_TYPE_LAYER3)
+		qeth_l3_rebuild_skb(card, skb, hdr);
+#endif
+
+	qeth_receive_skb(card, skb, uses_frags, is_cso);
 	return 0;
 }
 
-- 
2.32.0

