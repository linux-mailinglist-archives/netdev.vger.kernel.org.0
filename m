Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7ADA35EE8F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348092AbhDNHl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbhDNHlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:41:24 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5CEC061574;
        Wed, 14 Apr 2021 00:41:02 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so2131775wmq.1;
        Wed, 14 Apr 2021 00:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=UasjkY44wWTQTAzdeMirX8rS/dwaZ9OE+lBiPq6Cr+g=;
        b=I0O0m/PpJM2+gbWKun63C6xLUpVBHog3TYMWxAdrjl+5eiBIiMldsDVpCA5TgV1VnQ
         LmAe5rNdnplBcnmv6c2rYkieBF/c1I4c8V10rwCWTup7WI/bvmpph6rDRo6Mo7y/VIj7
         PoQUnFqKSjtsFtmWec8elcA6rvDmSEVvQRo67ajmiF4J1w607P5sK+3wcCk8J7xpl/8B
         hxbnUzY9nnyDVqaVjUSSOUCwZLDTP8ZxhiWtx5C2Z32nEXFlE9KAc68m4Fs+a+uF/Wsx
         v9hZPUAHg2RSI55YMbKDFO/58YY6Z/LY5blsF2cVksVnzvAtmnBkQuoRXd7WCjDgO46Y
         PmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=UasjkY44wWTQTAzdeMirX8rS/dwaZ9OE+lBiPq6Cr+g=;
        b=nmDJaYE/i2MKj/3wuyghIlDZxyjUynknhnfr87Yo0Okz5FjnbViGxFEWlY34S/tmyi
         /oyP9OVW5VL3fM2Y/IbX8FmL8aHsCSmSvZNov00aaNzqZlJ0ARe2T2tuqCR9iwryaFzY
         QCAm1E5tM45GMuGI0S+EXXF3nJRvQIQFPPlze0rbpk3qbNBQcixS8ikh+6jhHBvsDRjy
         JkUU60lbskT5yAmZXxZMJawLVKuY6eleQqZkIqRZnXtFqSUQzdKj4tzjMgQ+/R4ROj5c
         p2yqaMzYvmeWydMnB9sRLy0N8Pvd8b1TMwB0m20ewOcTMDeH2hcwURibYf87vNIUDVEP
         c5jA==
X-Gm-Message-State: AOAM532slp1X6eOmaEMUSUF18hmZ2LAU81r7gvP6TwijQidOFtWuO/Xv
        wrO7X/hsSTbEEtwEuasGZV38o9tSadszhw==
X-Google-Smtp-Source: ABdhPJzia43nxVw/1gwOley2wfn0MaU9XNSNQw1dvE0FKVMOE/YEUq5BswWdXT4k9r/WQI6kWXHfrA==
X-Received: by 2002:a1c:7ed3:: with SMTP id z202mr1584591wmc.136.1618386061016;
        Wed, 14 Apr 2021 00:41:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:c95a:c5e7:2490:ebe3? (p200300ea8f384600c95ac5e72490ebe3.dip0.t-ipconnect.de. [2003:ea:8f38:4600:c95a:c5e7:2490:ebe3])
        by smtp.googlemail.com with ESMTPSA id z16sm5909707wrq.21.2021.04.14.00.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 00:41:00 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Roman Mamedov <rm+bko@romanrm.net>
Subject: [PATCH net] r8169: don't advertise pause in jumbo mode
Message-ID: <e249e2fb-ba51-a62e-f2e7-5011c3790830@gmail.com>
Date:   Wed, 14 Apr 2021 09:40:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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
---
This patch doesn't apply cleanly on some kernel versions, but the needed
changes are trivial.
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

