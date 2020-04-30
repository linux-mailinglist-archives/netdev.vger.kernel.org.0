Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9F61C019A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgD3QH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 014C324954;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=+oepTwi2d1+xgVCEplDCO3Ur/xrWZBrtr5WgvtZvPeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CF4qXlD5D79lPozQgx2afoIOFLphfXHFM48RzwlkrIcM6Tt+0qggu5OBstzuG0pde
         zvFBnaLWJSoyAtiesqaAbMaK1p7DAkv7PwpKchA1gb7S9EdmZS/RGdTzAIAETxGmTN
         Y6mgJ9ZE25e8qx1EL8M+nboD7QVDH/o74KfrDiZE=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEy-9A; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 11/37] docs: networking: convert netif-msg.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:06 +0200
Message-Id: <72289384e0cf00824ed80b819ef9720665eabccf.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title and chapter markups;
- mark lists as such;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst     |  1 +
 Documentation/networking/netif-msg.rst | 95 ++++++++++++++++++++++++++
 Documentation/networking/netif-msg.txt | 79 ---------------------
 3 files changed, 96 insertions(+), 79 deletions(-)
 create mode 100644 Documentation/networking/netif-msg.rst
 delete mode 100644 Documentation/networking/netif-msg.txt

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 1ae0cbef8c04..d98509f15363 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -84,6 +84,7 @@ Contents:
    netdev-features
    netdevices
    netfilter-sysctl
