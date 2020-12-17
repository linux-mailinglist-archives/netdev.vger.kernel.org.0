Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07DF2DD525
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgLQQ0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:26:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgLQQ0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 11:26:13 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 3/4] net-sysfs: take the rtnl lock when storing xps_rxqs
Date:   Thu, 17 Dec 2020 17:25:20 +0100
Message-Id: <20201217162521.1134496-4-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217162521.1134496-1-atenart@kernel.org>
References: <20201217162521.1134496-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callers to __netif_set_xps_queue should take the rtnl lock. Failing to
do so can lead to race conditions between netdev_set_num_tc and
__netif_set_xps_queue, triggering various oops:

- __netif_set_xps_queue uses dev->tc_num as one of the parameters to
  compute the size of new_dev_maps when allocating it. dev->tc_num is
  also used to access the map, and the compiler may generate code to
  retrieve this field multiple times in the function.

- netdev_set_num_tc sets dev->tc_num.

If new_dev_maps is allocated using dev->tc_num and then dev->tc_num is
set to a higher value through netdev_set_num_tc, later accesses to
new_dev_maps in __netif_set_xps_queue could lead to accessing memory
outside of new_dev_maps; triggering an oops.

One way of triggering this is to set an iface up (for which the driver
uses netdev_set_num_tc in the open path, such as bnx2x) and writing to
xps_rxqs in a concurrent thread. With the right timing an oops is
triggered.

Fixes: 8af2c06ff4b1 ("net-sysfs: Add interface for Rx queue(s) map per Tx queue")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 65886bfbf822..62ca2f2c0ee6 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1499,10 +1499,17 @@ static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
 		return err;
 	}
 
+	if (!rtnl_trylock()) {
+		bitmap_free(mask);
+		return restart_syscall();
+	}
+
 	cpus_read_lock();
 	err = __netif_set_xps_queue(dev, mask, index, true);
 	cpus_read_unlock();
 
+	rtnl_unlock();
+
 	bitmap_free(mask);
 	return err ? : len;
 }
-- 
2.29.2

