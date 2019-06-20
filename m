Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CC14CA0D
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfFTIzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:55:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56118 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731341AbfFTIyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:31 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8254468E54B716B83E4E;
        Thu, 20 Jun 2019 16:54:28 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/11] net: hns3: fix selftest fail issue for fibre port with autoneg on
Date:   Thu, 20 Jun 2019 16:52:35 +0800
Message-ID: <1561020765-14481-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

When doing selftest for fibre port with autoneg on, the MAC speed
may be incorrect, which may cause the selftest failed. This patch
fixes it by halting autoneg during the selftest.

Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      | 10 ++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 12 ++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index bf921ef..d78a5f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -264,6 +264,8 @@ struct hnae3_ae_dev {
  *   get auto autonegotiation of pause frame use
  * restart_autoneg()
  *   restart autonegotiation
+ * halt_autoneg()
+ *   halt/resume autonegotiation when autonegotiation on
  * get_coalesce_usecs()
  *   get usecs to delay a TX interrupt after a packet is sent
  * get_rx_max_coalesced_frames()
@@ -383,6 +385,7 @@ struct hnae3_ae_ops {
 	int (*set_autoneg)(struct hnae3_handle *handle, bool enable);
 	int (*get_autoneg)(struct hnae3_handle *handle);
 	int (*restart_autoneg)(struct hnae3_handle *handle);
+	int (*halt_autoneg)(struct hnae3_handle *handle, bool halt);
 
 	void (*get_coalesce_usecs)(struct hnae3_handle *handle,
 				   u32 *tx_usecs, u32 *rx_usecs);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 0998647..16034af 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -336,6 +336,13 @@ static void hns3_self_test(struct net_device *ndev,
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
+	/* Tell firmware to stop mac autoneg before loopback test start,
+	 * otherwise loopback test may be failed when the port is still
+	 * negotiating.
+	 */
+	if (h->ae_algo->ops->halt_autoneg)
+		h->ae_algo->ops->halt_autoneg(h, true);
+
 	set_bit(HNS3_NIC_STATE_TESTING, &priv->state);
 
 	for (i = 0; i < HNS3_SELF_TEST_TYPE_NUM; i++) {
@@ -358,6 +365,9 @@ static void hns3_self_test(struct net_device *ndev,
 
 	clear_bit(HNS3_NIC_STATE_TESTING, &priv->state);
 
+	if (h->ae_algo->ops->halt_autoneg)
+		h->ae_algo->ops->halt_autoneg(h, false);
+
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	if (dis_vlan_filter)
 		h->ae_algo->ops->enable_vlan_filter(h, true);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fbf0c20..b328662 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2315,6 +2315,17 @@ static int hclge_restart_autoneg(struct hnae3_handle *handle)
 	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 }
 
+static int hclge_halt_autoneg(struct hnae3_handle *handle, bool halt)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	if (hdev->hw.mac.support_autoneg && hdev->hw.mac.autoneg)
+		return hclge_set_autoneg_en(hdev, !halt);
+
+	return 0;
+}
+
 static int hclge_set_fec_hw(struct hclge_dev *hdev, u32 fec_mode)
 {
 	struct hclge_config_fec_cmd *req;
@@ -9265,6 +9276,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_autoneg = hclge_set_autoneg,
 	.get_autoneg = hclge_get_autoneg,
 	.restart_autoneg = hclge_restart_autoneg,
+	.halt_autoneg = hclge_halt_autoneg,
 	.get_pauseparam = hclge_get_pauseparam,
 	.set_pauseparam = hclge_set_pauseparam,
 	.set_mtu = hclge_set_mtu,
-- 
2.7.4

