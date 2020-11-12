Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEF62B0DF5
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgKLTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:17 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14161 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgKLTYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c090000>; Thu, 12 Nov 2020 11:24:57 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:52 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 06/13] devlink: Introduce devlink refcount to reduce scope of global devlink_mutex
Date:   Thu, 12 Nov 2020 21:24:16 +0200
Message-ID: <20201112192424.2742-7-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112192424.2742-1-parav@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605209098; bh=duM8oXC36aVKHiWOtlUJ0x2Qpxs/rbzwQ5FiUJNUeko=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=F9eSGrW6Z8OaszUNTbldZ87T3/J/ImhHJ0VRlBMNRpT5tg6wQ65GSqQSPxZHim3ow
         S3m5Hbu/XYjGKRsKPkE+ITjfOf6gMK5kcY+YI7VhXrzFEDN3M/qZ+JyJjrqnW3gFpY
         IYPtv7pE54lbZIBSk3xZv8VIidvVQG+qOgmhCUZv5N/SrRhNEtXNFD68/jlGPKG/LS
         Kzec/BzzV32nMZiYUIEA9X3MMN1uaUw7N5ShDWlAmGlFabiwl+SQMTW2Y6Adoo9ljJ
         nWH5CZJDJM+ukaQUZYyniiOOm+f4zSTk2A53urZHpIcNpj4jdl2xL1ADcC9JrRPha6
         qMPukygEERxVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently global devlink_mutex is held while a doit() operation is
progress. This brings a limitation.

A Driver cannot perform devlink_register()/unregister() calls
during devlink doit() callback functions.
This is typically required when a port state change described in
RFC [1] callback wants to delete an active SF port or wants to
activate a SF port that results into unregistering or registering a
devlink instance on different bus such as ancillary bus.

An example flow:

devlink_predoit()
  mutex_lock(&devlink_mutex); <- First lock acquire
  devlink_reload()
    driver->reload_down(inactive)
        adev->remove();
           mlx5_adev_remove(ancillary_dev);
             devlink_unregister(ancillary_dev->devlink_instance);
               mutex_lock(&devlink_mutex); <- Second lock acquire

This patch is preparation patch to enable drivers to achieve this.

It achieves this by maintaining a per devlink instance refcount to
prevent devlink device unregistration while user command are in progress
or while devlink device is migration to init_net net namespace.

devlink_nl_family continue to remain registered with parallel_ops
disabled. So even after removing devlink_mutex during doit commands,
it doesn't enable userspace to run multiple devlink commands for one
or multiple devlink instance.

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  5 +++
 net/core/devlink.c    | 84 +++++++++++++++++++++++++++++++------------
 2 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ef487b8ed17b..c8eab814c234 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -53,6 +53,11 @@ struct devlink {
 			    * port, sb, dpipe, resource, params, region, traps and more.
 			    */
 	struct mutex reload_lock; /* Protects reload operation */
+	struct list_head reload_list;
+	refcount_t refcount; /* Serializes user doit commands and netns command
+			      * with device unregistration.
+			      */
+	struct completion unregister_complete;
 	u8 reload_failed:1,
 	   reload_enabled:1,
 	   registered:1;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c7c6f274d392..84f3ec12b3e8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -96,9 +96,8 @@ static LIST_HEAD(devlink_list);
=20
 /* devlink_mutex
  *
- * An overall lock guarding every operation coming from userspace.
- * It also guards devlink devices list and it is taken when
- * driver registers/unregisters it.
+ * An overall lock guarding devlink devices list during operations coming =
from
+ * userspace and when driver registers/unregisters devlink device.
  */
 static DEFINE_MUTEX(devlink_mutex);
=20
@@ -121,6 +120,18 @@ void devlink_net_set(struct devlink *devlink, struct n=
et *net)
 }
 EXPORT_SYMBOL_GPL(devlink_net_set);
=20
+static inline bool
+devlink_try_get(struct devlink *devlink)
+{
+	return refcount_inc_not_zero(&devlink->refcount);
+}
+
+static void devlink_put(struct devlink *devlink)
+{
+	if (refcount_dec_and_test(&devlink->refcount))
+		complete(&devlink->unregister_complete);
+}
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -139,7 +150,7 @@ static struct devlink *devlink_get_from_attrs(struct ne=
t *net,
 	list_for_each_entry(devlink, &devlink_list, list) {
 		if (strcmp(devlink->dev->bus->name, busname) =3D=3D 0 &&
 		    strcmp(dev_name(devlink->dev), devname) =3D=3D 0 &&
-		    net_eq(devlink_net(devlink), net))
+		    net_eq(devlink_net(devlink), net) && devlink_try_get(devlink))
 			return devlink;
 	}
=20
@@ -411,7 +422,7 @@ devlink_region_snapshot_get_by_id(struct devlink_region=
 *region, u32 id)
=20
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
- * devlink lock is taken and protects from disruption by user-calls.
+ * devlink lock is taken and protects from disruption by dumpit user-calls=
.
  */
 #define DEVLINK_NL_FLAG_NO_LOCK			BIT(2)
