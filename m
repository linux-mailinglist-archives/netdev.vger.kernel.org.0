Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7FE680EA6
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbjA3NSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbjA3NSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:18:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748C41026D;
        Mon, 30 Jan 2023 05:18:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25B7EB810CB;
        Mon, 30 Jan 2023 13:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66832C433EF;
        Mon, 30 Jan 2023 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675084698;
        bh=k0NPXSsp+gSXfsSSzhWDgDyCWNg7HyXTSjzLGPOZckY=;
        h=From:To:Cc:Subject:Date:From;
        b=QqWtSLvHoxuuGMVpEQ2LHIhNyYBPCK5ccEAdWZZ5dHu+0upsECozEjsv/akgTf1su
         pC6gKsYxbXLbF8kLZa4JEogni7zT+VYTzWBXPQ/IMeOPPEX/8gPPv4d8qGGuJVuSNY
         OgV7DBR5R74BN8SZo3ddxPAmbQ3aEPtT5DjydPHVxfNe3kav1c6zfagUh21nSzoKRQ
         FgEvGVbFOo2Pos49LOa6lKvSteaMEXSPs5TYkZ3i/pi2KuDeualEuZInVlDVGsxz6Q
         QFUqJNW8XeUge1ti6F02O8KVaU8v2M1gOp33wFzGa5Fgcd2oZ4yBaURIQj7uytmPVg
         kooMJ+XX7Rfdg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Christian Eggers <ceggers@arri.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] net: dsa: microchip: ptp: fix up PTP dependency
Date:   Mon, 30 Jan 2023 14:17:51 +0100
Message-Id: <20230130131808.1084796-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When NET_DSA_MICROCHIP_KSZ_COMMON is built-in but PTP is a loadable
module, the ksz_ptp support still causes a link failure:

ld.lld-16: error: undefined symbol: ptp_clock_index
>>> referenced by ksz_ptp.c
>>>               drivers/net/dsa/microchip/ksz_ptp.o:(ksz_get_ts_info) in archive vmlinux.a

This can happen if NET_DSA_MICROCHIP_KSZ8863_SMI is enabled, or
even if none of the KSZ9477_I2C/KSZ_SPI/KSZ8863_SMI ones are active
but only the common module is.

The most straightforward way to address this is to move the
dependency to NET_DSA_MICROCHIP_KSZ_PTP itself, which can now
only be enabled if both PTP_1588_CLOCK support is reachable
from NET_DSA_MICROCHIP_KSZ_COMMON. Alternatively, one could make
NET_DSA_MICROCHIP_KSZ_COMMON a hidden Kconfig symbol and extend the
PTP_1588_CLOCK_OPTIONAL dependency to NET_DSA_MICROCHIP_KSZ8863_SMI as
well, but that is a little more fragile.

Fixes: eac1ea20261e ("net: dsa: microchip: ptp: add the posix clock support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: avoid the build regression also if none of the three drivers
are active and only NET_DSA_MICROCHIP_KSZ_COMMON is built-in.
---
 drivers/net/dsa/microchip/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 0546c573668a..394ca8678d2b 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -11,7 +11,6 @@ menuconfig NET_DSA_MICROCHIP_KSZ_COMMON
 config NET_DSA_MICROCHIP_KSZ9477_I2C
 	tristate "KSZ series I2C connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && I2C
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select REGMAP_I2C
 	help
 	  Select to enable support for registering switches configured through I2C.
@@ -19,7 +18,6 @@ config NET_DSA_MICROCHIP_KSZ9477_I2C
 config NET_DSA_MICROCHIP_KSZ_SPI
 	tristate "KSZ series SPI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && SPI
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select REGMAP_SPI
 	help
 	  Select to enable support for registering switches configured through SPI.
@@ -27,6 +25,7 @@ config NET_DSA_MICROCHIP_KSZ_SPI
 config NET_DSA_MICROCHIP_KSZ_PTP
 	bool "Support for the PTP clock on the KSZ9563/LAN937x Ethernet Switch"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && PTP_1588_CLOCK
+	depends on NET_DSA_MICROCHIP_KSZ_COMMON=m || PTP_1588_CLOCK=y
 	help
 	  Select to enable support for timestamping & PTP clock manipulation in
 	  KSZ8563/KSZ9563/LAN937x series of switches. KSZ9563/KSZ8563 supports
-- 
2.39.0

