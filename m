Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6F849ADA2
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358447AbiAYH3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:29:41 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:31187 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445151AbiAYH1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 02:27:07 -0500
Received: from kwepemi100013.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JjddG6hPcz8wW9;
        Tue, 25 Jan 2022 15:24:02 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100013.china.huawei.com (7.221.188.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:26:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:26:58 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [RESEND PATCH net-next 2/2] net: hns3: add ethtool priv-flag for TX push
Date:   Tue, 25 Jan 2022 15:21:49 +0800
Message-ID: <20220125072149.56604-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220125072149.56604-1-huangguangbin2@huawei.com>
References: <20220125072149.56604-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Add a control private flag in ethtool for enable/disable
TX push feature.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  5 ++++-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 19 ++++++++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 6f18c9a03231..c40c45b75065 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -818,6 +818,7 @@ struct hnae3_roce_private_info {
 
 enum hnae3_pflag {
 	HNAE3_PFLAG_LIMIT_PROMISC,
+	HNAE3_PFLAG_PUSH_ENABLE,
 	HNAE3_PFLAG_MAX
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0b8a73c40b12..97222192d68c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5162,8 +5162,11 @@ static void hns3_state_init(struct hnae3_handle *handle)
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
-	if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+	if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps)) {
 		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+		handle->priv_flags |= BIT(HNAE3_PFLAG_PUSH_ENABLE);
+		set_bit(HNAE3_PFLAG_PUSH_ENABLE, &handle->supported_pflags);
+	}
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->supported_pflags);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6469238ae090..a7cf5fee9f48 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -440,8 +440,25 @@ static void hns3_update_limit_promisc_mode(struct net_device *netdev,
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
2.33.0

