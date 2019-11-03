Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B3FED194
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 04:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfKCDRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 23:17:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35690 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfKCDRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 23:17:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id 8so5628611wmo.0;
        Sat, 02 Nov 2019 20:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pxIGu3u5xJbOz4wi1IVD6IMKrp2EyQWpsAtO+pdvP2g=;
        b=PbeFQcRHCdG34JCzSRtBVCTb7HOzB+UI66b74r3Q6uVOJJmgO8kZtdu3MgubpuL8aX
         /Uq0CzdrpQCkbRHF4W96g0pdBMPS5+JZInSnNbYhSPbL7misLSo93OSo9RWkn+LsF2Yz
         JuuYBpbcT8DEbq63qoyGlphTTqfSxulQad66mmfOEhEbIcCcvFcjGaa8icZFT2IZUMba
         gXF8aJ9Rfm1uJqpZJswCnTbU7ikRXpV2pEsSd2BvbG19IzQD+YDZW5RGjxqok1xWBrw8
         Tl8WdMtubogJX3tE5jtfOS+uz+dRTcbxxClmutLJl0erjNRNeRH+8QSw0cmPVPYEN99g
         kB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pxIGu3u5xJbOz4wi1IVD6IMKrp2EyQWpsAtO+pdvP2g=;
        b=HjM9yqFyAZvexq1kAqA255Jh4O6Lm0JEei1K3rKSvRVrN/+Em1Fjsg+6PhSsrWEeuN
         sFEtCTB+nBsBj1GaNXmwHjLzkpeB6jHgbIhujjZkQu3R7M9tmxVFXKgrHqhuK71X4sfV
         3kOxiPqB+9vXf4GINXjFzPxmfn/0mHyFVetUzI+8mT2TqYTlQ/HkItll/1IeFU7WvilP
         HYWzdHDzwrcrACy7xCnmajhGf04SD086F2HyBBrGVDmynm6AkCq0/J7RufbO0Qtiaf/E
         B2CBYH8RDHCZsoIusukVYWgr4/n5WzJv/Hp+ibUWGRzG8He/8Gu0RJ6PFibAfU3eJMC7
         ZPaw==
X-Gm-Message-State: APjAAAX/ys+kxoTOnED3n5ArgXyJHGpJRNo0EhfecF0dWPbI0qwBpbfW
        5z2YlV6AV5wbBqT4pmQHpxGCtO7J
X-Google-Smtp-Source: APXvYqxtljDCXaHSrD9EnZ1CDXDcKud1jCmDEiHU6ZjIh4z5h7GoLR25TE/G96ad2eGyntYoHm4Gqw==
X-Received: by 2002:a1c:f302:: with SMTP id q2mr17848091wmq.142.1572751065271;
        Sat, 02 Nov 2019 20:17:45 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p15sm13149147wrs.94.2019.11.02.20.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 20:17:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     rmk+kernel@armlinux.org.uk, hkallweit1@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Fix driver removal
Date:   Sat,  2 Nov 2019 20:17:39 -0700
Message-Id: <20191103031739.27157-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the DSA core doing the call to dsa_port_disable() we do not need to
do that within the driver itself. This could cause an use after free
since past dsa_unregister_switch() we should not be accessing any
dsa_switch internal structures.

Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index a4a46f8df352..79748ca30c33 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1212,10 +1212,10 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
 	struct bcm_sf2_priv *priv = platform_get_drvdata(pdev);
 
 	priv->wol_ports_mask = 0;
+	/* Disable interrupts */
+	bcm_sf2_intr_disable(priv);
 	dsa_unregister_switch(priv->dev->ds);
 	bcm_sf2_cfp_exit(priv->dev->ds);
-	/* Disable all ports and interrupts */
-	bcm_sf2_sw_suspend(priv->dev->ds);
 	bcm_sf2_mdio_unregister(priv);
 
 	return 0;
-- 
2.17.1

