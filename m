Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF10FF50E3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfKHQTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:11 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60328 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727178AbfKHQTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:19:05 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GJ4hT003595;
        Fri, 8 Nov 2019 18:19:05 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GJ3Zh030100;
        Fri, 8 Nov 2019 18:19:03 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GJ3mn030099;
        Fri, 8 Nov 2019 18:19:03 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 06/10] Documentation: Add devlink-subdev documentation.
Date:   Fri,  8 Nov 2019 18:18:42 +0200
Message-Id: <1573229926-30040-7-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink-subdev documentation.

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink-subdev.rst | 125 ++++++++++++++++++++
 1 file changed, 125 insertions(+)
 create mode 100644 Documentation/networking/devlink-subdev.rst

diff --git a/Documentation/networking/devlink-subdev.rst b/Documentation/networking/devlink-subdev.rst
new file mode 100644
index 000000000000..724464111aac
--- /dev/null
+++ b/Documentation/networking/devlink-subdev.rst
@@ -0,0 +1,125 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Subdev
+==============
+
+Introduction
+============
+The network ASIC may expose privileged and non-privileged (subdev) devices.
+A privileged user can control the parameters of the subdev through the
+privileged device.
+
+The network ASIC exposes PCI PF and SR-IOV VF device(s) to the host system
+where it is connected as PCIe end point. An administrator needs to manage
+attributes and resource of such PCI PF/VF such as MAC address, MSI-X vectors
+etc. in the ASIC.
+
+An administrator doesn't have access to the host system where the PCIe ASIC
+device is connected. In some use cases host system may not even be running Linux
+kernel where the PCIe PF and VF devices are enumerated.
+Currently, the networking ASIC exposes devlink interfaces for eswitch
+mamangement. However, there is no user interface to manage attributes and
+resources on the ASIC device.
+
+Additionally, the PCIe PF and VF devices may be of a different class
+than networking; such as NVMe, GPU, crypto or something else.
+For non-networking devices, there may not be any eswitch (eswitch ports).
+
+It is desirable to control common PCIe attributes and resources through
+common kernel infrastructure. Some of the attributes or resources may not be a
+port parameter, i.e. number of IRQ (MSI-X) vectors per PF/VF.
+
+An example system view of a networking ASIC (aka SmartNIC), can be seen in the
+below diagram, where devlink eswitch instance and PCI PF and/or VFs are
+situated on two different CPU subsystems::
+
+
+	  +------------------------------+
+	  |                              |
+	  |             HOST             |
+	  |                              |
+	  |   +----+-----+-----+-----+   |
+	  |   | PF | VF0 | VF1 | VF2 |   |
+	  +---+----+-----------+-----+---+
+        	     PCI1|
+	      +---+------------+
+        	  |
+	 +----------------------------------------+
+	 |        |         SmartNic              |
+	 |   +----+-------------------------+     |
+	 |   |                              |     |
+	 |   |               NIC            |     |
+	 |   |                              |     |
+	 |   +---------------------+--------+     |
+	 |                         |  PCI2        |
+	 |         +-----+---------+--+           |
+	 |               |                        |
+	 |      +-----+--+--+--------------+      |
+	 |      |     | PF  |              |      |
+	 |      |     +-----+              |      |
+	 |      |      Embedded CPU        |      |
+	 |      |                          |      |
+	 |      +--------------------------+      |
+	 |                                        |
+	 +----------------------------------------+
+
+The below diagram shows an example of devlink subdev topology where some
+subdevs are connected to devlink ports::
+
+
+
+            (PF0)    (VF0)    (VF1)           (NVME VF2)
+         +--------------------------+         +--------+
+         | devlink| devlink| devlink|         | devlink|
+         | subdev | subdev | subdev |         | subdev |
+         |    0   |    1   |    2   |         |    3   |
+         +--------------------------+         +--------+
+              |        |        |
+              |        |        |
+              |        |        |
+     +----------------------------------+
+     |   | devlink| devlink| devlink|   |
+     |   |  port  |  port  |  port  |   |
+     |   |    0   |    1   |    2   |   |
+     |   +--------------------------+   |
+     |                                  |
+     |                                  |
+     |           E-switch               |
+     |                                  |
+     |                                  |
+     |          +--------+              |
+     |          | uplink |              |
+     |          | devlink|              |
+     |          |  port  |              |
+     +----------------------------------+
+
+
+.. _Subdev-Flavours:
+
+Subdev flavours
+===============
+
+The ``devlink-subdev`` supports the following device flavours:
+
+  * ``pcipf``: exposes pf_index attribute.
+  * ``pcivf``: exposes vf_index and pf_index.
+
+.. _Subdev-Actions:
+
+Network attributes:
+==================
+
+The ``devlink-subdev`` may represent a network device and expose the following
+attributes:
+
+  * ``hw_addr``: The HW addr of the network device.
+  * ``port_index``: The ``devlink-port`` index associated with the device.
+
+Testing
+=======
+
+See ``tools/testing/selftests/drivers/net/netdevsim/devlink.sh`` for a
+test covering the core infrastructure. Test cases should be added for any new
+functionality.
+
-- 
2.17.1

