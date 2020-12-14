Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0562DA2C1
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503422AbgLNVra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:47:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503376AbgLNVpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 16:45:49 -0500
From:   Saeed Mahameed <saeed@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v4 13/15] devlink: Add devlink port documentation
Date:   Mon, 14 Dec 2020 13:43:50 -0800
Message-Id: <20201214214352.198172-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214214352.198172-1-saeed@kernel.org>
References: <20201214214352.198172-1-saeed@kernel.org>
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
index 000000000000..4c910dbb01ca
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
+potentially multiple physical and virtual functions. Such PCI function consists
+of one or more ports. This port of the function is represented by the devlink
+eswitch port.
+
+A PCI Device connected to multiple CPUs or multiple PCI root complexes or
+SmartNIC, however, may have multiple controllers. For a device with multiple
+controllers, each controller is distinguished by a unique controller number.
+An eswitch on the PCI device support ports of multiple controllers.
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
+In above example, external controller (identified by controller number = 1)
+doesn't have eswitch. Local controller (identified by controller number = 0)
+has the eswitch. Devlink instance on local controller has eswitch devlink
+ports representing ports for both the controllers.
+
+Port function configuration
+===========================
+
+A user can configure the port function attribute before enumerating the
+PCI function. Usually it means, user should configure port function attribute
+before a bus specific device for the function is created. However, when
+SRIOV is enabled, virtual function devices are created on the PCI bus.
+Hence, function attribute should be configured before binding virtual
+function device to the driver.
+
+User may set the hardware address of the function represented by the devlink
+port function. For Ethernet port function this means a MAC address.
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

