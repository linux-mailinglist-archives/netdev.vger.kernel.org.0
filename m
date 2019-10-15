Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D55D7304
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbfJOKTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:19:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:47018 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfJOKTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 06:19:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so12146186pfg.13
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 03:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2+MfU8BA9N+kYG+UhxO+xB6ESKW69SU23RYupl8tn0=;
        b=v1Keii2AMIQ2PHav5u2wn8zsXXt1VCZh/YSN1DMY3rm6moRf3QVRm+H+AX7PLRFTeM
         1FT3BygBzYcOrA39ion6q6EDYe6KjvTB6MCpNjmwgB9Gflsx2RgIyBLnFRCkeq6sRKL3
         K7E5E2ALpkA+HZDRThYKCu8g2pGIhbxoHOojMukX5lbwq8c427ZI/8QQx65NevMICvvK
         GIQQB/pD2xCuFLvV8bBPBh+/ufN5x7zHsjNkIJ3Sm+gBG19oshTgqIy5PNC3UPvBAk1Y
         WLLOEjtzxJ41LeZTXvsKkoO/CzkRhFwjuVgjczTG7bFCXng1UtFsXIpDxE7UyT7PTG2C
         Y/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2+MfU8BA9N+kYG+UhxO+xB6ESKW69SU23RYupl8tn0=;
        b=stXWlqKr7yvZL+aAafvhM8ig8NQ73r6QD7Y0QG9VhoQ3ImdDFfVSNkxKlt5qbAtPEy
         HLq8Mocj4KsLwsZY3Ya9recg1u0C+bO0Fj+qSdJjKJJah5B2Gz73tMxHeyfAUu/cka85
         8RCQYI5/F6DFHw0y//T90Kquhk8yv0srZyzhaYzjd29iyQVCYwc3uTPNH4qx+VTOmXnk
         vcH5YBKp9ys1Wl/BdWXcu8/OOwViYWalWS/Bf4TdkLSongr8vpLzqJ0hF1PDflM/qjyk
         amPcVIS5aL4rUy68WTqNG4ZCdhKaswLtJkeTOlHPuvYf8nvNDajBtomP+hwNYoMhHsTf
         DoLA==
X-Gm-Message-State: APjAAAVMD7vh/pR4Uh8J5KahzZOPBRL3maFlK4QPvotxRtyzWVWgth6F
        yKQu4zmI4w06/NAv5siSCwGiJg==
X-Google-Smtp-Source: APXvYqzxfW0HfhrtkjeiBPUPxUrWjbbIPe+aeyWNKtwFXZrIWAAaVN4VyjHbl7eryMtTzPtVVFhAkw==
X-Received: by 2002:aa7:86d6:: with SMTP id h22mr38105646pfo.72.1571134754357;
        Tue, 15 Oct 2019 03:19:14 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-130.HINET-IP.hinet.net. [59.127.47.130])
        by smtp.gmail.com with ESMTPSA id m12sm24635560pff.66.2019.10.15.03.19.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Oct 2019 03:19:13 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH] rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot
Date:   Tue, 15 Oct 2019 18:19:09 +0800
Message-Id: <20191015101909.4640-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
RTL8723BU to do full initilization without checking MAC status.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 22e95b11bfbb..6598c8d786ea 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1425,6 +1425,7 @@ struct rtl8xxxu_fileops {
 	u8 has_s0s1:1;
 	u8 has_tx_report:1;
 	u8 gen2_thermal_meter:1;
+	u8 needs_full_init:1;
 	u32 adda_1t_init;
 	u32 adda_1t_path_on;
 	u32 adda_2t_path_on_a;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 9ba661b3d767..a1c3787abe2e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1668,6 +1668,7 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.has_s0s1 = 1,
 	.has_tx_report = 1,
 	.gen2_thermal_meter = 1,
+	.needs_full_init = 1,
 	.adda_1t_init = 0x01c00014,
 	.adda_1t_path_on = 0x01c00014,
 	.adda_2t_path_on_a = 0x01c00014,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e4c1b08c8070..8420cb269b8d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3900,6 +3900,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	else
 		macpower = true;
 
+	if (fops->needs_full_init)
+		macpower = false;
+
 	ret = fops->power_on(priv);
 	if (ret < 0) {
 		dev_warn(dev, "%s: Failed power on\n", __func__);
-- 
2.23.0

