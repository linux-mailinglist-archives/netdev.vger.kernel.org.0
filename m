Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C29F2EC581
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbhAFVHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbhAFVHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A624123158;
        Wed,  6 Jan 2021 21:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609967230;
        bh=RHhyOB1Z52lLst6SBS07TqC8kojrSs+RU4bZlUxuO28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDn0u8kbs7gmjbhR4WIVDD344s+nTC/IuU4C8eOoEYgn3dAiwYFigAuJ6vKjBl+oh
         G6+aIMmQlpcm7aAW3O7TTHGBkJVYnvLCffr/jpSTXwl0NHRt/sXUw+MLeJtzv+4iAb
         XgsSx9zwBWaJhvtJAeu4l9/Dj/SNAhFOK58L/IC3gEs6bv5RnTib5qKCNEwJR9ybbL
         3wprVpMImF3LNlclBi1EkJq7+SbZaFfN2Tdb8nMDfZ7bgf4EM5oZhRLo+85Z+CZA5C
         HHERqe1B8mupvmg7upR6ojeONNK6PfPJ74spclAbriVyJT5tu9ONdJsdrAFJB7WAya
         hfVrhW24RFqIQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, thomas.lendacky@amd.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        michael.chan@broadcom.com, rajur@chelsio.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, GR-Linux-NIC-Dev@marvell.com,
        ecree.xilinx@gmail.com, simon.horman@netronome.com,
        alexander.duyck@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/4] udp_tunnel: remove REGISTER/UNREGISTER handling from tunnel drivers
Date:   Wed,  6 Jan 2021 13:06:35 -0800
Message-Id: <20210106210637.1839662-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106210637.1839662-1-kuba@kernel.org>
References: <20210106210637.1839662-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udp_tunnel_nic handles REGISTER and UNREGISTER event, now that all
drivers use that infra we can drop the event handling in the tunnel
drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/geneve.c | 14 ++++----------
 drivers/net/vxlan.c  | 15 +++++----------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 5523f069b9a5..6aa775d60c57 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1851,16 +1851,10 @@ static int geneve_netdevice_event(struct notifier_block *unused,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
-	if (event == NETDEV_UDP_TUNNEL_PUSH_INFO ||
-	    event == NETDEV_UDP_TUNNEL_DROP_INFO) {
-		geneve_offload_rx_ports(dev, event == NETDEV_UDP_TUNNEL_PUSH_INFO);
-	} else if (event == NETDEV_UNREGISTER) {
-		if (!dev->udp_tunnel_nic_info)
-			geneve_offload_rx_ports(dev, false);
-	} else if (event == NETDEV_REGISTER) {
-		if (!dev->udp_tunnel_nic_info)
-			geneve_offload_rx_ports(dev, true);
-	}
+	if (event == NETDEV_UDP_TUNNEL_PUSH_INFO)
+		geneve_offload_rx_ports(dev, true);
+	else if (event == NETDEV_UDP_TUNNEL_DROP_INFO)
+		geneve_offload_rx_ports(dev, false);
 
 	return NOTIFY_DONE;
 }
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a8ad710629e6..b9364433de8f 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4521,17 +4521,12 @@ static int vxlan_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct vxlan_net *vn = net_generic(dev_net(dev), vxlan_net_id);
 
-	if (event == NETDEV_UNREGISTER) {
-		if (!dev->udp_tunnel_nic_info)
-			vxlan_offload_rx_ports(dev, false);
+	if (event == NETDEV_UNREGISTER)
 		vxlan_handle_lowerdev_unregister(vn, dev);
-	} else if (event == NETDEV_REGISTER) {
-		if (!dev->udp_tunnel_nic_info)
-			vxlan_offload_rx_ports(dev, true);
-	} else if (event == NETDEV_UDP_TUNNEL_PUSH_INFO ||
-		   event == NETDEV_UDP_TUNNEL_DROP_INFO) {
-		vxlan_offload_rx_ports(dev, event == NETDEV_UDP_TUNNEL_PUSH_INFO);
-	}
+	else if (event == NETDEV_UDP_TUNNEL_PUSH_INFO)
+		vxlan_offload_rx_ports(dev, true);
+	else if (event == NETDEV_UDP_TUNNEL_DROP_INFO)
+		vxlan_offload_rx_ports(dev, false);
 
 	return NOTIFY_DONE;
 }
-- 
2.26.2

