Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718B5219594
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgGIBTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgGIBSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 21:18:49 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEF3C2078C;
        Thu,  9 Jul 2020 01:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594257529;
        bh=3LKRArY8kxSKxVmm3hu5UrQzIY9PSDkkIoua3B6RVmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/XyVKkezGxGoDTMZ3uZ6JLMzSO9mZLowTl7Y6Zv+SLW3gpZGW46jHqbj9d2lRpqS
         RabjevLgRk1FdqxM4M39HEcIxzEAM7QOTR+lnwuq5MWxyrujyJlDwEIcPfcnwEEdjB
         y+DlIfH7MDPCc5CY+PBEbrKycOk56BGW9plSzoEE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 07/10] ixgbe: don't clear UDP tunnel ports when RXCSUM is disabled
Date:   Wed,  8 Jul 2020 18:18:11 -0700
Message-Id: <20200709011814.4003186-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709011814.4003186-1-kuba@kernel.org>
References: <20200709011814.4003186-1-kuba@kernel.org>
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

