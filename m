Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E802AFF5F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgKLFca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:30 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7483 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbgKLDdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 22:33:13 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CWnHN3nFxzhjVl;
        Thu, 12 Nov 2020 11:33:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Nov 2020 11:33:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V3 net-next 08/10] net: hns3: add a check for ethtool priv-flag interface
Date:   Thu, 12 Nov 2020 11:33:16 +0800
Message-ID: <1605151998-12633-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
References: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check for hns3_set_priv_flags() since if the capability
is unsupported its private flags should not be modified as well.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 18b3e43..3642740 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -744,6 +744,7 @@ struct hnae3_handle {
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
 
+	unsigned long supported_pflags;
 	unsigned long priv_flags;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f686723..c30cf9e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4152,6 +4152,7 @@ static void hns3_state_init(struct hnae3_handle *handle)
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 	set_bit(HNS3_NIC_STATE_DIM_ENABLE, &priv->state);
 	handle->priv_flags |= BIT(HNAE3_PFLAG_DIM_ENABLE);
+	set_bit(HNAE3_PFLAG_DIM_ENABLE, &handle->supported_pflags);
 }
 
 static int hns3_client_init(struct hnae3_handle *handle)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e8adc70..7462d43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1561,12 +1561,31 @@ static u32 hns3_get_priv_flags(struct net_device *netdev)
 	return handle->priv_flags;
 }
 
+static int hns3_check_priv_flags(struct hnae3_handle *h, u32 changed)
+{
+	u32 i;
+
+	for (i = 0; i < HNAE3_PFLAG_MAX; i++)
+		if ((changed & BIT(i)) && !test_bit(i, &h->supported_pflags)) {
+			netdev_err(h->netdev, "%s is unsupported\n",
+				   hns3_priv_flags[i].name);
+			return -EOPNOTSUPP;
+		}
+
+	return 0;
+}
+
 static int hns3_set_priv_flags(struct net_device *netdev, u32 pflags)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	u32 changed = pflags ^ handle->priv_flags;
+	int ret;
 	u32 i;
 
+	ret = hns3_check_priv_flags(handle, changed);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < HNAE3_PFLAG_MAX; i++) {
 		if (changed & BIT(i)) {
 			bool enable = !(handle->priv_flags & BIT(i));
-- 
2.7.4

