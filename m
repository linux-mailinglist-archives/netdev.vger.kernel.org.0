Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE3424638C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHQJjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:39:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55865 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728467AbgHQJiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:38:18 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 17 Aug 2020 12:38:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07H9cEeu011441;
        Mon, 17 Aug 2020 12:38:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07H9cEQ4003256;
        Mon, 17 Aug 2020 12:38:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07H9cEGf003251;
        Mon, 17 Aug 2020 12:38:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v2 13/13] devlink: Add Documentation/networking/devlink/devlink-reload.rst
Date:   Mon, 17 Aug 2020 12:37:52 +0300
Message-Id: <1597657072-3130-14-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink reload rst documentation file.
Update index file to include it.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
- Instead of reload levels driver,fw_reset,fw_live_patch have reload
  actions driver_reinit,fw_activate,fw_live_patch
---
 .../networking/devlink/devlink-reload.rst     | 54 +++++++++++++++++++
 Documentation/networking/devlink/index.rst    |  1 +
 2 files changed, 55 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst

diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
new file mode 100644
index 000000000000..9846ea727f3b
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-reload.rst
@@ -0,0 +1,54 @@
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
+=============
+
+User may select a reload action.
+By default ``driver_reinit`` action is done.
+
+.. list-table:: Possible reload actions
+   :widths: 5 90
+
+   * - Name
+     - Description
+   * - ``driver-reinit``
+     - Driver entities re-initialization, including applying
+       new values to devlink entities which are used during driver
+       load such as ``devlink-params`` in configuration mode
+       ``driverinit`` or ``devlink-resources``
+   * - ``fw_activate``
+     - Firmware activate. Can be used for firmware reload or firmware
+       upgrade if new firmware is stored and driver supports such
+       firmware upgrade.
+   * - ``fw_live_patch``
+     - Firmware live patch, applies firmware changes without reset.
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
+    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { fw_live_patch | driver_reinit | fw_activate } ]
+
+    # Run reload command for devlink driver entities re-initialization:
+    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
+
+    # Run reload command to activate firmware:
+    $ devlink dev reload pci/0000:82:00.0 action fw_activate
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

