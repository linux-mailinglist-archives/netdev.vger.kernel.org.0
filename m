Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38922DA2C7
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503606AbgLNVsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503293AbgLNVpt (ORCPT <rfc822;netdev@vger.kernel.org>);
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
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v4 14/15] devlink: Extend devlink port documentation for subfunctions
Date:   Mon, 14 Dec 2020 13:43:51 -0800
Message-Id: <20201214214352.198172-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214214352.198172-1-saeed@kernel.org>
References: <20201214214352.198172-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add devlink port documentation for subfunction management.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/driver-api/auxiliary_bus.rst    |  2 +
 .../networking/devlink/devlink-port.rst       | 89 ++++++++++++++++++-
 2 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/Documentation/driver-api/auxiliary_bus.rst b/Documentation/driver-api/auxiliary_bus.rst
index 2312506b0674..fff96c7ba7a8 100644
--- a/Documentation/driver-api/auxiliary_bus.rst
+++ b/Documentation/driver-api/auxiliary_bus.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0-only
 
+.. _auxiliary_bus:
+
 =============
 Auxiliary Bus
 =============
diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 4c910dbb01ca..c6924e7a341e 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -34,6 +34,9 @@ Devlink port flavours are described below.
    * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
      - This indicates an eswitch port representing a port of PCI
        virtual function (VF).
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_SF``
+     - This indicates an eswitch port representing a port of PCI
+       subfunction (SF).
    * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
      - This indicates a virtual port for the PCI virtual function.
 
@@ -57,9 +60,9 @@ Devlink port can have a different type based on the link layer described below.
 PCI controllers
 ---------------
 In most cases a PCI device has only one controller. A controller consists of
-potentially multiple physical and virtual functions. Such PCI function consists
-of one or more ports. This port of the function is represented by the devlink
-eswitch port.
+potentially multiple physical functions, virtual functions and subfunctions.
+Such PCI function consists of one or more ports. This port of the function
+is represented by the devlink eswitch port.
 
 A PCI Device connected to multiple CPUs or multiple PCI root complexes or
 SmartNIC, however, may have multiple controllers. For a device with multiple
@@ -112,7 +115,85 @@ PCI function. Usually it means, user should configure port function attribute
 before a bus specific device for the function is created. However, when
 SRIOV is enabled, virtual function devices are created on the PCI bus.
 Hence, function attribute should be configured before binding virtual
-function device to the driver.
+function device to the driver. For subfunctions, this means user should
+configure port function attribute before activating the port function.
 
 User may set the hardware address of the function represented by the devlink
 port function. For Ethernet port function this means a MAC address.
+
+Subfunctions
+============
+
+Subfunctions are lightweight functions that has parent PCI function on which
+it is deployed. Subfunctions are created and deployed in unit of 1. Unlike
+SRIOV VFs, they don't require their own PCI virtual function. They communicate
+with the hardware through the parent PCI function. Subfunctions can possibly
+scale better.
+
+To use a subfunction, 3 steps setup sequence is followed.
+(1) create - create a subfunction;
+(2) configure - configure subfunction attributes;
+(3) deploy - deploy the subfunction;
+
+Subfunction management is done using devlink port user interface.
+User performs setup on the subfunction management device.
+
+(1) Create
+----------
+A subfunction is created using a devlink port interface. User adds the
+subfunction by adding a devlink port of subfunction flavour. The devlink
+kernel code calls down to subfunction management driver (devlink op) and asks
+it to create a subfunction devlink port. Driver then instantiates the
+subfunction port and any associated objects such as health reporters and
+representor netdevice.
+
+(2) Configure
+-------------
+Subfunction devlink port is created but it is not active yet. That means the
+entities are created on devlink side, the e-switch port representor is created,
+but the subfunction device itself it not created. User might use e-switch port
+representor to do settings, putting it into bridge, adding TC rules, etc. User
+might as well configure the hardware address (such as MAC address) of the
+subfunction while subfunction is inactive.
+
+(3) Deploy
+----------
+Once subfunction is configured, user must activate it to use it. Upon
+activation, subfunction management driver asks the subfunction management
+device to instantiate the actual subfunction device on particular PCI function.
+A subfunction device is created on the :ref:`Documentation/driver-api/auxiliary_bus.rst <auxiliary_bus>`. At this point matching
+subfunction driver binds to the subfunction's auxiliary device.
+
+Terms and Definitions
+=====================
+
+.. list-table:: Terms and Definitions
+   :widths: 22 90
+
+   * - Term
+     - Definitions
+   * - ``PCI device``
+     - A physical PCI device having one or more PCI bus consists of one or
+       more PCI controllers.
+   * - ``PCI controller``
+     -  A controller consists of potentially multiple physical functions,
+        virtual functions and subfunctions.
+   * - ``Port function``
+     -  An object to manage the function of a port.
+   * - ``Subfunction``
+     -  A lightweight function that has parent PCI function on which it is
+        deployed.
+   * - ``Subfunction device``
+     -  A bus device of the subfunction, usually on a auxiliary bus.
+   * - ``Subfunction driver``
+     -  A device driver for the subfunction auxiliary device.
+   * - ``Subfunction management device``
+     -  A PCI physical function that supports subfunction management.
+   * - ``Subfunction management driver``
+     -  A device driver for PCI physical function that supports
+        subfunction management using devlink port interface.
+   * - ``Subfunction host driver``
+     -  A device driver for PCI physical function that host subfunction
+        devices. In most cases it is same as subfunction management driver. When
+        subfunction is used on external controller, subfunction management and
+        host drivers are different.
-- 
2.26.2

