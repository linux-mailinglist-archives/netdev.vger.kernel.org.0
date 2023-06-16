Return-Path: <netdev+bounces-11355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7417A732B91
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 863C41C20F79
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5950D154A5;
	Fri, 16 Jun 2023 09:30:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021556117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF97EC433CA;
	Fri, 16 Jun 2023 09:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686907817;
	bh=0LCiNW47vz9emKUNT6ghLeNK5ZkmMsQ8k9618ObBVAY=;
	h=From:To:Cc:Subject:Date:From;
	b=RFV0xw4rvVEg653MXihwltNfQZDxkpwhr2f/xjdVLCt8vLzv0j2Kx7BJQZBcCMew8
	 jpi1fc4WiXoZMdDVhDV2ZA6zF2ybZxYKtrWyRnOYuG11gj8ojIUoul6c+BaIcDN5ed
	 2CSLn8KDPvgytauycmr4EiD7bUB4gxFYyvc02Yij5ROssojdhQh0tReT+o0Cu8gV6Z
	 7xOLWD64XznEkiOolp5NfjxqQ6PgaLIGR+/hIzc6TLd/k3rQ5G7+lCYBrfX/AFcKbj
	 AhqtzTzv1a+pwziGilkVzyk+WQN9knrCIUdprSrdstxLQX4EoW8LZWf7GJV5gRfKih
	 STgq8ZDc0xN5A==
From: Arnd Bergmann <arnd@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Ram=C3=B3n=20Nordin=20Rodriguez?= <ramon.nordin.rodriguez@ferroamp.se>,
	Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
	Frank Sae <Frank.Sae@motor-comm.com>,
	Michael Walle <michael@walle.cc>,
	Daniel Golle <daniel@makrotopia.org>,
	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] net: phy: mediatek: fix compile-test dependencies
Date: Fri, 16 Jun 2023 11:29:54 +0200
Message-Id: <20230616093009.3511692-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The new phy driver attempts to select a driver from another subsystem,
but that fails when the NVMEM subsystem is disabled:

WARNING: unmet direct dependencies detected for NVMEM_MTK_EFUSE
  Depends on [n]: NVMEM [=n] && (ARCH_MEDIATEK [=n] || COMPILE_TEST [=y]) && HAS_IOMEM [=y]
  Selected by [y]:
  - MEDIATEK_GE_SOC_PHY [=y] && NETDEVICES [=y] && PHYLIB [=y] && (ARM64 && ARCH_MEDIATEK [=n] || COMPILE_TEST [=y])

I could not see an actual compile time dependency, so presumably this
is only needed for for working correctly but not technically a dependency
on that particular nvmem driver implementation, so it would likely
be safe to remove the select for compile testing.

To keep the spirit of the original 'select', just replace this with a
'depends on' that ensures that the driver will work but does not get in
the way of build testing.

Fixes: 98c485eaf509b ("net: phy: add driver for MediaTek SoC built-in GE PHYs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index a40269c175974..78e6981650d94 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -239,7 +239,7 @@ config MEDIATEK_GE_PHY
 config MEDIATEK_GE_SOC_PHY
 	tristate "MediaTek SoC Ethernet PHYs"
 	depends on (ARM64 && ARCH_MEDIATEK) || COMPILE_TEST
-	select NVMEM_MTK_EFUSE
+	depends on NVMEM_MTK_EFUSE
 	help
 	  Supports MediaTek SoC built-in Gigabit Ethernet PHYs.
 
-- 
2.39.2