+   netif-msg
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/netif-msg.rst b/Documentation/networking/netif-msg.rst
new file mode 100644
index 000000000000..b20d265a734d
--- /dev/null
+++ b/Documentation/networking/netif-msg.rst
@@ -0,0 +1,95 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============
+NETIF Msg Level
+===============
+
+The design of the network interface message level setting.
+
+History
+-------
+
+ The design of the debugging message interface was guided and
+ constrained by backwards compatibility previous practice.  It is useful
+ to understand the history and evolution in order to understand current
+ practice and relate it to older driver source code.
+
+ From the beginning of Linux, each network device driver has had a local
+ integer variable that controls the debug message level.  The message
+ level ranged from 0 to 7, and monotonically increased in verbosity.
+
+ The message level was not precisely defined past level 3, but were
+ always implemented within +-1 of the specified level.  Drivers tended
+ to shed the more verbose level messages as they matured.
+
+   - 0  Minimal messages, only essential information on fatal errors.
+   - 1  Standard messages, initialization status.  No run-time messages
+   - 2  Special media selection messages, generally timer-driver.
+   - 3  Interface starts and stops, including normal status messages
+   - 4  Tx and Rx frame error messages, and abnormal driver operation
+   - 5  Tx packet queue information, interrupt events.
+   - 6  Status on each completed Tx packet and received Rx packets
+   - 7  Initial contents of Tx and Rx packets
+
+ Initially this message level variable was uniquely named in each driver
+ e.g. "lance_debug", so that a kernel symbolic debugger could locate and
+ modify the setting.  When kernel modules became common, the variables
+ were consistently renamed to "debug" and allowed to be set as a module
+ parameter.
+
+ This approach worked well.  However there is always a demand for
+ additional features.  Over the years the following emerged as
+ reasonable and easily implemented enhancements
+
+   - Using an ioctl() call to modify the level.
+   - Per-interface rather than per-driver message level setting.
+   - More selective control over the type of messages emitted.
+
+ The netif_msg recommendation adds these features with only a minor
+ complexity and code size increase.
+
+ The recommendation is the following points
+
+  - Retaining the per-driver integer variable "debug" as a module
+    parameter with a default level of '1'.
+
+  - Adding a per-interface private variable named "msg_enable".  The
+    variable is a bit map rather than a level, and is initialized as::
+
+       1 << debug
+
+    Or more precisely::
+
+	debug < 0 ? 0 : 1 << min(sizeof(int)-1, debug)
+
+    Messages should changes from::
+
+      if (debug > 1)
+	   printk(MSG_DEBUG "%s: ...
+
+    to::
+
+      if (np->msg_enable & NETIF_MSG_LINK)
+	   printk(MSG_DEBUG "%s: ...
+
+
+The set of message levels is named
+
+
+  =========   ===================	============
+  Old level   Name			Bit position
+  =========   ===================	============
+    0         NETIF_MSG_DRV		0x0001
+    1         NETIF_MSG_PROBE		0x0002
+    2         NETIF_MSG_LINK		0x0004
+    2         NETIF_MSG_TIMER		0x0004
+    3         NETIF_MSG_IFDOWN		0x0008
+    3         NETIF_MSG_IFUP		0x0008
+    4         NETIF_MSG_RX_ERR		0x0010
+    4         NETIF_MSG_TX_ERR		0x0010
+    5         NETIF_MSG_TX_QUEUED	0x0020
+    5         NETIF_MSG_INTR		0x0020
+    6         NETIF_MSG_TX_DONE		0x0040
+    6         NETIF_MSG_RX_STATUS	0x0040
+    7         NETIF_MSG_PKTDATA		0x0080
+  =========   ===================	============
diff --git a/Documentation/networking/netif-msg.txt b/Documentation/networking/netif-msg.txt
deleted file mode 100644
index c967ddb90d0b..000000000000
--- a/Documentation/networking/netif-msg.txt
+++ /dev/null
@@ -1,79 +0,0 @@
-
-________________
-NETIF Msg Level
-
-The design of the network interface message level setting.
-
-History
-
- The design of the debugging message interface was guided and
- constrained by backwards compatibility previous practice.  It is useful
- to understand the history and evolution in order to understand current
- practice and relate it to older driver source code.
-
- From the beginning of Linux, each network device driver has had a local
- integer variable that controls the debug message level.  The message
- level ranged from 0 to 7, and monotonically increased in verbosity.
-
- The message level was not precisely defined past level 3, but were
- always implemented within +-1 of the specified level.  Drivers tended
- to shed the more verbose level messages as they matured.
-    0  Minimal messages, only essential information on fatal errors.
-    1  Standard messages, initialization status.  No run-time messages
-    2  Special media selection messages, generally timer-driver.
-    3  Interface starts and stops, including normal status messages
-    4  Tx and Rx frame error messages, and abnormal driver operation
-    5  Tx packet queue information, interrupt events.
-    6  Status on each completed Tx packet and received Rx packets
-    7  Initial contents of Tx and Rx packets
-
- Initially this message level variable was uniquely named in each driver
- e.g. "lance_debug", so that a kernel symbolic debugger could locate and
- modify the setting.  When kernel modules became common, the variables
- were consistently renamed to "debug" and allowed to be set as a module
- parameter.
-
- This approach worked well.  However there is always a demand for
- additional features.  Over the years the following emerged as
- reasonable and easily implemented enhancements
-   Using an ioctl() call to modify the level.
-   Per-interface rather than per-driver message level setting.
-   More selective control over the type of messages emitted.
-
- The netif_msg recommendation adds these features with only a minor
- complexity and code size increase.
-
- The recommendation is the following points
-    Retaining the per-driver integer variable "debug" as a module
-    parameter with a default level of '1'.
-
-    Adding a per-interface private variable named "msg_enable".  The
-    variable is a bit map rather than a level, and is initialized as
-       1 << debug
-    Or more precisely
-        debug < 0 ? 0 : 1 << min(sizeof(int)-1, debug)
-
-    Messages should changes from
-      if (debug > 1)
-           printk(MSG_DEBUG "%s: ...
-    to
-      if (np->msg_enable & NETIF_MSG_LINK)
-           printk(MSG_DEBUG "%s: ...
-
-
-The set of message levels is named
-  Old level   Name   Bit position
-    0    NETIF_MSG_DRV		0x0001
-    1    NETIF_MSG_PROBE	0x0002
-    2    NETIF_MSG_LINK		0x0004
-    2    NETIF_MSG_TIMER	0x0004
-    3    NETIF_MSG_IFDOWN	0x0008
-    3    NETIF_MSG_IFUP		0x0008
-    4    NETIF_MSG_RX_ERR	0x0010
-    4    NETIF_MSG_TX_ERR	0x0010
-    5    NETIF_MSG_TX_QUEUED	0x0020
-    5    NETIF_MSG_INTR		0x0020
-    6    NETIF_MSG_TX_DONE	0x0040
-    6    NETIF_MSG_RX_STATUS	0x0040
-    7    NETIF_MSG_PKTDATA	0x0080
-
-- 
2.25.4

