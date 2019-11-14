Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6068FC3E0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfKNKTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbfKNKTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:35 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAII0j018326
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:34 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w94yk05f2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:33 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:31 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:30 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJS6O20775026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 867FBA4040;
        Thu, 14 Nov 2019 10:19:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53DE0A4057;
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
Subject: [PATCH net-next 01/11] s390/qeth: gather more detailed RX dropped/error statistics
Date:   Thu, 14 Nov 2019 11:19:14 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0028-0000-0000-000003B6CD19
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0029-0000-0000-00002479D96C
Message-Id: <20191114101924.29558-2-jwi@linux.ibm.com>
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

Where available, use the fine-grained counters in rtnl_link_stats64 to
indicate different RX error causes. For drop reasons, use driver-private
ethtool counters.

In particular this patch allows us to keep track of driver-side drops due
to unknown/unsupported HW descriptor format.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  7 +++++--
 drivers/s390/net/qeth_core_main.c | 17 +++++++++++------
 drivers/s390/net/qeth_ethtool.c   |  2 ++
 drivers/s390/net/qeth_l2_main.c   |  1 +
 drivers/s390/net/qeth_l3_main.c   |  1 +
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index d08154502b15..14edc892f7c1 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -477,12 +477,15 @@ struct qeth_card_stats {
 	u64 rx_sg_frags;
 	u64 rx_sg_alloc_page;
 
+	u64 rx_dropped_nomem;
+	u64 rx_dropped_notsupp;
+
 	/* rtnl_link_stats64 */
 	u64 rx_packets;
 	u64 rx_bytes;
-	u64 rx_errors;
-	u64 rx_dropped;
 	u64 rx_multicast;
+	u64 rx_length_errors;
+	u64 rx_fifo_errors;
 };
 
 struct qeth_out_q_stats {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9e8bd8e08146..4e113f359be9 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3093,7 +3093,7 @@ static int qeth_check_qdio_errors(struct qeth_card *card,
 			       buf->element[14].sflags);
 		QETH_CARD_TEXT_(card, 2, " qerr=%X", qdio_error);
 		if ((buf->element[15].sflags) == 0x12) {
-			QETH_CARD_STAT_INC(card, rx_dropped);
+			QETH_CARD_STAT_INC(card, rx_fifo_errors);
 			return 0;
 		} else
 			return 1;
@@ -4346,7 +4346,7 @@ static int qeth_mdio_read(struct net_device *dev, int phy_id, int regnum)
 	case MII_NWAYTEST: /* N-way auto-neg test register */
 		break;
 	case MII_RERRCOUNTER: /* rx error counter */
-		rc = card->stats.rx_errors;
+		rc = card->stats.rx_length_errors + card->stats.rx_fifo_errors;
 		break;
 	case MII_SREVISION: /* silicon revision */
 		break;
@@ -5092,6 +5092,7 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		headroom = sizeof(struct qeth_hdr);
 		break;
 	default:
+		QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 		break;
 	}
 
@@ -5134,7 +5135,7 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 				QETH_CARD_TEXT(card, 4, "unexeob");
 				QETH_CARD_HEX(card, 2, buffer, sizeof(void *));
 				dev_kfree_skb_any(skb);
-				QETH_CARD_STAT_INC(card, rx_errors);
+				QETH_CARD_STAT_INC(card, rx_length_errors);
 				return NULL;
 			}
 			element++;
@@ -5156,7 +5157,7 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 	if (net_ratelimit()) {
 		QETH_CARD_TEXT(card, 2, "noskbmem");
 	}
-	QETH_CARD_STAT_INC(card, rx_dropped);
+	QETH_CARD_STAT_INC(card, rx_dropped_nomem);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(qeth_core_get_next_skb);
@@ -6236,9 +6237,13 @@ void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 	stats->rx_packets = card->stats.rx_packets;
 	stats->rx_bytes = card->stats.rx_bytes;
-	stats->rx_errors = card->stats.rx_errors;
-	stats->rx_dropped = card->stats.rx_dropped;
+	stats->rx_errors = card->stats.rx_length_errors +
+			   card->stats.rx_fifo_errors;
+	stats->rx_dropped = card->stats.rx_dropped_nomem +
+			    card->stats.rx_dropped_notsupp;
 	stats->multicast = card->stats.rx_multicast;
+	stats->rx_length_errors = card->stats.rx_length_errors;
+	stats->rx_fifo_errors = card->stats.rx_fifo_errors;
 
 	for (i = 0; i < card->qdio.no_out_queues; i++) {
 		queue = card->qdio.out_qs[i];
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 096698df3886..f7485c6dea25 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -49,6 +49,8 @@ static const struct qeth_stats card_stats[] = {
 	QETH_CARD_STAT("rx0 SG skbs", rx_sg_skbs),
 	QETH_CARD_STAT("rx0 SG page frags", rx_sg_frags),
 	QETH_CARD_STAT("rx0 SG page allocs", rx_sg_alloc_page),
+	QETH_CARD_STAT("rx0 dropped, no memory", rx_dropped_nomem),
+	QETH_CARD_STAT("rx0 dropped, bad format", rx_dropped_notsupp),
 };
 
 #define TXQ_STATS_LEN	ARRAY_SIZE(txq_stats)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 8f3093d24b12..1e85956f95c6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -336,6 +336,7 @@ static int qeth_l2_process_inbound_buffer(struct qeth_card *card,
 			dev_kfree_skb_any(skb);
 			QETH_CARD_TEXT(card, 3, "inbunkno");
 			QETH_DBF_HEX(CTRL, 3, hdr, sizeof(*hdr));
+			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 			continue;
 		}
 		work_done++;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 70d4586dc779..72c61faae3f9 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1391,6 +1391,7 @@ static int qeth_l3_process_inbound_buffer(struct qeth_card *card,
 			dev_kfree_skb_any(skb);
 			QETH_CARD_TEXT(card, 3, "inbunkno");
 			QETH_DBF_HEX(CTRL, 3, hdr, sizeof(*hdr));
+			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
 			continue;
 		}
 		work_done++;
-- 
2.17.1

