Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE85850C
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfF0PBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:01:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbfF0PBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:01:46 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5REwRUC078337
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:01:45 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcyf9jjus-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:01:45 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:42 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:40 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1cvH37224532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96D8BA405F;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CAE9A4064;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 10/12] s390/qeth: consolidate skb RX processing in L3 driver
Date:   Thu, 27 Jun 2019 17:01:31 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0028-0000-0000-0000037E418D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0029-0000-0000-0000243E6C3A
Message-Id: <20190627150133.58746-11-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=749 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_gro_receive() to pass up all types of packets that a L3 device
may receive.
1) For proper L2 packets received by the IQD sniffer, this is the
   obvious thing to do.
2) For af_iucv (which doesn't provide a GRO assist), the GRO code will
   transparently fall back to netif_receive_skb(). So there's no need to
   special-case this traffic in our code.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 44a602aa12ec..15351922b209 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1312,6 +1312,15 @@ static int qeth_l3_vlan_rx_kill_vid(struct net_device *dev,
 static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
 				struct qeth_hdr *hdr)
 {
+	struct af_iucv_trans_hdr *iucv = (struct af_iucv_trans_hdr *) skb->data;
+	struct net_device *dev = skb->dev;
+
+	if (IS_IQD(card) && iucv->magic == ETH_P_AF_IUCV) {
+		dev_hard_header(skb, dev, ETH_P_AF_IUCV, dev->dev_addr,
+				"FAKELL", skb->len);
+		return;
+	}
+
 	if (!(hdr->hdr.l3.flags & QETH_HDR_PASSTHRU)) {
 		u16 prot = (hdr->hdr.l3.flags & QETH_HDR_IPV6) ? ETH_P_IPV6 :
 								 ETH_P_IP;
@@ -1345,8 +1354,6 @@ static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
 				tg_addr, "FAKELL", skb->len);
 	}
 
-	skb->protocol = eth_type_trans(skb, card->dev);
-
 	/* copy VLAN tag from hdr into skb */
 	if (!card->options.sniffer &&
 	    (hdr->hdr.l3.ext_flags & (QETH_HDR_EXT_VLAN_FRAME |
@@ -1363,12 +1370,10 @@ static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
 static int qeth_l3_process_inbound_buffer(struct qeth_card *card,
 				int budget, int *done)
 {
-	struct net_device *dev = card->dev;
 	int work_done = 0;
 	struct sk_buff *skb;
 	struct qeth_hdr *hdr;
 	unsigned int len;
-	__u16 magic;
 
 	*done = 0;
 	WARN_ON_ONCE(!budget);
@@ -1382,23 +1387,12 @@ static int qeth_l3_process_inbound_buffer(struct qeth_card *card,
 		}
 		switch (hdr->hdr.l3.id) {
 		case QETH_HEADER_TYPE_LAYER3:
-			magic = *(__u16 *)skb->data;
-			if (IS_IQD(card) && magic == ETH_P_AF_IUCV) {
-				len = skb->len;
-				dev_hard_header(skb, dev, ETH_P_AF_IUCV,
-						dev->dev_addr, "FAKELL", len);
-				skb->protocol = eth_type_trans(skb, dev);
-				netif_receive_skb(skb);
-			} else {
-				qeth_l3_rebuild_skb(card, skb, hdr);
-				len = skb->len;
-				napi_gro_receive(&card->napi, skb);
-			}
-			break;
+			qeth_l3_rebuild_skb(card, skb, hdr);
+			/* fall through */
 		case QETH_HEADER_TYPE_LAYER2: /* for HiperSockets sniffer */
 			skb->protocol = eth_type_trans(skb, skb->dev);
 			len = skb->len;
-			netif_receive_skb(skb);
+			napi_gro_receive(&card->napi, skb);
 			break;
 		default:
 			dev_kfree_skb_any(skb);
-- 
2.17.1

