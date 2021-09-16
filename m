Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4097A40D78D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 12:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhIPKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 06:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235570AbhIPKj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 06:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE7146120F;
        Thu, 16 Sep 2021 10:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631788718;
        bh=8eNapddlcaRrVxc1VNMRrvE1AbLm5qHmft+xwzIJ8Wg=;
        h=From:To:Cc:Subject:Date:From;
        b=fG5Yu+DZzZ44XJNJbKPVQn+Nk4MzW8ZC67RWUkLCK+z/Ld5hM87Pn5QPOsMcPWzYh
         dme45GIo4hhYPX66yeR5TL+c207AR5Rh4qOVvk2iYhrjttJhQ5esu8YDzaKgex9TDJ
         e1G+qtxFLknnW/bMBSIQ/qlweYkY6rsOBYrQbkxhvGebACsWcZ6kX1vw1+uqBfx2O5
         Qe0XY5gMOMNFfVrpCpyZtr3DJr+shtj/wqHIIJ7A3XGaTS5H3OcOiBHqI96l4Zc5QO
         trKBH951xQM9BLc6A28PgnuvG7PUeSrlQ25NR2djFI0SGZPVsqxCLq3xOL/7VUpmck
         ly0QQdZ+NDuvg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] devlink: Delete not-used devlink APIs
Date:   Thu, 16 Sep 2021 13:38:33 +0300
Message-Id: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink core exported generously the functions calls that were used
by netdevsim tests or not used at all.

Delete such APIs with one exception - devlink_alloc_ns(). That function
should be spared from deleting because it is a special form of devlink_alloc()
needed for the netdevsim.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/netdevsim/health.c |  32 -----------
 include/net/devlink.h          |  14 -----
 net/core/devlink.c             | 102 +--------------------------------
 3 files changed, 3 insertions(+), 145 deletions(-)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 04aebdf85747..aa77af4a68df 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -110,26 +110,6 @@ static int nsim_dev_dummy_fmsg_put(struct devlink_fmsg *fmsg, u32 binary_len)
 	if (err)
 		return err;
 
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_bool_array");
-	if (err)
-		return err;
-	for (i = 0; i < 10; i++) {
-		err = devlink_fmsg_bool_put(fmsg, true);
-		if (err)
-			return err;
-	}
-	err = devlink_fmsg_arr_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_u8_array");
-	if (err)
-		return err;
-	for (i = 0; i < 10; i++) {
-		err = devlink_fmsg_u8_put(fmsg, i);
-		if (err)
-			return err;
-	}
 	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
 		return err;
@@ -146,18 +126,6 @@ static int nsim_dev_dummy_fmsg_put(struct devlink_fmsg *fmsg, u32 binary_len)
 	if (err)
 		return err;
 
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_u64_array");
-	if (err)
-		return err;
-	for (i = 0; i < 10; i++) {
-		err = devlink_fmsg_u64_put(fmsg, i);
-		if (err)
-			return err;
-	}
-	err = devlink_fmsg_arr_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
 	err = devlink_fmsg_arr_pair_nest_start(fmsg, "test_array_of_objects");
 	if (err)
 		return err;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index cd89b2dc2354..0e06b3dbbec6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1663,18 +1663,7 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value init_val);
-int
-devlink_port_param_driverinit_value_get(struct devlink_port *devlink_port,
-					u32 param_id,
-					union devlink_param_value *init_val);
-int devlink_port_param_driverinit_value_set(struct devlink_port *devlink_port,
-					    u32 param_id,
-					    union devlink_param_value init_val);
 void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
-void devlink_port_param_value_changed(struct devlink_port *devlink_port,
-				      u32 param_id);
-void devlink_param_value_str_fill(union devlink_param_value *dst_val,
-				  const char *src);
 struct devlink_region *
 devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
@@ -1719,10 +1708,7 @@ int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
 					const char *name);
 int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg);
 
-int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value);
-int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value);
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value);
-int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value);
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value);
 int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
 			    u16 value_len);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f30121f07467..0f1663453ca0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6269,23 +6269,21 @@ static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
 	return 0;
 }
 
-int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
+static int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
 {
 	if (fmsg->putting_binary)
 		return -EINVAL;
 
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
 }
