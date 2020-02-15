Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0199115FF4E
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgBOQyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:54:40 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:43237 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOQyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 11:54:39 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48KbvH5BXfz1rbLm;
        Sat, 15 Feb 2020 17:54:35 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48KbvH4cDgz1r0bw;
        Sat, 15 Feb 2020 17:54:35 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id KcRQMSUFydrG; Sat, 15 Feb 2020 17:54:34 +0100 (CET)
X-Auth-Info: zdhBrOXxaVj0r6zLO/8sd0HjQfWIW+WSoKDc/aupE4E=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 15 Feb 2020 17:54:34 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V2 3/3] net: ks8851-ml: Fix 16-bit IO operation
Date:   Sat, 15 Feb 2020 17:54:19 +0100
Message-Id: <20200215165419.3901611-3-marex@denx.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200215165419.3901611-1-marex@denx.de>
References: <20200215165419.3901611-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Micrel KSZ8851-16MLLI datasheet DS00002357B page 12 states that
BE[3:0] signals are active high. This contradicts the measurements
of the behavior of the actual chip, where these signals behave as
active low. For example, to read the CIDER register, the bus must
expose 0xc0c0 during the address phase, which means BE[3:0]=4'b1100.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: No change
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 5ae206ae5d2b..1c9e70c8cc30 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -166,7 +166,7 @@ static int msg_enable;
 
 static u16 ks_rdreg16(struct ks_net *ks, int offset)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	return ioread16(ks->hw_addr);
 }
@@ -181,7 +181,7 @@ static u16 ks_rdreg16(struct ks_net *ks, int offset)
 
 static void ks_wrreg16(struct ks_net *ks, int offset, u16 value)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	iowrite16(value, ks->hw_addr);
 }
-- 
2.25.0

