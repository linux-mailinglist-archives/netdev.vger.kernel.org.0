Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745B835F022
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348542AbhDNIrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 04:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhDNIrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 04:47:42 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A541DC061574;
        Wed, 14 Apr 2021 01:47:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so2222358wmq.1;
        Wed, 14 Apr 2021 01:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=As3o8lZXZFAGWP1nJ5PUlnWKBI8dDteBEIbgvKq/hiA=;
        b=gUVgRr9u5bZj4iUjBJbeUbu3UIZrCaOoXbbyplgeqwwYnQ21Ni+RyQ8uAN3rkQoiWC
         a+lwtIJrg14FlE/HPkvtY7149M3oWnFOghUHf6mFNepPIdbvYNnRx4IWJGD9tX5cM9vp
         c08xTyFS27O8bhMjd56Pb6y36Tl2aJNK/hY3tufsrEXUm8QoFf/yMVh0FfuhgJGt9bL2
         SJjf2Wapx16EFxo9xEONuf9dG08/sa0v2xjDL+hDmO7LLCK1hLbaJP2ypMcmY86YQqfB
         ZWSidVAswTBNJB9cQ4RPLa3Mrupk5WioekiMBIbxwv4BHkgn+FaZZeaB4u8ZECQcd/Lj
         P4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=As3o8lZXZFAGWP1nJ5PUlnWKBI8dDteBEIbgvKq/hiA=;
        b=eQpz395MAOM7A/ZAT4XLigYGxPghBckU9+TmnqIxN6DICzwITCVB93jN93lAx7AFav
         C1XsnQCoJ7/nKmvtb4XEGc9QhQ6O7JMRGHquEKG0tRrWiji1Nl2mvyRxmox5IW8vYwGI
         HMTa8Wj97Mmeqp//KtxAx5rc2EmmqwAKy2qn7fKmQ2IBRYGRp6XoTj5qbpuNo8EW6oIW
         wWCEpBNbNo3lVglEG6JAXHTQ2aY2Gxhw23jSEKNUJWlNlI/5BLWFtSLC/GBLzBd86MkL
         kWY2s/rmXGmvqQochKqcyrf4dlDJu0nN0rdztXZnYnd6JYGpM9vaftzxyimLA3b0tFg3
         0K3Q==
X-Gm-Message-State: AOAM5331WKOvFVK8SxFqRz8opvBgeOqrbybDJu3fzKQOTi4aH308fKm1
        mizsDiV1yRbKGuapHXCCV5M=
X-Google-Smtp-Source: ABdhPJxjPx8wq9KVG/0oMJZ+zFnka3lx7RwcMURtXq02N0HyyyoQ3huwQOw1rgmCwI2il6RgbX6wVw==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr1897186wmo.68.1618390039455;
        Wed, 14 Apr 2021 01:47:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:c95a:c5e7:2490:ebe3? (p200300ea8f384600c95ac5e72490ebe3.dip0.t-ipconnect.de. [2003:ea:8f38:4600:c95a:c5e7:2490:ebe3])
        by smtp.googlemail.com with ESMTPSA id d2sm22300722wrs.10.2021.04.14.01.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 01:47:19 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net v2] r8169: don't advertise pause in jumbo mode
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Roman Mamedov <rm+bko@romanrm.net>
Message-ID: <1fcf6387-f5ee-40f7-d368-37503a81879b@gmail.com>
Date:   Wed, 14 Apr 2021 10:47:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been reported [0] that using pause frames in jumbo mode impacts
performance. There's no available chip documentation, but vendor
drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
do the same, according to Roman it fixes the issue.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=212617

Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
Reported-by: Roman Mamedov <rm+bko@romanrm.net>
Tested-by: Roman Mamedov <rm+bko@romanrm.net>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Cc: stable@vger.kernel.org
---
This patch doesn't apply cleanly on some kernel versions, but the needed
changes are trivial.
v2: added cc stable in sign-off area
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1b48084f2..7d02bab1c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2386,6 +2386,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 
 	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
 		pcie_set_readrq(tp->pci_dev, readrq);
+
+	/* Chip doesn't support pause in jumbo mode */
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	phy_start_aneg(tp->phydev);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
@@ -4647,8 +4654,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (!tp->supports_gmii)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	phy_support_asym_pause(phydev);
-
 	phy_attached_info(phydev);
 
 	return 0;
-- 
2.31.1

