Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3B38CC8A
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbhEURro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238394AbhEURrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:47:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A1DC061574;
        Fri, 21 May 2021 10:46:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g24so11333326pji.4;
        Fri, 21 May 2021 10:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IZpMzIU7b+ESFAZpGC/CRxm8r6tykVrncuEN2XKqdDU=;
        b=HZ5grogS6Q+gxx1sUcRO3hYq5rM07NVuL+HhMQfmOHoHWIZO0H5J6aP3INjSdU3obL
         fxL9tiJj8epY2kUTOuTmSqVk3mrss7OUkGDmNGoRixdYHjRPosZB0EkBRBaFuCQlYavh
         M+G9TVdxnBYJvRZoYNW/zzeBvy2ZarUQjutHMsUMnzAbs92TdDcMeWzKxphDUxk0S+qt
         NBz78MiatnCy5FLzSzd7tyvh5eDqIAfiU7NcFeteQJM5iQKSlATSaIN6T8hftONntkUb
         pLikiGvQNIBRdifEDCp5QnGZwprV08xDxTTNaG/xA4ZRrwC3qMP1MmEQbEby+HkIYg7Z
         zl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IZpMzIU7b+ESFAZpGC/CRxm8r6tykVrncuEN2XKqdDU=;
        b=mvD/AQ3k7jVpmNKJOcZowQ/YPyLMf5s/VZrGBzcsY0KN5AEzbJA5bCOkPjfYHukaRA
         uTQQHeJ5IF3foyjah4j9J+cE8+fDWf9Q4M09/c/5w06GaooaR4pGMuqm+7NjAA78i11h
         2Z3Q9Z6CyA+dGTj8zHCaba79sf7N1ahQ99wzUo203eZmMAkDOAKVEoKOP65kkIPGJsxm
         DK5Gyb6fGs9/0/6LXS4NjQab5X2lqw9V95YhCDMW3fCiWXMbT14RCCP3d21mVkdgDEPM
         gpFB+zMl5oz8brmPKiExeJKSDbTYjmgcmB9Rm3ghzOdEBnPJJUv/dAnHMEhj8RpT+Sv4
         lyEQ==
X-Gm-Message-State: AOAM531t9kXnfBwxXiZrdqzUAd1VT8o1G4VX3krMvWgBnnWV3vaFDY+a
        FYbKbbbbKD2hHhp7Ksas1YGmaMd4Snk=
X-Google-Smtp-Source: ABdhPJx8jI5x0Oa8PEMibyvPc3nbmHUUTYfz1joB6ULVg+/lnhPtp6BFcxttDLqn1WgZWn8QoqRq6g==
X-Received: by 2002:a17:90a:b78d:: with SMTP id m13mr12318635pjr.177.1621619179560;
        Fri, 21 May 2021 10:46:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u12sm3957291pfm.2.2021.05.21.10.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:46:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     zajec5@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Fix bcm_sf2_reg_rgmii_cntrl() call for non-RGMII port
Date:   Fri, 21 May 2021 10:46:14 -0700
Message-Id: <20210521174614.2535824-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We cannot call bcm_sf2_reg_rgmii_cntrl() for a port that is not RGMII,
yet we do that in bcm_sf2_sw_mac_link_up() irrespective of the port's
interface. Move that read until we have properly qualified the PHY
interface mode. This avoids triggering a warning on 7278 platforms that
have GMII ports.

Fixes: 55cfeb396965 ("net: dsa: bcm_sf2: add function finding RGMII register")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
David, Jakub, please queue this up for stable because the offnending
commit is already in 5.12, thanks!

 drivers/net/dsa/bcm_sf2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 9150038b60cb..3b018fcf4412 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -821,11 +821,9 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		u32 reg_rgmii_ctrl;
+		u32 reg_rgmii_ctrl = 0;
 		u32 reg, offset;
 
-		reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
-
 		if (priv->type == BCM4908_DEVICE_ID ||
 		    priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
@@ -836,6 +834,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 		    interface == PHY_INTERFACE_MODE_MII ||
 		    interface == PHY_INTERFACE_MODE_REVMII) {
+			reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
 			reg = reg_readl(priv, reg_rgmii_ctrl);
 			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 
-- 
2.25.1

