Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861BE41AF72
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbhI1M45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240731AbhI1M4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6CAC610CC;
        Tue, 28 Sep 2021 12:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833716;
        bh=MYyuK2Oibf/hpzECOqohcD7fpK/taUOqcg37M8ZQG6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCmcw80kihK7PbWq72ZjqNf2Yorh5OmG8UZfW4UPAozrQDjRKDXe9/sbQid8eRnOJ
         OMeDWsOxOdwfZ76PbXwTSFqthnS4cuaxBjl0elvmJoRIbDolPej5ioCRGYgDyjCJp7
         1NOtQIse+9nbAxbIeclYwjX1NtvRp5tBx0ZhTMtaKYcmtAb9doPrcRXs+qmOzwCUJ1
         5OQj+7/40nXPXQMCMJRH01hbohl9ovFB6k9saEW6BBL4WFuSdAd275dH+4JaaxVOoP
         KDLTRPQSSKJFR6PrTlWdFVWtILipMdYaHYqGz1ItrlnVo/H4OJuHEyl5ZhGQ0eXF+P
         +7RfCheNugCOQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 1/9] net-sysfs: try not to restart the syscall if it will fail eventually
Date:   Tue, 28 Sep 2021 14:54:52 +0200
Message-Id: <20210928125500.167943-2-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
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
 net/core/net-sysfs.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f6197774048b..21c3fdeccf20 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -196,6 +196,12 @@ static ssize_t speed_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
+	/* The check is also done in __ethtool_get_link_ksettings; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->ethtool_ops->get_link_ksettings)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -216,6 +222,12 @@ static ssize_t duplex_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
+	/* The check is also done in __ethtool_get_link_ksettings; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->ethtool_ops->get_link_ksettings)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -478,6 +490,12 @@ static ssize_t phys_port_id_show(struct device *dev,
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
 
@@ -500,6 +518,13 @@ static ssize_t phys_port_name_show(struct device *dev,
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
 
@@ -522,6 +547,13 @@ static ssize_t phys_switch_id_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
+	/* The checks are also done in dev_get_phys_port_name; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->netdev_ops->ndo_get_port_parent_id &&
+	    !netdev->netdev_ops->ndo_get_devlink_port)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -1226,6 +1258,12 @@ static ssize_t tx_maxrate_store(struct netdev_queue *queue,
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

