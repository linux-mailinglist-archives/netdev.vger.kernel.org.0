Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE211DEA47
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgEVOxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731130AbgEVOvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 10:51:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0921522255;
        Fri, 22 May 2020 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159114;
        bh=aVWBkr/MbZ67KkqkDZdoxyT8qvaVzqO3nHWvC9kgK+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5prBhYZcHFqOjkGNUBSIqZoW0sfZwwxHZt+TTv4fjwQ0y1soVJU+WGDPWgIePfqp
         VXVLWACD/mzCwd16Nz9ly0UPN5JFynHU2QYNV63aDsVjAXcdI+YJ2xtbnQOiL//9wC
         B9QcZLwotScwWPTRnYZpCWCJ/Yruf+LaWPwykE9o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/13] net: freescale: select CONFIG_FIXED_PHY where needed
Date:   Fri, 22 May 2020 10:51:40 -0400
Message-Id: <20200522145142.435086-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145142.435086-1-sashal@kernel.org>
References: <20200522145142.435086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 99352c79af3e5f2e4724abf37fa5a2a3299b1c81 ]

I ran into a randconfig build failure with CONFIG_FIXED_PHY=m
and CONFIG_GIANFAR=y:

x86_64-linux-ld: drivers/net/ethernet/freescale/gianfar.o:(.rodata+0x418): undefined reference to `fixed_phy_change_carrier'

It seems the same thing can happen with dpaa and ucc_geth, so change
all three to do an explicit 'select FIXED_PHY'.

The fixed-phy driver actually has an alternative stub function that
theoretically allows building network drivers when fixed-phy is
disabled, but I don't see how that would help here, as the drivers
presumably would not work then.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/Kconfig      | 2 ++
 drivers/net/ethernet/freescale/dpaa/Kconfig | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 6e490fd2345d..71f0640200bc 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -76,6 +76,7 @@ config UCC_GETH
 	depends on QUICC_ENGINE
 	select FSL_PQ_MDIO
 	select PHYLIB
+	select FIXED_PHY
 	---help---
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
@@ -89,6 +90,7 @@ config GIANFAR
 	depends on HAS_DMA
 	select FSL_PQ_MDIO
 	select PHYLIB
+	select FIXED_PHY
 	select CRC32
 	---help---
 	  This driver supports the Gigabit TSEC on the MPC83xx, MPC85xx,
diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig b/drivers/net/ethernet/freescale/dpaa/Kconfig
index a654736237a9..8fec41e57178 100644
--- a/drivers/net/ethernet/freescale/dpaa/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
@@ -2,6 +2,7 @@ menuconfig FSL_DPAA_ETH
 	tristate "DPAA Ethernet"
 	depends on FSL_DPAA && FSL_FMAN
 	select PHYLIB
+	select FIXED_PHY
 	select FSL_FMAN_MAC
 	---help---
 	  Data Path Acceleration Architecture Ethernet driver,
-- 
2.25.1

