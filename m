Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE410E152
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 10:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfLAJwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 04:52:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40616 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfLAJwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 04:52:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so15791849wrn.7
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 01:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Cjqp4JaqLM1CQuxFZiKhP6oydye6L9xkRZC0wwMTMk8=;
        b=gp/OIFcOLpNfxCKhhxmPs28mlZXzCh2wA/FWJQtv5pRCMPagQ5+kcOSDwosQ4LVHuA
         F1xcb6qxmSmEvydjGroH3i+4uRiLJnb+5eohv4dVgObJ0Euk7AsiP/EUOfqPzeUABqrB
         lya2v8P3nTZ2GDliw5a0COyhc4E0M7Uv7a27xfcLXAMhO/80arKD6Ua+HumcZLimJ8Gy
         n0Y6pIUwt43yL3e5747M2HddX6t3WB/qy9mhpoT6pw+kqMpR178pwvM7eASRpwAgrevx
         WO0CH8ZKFCNw34bhaOVTM/oeiRNNCLF8no1Ls7KaQPhDaiAMciTvR+Bucaub8Lnw3pFG
         QpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Cjqp4JaqLM1CQuxFZiKhP6oydye6L9xkRZC0wwMTMk8=;
        b=P8kS36PExogRAw16kv+LhI05f/siM+95X8MoW43FHILmpLkJWVIv8b//UW3kCmzrKy
         3M+EXL0LORja61bJq/RHbKTizhBurxzVnPjD0gdOF9pDktFIOiiQIucE3Bh3wFMIDThi
         SG8nd+vMvRHBLqt2gtUJ3wsM72lmp6Pe6TK/590UMUoHyz3Jo5s1GHUMOagoAqzECWH2
         6+PmEnhFj0xm2iaGlNy75Q07D772SgumRx+kp8KUzogPi0m4NCapuBvxOgJHKd2ojPuU
         ZPWTYKXf3BmQNe/BFqGidgC7vwIokUMoFxB53fCrU7XQ8b6RkF+rHdNEjrd24KuKyrtv
         KUfQ==
X-Gm-Message-State: APjAAAVSyNUUjA4MlAlqpBx4FS3SGFG/cpbtj2CZwxMG2nB8SqSbwKux
        7twLchbQgptXQF/75w4TjRo=
X-Google-Smtp-Source: APXvYqxRbb5VZlTwR341MQPsZt+RKGbJidByjEXtNU3gIk/4yTLEIgD3WQ0bqhMoqUuYytTTndxbig==
X-Received: by 2002:adf:dd51:: with SMTP id u17mr28353698wrm.290.1575193925309;
        Sun, 01 Dec 2019 01:52:05 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:1159:8f18:7fad:7ef1? (p200300EA8F4A630011598F187FAD7EF1.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:1159:8f18:7fad:7ef1])
        by smtp.googlemail.com with ESMTPSA id e16sm34835440wrj.80.2019.12.01.01.52.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Dec 2019 01:52:04 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: realtek: fix using paged operations with
 RTL8105e / RTL8208
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        jhdskag3 <jhdskag3@tutanota.com>
Message-ID: <2c4f254c-6b17-714e-81e2-96bb6b08a12d@gmail.com>
Date:   Sun, 1 Dec 2019 10:51:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported [0] that since the referenced commit a warning is
triggered in phylib that complains about paged operations being used
with a PHY driver that doesn't support this. The commit isn't wrong,
just for one chip version (RTL8105e) no dedicated PHY driver exists
yet. So add the missing PHY driver.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=202103

Fixes: 3a129e3f9ac4 ("r8169: switch to phylib functions in more places")
Reported-by: jhdskag3 <jhdskag3@tutanota.com>
Tested-by: jhdskag3 <jhdskag3@tutanota.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 677c45985..476db5345 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -439,6 +439,15 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_MODEL(0x001cc880),
+		.name		= "RTL8208 Fast Ethernet",
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc910),
 		.name		= "RTL8211 Gigabit Ethernet",
-- 
2.24.0