-EXPORT_SYMBOL_GPL(devlink_fmsg_bool_put);
 
-int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
+static int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
 {
 	if (fmsg->putting_binary)
 		return -EINVAL;
 
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
 }
-EXPORT_SYMBOL_GPL(devlink_fmsg_u8_put);
 
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
 {
@@ -6296,14 +6294,13 @@ int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
 
-int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
+static int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
 {
 	if (fmsg->putting_binary)
 		return -EINVAL;
 
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
 }
-EXPORT_SYMBOL_GPL(devlink_fmsg_u64_put);
 
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
 {
@@ -10257,55 +10254,6 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 }
 EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
 
-/**
- *	devlink_port_param_driverinit_value_get - get configuration parameter
- *						value for driver initializing
- *
- *	@devlink_port: devlink_port
- *	@param_id: parameter ID
- *	@init_val: value of parameter in driverinit configuration mode
- *
- *	This function should be used by the driver to get driverinit
- *	configuration for initialization after reload command.
- */
-int devlink_port_param_driverinit_value_get(struct devlink_port *devlink_port,
-					    u32 param_id,
-					    union devlink_param_value *init_val)
-{
-	struct devlink *devlink = devlink_port->devlink;
-
-	if (!devlink_reload_supported(devlink->ops))
-		return -EOPNOTSUPP;
-
-	return __devlink_param_driverinit_value_get(&devlink_port->param_list,
-						    param_id, init_val);
-}
-EXPORT_SYMBOL_GPL(devlink_port_param_driverinit_value_get);
-
-/**
- *     devlink_port_param_driverinit_value_set - set value of configuration
- *                                               parameter for driverinit
- *                                               configuration mode
- *
- *     @devlink_port: devlink_port
- *     @param_id: parameter ID
- *     @init_val: value of parameter to set for driverinit configuration mode
- *
- *     This function should be used by the driver to set driverinit
- *     configuration mode default value.
- */
-int devlink_port_param_driverinit_value_set(struct devlink_port *devlink_port,
-					    u32 param_id,
-					    union devlink_param_value init_val)
-{
-	return __devlink_param_driverinit_value_set(devlink_port->devlink,
-						    devlink_port->index,
-						    &devlink_port->param_list,
-						    param_id, init_val,
-						    DEVLINK_CMD_PORT_PARAM_NEW);
-}
-EXPORT_SYMBOL_GPL(devlink_port_param_driverinit_value_set);
-
 /**
  *	devlink_param_value_changed - notify devlink on a parameter's value
  *				      change. Should be called by the driver
@@ -10329,50 +10277,6 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
 }
 EXPORT_SYMBOL_GPL(devlink_param_value_changed);
 
-/**
- *     devlink_port_param_value_changed - notify devlink on a parameter's value
- *                                      change. Should be called by the driver
- *                                      right after the change.
- *
- *     @devlink_port: devlink_port
- *     @param_id: parameter ID
- *
- *     This function should be used by the driver to notify devlink on value
- *     change, excluding driverinit configuration mode.
- *     For driverinit configuration mode driver should use the function
- *     devlink_port_param_driverinit_value_set() instead.
- */
-void devlink_port_param_value_changed(struct devlink_port *devlink_port,
-				      u32 param_id)
-{
-	struct devlink_param_item *param_item;
-
-	param_item = devlink_param_find_by_id(&devlink_port->param_list,
-					      param_id);
-	WARN_ON(!param_item);
-
-	devlink_param_notify(devlink_port->devlink, devlink_port->index,
-			     param_item, DEVLINK_CMD_PORT_PARAM_NEW);
-}
-EXPORT_SYMBOL_GPL(devlink_port_param_value_changed);
-
-/**
- *	devlink_param_value_str_fill - Safely fill-up the string preventing
- *				       from overflow of the preallocated buffer
- *
- *	@dst_val: destination devlink_param_value
- *	@src: source buffer
- */
-void devlink_param_value_str_fill(union devlink_param_value *dst_val,
-				  const char *src)
-{
-	size_t len;
-
-	len = strlcpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
-	WARN_ON(len >= __DEVLINK_PARAM_MAX_STRING_VALUE);
-}
-EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
-
 /**
  *	devlink_region_create - create a new address region
  *
-- 
2.31.1

