Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521CF340D46
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhCRSiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhCRSiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F22564F69;
        Thu, 18 Mar 2021 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092705;
        bh=1Sp7cr19Qqp+LzEYvRyL3hXdS3DHoYWAqzJ2dxOmAN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtHkGVO2q48Gnl/EUdn3MUuSoh/PMB7/peV2y+pytaHPQodO36Ndv0WLTtDTZhZhZ
         SGe7+sBnklo4ni12DjQainYDuq4TxULohB6yM+x3wOQcqxb4UuNMb40MMIlzUBgKwM
         4bWs3X75gNoc8tqpGTWuJbaJzZq3z5P2+nUkYcqg72aT+ATOW/T6+D3BB2pm9122Hq
         jvVpAqgDZJpcRu/ExXNZBL1iKLgu9HHJ6AMm5BTtj2hs2IvpXWNnTxwf8eWplnAWNp
         rDKdMROR5m+ioIowN67Vk+3CHbPccM4JOrnL0gNuWfSfaAUvRBSxH2n+67kGptHo1K
         FvpJKg0Y/QXBQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 10/13] net-sysfs: move the rtnl unlock up in the xps show helpers
Date:   Thu, 18 Mar 2021 19:37:49 +0100
Message-Id: <20210318183752.2612563-11-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
References: <20210318183752.2612563-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that nr_ids and num_tc are stored in the xps dev_maps, which are RCU
protected, we do not have the need to protect the maps in the rtnl lock.
Move the rtnl unlock up so we reduce the rtnl locking section.

We also increase the reference count on the subordinate device if any,
as we don't want this device to be freed while we use it (now that the
rtnl lock isn't protecting it in the whole function).

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ca1f3b63cfad..094fea082649 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1383,10 +1383,14 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	tc = netdev_txq_to_tc(dev, index);
 	if (tc < 0) {
-		ret = -EINVAL;
-		goto err_rtnl_unlock;
+		rtnl_unlock();
+		return -EINVAL;
 	}
 
+	/* Make sure the subordinate device can't be freed */
+	get_device(&dev->dev);
+	rtnl_unlock();
+
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_maps[XPS_CPUS]);
 	nr_ids = dev_maps ? dev_maps->nr_ids : nr_cpu_ids;
@@ -1417,8 +1421,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	}
 out_no_maps:
 	rcu_read_unlock();
-
-	rtnl_unlock();
+	put_device(&dev->dev);
 
 	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
 	bitmap_free(mask);
@@ -1426,8 +1429,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 err_rcu_unlock:
 	rcu_read_unlock();
-err_rtnl_unlock:
-	rtnl_unlock();
+	put_device(&dev->dev);
 	return ret;
 }
 
@@ -1486,10 +1488,9 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 		return restart_syscall();
 
 	tc = netdev_txq_to_tc(dev, index);
-	if (tc < 0) {
-		ret = -EINVAL;
-		goto err_rtnl_unlock;
-	}
+	rtnl_unlock();
+	if (tc < 0)
+		return -EINVAL;
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_maps[XPS_RXQS]);
@@ -1522,8 +1523,6 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 out_no_maps:
 	rcu_read_unlock();
 
-	rtnl_unlock();
-
 	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
 	bitmap_free(mask);
 
@@ -1531,8 +1530,6 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 
 err_rcu_unlock:
 	rcu_read_unlock();
-err_rtnl_unlock:
-	rtnl_unlock();
 	return ret;
 }
 
-- 
2.30.2

