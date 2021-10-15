Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BA942FE01
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbhJOWTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238850AbhJOWTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F7561205;
        Fri, 15 Oct 2021 22:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336223;
        bh=GdVkfoHzadHtHSaJzJVs8Ku7u9K9MTzPxyYmK33OkCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSVk3MuwNOZx1uFwvrKF33hCBUVSDowoRET9X+K/vILty3JRu2K+J5YnjVLBd6q8s
         bUECqWAHagKR0Xhme7ry27c4HgdLFD1Bz0Yf5if8v1tXjIPb0BMtWKX9YH87Jk1l7d
         j8xauKHue4azPh0a6JXU/E8calRn435tSLQ/oi3LRsBpM0/W8853svtpwrA4aouBsd
         /d9/BNV4aiKWrKWg8m+l2qhjMr9SJy9om/wYRNU0pugS4QrdMIIuCKrvgt2Oj2CT72
         dY1pO+uouPR6w87YNs58lTqZVIsJrVCuZwceLzAY/mwTU6uebC9DlvoGOoSq6+MFb5
         1ELIH+GLRIiHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        cforno12@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next 11/12] ethernet: ibmveth: use ether_addr_to_u64()
Date:   Fri, 15 Oct 2021 15:16:51 -0700
Message-Id: <20211015221652.827253-12-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll want to make netdev->dev_addr const, remove the local
helper which is missing a const qualifier on the argument
and use ether_addr_to_u64().

Similar story to mlx4.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: cforno12@linux.ibm.com
CC: mpe@ellerman.id.au
CC: benh@kernel.crashing.org
CC: paulus@samba.org
CC: linuxppc-dev@lists.ozlabs.org
---
 drivers/net/ethernet/ibm/ibmveth.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 836617fb3f40..45ba40cf4d07 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -483,17 +483,6 @@ static int ibmveth_register_logical_lan(struct ibmveth_adapter *adapter,
 	return rc;
 }
 
-static u64 ibmveth_encode_mac_addr(u8 *mac)
-{
-	int i;
-	u64 encoded = 0;
-
-	for (i = 0; i < ETH_ALEN; i++)
-		encoded = (encoded << 8) | mac[i];
-
-	return encoded;
-}
-
 static int ibmveth_open(struct net_device *netdev)
 {
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
@@ -553,7 +542,7 @@ static int ibmveth_open(struct net_device *netdev)
 	adapter->rx_queue.num_slots = rxq_entries;
 	adapter->rx_queue.toggle = 1;
 
-	mac_address = ibmveth_encode_mac_addr(netdev->dev_addr);
+	mac_address = ether_addr_to_u64(netdev->dev_addr);
 
 	rxq_desc.fields.flags_len = IBMVETH_BUF_VALID |
 					adapter->rx_queue.queue_len;
@@ -1476,7 +1465,7 @@ static void ibmveth_set_multicast_list(struct net_device *netdev)
 		netdev_for_each_mc_addr(ha, netdev) {
 			/* add the multicast address to the filter table */
 			u64 mcast_addr;
-			mcast_addr = ibmveth_encode_mac_addr(ha->addr);
+			mcast_addr = ether_addr_to_u64(ha->addr);
 			lpar_rc = h_multicast_ctrl(adapter->vdev->unit_address,
 						   IbmVethMcastAddFilter,
 						   mcast_addr);
@@ -1606,7 +1595,7 @@ static int ibmveth_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	mac_address = ibmveth_encode_mac_addr(addr->sa_data);
+	mac_address = ether_addr_to_u64(addr->sa_data);
 	rc = h_change_logical_lan_mac(adapter->vdev->unit_address, mac_address);
 	if (rc) {
 		netdev_err(adapter->netdev, "h_change_logical_lan_mac failed with rc=%d\n", rc);
-- 
2.31.1

