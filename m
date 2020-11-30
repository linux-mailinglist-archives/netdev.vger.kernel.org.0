Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C17E2C89CA
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgK3QmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:42:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16618 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgK3QmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:42:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc520cc0000>; Mon, 30 Nov 2020 08:41:48 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Nov
 2020 16:41:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next] devlink: Add devlink port documentation
Date:   Mon, 30 Nov 2020 18:41:19 +0200
Message-ID: <20201130164119.571362-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606754508; bh=CdqsQLCkKYKSUYCcL+zEYESLx2DeBP4R80mY1PA0qls=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=NVFL9BevclG9vvbsTuG5KqJtp2+7yIgvrlabORDGjMmlvUouSwguwZo0eBFujLxo6
         GUed0pObX8C34weMryL0QejK3h3tKdJ+u3McPj8XGgYetHu0Tvspk66Q3jzU5ZIB/7
         RLOtCi8ZWEpPqhL39SzYieeXDsLlA5wjNhgRktu379qSunRBUdTDIOLnFqyzEvVOQx
         32FIY5I95iDGfePI9sPrOO7HNmXaRZzv2oqR+PmfX0Q31ffOuyIiroMJKqod3LI3B1
         Lpy91YPDUJjZh7aq37QP2Pz59G4nMz1tuNalvY07BGVnvW7k5lGgP4NjoEn3jgqrwn
         u5XY7aLV5mY4w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added documentation for devlink port and port function related commands.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       | 102 ++++++++++++++++++
 Documentation/networking/devlink/index.rst    |   1 +
 2 files changed, 103 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-port.rst

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentat=
ion/networking/devlink/devlink-port.rst
new file mode 100644
index 000000000000..966d2ee328a6
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -0,0 +1,102 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Devlink Port
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+``devlink-port`` provides capability for a driver to expose various
+flavours of ports which exist on device. A devlink port can of an
+embedded switch (eswitch) present on the device.
+
+A devlink port can be of 3 diffferent types.
+
+.. list-table:: List of devlink port types
+   :widths: 23 90
+
+   * - Type
+     - Description
+   * - ``DEVLINK_PORT_TYPE_ETH``
+     - This type is set for a devlink port when a physical link layer of t=
he port
+       is Ethernet.
+   * - ``DEVLINK_PORT_TYPE_IB``
+     - This type is set for a devlink port when a physical link layer of t=
he port
+       is InfiniBand.
+   * - ``DEVLINK_PORT_TYPE_AUTO``
+     - This type is indicated by the user when user prefers to set the por=
t type
+       to be automatically detected by the device driver.
+
+Devlink port can be of few different flavours described below.
+
+.. list-table:: List of devlink port flavours
+   :widths: 33 90
+
+   * - Flavour
+     - Description
+   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
+     - Any kind of port which is physically facing the user. This can be
+       a eswitch physical port or any other physical port on the device.
+   * - ``DEVLINK_PORT_FLAVOUR_CPU``
+     - This indicates a CPU port.
+   * - ``DEVLINK_PORT_FLAVOUR_DSA``
+     - This indicates a interconnect port in a distributed switch architec=
ture.
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
+     - This indicates an eswitch port representing PCI physical function(P=
F).
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
+     - This indicates an eswitch port representing PCI virtual function(VF=
).
+   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
+     - This indicates a virtual port facing the user.
+   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
+     - This indicates an virtual port facing the user.
+
+A devlink port may be for a controller consist of one or more PCI device(s=
).
+A devlink instance holds ports of two types of controllers.
+
+(1) controller discovered on same system where eswitch resides
+This is the case where PCI PF/VF of a controller and devlink eswitch
+instance both are located on a single system.
+
+(2) controller located on external host system.
+This is the case where a controller is located in one system and its
+devlink eswitch ports are located in a different system.
+
+An example view of two controller systems::
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
+``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the port of a PCI function.
+A user can configure the port function attributes before enumerating the
+function. For example user may set the hardware address of the function
+represented by the devlink port.
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

