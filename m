Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F371D85A2
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 03:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbfJPByW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 21:54:22 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37287 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfJPByW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 21:54:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id y5so13660675pfo.4
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 18:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sW6Kr6EUz7rX5dHEbanmtPwyhYGa11s9qoO8PB91xwg=;
        b=y0vQuP5DtjBl8KzkKmSS7SXOvaPBJr4sYiPAF2WPXb7nx8y+IEUgL/kyrJXsiptwqZ
         n5Iv6M8vg50oRKF4XIfaSRVVFyE95JIevoK5/Ey3WlAZI1u0JUNk0wo+wBRLaTKMTWVJ
         FefRrnvZjSjfXoSAaEd+/EKf85UkR4cr96yanUGdD2awv4SvXfPpE0H6dcS77JFdcj6X
         y2o0Bnu3VrC5/B1hEOaxOmfvaS6eq00D23D2VfxgFUS4yWEwlphsL5RnkGDGqSqc/Gsn
         Z+tpL53Ye9o5KePGGh8rBGcY2UYkFGOb+55kkEE0WL9qFRsCiUVon7S3sHk5VWZ5hHYk
         Geig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sW6Kr6EUz7rX5dHEbanmtPwyhYGa11s9qoO8PB91xwg=;
        b=IVuqXDo0yybQRZZ+6w6faPtyj97WOPZW5+jJwP4oeEafjvPrJatGpeSZh6f1pSzRfg
         w6Jq9tKRLWQA8rIEnSDe9ar4U1qREFj/duXJ9nzp/WTJD59bw3eWZx8Ox3U5X7N8jjMH
         3xHHZVhrkQcJPs9JR6F/ygTR5dSKl0mQfIWVr/7Tdzk2PKp2PmTDkGE4+nEVRu7+l00V
         yXyDEgeeChuwpxgSXUNz2s5Nk314VH05JWx8bWlE3tnCHwjRKxMRM6iacD4J7dA4QjeL
         g+2GxgZ/8ZnIvAN/z2ZiHB0DqmKf1ZmOcEr58yIOGjIOEsTEgW59KEKPzZ3fuyEU9ZiJ
         LpXA==
X-Gm-Message-State: APjAAAWI4WnzZ6CIGb3uPpPT2xPbo5sfyuktE4gksruKZ1zAMLS7T+1D
        W2upZCThYCZIMYOj7cKVrYuaZg==
X-Google-Smtp-Source: APXvYqwL2+GWeShyoqkAFDgZaBqSlRnbFG5KUO1F9bCx+36sFbahEpqGpni5iPfASMoeOicMcsIauw==
X-Received: by 2002:aa7:99c7:: with SMTP id v7mr42243796pfi.165.1571190859542;
        Tue, 15 Oct 2019 18:54:19 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-126.HINET-IP.hinet.net. [59.127.47.126])
        by smtp.gmail.com with ESMTPSA id m5sm22355135pgt.15.2019.10.15.18.54.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Oct 2019 18:54:18 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH v2] rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot
Date:   Wed, 16 Oct 2019 09:54:08 +0800
Message-Id: <20191016015408.11091-1-chiu@endlessm.com>
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
RTL8723BU to do full initialization without checking MAC status.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---

Note:
  v2: fix typo of commit message


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

