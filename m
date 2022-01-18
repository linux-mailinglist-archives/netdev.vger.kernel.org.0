Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F054914FA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245739AbiARCZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245356AbiARCXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:23:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E412C0617AA;
        Mon, 17 Jan 2022 18:23:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88B9E60E99;
        Tue, 18 Jan 2022 02:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DA9C36AEB;
        Tue, 18 Jan 2022 02:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472618;
        bh=lGJRpRCjDTX1CV5Q8d9zP8u0eeWcNT5bB1+N9cZQVD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKjMZiSkUpw3XHPlqL0KiOD+wMhzf5prFedlFY+o8qnJdmZsD2PgGTezNT8YpCrdL
         CxzmaM95/iLvy3OFUDApzmjLmumbg4vTBczTDOf9DCeQz+shOR/o4vHR0T46OhTIdF
         KL/oQiVt9K8wb5X/waVkVVmD64XAacU2lppp6/sUXvXg9/RdIeaHISbzphVSE2YNKV
         /H4o7PZ73CVp1/lq760eXiWppiRi+hEpkH872WcwNe9H7zSkK/IYJD/IPwlQjg7Ms5
         H1GWwm940eDM1uoP/bjZrtLFK2JwIFiMAsjsiWFfoDXhc8HwXcJH40o4yNUFleTTq3
         +5gT92+Mp+gWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 074/217] rtw89: fix potentially access out of range of RF register array
Date:   Mon, 17 Jan 2022 21:17:17 -0500
Message-Id: <20220118021940.1942199-74-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 30101812a09b37bc8aa409a83f603d4c072198f2 ]

The RF register array is used to help firmware to restore RF settings.
The original code can potentially access out of range, if the size is
between (RTW89_H2C_RF_PAGE_SIZE * RTW89_H2C_RF_PAGE_NUM + 1) to
((RTW89_H2C_RF_PAGE_SIZE + 1) * RTW89_H2C_RF_PAGE_NUM). Fortunately,
current used size doesn't fall into the wrong case, and the size will not
change if we don't update RF parameter.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211119055729.12826-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 33 ++++++++++++++----------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index ab134856baac7..d75e9de8df7c6 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -654,6 +654,12 @@ rtw89_phy_cofig_rf_reg_store(struct rtw89_dev *rtwdev,
 	u16 idx = info->curr_idx % RTW89_H2C_RF_PAGE_SIZE;
 	u8 page = info->curr_idx / RTW89_H2C_RF_PAGE_SIZE;
 
+	if (page >= RTW89_H2C_RF_PAGE_NUM) {
+		rtw89_warn(rtwdev, "RF parameters exceed size. path=%d, idx=%d",
+			   rf_path, info->curr_idx);
+		return;
+	}
+
 	info->rtw89_phy_config_rf_h2c[page][idx] =
 		cpu_to_le32((reg->addr << 20) | reg->data);
 	info->curr_idx++;
@@ -662,30 +668,29 @@ rtw89_phy_cofig_rf_reg_store(struct rtw89_dev *rtwdev,
 static int rtw89_phy_config_rf_reg_fw(struct rtw89_dev *rtwdev,
 				      struct rtw89_fw_h2c_rf_reg_info *info)
 {
-	u16 page = info->curr_idx / RTW89_H2C_RF_PAGE_SIZE;
-	u16 len = (info->curr_idx % RTW89_H2C_RF_PAGE_SIZE) * 4;
+	u16 remain = info->curr_idx;
+	u16 len = 0;
 	u8 i;
 	int ret = 0;
 
-	if (page > RTW89_H2C_RF_PAGE_NUM) {
+	if (remain > RTW89_H2C_RF_PAGE_NUM * RTW89_H2C_RF_PAGE_SIZE) {
 		rtw89_warn(rtwdev,
-			   "rf reg h2c total page num %d larger than %d (RTW89_H2C_RF_PAGE_NUM)\n",
-			   page, RTW89_H2C_RF_PAGE_NUM);
-		return -EINVAL;
+			   "rf reg h2c total len %d larger than %d\n",
+			   remain, RTW89_H2C_RF_PAGE_NUM * RTW89_H2C_RF_PAGE_SIZE);
+		ret = -EINVAL;
+		goto out;
 	}
 
-	for (i = 0; i < page; i++) {
-		ret = rtw89_fw_h2c_rf_reg(rtwdev, info,
-					  RTW89_H2C_RF_PAGE_SIZE * 4, i);
+	for (i = 0; i < RTW89_H2C_RF_PAGE_NUM && remain; i++, remain -= len) {
+		len = remain > RTW89_H2C_RF_PAGE_SIZE ? RTW89_H2C_RF_PAGE_SIZE : remain;
+		ret = rtw89_fw_h2c_rf_reg(rtwdev, info, len * 4, i);
 		if (ret)
-			return ret;
+			goto out;
 	}
-	ret = rtw89_fw_h2c_rf_reg(rtwdev, info, len, i);
-	if (ret)
-		return ret;
+out:
 	info->curr_idx = 0;
 
-	return 0;
+	return ret;
 }
 
 static void rtw89_phy_config_rf_reg(struct rtw89_dev *rtwdev,
-- 
2.34.1

