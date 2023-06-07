Return-Path: <netdev+bounces-8859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C4F57261C2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C471280F4D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7474335B45;
	Wed,  7 Jun 2023 13:56:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B4B139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859C2C433EF;
	Wed,  7 Jun 2023 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686146206;
	bh=bZhwvYa05FtutRjZRtFZn41GMyv24CmHT6uPZylAuVU=;
	h=From:To:Cc:Subject:Date:From;
	b=D5AMwlgUa9w6w4Pupuocx+TfI7PB91MRhjSx1a/NTAWH2kYakHlyb8Wz01rVyXZw2
	 Bx3Uxhdn0DKDTqQ2E2EfADvNY5pzcZ5SafvK1uD/F9fD6G14UKXStVvRw//yGP1t6r
	 E5hsecjdLS5j2uE51Xn02etZUibWI6tQvaeu98SF/i8i5R4BFye1/V1LoJz9slB+PB
	 5NzmkaqlVkdUIxz90gI7Scg/AX8lR8zIKkifGtCf5dQ7DKGUBdZMMnulBnpfsYgW1X
	 krsJQiXhaLLxRGvjMa8U+E10R3cSRLSDvxRhWu0PrSQ4ZJDuarPJp3s6lwx2ac1UPH
	 GlroLJmvOsgFA==
From: Arnd Bergmann <arnd@kernel.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Bhadram Varka <vbhadram@nvidia.com>,
	Samin Guo <samin.guo@starfivetech.com>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] stmmac: fix pcs_lynx link failure
Date: Wed,  7 Jun 2023 15:56:32 +0200
Message-Id: <20230607135638.1341101-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The mdio code in stmmac now directly links into both the lynx_pcs and
the xpcs device drivers, but the lynx_pcs dependency is only enforced
for the altera variant of stmmac, which is the one that actually uses it.

Building stmmac for a non-altera platform therefore causes a link
failure:

arm-linux-gnueabi-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
stmmac_mdio.c:(.text+0x1418): undefined reference to `lynx_pcs_destroy'

I've tried to come up with a patch that moves this dependency back into
the dwmac-socfpga.c file, but there was no easy and obvious way to
do this. It also seems that this would not be a proper solution, but
instead there should be a real abstraction for pcs drivers that lets
device drivers handle this transparently.

As the lynx_pcs driver is tiny, it appears that we can just avoid the
link error by always forcing it to be built when the stmmac driver
is, even for non-altera platforms. This matches what we already do
for the xpcs variant that is used by the intel and tegra variants of
stmmac.

Fixes: 5d1f3fe7d2d54 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 5583f0b055ec7..fa956f2081a53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -5,6 +5,7 @@ config STMMAC_ETH
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	select PCS_XPCS
+	select PCS_LYNX
 	select PAGE_POOL
 	select PHYLINK
 	select CRC32
@@ -160,7 +161,6 @@ config DWMAC_SOCFPGA
 	select MFD_SYSCON
 	select MDIO_REGMAP
 	select REGMAP_MMIO
-	select PCS_LYNX
 	help
 	  Support for ethernet controller on Altera SOCFPGA
 
-- 
2.39.2


