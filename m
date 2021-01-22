Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3E30107E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbhAVW74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbhAVTkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 14:40:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37BC023B04;
        Fri, 22 Jan 2021 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611344235;
        bh=mzbkx4nxlpJy3TS+rp4LjZaF+nfej0USFd0t/5xR6g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImBNKnYwRpbqDucPS2fGMBDhRdceHcjDrfUwvTNG4/zXmiOJuY2aOXS4p6VwCXVHN
         WjYjFVfQxaTN9EhTguaFxus4aB6GXvkOsHfG33LEMb4zKKHst9gh+rO3tSndfua3qm
         oS2pUGswGUL7a/UBoA8H7faXLwkG6EvEIq7oc6IuIdBggmXVZD3ZjmG4JGkSngTrVt
         3yPECH5UT296RIX/nW/hF+2Z3d4C8AN/Eum9qp0YY5fbQZ/mhghnBuwCyilOlRttZV
         Oj8919SNrjP6wVnnB4Mq6JVTmACtxVnHUR3mU5yb+OiGy6tUzc1AV9wmF59iYmxJXP
         k67Rks+F6uXlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V10 13/14] devlink: Extend devlink port documentation for subfunctions
Date:   Fri, 22 Jan 2021 11:36:57 -0800
Message-Id: <20210122193658.282884-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122193658.282884-1-saeed@kernel.org>
References: <20210122193658.282884-1-saeed@kernel.org>
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
 .../networking/devlink/devlink-port.rst       | 87 ++++++++++++++++++-
 2 files changed, 86 insertions(+), 3 deletions(-)

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
index c564b557e757..e99b41599465 100644
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
 
@@ -57,8 +60,9 @@ Devlink port can have a different type based on the link layer described below.
 PCI controllers
 ---------------
 In most cases a PCI device has only one controller. A controller consists of
-potentially multiple physical and virtual functions. A function consists
-of one or more ports. This port is represented by the devlink eswitch port.
+potentially multiple physical, virtual functions and subfunctions. A function
+consists of one or more ports. This port is represented by the devlink eswitch
+port.
 
 A PCI device connected to multiple CPUs or multiple PCI root complexes or a
 SmartNIC, however, may have multiple controllers. For a device with multiple
@@ -111,8 +115,85 @@ function. Usually it means, user should configure function attribute
 before a bus specific device for the function is created. However, when
 SRIOV is enabled, virtual function devices are created on the PCI bus.
 Hence, function attribute should be configured before binding virtual
-function device to the driver.
+function device to the driver. For subfunctions, this means user should
+configure port function attribute before activating the port function.
 
 A user may set the hardware address of the function using
 'devlink port function set hw_addr' command. For Ethernet port function
 this means a MAC address.
+
+Subfunction
+============
+
+Subfunction is a lightweight function that has a parent PCI function on which
+it is deployed. Subfunction is created and deployed in unit of 1. Unlike
+SRIOV VFs, a subfunction doesn't require its own PCI virtual function.
+A subfunction communicates with the hardware through the parent PCI function.
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
+A subfunction is created using a devlink port interface. A user adds the
+subfunction by adding a devlink port of subfunction flavour. The devlink
+kernel code calls down to subfunction management driver (devlink ops) and asks
+it to create a subfunction devlink port. Driver then instantiates the
+subfunction port and any associated objects such as health reporters and
+representor netdevice.
+
+(2) Configure
+-------------
+A subfunction devlink port is created but it is not active yet. That means the
+entities are created on devlink side, the e-switch port representor is created,
+but the subfunction device itself it not created. A user might use e-switch port
+representor to do settings, putting it into bridge, adding TC rules, etc. A user
+might as well configure the hardware address (such as MAC address) of the
+subfunction while subfunction is inactive.
+
+(3) Deploy
+----------
+Once a subfunction is configured, user must activate it to use it. Upon
+activation, subfunction management driver asks the subfunction management
+device to instantiate the subfunction device on particular PCI function.
+A subfunction device is created on the :ref:`Documentation/driver-api/auxiliary_bus.rst <auxiliary_bus>`.
+At this point a matching subfunction driver binds to the subfunction's auxiliary device.
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
+     -  A device driver for PCI physical function that hosts subfunction
+        devices. In most cases it is same as subfunction management driver. When
+        subfunction is used on external controller, subfunction management and
+        host drivers are different.
-- 
2.26.2

