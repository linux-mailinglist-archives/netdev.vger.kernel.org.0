Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6C82F5354
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbhAMT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbhAMT3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 14:29:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B673F23435;
        Wed, 13 Jan 2021 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610566080;
        bh=9n5162lUSx/lZHHbDuIz/xZwbuzzBn7e0KVtSWTnRrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2CC4GKI+PRsEkJF8+UBch04w6ucdSYveGU87xeeAe+7vAyRQZf2l57NtDEeoM/fe
         GQV8IjI7C/7nTYcyoxopeECAlPOQKSXNi4M0/ar35dctaFmSPKSJWkLKHvCT7JXA0q
         rQZeEr50fJpPRgz43gIQPV55tyGOyLjAgzDm/Sx7Om1hbfbgwN6/ycUwITaGrVJG/A
         bMS3+Bzi7UmEc9ahGL+5vrlQgRpRMtn6toyAijs1CPmRdSAo62PCXqeH6anz+6yPB3
         etP+luEcKurLaHMiNwlyKyXzwVtY8IM6FZapNOb52IFcyIfWqzaTtc342riLmln+rI
         bjCMaUopO1Qcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V6 14/14] net/mlx5: Add devlink subfunction port documentation
Date:   Wed, 13 Jan 2021 11:27:30 -0800
Message-Id: <20210113192730.280656-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113192730.280656-1-saeed@kernel.org>
References: <20210113192730.280656-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add documentation for subfunction management using devlink
port.

changelog:
v5->v6:
 - corrected spellings
 - updated port add example
 - corrected port delete example

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst | 210 ++++++++++++++++++
 1 file changed, 210 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index a5eb22793bb9..a1b32fcd0d76 100644
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
 
@@ -181,6 +183,214 @@ User command examples:
       values:
          cmode driverinit value true
 
+mlx5 subfunction
+================
+mlx5 supports subfunction management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
+
+A Subfunction has its own function capabilities and its own resources. This
+means a subfunction has its own dedicated queues (txq, rxq, cq, eq). These
+queues are neither shared nor stolen from the parent PCI function.
+
+When a subfunction is RDMA capable, it has its own QP1, GID table and rdma
+resources neither shared nor stolen from the parent PCI function.
+
+A subfunction has a dedicated window in PCI BAR space that is not shared
+with ther other subfunctions or the parent PCI function. This ensures that all
+devices (netdev, rdma, vdpa etc.) of the subfunction accesses only assigned
+PCI BAR space.
+
+A Subfunction supports eswitch representation through which it supports tc
+offloads. The user configures eswitch to send/receive packets from/to
+the subfunction port.
+
+Subfunctions share PCI level resources such as PCI MSI-X IRQs with
+other subfunctions and/or with its parent PCI function.
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
+- Add a devlink port of subfunction flaovur::
+
+    $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
+    pci/0000:06:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
+      function:
+        hw_addr 00:00:00:00:00:00 state inactive opstate detached
+
+- Show a devlink port of the subfunction::
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:00:00 state inactive opstate detached
+
+- Delete a devlink port of subfunction after use::
+
+    $ devlink port del pci/0000:06:00.0/32768
+
+mlx5 function attributes
+========================
+The mlx5 driver provides a mechanism to setup PCI VF/SF function attributes in
+a unified way for SmartNIC and non-SmartNIC.
+
+This is supported only when the eswitch mode is set to switchdev. Port function
+configuration of the PCI VF/SF is supported through devlink eswitch port.
+
+Port function attributes should be set before PCI VF/SF is enumerated by the
+driver.
+
+MAC address setup
+-----------------
+mlx5 driver provides mechanism to setup the MAC address of the PCI VF/SF.
+
+The configured MAC address of the PCI VF/SF will be used by netdevice and rdma
+device created for the PCI VF/SF.
+
+- Get the MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+      function:
+        hw_addr 00:00:00:00:00:00
+
+- Set the MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port function set pci/0000:06:00.0/2 hw_addr 00:11:22:33:44:55
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+      function:
+        hw_addr 00:11:22:33:44:55
+
+- Get the MAC address of the SF identified by its unique devlink port index::
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:00:00
+
+- Set the MAC address of the VF identified by its unique devlink port index::
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
+To use the SF, the user must active the SF using the SF function state
+attribute.
+
+- Get the state of the SF identified by its unique devlink port index::
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
+Upon function activation, the PF driver instance gets the event from the device
+that a particular SF was activated. It's the cue to put the device on bus, probe
+it and instantiate the devlink instance and class specific auxiliary devices
+for it.
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
+Additionally, the SF port also gets the event when the driver attaches to the
+auxiliary device of the subfunction. This results in changing the operational
+state of the function. This provides visiblity to the user to decide when is it
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

