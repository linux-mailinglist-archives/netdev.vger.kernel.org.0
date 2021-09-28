Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E31041AF7B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbhI1M5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240852AbhI1M5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E07661215;
        Tue, 28 Sep 2021 12:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833739;
        bh=f4TymLIZGiKc1reyB92dlJpF9pGSgYjD+LZcAT8XLPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLd+ejQEnFRgzT3DvmkVixtjjPAWZxE1S1hJ5i3G6uW/7/J5C70fkLRlyFRwqKiTV
         AFbo3Mv6zIAQ6IzYENvTG+pkpJhSoEgwcHMVpHobdN/Smz9LVsR6z3KJkTn9UuYHCm
         haV3ZN31l1IXuDmlNYh/gcRWr1qajII5fzBEZr31ufTE7qmekZkVTKGSo57KUp2Ak6
         ShUbkkV1/ZJBB93qkDuR2PDC6uSl9EXlMuPgvgkGqB+LjRT7DJ07954pNw9tEOAF6S
         e8Yuway5ehzMXYL5rWdzkTuMawBNzppX55ikM0d8z+W12K56l4hW9dDPlW1DvJrRO4
         Ty0NnpHMJTi6g==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 9/9] net-sysfs: remove the use of rtnl_trylock/restart_syscall
Date:   Tue, 28 Sep 2021 14:55:00 +0200
Message-Id: <20210928125500.167943-10-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ABBA deadlock avoided by using rtnl_trylock and restart_syscall was
fixed in previous commits, we can now remove the use of this
trylock/restart logic and have net-sysfs operations not spinning when
rtnl is already taken.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 95 +++++++-------------------------------------
 1 file changed, 14 insertions(+), 81 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e754f00c117b..987b32fd8604 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -90,9 +90,7 @@ static ssize_t netdev_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		goto err;
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (dev_isalive(netdev)) {
 		ret = (*set)(netdev, new);
 		if (ret == 0)
@@ -196,15 +194,7 @@ static ssize_t speed_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
-	/* The check is also done in __ethtool_get_link_ksettings; this helps
-	 * returning early without hitting the trylock/restart below.
-	 */
-	if (!netdev->ethtool_ops->get_link_ksettings)
-		return -EOPNOTSUPP;
-
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
@@ -222,15 +212,7 @@ static ssize_t duplex_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
-	/* The check is also done in __ethtool_get_link_ksettings; this helps
-	 * returning early without hitting the trylock/restart below.
-	 */
-	if (!netdev->ethtool_ops->get_link_ksettings)
-		return -EOPNOTSUPP;
-
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
@@ -427,9 +409,7 @@ static ssize_t ifalias_store(struct device *dev, struct device_attribute *attr,
 	if (len >  0 && buf[len - 1] == '\n')
 		--count;
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (dev_isalive(netdev)) {
 		ret = dev_set_alias(netdev, buf, count);
 		if (ret < 0)
@@ -490,15 +470,7 @@ static ssize_t phys_port_id_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
-	/* The check is also done in dev_get_phys_port_id; this helps returning
-	 * early without hitting the trylock/restart below.
-	 */
-	if (!netdev->netdev_ops->ndo_get_phys_port_id)
-		return -EOPNOTSUPP;
-
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (dev_isalive(netdev)) {
 		struct netdev_phys_item_id ppid;
 
@@ -518,16 +490,7 @@ static ssize_t phys_port_name_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
-	/* The checks are also done in dev_get_phys_port_name; this helps
-	 * returning early without hitting the trylock/restart below.
-	 */
-	if (!netdev->netdev_ops->ndo_get_phys_port_name &&
-	    !netdev->netdev_ops->ndo_get_devlink_port)
-		return -EOPNOTSUPP;
-
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (dev_isalive(netdev)) {
 		char name[IFNAMSIZ];
 
@@ -547,16 +510,7 @@ static ssize_t phys_switch_id_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
-	/* The checks are also done in dev_get_phys_port_name; this helps
-	 * returning early without hitting the trylock/restart below.
-	 */
-	if (!netdev->netdev_ops->ndo_get_port_parent_id &&
-	    !netdev->netdev_ops->ndo_get_devlink_port)
-		return -EOPNOTSUPP;
-
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (dev_isalive(netdev)) {
 		struct netdev_phys_item_id ppid = { };
 
@@ -576,9 +530,7 @@ static ssize_t threaded_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	if (dev_isalive(netdev))
 		ret = sprintf(buf, fmt_dec, netdev->threaded);
 
@@ -1214,9 +1166,7 @@ static ssize_t traffic_class_show(struct netdev_queue *queue,
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	index = get_netdev_queue_index(queue);
 
 	/* If queue belongs to subordinate dev use its TC mapping */
@@ -1258,18 +1208,11 @@ static ssize_t tx_maxrate_store(struct netdev_queue *queue,
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	/* The check is also done later; this helps returning early without
-	 * hitting the trylock/restart below.
-	 */
-	if (!dev->netdev_ops->ndo_set_tx_maxrate)
-		return -EOPNOTSUPP;
-
 	err = kstrtou32(buf, 10, &rate);
 	if (err < 0)
 		return err;
 
-	if (!rtnl_trylock())
-		return restart_syscall();
+	rtnl_lock();
 
 	err = -EOPNOTSUPP;
 	if (dev->netdev_ops->ndo_set_tx_maxrate)
@@ -1460,8 +1403,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
 
 	index = get_netdev_queue_index(queue);
 
-	if (!rtnl_trylock())
-		return restart_syscall();
+	rtnl_lock();
 
 	/* If queue belongs to subordinate dev use its map */
 	dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
@@ -1507,11 +1449,7 @@ static ssize_t xps_cpus_store(struct netdev_queue *queue,
 		return err;
 	}
 
-	if (!rtnl_trylock()) {
-		free_cpumask_var(mask);
-		return restart_syscall();
-	}
-
+	rtnl_lock();
 	err = netif_set_xps_queue(dev, mask, index);
 	rtnl_unlock();
 
@@ -1531,9 +1469,7 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 
 	index = get_netdev_queue_index(queue);
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
+	rtnl_lock();
 	tc = netdev_txq_to_tc(dev, index);
 	rtnl_unlock();
 	if (tc < 0)
@@ -1566,10 +1502,7 @@ static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
 		return err;
 	}
 
-	if (!rtnl_trylock()) {
-		bitmap_free(mask);
-		return restart_syscall();
-	}
+	rtnl_lock();
 
 	cpus_read_lock();
 	err = __netif_set_xps_queue(dev, mask, index, XPS_RXQS);
-- 
2.31.1

