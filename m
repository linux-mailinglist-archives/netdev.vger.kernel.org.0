Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158D6333C1A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhCJMDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhCJMDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:03:24 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDD0DC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:03:23 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 2C9F692009C; Wed, 10 Mar 2021 13:03:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 26D1C92009B;
        Wed, 10 Mar 2021 13:03:19 +0100 (CET)
Date:   Wed, 10 Mar 2021 13:03:19 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] FDDI: defxx: Implement dynamic CSR I/O address
 space selection
In-Reply-To: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2103092355090.33195@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent versions of the PCI Express specification have deprecated support 
for I/O transactions and actually some PCIe host bridges, such as Power 
Systems Host Bridge 4 (PHB4), do not implement them.  Conversely a DEFEA 
adapter can have its MMIO decoding disabled with ECU (EISA Configuration 
Utility) and therefore not available for us with the resource allocation 
infrastructure we implement.

However either I/O address space will always be available for use with 
the DEFEA (EISA) and DEFPA (PCI) adapters and both have double address 
decoding implemented in hardware for Control and Status Register access.  
The two kinds of adapters can be present both at once in a single mixed 
PCI/EISA system.  For the DEFTA (TURBOchannel) variant there is no issue 
as there has been no port I/O address space defined for that bus.

To make people's life easier and the driver more robust remove the 
DEFXX_MMIO configuration option so as to rather than making the choice 
for the I/O address space to use at build time for all the adapters 
installed in the system let the driver choose the most suitable address 
space dynamically on a case-by-case basis at run time.  Make MMIO the 
default and resort to port I/O should the default fail for some reason.

This way multiple adapters installed in one system can use different I/O 
address spaces each, in particular in the presence of DEFEA adapters in 
a pure-EISA or a mixed EISA/PCI system (it is expected that DEFPA boards
will use MMIO in normal circumstances).

The choice of the I/O address space to use continues being reported by 
the driver on startup, e.g.:

eisa 00:05: EISA: slot 5: DEC3002 detected
defxx: v1.12 2021/03/10  Lawrence V. Stefani and others
00:05: DEFEA at I/O addr = 0x5000, IRQ = 10, Hardware addr = 00-00-f8-c8-b3-b6
00:05: registered as fddi0

and:

defxx: v1.12 2021/03/10  Lawrence V. Stefani and others
0031:02:04.0: DEFPA at MMIO addr = 0x620c080020000, IRQ = 57, Hardware addr = 00-60-6d-93-91-98
0031:02:04.0: registered as fddi0

and:

defxx: v1.12 2021/03/10  Lawrence V. Stefani and others
tc2: DEFTA at MMIO addr = 0x1f100000, IRQ = 21, Hardware addr = 08-00-2b-b0-8b-1e
tc2: registered as fddi0

so there is no need to add further information.

The change is supposed to cause a negligible performance hit as I/O 
accessors will now have code executed conditionally at run time.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
 drivers/net/fddi/Kconfig |   19 --------------
 drivers/net/fddi/defxx.c |   60 +++++++++++++++++------------------------------
 drivers/net/fddi/defxx.h |    3 ++
 3 files changed, 25 insertions(+), 57 deletions(-)

Index: linux-defxx/drivers/net/fddi/Kconfig
===================================================================
--- linux-defxx.orig/drivers/net/fddi/Kconfig
+++ linux-defxx/drivers/net/fddi/Kconfig
@@ -38,25 +38,6 @@ config DEFXX
 	  To compile this driver as a module, choose M here: the module
 	  will be called defxx.  If unsure, say N.
 
-config DEFXX_MMIO
-	bool
-	prompt "Use MMIO instead of IOP" if PCI || EISA
-	depends on DEFXX
-	default n if EISA
-	default y
-	help
-	  This instructs the driver to use EISA or PCI memory-mapped I/O
-	  (MMIO) as appropriate instead of programmed I/O ports (IOP).
-	  Enabling this gives an improvement in processing time in parts
-	  of the driver, but it requires a memory window to be configured
-	  for EISA (DEFEA) adapters that may not always be available.
-	  Conversely some PCIe host bridges do not support IOP, so MMIO
-	  may be required to access PCI (DEFPA) adapters on downstream PCI
-	  buses with some systems.  TURBOchannel does not have the concept
-	  of I/O ports, so MMIO is always used for these (DEFTA) adapters.
-
-	  If unsure, say N.
-
 config SKFP
 	tristate "SysKonnect FDDI PCI support"
 	depends on FDDI && PCI
