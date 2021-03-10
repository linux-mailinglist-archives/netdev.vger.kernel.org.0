Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE0F333C1D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhCJMDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhCJMDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:03:25 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFD5AC061760;
        Wed, 10 Mar 2021 04:03:24 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 44C769200B3; Wed, 10 Mar 2021 13:03:24 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 3EBF992009E;
        Wed, 10 Mar 2021 13:03:24 +0100 (CET)
Date:   Wed, 10 Mar 2021 13:03:24 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] FDDI: defxx: Use driver's name with resource
 requests
In-Reply-To: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2103100248020.33195@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace repeated "defxx" strings with a reference to the DRV_NAME macro 
and then use the driver's name rather that the bus address with resource 
requests so as to have contents of /proc/iomem and /proc/ioports more 
meaningful to the user, in line with what drivers usually do.

So rather than say:

5000-50ff : DEC FDDIcontroller/EISA Adapter
  5000-503f : 00:05
  5040-5043 : 00:05
5400-54ff : DEC FDDIcontroller/EISA Adapter
5800-58ff : DEC FDDIcontroller/EISA Adapter
5c00-5cff : DEC FDDIcontroller/EISA Adapter
  5c80-5cbf : 00:05

or:

620c080020000-620c08002007f : 0031:02:04.0
  620c080020000-620c08002007f : 0031:02:04.0
620c080030000-620c08003ffff : 0031:02:04.0

or:

1f100000-1f10003f : tc2

we report:

5000-50ff : DEC FDDIcontroller/EISA Adapter
  5000-503f : defxx
  5040-5043 : defxx
5400-54ff : DEC FDDIcontroller/EISA Adapter
5800-58ff : DEC FDDIcontroller/EISA Adapter
5c00-5cff : DEC FDDIcontroller/EISA Adapter
  5c80-5cbf : defxx

and:

620c080020000-620c08002007f : 0031:02:04.0
  620c080020000-620c08002007f : defxx
620c080030000-620c08003ffff : 0031:02:04.0

and:

1f100000-1f10003f : defxx

respectively for the DEFEA (EISA), DEFPA (PCI), and DEFTA (TURBOchannel) 
adapters.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
 drivers/net/fddi/defxx.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-defxx/drivers/net/fddi/defxx.c
===================================================================
--- linux-defxx.orig/drivers/net/fddi/defxx.c
+++ linux-defxx/drivers/net/fddi/defxx.c
@@ -580,14 +580,15 @@ static int dfx_register(struct device *b
 
 	if (dfx_use_mmio) {
 		region = request_mem_region(bar_start[0], bar_len[0],
-					    print_name);
+					    bdev->driver->name);
 		if (!region && (dfx_bus_eisa || dfx_bus_pci)) {
 			bp->mmio = false;
 			dfx_get_bars(bp, bar_start, bar_len);
 		}
 	}
 	if (!dfx_use_mmio)
-		region = request_region(bar_start[0], bar_len[0], print_name);
+		region = request_region(bar_start[0], bar_len[0],
+					bdev->driver->name);
 	if (!region) {
 		dfx_register_res_err(print_name, dfx_use_mmio,
 				     bar_start[0], bar_len[0]);
@@ -595,7 +596,8 @@ static int dfx_register(struct device *b
 		goto err_out_disable;
 	}
 	if (bar_start[1] != 0) {
-		region = request_region(bar_start[1], bar_len[1], print_name);
+		region = request_region(bar_start[1], bar_len[1],
+					bdev->driver->name);
 		if (!region) {
 			dfx_register_res_err(print_name, 0,
 					     bar_start[1], bar_len[1]);
@@ -604,7 +606,8 @@ static int dfx_register(struct device *b
 		}
 	}
 	if (bar_start[2] != 0) {
-		region = request_region(bar_start[2], bar_len[2], print_name);
+		region = request_region(bar_start[2], bar_len[2],
+					bdev->driver->name);
 		if (!region) {
 			dfx_register_res_err(print_name, 0,
 					     bar_start[2], bar_len[2]);
@@ -3745,7 +3748,7 @@ static const struct pci_device_id dfx_pc
 MODULE_DEVICE_TABLE(pci, dfx_pci_table);
 
 static struct pci_driver dfx_pci_driver = {
-	.name		= "defxx",
+	.name		= DRV_NAME,
 	.id_table	= dfx_pci_table,
 	.probe		= dfx_pci_register,
 	.remove		= dfx_pci_unregister,
@@ -3776,7 +3779,7 @@ MODULE_DEVICE_TABLE(eisa, dfx_eisa_table
 static struct eisa_driver dfx_eisa_driver = {
 	.id_table	= dfx_eisa_table,
 	.driver		= {
-		.name	= "defxx",
+		.name	= DRV_NAME,
 		.bus	= &eisa_bus_type,
 		.probe	= dfx_dev_register,
 		.remove	= dfx_dev_unregister,
@@ -3797,7 +3800,7 @@ MODULE_DEVICE_TABLE(tc, dfx_tc_table);
 static struct tc_driver dfx_tc_driver = {
 	.id_table	= dfx_tc_table,
 	.driver		= {
-		.name	= "defxx",
+		.name	= DRV_NAME,
 		.bus	= &tc_bus_type,
 		.probe	= dfx_dev_register,
 		.remove	= dfx_dev_unregister,
