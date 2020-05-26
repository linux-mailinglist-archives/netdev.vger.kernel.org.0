Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4EA1D39E2
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgENSwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbgENSw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9445A2065F;
        Thu, 14 May 2020 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482348;
        bh=rZe7RgQTbU2+URaYJ7uJtJiULLuneyg1T7kqNoH9dDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5ema0BkftWmgk/+vgR3MqKmZziiNnNs7fF/tmd27iR4Tes6kOU9bX07UsR1FWepf
         qN4rydXQhW5zMT4eySvdvUUZD+iDcstG1p/A+UmaecGbtFeB+MF2OLk8HhTGDtvp/8
         8Y7822FHlY+WIqpCJXHOtGnrvekYrgesWYW9kosQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Clay McClure <clay@daemons.net>, Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 30/62] net: Make PTP-specific drivers depend on PTP_1588_CLOCK
Date:   Thu, 14 May 2020 14:51:15 -0400
Message-Id: <20200514185147.19716-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Clay McClure <clay@daemons.net>

[ Upstream commit b6d49cab44b567b3e0a5544b3d61e516a7355fad ]

Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
clock subsystem and ethernet drivers capable of being clock providers."
As a result it is possible to build PTP-capable Ethernet drivers without
the PTP subsystem by deselecting PTP_1588_CLOCK. Drivers are required to
handle the missing dependency gracefully.

Some PTP-capable Ethernet drivers (e.g., TI_CPSW) factor their PTP code
out into separate drivers (e.g., TI_CPTS_MOD). The above commit also
changed these PTP-specific drivers to `imply PTP_1588_CLOCK`, making it
possible to build them without the PTP subsystem. But as Grygorii
Strashko noted in [1]:

On Wed, Apr 22, 2020 at 02:16:11PM +0300, Grygorii Strashko wrote:

> Another question is that CPTS completely nonfunctional in this case and
> it was never expected that somebody will even try to use/run such
> configuration (except for random build purposes).

In my view, enabling a PTP-specific driver without the PTP subsystem is
a configuration error made possible by the above commit. Kconfig should
not allow users to create a configuration with missing dependencies that
results in "completely nonfunctional" drivers.

I audited all network drivers that call ptp_clock_register() but merely
`imply PTP_1588_CLOCK` and found five PTP-specific drivers that are
likely nonfunctional without PTP_1588_CLOCK:

    NET_DSA_MV88E6XXX_PTP
    NET_DSA_SJA1105_PTP
    MACB_USE_HWSTAMP
    CAVIUM_PTP
    TI_CPTS_MOD

Note how these symbols all reference PTP or timestamping in their name;
this is a clue that they depend on PTP_1588_CLOCK.

Change them from `imply PTP_1588_CLOCK` [2] to `depends on PTP_1588_CLOCK`.
I'm not using `select PTP_1588_CLOCK` here because PTP_1588_CLOCK has
its own dependencies, which `select` would not transitively apply.

Additionally, remove the `select NET_PTP_CLASSIFY` from CPTS_TI_MOD;
PTP_1588_CLOCK already selects that.

[1]: https://lore.kernel.org/lkml/c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com/

[2]: NET_DSA_SJA1105_PTP had never declared any type of dependency on
PTP_1588_CLOCK (`imply` or otherwise); adding a `depends on PTP_1588_CLOCK`
here seems appropriate.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: d1cbfd771ce8 ("ptp_clock: Allow for it to be optional")
Signed-off-by: Clay McClure <clay@daemons.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/Kconfig    | 2 +-
 drivers/net/dsa/sja1105/Kconfig      | 1 +
 drivers/net/ethernet/cadence/Kconfig | 2 +-
 drivers/net/ethernet/cavium/Kconfig  | 2 +-
 drivers/net/ethernet/ti/Kconfig      | 3 +--
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 6435020d690dd..51185e4d7d15e 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -24,8 +24,8 @@ config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
 	depends on NET_DSA_MV88E6XXX_GLOBAL2
+	depends on PTP_1588_CLOCK
 	imply NETWORK_PHY_TIMESTAMPING
-	imply PTP_1588_CLOCK
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 0fe1ae173aa1a..68c3086af9af8 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -20,6 +20,7 @@ tristate "NXP SJA1105 Ethernet switch family support"
 config NET_DSA_SJA1105_PTP
 	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
 	depends on NET_DSA_SJA1105
+	depends on PTP_1588_CLOCK
 	help
 	  This enables support for timestamping and PTP clock manipulations in
 	  the SJA1105 DSA driver.
diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 53b50c24d9c95..2c4c12b03502d 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -35,8 +35,8 @@ config MACB
 config MACB_USE_HWSTAMP
 	bool "Use IEEE 1588 hwstamp"
 	depends on MACB
+	depends on PTP_1588_CLOCK
 	default y
-	imply PTP_1588_CLOCK
 	---help---
 	  Enable IEEE 1588 Precision Time Protocol (PTP) support for MACB.
 
diff --git a/drivers/net/ethernet/cavium/Kconfig b/drivers/net/ethernet/cavium/Kconfig
index 6a700d34019e3..4520e7ee00fe1 100644
--- a/drivers/net/ethernet/cavium/Kconfig
+++ b/drivers/net/ethernet/cavium/Kconfig
@@ -54,7 +54,7 @@ config	THUNDER_NIC_RGX
 config CAVIUM_PTP
 	tristate "Cavium PTP coprocessor as PTP clock"
 	depends on 64BIT && PCI
-	imply PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK
 	---help---
 	  This driver adds support for the Precision Time Protocol Clocks and
 	  Timestamping coprocessor (PTP) found on Cavium processors.
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index bf98e0fa7d8be..cd6eda83e1f8c 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -89,9 +89,8 @@ config TI_CPTS
 config TI_CPTS_MOD
 	tristate
 	depends on TI_CPTS
+	depends on PTP_1588_CLOCK
 	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
-	select NET_PTP_CLASSIFY
-	imply PTP_1588_CLOCK
 	default m
 
 config TI_KEYSTONE_NETCP
-- 
2.20.1

