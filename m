Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8E33BA065
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhGBMdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 08:33:36 -0400
Received: from proxmox-new.maurer-it.com ([94.136.29.106]:8616 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhGBMdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 08:33:36 -0400
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 126A34048F;
        Fri,  2 Jul 2021 14:07:43 +0200 (CEST)
From:   Wolfgang Bumiller <w.bumiller@proxmox.com>
To:     netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: [PATCH v3] net: bridge: sync fdb to new unicast-filtering ports
Date:   Fri,  2 Jul 2021 14:07:36 +0200
Message-Id: <20210702120736.3746-1-w.bumiller@proxmox.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2796d0c648c9 ("bridge: Automatically manage
port promiscuous mode.")
bridges with `vlan_filtering 1` and only 1 auto-port don't
set IFF_PROMISC for unicast-filtering-capable ports.

Normally on port changes `br_manage_promisc` is called to
update the promisc flags and unicast filters if necessary,
but it cannot distinguish between *new* ports and ones
losing their promisc flag, and new ports end up not
receiving the MAC address list.

Fix this by calling `br_fdb_sync_static` in `br_add_if`
after the port promisc flags are updated and the unicast
filter was supposed to have been filled.

Fixes: 2796d0c648c9 ("bridge: Automatically manage port promiscuous mode.")
Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
---
Changes to v2:
  * Added 'fdb_synced' boolean to only unsync on error if it was
    actually synced.
    `br_fdb_sync_static()` already unrolls changes if it encounters an
    error in the middle, so only a successful call will trigger the
    unsync.
    I opted for the explicit error handling as I felt that avoiding the
    error cleanup by moving the code down might be more easily missed in
    future changes (I just felt safer this way), plus, it's closer to
    the call which would normally be responsible for doing this which
    felt more natural to me.

    I hope this is fine, otherwise I can still move it :-)

 net/bridge/br_if.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..6e4a32354a13 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -562,7 +562,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	struct net_bridge_port *p;
 	int err = 0;
 	unsigned br_hr, dev_hr;
-	bool changed_addr;
+	bool changed_addr, fdb_synced = false;
 
 	/* Don't allow bridging non-ethernet like devices. */
 	if ((dev->flags & IFF_LOOPBACK) ||
@@ -652,6 +652,19 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	list_add_rcu(&p->list, &br->port_list);
 
 	nbp_update_port_count(br);
+	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
+		/* When updating the port count we also update all ports'
+		 * promiscuous mode.
+		 * A port leaving promiscuous mode normally gets the bridge's
+		 * fdb synced to the unicast filter (if supported), however,
+		 * `br_port_clear_promisc` does not distinguish between
+		 * non-promiscuous ports and *new* ports, so we need to
+		 * sync explicitly here.
+		 */
+		fdb_synced = br_fdb_sync_static(br, p) == 0;
+		if (!fdb_synced)
+			netdev_err(dev, "failed to sync bridge static fdb addresses to this port\n");
+	}
 
 	netdev_update_features(br->dev);
 
@@ -701,6 +714,8 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	return 0;
 
 err7:
+	if (fdb_synced)
+		br_fdb_unsync_static(br, p);
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);
-- 
2.32.0


