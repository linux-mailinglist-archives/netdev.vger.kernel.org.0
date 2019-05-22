Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041452611D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 12:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfEVKBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 06:01:09 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:23941 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbfEVKBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 06:01:09 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4587SL4VkZz9v2M2;
        Wed, 22 May 2019 12:01:06 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=qqOlTXMN; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id htw2hqspO0bf; Wed, 22 May 2019 12:01:06 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4587SL3TkDz9v2M1;
        Wed, 22 May 2019 12:01:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558519266; bh=pOJgHp/KMoeYEIwsOCZddIB2aTQYV+vwh0CSHycpDpI=;
        h=From:Subject:To:Cc:Date:From;
        b=qqOlTXMNNHJOMdk1N0HS5Hzpjr/2y4ypZNow5W/PI1QnLs7xTU5AODc1lbH+yW2YQ
         4sE+CEJBwutOJwezWalBSKhSPl0OETTs8Qdl/cHuf7CvaUOTtcsf5OQ3d+mF1hdRn5
         mbkCkumtsx09O8bpHrNBhw6w1FgIKFul1ZKY43uU=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 932128B82C;
        Wed, 22 May 2019 12:01:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id g2u_VzR4Vwh9; Wed, 22 May 2019 12:01:07 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 644268B823;
        Wed, 22 May 2019 12:01:07 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 2B677684F2; Wed, 22 May 2019 10:01:07 +0000 (UTC)
Message-Id: <cf280b7ab1f513f03d3908ac9ad194e819f170f5.1558519026.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] net: phy: lxt: Add suspend/resume support to LXT971 and
 LXT973.
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 22 May 2019 10:01:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All LXT PHYs implement the standard "power down" bit 11 of
BMCR, so this patch adds support using the generic
genphy_{suspend,resume} functions.

LXT970 is left aside because all registers get cleared upon
"power down" exit.

Fixes: 0f0ca340e57b ("phy: power management support")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/net/phy/lxt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index 314486288119..356bd6472f49 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -262,6 +262,8 @@ static struct phy_driver lxt97x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt	= lxt971_ack_interrupt,
 	.config_intr	= lxt971_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= 0x00137a10,
 	.name		= "LXT973-A2",
@@ -271,6 +273,8 @@ static struct phy_driver lxt97x_driver[] = {
 	.probe		= lxt973_probe,
 	.config_aneg	= lxt973_config_aneg,
 	.read_status	= lxt973a2_read_status,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= 0x00137a10,
 	.name		= "LXT973",
@@ -279,6 +283,8 @@ static struct phy_driver lxt97x_driver[] = {
 	.flags		= 0,
 	.probe		= lxt973_probe,
 	.config_aneg	= lxt973_config_aneg,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 } };
 
 module_phy_driver(lxt97x_driver);
-- 
2.13.3

