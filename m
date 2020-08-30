Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05958256F07
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 17:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgH3P2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 11:28:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42780 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726814AbgH3P2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 11:28:01 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 30 Aug 2020 18:27:57 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07UFRvvG029680;
        Sun, 30 Aug 2020 18:27:57 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07UFRv05027857;
        Sun, 30 Aug 2020 18:27:57 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07UFRvd1027856;
        Sun, 30 Aug 2020 18:27:57 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v3 14/14] devlink: Add Documentation/networking/devlink/devlink-reload.rst
Date:   Sun, 30 Aug 2020 18:27:34 +0300
Message-Id: <1598801254-27764-15-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink reload rst documentation file.
Update index file to include it.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v2 -> v3:
- Devlink reload returns the actions done
- Replace fw_live_patch action by fw_activate_no_reset
- Explain fw_activate meaning
v1 -> v2:
- Instead of reload levels driver,fw_reset,fw_live_patch have reload
  actions driver_reinit,fw_activate,fw_live_patch
---
 .../networking/devlink/devlink-reload.rst     | 68 +++++++++++++++++++
 Documentation/networking/devlink/index.rst    |  1 +
 2 files changed, 69 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst

diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
new file mode 100644
index 000000000000..44a18692bddd
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-reload.rst
@@ -0,0 +1,68 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Reload
+==============
+
+``devlink-reload`` provides mechanism to either reload driver entities,
+applying ``devlink-params`` and ``devlink-resources`` new values or firmware
+activation depends on reload action selected.
+
+Reload actions
+==============
+
+User may select a reload action.
+By default ``driver_reinit`` action is done.
+
+.. list-table:: Possible reload levels
+   :widths: 5 90
+
+   * - Name
+     - Description
+   * - ``driver-reinit``
+     - Devlink driver entities re-initialization, including applying
+       new values to devlink entities which are used during driver
+       load such as ``devlink-params`` in configuration mode
+       ``driverinit`` or ``devlink-resources``
+   * - ``fw_activate``
+     - Firmware activate. Activates new firmware if such image is stored and
+       pending activation. This action involves firmware reset, if no new image
+       pending this action will reload current firmware image.
+   * - ``fw_activate_no_reset``
+     - Activate new firmware image without firmware reset or reload.
+       This action is also known as live patch, applying firmware changes
+       without reset.
+
+Note that when required to do firmware activation some drivers may need
+to reload the driver. On the other hand some drivers may need to reset
+the firmware to reinitialize the driver entities. Therefore, the devlink
+reload command returns the actions which were actually done.
+However, in case fw_activate_no_reset action is selected, then no other
+reload action is allowed.
+
+Change namespace
+================
+
+All devlink instances are created in init_net and stay there for a
+lifetime. Allow user to be able to move devlink instances into
+namespaces during devlink reload operation. That ensures proper
+re-instantiation of driver objects, including netdevices.
+
+example usage
+-------------
+
+.. code:: shell
+
+    $ devlink dev reload help
+    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate [no_reset] } ]
+
+    # Run reload command for devlink driver entities re-initialization:
+    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
+    reload_actions_done:
+      driver_reinit
+
+    # Run reload command to activate firmware:
+    $ devlink dev reload pci/0000:82:00.0 action fw_activate
+    reload_actions_done:
+      driver_reinit fw_activate
+    # Note that the driver in this example reloads the driver while activating firmware
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 7684ae5c4a4a..d82874760ae2 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -20,6 +20,7 @@ general.
    devlink-params
    devlink-region
    devlink-resource
+   devlink-reload
    devlink-trap
 
 Driver-specific documentation
-- 
2.17.1

