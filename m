Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCD2285E40
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 13:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgJGLfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 07:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgJGLfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 07:35:02 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C290AC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 04:35:01 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id h24so2431800ejg.9
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 04:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qpbccRU/eQ4nkgRTKu6SfMGnl7KJDpIW3VK2LHVRiHs=;
        b=SaGz6lkp9db3hileuTGhN4su4DlsXvn1Oy0+oIwrONznEPDjyjfhQBit5e8Dnz/wrX
         syr6MZTvmKN0nsoYbqRE74197hJFoTXBlFFTmjqbBlMqIFgVWTBWo53SWqVKuVCYzDtJ
         mDXs6GTn2uzZHAzWVsSucL9h7R9La/HXGP+eZDW3BO06dJ5tkD5mHQDWnXWjEMrUFixq
         TmhbDwnZwHYPNJzC+HE5a8ALbWE/Qrn+h3VsD4sooKVJtjPrLnFg0rD9dadhJkU6p0kN
         57LuP1Hj4Uf7Ex9/iMQ+/k48LORUPGdaeBrZRBlSm2oBGzo9/mQHEVRVbvFAnHfMPFQ1
         ifTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qpbccRU/eQ4nkgRTKu6SfMGnl7KJDpIW3VK2LHVRiHs=;
        b=iC2LON2ZGfZqHeleN19WB3+hMI7vm83KuVXu5OzVYW+EHSRz4/eo4xqQbMWvrtPeq0
         rfEdxvd4cMtUPe9MhUYGx9f4YNS0pTi0XzP8qMxm4xmslaiyrk09kAwbTLYo5d+1qfoy
         aCNJ/s6BM+CeyoqLYayOGol9MmGKvRcEV68fsQ1h+nTnO4s2OmhVhzYMhjbkr1v6LQDm
         yNVQ7CYBkt4+YuRpZQqZCGrz7fJHzSkSfMPAk/3+ChG6wD90h5HZM9YPxkJx9phfFeax
         ibuoUCO4MaWZ/LFB4DF8sxXvHlNeeMKbli7SQSg9Ogf/RH+uXWbAGybhMwawU+QJDhUX
         5Rag==
X-Gm-Message-State: AOAM531Q/d+IZ1laavKV9gsmBT2fLvo/PnH7Pr9PbRceQQNmJKdjGZvG
        Sq4Y0bNVSLJu2VuH40LMM/POMzb5ooF1+A==
X-Google-Smtp-Source: ABdhPJwg1B2Qgd2jxUvHUvAKRd+Mxrh85txq3WaNjb9pTrFP3wRHNwDCKYeRCF0HjrnaT1YfJgGVPw==
X-Received: by 2002:a17:907:40bb:: with SMTP id nu19mr2756847ejb.246.1602070500159;
        Wed, 07 Oct 2020 04:35:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:dcf9:e560:b3a:3a15? (p200300ea8f006a00dcf9e5600b3a3a15.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:dcf9:e560:b3a:3a15])
        by smtp.googlemail.com with ESMTPSA id c17sm1298449ejb.15.2020.10.07.04.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 04:34:59 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: consider that PHY reset may still be in progress
 after applying firmware
Message-ID: <a89cee3b-caa0-99aa-d7a2-de4257204db4@gmail.com>
Date:   Wed, 7 Oct 2020 13:34:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some firmware files trigger a PHY soft reset and don't wait for it to
be finished. PHY register writes directly after applying the firmware
may fail or provide unexpected results therefore. Fix this by waiting
for bit BMCR_RESET to be cleared after applying firmware.

There's nothing wrong with the referenced change, it's just that the
fix will apply cleanly only after this change.

Fixes: 89fbd26cca7e ("r8169: fix firmware not resetting tp->ocp_base")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0fa99298a..9afd1ef57 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2055,11 +2055,18 @@ static void rtl_release_firmware(struct rtl8169_private *tp)
 
 void r8169_apply_firmware(struct rtl8169_private *tp)
 {
+	int val;
+
 	/* TODO: release firmware if rtl_fw_write_firmware signals failure. */
 	if (tp->rtl_fw) {
 		rtl_fw_write_firmware(tp, tp->rtl_fw);
 		/* At least one firmware doesn't reset tp->ocp_base. */
 		tp->ocp_base = OCP_STD_PHY_BASE;
+
+		/* PHY soft reset may still be in progress */
+		phy_read_poll_timeout(tp->phydev, MII_BMCR, val,
+				      !(val & BMCR_RESET),
+				      50000, 600000, true);
 	}
 }
 
-- 
2.28.0

