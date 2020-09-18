Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5EF2701D3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgIRQPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:15:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55250 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726384AbgIRQN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:13:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 18 Sep 2020 19:07:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08IG7BiF025159;
        Fri, 18 Sep 2020 19:07:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08IG7BUB031169;
        Fri, 18 Sep 2020 19:07:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08IG7Bje031168;
        Fri, 18 Sep 2020 19:07:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v5 11/15] devlink: Add enable_remote_dev_reset generic parameter
Date:   Fri, 18 Sep 2020 19:06:47 +0300
Message-Id: <1600445211-31078-12-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enable_remote_dev_reset devlink param flags that the host admin
allows device resets that can be initiated by other hosts. This
parameter is useful for setups where a device is shared by different
hosts, such as multi-host setup. Once the user set this parameter to
false, the driver should NACK any attempt to reset the device while the
driver is loaded.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index d075fd090b3d..54c9f107c4b0 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -108,3 +108,9 @@ own name.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
+   * - ``enable_remote_dev_reset``
+     - Boolean
+     - Enable device reset by remote host. When cleared, the device driver
+       will NACK any attempt of other host to reset the device. This parameter
+       is useful for setups where a device is shared by different hosts, such
+       as multi-host setup.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f09f55a47d09..8ab5ac5c365f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -445,6 +445,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_REMOTE_DEV_RESET,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -482,6 +483,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
 #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_NAME "enable_remote_dev_reset"
+#define DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 71aeda259e6a..565fa786d01f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3458,6 +3458,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_REMOTE_DEV_RESET,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.17.1

