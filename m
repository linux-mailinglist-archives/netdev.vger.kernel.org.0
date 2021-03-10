Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A725333C15
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhCJMDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhCJMDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:03:12 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 451F8C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:03:12 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id D73FE92009C; Wed, 10 Mar 2021 13:03:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id D12E592009B;
        Wed, 10 Mar 2021 13:03:09 +0100 (CET)
Date:   Wed, 10 Mar 2021 13:03:09 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH net/net-next 1/4] FDDI: defxx: Bail out gracefully with
 unassigned PCI resource for CSR
In-Reply-To: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2103091958350.33195@angie.orcam.me.uk>
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

For those systems the PCI BARs that request a mapping in the I/O space 
have the length recorded in the corresponding PCI resource set to zero, 
which makes it unassigned:

# lspci -s 0031:02:04.0 -v
0031:02:04.0 FDDI network controller: Digital Equipment Corporation PCI-to-PDQ Interface Chip [PFI] FDDI (DEFPA) (rev 02)
	Subsystem: Digital Equipment Corporation FDDIcontroller/PCI (DEFPA)
	Flags: bus master, medium devsel, latency 136, IRQ 57, NUMA node 8
	Memory at 620c080020000 (32-bit, non-prefetchable) [size=128]
	I/O ports at <unassigned> [disabled]
	Memory at 620c080030000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: defxx
	Kernel modules: defxx

# 

Regardless the driver goes ahead and requests it (here observed with a 
Raptor Talos II POWER9 system), resulting in an odd /proc/ioport entry:

# cat /proc/ioports
00000000-ffffffffffffffff : 0031:02:04.0
# 

Furthermore, the system gets confused as the driver actually continues 
and pokes at those locations, causing a flood of messages being output 
to the system console by the underlying system firmware, like:

defxx: v1.11 2014/07/01  Lawrence V. Stefani and others
defxx 0031:02:04.0: enabling device (0140 -> 0142)
LPC[000]: Got SYNC no-response error. Error address reg: 0xd0010000
IPMI: dropping non severe PEL event
LPC[000]: Got SYNC no-response error. Error address reg: 0xd0010014
IPMI: dropping non severe PEL event
LPC[000]: Got SYNC no-response error. Error address reg: 0xd0010014
IPMI: dropping non severe PEL event

and so on and so on (possibly intermixed actually, as there's no locking 
between the kernel and the firmware in console port access with this 
particular system, but cleaned up above for clarity), and once some 10k 
of such pairs of the latter two messages have been produced an interace 
eventually shows up in a useless state:

0031:02:04.0: DEFPA at I/O addr = 0x0, IRQ = 57, Hardware addr = 00-00-00-00-00-00

This was not expected to happen as resource handling was added to the 
driver a while ago, because it was not known at that time that a PCI 
system would be possible that cannot assign port I/O resources, and 
oddly enough `request_region' does not fail, which would have caught it.

Correct the problem then by checking for the length of zero for the CSR 
resource and bail out gracefully refusing to register an interface if 
that turns out to be the case, producing messages like:

defxx: v1.11 2014/07/01  Lawrence V. Stefani and others
0031:02:04.0: Cannot use I/O, no address set, aborting
0031:02:04.0: Recompile driver with "CONFIG_DEFXX_MMIO=y"

Keep the original check for the EISA MMIO resource as implemented, 
because in that case the length is hardwired to 0x400 as a consequence 
of how the compare/mask address decoding works in the ESIC chip and it 
is only the base address that is set to zero if MMIO has been disabled 
for the adapter in EISA configuration, which in turn could be a valid 
bus address in a legacy-free system implementing PCI, especially for 
port I/O.

Where the EISA MMIO resource has been disabled for the adapter in EISA 
configuration this arrangement keeps producing messages like:

eisa 00:05: EISA: slot 5: DEC3002 detected
defxx: v1.11 2014/07/01  Lawrence V. Stefani and others
00:05: Cannot use MMIO, no address set, aborting
00:05: Recompile driver with "CONFIG_DEFXX_MMIO=n"
00:05: Or run ECU and set adapter's MMIO location

with the last two lines now swapped for easier handling in the driver.

There is no need to check for and catch the case of a port I/O resource 
not having been assigned for EISA as the adapter uses the slot-specific 
I/O space, which gets assigned by how EISA has been specified and maps 
directly to the particular slot an option card has been placed in.  And 
the EISA variant of the adapter has additional registers that are only 
accessible via the port I/O space anyway.

While at it factor out the error message calls into helpers and fix an 
argument order bug with the `pr_err' call now in `dfx_register_res_err'.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 4d0438e56a8f ("defxx: Clean up DEFEA resource management")
Cc: stable@vger.kernel.org # v3.19+
---
 drivers/net/fddi/defxx.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

