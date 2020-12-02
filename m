Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1A92CBEC7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgLBNyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:54:50 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6658 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgLBNyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:54:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc79c820000>; Wed, 02 Dec 2020 05:54:10 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 13:54:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jacob.e.keller@intel.com>, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v3] devlink: Add devlink port documentation
Date:   Wed, 2 Dec 2020 15:53:37 +0200
Message-ID: <20201202135337.937538-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130164119.571362-1-parav@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606917250; bh=mH4/woGc7xUG6NfGQD0lcSoKQbNcb4QIknP10bICu+A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=NEtqRG4QPhuhl8oZ3PwWnwSahAE8s5rtsQgxWFWPUi7HURP3itd5WeZs+ordLlJVy
         XK4fWcJKlP03eHS/F09vJeaZ1Lh3x+e0zViGC/yYetu7o8gwOa51/pZioguJ52C3G/
         y6rsM31WkSKaEmZZXh1jZQi+2d5dORt6HBUggH31A+H2DYNaHFyiGxWQCnGPcboAFz
         ah+RiuMHgzjZX6ubcJav/BURzJFZWjXwBiVloBsFfuKYZS2zu+kd+k6Eb+Z1FV2hNV
         7UEmjvYCWFcTrm8xPs6afUZwjD43V5ccng226I/tDUpy+MfhBKIuRzCqcr05YFeBk1
         IHbG2+4aK74bg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added documentation for devlink port and port function related commands.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changelog:
v2->v3:
 - rephased many lines
 - first paragraph now describe devlink port
 - instead of saying PCI device/function, using PCI function every
   where
 - changed 'physical link layer' to 'link layer'
 - made devlink port type description more clear
 - made devlink port flavour description more clear
 - moved devlink port type table after port flavour
 - added description for the example diagram
 - describe CPU port that its linked to DSA
 - made devlink port description for eswitch port more clear
v1->v2:
 - Removed duplicate table entries for DEVLINK_PORT_FLAVOUR_VIRTUAL.
 - replaced 'consist of' to 'consisting'
 - changed 'can be' to 'can be of'
---
 .../networking/devlink/devlink-port.rst       | 111 ++++++++++++++++++
 Documentation/networking/devlink/index.rst    |   1 +
 2 files changed, 112 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-port.rst

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentat=
ion/networking/devlink/devlink-port.rst
new file mode 100644
index 000000000000..8407bbe9ce88
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -0,0 +1,111 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Devlink Port
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+``devlink-port`` is a port that exist on the device. A devlink port can
+be of one among many flavours. A devlink port flavour along with port
+attributes describe what a port represents.
+
+A device driver who intents to publish a devlink port, sets the
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
+     - Any kind of physical networking port. This can be a eswitch physica=
l
+       port or any other physical port on the device.
+   * - ``DEVLINK_PORT_FLAVOUR_DSA``
+     - This indicates a DSA interconnect port.
+   * - ``DEVLINK_PORT_FLAVOUR_CPU``
+     - This indicates a CPU port applicable only to DSA.
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
+     - This indicates an eswitch port representing a networking port of
+       PCI physical function (PF).
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
+     - This indicates an eswitch port representing a networking port of
+       PCI virtual function (VF).
+   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
+     - This indicates a virtual port for the virtual PCI device such as PC=
I VF.
+
+A devlink port types are described below.
+
+.. list-table:: List of devlink port types
+   :widths: 23 90
+
+   * - Type
+     - Description
+   * - ``DEVLINK_PORT_TYPE_ETH``
+     - Driver should set this port type when a link layer of the port is E=
thernet.
+   * - ``DEVLINK_PORT_TYPE_IB``
+     - Driver should set this port type when a link layer of the port is I=
nfiniBand.
+   * - ``DEVLINK_PORT_TYPE_AUTO``
+     - This type is indicated by the user when user prefers to set the por=
t type
+       to be automatically detected by the device driver.
+
+A controller consist of one or more PCI functions. Such PCI function can h=
ave one
+or more networking ports. A networking port of such PCI function is repres=
ented
+by the eswitch devlink port. A devlink instance holds ports of two types o=
f
+controllers.
+
+(1) controller discovered on same system where eswitch resides:
+This is the case where PCI PF/VF of a controller and devlink eswitch
+instance both are located on a single system.
+
+(2) controller located on external host system.
+This is the case where a controller is located in one system and its
+devlink eswitch ports are located in a different system. Such controller
+is called external controller.
+
+An example view of two controller systems::
+
+In this example a controller which contains the eswitch is local controlle=
r
+with controller number =3D 0. The second is a external controller having
+controller number =3D 1. Eswitch devlink instance has representor devlink
+ports for the PCI functions of both the controllers.
+
+                 ---------------------------------------------------------
+                 |                                                       |
+                 |           --------- ---------         ------- ------- |
+    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
+    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
+    | pci rc  |=3D=3D=3D | pf0 |______/________/       | pf1 |___/_______/=
     |
+    | connect |  | -------                       -------                 |
+    -----------  |     | controller_num=3D1 (no eswitch)                  =
 |
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
+                 |           --------- ---------         ------- ------- |
+                 |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
+                 | -------   ----/---- ---/----- ------- ---/--- ---/--- |
+                 | | pf0 |______/________/       | pf1 |___/_______/     |
+                 | -------                       -------                 |
+                 |                                                       |
+                 |  local controller_num=3D0 (eswitch)                    =
 |
+                 ---------------------------------------------------------
+
+Port function configuration
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
+``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the networking port of a
+PCI function. A user can configure the port function attributes before
+enumerating the function. For example user may set the hardware address of
+the function represented by the devlink port function.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/net=
working/devlink/index.rst
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
--=20
2.26.2

