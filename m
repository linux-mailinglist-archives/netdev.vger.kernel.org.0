Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC8B519E79
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343995AbiEDLut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 07:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiEDLus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 07:50:48 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBE05F91;
        Wed,  4 May 2022 04:47:12 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id y63so909658oia.7;
        Wed, 04 May 2022 04:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bz0AXE0SYU2skMQoICtZi7uVEPUJbgHpcnH6xCu008Y=;
        b=etLbOLwao7AqW0NXetY0eNvLOUZyGwjWwIG+eJWINm2VL/HiIVvXoZFSZd5eZ9ISg5
         LszcjcVMJeo2i7rPfgTjaTst0kguZV33G6Ysl12jFR/RBczm9jxzoLy0lqLJPaKl5vP0
         T1EM8GLxWr+wyT/WEp7yMUuLLNnO96BJSAuSW+q+oGPJOzlTzBMucOx8omJTdHWmetgp
         OYzja1PkMQ1K3YuwOP21HFHQWjE8JduXmkg18dSeR3rwUn/TZDD6iHUKMTqLD0zKZD5k
         rJyidF0Mice/PNhZESimr/AcBzWJ3bTyNNFrLoYyEDUbPEuZqCLeEHB/IJIr4eenQbOj
         kZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bz0AXE0SYU2skMQoICtZi7uVEPUJbgHpcnH6xCu008Y=;
        b=gPDE/hvWaPlwkxRM+ofWvW5gdmDdRqO440/x4N6nhzViyv7l+BJPQ2SfX2r1MYYFrW
         dx/7QJfLXhs4ZPidUkj+czR4fX/2Nd1nWiODDiJZFSBHVjwVhcN9X/r6EdvZdDcsM1i+
         +OHiIl9qSzeIJMPigf8l9y0wWWi/2AtL2NKp9Tne0zWYNswfmwPsci9bRGvkyH82uoaJ
         TobmoF9miEt+064ljsWrohjIxFye1kRZzKh6u1tDAHO0gGZ64httcZemjl+BA/bckKTn
         OB7grKyXRHi2XNeoYOqaLyfwDO7gF4fAI9PGfJiRa2rbpJBaqyN9wixwjnw8T7iTy4sF
         +ISQ==
X-Gm-Message-State: AOAM531PKhlpISH+lxX3SvxHSjqOiZVOD2OS6jbO9LQxKgdmqjGqytzT
        /vZ7/lkkL+0aQYyTJgZk/0w=
X-Google-Smtp-Source: ABdhPJxpKwqjBkj781v/BMs2W9l1Oz7m97vbOBDVx3nJW4wBPyKhrS7vbPNbT94pTuliUQx1xKsu1A==
X-Received: by 2002:a05:6808:682:b0:325:667c:821a with SMTP id k2-20020a056808068200b00325667c821amr3715051oig.14.1651664832105;
        Wed, 04 May 2022 04:47:12 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:6ef3:840d:df28:4651])
        by smtp.gmail.com with ESMTPSA id c19-20020a9d7853000000b006060322124csm5026305otm.28.2022.05.04.04.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 04:47:11 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        linux@armlinux.org.uk, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: [PATCH] net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
Date:   Wed,  4 May 2022 08:47:03 -0300
Message-Id: <20220504114703.1229615-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

Since commit f1131b9c23fb ("net: phy: micrel: use
kszphy_suspend()/kszphy_resume for irq aware devices") the following
NULL pointer dereference is observed on a board with KSZ8061:

 # udhcpc -i eth0
udhcpc: started, v1.35.0
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000008
pgd = f73cef4e
[00000008] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
Hardware name: Freescale i.MX6 SoloX (Device Tree)
PC is at kszphy_config_reset+0x10/0x114
LR is at kszphy_resume+0x24/0x64
...

The KSZ8061 phy_driver structure does not have the .probe/..driver_data
fields, which means that priv is not allocated.

This causes the NULL pointer dereference inside kszphy_config_reset().

Fix the problem by using the generic suspend/resume functions as before.

Cc: stable@vger.kernel.org
Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 685a0ab5453c..11cd073630e5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3021,8 +3021,8 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz8061_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
-- 
2.25.1

