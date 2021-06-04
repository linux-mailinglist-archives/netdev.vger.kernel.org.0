Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E9639B905
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhFDMcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:32:13 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:50899 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFDMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 08:32:13 -0400
Received: from mwalle01.fritz.box (ip4d17858c.dynamic.kabel-deutschland.de [77.23.133.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 188FA22236;
        Fri,  4 Jun 2021 14:30:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1622809825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CAnAXlwU45hkznl5COHuIJn6xAcpnJsZHjHpj93Ttt4=;
        b=cmvUCpT3Up07Bk5jHp9HHKyOjMk7Uxx1CkHKjVNx++1c/xmntmBYgrTXqYFdXVT1fFylAA
        NSKWNeRE0zoH09Gr03Cva6011mxWNImIw3qB/lvjMhW1bsJ1eCemYilAsimxjjxnnS5OGe
        nhkEEhdHhec1cw8fmDdoBC79FydylWE=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: enetc: use get/put_unaligned() for mac address handling
Date:   Fri,  4 Jun 2021 14:30:18 +0200
Message-Id: <20210604123018.24940-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The supplied buffer for the MAC address might not be aligned. Thus
doing a 32bit (or 16bit) access could be on an unaligned address. For
now, enetc is only used on aarch64 which can do unaligned accesses, thus
there is no error. In any case, be correct and use the get/put_unaligned()
helpers.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 31274325159a..a96d2acb5e11 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2017-2019 NXP */
 
+#include <asm/unaligned.h>
 #include <linux/mdio.h>
 #include <linux/module.h>
 #include <linux/fsl/enetc_mdio.h>
@@ -17,15 +18,15 @@ static void enetc_pf_get_primary_mac_addr(struct enetc_hw *hw, int si, u8 *addr)
 	u32 upper = __raw_readl(hw->port + ENETC_PSIPMAR0(si));
 	u16 lower = __raw_readw(hw->port + ENETC_PSIPMAR1(si));
 
-	*(u32 *)addr = upper;
-	*(u16 *)(addr + 4) = lower;
+	put_unaligned(upper, (u32 *)addr);
+	put_unaligned(lower, (u16 *)(addr + 4));
 }
 
 static void enetc_pf_set_primary_mac_addr(struct enetc_hw *hw, int si,
 					  const u8 *addr)
 {
-	u32 upper = *(const u32 *)addr;
-	u16 lower = *(const u16 *)(addr + 4);
+	u32 upper = get_unaligned((const u32 *)addr);
+	u16 lower = get_unaligned((const u16 *)(addr + 4));
 
 	__raw_writel(upper, hw->port + ENETC_PSIPMAR0(si));
 	__raw_writew(lower, hw->port + ENETC_PSIPMAR1(si));
-- 
2.20.1

