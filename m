Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B6C15426B
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 11:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgBFK4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 05:56:25 -0500
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:55114 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727698AbgBFK4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 05:56:24 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id F3517837F27D;
        Thu,  6 Feb 2020 10:56:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:4:41:69:355:379:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2393:2553:2559:2562:2640:2828:3138:3139:3140:3141:3142:3865:3867:4321:4384:4605:5007:6117:6119:7903:8603:8829:10004:11026:11473:11657:11658:11914:12043:12296:12297:12438:12555:12760:12986:13439:14394:14659:21080:21433:21627:21740:21939:21990:30054:30090,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: ink51_5482e4a147944
X-Filterd-Recvd-Size: 15578
Received: from XPS-9350 (unknown [172.58.43.208])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Thu,  6 Feb 2020 10:56:20 +0000 (UTC)
Message-ID: <4ba111ba18f14f0630cc550b58dbe5dbc82a48ac.camel@perches.com>
Subject: [PATCH] rtw88: 8822[bc]: Make tables const, reduce data object size
From:   Joe Perches <joe@perches.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 06 Feb 2020 02:54:38 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the data size 2kb or 3kb by making tables const.
Add const to pointer declarations to make compilation work too.

(x86-64 defconfig)
$ size drivers/net/wireless/realtek/rtw88/rtw8822?.o*
   text	   data	    bss	    dec	    hex	filename
  25054	    672	      8	  25734	   6486	drivers/net/wireless/realtek/rtw88/rtw8822b.o.new
  23870	   1872	      8	  25750	   6496	drivers/net/wireless/realtek/rtw88/rtw8822b.o.old
  53646	    828	      0	  54474	   d4ca	drivers/net/wireless/realtek/rtw88/rtw8822c.o.new
  52846	   1652	      0	  54498	   d4e2	drivers/net/wireless/realtek/rtw88/rtw8822c.o.old

