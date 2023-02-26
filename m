Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549316A301A
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBZOqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBZOqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:46:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7E212F10;
        Sun, 26 Feb 2023 06:45:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B399BB80BAA;
        Sun, 26 Feb 2023 14:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4666BC4339B;
        Sun, 26 Feb 2023 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422725;
        bh=x7sdm3iU1dJ2vJSPlk7zJ6Ctuyc9lXKp2dS9RwD/CNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ut27tR11Sq6NtIl2BlesIxbT9Rd3phM+ZpxU1Z5PEJScqxitoJsmVfOOTt/+elJg2
         YX7wGBhqC/is3/veC4J8xmUkT+CV8cYyNtKqD1cAmu8+BvfFu12OANp97+JZl0JKt6
         wiOSbCkG9gc630PrXEmVXTkleAM2Zjq9m+fdNbNXsqnJclGys1RLR+PjTbd6VpRFvl
         YftPhyfzXXkf4KyzFvdszsNfp+Rw3PGTL/ga/l8M945Q+y6ZoeUW5Hv2C74+mQzN9w
         YaHTq2piQ+KzvLAB8HyVGoREJdfRJ6+XJC2g+MHc+YxC59nJfDZwqSWN/lX4hJitx9
         Vz+f7agsXCERw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 15/53] wifi: rtw89: fix assignation of TX BD RAM table
Date:   Sun, 26 Feb 2023 09:44:07 -0500
Message-Id: <20230226144446.824580-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 7f495de6ae7d31f098970fb45a038c9f69b1bf75 ]

TX BD's RAM table describes how HW allocates usable buffer section
for each TX channel at fetch time. The total RAM size for TX BD is
chip-dependent. For 8852BE, it has only half size (32) for TX channels
of single band. Original table arrange total size (64) for dual band.
It will overflow on 8852BE circuit and cause section conflicts between
different TX channels.

So, we do the changes below.
* add another table for single band chip and export both kind of tables
* point to the expected one in rtw89_pci_info by chip

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230113090632.60957-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c       | 15 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/pci.h       | 15 +++++++++------
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c |  1 +
 5 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 1c4500ba777c6..0ea734c81b4f0 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -1384,7 +1384,7 @@ static int rtw89_pci_ops_tx_write(struct rtw89_dev *rtwdev, struct rtw89_core_tx
 	return 0;
 }
 
