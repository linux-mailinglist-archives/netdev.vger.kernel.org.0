Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5246B693
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhLGJIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:08:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233434AbhLGJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:08:47 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B78rYds014783;
        Tue, 7 Dec 2021 09:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OB3DiaHyyTxkrFY6saA072dhUDqAvokAoqy3roQQpLU=;
 b=gctEI2ruOLNoE2dfv3miPUtvbb9OvTDXKIZnfxdjQriV/qgtjK/yhR2bxNYmQVxL6m18
 LIpF4dj+tKiYg9pC31L37i6Sf6z+TxlyJ2xp+bDxw1NnWXnBdQ2M/kFMQBeRcLRbR+1w
 /cG4r/pIDScVN/v2JfsemFrC0RN82Hb7Iw7REtSSzMoQLDCf3BMvbqWfJ5EpxmLANuvq
 iIgkd7EAig6ayjgEhwb1ZaYQlE0LIBJQwWpqxKvpXIg2FdW+Gb5sYckT8cMlNQt7FZhW
 E8O6SvzbYB4l7yRlmDmr98tcEl4iJwI/XkRoCPKcGVPLmCTQDqFH9OlvwNYDIgaqK0jr sw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct4gg06xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B791oEW000333;
        Tue, 7 Dec 2021 09:05:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyy9ve8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B79596p22086138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 09:05:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E874EA4065;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D952EA405B;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 792B1E128D; Tue,  7 Dec 2021 10:05:08 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 4/5] s390/qeth: fine-tune .ndo_select_queue()
Date:   Tue,  7 Dec 2021 10:04:51 +0100
Message-Id: <20211207090452.1155688-5-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207090452.1155688-1-wintera@linux.ibm.com>
References: <20211207090452.1155688-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uFbCptEWD9Qc8fXIeIVk4BOxZeykJjM6
X-Proofpoint-GUID: uFbCptEWD9Qc8fXIeIVk4BOxZeykJjM6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 mlxlogscore=752 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Avoid a conditional branch for L2 devices when selecting the TX queue,
and have shared logic for OSA devices.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  4 ++--
 drivers/s390/net/qeth_core_main.c | 15 +++++++++++++--
 drivers/s390/net/qeth_l2_main.c   | 20 ++++++--------------
 drivers/s390/net/qeth_l3_main.c   | 13 +------------
 4 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 20dca4c0384a..de25d7ac41da 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1030,8 +1030,6 @@ static inline int qeth_send_simple_setassparms_v6(struct qeth_card *card,
 						 data, QETH_PROT_IPV6);
 }
 
-int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb);
-
 extern const struct qeth_discipline qeth_l2_discipline;
 extern const struct qeth_discipline qeth_l3_discipline;
 extern const struct ethtool_ops qeth_ethtool_ops;
@@ -1099,6 +1097,8 @@ void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
 int qeth_set_real_num_tx_queues(struct qeth_card *card, unsigned int count);
 u16 qeth_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
 			  u8 cast_type, struct net_device *sb_dev);
+u16 qeth_osa_select_queue(struct net_device *dev, struct sk_buff *skb,
+			  struct net_device *sb_dev);
 int qeth_open(struct net_device *dev);
 int qeth_stop(struct net_device *dev);
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 629a7f5c4d71..093ee14e8051 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3769,7 +3769,7 @@ static void qeth_qdio_output_handler(struct ccw_device *ccwdev,
 /*
  * Note: Function assumes that we have 4 outbound queues.
  */
-int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb)
+static int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb)
 {
 	struct vlan_ethhdr *veth = vlan_eth_hdr(skb);
 	u8 tos;
@@ -3814,7 +3814,6 @@ int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb)
 	}
 	return card->qdio.default_out_queue;
 }