(x86-64 allyesconfig)
$ size drivers/net/wireless/realtek/rtw88/rtw8822?.o*
   text	   data	    bss	    dec	    hex	filename
  45811	   6280	    128	  52219	   cbfb	drivers/net/wireless/realtek/rtw88/rtw8822b.o.new
  44211	   7880	    128	  52219	   cbfb	drivers/net/wireless/realtek/rtw88/rtw8822b.o.old
 100195	   8128	      0	 108323	  1a723	drivers/net/wireless/realtek/rtw88/rtw8822c.o.new
  98947	   9376	      0	 108323	  1a723	drivers/net/wireless/realtek/rtw88/rtw8822c.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c      | 19 +++++++++---------
 drivers/net/wireless/realtek/rtw88/main.h     | 22 ++++++++++-----------
 drivers/net/wireless/realtek/rtw88/pci.c      |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 28 +++++++++++++--------------
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 28 +++++++++++++--------------
 5 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index cadf0a..0b98d3 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -101,7 +101,7 @@ static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
 }
 
 static int rtw_pwr_cmd_polling(struct rtw_dev *rtwdev,
-			       struct rtw_pwr_seq_cmd *cmd)
+			       const struct rtw_pwr_seq_cmd *cmd)
 {
 	u8 value;
 	u8 flag = 0;
@@ -139,9 +139,10 @@ static int rtw_pwr_cmd_polling(struct rtw_dev *rtwdev,
 }
 
 static int rtw_sub_pwr_seq_parser(struct rtw_dev *rtwdev, u8 intf_mask,
-				  u8 cut_mask, struct rtw_pwr_seq_cmd *cmd)
+				  u8 cut_mask,
+				  const struct rtw_pwr_seq_cmd *cmd)
 {
-	struct rtw_pwr_seq_cmd *cur_cmd;
+	const struct rtw_pwr_seq_cmd *cur_cmd;
 	u32 offset;
 	u8 value;
 
@@ -183,13 +184,13 @@ static int rtw_sub_pwr_seq_parser(struct rtw_dev *rtwdev, u8 intf_mask,
 }
 
 static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
-			      struct rtw_pwr_seq_cmd **cmd_seq)
+			      const struct rtw_pwr_seq_cmd **cmd_seq)
 {
 	u8 cut_mask;
 	u8 intf_mask;
 	u8 cut;
 	u32 idx = 0;
-	struct rtw_pwr_seq_cmd *cmd;
+	const struct rtw_pwr_seq_cmd *cmd;
 	int ret;
 
 	cut = rtwdev->hal.cut_version;
@@ -223,7 +224,7 @@ static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
 static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 {
 	struct rtw_chip_info *chip = rtwdev->chip;
-	struct rtw_pwr_seq_cmd **pwr_seq;
+	const struct rtw_pwr_seq_cmd **pwr_seq;
 	u8 rpwm;
 	bool cur_pwr;
 
@@ -705,7 +706,7 @@ int rtw_download_firmware(struct rtw_dev *rtwdev, struct rtw_fw_state *fw)
 
 static u32 get_priority_queues(struct rtw_dev *rtwdev, u32 queues)
 {
-	struct rtw_rqpn *rqpn = rtwdev->fifo.rqpn;
+	const struct rtw_rqpn *rqpn = rtwdev->fifo.rqpn;
 	u32 prio_queues = 0;
 
 	if (queues & BIT(IEEE80211_AC_VO))
@@ -793,7 +794,7 @@ void rtw_mac_flush_queues(struct rtw_dev *rtwdev, u32 queues, bool drop)
 static int txdma_queue_mapping(struct rtw_dev *rtwdev)
 {
 	struct rtw_chip_info *chip = rtwdev->chip;
-	struct rtw_rqpn *rqpn = NULL;
+	const struct rtw_rqpn *rqpn = NULL;
 	u16 txdma_pq_map = 0;
 
 	switch (rtw_hci_type(rtwdev)) {
@@ -882,7 +883,7 @@ static int priority_queue_cfg(struct rtw_dev *rtwdev)
 {
 	struct rtw_fifo_conf *fifo = &rtwdev->fifo;
 	struct rtw_chip_info *chip = rtwdev->chip;
-	struct rtw_page_table *pg_tbl = NULL;
+	const struct rtw_page_table *pg_tbl = NULL;
 	u16 pubq_num;
 	int ret;
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index f334d2..a55635 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -948,10 +948,10 @@ struct rtw_wow_param {
 };
 
 struct rtw_intf_phy_para_table {
-	struct rtw_intf_phy_para *usb2_para;
-	struct rtw_intf_phy_para *usb3_para;
-	struct rtw_intf_phy_para *gen1_para;
-	struct rtw_intf_phy_para *gen2_para;
+	const struct rtw_intf_phy_para *usb2_para;
+	const struct rtw_intf_phy_para *usb3_para;
+	const struct rtw_intf_phy_para *gen1_para;
+	const struct rtw_intf_phy_para *gen2_para;
 	u8 n_usb2_para;
 	u8 n_usb3_para;
 	u8 n_gen1_para;
@@ -1048,13 +1048,13 @@ struct rtw_chip_info {
 
 	/* init values */
 	u8 sys_func_en;
-	struct rtw_pwr_seq_cmd **pwr_on_seq;
-	struct rtw_pwr_seq_cmd **pwr_off_seq;
-	struct rtw_rqpn *rqpn_table;
-	struct rtw_page_table *page_table;
-	struct rtw_intf_phy_para_table *intf_table;
+	const struct rtw_pwr_seq_cmd **pwr_on_seq;
+	const struct rtw_pwr_seq_cmd **pwr_off_seq;
+	const struct rtw_rqpn *rqpn_table;
+	const struct rtw_page_table *page_table;
+	const struct rtw_intf_phy_para_table *intf_table;
 
-	struct rtw_hw_reg *dig;
+	const struct rtw_hw_reg *dig;
 	u32 rf_base_addr[2];
 	u32 rf_sipi_addr[2];
 
@@ -1500,7 +1500,7 @@ struct rtw_fifo_conf {
 	u16 rsvd_cpu_instr_addr;
 	u16 rsvd_fw_txbuf_addr;
 	u16 rsvd_csibuf_addr;
-	struct rtw_rqpn *rqpn;
+	const struct rtw_rqpn *rqpn;
 };
 
 struct rtw_fw_state {
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 1fbc14..82b1f86 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1248,7 +1248,7 @@ static void rtw_pci_interface_cfg(struct rtw_dev *rtwdev)
 static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 {
 	struct rtw_chip_info *chip = rtwdev->chip;
-	struct rtw_intf_phy_para *para;
+	const struct rtw_intf_phy_para *para;
 	u16 cut;
 	u16 value;
 	u16 offset;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 4bc14b..ded1e9f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -1543,7 +1543,7 @@ static void rtw8822b_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
 		rtw_warn(rtwdev, "wrong bfee role\n");
 }
 
-static struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822b[] = {
+static const struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822b[] = {
 	{0x0086,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_SDIO_MSK,
@@ -1581,7 +1581,7 @@ static struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822b[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822b[] = {
+static const struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822b[] = {
 	{0x0012,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_ALL_MSK,
@@ -1714,7 +1714,7 @@ static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822b[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822b[] = {
+static const struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822b[] = {
 	{0x0003,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_SDIO_MSK,
@@ -1787,7 +1787,7 @@ static struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822b[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822b[] = {
+static const struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822b[] = {
 	{0x0005,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_SDIO_MSK,
@@ -1905,26 +1905,26 @@ static struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822b[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd *card_enable_flow_8822b[] = {
+static const struct rtw_pwr_seq_cmd *card_enable_flow_8822b[] = {
 	trans_carddis_to_cardemu_8822b,
 	trans_cardemu_to_act_8822b,
 	NULL
 };
 
-static struct rtw_pwr_seq_cmd *card_disable_flow_8822b[] = {
+static const struct rtw_pwr_seq_cmd *card_disable_flow_8822b[] = {
 	trans_act_to_cardemu_8822b,
 	trans_cardemu_to_carddis_8822b,
 	NULL
 };
 
-static struct rtw_intf_phy_para usb2_param_8822b[] = {
+static const struct rtw_intf_phy_para usb2_param_8822b[] = {
 	{0xFFFF, 0x00,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_ALL,
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para usb3_param_8822b[] = {
+static const struct rtw_intf_phy_para usb3_param_8822b[] = {
 	{0x0001, 0xA841,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_D,
@@ -1935,7 +1935,7 @@ static struct rtw_intf_phy_para usb3_param_8822b[] = {
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para pcie_gen1_param_8822b[] = {
+static const struct rtw_intf_phy_para pcie_gen1_param_8822b[] = {
 	{0x0001, 0xA841,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_C,
@@ -1982,7 +1982,7 @@ static struct rtw_intf_phy_para pcie_gen1_param_8822b[] = {
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para pcie_gen2_param_8822b[] = {
+static const struct rtw_intf_phy_para pcie_gen2_param_8822b[] = {
 	{0x0001, 0xA841,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_C,
@@ -2029,7 +2029,7 @@ static struct rtw_intf_phy_para pcie_gen2_param_8822b[] = {
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para_table phy_para_table_8822b = {
+static const struct rtw_intf_phy_para_table phy_para_table_8822b = {
 	.usb2_para	= usb2_param_8822b,
 	.usb3_para	= usb3_param_8822b,
 	.gen1_para	= pcie_gen1_param_8822b,
@@ -2046,12 +2046,12 @@ static const struct rtw_rfe_def rtw8822b_rfe_defs[] = {
 	[5] = RTW_DEF_RFE(8822b, 5, 5),
 };
 
-static struct rtw_hw_reg rtw8822b_dig[] = {
+static const struct rtw_hw_reg rtw8822b_dig[] = {
 	[0] = { .addr = 0xc50, .mask = 0x7f },
 	[1] = { .addr = 0xe50, .mask = 0x7f },
 };
 
-static struct rtw_page_table page_table_8822b[] = {
+static const struct rtw_page_table page_table_8822b[] = {
 	{64, 64, 64, 64, 1},
 	{64, 64, 64, 64, 1},
 	{64, 64, 0, 0, 1},
@@ -2059,7 +2059,7 @@ static struct rtw_page_table page_table_8822b[] = {
 	{64, 64, 64, 64, 1},
 };
 
-static struct rtw_rqpn rqpn_table_8822b[] = {
+static const struct rtw_rqpn rqpn_table_8822b[] = {
 	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
 	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
 	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 386509..5b2f594 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3399,7 +3399,7 @@ static void rtw8822c_pwr_track(struct rtw_dev *rtwdev)
 	dm_info->pwr_trk_triggered = false;
 }
 
-static struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822c[] = {
+static const struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822c[] = {
 	{0x0086,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_SDIO_MSK,
@@ -3442,7 +3442,7 @@ static struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822c[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822c[] = {
+static const struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822c[] = {
 	{0x0000,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
@@ -3551,7 +3551,7 @@ static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822c[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822c[] = {
+static const struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822c[] = {
 	{0x0093,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_ALL_MSK,
@@ -3614,7 +3614,7 @@ static struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822c[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822c[] = {
+static const struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822c[] = {
 	{0x0005,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_SDIO_MSK,
@@ -3677,47 +3677,47 @@ static struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822c[] = {
 	 RTW_PWR_CMD_END, 0, 0},
 };
 
-static struct rtw_pwr_seq_cmd *card_enable_flow_8822c[] = {
+static const struct rtw_pwr_seq_cmd *card_enable_flow_8822c[] = {
 	trans_carddis_to_cardemu_8822c,
 	trans_cardemu_to_act_8822c,
 	NULL
 };
 
-static struct rtw_pwr_seq_cmd *card_disable_flow_8822c[] = {
+static const struct rtw_pwr_seq_cmd *card_disable_flow_8822c[] = {
 	trans_act_to_cardemu_8822c,
 	trans_cardemu_to_carddis_8822c,
 	NULL
 };
 
-static struct rtw_intf_phy_para usb2_param_8822c[] = {
+static const struct rtw_intf_phy_para usb2_param_8822c[] = {
 	{0xFFFF, 0x00,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_ALL,
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para usb3_param_8822c[] = {
+static const struct rtw_intf_phy_para usb3_param_8822c[] = {
 	{0xFFFF, 0x0000,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_ALL,
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para pcie_gen1_param_8822c[] = {
+static const struct rtw_intf_phy_para pcie_gen1_param_8822c[] = {
 	{0xFFFF, 0x0000,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_ALL,
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para pcie_gen2_param_8822c[] = {
+static const struct rtw_intf_phy_para pcie_gen2_param_8822c[] = {
 	{0xFFFF, 0x0000,
 	 RTW_IP_SEL_PHY,
 	 RTW_INTF_PHY_CUT_ALL,
 	 RTW_INTF_PHY_PLATFORM_ALL},
 };
 
-static struct rtw_intf_phy_para_table phy_para_table_8822c = {
+static const struct rtw_intf_phy_para_table phy_para_table_8822c = {
 	.usb2_para	= usb2_param_8822c,
 	.usb3_para	= usb3_param_8822c,
 	.gen1_para	= pcie_gen1_param_8822c,
@@ -3734,12 +3734,12 @@ static const struct rtw_rfe_def rtw8822c_rfe_defs[] = {
 	[2] = RTW_DEF_RFE(8822c, 0, 0),
 };
 
-static struct rtw_hw_reg rtw8822c_dig[] = {
+static const struct rtw_hw_reg rtw8822c_dig[] = {
 	[0] = { .addr = 0x1d70, .mask = 0x7f },
 	[1] = { .addr = 0x1d70, .mask = 0x7f00 },
 };
 
-static struct rtw_page_table page_table_8822c[] = {
+static const struct rtw_page_table page_table_8822c[] = {
 	{64, 64, 64, 64, 1},
 	{64, 64, 64, 64, 1},
 	{64, 64, 0, 0, 1},
@@ -3747,7 +3747,7 @@ static struct rtw_page_table page_table_8822c[] = {
 	{64, 64, 64, 64, 1},
 };
 
-static struct rtw_rqpn rqpn_table_8822c[] = {
+static const struct rtw_rqpn rqpn_table_8822c[] = {
 	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
 	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
 	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},

