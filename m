Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70BC41C980
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345625AbhI2QF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:58 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24149 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345681AbhI2QAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:14 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbb3s2Nz1DHNj;
        Wed, 29 Sep 2021 23:56:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 152/167] scsi: fcoe: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:19 +0800
Message-ID: <20210929155334.12454-153-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/scsi/fcoe/fcoe.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 5ae6c207d3ac..a0e91043368e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -652,19 +652,19 @@ static void fcoe_netdev_features_change(struct fc_lport *lport,
 {
 	mutex_lock(&lport->lp_mutex);
 
-	if (netdev->features & NETIF_F_SG)
+	if (netdev_feature_test_bit(NETIF_F_SG_BIT, netdev->features))
 		lport->sg_supp = 1;
 	else
 		lport->sg_supp = 0;
 
-	if (netdev->features & NETIF_F_FCOE_CRC) {
+	if (netdev_feature_test_bit(NETIF_F_FCOE_CRC_BIT, netdev->features)) {
 		lport->crc_offload = 1;
 		FCOE_NETDEV_DBG(netdev, "Supports FCCRC offload\n");
 	} else {
 		lport->crc_offload = 0;
 	}
 
-	if (netdev->features & NETIF_F_FSO) {
+	if (netdev_feature_test_bit(NETIF_F_FSO_BIT, netdev->features)) {
 		lport->seq_offload = 1;
 		lport->lso_max = netdev->gso_max_size;
 		FCOE_NETDEV_DBG(netdev, "Supports LSO for max len 0x%x\n",
@@ -721,7 +721,7 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	 * will return 0, so do this first.
 	 */
 	mfs = netdev->mtu;
-	if (netdev->features & NETIF_F_FCOE_MTU) {
+	if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT, netdev->features)) {
 		mfs = FCOE_MTU;
 		FCOE_NETDEV_DBG(netdev, "Supports FCOE_MTU of %d bytes\n", mfs);
 	}
@@ -1549,7 +1549,8 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	skb->priority = fcoe->priority;
 
 	if (is_vlan_dev(fcoe->netdev) &&
-	    fcoe->realdev->features & NETIF_F_HW_VLAN_CTAG_TX) {
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    fcoe->realdev->features)) {
 		/* must set skb->dev before calling vlan_put_tag */
 		skb->dev = fcoe->realdev;
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
@@ -1872,7 +1873,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	case NETDEV_CHANGE:
 		break;
 	case NETDEV_CHANGEMTU:
-		if (netdev->features & NETIF_F_FCOE_MTU)
+		if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT,
+					    netdev->features))
 			break;
 		mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
 				     sizeof(struct fcoe_crc_eof));
-- 
2.33.0

