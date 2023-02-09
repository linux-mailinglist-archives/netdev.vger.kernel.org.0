Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073FF690924
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBIMon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBIMom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:44:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15C25AB08;
        Thu,  9 Feb 2023 04:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7410461A3D;
        Thu,  9 Feb 2023 12:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6827C433D2;
        Thu,  9 Feb 2023 12:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675946680;
        bh=mpk6/sW48WtpnWNSsmwhCzd9speTfJtkyUBZqRHxCtE=;
        h=From:To:Cc:Subject:Date:From;
        b=PteE3i9ZTFUZfoqp9ayBaNKGkrSUS8+elnSt1QS0B0un+GnMItb/DJOFIFw7F3NBh
         6gZT2WtkfeLFaGouS0LJsPEmxzmIGcwP7eTLt6k77stH6kylmaNnoSERt5czdFT70N
         oUGw8HIJYIp3xKWdtLYEzHJmo/9nTJofQWAKSZdb+pzIggYQOwhoXKnuV4RTx8TO4a
         Vl+evP4lVYusixIeSRW7e0um8/SUeDCxsGSv/sM9vo7qzSewUMzc3Og12nBt+IoI5y
         fXewZQ94oa4QL7jCeoXpL1FDKvRtBbSZLHTg7D+B7Hxqss9Pfmb8FRCZ6sNDIkJmvZ
         H9SlZMnPFWctQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: ocelot: add PTP dependency for NET_DSA_MSCC_OCELOT_EXT
Date:   Thu,  9 Feb 2023 13:44:17 +0100
Message-Id: <20230209124435.1317781-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.1
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

A new user of MSCC_OCELOT_SWITCH_LIB was added, bringing back an old
link failure that was fixed with e5f31552674e ("ethernet: fix
PTP_1588_CLOCK dependencies"):

x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_ptp_enable':
ocelot_ptp.c:(.text+0x8ee): undefined reference to `ptp_find_pin'
x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_get_ts_info':
ocelot_ptp.c:(.text+0xd5d): undefined reference to `ptp_clock_index'
x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_init_timestamp':
ocelot_ptp.c:(.text+0x15ca): undefined reference to `ptp_clock_register'
x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_deinit_timestamp':
ocelot_ptp.c:(.text+0x16b7): undefined reference to `ptp_clock_unregister'

Add the same PTP dependency here, as well as in the MSCC_OCELOT_SWITCH_LIB
symbol itself to make it more obvious what is going on when the next
driver selects it.

Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/ocelot/Kconfig    | 1 +
 drivers/net/ethernet/mscc/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 640725524d0c..eff0a7dfcd21 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -12,6 +12,7 @@ config NET_DSA_MSCC_OCELOT_EXT
 	tristate "Ocelot External Ethernet switch support"
 	depends on NET_DSA && SPI
 	depends on NET_VENDOR_MICROSEMI
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MDIO_MSCC_MIIM
 	select MFD_OCELOT_CORE
 	select MSCC_OCELOT_SWITCH_LIB
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index 8dd8c7f425d2..81e605691bb8 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -13,6 +13,7 @@ if NET_VENDOR_MICROSEMI
 
 # Users should depend on NET_SWITCHDEV, HAS_IOMEM, BRIDGE
 config MSCC_OCELOT_SWITCH_LIB
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select NET_DEVLINK
 	select REGMAP_MMIO
 	select PACKING
-- 
2.39.1

