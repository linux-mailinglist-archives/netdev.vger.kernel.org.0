Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C021193B8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfLJVJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbfLJVJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5D4246BA;
        Tue, 10 Dec 2019 21:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012182;
        bh=796UophT8NjBbk/E9gRtRL1R6ZdTfcJ7TBT6/Hu9NoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hidc3VzjsmiVaG6wRKYIOHUo59wMRM5M1rrfhYW78YF3e7JOdYqRY2+HdHKdvM2w
         77tfDQusKyXT7ZVsUgRTBl3gHqOklH4C2d3a+U6PVOotnhYiFXuNAE1Hf2uD6VsubT
         TqAUyJp8Uqv2vt7A8QHW0HCq122JxeApLE125djQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Chiu <chiu@endlessm.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 139/350] rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot
Date:   Tue, 10 Dec 2019 16:04:04 -0500
Message-Id: <20191210210735.9077-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit 0eeb91ade90ce06d2fa1e2fcb55e3316b64c203c ]

The RTL8723BU has problems connecting to AP after each warm reboot.
Sometimes it returns no scan result, and in most cases, it fails
the authentication for unknown reason. However, it works totally
fine after cold reboot.

Compare the value of register SYS_CR and SYS_CLK_MAC_CLK_ENABLE
for cold reboot and warm reboot, the registers imply that the MAC
is already powered and thus some procedures are skipped during
driver initialization. Double checked the vendor driver, it reads
the SYS_CR and SYS_CLK_MAC_CLK_ENABLE also but doesn't skip any
during initialization based on them. This commit only tells the
RTL8723BU to do full initialization without checking MAC status.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index ade057d868f7e..5e9ce03067de2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1341,6 +1341,7 @@ struct rtl8xxxu_fileops {
 	u8 has_s0s1:1;
 	u8 has_tx_report:1;
 	u8 gen2_thermal_meter:1;
+	u8 needs_full_init:1;
 	u32 adda_1t_init;
 	u32 adda_1t_path_on;
 	u32 adda_2t_path_on_a;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index ceffe05bd65b2..f3cd314d1a9cf 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1670,6 +1670,7 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.has_s0s1 = 1,
 	.has_tx_report = 1,
 	.gen2_thermal_meter = 1,
+	.needs_full_init = 1,
 	.adda_1t_init = 0x01c00014,
 	.adda_1t_path_on = 0x01c00014,
 	.adda_2t_path_on_a = 0x01c00014,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c6c41fb962ffc..361248e975687 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3902,6 +3902,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	else
 		macpower = true;
 
+	if (fops->needs_full_init)
+		macpower = false;
+
 	ret = fops->power_on(priv);
 	if (ret < 0) {
 		dev_warn(dev, "%s: Failed power on\n", __func__);
-- 
2.20.1

