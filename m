Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323EC46B695
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhLGJIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:08:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233433AbhLGJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:08:47 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B78bA5X020074;
        Tue, 7 Dec 2021 09:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0umxdDY07IISOHwYhPvKHcGjhA+d4kt1rnAUXSN9niM=;
 b=e+dg5CCTRsXGNhDTCSzgduhEyHz7NpLq1JbhymoyRnmgOWTCzG8Pkvg5Sn6XpUIfEIsk
 P7bUbNVM51jW0wcTZqV6Pfr2uBOTOUzF9JpySlj7R3rF1xf/RnmfP/f3TKE5OkvC+ArM
 zYnmHW6pXg+AHD5VvxssWeTx0yaICwDw/rd5gcikcDViDuctb4LWdCOxpNi2qJh/UOp/
 G1TpieQHQftOGIB75pNuGR8hm4hF9ElXNhYenHd/uJloAM5ItFKZVmA3JwahW/A/73mu
 XvwqtlQsBlTZHJyQkkkLpQjTS/O2leN7VSVnvaw34YfrAGII/UUfbDezZEVY/ZqIsc8R ug== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct1rxus6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:15 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B793lAT011603;
        Tue, 7 Dec 2021 09:05:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3cqyy9ke7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B78vSus26608062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 08:57:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D45494C05E;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CE34C044;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 7463CE1207; Tue,  7 Dec 2021 10:05:08 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 2/5] s390/qeth: split up L2 netdev_ops
Date:   Tue,  7 Dec 2021 10:04:49 +0100
Message-Id: <20211207090452.1155688-3-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207090452.1155688-1-wintera@linux.ibm.com>
References: <20211207090452.1155688-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LBTJGOXFw1T2OzHl166lalS87rM24cf5
X-Proofpoint-ORIG-GUID: LBTJGOXFw1T2OzHl166lalS87rM24cf5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Splitting up the netdev_ops allows for fine-tuning some of the ndo's
in subsequent patches.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 0347fc184786..48355fbc0712 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -726,7 +726,8 @@ struct qeth_l2_br2dev_event_work {
 	unsigned char addr[ETH_ALEN];
 };
 
-static const struct net_device_ops qeth_l2_netdev_ops;
+static const struct net_device_ops qeth_l2_iqd_netdev_ops;
+static const struct net_device_ops qeth_l2_osa_netdev_ops;
 
 static bool qeth_l2_must_learn(struct net_device *netdev,
 			       struct net_device *dstdev)
@@ -738,7 +739,8 @@ static bool qeth_l2_must_learn(struct net_device *netdev,
 		(priv->brport_features & BR_LEARNING_SYNC) &&
 		!(br_port_flag_is_set(netdev, BR_ISOLATED) &&
 		  br_port_flag_is_set(dstdev, BR_ISOLATED)) &&
-		netdev->netdev_ops == &qeth_l2_netdev_ops);
+		(netdev->netdev_ops == &qeth_l2_iqd_netdev_ops ||
+		 netdev->netdev_ops == &qeth_l2_osa_netdev_ops));
 }
 
 /**
@@ -1051,7 +1053,28 @@ static int qeth_l2_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
 	return rc;
 }
 
-static const struct net_device_ops qeth_l2_netdev_ops = {
+static const struct net_device_ops qeth_l2_iqd_netdev_ops = {
+	.ndo_open		= qeth_open,
+	.ndo_stop		= qeth_stop,
+	.ndo_get_stats64	= qeth_get_stats64,
+	.ndo_start_xmit		= qeth_l2_hard_start_xmit,
+	.ndo_features_check	= qeth_features_check,
+	.ndo_select_queue	= qeth_l2_select_queue,
+	.ndo_validate_addr	= qeth_l2_validate_addr,
+	.ndo_set_rx_mode	= qeth_l2_set_rx_mode,
+	.ndo_eth_ioctl		= qeth_do_ioctl,
+	.ndo_siocdevprivate	= qeth_siocdevprivate,
+	.ndo_set_mac_address	= qeth_l2_set_mac_address,
+	.ndo_vlan_rx_add_vid	= qeth_l2_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid	= qeth_l2_vlan_rx_kill_vid,
+	.ndo_tx_timeout		= qeth_tx_timeout,
+	.ndo_fix_features	= qeth_fix_features,
+	.ndo_set_features	= qeth_set_features,
+	.ndo_bridge_getlink	= qeth_l2_bridge_getlink,
+	.ndo_bridge_setlink	= qeth_l2_bridge_setlink,
+};
+
+static const struct net_device_ops qeth_l2_osa_netdev_ops = {
 	.ndo_open		= qeth_open,
 	.ndo_stop		= qeth_stop,
 	.ndo_get_stats64	= qeth_get_stats64,
@@ -1074,8 +1097,9 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 
 static int qeth_l2_setup_netdev(struct qeth_card *card)
 {
+	card->dev->netdev_ops = IS_IQD(card) ? &qeth_l2_iqd_netdev_ops :
+					       &qeth_l2_osa_netdev_ops;
 	card->dev->needed_headroom = sizeof(struct qeth_hdr);
-	card->dev->netdev_ops = &qeth_l2_netdev_ops;
 	card->dev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (IS_OSM(card)) {
-- 
2.32.0