Index: linux-defxx/drivers/net/fddi/defxx.c
===================================================================
--- linux-defxx.orig/drivers/net/fddi/defxx.c
+++ linux-defxx/drivers/net/fddi/defxx.c
@@ -197,6 +197,7 @@
  *		23 Oct 2006	macro		Big-endian host support.
  *		14 Dec 2006	macro		TURBOchannel support.
  *		01 Jul 2014	macro		Fixes for DMA on 64-bit hosts.
+ *		10 Mar 2021	macro		Dynamic MMIO vs port I/O.
  */
 
 /* Include files */
@@ -225,8 +226,8 @@
 
 /* Version information string should be updated prior to each new release!  */
 #define DRV_NAME "defxx"
-#define DRV_VERSION "v1.11"
-#define DRV_RELDATE "2014/07/01"
+#define DRV_VERSION "v1.12"
+#define DRV_RELDATE "2021/03/10"
 
 static const char version[] =
 	DRV_NAME ": " DRV_VERSION " " DRV_RELDATE
@@ -253,10 +254,10 @@ static const char version[] =
 #define DFX_BUS_TC(dev) 0
 #endif
 
-#ifdef CONFIG_DEFXX_MMIO
-#define DFX_MMIO 1
+#if defined(CONFIG_EISA) || defined(CONFIG_PCI)
+#define dfx_use_mmio bp->mmio
 #else
-#define DFX_MMIO 0
+#define dfx_use_mmio true
 #endif
 
 /* Define module-wide (static) routines */
