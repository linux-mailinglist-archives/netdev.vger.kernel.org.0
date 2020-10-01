Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF02800AB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732539AbgJAOAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:00:37 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36685 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732472AbgJAOAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:30 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:27 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0RxA002378;
        Thu, 1 Oct 2020 17:00:27 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0QHB011192;
        Thu, 1 Oct 2020 17:00:26 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0QPk011191;
        Thu, 1 Oct 2020 17:00:26 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 16/16] devlink: Add Documentation/networking/devlink/devlink-reload.rst
Date:   Thu,  1 Oct 2020 16:59:19 +0300
Message-Id: <1601560759-11030-17-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink reload rst documentation file.
Update index file to include it.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
RFCv5 -> v1:
- Rename reload_action_limit_level to reload_limit
RFCv4 -> RFCv5:
- Rephrase namespace chnage section
- Rephrase note on actions performed
RFCv3 -> RFCv4:
- Remove reload action fw_activate_no_reset
- Add reload actions limit levels and document the no_reset limit level
  constrains
RFCv2 -> RFCv3:
- Devlink reload returns the actions done
- Replace fw_live_patch action by fw_activate_no_reset
- Explain fw_activate meaning
RFCv1 -> RFCv2:
- Instead of reload levels driver,fw_reset,fw_live_patch have reload
  actions driver_reinit,fw_activate,fw_live_patch
---
 .../networking/devlink/devlink-reload.rst     | 81 +++++++++++++++++++
 Documentation/networking/devlink/index.rst    |  1 +
 2 files changed, 82 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst

diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
new file mode 100644
index 000000000000..5abc5c2c75fd
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-reload.rst
@@ -0,0 +1,81 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Reload
+==============
+
+``devlink-reload`` provides mechanism to either reinit driver entities,
+applying ``devlink-params`` and ``devlink-resources`` new values or firmware
+activation depends on reload action selected.
+
+Reload actions
+==============
+
+User may select a reload action.
+By default ``driver_reinit`` action is selected.
+
+.. list-table:: Possible reload actions
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
+       pending activation. If no limitation specified this action may involve
+       firmware reset. If no new image pending this action will reload current
+       firmware image.
+
+Note that even though user asks for a specific action, the driver
+implementation might require to perform another action alongside with
+it. For example, some driver do not support driver reinitialization
+being performed without fw activation. Therefore, the devlink reload
+command returns the list of actions which were actrually performed.
+
+Reload limits
+=============
+
+By default reload actions are not limited and driver implementation may
+include reset or downtime as needed to perform the actions.
+
+However, some drivers support action limits, which limit the action
+implementation to specific constrains.
+
+.. list-table:: Possible reload limits
+   :widths: 5 90
+
+   * - Name
+     - Description
+   * - ``no_reset``
+     - No reset allowed, no down time allowed, no link flap and no
+       configuration is lost.
+
+Change namespace
+================
+
+The netns option allow user to be able to move devlink instances into
+namespaces during devlink reload operation.
+By default all devlink instances are created in init_net and stay there.
+
+example usage
+-------------
+
+.. code:: shell
+
+    $ devlink dev reload help
+    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate } ] [ limit no_reset ]
+
+    # Run reload command for devlink driver entities re-initialization:
+    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
+    reload_actions_performed:
+      driver_reinit
+
+    # Run reload command to activate firmware:
+    # Note that mlx5 driver reloads the driver while activating firmware
+    $ devlink dev reload pci/0000:82:00.0 action fw_activate
+    reload_actions_performed:
+      driver_reinit fw_activate
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
2.18.2

