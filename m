Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED7011D33C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfLLRMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:12:00 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36675 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730014AbfLLRL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:11:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so3403916wma.1
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 09:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IPUDlx3Nml4HC5MpbI7A8zw8i+dCcu+D0TS3pRTKTgs=;
        b=nQj4aWyT2lPxb9WguSxvGlVw6kDkVLGMArH13Wy4pzDCFaTw6SVILRGKwy7VkoSZ69
         OJr5R9bE1WTGTyfkD3+nSZKBY87wTtQlThVHsRTqZuYt0zZwQEjkyw88wMzR99cB6AWO
         4YrS9PxZFdIeG6qjMkhiZUnG/0PWKOXAD2ULzkyyyuLEuyeSUVyenGTOXFviVaStNtMl
         QtxyhfmNYSwWisAib2DmDpyi9wKiiLCGXj7kUgElV4E1wCk0GckzsSLD0+2cfBccms4M
         E7hC/pcH+YjVHIVAE/YB8Acf9IaePAmVF4mL8SeaeDxL2LN8nvPv03nN5uhi+Lhd1NSr
         LjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IPUDlx3Nml4HC5MpbI7A8zw8i+dCcu+D0TS3pRTKTgs=;
        b=sPA4QOmFyScW76qjS0o1tP+8jOM2ghWKeeSjkICaSDNZ6jEmcL4kdGmbf+w3v9khGM
         A0fgYa5a8fMGeQPsIZ+569+F0FnA6KlFjB1adBkWs8iBsaQIRMtkrpYwofbi8ynlRNkj
         +oN0nhhhszxGSpVR8oQpnuvgBYn9e7ZTkMBjj51Vjb9+yib5WWL2j3Zu1wCe3MTglMS9
         WmZ6dIVvLajcClwlBxor2gvRnUsE3ASpbPB5nvbKA5s79fq4/yettkWjldL21HVQ26nw
         ROnAk/HKJNsuZxz5PRNaWlKoEVVtL6nslxqrsvtdvLlCN4oOExLBfvuh4/SjUZZQjeBx
         e5ew==
X-Gm-Message-State: APjAAAWYVnC01oFG8SVgkilFrdj+VSOGBW4jkoNvspBNE6/kZbKR9UBG
        ec4pWbkmJDA1XYpOqqpNB24=
X-Google-Smtp-Source: APXvYqxMRhIerHWKXj5+SuMTfOyVNvAVDLOxSqsMpUWpMVx5yt5RY4JfJso8eUVgRfqC8UwIcE7aeQ==
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr7925427wmc.21.1576170716834;
        Thu, 12 Dec 2019 09:11:56 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id z21sm6892106wml.5.2019.12.12.09.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 09:11:56 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     arnd@arndb.de, maowenan@huawei.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH] net: mscc: ocelot: hide MSCC_OCELOT_SWITCH and move outside NET_VENDOR_MICROSEMI
Date:   Thu, 12 Dec 2019 19:11:25 +0200
Message-Id: <20191212171125.9933-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

NET_DSA_MSCC_FELIX and MSCC_OCELOT_SWITCH_OCELOT are 2 different drivers
that use the same core operations, compiled under MSCC_OCELOT_SWITCH.

The DSA driver depends on HAVE_NET_DSA, and the switchdev driver depends
on NET_VENDOR_MICROSEMI. This dependency is purely cosmetic (to hide
options per driver class, or per networking vendor) from menuconfig
choices.

However, there is an issue with the fact that the common core depends on
NET_VENDOR_MICROSEMI, as can be seen below, when building the DSA
driver:

WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
Selected by [y]:
NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y]
&& NET_DSA [=y] && PCI [=y]

We don't want to make NET_DSA_MSCC_FELIX hidden under
NET_VENDOR_MICROSEMI, since it is physically located under
drivers/net/dsa and already findable in the configurator through DSA.

So we move the common Ocelot core outside the NET_VENDOR_MICROSEMI
selector, and we make the switchdev and DSA drivers select it by
default. In that process, we hide it from menuconfig, since the user
shouldn't need to know anything about it, and we change it from tristate
to bool, since it doesn't make a lot of sense to have it as yet another
loadable kernel module.

With this, the DSA driver also needs to explicitly depend on ETHERNET,
to avoid an unmet dependency situation caused by selecting
MSCC_OCELOT_SWITCH when ETHERNET is disabled.

A few more dependencies were shuffled around. HAS_IOMEM is now "depends"
to avoid a circular dependency:

symbol HAS_IOMEM is selected by MSCC_OCELOT_SWITCH
symbol MSCC_OCELOT_SWITCH depends on NETDEVICES
symbol NETDEVICES is selected by SCSI_CXGB3_ISCSI
symbol SCSI_CXGB3_ISCSI depends on SCSI_LOWLEVEL
symbol SCSI_LOWLEVEL depends on SCSI
symbol SCSI is selected by ATA
symbol ATA depends on HAS_IOMEM

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig    |  2 +-
 drivers/net/ethernet/mscc/Kconfig | 27 ++++++++++++++++-----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 0031ca814346..c41d50ca98b7 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
-	depends on NET_DSA && PCI
+	depends on NET_DSA && PCI && ETHERNET
 	select MSCC_OCELOT_SWITCH
 	select NET_DSA_TAG_OCELOT
 	help
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index bcec0587cf61..13fa11c30f68 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -9,24 +9,29 @@ config NET_VENDOR_MICROSEMI
 	  kernel: saying N will just cause the configurator to skip all
 	  the questions about Microsemi devices.
 
-if NET_VENDOR_MICROSEMI
-
 config MSCC_OCELOT_SWITCH
-	tristate "Ocelot switch driver"
+	bool
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
-	select PHYLIB
 	select REGMAP_MMIO
+	select PHYLIB
 	help
-	  This driver supports the Ocelot network switch device.
+	  This is the core library for the Vitesse / Microsemi / Microchip
+	  Ocelot network switch family. It offers a set of DSA-compatible
+	  switchdev operations for managing switches of this class, like:
+	  - VSC7514
+	  - VSC9959
+
+if NET_VENDOR_MICROSEMI
 
 config MSCC_OCELOT_SWITCH_OCELOT
-	tristate "Ocelot switch driver on Ocelot"
-	depends on MSCC_OCELOT_SWITCH
-	depends on GENERIC_PHY
-	depends on OF_NET
+	tristate "Ocelot switch driver for local management CPUs"
+	select MSCC_OCELOT_SWITCH
+	select GENERIC_PHY
+	select OF_NET
 	help
-	  This driver supports the Ocelot network switch device as present on
-	  the Ocelot SoCs.
+	  This supports the network switch present on the Ocelot SoCs
+	  (VSC7514). The driver is intended for use on the local MIPS
+	  management CPU. Frame transfer is through polled I/O or DMA.
 
 endif # NET_VENDOR_MICROSEMI
-- 
2.7.4

