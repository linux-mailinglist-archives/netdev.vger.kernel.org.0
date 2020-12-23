Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF3C2E2204
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgLWVYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 16:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbgLWVYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 16:24:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB362247F;
        Wed, 23 Dec 2020 21:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608758614;
        bh=4cMhlCykl7mfzg2nMm1XjPf1LqbO9W6RHroB+SznBiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWe8lgTgC6Ug0zei6ck0C9KYcPeouvHNF7d8/lFVx61Bs+T7t9KAfJFT3t7CsjMLi
         g0Wi66hEXcY4G4v5z9Flq53tWKy/9LKjixPe7AQlKPzv6WeDwRqPvGVNFbiU2jkbls
         O+m6YVRnCcD9Oh9WGcQmqAe12/fK8xXxW9VfpDrqKMzBGgysDmtYZ9npGT/9OLfrfN
         oPLW+b7JZKZQB1H1hTMglnsRePkiBLI6orf0mJHz40CjD+yo1NNa5AHdGbVuBtsza/
         rsbKcFODVNO12JnY3Dnt54/2ZWogfOv5/OsitctAHsFkGE44K6WRGSPtoPvMl2EVeP
         dCBzVWnsH4jXw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net v3 3/4] net-sysfs: take the rtnl lock when storing xps_rxqs
Date:   Wed, 23 Dec 2020 22:23:22 +0100
Message-Id: <20201223212323.3603139-4-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223212323.3603139-1-atenart@kernel.org>
References: <20201223212323.3603139-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two race conditions can be triggered when storing xps rxqs, resulting in
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
xps_rxqs in a concurrent thread. With the right timing an oops is
triggered.

Both issues have the same fix: netif_set_xps_queue, netdev_set_num_tc
and netdev_reset_tc should be mutually exclusive. We do that by taking
the rtnl lock in xps_rxqs_store.

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

