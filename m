Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD74D333C19
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhCJMDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhCJMDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:03:18 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54929C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:03:18 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 3961E92009C; Wed, 10 Mar 2021 13:03:14 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 3371892009B;
        Wed, 10 Mar 2021 13:03:14 +0100 (CET)
Date:   Wed, 10 Mar 2021 13:03:14 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH net/net-next 2/4] FDDI: defxx: Make MMIO the configuration
 default except for EISA
In-Reply-To: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2103092045300.33195@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent versions of the PCI Express specification have deprecated support
for I/O transactions and actually some PCIe host bridges, such as Power
Systems Host Bridge 4 (PHB4), do not implement them.

The default kernel configuration choice for the defxx driver is the use 
of I/O ports rather than MMIO for PCI and EISA systems.  It may have 
made sense as a conservative backwards compatible choice back when MMIO 
operation support was added to the driver as a part of TURBOchannel bus 
support.  However nowadays this configuration choice makes the driver 
unusable with systems that do not implement I/O transactions for PCIe.

Make DEFXX_MMIO the configuration default then, except where configured 
for EISA.  This exception is because an EISA adapter can have its MMIO 
decoding disabled with ECU (EISA Configuration Utility) and therefore 
not available with the resource allocation infrastructure we implement, 
while port I/O is always readily available as it uses slot-specific 
addressing, directly mapped to the slot an option card has been placed 
in and handled with our EISA bus support core.  Conversely a kernel that 
supports modern systems which may not have I/O transactions implemented 
for PCIe will usually not be expected to handle legacy EISA systems.

The change of the default will make it easier for people, including but 
not limited to distribution packagers, to make a working choice for the 
driver.

Update the option description accordingly and while at it replace the 
potentially ambiguous PIO acronym with IOP for "port I/O" vs "I/O ports" 
according to our nomenclature used elsewhere.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: e89a2cfb7d7b ("[TC] defxx: TURBOchannel support")
Cc: stable@vger.kernel.org # v2.6.21+
---
 drivers/net/fddi/Kconfig |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-defxx/drivers/net/fddi/Kconfig
===================================================================
--- linux-defxx.orig/drivers/net/fddi/Kconfig
+++ linux-defxx/drivers/net/fddi/Kconfig
@@ -40,17 +40,20 @@ config DEFXX
 
 config DEFXX_MMIO
 	bool
-	prompt "Use MMIO instead of PIO" if PCI || EISA
+	prompt "Use MMIO instead of IOP" if PCI || EISA
 	depends on DEFXX
-	default n if PCI || EISA
+	default n if EISA
 	default y
 	help
 	  This instructs the driver to use EISA or PCI memory-mapped I/O
-	  (MMIO) as appropriate instead of programmed I/O ports (PIO).
+	  (MMIO) as appropriate instead of programmed I/O ports (IOP).
 	  Enabling this gives an improvement in processing time in parts
-	  of the driver, but it may cause problems with EISA (DEFEA)
-	  adapters.  TURBOchannel does not have the concept of I/O ports,
-	  so MMIO is always used for these (DEFTA) adapters.
+	  of the driver, but it requires a memory window to be configured
+	  for EISA (DEFEA) adapters that may not always be available.
+	  Conversely some PCIe host bridges do not support IOP, so MMIO
+	  may be required to access PCI (DEFPA) adapters on downstream PCI
+	  buses with some systems.  TURBOchannel does not have the concept
+	  of I/O ports, so MMIO is always used for these (DEFTA) adapters.
 
 	  If unsure, say N.
 