-static const struct rtw89_pci_bd_ram bd_ram_table[RTW89_TXCH_NUM] = {
+const struct rtw89_pci_bd_ram rtw89_bd_ram_table_dual[RTW89_TXCH_NUM] = {
 	[RTW89_TXCH_ACH0] = {.start_idx = 0,  .max_num = 5, .min_num = 2},
 	[RTW89_TXCH_ACH1] = {.start_idx = 5,  .max_num = 5, .min_num = 2},
 	[RTW89_TXCH_ACH2] = {.start_idx = 10, .max_num = 5, .min_num = 2},
@@ -1399,11 +1399,24 @@ static const struct rtw89_pci_bd_ram bd_ram_table[RTW89_TXCH_NUM] = {
 	[RTW89_TXCH_CH11] = {.start_idx = 55, .max_num = 5, .min_num = 1},
 	[RTW89_TXCH_CH12] = {.start_idx = 60, .max_num = 4, .min_num = 1},
 };
+EXPORT_SYMBOL(rtw89_bd_ram_table_dual);
+
+const struct rtw89_pci_bd_ram rtw89_bd_ram_table_single[RTW89_TXCH_NUM] = {
+	[RTW89_TXCH_ACH0] = {.start_idx = 0,  .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_ACH1] = {.start_idx = 5,  .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_ACH2] = {.start_idx = 10, .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_ACH3] = {.start_idx = 15, .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_CH8]  = {.start_idx = 20, .max_num = 4, .min_num = 1},
+	[RTW89_TXCH_CH9]  = {.start_idx = 24, .max_num = 4, .min_num = 1},
+	[RTW89_TXCH_CH12] = {.start_idx = 28, .max_num = 4, .min_num = 1},
+};
+EXPORT_SYMBOL(rtw89_bd_ram_table_single);
 
 static void rtw89_pci_reset_trx_rings(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
+	const struct rtw89_pci_bd_ram *bd_ram_table = *info->bd_ram_table;
 	struct rtw89_pci_tx_ring *tx_ring;
 	struct rtw89_pci_rx_ring *rx_ring;
 	struct rtw89_pci_dma_ring *bd_ring;
diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index 7d033501d4d95..1e19740db8c54 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -750,6 +750,12 @@ struct rtw89_pci_ch_dma_addr_set {
 	struct rtw89_pci_ch_dma_addr rx[RTW89_RXCH_NUM];
 };
 
+struct rtw89_pci_bd_ram {
+	u8 start_idx;
+	u8 max_num;
+	u8 min_num;
+};
+
 struct rtw89_pci_info {
 	enum mac_ax_bd_trunc_mode txbd_trunc_mode;
 	enum mac_ax_bd_trunc_mode rxbd_trunc_mode;
@@ -785,6 +791,7 @@ struct rtw89_pci_info {
 	u32 tx_dma_ch_mask;
 	const struct rtw89_pci_bd_idx_addr *bd_idx_addr_low_power;
 	const struct rtw89_pci_ch_dma_addr_set *dma_addr_set;
+	const struct rtw89_pci_bd_ram (*bd_ram_table)[RTW89_TXCH_NUM];
 
 	int (*ltr_set)(struct rtw89_dev *rtwdev, bool en);
 	u32 (*fill_txaddr_info)(struct rtw89_dev *rtwdev,
@@ -798,12 +805,6 @@ struct rtw89_pci_info {
 				struct rtw89_pci_isrs *isrs);
 };
 
-struct rtw89_pci_bd_ram {
-	u8 start_idx;
-	u8 max_num;
-	u8 min_num;
-};
-
 struct rtw89_pci_tx_data {
 	dma_addr_t dma;
 };
@@ -1057,6 +1058,8 @@ static inline bool rtw89_pci_ltr_is_err_reg_val(u32 val)
 extern const struct dev_pm_ops rtw89_pm_ops;
 extern const struct rtw89_pci_ch_dma_addr_set rtw89_pci_ch_dma_addr_set;
 extern const struct rtw89_pci_ch_dma_addr_set rtw89_pci_ch_dma_addr_set_v1;
+extern const struct rtw89_pci_bd_ram rtw89_bd_ram_table_dual[RTW89_TXCH_NUM];
+extern const struct rtw89_pci_bd_ram rtw89_bd_ram_table_single[RTW89_TXCH_NUM];
 
 struct pci_device_id;
 
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
index 0cd8c0c44d19d..d835a44a1d0d0 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
@@ -44,6 +44,7 @@ static const struct rtw89_pci_info rtw8852a_pci_info = {
 	.tx_dma_ch_mask		= 0,
 	.bd_idx_addr_low_power	= NULL,
 	.dma_addr_set		= &rtw89_pci_ch_dma_addr_set,
+	.bd_ram_table		= &rtw89_bd_ram_table_dual,
 
 	.ltr_set		= rtw89_pci_ltr_set,
 	.fill_txaddr_info	= rtw89_pci_fill_txaddr_info,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852be.c b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
index 0ef2ca8efeb0e..ecf39d2d9f81f 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
@@ -46,6 +46,7 @@ static const struct rtw89_pci_info rtw8852b_pci_info = {
 				  BIT(RTW89_TXCH_CH10) | BIT(RTW89_TXCH_CH11),
 	.bd_idx_addr_low_power	= NULL,
 	.dma_addr_set		= &rtw89_pci_ch_dma_addr_set,
+	.bd_ram_table		= &rtw89_bd_ram_table_single,
 
 	.ltr_set		= rtw89_pci_ltr_set,
 	.fill_txaddr_info	= rtw89_pci_fill_txaddr_info,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
index 35901f64d17de..80490a5437df6 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
@@ -53,6 +53,7 @@ static const struct rtw89_pci_info rtw8852c_pci_info = {
 	.tx_dma_ch_mask		= 0,
 	.bd_idx_addr_low_power	= &rtw8852c_bd_idx_addr_low_power,
 	.dma_addr_set		= &rtw89_pci_ch_dma_addr_set_v1,
+	.bd_ram_table		= &rtw89_bd_ram_table_dual,
 
 	.ltr_set		= rtw89_pci_ltr_set_v1,
 	.fill_txaddr_info	= rtw89_pci_fill_txaddr_info_v1,
-- 
2.39.0

