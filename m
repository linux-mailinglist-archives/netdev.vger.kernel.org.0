Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA3C1D5F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfI3IsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:48:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730131AbfI3IsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 04:48:20 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3DA857E955F3AC177F5E;
        Mon, 30 Sep 2019 16:48:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 16:47:59 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 2/6] rtlwifi: Remove set but not used variables 'dataempty','hoffset'
Date:   Mon, 30 Sep 2019 16:54:48 +0800
Message-ID: <1569833692-93288-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
References: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/efuse.c: In function efuse_pg_packet_write:
drivers/net/wireless/realtek/rtlwifi/efuse.c:937:24: warning: variable dataempty set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/efuse.c: In function efuse_get_current_size:
drivers/net/wireless/realtek/rtlwifi/efuse.c:1202:5: warning: variable hoffset set but not used [-Wunused-but-set-variable]

They are not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index 2646672..cef9f2a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -915,7 +915,7 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct target_pkt;
 	u8 write_state = PG_STATE_HEADER;
-	int continual = true, dataempty = true, result = true;
+	int continual = true, result = true;
 	u16 efuse_addr = 0;
 	u8 efuse_data;
 	u8 target_word_cnts = 0;
@@ -942,7 +942,6 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 	while (continual && (efuse_addr < (EFUSE_MAX_SIZE -
 		rtlpriv->cfg->maps[EFUSE_OOB_PROTECT_BYTES_LEN]))) {
 		if (write_state == PG_STATE_HEADER) {
-			dataempty = true;
 			badworden = 0x0F;
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 				"efuse PG_STATE_HEADER\n");
@@ -1179,13 +1178,12 @@ static u16 efuse_get_current_size(struct ieee80211_hw *hw)
 {
 	int continual = true;
 	u16 efuse_addr = 0;
-	u8 hoffset, hworden;
+	u8 hworden;
 	u8 efuse_data, word_cnts;

 	while (continual && efuse_one_byte_read(hw, efuse_addr, &efuse_data) &&
 	       (efuse_addr < EFUSE_MAX_SIZE)) {
 		if (efuse_data != 0xFF) {
-			hoffset = (efuse_data >> 4) & 0x0F;
 			hworden = efuse_data & 0x0F;
 			word_cnts = efuse_calculate_word_cnts(hworden);
 			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
--
2.7.4

