Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4CE2DD528
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgLQQ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgLQQ0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 11:26:08 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 1/4] net-sysfs: take the rtnl lock when storing xps_cpus
Date:   Thu, 17 Dec 2020 17:25:18 +0100
Message-Id: <20201217162521.1134496-2-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217162521.1134496-1-atenart@kernel.org>
References: <20201217162521.1134496-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callers to netif_set_xps_queue should take the rtnl lock. Failing to do
so can lead to race conditions between netdev_set_num_tc and
netif_set_xps_queue, triggering various oops:

- netif_set_xps_queue uses dev->tc_num as one of the parameters to
  compute the size of new_dev_maps when allocating it. dev->tc_num is
  also used to access the map, and the compiler may generate code to
  retrieve this field multiple times in the function.

- netdev_set_num_tc sets dev->tc_num.

If new_dev_maps is allocated using dev->tc_num and then dev->tc_num is
set to a higher value through netdev_set_num_tc, later accesses to
new_dev_maps in netif_set_xps_queue could lead to accessing memory
outside of new_dev_maps; triggering an oops.

One way of triggering this is to set an iface up (for which the driver
uses netdev_set_num_tc in the open path, such as bnx2x) and writing to
xps_cpus in a concurrent thread. With the right timing an oops is
triggered.

Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 999b70c59761..7cc15dec1717 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1396,7 +1396,13 @@ static ssize_t xps_cpus_store(struct netdev_queue *queue,
 		return err;
 	}
 
+	if (!rtnl_trylock()) {
+		free_cpumask_var(mask);
+		return restart_syscall();
+	}
+
 	err = netif_set_xps_queue(dev, mask, index);
+	rtnl_unlock();
 
 	free_cpumask_var(mask);
 
-- 
2.29.2

