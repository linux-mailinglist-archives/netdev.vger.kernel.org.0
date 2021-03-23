Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA1D3458F4
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhCWHlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:41:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14010 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCWHlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:41:02 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4NXg2XBtzrWjT;
        Tue, 23 Mar 2021 15:38:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:40:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/8] net: hns: remove unused set_rx_ignore_pause_frames()
Date:   Tue, 23 Mar 2021 15:41:04 +0800
Message-ID: <1616485269-57044-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
References: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since set_rx_ignore_pause_frames() in struct mac_driver
is unused, so remove it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c  |  9 ---------
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h   |  2 --
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c | 15 ---------------
 3 files changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
index 04878b1..8907c08 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
@@ -130,14 +130,6 @@ static void hns_gmac_get_tx_auto_pause_frames(void *mac_drv, u16 *newval)
 				     GMAC_FC_TX_TIMER_M, GMAC_FC_TX_TIMER_S);
 }
 
-static void hns_gmac_set_rx_auto_pause_frames(void *mac_drv, u32 newval)
-{
-	struct mac_driver *drv = (struct mac_driver *)mac_drv;
-
-	dsaf_set_dev_bit(drv, GMAC_PAUSE_EN_REG,
-			 GMAC_PAUSE_EN_RX_FDFC_B, !!newval);
-}
-
 static void hns_gmac_config_max_frame_length(void *mac_drv, u16 newval)
 {
 	struct mac_driver *drv = (struct mac_driver *)mac_drv;
@@ -739,7 +731,6 @@ void *hns_gmac_config(struct hns_mac_cb *mac_cb, struct mac_params *mac_param)
 	mac_drv->config_loopback = hns_gmac_config_loopback;
 	mac_drv->config_pad_and_crc = hns_gmac_config_pad_and_crc;
 	mac_drv->config_half_duplex = hns_gmac_set_duplex_type;
-	mac_drv->set_rx_ignore_pause_frames = hns_gmac_set_rx_auto_pause_frames;
 	mac_drv->get_info = hns_gmac_get_info;
 	mac_drv->autoneg_stat = hns_gmac_autoneg_stat;
 	mac_drv->get_pause_enable = hns_gmac_get_pausefrm_cfg;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
index 3278bf4..9771ba8 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
@@ -368,8 +368,6 @@ struct mac_driver {
 	void (*config_half_duplex)(void *mac_drv, u8 newval);
 	/*config tx pause time,if pause_time is zero,disable tx pause enable*/
 	void (*set_tx_auto_pause_frames)(void *mac_drv, u16 pause_time);
-	/*config rx pause enable*/
-	void (*set_rx_ignore_pause_frames)(void *mac_drv, u32 enable);
 	/* config rx mode for promiscuous*/
 	void (*set_promiscuous)(void *mac_drv, u8 enable);
 	void (*mac_pausefrm_cfg)(void *mac_drv, u32 rx_en, u32 tx_en);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index f514545..8efc966 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -267,19 +267,6 @@ static void hns_xgmac_set_pausefrm_mac_addr(void *mac_drv, char *mac_addr)
 }
 
 /**
- *hns_xgmac_set_rx_ignore_pause_frames - set rx pause param about xgmac
- *@mac_drv: mac driver
- *@enable:enable rx pause param
- */
-static void hns_xgmac_set_rx_ignore_pause_frames(void *mac_drv, u32 enable)
-{
-	struct mac_driver *drv = (struct mac_driver *)mac_drv;
-
-	dsaf_set_dev_bit(drv, XGMAC_MAC_PAUSE_CTRL_REG,
-			 XGMAC_PAUSE_CTL_RX_B, !!enable);
-}
-
-/**
  *hns_xgmac_set_tx_auto_pause_frames - set tx pause param about xgmac
  *@mac_drv: mac driver
  *@enable:enable tx pause param
@@ -813,8 +800,6 @@ void *hns_xgmac_config(struct hns_mac_cb *mac_cb, struct mac_params *mac_param)
 	mac_drv->config_loopback = NULL;
 	mac_drv->config_pad_and_crc = hns_xgmac_config_pad_and_crc;
 	mac_drv->config_half_duplex = NULL;
-	mac_drv->set_rx_ignore_pause_frames =
-		hns_xgmac_set_rx_ignore_pause_frames;
 	mac_drv->mac_free = hns_xgmac_free;
 	mac_drv->adjust_link = NULL;
 	mac_drv->set_tx_auto_pause_frames = hns_xgmac_set_tx_auto_pause_frames;
-- 
2.7.4

