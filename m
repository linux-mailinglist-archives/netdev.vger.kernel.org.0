Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7664F3382ED
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhCLAx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhCLAxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:53:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FF9C061574;
        Thu, 11 Mar 2021 16:53:02 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id bt4so4324457pjb.5;
        Thu, 11 Mar 2021 16:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMFqKRtgcs+0ebOYFdj+44tpkQFNCqnBlU/CvJWBuDU=;
        b=NQGFr/9BtzOWNGk4TF3mbMQjvIfJXrzqXbX/HRuRhBtZOciXZzlfdvOcml3elyXK7K
         rv2vLMW6fwC2BonjNxQhTX9u/7qSkVCtsZnzLabfS+s81Glq0okX3/tb3u+fPckWqyg+
         1meerjcOBPMLylZ2fjSeuVEeForjVNV+CI49KzFakXwwchlVJFiHV6cLDHFuOyHIdIdV
         BjerrmBtAmakLcLfS71lK76hZQonQM107FLAf6I13Dg1UsJ+BLvDLgEV0/8aNdX5ojVe
         0cxb1xfdMfkpghln3PT9xezP4D/Q2w2rhRCNDlJxifYQYsDFoRsPAWTecGATNP57EBJL
         kz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMFqKRtgcs+0ebOYFdj+44tpkQFNCqnBlU/CvJWBuDU=;
        b=AmgkpYgLurW3fazA/0EmhVmnL8xKGsZ8mwQRvV3o7ix1cyGKtO2dfsag6Ux0M2Jxgp
         JQf3DxuN5SzqbdP6a0DkRuuLNxhtzVn3r5qnjbzomaTKkE0mREoJWlkeYUukXgBOxqZl
         9qXe/35rHXoJ4/c5Z2IwIPjzUxrafoXBT1Vi3QgcXZf9MPaI8RDsAz8nm5NsIRLQ/6bI
         g251XiOLV7FWvGfUcuwDfT4cCpkL2ZoE6riLC2HB+7aaayeVKTGYagKZdt2aC6O/g4xD
         mYlW2POjbvA43+h1blPJRDSOdlWNivbulkilIzkhkk37JT4P43+acuYs9+pT+d+bIGoW
         Ew2Q==
X-Gm-Message-State: AOAM533umiSnKsMxufru7eVMPWgTgw7DbL5pEvQDFaAs6r+8yo7phwPi
        38npwoiiGJEvuIVGbtRN9BlJiQ8TlCo=
X-Google-Smtp-Source: ABdhPJzU/8gzgNU0reee2x/1TuHv1YF8O6jb+VuWwtYh9PXxS3De1BKhvGnSz0XW5gKMhDt/EoV8zg==
X-Received: by 2002:a17:902:be06:b029:e3:7031:bef with SMTP id r6-20020a170902be06b02900e370310befmr10763852pls.19.1615510381644;
        Thu, 11 Mar 2021 16:53:01 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x14sm3554079pfm.207.2021.03.11.16.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 16:53:01 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Abhishek Shah <abhishek.shah@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: broadcom: Fix RGMII delays for BCM50160 and BCM50610M
Date:   Thu, 11 Mar 2021 16:52:50 -0800
Message-Id: <20210312005251.3353889-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY driver entry for BCM50160 and BCM50610M calls
bcm54xx_config_init() but does not call bcm54xx_config_clock_delay() in
order to configuration appropriate clock delays on the PHY, fix that.

Fixes: 733336262b28 ("net: phy: Allow BCM5481x PHYs to setup internal TX/RX clock delay")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Hi,

More (all) PHY entries that support RGMII should arguably do the same
thing here but given that we had a bad history of seeing broken
DTS/DTBs, I prefer to take a conservative approach here and submit a
localized fix to the hardware I just had to test this on.

While this dates back to before the commit in Fixes tag, that commit
introduces the bcm54xx_config_clock_delay() function and would make it
go far enough for stable back ports.

 drivers/net/phy/broadcom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index fa0be591ae79..4c2f8bb51eef 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -342,6 +342,10 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	bcm54xx_adjust_rxrefclk(phydev);
 
 	switch (BRCM_PHY_MODEL(phydev)) {
+	case PHY_ID_BCM50610:
+	case PHY_ID_BCM50610M:
+		err = bcm54xx_config_clock_delay(phydev);
+		break;
 	case PHY_ID_BCM54210E:
 		err = bcm54210e_config_init(phydev);
 		break;
-- 
2.25.1

