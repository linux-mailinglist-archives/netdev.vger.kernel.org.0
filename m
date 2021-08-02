Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567923DDBB3
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhHBO7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234417AbhHBO7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:59:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA5E61029;
        Mon,  2 Aug 2021 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627916383;
        bh=Lkr1dFSreFjPtodwG8AQp2lM5ZAmh2e2VFsf/AFrxW8=;
        h=From:To:Cc:Subject:Date:From;
        b=WM8AKZ3sCcnZpGgyWaTVASIh1HVD5JyolR9jrAa5D8LupWFtMc//PCEFdjUBFE7xI
         B6zVNaR00ZrLHXYRU89FnHConbJ86lcg3Lmb5sJHS+Dn/PwvKq4/7BKUmWivqrIy2s
         39NLuJADFxhb0RlM4SbteogfWRxvYxIdqHXDEdxijpuSpzUVH66IlB9AcTKufPWWdK
         S9Rc5s3abKSJh7Rim/0fne49/S0d9gdzK8Iho1+QLg6LB+9NRySJ1HqHnl+urQXhN7
         zz0uRstrvI/og+JLpenVIB3juE5cdz+EoaAjP68hnDR7TPXuf7EpqQG5eu/LhL4/cZ
         a4sJ5hPVOtN3A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
Date:   Mon,  2 Aug 2021 16:59:33 +0200
Message-Id: <20210802145937.1155571-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The 'imply' keyword does not do what most people think it does, it only
politely asks Kconfig to turn on another symbol, but does not prevent
it from being disabled manually or built as a loadable module when the
user is built-in. In the ICE driver, the latter now causes a link failure:

aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_eth_ioctl':
ice_main.c:(.text+0x13b0): undefined reference to `ice_ptp_get_ts_config'
ice_main.c:(.text+0x13b0): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_get_ts_config'
aarch64-linux-ld: ice_main.c:(.text+0x13bc): undefined reference to `ice_ptp_set_ts_config'
ice_main.c:(.text+0x13bc): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_set_ts_config'
aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_prepare_for_reset':
ice_main.c:(.text+0x31fc): undefined reference to `ice_ptp_release'
ice_main.c:(.text+0x31fc): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_release'
aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_rebuild':

For the other Intel network drivers, there is no link error when the
drivers are built-in and PTP is a loadable module, because
linux/ptp_clock_kernel.h contains an IS_REACHABLE() check, but this
just changes the compile-time failure to a runtime failure, which is
arguably worse.

Change all the Intel drivers to use the 'depends on PTP_1588_CLOCK ||
!PTP_1588_CLOCK' trick to prevent the broken configuration, as we
already do for several other drivers. To avoid circular dependencies,
this also requires changing the IGB driver back to using the normal
'depends on I2C' instead of 'select I2C'.

This is a recurring problem in many drivers, and we have discussed
it several times befores, without reaching a consensus. I'm providing
a link to the previous email thread for reference, which discusses
some related problems, though I can't find what reasons there were
against the approach with the extra Kconfig dependency.

Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
Link: https://lore.kernel.org/netdev/CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com/
Link: https://lore.kernel.org/netdev/20210726084540.3282344-1-arnd@kernel.org/
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v2:
- include a missing patch hunk
- link to a previous discussion with Richard Cochran
---
 drivers/net/ethernet/intel/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 2aa84bd97287..3ddadc147d45 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -58,8 +58,8 @@ config E1000
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
 	depends on PCI && (!SPARC32 || BROKEN)
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
 	select CRC32
-	imply PTP_1588_CLOCK
 	help
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
@@ -87,8 +87,8 @@ config E1000E_HWTS
 config IGB
 	tristate "Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support"
 	depends on PCI
-	imply PTP_1588_CLOCK
-	select I2C
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
+	depends on I2C
 	select I2C_ALGOBIT
 	help
 	  This driver supports Intel(R) 82575/82576 gigabit ethernet family of
@@ -159,9 +159,9 @@ config IXGB
 config IXGBE
 	tristate "Intel(R) 10GbE PCI Express adapters support"
 	depends on PCI
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
 	select MDIO
 	select PHYLIB
-	imply PTP_1588_CLOCK
 	help
 	  This driver supports Intel(R) 10GbE PCI Express family of
 	  adapters.  For more information on how to identify your adapter, go
@@ -239,7 +239,7 @@ config IXGBEVF_IPSEC
 
 config I40E
 	tristate "Intel(R) Ethernet Controller XL710 Family support"
-	imply PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
 	depends on PCI
 	select AUXILIARY_BUS
 	help
@@ -295,11 +295,11 @@ config ICE
 	tristate "Intel(R) Ethernet Connection E800 Series Support"
 	default n
 	depends on PCI_MSI
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
 	select AUXILIARY_BUS
 	select DIMLIB
 	select NET_DEVLINK
 	select PLDMFW
-	imply PTP_1588_CLOCK
 	help
 	  This driver supports Intel(R) Ethernet Connection E800 Series of
 	  devices.  For more information on how to identify your adapter, go
@@ -317,7 +317,7 @@ config FM10K
 	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
 	default n
 	depends on PCI_MSI
-	imply PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
 	help
 	  This driver supports Intel(R) FM10000 Ethernet Switch Host
 	  Interface.  For more information on how to identify your adapter,
-- 
2.29.2

