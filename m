Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0EE1582D5
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgBJSmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:42:01 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:36019 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbgBJSmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:42:00 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48GZWV2zMxz1rhsG;
        Mon, 10 Feb 2020 19:41:56 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48GZWS0vHBz1qxyg;
        Mon, 10 Feb 2020 19:41:56 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id tk3HDAiWYGpF; Mon, 10 Feb 2020 19:41:55 +0100 (CET)
X-Auth-Info: bSEvQ/1mRaBBa2wsRHGu4Pb2zILCuz9PyNuX6qikPKw=
Received: from chi.lan (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 10 Feb 2020 19:41:55 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 3/3] net: ks8851-ml: Fix 16-bit IO operation
Date:   Mon, 10 Feb 2020 19:41:39 +0100
Message-Id: <20200210184139.342716-3-marex@denx.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200210184139.342716-1-marex@denx.de>
References: <20200210184139.342716-1-marex@denx.de>
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
 drivers/net/ethernet/micrel/ks8851_mll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index e9ca198a67a4..0729b95d555c 100644
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
2.24.1

