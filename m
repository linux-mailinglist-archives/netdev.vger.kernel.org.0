Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653BE4254EF
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbhJGOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240542AbhJGOCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6516661040;
        Thu,  7 Oct 2021 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633615253;
        bh=LkxbaRvJVsqztkk7bgS+GYx4Rx84luyKoIAw6YQceRs=;
        h=From:To:Cc:Subject:Date:From;
        b=J4Vt8ZzxkKrXFWUTCwpAdhvBrxnIMWy/eYlYvAfrs/Z621TvuNqGtd1uXYZfqR1/u
         O3WAbuIw8YTwqzzYSs8vZxhIh+bDK36yZ90EO0KWqdzetQVXFMbbC357/VtAZ0Sj7v
         YGUvHalXvmYoSr6eOjUi/F3cv0/CFiyxsplbCRjsQJMmN7JueK2Hjh8Cy2c3+O2lJ3
         j1liZhVYYV9NXlFxJQfrb4aMvlClvtDl/YlC+kFK7QIVbyz73pvHkdMNRd3r0BRsrr
         8gA7JESPJuSF5ANjTyeQZRpO6lbmYYgmJVd+lb8foLbXgDVsopLHflWo1gi8YA1Hj1
         mkmtNasu+4GrA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        juri.lelli@redhat.com, mhocko@suse.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net-sysfs: try not to restart the syscall if it will fail eventually
Date:   Thu,  7 Oct 2021 16:00:51 +0200
Message-Id: <20211007140051.297963-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to deadlocks in the networking subsystem spotted 12 years ago[1],
a workaround was put in place[2] to avoid taking the rtnl lock when it
was not available and restarting the syscall (back to VFS, letting
userspace spin). The following construction is found a lot in the net
sysfs and sysctl code:

  if (!rtnl_trylock())
          return restart_syscall();

This can be problematic when multiple userspace threads use such
interfaces in a short period, making them to spin a lot. This happens
for example when adding and moving virtual interfaces: userspace
programs listening on events, such as systemd-udevd and NetworkManager,
do trigger actions reading files in sysfs. It gets worse when a lot of
virtual interfaces are created concurrently, say when creating
containers at boot time.

Returning early without hitting the above pattern when the syscall will
fail eventually does make things better. While it is not a fix for the
issue, it does ease things.

[1] https://lore.kernel.org/netdev/49A4D5D5.5090602@trash.net/
    https://lore.kernel.org/netdev/m14oyhis31.fsf@fess.ebiederm.org/
    and https://lore.kernel.org/netdev/20090226084924.16cb3e08@nehalam/
[2] Rightfully, those deadlocks are *hard* to solve.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Hello,

This patch comes from an RFC series[3] but wasn't strictly linked to the
other patches. As it helps at reducing the scope of the issue, it is
re-posted separately (as suggested by Jakub).

Since the RFC, this patch now also tries to avoid the trylock logic for
carrier_store and proto_down_store.

FYI, I haven't changed the behaviour of duplex_show and speed_show,
returning -EINVAL when the op is not supported. I can sent a
following-up patch to change that.

Thanks,
Antoine

[3] https://lore.kernel.org/all/20210928125500.167943-1-atenart@kernel.org/

 net/core/net-sysfs.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f6197774048b..5f6b421d06a1 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -175,6 +175,14 @@ static int change_carrier(struct net_device *dev, unsigned long new_carrier)
 static ssize_t carrier_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t len)
 {
+	struct net_device *netdev = to_net_dev(dev);
+
+	/* The check is also done in change_carrier; this helps returning early
+	 * without hitting the trylock/restart in netdev_store.
+	 */
+	if (!netdev->netdev_ops->ndo_change_carrier)
+		return -EOPNOTSUPP;
+
 	return netdev_store(dev, attr, buf, len, change_carrier);
 }
 
@@ -196,6 +204,12 @@ static ssize_t speed_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
+	/* The check is also done in __ethtool_get_link_ksettings; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->ethtool_ops->get_link_ksettings)
+		return ret;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -216,6 +230,12 @@ static ssize_t duplex_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
+	/* The check is also done in __ethtool_get_link_ksettings; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->ethtool_ops->get_link_ksettings)
+		return ret;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -468,6 +488,14 @@ static ssize_t proto_down_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
+	struct net_device *netdev = to_net_dev(dev);
+
+	/* The check is also done in change_proto_down; this helps returning
+	 * early without hitting the trylock/restart in netdev_store.
+	 */
+	if (!netdev->netdev_ops->ndo_change_proto_down)
+		return -EOPNOTSUPP;
+
 	return netdev_store(dev, attr, buf, len, change_proto_down);
 }
 NETDEVICE_SHOW_RW(proto_down, fmt_dec);
@@ -478,6 +506,12 @@ static ssize_t phys_port_id_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
+	/* The check is also done in dev_get_phys_port_id; this helps returning
+	 * early without hitting the trylock/restart below.
+	 */
+	if (!netdev->netdev_ops->ndo_get_phys_port_id)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -500,6 +534,13 @@ static ssize_t phys_port_name_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
+	/* The checks are also done in dev_get_phys_port_name; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->netdev_ops->ndo_get_phys_port_name &&
+	    !netdev->netdev_ops->ndo_get_devlink_port)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -522,6 +563,14 @@ static ssize_t phys_switch_id_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
+	/* The checks are also done in dev_get_phys_port_name; this helps
+	 * returning early without hitting the trylock/restart below. This works
+	 * because recurse is false when calling dev_get_port_parent_id.
+	 */
+	if (!netdev->netdev_ops->ndo_get_port_parent_id &&
+	    !netdev->netdev_ops->ndo_get_devlink_port)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -1226,6 +1275,12 @@ static ssize_t tx_maxrate_store(struct netdev_queue *queue,
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	/* The check is also done later; this helps returning early without
+	 * hitting the trylock/restart below.
+	 */
+	if (!dev->netdev_ops->ndo_set_tx_maxrate)
+		return -EOPNOTSUPP;
+
 	err = kstrtou32(buf, 10, &rate);
 	if (err < 0)
 		return err;
-- 
2.31.1

