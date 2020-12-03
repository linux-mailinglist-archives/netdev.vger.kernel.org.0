Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48ABA2CDD08
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgLCSD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:03:56 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11179 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgLCSD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:03:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc928630000>; Thu, 03 Dec 2020 10:03:15 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 18:03:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jacob.e.keller@intel.com>, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v4] devlink: Add devlink port documentation
Date:   Thu, 3 Dec 2020 20:02:55 +0200
Message-ID: <20201203180255.5253-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130164119.571362-1-parav@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607018595; bh=D8kDfSNIqt2xIfVpT5c/+17IyUhgTFlOBb0sx4OkdhA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=W9UeRjA0wke1aVpoj+79zPJjeU2066obX+ynXyDAUdHHLTZD39zzKF0c73TmLCUOp
         QB5mi9jkEMsutjK6qO/qSigsVJ88hrcsidUdfamFFm/8SMcY3ELrOErvzIKiDMnmqS
         Sj7NFJXfHOcwyq8KvRaWxImbEXmRZXKTOLoB/KlIAQWpZDfyAVxVxmRb5/jWprqUgc
         bJaH/MtblivDYSHFG03Z5RSJBS9fscamDxWHpJiUBHaONOg1tJkS3jyDofBgj2qi1g
         bID+B/WA3yvxDZo8+rc6n8l0XWUd8Se5weNFPE5wv4DIFi4FXFzzmP+q+j0fBTGslK
         9vUVJqlLPmpTw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added documentation for devlink port and port function related commands.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changelog:
v3->v4:
 - changed 'exist' to 'exists'
 - added 'an' eswitch
 - changed 'can have one' to 'consists of'
 - changed 'who intents' to 'that intends'
 - removed unnecessary comma
 - rewrote description for the example diagram
 - changed 'controller consist of' to 'controller consists of'
v2->v3:
 - rephrased many lines
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
index 000000000000..ac18cb8041dc
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -0,0 +1,111 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Devlink Port
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+``devlink-port`` is a port that exists on the device. A devlink port can
+be of one among many flavours. A devlink port flavour along with port
+attributes describe what a port represents.
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
+     - Any kind of physical networking port. This can be an eswitch physic=
al
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
+Devlink port types are described below.
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
+A controller consists of one or more PCI functions. Such PCI function cons=
ists
+of one or more networking ports. A networking port of such PCI function is
+represented by the eswitch devlink port. A devlink instance holds ports of=
 two
+types of controllers.
+
+(1) controller discovered on same system where eswitch resides:
+This is the case where PCI PF/VF of a controller and devlink eswitch
+instance both are located on a single system.
+
+(2) controller located on external host system.
+This is the case where a controller is in one system and its devlink
+eswitch ports are in a different system. Such controller is called
+external controller.
+
+An example view of two controller systems::
+
+In this example, external controller (identified by controller number =3D =
1)
+doesn't have eswitch. Local controller (identified by controller number =
=3D 0)
+has the eswitch. Devlink instance on local Controller has eswitch devlink
+ports representing networking ports for both the controllers.
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

