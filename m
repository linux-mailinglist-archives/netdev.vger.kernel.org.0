Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E354D1CFE99
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgELTp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgELTp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:45:58 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E049C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:45:58 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so25155852wma.4
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=KLCscuQOlnUBSAz+f+ceaW+MwPSkA0Ia974a4ZvZor8=;
        b=Q/o7siEsfyDG7JjYBJ65KNME7Dc+vOpHURhp0Dgz9itOdNAy36nWGoOBafd/PQjtAF
         S8B1/a2PtEUAK1v1dfniKe3t035tcaFxR9mwPq9tTgTB95xy+b2gbnxzZ1Rd9ENdPVM9
         d/cVnfPGxZLP96t8HpqiPM+nYGihrAnpFLDyoRiSVPK2UZt3+siNypjD7Q1lt0Ee3m5x
         NsAH7lZSZRXN/EhOFhRekoH3zOcBMms/o2laS8BN2KPZFnz7Z1mvn7DRsavnCRSvR8f9
         Tx3GnJBcal9qYmRQ7eSaxjYA5Ed6crgBu6hvlLF72tHx0cX1xPp3FSXHO5GnuuajYrjr
         bq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=KLCscuQOlnUBSAz+f+ceaW+MwPSkA0Ia974a4ZvZor8=;
        b=MYxN5FCViSydMSFKX6aEHy6QTXWbZbx9TOdViUNoZuLMtMttwDQfVszPIthx3WMfO4
         7rUx/c/sbXW47rNHalZE7R5dW5kvZWkjQ7wyeWWyWzT9RIFx6xbK+8ZuzdPqhfLJqjsS
         1SXi62AsasKieGFElfgMX4lvBzB9IldF4/gqZ6DUM6KZnYERMf8hGykIzBPfHWx09e3w
         lAJM4NNGnfEuluTkecXb5VXfOkWQRWvG2UsoWhitVlGXBH6iIbtvq/KY5kfUolHQr0K6
         vb3TwFzD7M8z8gc3CekneibJVI0WEHcTSOc/VWkgvTqhE8S0ix/YFjXj8Xm5U3WEpefP
         ApQw==
X-Gm-Message-State: AGi0PuYOpDLKoFHAKIaxJ9Dm3P8g31OPWxymRSxtFwz6Ke5wJumBVgo8
        Z4G95bI4t3Bf5GBaTnDaNTRWHbL5
X-Google-Smtp-Source: APiQypLloRoh4SW+ERgv9Vm55d19OSNpnpMAhInAdxDLxmvr9i70B3PRSjkNPRhBm/DCZuWPkp4t4g==
X-Received: by 2002:a1c:1b4d:: with SMTP id b74mr10691534wmb.123.1589312756852;
        Tue, 12 May 2020 12:45:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:d932:d3d0:91da:45c2? (p200300EA8F285200D932D3D091DA45C2.dip0.t-ipconnect.de. [2003:ea:8f28:5200:d932:d3d0:91da:45c2])
        by smtp.googlemail.com with ESMTPSA id t22sm3155761wmj.37.2020.05.12.12.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 12:45:56 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: fix aneg restart in phy_ethtool_set_eee
Message-ID: <2a8c3ca7-4ef3-3dd7-6276-759f66ab8b5e@gmail.com>
Date:   Tue, 12 May 2020 21:45:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_restart_aneg() enables aneg in the PHY. That's not what we want
if phydev->autoneg is disabled. In this case still update EEE
advertisement register, but don't enable aneg and don't trigger an
aneg restart.

Fixes: f75abeb8338e ("net: phy: restart phy autonegotiation after EEE advertisment change")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 9bdc924ee..d4bbf79da 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1240,9 +1240,11 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 		/* Restart autonegotiation so the new modes get sent to the
 		 * link partner.
 		 */
-		ret = phy_restart_aneg(phydev);
-		if (ret < 0)
-			return ret;
+		if (phydev->autoneg == AUTONEG_ENABLE) {
+			ret = phy_restart_aneg(phydev);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	return 0;
-- 
2.26.2

