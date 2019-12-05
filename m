Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0569F114182
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfLENd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:33:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729514AbfLENd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:33:26 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB5DNr6N117337
        for <netdev@vger.kernel.org>; Thu, 5 Dec 2019 08:33:25 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wq1nn3f0c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 08:33:25 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 5 Dec 2019 13:33:23 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Dec 2019 13:33:19 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB5DXIgV54132842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Dec 2019 13:33:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AAC511C050;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0957A11C05B;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Dec 2019 13:33:17 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/3] s390/qeth: guard against runt packets
Date:   Thu,  5 Dec 2019 14:33:02 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205133304.58895-1-jwi@linux.ibm.com>
References: <20191205133304.58895-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19120513-0016-0000-0000-000002D1A1AC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120513-0017-0000-0000-00003333A680
Message-Id: <20191205133304.58895-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_03:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912050113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on a packet's type, the RX path needs to access fields in the
packet headers and thus requires a minimum packet length.
Enforce this length when building the skb.

On the other hand a single runt packet is no reason to drop the whole
RX buffer. So just skip it, and continue processing on the next packet.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c | 27 +++++++++++++++++++++------
 drivers/s390/net/qeth_ethtool.c   |  1 +
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 293dd99b7fef..7cdebd2e329f 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -480,6 +480,7 @@ struct qeth_card_stats {
 
 	u64 rx_dropped_nomem;
 	u64 rx_dropped_notsupp;
+	u64 rx_dropped_runt;
 
 	/* rtnl_link_stats64 */
 	u64 rx_packets;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index efcbe60220d1..7285484212de 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5063,9 +5063,9 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 {
 	struct qdio_buffer_element *element = *__element;
 	struct qdio_buffer *buffer = qethbuffer->buffer;
+	unsigned int headroom, linear_len;
 	int offset = *__offset;
 	bool use_rx_sg = false;
-	unsigned int headroom;
 	struct sk_buff *skb;
 	int skb_len = 0;
 	void *data_ptr;
@@ -5082,29 +5082,41 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	*hdr = element->addr + offset;
 
 	offset += sizeof(struct qeth_hdr);
+	skb = NULL;
+
 	switch ((*hdr)->hdr.l2.id) {
 	case QETH_HEADER_TYPE_LAYER2:
 		skb_len = (*hdr)->hdr.l2.pkt_length;
+		linear_len = ETH_HLEN;
 		headroom = 0;
 		break;
 	case QETH_HEADER_TYPE_LAYER3:
 		skb_len = (*hdr)->hdr.l3.length;
 		if (!IS_LAYER3(card)) {
 			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
-			skb = NULL;
 			goto walk_packet;
 		}
 
+		if ((*hdr)->hdr.l3.flags & QETH_HDR_PASSTHRU) {
+			linear_len = ETH_HLEN;
+			headroom = 0;
+			break;
+		}
+
+		if ((*hdr)->hdr.l3.flags & QETH_HDR_IPV6)
+			linear_len = sizeof(struct ipv6hdr);
+		else
+			linear_len = sizeof(struct iphdr);
 		headroom = ETH_HLEN;
 		break;
 	case QETH_HEADER_TYPE_OSN:
 		skb_len = (*hdr)->hdr.osn.pdu_length;
 		if (!IS_OSN(card)) {
 			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
-			skb = NULL;
 			goto walk_packet;
 		}
 
+		linear_len = skb_len;
 		headroom = sizeof(struct qeth_hdr);
 		break;
 	default:
@@ -5117,8 +5129,10 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		return NULL;
 	}
 
-	if (!skb_len)
-		return NULL;
+	if (skb_len < linear_len) {
+		QETH_CARD_STAT_INC(card, rx_dropped_runt);
+		goto walk_packet;
+	}
 
 	use_rx_sg = (card->options.cq == QETH_CQ_ENABLED) ||
 		    ((skb_len >= card->options.rx_sg_cb) &&
@@ -6268,7 +6282,8 @@ void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 			   card->stats.rx_frame_errors +
 			   card->stats.rx_fifo_errors;
 	stats->rx_dropped = card->stats.rx_dropped_nomem +
-			    card->stats.rx_dropped_notsupp;
+			    card->stats.rx_dropped_notsupp +
+			    card->stats.rx_dropped_runt;
 	stats->multicast = card->stats.rx_multicast;
 	stats->rx_length_errors = card->stats.rx_length_errors;
 	stats->rx_frame_errors = card->stats.rx_frame_errors;
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index f7485c6dea25..ab59bc975719 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -51,6 +51,7 @@ static const struct qeth_stats card_stats[] = {
 	QETH_CARD_STAT("rx0 SG page allocs", rx_sg_alloc_page),
 	QETH_CARD_STAT("rx0 dropped, no memory", rx_dropped_nomem),
 	QETH_CARD_STAT("rx0 dropped, bad format", rx_dropped_notsupp),
+	QETH_CARD_STAT("rx0 dropped, runt", rx_dropped_runt),
 };
 
 #define TXQ_STATS_LEN	ARRAY_SIZE(txq_stats)
-- 
2.17.1