-EXPORT_SYMBOL_GPL(qeth_get_priority_queue);
 
 /**
  * qeth_get_elements_for_frags() -	find number of SBALEs for skb frags.
@@ -7078,6 +7077,18 @@ u16 qeth_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(qeth_iqd_select_queue);
 
+u16 qeth_osa_select_queue(struct net_device *dev, struct sk_buff *skb,
+			  struct net_device *sb_dev)
+{
+	struct qeth_card *card = dev->ml_priv;
+
+	if (qeth_uses_tx_prio_queueing(card))
+		return qeth_get_priority_queue(card, skb);
+
+	return netdev_pick_tx(dev, skb, sb_dev);
+}
+EXPORT_SYMBOL_GPL(qeth_osa_select_queue);
+
 int qeth_open(struct net_device *dev)
 {
 	struct qeth_card *card = dev->ml_priv;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index d1933c54bfbb..303461d70af3 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -519,19 +519,11 @@ static netdev_tx_t qeth_l2_hard_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static u16 qeth_l2_select_queue(struct net_device *dev, struct sk_buff *skb,
-				struct net_device *sb_dev)
+static u16 qeth_l2_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
+				    struct net_device *sb_dev)
 {
-	struct qeth_card *card = dev->ml_priv;
-
-	if (IS_IQD(card))
-		return qeth_iqd_select_queue(dev, skb,
-					     qeth_get_ether_cast_type(skb),
-					     sb_dev);
-	if (qeth_uses_tx_prio_queueing(card))
-		return qeth_get_priority_queue(card, skb);
-
-	return netdev_pick_tx(dev, skb, sb_dev);
+	return qeth_iqd_select_queue(dev, skb, qeth_get_ether_cast_type(skb),
+				     sb_dev);
 }
 
 static void qeth_l2_set_rx_mode(struct net_device *dev)
@@ -1059,7 +1051,7 @@ static const struct net_device_ops qeth_l2_iqd_netdev_ops = {
 	.ndo_get_stats64	= qeth_get_stats64,
 	.ndo_start_xmit		= qeth_l2_hard_start_xmit,
 	.ndo_features_check	= qeth_features_check,
-	.ndo_select_queue	= qeth_l2_select_queue,
+	.ndo_select_queue	= qeth_l2_iqd_select_queue,
 	.ndo_validate_addr	= qeth_l2_validate_addr,
 	.ndo_set_rx_mode	= qeth_l2_set_rx_mode,
 	.ndo_eth_ioctl		= qeth_do_ioctl,
@@ -1080,7 +1072,7 @@ static const struct net_device_ops qeth_l2_osa_netdev_ops = {
 	.ndo_get_stats64	= qeth_get_stats64,
 	.ndo_start_xmit		= qeth_l2_hard_start_xmit,
 	.ndo_features_check	= qeth_features_check,
-	.ndo_select_queue	= qeth_l2_select_queue,
+	.ndo_select_queue	= qeth_osa_select_queue,
 	.ndo_validate_addr	= qeth_l2_validate_addr,
 	.ndo_set_rx_mode	= qeth_l2_set_rx_mode,
 	.ndo_eth_ioctl		= qeth_do_ioctl,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 48a886f7af62..9251ad276ee8 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1822,17 +1822,6 @@ static u16 qeth_l3_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
 				     qeth_l3_get_cast_type(skb, proto), sb_dev);
 }
 
-static u16 qeth_l3_osa_select_queue(struct net_device *dev, struct sk_buff *skb,
-				    struct net_device *sb_dev)
-{
-	struct qeth_card *card = dev->ml_priv;
-
-	if (qeth_uses_tx_prio_queueing(card))
-		return qeth_get_priority_queue(card, skb);
-
-	return netdev_pick_tx(dev, skb, sb_dev);
-}
-
 static const struct net_device_ops qeth_l3_netdev_ops = {
 	.ndo_open		= qeth_open,
 	.ndo_stop		= qeth_stop,
@@ -1854,7 +1843,7 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_get_stats64	= qeth_get_stats64,
 	.ndo_start_xmit		= qeth_l3_hard_start_xmit,
 	.ndo_features_check	= qeth_l3_osa_features_check,
-	.ndo_select_queue	= qeth_l3_osa_select_queue,
+	.ndo_select_queue	= qeth_osa_select_queue,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
 	.ndo_eth_ioctl		= qeth_do_ioctl,
-- 
2.32.0

