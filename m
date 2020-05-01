Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6221C186F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgEAOrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgEAOpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:09 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC592499C;
        Fri,  1 May 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344307;
        bh=sOS2kIMOD03hQNs2x+NWyCYOuV8A+66xLSrlH1J7Uek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFGSpleWi0IozZd/em/lmgjlgzafNSx9O9bYi7I3aC36WSkfXZOmnOgzkUS8qIM60
         AP0ZgVpbyr7ywvft4Y3tBfpbSsIOr7BqV8Pif0yjVrhGufcwpddy41AprNLrR2R60J
         N2lhJhYx1TkyKRvAEXIecZjJhwpkAns9GRaeM8FI=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuU-00FCf0-1K; Fri, 01 May 2020 16:45:02 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 31/37] docs: networking: device drivers: convert smsc/smc9.txt to ReST
Date:   Fri,  1 May 2020 16:44:53 +0200
Message-Id: <38bf787b343aad259bdd5168099d3c6be3bae44e.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |  1 +
 .../networking/device_drivers/smsc/smc9.rst   | 49 +++++++++++++++++++
 .../networking/device_drivers/smsc/smc9.txt   | 42 ----------------
 drivers/net/ethernet/smsc/Kconfig             |  4 +-
 4 files changed, 52 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/smsc/smc9.rst
 delete mode 100644 Documentation/networking/device_drivers/smsc/smc9.txt

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 77270d59943b..3479e6f576c3 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -46,6 +46,7 @@ Contents:
    neterion/vxge
    qualcomm/rmnet
    sb1000
+   smsc/smc9
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/smsc/smc9.rst b/Documentation/networking/device_drivers/smsc/smc9.rst
new file mode 100644
index 000000000000..7cdcb9139942
--- /dev/null
+++ b/Documentation/networking/device_drivers/smsc/smc9.rst
@@ -0,0 +1,49 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+SMC 9xxxx Driver
+================
+
+Revision 0.12
+
+3/5/96
+
+Copyright 1996  Erik Stahlman
+
+Released under terms of the GNU General Public License.
+
+This file contains the instructions and caveats for my SMC9xxx driver.  You
+should not be using the driver without reading this file.
+
+Things to note about installation:
+
+  1. The driver should work on all kernels from 1.2.13 until 1.3.71.
+     (A kernel patch is supplied for 1.3.71 )
+
+  2. If you include this into the kernel, you might need to change some
+     options, such as for forcing IRQ.
+
+
+  3.  To compile as a module, run 'make'.
+      Make will give you the appropriate options for various kernel support.
+
+  4.  Loading the driver as a module::
+
+	use:   insmod smc9194.o
+	optional parameters:
+		io=xxxx    : your base address
+		irq=xx	   : your irq
+		ifport=x   :	0 for whatever is default
+				1 for twisted pair
+				2 for AUI  ( or BNC on some cards )
+
+How to obtain the latest version?
+
+FTP:
+	ftp://fenris.campus.vt.edu/smc9/smc9-12.tar.gz
+	ftp://sfbox.vt.edu/filebox/F/fenris/smc9/smc9-12.tar.gz
+
+
+Contacting me:
+    erik@mail.vt.edu
+
diff --git a/Documentation/networking/device_drivers/smsc/smc9.txt b/Documentation/networking/device_drivers/smsc/smc9.txt
deleted file mode 100644
index d1e15074e43d..000000000000
--- a/Documentation/networking/device_drivers/smsc/smc9.txt
+++ /dev/null
@@ -1,42 +0,0 @@
-
-SMC 9xxxx Driver 
-Revision 0.12 
-3/5/96
-Copyright 1996  Erik Stahlman 
-Released under terms of the GNU General Public License. 
-
-This file contains the instructions and caveats for my SMC9xxx driver.  You
-should not be using the driver without reading this file.  
-
-Things to note about installation:
-
-  1. The driver should work on all kernels from 1.2.13 until 1.3.71.
-	(A kernel patch is supplied for 1.3.71 )
-
-  2. If you include this into the kernel, you might need to change some
-	options, such as for forcing IRQ.   
-
- 
-  3.  To compile as a module, run 'make' .   
-	Make will give you the appropriate options for various kernel support.
- 
-  4.  Loading the driver as a module :
-
-	use:   insmod smc9194.o 
-	optional parameters:
-		io=xxxx    : your base address
-		irq=xx	   : your irq 
-		ifport=x   :	0 for whatever is default
-				1 for twisted pair
-				2 for AUI  ( or BNC on some cards )
-
-How to obtain the latest version? 
-	
-FTP:  
-	ftp://fenris.campus.vt.edu/smc9/smc9-12.tar.gz
-	ftp://sfbox.vt.edu/filebox/F/fenris/smc9/smc9-12.tar.gz 
-   
-
-Contacting me:
-    erik@mail.vt.edu
- 
diff --git a/drivers/net/ethernet/smsc/Kconfig b/drivers/net/ethernet/smsc/Kconfig
index 64ca1b36b91e..4fcc5858a750 100644
--- a/drivers/net/ethernet/smsc/Kconfig
+++ b/drivers/net/ethernet/smsc/Kconfig
@@ -28,7 +28,7 @@ config SMC9194
 	  option if you have a DELL laptop with the docking station, or
 	  another SMC9192/9194 based chipset.  Say Y if you want it compiled
 	  into the kernel, and read the file
-	  <file:Documentation/networking/device_drivers/smsc/smc9.txt>.
+	  <file:Documentation/networking/device_drivers/smsc/smc9.rst>.
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called smc9194.
@@ -43,7 +43,7 @@ config SMC91X
 	  This is a driver for SMC's 91x series of Ethernet chipsets,
 	  including the SMC91C94 and the SMC91C111. Say Y if you want it
 	  compiled into the kernel, and read the file
-	  <file:Documentation/networking/device_drivers/smsc/smc9.txt>.
+	  <file:Documentation/networking/device_drivers/smsc/smc9.rst>.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
-- 
2.25.4

