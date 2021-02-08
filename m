Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECD3313AC7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhBHRXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhBHRVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE90064EB4;
        Mon,  8 Feb 2021 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804782;
        bh=4mWavSQrebp/ovnVdSJxGHCsK1N5UL37VgY1dObRWBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoRptTY3lHuNhszm59ar1AedE8RBobWBi60tht1sn84kHiyL6F5KTswztN2POqJ/I
         rUzitizraiA7IDm9hG52FhNSqdu+BP5b46bHn7hBEQS1he3lORgzowTDtiJw41N6ne
         ynLDmilW0jfxR+HpBh/mIMnN7xbSXeLeEuuNg/STKRmDw4FKGeGQNrYDmt3Gtb2lAw
         SB5DifWfHvzp/uRKf+3/qlNPHEaGNZ7o8m0MO1GhSVJlJhPIXKufuStJhOAYBIqdJo
         WuK54+1CsHX097V5tqwhNOL2e1MdCvyQSDLJdd5nEFA4qcB10a1KFX/3etLTV2TUEu
         t2YFrYEJHmh6A==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 09/12] net-sysfs: remove the rtnl lock when accessing the xps maps
Date:   Mon,  8 Feb 2021 18:19:14 +0100
Message-Id: <20210208171917.1088230-10-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that nr_ids and num_tc are stored in the xps dev_maps, which are RCU
protected, we do not have the need to protect the xps_cpus_show and
xps_rxqs_show functions with the rtnl lock.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c2276b589cfb..6ce5772e799e 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1328,17 +1328,12 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	index = get_netdev_queue_index(queue);
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
 	/* If queue belongs to subordinate dev use its map */
 	dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
 	tc = netdev_txq_to_tc(dev, index);
-	if (tc < 0) {
-		ret = -EINVAL;
-		goto err_rtnl_unlock;
-	}
+	if (tc < 0)
+		return -EINVAL;
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_maps[XPS_CPUS]);
@@ -1371,16 +1366,12 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 out_no_maps:
 	rcu_read_unlock();
 
-	rtnl_unlock();
-
 	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
 	bitmap_free(mask);
 	return len < PAGE_SIZE ? len : -EINVAL;
 
 err_rcu_unlock:
 	rcu_read_unlock();
-err_rtnl_unlock:
-	rtnl_unlock();
 	return ret;
 }
 
@@ -1435,14 +1426,9 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 
 	index = get_netdev_queue_index(queue);
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
 	tc = netdev_txq_to_tc(dev, index);
-	if (tc < 0) {
-		ret = -EINVAL;
-		goto err_rtnl_unlock;
-	}
+	if (tc < 0)
+		return -EINVAL;
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_maps[XPS_RXQS]);
@@ -1475,8 +1461,6 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 out_no_maps:
 	rcu_read_unlock();
 
-	rtnl_unlock();
-
 	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
 	bitmap_free(mask);
 
@@ -1484,8 +1468,6 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 
 err_rcu_unlock:
 	rcu_read_unlock();
-err_rtnl_unlock:
-	rtnl_unlock();
 	return ret;
 }
 
-- 
2.29.2

