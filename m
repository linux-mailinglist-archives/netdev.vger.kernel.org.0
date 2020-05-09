Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6DE1CC122
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgEIMFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 08:05:30 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:43349 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgEIMFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 08:05:30 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MjjKf-1irD2q0wW3-00l9tC; Sat, 09 May 2020 14:05:11 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Timur Tabi <timur@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: freescale: select CONFIG_FIXED_PHY where needed
Date:   Sat,  9 May 2020 14:04:52 +0200
Message-Id: <20200509120505.109218-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:h9yFrIRXLw4ySr/K8T7dpgPAcNBfXpgdjuBXGgfTWi/oLO0O7b3
 3QzmyhOdEV7ue+w9vVDiLKMpf6cEyPrhpuy9ycZaC+mDcp412OwvqT9hbNQh7gk5HYuSKDf
 K8mIzC0fQBKcYKur5cuxH4YbA41cpKAQcFPb1VACyQRuj3JBvecl++cD0n+A9N6SKNQvShy
 DGsRjhvWrXU5QOsgnjE1g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zwWkj2Ibg9U=:kPVIN3cDzUWTdqnu8jFYIS
 nkUvo37MduvMt7rPN+/56KpH3gHA50HYZh1Esv2TFzth9glTaJKAt6rpzbexn0nFJpcxaI0rH
 6MDLAWH+SkWx7YkmlTUJrnPX/pEQXPDxWKpChPb8lC/VaksFNfKlAyU9tgq4CJDHyhLHk7343
 sH+W4fPyfxGSrbCcJ+8k72jxX0hkp2mlaPOcVUuXb+/wPtG+sU57WqTSNudKhuno2wd0ESJz+
 8JfWXCLUU4K8rXtpI5NScAbq5xmaMQ1pK6Y0iMkLJrB/H23ytjcIt0fH8xJW0RirIpKNWvtn4
 8AvmemEwqRfe49r1yHUdTeT7UkjLffT0c1a7lvyOqdbpcuIa6dX6A9jJKCH+z5543FJ/9OV8B
 W59/BSZ1RU4XARJmu0bOEzy71RwNKuugm+Gx+CTRr/MhEEKKMILLgiJyaf6B2g0qflONINjy1
 IBdD1wRGG7aTLHrlS2mcnnXRyWFrFp64tRkwLpgzivoIjL8KRf/rKOXQwMYR7I+glV8YsAKR2
 DaHDBKnO55lv6IkGmT9H70XqF4NiDCkxPxcD3KYcWi2UmZyeqVdx/+nRJtQzT1h4l3hFNUtjS
 8P+DUup30HMxmzHc3c++JQaNPWLZgfJVwdlpuEiyjGnoENYRbo0V9WI6DVjthnwwjwm70rlMy
 bQWWZR+d5dNbmkXB0YLXn7yOCudBFt0H2ZsAIFkYdGPyuGVXMLfH1fPGig5KXA1cnmzu1MmkA
 P9YIcEy1XFhvZEGJvEZrGcwpIcFzM4Yh6eMoCdmF0nGjhUUSkeIaVLkK3cKn0KTaNdsjtPwGu
 Geu1DvgMwtu/oKgqKJYnsV+aUqz9oKxOTVRdN3r5PicFaVO7C0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.26.0

