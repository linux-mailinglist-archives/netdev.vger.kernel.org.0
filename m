Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C742E2202
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgLWVYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 16:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbgLWVYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 16:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675A32246B;
        Wed, 23 Dec 2020 21:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608758609;
        bh=Qv7BNaQBGigmchrOczr/Unmy93zZ29j4XMAjksBoIWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=am+ogcDW/UnuyA2x0N8ww9ObN6VNHgWVd9xGlkEEPzkmbXrHpsXxF7rTvRzkx2mUn
         J89ULD70k68nyRACwA2XVerrEWVDTmXu91UOPPecKMoySKSh1wiQytQR77S/IOTPET
         3eq6acPbrBPG6j9+3fWIyrl1uBrao7amCpXJKUk59QCcg3OPLBkkpk0l4KLC+gJRdd
         V3lDuQSBkCtz1sQ15K8fOE9tb/a1Qn7Lrly58r/ZY+yMQ7Rus7es/eOTCI4p5Zj+wU
         59vFUx88vvVNuB97b09csQ0jMKrxgAvh35+FR+rJVSspQNF9feH//i0Hu9HcEncvAL
         pZkLv02J2AX3Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net v3 1/4] net-sysfs: take the rtnl lock when storing xps_cpus
Date:   Wed, 23 Dec 2020 22:23:20 +0100
Message-Id: <20201223212323.3603139-2-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223212323.3603139-1-atenart@kernel.org>
References: <20201223212323.3603139-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two race conditions can be triggered when storing xps cpus, resulting in
various oops and invalid memory accesses:

1. Calling netdev_set_num_tc while netif_set_xps_queue:

   - netif_set_xps_queue uses dev->tc_num as one of the parameters to
     compute the size of new_dev_maps when allocating it. dev->tc_num is
     also used to access the map, and the compiler may generate code to
     retrieve this field multiple times in the function.

   - netdev_set_num_tc sets dev->tc_num.

   If new_dev_maps is allocated using dev->tc_num and then dev->tc_num
   is set to a higher value through netdev_set_num_tc, later accesses to
   new_dev_maps in netif_set_xps_queue could lead to accessing memory
   outside of new_dev_maps; triggering an oops.

2. Calling netif_set_xps_queue while netdev_set_num_tc is running:

   2.1. netdev_set_num_tc starts by resetting the xps queues,
        dev->tc_num isn't updated yet.

   2.2. netif_set_xps_queue is called, setting up the map with the
        *old* dev->num_tc.

   2.3. netdev_set_num_tc updates dev->tc_num.

   2.4. Later accesses to the map lead to out of bound accesses and
        oops.

   A similar issue can be found with netdev_reset_tc.

One way of triggering this is to set an iface up (for which the driver
uses netdev_set_num_tc in the open path, such as bnx2x) and writing to
xps_cpus in a concurrent thread. With the right timing an oops is
triggered.

Both issues have the same fix: netif_set_xps_queue, netdev_set_num_tc
and netdev_reset_tc should be mutually exclusive. We do that by taking
the rtnl lock in xps_cpus_store.

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

