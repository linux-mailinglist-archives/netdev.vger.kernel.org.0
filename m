Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5187F2DA9AE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgLOJG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbgLOJFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 04:05:51 -0500
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
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v5 15/15] net/mlx5: Add devlink subfunction port documentation
Date:   Tue, 15 Dec 2020 01:03:58 -0800
Message-Id: <20201215090358.240365-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215090358.240365-1-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add documentation for subfunction management using devlink
port.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst | 204 ++++++++++++++++++
 1 file changed, 204 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index a5eb22793bb9..07e38c044355 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -12,6 +12,8 @@ Contents
 - `Enabling the driver and kconfig options`_
 - `Devlink info`_
 - `Devlink parameters`_
+- `mlx5 subfunction`_
+- `mlx5 port function`_
 - `Devlink health reporters`_
 - `mlx5 tracepoints`_
 
@@ -181,6 +183,208 @@ User command examples:
       values:
          cmode driverinit value true
 
+mlx5 subfunction
+================
+mlx5 supports subfunctions management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
+
+A Subfunction has its own function capabilities and its own resources. This
+means a subfunction has its own dedicated queues(txq, rxq, cq, eq). These queues
+are neither shared nor stolen from the parent PCI function.
+
+When subfunction is RDMA capable, it has its own QP1, GID table and rdma
+resources neither shared nor stolen from the parent PCI function.
+
+A subfunction has dedicated window in PCI BAR space that is not shared
+with the other subfunctions or parent PCI function. This ensures that all
+class devices of the subfunction accesses only assigned PCI BAR space.
+
+A Subfunction supports eswitch representation through which it supports tc
+offloads. User must configure eswitch to send/receive packets from/to
+subfunction port.
+
+Subfunctions share PCI level resources such as PCI MSI-X IRQs with
+the other subfunctions and/or with its parent PCI function.
+
+Example mlx5 software, system and device view::
+
+       _______
+      | admin |
+      | user  |----------
+      |_______|         |
+          |             |
+      ____|____       __|______            _________________
+     |         |     |         |          |                 |
+     | devlink |     | tc tool |          |    user         |
+     | tool    |     |_________|          | applications    |
+     |_________|         |                |_________________|
+           |             |                   |          |
+           |             |                   |          |         Userspace
+ +---------|-------------|-------------------|----------|--------------------+
+           |             |           +----------+   +----------+   Kernel
+           |             |           |  netdev  |   | rdma dev |
+           |             |           +----------+   +----------+
+   (devlink port add/del |              ^               ^
+    port function set)   |              |               |
+           |             |              +---------------|
+      _____|___          |              |        _______|_______
+     |         |         |              |       | mlx5 class    |
+     | devlink |   +------------+       |       |   drivers     |
+     | kernel  |   | rep netdev |       |       |(mlx5_core,ib) |
+     |_________|   +------------+       |       |_______________|
+           |             |              |               ^
+   (devlink ops)         |              |          (probe/remove)
+  _________|________     |              |           ____|________
+ | subfunction      |    |     +---------------+   | subfunction |
+ | management driver|-----     | subfunction   |---|  driver     |
+ | (mlx5_core)      |          | auxiliary dev |   | (mlx5_core) |
+ |__________________|          +---------------+   |_____________|
+           |                                            ^
+  (sf add/del, vhca events)                             |
+           |                                      (device add/del)
+      _____|____                                    ____|________
+     |          |                                  | subfunction |
+     |  PCI NIC |---- activate/deactive events---->| host driver |
+     |__________|                                  | (mlx5_core) |
+                                                   |_____________|
+
+Subfunction is created using devlink port interface.
+
+- Change device to switchdev mode::
+
+    $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
+
+- Add a devlink port of subfunction flavour::
+
+    $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
+
+- Show a devlink port of the subfunction::
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:00:00
+
+- Delete a devlink port of subfunction after use::
+
+    $ devlink port del pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
+
+mlx5 port function
+==================
+mlx5 driver provides mechanism to setup PCI VF/SF port function
+attributes in unified way for smartnic and non-smartnic NICs.
+
+This is supported only when eswitch mode is set to switchdev. Port function
+configuration of the PCI VF/SF is supported through devlink eswitch port.
+
+Port function attributes should be set before PCI VF/SF is enumerated by the
+driver.
+
+MAC address setup
+-----------------
+mlx5 driver provides mechanism to setup the MAC address of the PCI VF/SF.
+
+Configured MAC address of the PCI VF/SF will be used by netdevice and rdma
+device created for the PCI VF/SF.
+
+- Get MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+      function:
+        hw_addr 00:00:00:00:00:00
+
+- Set MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port function set pci/0000:06:00.0/2 hw_addr 00:11:22:33:44:55
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+      function:
+        hw_addr 00:11:22:33:44:55
+
+- Get MAC address of the SF identified by its unique devlink port index::
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:00:00
+
+- Set MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcivf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:88:88
+
+SF state setup
+--------------
+To use the SF, user must active the SF using SF port function state attribute.
+
+- Get state of the SF identified by its unique devlink port index::
+
+   $ devlink port show ens2f0npf0sf88
+   pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
+     function:
+       hw_addr 00:00:00:00:88:88 state inactive opstate detached
+
+- Activate the function and verify its state is active::
+
+   $ devlink port function set ens2f0npf0sf88 state active
+
+   $ devlink port show ens2f0npf0sf88
+   pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
+     function:
+       hw_addr 00:00:00:00:88:88 state active opstate detached
+
+Upon function activation, PF driver instance gets the event from the device that
+particular SF was activated. It's the cue to put the device on bus, probe it and
+instantiate devlink instance and class specific auxiliary devices for it.
+
+- Show the auxiliary device and port of the subfunction::
+
+    $ devlink dev show
+    devlink dev show auxiliary/mlx5_core.sf.4
+
+    $ devlink port show auxiliary/mlx5_core.sf.4/1
+    auxiliary/mlx5_core.sf.4/1: type eth netdev p0sf88 flavour virtual port 0 splittable false
+
+    $ rdma link show mlx5_0/1
+    link mlx5_0/1 state ACTIVE physical_state LINK_UP netdev p0sf88
+
+    $ rdma dev show
+    8: rocep6s0f1: node_type ca fw 16.29.0550 node_guid 248a:0703:00b3:d113 sys_image_guid 248a:0703:00b3:d112
+    13: mlx5_0: node_type ca fw 16.29.0550 node_guid 0000:00ff:fe00:8888 sys_image_guid 248a:0703:00b3:d112
+
+- Subfunction auxiliary device and class device hierarchy::
+
+                 mlx5_core.sf.4
+          (subfunction auxiliary device)
+                       /\
+                      /  \
+                     /    \
+                    /      \
+                   /        \
+      mlx5_core.eth.4     mlx5_core.rdma.4
+     (sf eth aux dev)     (sf rdma aux dev)
+         |                      |
+         |                      |
+      p0sf88                  mlx5_0
+     (sf netdev)          (sf rdma device)
+
+Additionally SF port also gets the event when the driver attaches to the
+auxiliary device of the subfunction. This results in changing the operational
+state of the function. This provides visibility to user to decide when it is
+safe to delete the SF port for graceful termination of the subfunction.
+
+- Show the SF port operational state::
+
+    $ devlink port show ens2f0npf0sf88
+    pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
+      function:
+        hw_addr 00:00:00:00:88:88 state active opstate attached
+
 Devlink health reporters
 ========================
 
-- 
2.26.2