@@ -374,8 +375,6 @@ static inline void dfx_outl(DFX_board_t
 static void dfx_port_write_long(DFX_board_t *bp, int offset, u32 data)
 {
 	struct device __maybe_unused *bdev = bp->bus_dev;
-	int dfx_bus_tc = DFX_BUS_TC(bdev);
-	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 
 	if (dfx_use_mmio)
 		dfx_writel(bp, offset, data);
@@ -398,8 +397,6 @@ static inline void dfx_inl(DFX_board_t *
 static void dfx_port_read_long(DFX_board_t *bp, int offset, u32 *data)
 {
 	struct device __maybe_unused *bdev = bp->bus_dev;
-	int dfx_bus_tc = DFX_BUS_TC(bdev);
-	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 
 	if (dfx_use_mmio)
 		dfx_readl(bp, offset, data);
@@ -421,7 +418,7 @@ static void dfx_port_read_long(DFX_board
  *   None
  *
  * Arguments:
- *   bdev	- pointer to device information
+ *   bp		- pointer to board information
  *   bar_start	- pointer to store the start addresses
  *   bar_len	- pointer to store the lengths of the areas
  *
@@ -431,13 +428,13 @@ static void dfx_port_read_long(DFX_board
  * Side Effects:
  *   None
  */
-static void dfx_get_bars(struct device *bdev,
+static void dfx_get_bars(DFX_board_t *bp,
 			 resource_size_t *bar_start, resource_size_t *bar_len)
 {
+	struct device *bdev = bp->bus_dev;
 	int dfx_bus_pci = dev_is_pci(bdev);
 	int dfx_bus_eisa = DFX_BUS_EISA(bdev);
 	int dfx_bus_tc = DFX_BUS_TC(bdev);
-	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 
 	if (dfx_bus_pci) {
 		int num = dfx_use_mmio ? 0 : 1;
@@ -495,18 +492,6 @@ static const struct net_device_ops dfx_n
 	.ndo_set_mac_address	= dfx_ctl_set_mac_address,
 };
 
-static void dfx_register_res_alloc_err(const char *print_name, bool mmio,
-				       bool eisa)
-{
-	pr_err("%s: Cannot use %s, no address set, aborting\n",
-	       print_name, mmio ? "MMIO" : "I/O");
-	pr_err("%s: Recompile driver with \"CONFIG_DEFXX_MMIO=%c\"\n",
-	       print_name, mmio ? 'n' : 'y');
-	if (eisa && mmio)
-		pr_err("%s: Or run ECU and set adapter's MMIO location\n",
-		       print_name);
-}
-
 static void dfx_register_res_err(const char *print_name, bool mmio,
 				 unsigned long start, unsigned long len)
 {
@@ -547,8 +532,6 @@ static int dfx_register(struct device *b
 	static int version_disp;
 	int dfx_bus_pci = dev_is_pci(bdev);
 	int dfx_bus_eisa = DFX_BUS_EISA(bdev);
-	int dfx_bus_tc = DFX_BUS_TC(bdev);
-	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 	const char *print_name = dev_name(bdev);
 	struct net_device *dev;
 	DFX_board_t	  *bp;			/* board pointer */
@@ -586,19 +569,24 @@ static int dfx_register(struct device *b
 	bp->bus_dev = bdev;
 	dev_set_drvdata(bdev, dev);
 
-	dfx_get_bars(bdev, bar_start, bar_len);
+	bp->mmio = true;
+
+	dfx_get_bars(bp, bar_start, bar_len);
 	if (bar_len[0] == 0 ||
 	    (dfx_bus_eisa && dfx_use_mmio && bar_start[0] == 0)) {
-		dfx_register_res_alloc_err(print_name, dfx_use_mmio,
-					   dfx_bus_eisa);
-		err = -ENXIO;
-		goto err_out_disable;
+		bp->mmio = false;
+		dfx_get_bars(bp, bar_start, bar_len);
 	}
 
-	if (dfx_use_mmio)
+	if (dfx_use_mmio) {
 		region = request_mem_region(bar_start[0], bar_len[0],
 					    print_name);
-	else
+		if (!region && (dfx_bus_eisa || dfx_bus_pci)) {
+			bp->mmio = false;
+			dfx_get_bars(bp, bar_start, bar_len);
+		}
+	}
+	if (!dfx_use_mmio)
 		region = request_region(bar_start[0], bar_len[0], print_name);
 	if (!region) {
 		dfx_register_res_err(print_name, dfx_use_mmio,
@@ -734,7 +722,6 @@ static void dfx_bus_init(struct net_devi
 	int dfx_bus_pci = dev_is_pci(bdev);
 	int dfx_bus_eisa = DFX_BUS_EISA(bdev);
 	int dfx_bus_tc = DFX_BUS_TC(bdev);
-	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 	u8 val;
 
 	DBG_printk("In dfx_bus_init...\n");
@@ -1054,7 +1041,6 @@ static int dfx_driver_init(struct net_de
 	int dfx_bus_pci = dev_is_pci(bdev);
 	int dfx_bus_eisa = DFX_BUS_EISA(bdev);
 	int dfx_bus_tc = DFX_BUS_TC(bdev);
-	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 	int alloc_size;			/* total buffer size needed */
 	char *top_v, *curr_v;		/* virtual addrs into memory block */
 	dma_addr_t top_p, curr_p;	/* physical addrs into memory block */
@@ -3708,8 +3694,6 @@ static void dfx_unregister(struct device
 	struct net_device *dev = dev_get_drvdata(bdev);
 	DFX_board_t *bp = netdev_priv(dev);
 	int dfx_bus_pci = dev_is_pci(bdev);
-	int dfx_bus_tc = DFX_BUS_TC(bdev);
-	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 	resource_size_t bar_start[3] = {0};	/* pointers to ports */
 	resource_size_t bar_len[3] = {0};	/* resource lengths */
 	int		alloc_size;		/* total buffer size used */
@@ -3729,7 +3713,7 @@ static void dfx_unregister(struct device
 
 	dfx_bus_uninit(dev);
 
-	dfx_get_bars(bdev, bar_start, bar_len);
+	dfx_get_bars(bp, bar_start, bar_len);
 	if (bar_start[2] != 0)
 		release_region(bar_start[2], bar_len[2]);
 	if (bar_start[1] != 0)
Index: linux-defxx/drivers/net/fddi/defxx.h
===================================================================
--- linux-defxx.orig/drivers/net/fddi/defxx.h
+++ linux-defxx/drivers/net/fddi/defxx.h
@@ -27,6 +27,7 @@
  *		04 Aug 2003	macro		Converted to the DMA API.
  *		23 Oct 2006	macro		Big-endian host support.
  *		14 Dec 2006	macro		TURBOchannel support.
+ *		10 Mar 2021	macro		Dynamic MMIO vs port I/O.
  */
 
 #ifndef _DEFXX_H_
@@ -1776,6 +1777,8 @@ typedef struct DFX_board_tag
 		int port;
 	} base;										/* base address */
 	struct device			*bus_dev;
+	/* Whether to use MMIO or port I/O.  */
+	bool				mmio;
 	u32				full_duplex_enb;				/* FDDI Full Duplex enable (1 == on, 2 == off) */
 	u32				req_ttrt;					/* requested TTRT value (in 80ns units) */
 	u32				burst_size;					/* adapter burst size (enumerated) */