Index: linux-defxx/drivers/net/fddi/defxx.c
===================================================================
--- linux-defxx.orig/drivers/net/fddi/defxx.c
+++ linux-defxx/drivers/net/fddi/defxx.c
@@ -495,6 +495,25 @@ static const struct net_device_ops dfx_n
 	.ndo_set_mac_address	= dfx_ctl_set_mac_address,
 };
 
+static void dfx_register_res_alloc_err(const char *print_name, bool mmio,
+				       bool eisa)
+{
+	pr_err("%s: Cannot use %s, no address set, aborting\n",
+	       print_name, mmio ? "MMIO" : "I/O");
+	pr_err("%s: Recompile driver with \"CONFIG_DEFXX_MMIO=%c\"\n",
+	       print_name, mmio ? 'n' : 'y');
+	if (eisa && mmio)
+		pr_err("%s: Or run ECU and set adapter's MMIO location\n",
+		       print_name);
+}
+
+static void dfx_register_res_err(const char *print_name, bool mmio,
+				 unsigned long start, unsigned long len)
+{
+	pr_err("%s: Cannot reserve %s resource 0x%lx @ 0x%lx, aborting\n",
+	       print_name, mmio ? "MMIO" : "I/O", len, start);
+}
+
 /*
  * ================
  * = dfx_register =
@@ -568,15 +587,12 @@ static int dfx_register(struct device *b
 	dev_set_drvdata(bdev, dev);
 
 	dfx_get_bars(bdev, bar_start, bar_len);
-	if (dfx_bus_eisa && dfx_use_mmio && bar_start[0] == 0) {
-		pr_err("%s: Cannot use MMIO, no address set, aborting\n",
-		       print_name);
-		pr_err("%s: Run ECU and set adapter's MMIO location\n",
-		       print_name);
-		pr_err("%s: Or recompile driver with \"CONFIG_DEFXX_MMIO=n\""
-		       "\n", print_name);
+	if (bar_len[0] == 0 ||
+	    (dfx_bus_eisa && dfx_use_mmio && bar_start[0] == 0)) {
+		dfx_register_res_alloc_err(print_name, dfx_use_mmio,
+					   dfx_bus_eisa);
 		err = -ENXIO;
-		goto err_out;
+		goto err_out_disable;
 	}
 
 	if (dfx_use_mmio)
@@ -585,18 +601,16 @@ static int dfx_register(struct device *b
 	else
 		region = request_region(bar_start[0], bar_len[0], print_name);
 	if (!region) {
-		pr_err("%s: Cannot reserve %s resource 0x%lx @ 0x%lx, "
-		       "aborting\n", dfx_use_mmio ? "MMIO" : "I/O", print_name,
-		       (long)bar_len[0], (long)bar_start[0]);
+		dfx_register_res_err(print_name, dfx_use_mmio,
+				     bar_start[0], bar_len[0]);
 		err = -EBUSY;
 		goto err_out_disable;
 	}
 	if (bar_start[1] != 0) {
 		region = request_region(bar_start[1], bar_len[1], print_name);
 		if (!region) {
-			pr_err("%s: Cannot reserve I/O resource "
-			       "0x%lx @ 0x%lx, aborting\n", print_name,
-			       (long)bar_len[1], (long)bar_start[1]);
+			dfx_register_res_err(print_name, 0,
+					     bar_start[1], bar_len[1]);
 			err = -EBUSY;
 			goto err_out_csr_region;
 		}
@@ -604,9 +618,8 @@ static int dfx_register(struct device *b
 	if (bar_start[2] != 0) {
 		region = request_region(bar_start[2], bar_len[2], print_name);
 		if (!region) {
-			pr_err("%s: Cannot reserve I/O resource "
-			       "0x%lx @ 0x%lx, aborting\n", print_name,
-			       (long)bar_len[2], (long)bar_start[2]);
+			dfx_register_res_err(print_name, 0,
+					     bar_start[2], bar_len[2]);
 			err = -EBUSY;
 			goto err_out_bh_region;
 		}
