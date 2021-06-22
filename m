Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE13B0288
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFVLQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:16:48 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7376 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhFVLQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:16:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G8NwZ4Txfz71CG;
        Tue, 22 Jun 2021 19:10:22 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 19:14:27 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 22 Jun 2021 19:14:27 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
        <mark.rutland@arm.com>, <dbrazdil@google.com>, <qperret@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/3] net: hns3: add ethtool priv-flag for TX push
Date:   Tue, 22 Jun 2021 19:11:11 +0800
Message-ID: <1624360271-17525-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

Add a control private flag in ethtool for enable/disable
TX push feature.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  5 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 19 ++++++++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 3979d5d2e842..bebb91f7d9a4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -805,6 +805,7 @@ struct hnae3_roce_private_info {
 
 enum hnae3_pflag {
 	HNAE3_PFLAG_LIMIT_PROMISC,
+	HNAE3_PFLAG_PUSH_ENABLE,
 	HNAE3_PFLAG_MAX
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 8649bd8e1b57..8ea6ad783e55 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5132,8 +5132,11 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	if (hnae3_ae_dev_rxd_adv_layout_supported(ae_dev))
 		set_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state);
 
-	if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+	if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps)) {
 		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+		handle->priv_flags |= BIT(HNAE3_PFLAG_PUSH_ENABLE);
+		set_bit(HNAE3_PFLAG_PUSH_ENABLE, &handle->supported_pflags);
+	}
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 155a58e11089..0b2557d4441d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -423,8 +423,25 @@ static void hns3_update_limit_promisc_mode(struct net_device *netdev,
 	hns3_request_update_promisc_mode(handle);
 }
 
+static void hns3_update_state(struct net_device *netdev,
+			      enum hns3_nic_state state, bool enable)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+
+	if (enable)
+		set_bit(state, &priv->state);
+	else
+		clear_bit(state, &priv->state);
+}
+
+static void hns3_update_push_state(struct net_device *netdev, bool enable)
+{
+	hns3_update_state(netdev, HNS3_NIC_STATE_TX_PUSH_ENABLE, enable);
+}
+
 static const struct hns3_pflag_desc hns3_priv_flags[HNAE3_PFLAG_MAX] = {
-	{ "limit_promisc",	hns3_update_limit_promisc_mode }
+	{ "limit_promisc",	hns3_update_limit_promisc_mode },
+	{ "tx_push_enable",	hns3_update_push_state }
 };
 
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
-- 
2.8.1

