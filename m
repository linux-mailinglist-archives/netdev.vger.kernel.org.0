Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E53390BD
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhCLPFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232130AbhCLPFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F7F64F78;
        Fri, 12 Mar 2021 15:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561531;
        bh=SmBFsh200oLrNKpbhIObeffm9Jh3UMHhD/+jxp/SARk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwwRWj9cOPgHrQdRmEhFTg0DRd89rv+QzTU6JUClKvD8x+fGy0ragzRH8YcFgtqRO
         oM5xU7ngsbA3qghCH+s4z1UyZ8cPYG9zUXyAqhQ7F68Xldd8GR54Ewd8h1pQ8B/gth
         QD5lIHajD5e6kIL6Yqe/53CPWU7bJMgnKqhEe+a4fqNE6j2tm29d8kiPfvZI94S4Rf
         sHa4OIrS+19rT0+VlLRqZ60V3NQafPRV/LarcIEftSsq/3wOzpk5AEr16MUv6kigOk
         c5lh0tEpQJCq26NAe6xIbt0fBuCvG74bngz73Yxvq8OtvZrt5rfggrWygGlXL25rfO
         NExWcq+tsd3qA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        mst@redhat.com, jasowang@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 16/16] virtio_net: take the rtnl lock when calling virtnet_set_affinity
Date:   Fri, 12 Mar 2021 16:04:44 +0100
Message-Id: <20210312150444.355207-17-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_set_xps_queue must be called with the rtnl lock taken, and this is
now enforced using ASSERT_RTNL(). In virtio_net, netif_set_xps_queue is
called by virtnet_set_affinity. As this function can be called from an
ethtool helper, we can't take the rtnl lock directly in it. Instead we
take the rtnl lock when calling virtnet_set_affinity when the rtnl lock
isn't taken already.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/virtio_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index dde9bbcc5ff0..54d2277f6c98 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2027,7 +2027,9 @@ static int virtnet_cpu_online(unsigned int cpu, struct hlist_node *node)
 {
 	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
 						   node);
+	rtnl_lock();
 	virtnet_set_affinity(vi);
+	rtnl_unlock();
 	return 0;
 }
 
@@ -2035,7 +2037,9 @@ static int virtnet_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
 						   node_dead);
+	rtnl_lock();
 	virtnet_set_affinity(vi);
+	rtnl_unlock();
 	return 0;
 }
 
@@ -2883,7 +2887,9 @@ static int init_vqs(struct virtnet_info *vi)
 		goto err_free;
 
 	get_online_cpus();
+	rtnl_lock();
 	virtnet_set_affinity(vi);
+	rtnl_unlock();
 	put_online_cpus();
 
 	return 0;
-- 
2.29.2

