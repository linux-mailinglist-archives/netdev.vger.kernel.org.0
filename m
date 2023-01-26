Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6BA67D1C9
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjAZQhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjAZQhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:37:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27363EC44;
        Thu, 26 Jan 2023 08:36:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C644618B9;
        Thu, 26 Jan 2023 16:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBA2C4339B;
        Thu, 26 Jan 2023 16:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674751012;
        bh=Zc6e+eUqfPJO+05OsGiTtY0oTOxGFgAZIR3Yj5hlt0k=;
        h=From:To:Cc:Subject:Date:From;
        b=DEv1NX1vOiHrGyYE5IuvIc04fn6o0YlfYw0nAtVYJIQ9KeS8yzOUWq/+kLv1Dr0/2
         t41gs0f0I8lNhQvThbzWggkY2wC8fv2UB0J+S3kSGplRk4DOe3KAiqQGqP1kyKjMEA
         dO1/LR0zCpVA6sIxgL8D53V+NH8NQmC0iNAMcJKBsCVoUb5eI1IsT5IFAlt0sGhkMY
         HEpu7ijgVmD8xBb4ga+2RBn2QfhfE8KkSizsnGptncBrIuAiJe8GTmGR/jB/7aJ2Ju
         PZGcSpesBH36VkOJn0LE+sG9y2/6kSFtBfw8wpDSGzBxxE4zAmW8IgrDOUMtnp1uJS
         lXAxjJlqvjufQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mscc: ocelot: add ETHTOOL_NETLINK dependency
Date:   Thu, 26 Jan 2023 17:36:36 +0100
Message-Id: <20230126163647.3554883-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver now directly calls into ethtool code, which fails if
ethtool is disabled:

arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_pause_stats':
ocelot_stats.c:(.text+0xe54): undefined reference to `ethtool_aggregate_pause_stats'
arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_rmon_stats':
ocelot_stats.c:(.text+0x1090): undefined reference to `ethtool_aggregate_rmon_stats'
arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_eth_ctrl_stats':
ocelot_stats.c:(.text+0x1228): undefined reference to `ethtool_aggregate_ctrl_stats'
arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_eth_mac_stats':
ocelot_stats.c:(.text+0x13a8): undefined reference to `ethtool_aggregate_mac_stats'
arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_eth_phy_stats':
ocelot_stats.c:(.text+0x1540): undefined reference to `ethtool_aggregate_phy_stats'

Add a dependency on ETHTOOL_NETLINK, since that controls the
compilation of the ethtool stats code. It would probably be possible
to have a more fine-grained symbol there, but in practice this is
already required.

Fixes: 6505b6805655 ("net: mscc: ocelot: add MAC Merge layer support for VSC9959")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/ocelot/Kconfig    | 2 ++
 drivers/net/ethernet/mscc/Kconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 08db9cf76818..9b0624a1837e 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -7,6 +7,7 @@ config NET_DSA_MSCC_FELIX
 	depends on HAS_IOMEM
 	depends on PTP_1588_CLOCK_OPTIONAL
 	depends on NET_SCH_TAPRIO || NET_SCH_TAPRIO=n
+	depends on ETHTOOL_NETLINK
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
@@ -22,6 +23,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on ETHTOOL_NETLINK
 	select MDIO_MSCC_MIIM
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index 8dd8c7f425d2..8b1a145971b2 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -13,6 +13,7 @@ if NET_VENDOR_MICROSEMI
 
 # Users should depend on NET_SWITCHDEV, HAS_IOMEM, BRIDGE
 config MSCC_OCELOT_SWITCH_LIB
+	depends on ETHTOOL_NETLINK
 	select NET_DEVLINK
 	select REGMAP_MMIO
 	select PACKING
@@ -25,6 +26,7 @@ config MSCC_OCELOT_SWITCH_LIB
 config MSCC_OCELOT_SWITCH
 	tristate "Ocelot switch driver"
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on ETHTOOL_NETLINK
 	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
-- 
2.39.0

