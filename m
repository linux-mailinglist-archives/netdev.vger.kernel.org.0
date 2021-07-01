Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F1C3B91D9
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhGAM6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:58:36 -0400
Received: from proxmox-new.maurer-it.com ([94.136.29.106]:41963 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbhGAM6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:58:35 -0400
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id BAC9440345;
        Thu,  1 Jul 2021 14:47:06 +0200 (CEST)
From:   Wolfgang Bumiller <w.bumiller@proxmox.com>
To:     netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: [PATCH 1/1] net: bridge: sync fdb to new unicast-filtering ports
Date:   Thu,  1 Jul 2021 14:28:30 +0200
Message-Id: <20210701122830.2652-2-w.bumiller@proxmox.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210701122830.2652-1-w.bumiller@proxmox.com>
References: <20210701122830.2652-1-w.bumiller@proxmox.com>
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

Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
---
 net/bridge/br_if.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..183e72e7b65e 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -652,6 +652,18 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
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
+		if (br_fdb_sync_static(br, p))
+			netdev_err(dev, "failed to sync bridge addresses to this port\n");
+	}
 
 	netdev_update_features(br->dev);
 
-- 
2.32.0