=20
@@ -424,10 +435,10 @@ static int devlink_nl_pre_doit(const struct genl_ops =
*ops,
=20
 	mutex_lock(&devlink_mutex);
 	devlink =3D devlink_get_from_info(info);
-	if (IS_ERR(devlink)) {
-		mutex_unlock(&devlink_mutex);
+	mutex_unlock(&devlink_mutex);
+
+	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
-	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_lock(&devlink->lock);
 	info->user_ptr[0] =3D devlink;
@@ -448,7 +459,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *o=
ps,
 unlock:
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_unlock(&devlink->lock);
-	mutex_unlock(&devlink_mutex);
+	devlink_put(devlink);
 	return err;
 }
=20
@@ -460,7 +471,7 @@ static void devlink_nl_post_doit(const struct genl_ops =
*ops,
 	devlink =3D info->user_ptr[0];
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_unlock(&devlink->lock);
-	mutex_unlock(&devlink_mutex);
+	devlink_put(devlink);
 }
=20
 static struct genl_family devlink_nl_family;
@@ -8122,6 +8133,7 @@ struct devlink *devlink_alloc(const struct devlink_op=
s *ops, size_t priv_size)
 	mutex_init(&devlink->lock);
 	mutex_init(&devlink->reporters_lock);
 	mutex_init(&devlink->reload_lock);
+	init_completion(&devlink->unregister_complete);
 	return devlink;
 }
 EXPORT_SYMBOL_GPL(devlink_alloc);
@@ -8136,6 +8148,7 @@ int devlink_register(struct devlink *devlink, struct =
device *dev)
 {
 	devlink->dev =3D dev;
 	devlink->registered =3D true;
+	refcount_set(&devlink->refcount, 1);
 	mutex_lock(&devlink_mutex);
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
@@ -8151,12 +8164,23 @@ EXPORT_SYMBOL_GPL(devlink_register);
  */
 void devlink_unregister(struct devlink *devlink)
 {
+	/* Remove from the list first, so that no new users can get it */
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink->ops) &&
-		devlink->reload_enabled);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 	list_del(&devlink->list);
 	mutex_unlock(&devlink_mutex);
+
+	/* Balances with refcount_set in devlink_register(). */
+	devlink_put(devlink);
+	/* Wait for any existing users to stop using the devlink device */
+	wait_for_completion(&devlink->unregister_complete);
+
+	/* At this point there are no active users working on the devlink instanc=
e;
+	 * also net ns exit operation (if any) is also completed.
+	 * devlink is out of global list, hence no users can acquire reference to=
 this devlink
+	 * instance anymore. Hence, it is safe to proceed with unregistration.
+	 */
+	WARN_ON(devlink_reload_supported(devlink->ops) && devlink->reload_enabled=
);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
=20
@@ -10472,6 +10496,8 @@ static void __net_exit devlink_pernet_pre_exit(stru=
ct net *net)
 {
 	struct devlink *devlink;
 	u32 actions_performed;
+	LIST_HEAD(local_list);
+	struct devlink *tmp;
 	int err;
=20
 	/* In case network namespace is getting destroyed, reload
@@ -10479,18 +10505,32 @@ static void __net_exit devlink_pernet_pre_exit(st=
ruct net *net)
 	 */
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
-		if (net_eq(devlink_net(devlink), net)) {
-			if (WARN_ON(!devlink_reload_supported(devlink->ops)))
-				continue;
-			err =3D devlink_reload(devlink, &init_net,
-					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
-					     DEVLINK_RELOAD_LIMIT_UNSPEC,
-					     &actions_performed, NULL);
-			if (err && err !=3D -EOPNOTSUPP)
-				pr_warn("Failed to reload devlink instance into init_net\n");
-		}
+		if (!net_eq(devlink_net(devlink), net))
+			continue;
+
+		if (WARN_ON(!devlink_reload_supported(devlink->ops)))
+			continue;
+
+		/* Hold the reference to devlink instance so that it doesn't get unregis=
tered
+		 * once global devlink_mutex is unlocked.
+		 * Store the devlink to a shadow list so that if devlink unregistration =
is
+		 * started, it can be still found in the shadow list.
+		 */
+		if (devlink_try_get(devlink))
+			list_add_tail(&devlink->reload_list, &local_list);
 	}
 	mutex_unlock(&devlink_mutex);
+
+	list_for_each_entry_safe(devlink, tmp, &local_list, reload_list) {
+		list_del_init(&devlink->reload_list);
+		err =3D devlink_reload(devlink, &init_net,
+				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+				     DEVLINK_RELOAD_LIMIT_UNSPEC,
+				     &actions_performed, NULL);
+		if (err && err !=3D -EOPNOTSUPP)
+			pr_warn("Failed to reload devlink instance into init_net\n");
+		devlink_put(devlink);
+	}
 }
=20
 static struct pernet_operations devlink_pernet_ops __net_initdata =3D {
--=20
2.26.2

