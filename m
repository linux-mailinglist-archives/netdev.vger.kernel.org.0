Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CF81F2C31
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbgFIAVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730509AbgFHXRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4040920823;
        Mon,  8 Jun 2020 23:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658265;
        bh=pqPXEdtzPBPf0WWCLi1AJBRZpqfhU60G1WugGDK/wGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SokhHMVMStQn3RlYZz8pJcG37wLXkgdduX4x7OZ72GJKVyXEw9zJuss0FI8L8XBGI
         GajLD0sDDsUqWlg06+GzNhELcUz6+6HSF0PxwpPeLjc5kToRgRp0tUQjpZ69OCpOpT
         rBOzypDgWx/gMicyCf93ReslNK2puWQFcwd1WhLI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 272/606] net: freescale: select CONFIG_FIXED_PHY where needed
Date:   Mon,  8 Jun 2020 19:06:37 -0400
Message-Id: <20200608231211.3363633-272-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
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
index 2bd7ace0a953..bfc6bfe94d0a 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -77,6 +77,7 @@ config UCC_GETH
 	depends on QUICC_ENGINE && PPC32
 	select FSL_PQ_MDIO
 	select PHYLIB
+	select FIXED_PHY
 	---help---
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
@@ -90,6 +91,7 @@ config GIANFAR
 	depends on HAS_DMA
 	select FSL_PQ_MDIO
 	select PHYLIB
+	select FIXED_PHY
 	select CRC32
 	---help---
 	  This driver supports the Gigabit TSEC on the MPC83xx, MPC85xx,
diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig b/drivers/net/ethernet/freescale/dpaa/Kconfig
index 3b325733a4f8..0a54c7e0e4ae 100644
--- a/drivers/net/ethernet/freescale/dpaa/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
@@ -3,6 +3,7 @@ menuconfig FSL_DPAA_ETH
 	tristate "DPAA Ethernet"
 	depends on FSL_DPAA && FSL_FMAN
 	select PHYLIB
+	select FIXED_PHY
 	select FSL_FMAN_MAC
 	---help---
 	  Data Path Acceleration Architecture Ethernet driver,
-- 
2.25.1

