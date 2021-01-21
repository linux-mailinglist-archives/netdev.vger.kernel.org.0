Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7890A2FF3A6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbhAUSyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:54:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728303AbhAUIye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 03:54:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7CA523A21;
        Thu, 21 Jan 2021 08:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611219180;
        bh=scLCCxJVoGOvT2w5RbwYecYIAeA90dNW03bxA9MWhWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAZs1Go4ydZ/MvWH/Rnb0wNOt6nl/RXrmG5DpNfC/SMgDn46j0ETuTEyjtXIzDHnQ
         oa8lbiY5ebfWTgIB56A7lNtf9xah/uFDSpT+bt4A5A8/ZFbHgy/rT7+1CHLauqGEJC
         g1VE0voW5fFvpWqkqI5h/JX8Eup5k4TkeMBdvnR+ANy1syQMX/BrS3Nb4HL57ysdIs
         IJoGXlqIkADcPsrRz09a+Q6bWy9AwdDq5lUtfPCqBXhgaXbRwLJrc7CCAQiEiR3xT8
         Ae1QMwfqdSZ0fp0riapbEmHFGv+9rEdSM1IGSOvh5Wgbd5cVC0Yye18yk7287g1VVZ
         valbjKnOelCyA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V9 12/14] devlink: Add devlink port documentation
Date:   Thu, 21 Jan 2021 00:52:35 -0800
Message-Id: <20210121085237.137919-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121085237.137919-1-saeed@kernel.org>
References: <20210121085237.137919-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Added documentation for devlink port and port function related commands.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       | 118 ++++++++++++++++++
 Documentation/networking/devlink/index.rst    |   1 +
 2 files changed, 119 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-port.rst

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
new file mode 100644
index 000000000000..c564b557e757
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -0,0 +1,118 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _devlink_port:
+
+============
+Devlink Port
+============
+
+``devlink-port`` is a port that exists on the device. It has a logically
+separate ingress/egress point of the device. A devlink port can be any one
+of many flavours. A devlink port flavour along with port attributes
+describe what a port represents.
+
+A device driver that intends to publish a devlink port sets the
+devlink port attributes and registers the devlink port.
+
+Devlink port flavours are described below.
+
+.. list-table:: List of devlink port flavours
+   :widths: 33 90
+
+   * - Flavour
+     - Description
+   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
+     - Any kind of physical port. This can be an eswitch physical port or any
+       other physical port on the device.
+   * - ``DEVLINK_PORT_FLAVOUR_DSA``
+     - This indicates a DSA interconnect port.
+   * - ``DEVLINK_PORT_FLAVOUR_CPU``
+     - This indicates a CPU port applicable only to DSA.
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
+     - This indicates an eswitch port representing a port of PCI
+       physical function (PF).
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
+     - This indicates an eswitch port representing a port of PCI
+       virtual function (VF).
+   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
+     - This indicates a virtual port for the PCI virtual function.
+
+Devlink port can have a different type based on the link layer described below.
+
+.. list-table:: List of devlink port types
+   :widths: 23 90
+
+   * - Type
+     - Description
+   * - ``DEVLINK_PORT_TYPE_ETH``
+     - Driver should set this port type when a link layer of the port is
+       Ethernet.
+   * - ``DEVLINK_PORT_TYPE_IB``
+     - Driver should set this port type when a link layer of the port is
+       InfiniBand.
+   * - ``DEVLINK_PORT_TYPE_AUTO``
+     - This type is indicated by the user when driver should detect the port
+       type automatically.
+
+PCI controllers
+---------------
+In most cases a PCI device has only one controller. A controller consists of
+potentially multiple physical and virtual functions. A function consists
+of one or more ports. This port is represented by the devlink eswitch port.
+
+A PCI device connected to multiple CPUs or multiple PCI root complexes or a
+SmartNIC, however, may have multiple controllers. For a device with multiple
+controllers, each controller is distinguished by a unique controller number.
+An eswitch is on the PCI device which supports ports of multiple controllers.
+
+An example view of a system with two controllers::
+
+                 ---------------------------------------------------------
+                 |                                                       |
+                 |           --------- ---------         ------- ------- |
+    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
+    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
+    | pci rc  |=== | pf0 |______/________/       | pf1 |___/_______/     |
+    | connect |  | -------                       -------                 |
+    -----------  |     | controller_num=1 (no eswitch)                   |
+                 ------|--------------------------------------------------
+                 (internal wire)
+                       |
+                 ---------------------------------------------------------
+                 | devlink eswitch ports and reps                        |
+                 | ----------------------------------------------------- |
+                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
+                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
+                 | ----------------------------------------------------- |
+                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
+                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
+                 | ----------------------------------------------------- |
+                 |                                                       |
+                 |                                                       |
+    -----------  |           --------- ---------         ------- ------- |
+    | smartNIC|  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
+    | pci rc  |==| -------   ----/---- ---/----- ------- ---/--- ---/--- |
+    | connect |  | | pf0 |______/________/       | pf1 |___/_______/     |
+    -----------  | -------                       -------                 |
+                 |                                                       |
+                 |  local controller_num=0 (eswitch)                     |
+                 ---------------------------------------------------------
+
+In the above example, the external controller (identified by controller number = 1)
+doesn't have the eswitch. Local controller (identified by controller number = 0)
+has the eswitch. The Devlink instance on the local controller has eswitch
+devlink ports for both the controllers.
+
+Function configuration
+======================
+
+A user can configure the function attribute before enumerating the PCI
+function. Usually it means, user should configure function attribute
+before a bus specific device for the function is created. However, when
+SRIOV is enabled, virtual function devices are created on the PCI bus.
+Hence, function attribute should be configured before binding virtual
+function device to the driver.
+
+A user may set the hardware address of the function using
+'devlink port function set hw_addr' command. For Ethernet port function
+this means a MAC address.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index d82874760ae2..aab79667f97b 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -18,6 +18,7 @@ general.
    devlink-info
    devlink-flash
    devlink-params
+   devlink-port
    devlink-region
    devlink-resource
    devlink-reload
-- 
2.26.2

