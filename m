Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF54E21AC1B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgGJAnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbgGJAm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 20:42:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840A5207BC;
        Fri, 10 Jul 2020 00:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594341778;
        bh=3LKRArY8kxSKxVmm3hu5UrQzIY9PSDkkIoua3B6RVmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sadBfhWjn0dUUp8pkVKBsOcSJaIa60XcWIKmTTyIji2rPbBnJsD1j4vvyTmOeSGUT
         vG9uNwP2CqdQr4MU2N9hwzG33dFcuQgAj9XWOMUqNcW0PlBEnQlbEEwQdgNZo6JI4E
         C7l2ZbBfniKSyWl3KNz9gRK+JR9t6ioc4Wsa5K8Y=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 07/10] ixgbe: don't clear UDP tunnel ports when RXCSUM is disabled
Date:   Thu,  9 Jul 2020 17:42:50 -0700
Message-Id: <20200710004253.211130-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710004253.211130-1-kuba@kernel.org>
References: <20200710004253.211130-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears the clearing of UDP tunnel ports when RXCSUM
is disabled is unnecessary. Driver will not pay attention
to checksum bits if RXCSUM is not set, so we can let
the hardware parse the packets.

Note that the UDP tunnel port NDO handlers don't pay attention
to the state of RXCSUM, so the ports could had been re-programmed,
anyway.

This cleanup simplifies later conversion patch.

v2:
 - break this out of the following patch.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f5d3d6230786..acdf525272a3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9784,26 +9784,6 @@ static int ixgbe_set_features(struct net_device *netdev,
 
 	netdev->features = features;
 
-	if ((adapter->flags & IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE)) {
-		if (features & NETIF_F_RXCSUM) {
-			adapter->flags2 |= IXGBE_FLAG2_UDP_TUN_REREG_NEEDED;
-		} else {
-			u32 port_mask = IXGBE_VXLANCTRL_VXLAN_UDPPORT_MASK;
-
-			ixgbe_clear_udp_tunnel_port(adapter, port_mask);
-		}
-	}
-
-	if ((adapter->flags & IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE)) {
-		if (features & NETIF_F_RXCSUM) {
-			adapter->flags2 |= IXGBE_FLAG2_UDP_TUN_REREG_NEEDED;
-		} else {
-			u32 port_mask = IXGBE_VXLANCTRL_GENEVE_UDPPORT_MASK;
-
-			ixgbe_clear_udp_tunnel_port(adapter, port_mask);
-		}
-	}
-
 	if ((changed & NETIF_F_HW_L2FW_DOFFLOAD) && adapter->num_rx_pools > 1)
 		ixgbe_reset_l2fw_offload(adapter);
 	else if (need_reset)
-- 
2.26.2

