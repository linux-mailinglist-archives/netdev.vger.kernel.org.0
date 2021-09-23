Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E897E4164EE
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242790AbhIWSOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242752AbhIWSOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4FE61241;
        Thu, 23 Sep 2021 18:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632420789;
        bh=hhGo+2kBrCwffbr0G/1kKyCktxsPkO5rYb4FUUgdUp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oy1rxmMV33ee4OBVTxYvez+g0iyaEVjoxxgkMYmqShbH1Yg6AJbh+rpPJ4tsG7xSm
         VaV/c7vi19v4xaesDvpYOtdstlr5lLncmKD2qLVsEFhrVQ862TN5jgKG+XAhjCsOPX
         Z8hj4I9DNjbqYIcU1P/vscwF+5aav4RoieYN/kQrSqXOE45i8d8xObnS2MrS54H0K3
         i3UCA9ztlOsDXACvak1skahIGft6DaeKxcQpGWt67uNZmO8wB3RqRfpk/IZ064zPqa
         9O6p9BjEfVa5+AqV+JVKJXgnYVUYUmHCZeWiMyhXXC4A03FRNGTzGyCl5K4qlDI2AL
         POAzrYuGIqQwg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 4/6] devlink: Remove single line function obfuscations
Date:   Thu, 23 Sep 2021 21:12:51 +0300
Message-Id: <a56f5eece50f146ea170571a9dde24079522937f.1632420431.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
References: <cover.1632420430.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in extra one line functions to call relevant
functions only once.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 89 ++++++++++++++++++----------------------------
 1 file changed, 34 insertions(+), 55 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9c071f4e609f..3ea33c689790 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10117,13 +10117,26 @@ void devlink_params_unpublish(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_params_unpublish);
 
-static int
-__devlink_param_driverinit_value_get(struct list_head *param_list, u32 param_id,
-				     union devlink_param_value *init_val)
+/**
+ *	devlink_param_driverinit_value_get - get configuration parameter
+ *					     value for driver initializing
+ *
+ *	@devlink: devlink
+ *	@param_id: parameter ID
+ *	@init_val: value of parameter in driverinit configuration mode
+ *
+ *	This function should be used by the driver to get driverinit
+ *	configuration for initialization after reload command.
+ */
+int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
+				       union devlink_param_value *init_val)
 {
 	struct devlink_param_item *param_item;
 
-	param_item = devlink_param_find_by_id(param_list, param_id);
+	if (!devlink_reload_supported(devlink->ops))
+		return -EOPNOTSUPP;
+
+	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
 	if (!param_item)
 		return -EINVAL;
 
@@ -10139,17 +10152,26 @@ __devlink_param_driverinit_value_get(struct list_head *param_list, u32 param_id,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_get);
 
-static int
-__devlink_param_driverinit_value_set(struct devlink *devlink,
-				     unsigned int port_index,
-				     struct list_head *param_list, u32 param_id,
-				     union devlink_param_value init_val,
-				     enum devlink_command cmd)
+/**
+ *	devlink_param_driverinit_value_set - set value of configuration
+ *					     parameter for driverinit
+ *					     configuration mode
+ *
+ *	@devlink: devlink
+ *	@param_id: parameter ID
+ *	@init_val: value of parameter to set for driverinit configuration mode
+ *
+ *	This function should be used by the driver to set driverinit
+ *	configuration mode default value.
+ */
+int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
+				       union devlink_param_value init_val)
 {
 	struct devlink_param_item *param_item;
 
-	param_item = devlink_param_find_by_id(param_list, param_id);
+	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
 	if (!param_item)
 		return -EINVAL;
 
@@ -10163,52 +10185,9 @@ __devlink_param_driverinit_value_set(struct devlink *devlink,
 		param_item->driverinit_value = init_val;
 	param_item->driverinit_value_valid = true;
 
-	devlink_param_notify(devlink, port_index, param_item, cmd);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 	return 0;
 }
-
-/**
- *	devlink_param_driverinit_value_get - get configuration parameter
- *					     value for driver initializing
- *
- *	@devlink: devlink
- *	@param_id: parameter ID
- *	@init_val: value of parameter in driverinit configuration mode
- *
- *	This function should be used by the driver to get driverinit
- *	configuration for initialization after reload command.
- */
-int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
-				       union devlink_param_value *init_val)
-{
-	if (!devlink_reload_supported(devlink->ops))
-		return -EOPNOTSUPP;
-
-	return __devlink_param_driverinit_value_get(&devlink->param_list,
-						    param_id, init_val);
-}
-EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_get);
-
-/**
- *	devlink_param_driverinit_value_set - set value of configuration
- *					     parameter for driverinit
- *					     configuration mode
- *
- *	@devlink: devlink
- *	@param_id: parameter ID
- *	@init_val: value of parameter to set for driverinit configuration mode
- *
- *	This function should be used by the driver to set driverinit
- *	configuration mode default value.
- */
-int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
-				       union devlink_param_value init_val)
-{
-	return __devlink_param_driverinit_value_set(devlink, 0,
-						    &devlink->param_list,
-						    param_id, init_val,
-						    DEVLINK_CMD_PARAM_NEW);
-}
 EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
 
 /**
-- 
2.31.1

