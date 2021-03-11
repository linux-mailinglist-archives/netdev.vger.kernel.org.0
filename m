Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC3336A12
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhCKCOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:14:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13905 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCKCNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:13:46 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DwssD2MQRzkXJd;
        Thu, 11 Mar 2021 10:12:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 10:13:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/2] net: hns3: use FEC capability queried from firmware
Date:   Thu, 11 Mar 2021 10:14:11 +0800
Message-ID: <1615428852-2637-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
References: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

For maintainability and compatibility, add support to use FEC
capability queried from firmware.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c  |  6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 10 ++++++----
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 1bd0ddf..02419bb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -353,7 +353,9 @@ static void hclge_set_default_capability(struct hclge_dev *hdev)
 
 	set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
 	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
-	set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
+	if (hdev->ae_dev->dev_version == HNAE3_DEVICE_VERSION_V2) {
+		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
+	}
 }
 
 static void hclge_parse_capability(struct hclge_dev *hdev,
@@ -378,6 +380,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_FD_FORWARD_TC_B))
 		set_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_FEC_B))
+		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
 }
 
 static __le32 hclge_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 057dda7..e8480ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -384,6 +384,7 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_HW_PAD_B,
 	HCLGE_CAP_STASH_B,
 	HCLGE_CAP_UDP_TUNNEL_CSUM_B,
+	HCLGE_CAP_FEC_B = 13,
 };
 
 enum HCLGE_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e3f81c7..0e0a16c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2889,10 +2889,12 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	clear_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state);
 }
 
-static void hclge_update_port_capability(struct hclge_mac *mac)
+static void hclge_update_port_capability(struct hclge_dev *hdev,
+					 struct hclge_mac *mac)
 {
-	/* update fec ability by speed */
-	hclge_convert_setting_fec(mac);
+	if (hnae3_dev_fec_supported(hdev))
+		/* update fec ability by speed */
+		hclge_convert_setting_fec(mac);
 
 	/* firmware can not identify back plane type, the media type
 	 * read from configuration can help deal it
@@ -3012,7 +3014,7 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		if (mac->speed_type == QUERY_ACTIVE_SPEED) {
-			hclge_update_port_capability(mac);
+			hclge_update_port_capability(hdev, mac);
 			return 0;
 		}
 		return hclge_cfg_mac_speed_dup(hdev, mac->speed,
-- 
2.7.4

