Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FDB2B0DE1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgKLTY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:24:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14156 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgKLTYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c080000>; Thu, 12 Nov 2020 11:24:56 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 05/13] devlink: Avoid global devlink mutex, use per instance reload lock
Date:   Thu, 12 Nov 2020 21:24:15 +0200
Message-ID: <20201112192424.2742-6-parav@nvidia.com>
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
        t=1605209097; bh=+/c5UpUQBIoWffcy2omGkhbvAAq7SZJuvOWE5xQXU2A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=UBX6Yj3dvenJFVTJQRw+nw6+garONpVQvNTZaYb7hpEmJSPxlD7iTlDWPPPk/5L+G
         LSc/ZoTGOXgrNs4EgcHDi19DlutzKJzhdXYgOZ0lTtg2SXo4cc0A7mFRiIgtDF/A0a
         SRW6VJVYTKGdGTwft5mBe/ajog/w0Zl+YwUYikeg6gbGix9kKluTzj4JW25rkyMhT4
         8ExJlIZ5eQOVC5scZkNJNM8VLRR42SrMAkStnzaArXl4k44ccQSPy4LbvtUA6aIKP/
         4LsxVkZh2bk6+lDRR55iqEPUYp0eG4IhwcJZI4zrQ4MkkirttYEQlyRfIiskh3X48l
         AtbBK5y+68EgA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink device reload is a special operation which brings down and up
the device. Such operation will unregister devlink device of sub
function port.
During devlink_reload() with devlink_mutex held leads to cyclic
dependency. For example,

devlink_reload()
  mutex_lock(&devlink_mutex); <- First lock acquire
  mlx5_reload_down(PCI PF device)
    disable_sf_devices();
      sf_state_set(inactive);
        ancillary_dev->remove();
           mlx5_adev_remove(adev);
             devlink_unregister(adev->devlink_instance);
               mutex_lock(&devlink_mutex); <- Second lock acquire

Hence devlink_reload() operation cannot be done under global
devlink_mutex mutex.

In second such instance reload_down() callback likely to disable reload
on child devlink device. This also prevents devlink_reload() to use
the overloaded global devlink_mutex.

devlink_reload()
  mutex_lock(&devlink_mutex); <- First lock acquire
    mlx5_reload_down(PCI PF device)
      disable_sf_devices();
        ancillary_dev->remove();
           mlx5_adev_remove(adev);
             devlink_reload_disable(adev->devlink_instance);
               mutex_lock(&devlink_mutex); <- Second lock acquire

Therefore, introduce a reload_lock per devlink instance which is held
when performing devlink device reload.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  1 +
 net/core/devlink.c    | 25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 124bac130c22..ef487b8ed17b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -52,6 +52,7 @@ struct devlink {
 	struct mutex lock; /* Serializes access to devlink instance specific obje=
cts such as
 			    * port, sb, dpipe, resource, params, region, traps and more.
 			    */
+	struct mutex reload_lock; /* Protects reload operation */
 	u8 reload_failed:1,
 	   reload_enabled:1,
 	   registered:1;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3e59ba73d5c4..c7c6f274d392 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3307,29 +3307,32 @@ static int devlink_reload(struct devlink *devlink, =
struct net *dest_net,
 	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
 	int err;
=20
-	if (!devlink->reload_enabled)
-		return -EOPNOTSUPP;
+	mutex_lock(&devlink->reload_lock);
+	if (!devlink->reload_enabled) {
+		err =3D -EOPNOTSUPP;
+		goto done;
+	}
=20
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
 	       sizeof(remote_reload_stats));
 	err =3D devlink->ops->reload_down(devlink, !!dest_net, action, limit, ext=
ack);
 	if (err)
-		return err;
+		goto done;
=20
 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
 		devlink_reload_netns_change(devlink, dest_net);
=20
 	err =3D devlink->ops->reload_up(devlink, action, limit, actions_performed=
, extack);
 	devlink_reload_failed_set(devlink, !!err);
-	if (err)
-		return err;
=20
 	WARN_ON(!(*actions_performed & BIT(action)));
 	/* Catch driver on updating the remote action within devlink reload */
 	WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,
 		       sizeof(remote_reload_stats)));
 	devlink_reload_stats_update(devlink, limit, *actions_performed);
-	return 0;
+done:
+	mutex_unlock(&devlink->reload_lock);
+	return err;
 }
=20
 static int
@@ -8118,6 +8121,7 @@ struct devlink *devlink_alloc(const struct devlink_op=
s *ops, size_t priv_size)
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
 	mutex_init(&devlink->lock);
 	mutex_init(&devlink->reporters_lock);
+	mutex_init(&devlink->reload_lock);
 	return devlink;
 }
 EXPORT_SYMBOL_GPL(devlink_alloc);
@@ -8166,9 +8170,9 @@ EXPORT_SYMBOL_GPL(devlink_unregister);
  */
 void devlink_reload_enable(struct devlink *devlink)
 {
-	mutex_lock(&devlink_mutex);
+	mutex_lock(&devlink->reload_lock);
 	devlink->reload_enabled =3D true;
-	mutex_unlock(&devlink_mutex);
+	mutex_unlock(&devlink->reload_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_reload_enable);
=20
@@ -8182,12 +8186,12 @@ EXPORT_SYMBOL_GPL(devlink_reload_enable);
  */
 void devlink_reload_disable(struct devlink *devlink)
 {
-	mutex_lock(&devlink_mutex);
+	mutex_lock(&devlink->reload_lock);
 	/* Mutex is taken which ensures that no reload operation is in
 	 * progress while setting up forbidded flag.
 	 */
 	devlink->reload_enabled =3D false;
-	mutex_unlock(&devlink_mutex);
+	mutex_unlock(&devlink->reload_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_reload_disable);
=20
@@ -8198,6 +8202,7 @@ EXPORT_SYMBOL_GPL(devlink_reload_disable);
  */
 void devlink_free(struct devlink *devlink)
 {
+	mutex_destroy(&devlink->reload_lock);
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
--=20
2.26.2

