Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB99FC3ED
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKNKT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726139AbfKNKT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:57 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAIexQ112622
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:56 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91m7ejuf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:54 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:33 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:30 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJSmd20775030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D70A6A406D;
        Thu, 14 Nov 2019 10:19:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B7A0A4051;
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
Subject: [PATCH net-next 02/11] s390/qeth: support per-frame invalidation
Date:   Thu, 14 Nov 2019 11:19:15 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0012-0000-0000-000003638CA9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0013-0000-0000-0000219F0522
Message-Id: <20191114101924.29558-3-jwi@linux.ibm.com>
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

Each RX buffer may contain up to 64KB worth of data. In case the device
needs to discard a packet _after_ already having reserved space for it
in the buffer, the whole buffer gets set to ERROR state. As the buffer
might contain any number of good packets, this can result in collateral
packet loss.

qeth can provide relief by enabling per-frame invalidation. The RX
buffer is then presented as usual, we just need to spot & drop any
individual packet that was flagged as invalid.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 ++
 drivers/s390/net/qeth_core_main.c | 13 +++++++++++--
 drivers/s390/net/qeth_core_mpc.h  |  1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 14edc892f7c1..52fd3c4bb132 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -368,6 +368,7 @@ enum qeth_header_ids {
 	QETH_HEADER_TYPE_L3_TSO	= 0x03,
 	QETH_HEADER_TYPE_OSN    = 0x04,
 	QETH_HEADER_TYPE_L2_TSO	= 0x06,
+	QETH_HEADER_MASK_INVAL	= 0x80,
 };
 /* flags for qeth_hdr.ext_flags */
 #define QETH_HDR_EXT_VLAN_FRAME       0x01
@@ -485,6 +486,7 @@ struct qeth_card_stats {
 	u64 rx_bytes;
 	u64 rx_multicast;
 	u64 rx_length_errors;
+	u64 rx_frame_errors;
 	u64 rx_fifo_errors;
 };
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 4e113f359be9..c52241df980b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1956,6 +1956,7 @@ static void qeth_idx_setup_activate_cmd(struct qeth_card *card,
 	ccw_device_get_id(CARD_DDEV(card), &dev_id);
 	iob->finalize = qeth_idx_finalize_cmd;
 
+	port |= QETH_IDX_ACT_INVAL_FRAME;
 	memcpy(QETH_IDX_ACT_PNO(iob->data), &port, 1);
 	memcpy(QETH_IDX_ACT_ISSUER_RM_TOKEN(iob->data),
 	       &card->token.issuer_rm_w, QETH_MPC_TOKEN_LENGTH);
@@ -4346,7 +4347,9 @@ static int qeth_mdio_read(struct net_device *dev, int phy_id, int regnum)
 	case MII_NWAYTEST: /* N-way auto-neg test register */
 		break;
 	case MII_RERRCOUNTER: /* rx error counter */
-		rc = card->stats.rx_length_errors + card->stats.rx_fifo_errors;
+		rc = card->stats.rx_length_errors +
+		     card->stats.rx_frame_errors +
+		     card->stats.rx_fifo_errors;
 		break;
 	case MII_SREVISION: /* silicon revision */
 		break;
@@ -5092,7 +5095,11 @@ struct sk_buff *qeth_core_get_next_skb(struct qeth_card *card,
 		headroom = sizeof(struct qeth_hdr);
 		break;
 	default:
-		QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
+		if ((*hdr)->hdr.l2.id & QETH_HEADER_MASK_INVAL)
+			QETH_CARD_STAT_INC(card, rx_frame_errors);
+		else
+			QETH_CARD_STAT_INC(card, rx_dropped_notsupp);
+
 		break;
 	}
 
@@ -6238,11 +6245,13 @@ void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_packets = card->stats.rx_packets;
 	stats->rx_bytes = card->stats.rx_bytes;
 	stats->rx_errors = card->stats.rx_length_errors +
+			   card->stats.rx_frame_errors +
 			   card->stats.rx_fifo_errors;
 	stats->rx_dropped = card->stats.rx_dropped_nomem +
 			    card->stats.rx_dropped_notsupp;
 	stats->multicast = card->stats.rx_multicast;
 	stats->rx_length_errors = card->stats.rx_length_errors;
+	stats->rx_frame_errors = card->stats.rx_frame_errors;
 	stats->rx_fifo_errors = card->stats.rx_fifo_errors;
 
 	for (i = 0; i < card->qdio.no_out_queues; i++) {
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 9ad0d6f9d48b..53fcf6641154 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -900,6 +900,7 @@ extern unsigned char IDX_ACTIVATE_WRITE[];
 #define IDX_ACTIVATE_SIZE	0x22
 #define QETH_IDX_ACT_PNO(buffer) (buffer+0x0b)
 #define QETH_IDX_ACT_ISSUER_RM_TOKEN(buffer) (buffer + 0x0c)
+#define QETH_IDX_ACT_INVAL_FRAME	0x40
 #define QETH_IDX_NO_PORTNAME_REQUIRED(buffer) ((buffer)[0x0b] & 0x80)
 #define QETH_IDX_ACT_FUNC_LEVEL(buffer) (buffer + 0x10)
 #define QETH_IDX_ACT_DATASET_NAME(buffer) (buffer + 0x16)
-- 
2.17.1

