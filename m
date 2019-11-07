Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D495F344D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389702AbfKGQJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:38 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53692 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389705AbfKGQJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:38 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:34 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4S007213;
        Thu, 7 Nov 2019 18:09:32 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 18/19] Documentation: net: mlx5: Add mdev usage documentation
Date:   Thu,  7 Nov 2019 10:08:33 -0600
Message-Id: <20191107160834.21087-18-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          | 122 ++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Documentation/networking/device_drivers/mellanox/mlx5.rst
index d071c6b49e1f..cbdf0a37205b 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -14,6 +14,7 @@ Contents
 - `Devlink parameters`_
 - `Devlink health reporters`_
 - `mlx5 tracepoints`_
+- `Mediated devices`_
 
 Enabling the driver and kconfig options
 ================================================
@@ -97,6 +98,10 @@ Enabling the driver and kconfig options
 
 |   Provides low-level InfiniBand/RDMA and `RoCE <https://community.mellanox.com/s/article/recommended-network-configuration-examples-for-roce-deployment>`_ support.
 
+**CONFIG_MLX5_MDEV(y/n)** (module mlx5_core.ko)
+
+|   Provides support for Sub Functions using mediated devices.
+
 
 **External options** ( Choose if the corresponding mlx5 feature is required )
 
@@ -298,3 +303,120 @@ tc and eswitch offloads tracepoints:
     $ cat /sys/kernel/debug/tracing/trace
     ...
     kworker/u48:7-2221  [009] ...1  1475.387435: mlx5e_rep_neigh_update: netdev: ens1f0 MAC: 24:8a:07:9a:17:9a IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 neigh_connected=1
+
+Mediated devices
+================
+
+Overview
+--------
+mlx5 mediated device (mdev) enables users to create multiple netdevices
+and/or RDMA devices from single PCI function.
+
+Each mdev maps to a mlx5 sub function.
+mlx5 sub function is similar to PCI VF. However it doesn't have its own
+PCI function and MSI-X vectors.
+mlx5 sub function has several less low level device capabilities
+as compare to PCI function.
+
+Each mlx5 sub function has its own resource namespace for RDMA resources.
+
+mlx5 mdevs share common PCI resources such as PCI BAR region,
+MSI-X interrupts.
+
+Each mdev has its own window in the PCI BAR region, which is
+accessible only to that mdev and applications using it.
+
+mdevs are supported when eswitch mode of the devlink instance
+is in switchdev mode described in 'http://man7.org/linux/man-pages/man8/devlink-dev.8.html'.
+
+mdev uses mediated device subsystem 'https://www.kernel.org/doc/Documentation/vfio-mediated-device.txt' of the kernel for its life cycle.
+
+mdev is identified using a UUID defined by RFC 4122.
+
+Each created mdev has unique 12 letters alias. This alias is used to
+derive phys_port_name attribute of the corresponding representor
+netdevice.
+
+User commands examples
+----------------------
+
+- Set eswitch mode as switchdev mode::
+
+    $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
+
+- Create a mdev::
+
+    Generate a UUID
+    $ UUID=$(uuidgen)
+    Create the mdev using UUID
+    $ echo $UUID > /sys/class/net/ens2f0_p0/device/mdev_supported_types/mlx5_core-local/create
+
+- Unbind a mdev from vfio_mdev driver::
+
+    $ echo $UUID > /sys/bus/mdev/drivers/vfio_mdev/unbind
+
+- Bind a mdev to mlx5_core driver::
+
+    $ echo $UUID > /sys/bus/mdev/drivers/mlx5_core/bind
+
+- View netdevice and (optionally) RDMA device in sysfs tree::
+
+    $ ls -l /sys/bus/mdev/devices/$UUID/net/
+    $ ls -l /sys/bus/mdev/devices/$UUID/infiniband/
+
+- View netdevice and (optionally) RDMA device using iproute2 tools::
+
+    $ ip link show
+    $ rdma dev show
+
+- Query maximum number of mdevs that can be created::
+
+    $ cat /sys/class/net/ens2f0_p0/device/mdev_supported_types/mlx5_core-local/max_mdevs
+
+- Query remaining number of mdevs that can be created::
+
+    $ cat /sys/class/net/ens2f0_p0/device/mdev_supported_types/mlx5_core-local/available_instances
+
+- Query an alias of the mdev::
+
+    $ cat /sys/bus/mdev/devices/$UUID/alias
+
+Security model
+--------------
+This section covers security aspects of mlx5 mediated devices at
+host level and at network level.
+
+Host side:
+- At present mlx5 mdev is meant to be used only in a host.
+It is not meant to be mapped to a VM or access by userspace application
+using VFIO framework.
+Hence, mlx5_core driver doesn't implement any of the VFIO device specific
+callback routines.
+Hence, mlx5 mediated device cannot be mapped to a VM or to a userspace
+application via VFIO framework.
+
+- At present an mlx5 mdev can be accessed by an application through
+its netdevice and/or RDMA device.
+
+- mlx5 mdev does not share PCI BAR with its parent PCI function.
+
+- All mlx5 mdevs of a given parent device share a single PCI BAR.
+However each mdev device has a small dedicated window of the PCI BAR.
+Hence, one mdev device cannot access PCI BAR or any of the resources
+of another mdev device.
+
+- Each mlx5 mdev has its own dedicated event queue through which interrupt
+notifications are delivered. Hence, one mlx5 mdev cannot enable/disable
+interrupts of other mlx5 mdev. mlx5 mdev cannot enable/disable interrupts
+of the parent PCI function.
+
+Network side:
+- By default the netdevice and the rdma device of mlx5 mdev cannot send or
+receive any packets over the network or to any other mlx5 mdev.
+
+- mlx5 mdev follows devlink eswitch and vport model of PCI SR-IOV PF and VFs.
+All traffic is dropped by default in this eswitch model.
+
+- Each mlx5 mdev has one eswitch vport representor netdevice and rdma port.
+The user must do necessary configuration through such representor to enable
+mlx5 mdev to send and/or receive packets.
-- 
2.19.2

