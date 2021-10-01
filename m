Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DDF41F6F9
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355669AbhJAVeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354739AbhJAVeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 131D7619EC;
        Fri,  1 Oct 2021 21:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123954;
        bh=xep7BxPERSxbDrN5NhkJ5VCge6k0FQR8G/IlcmphYu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pi2B2L9+rIrs5IDyED1MaQue0Aqy63Yr1qEvRfrEaiihbo12GIVPctamgorkIsLJQ
         2f5YXLzvfcHcQGvnnHa/7isbx2prMQJdInacCXGJX7AebLRtINs0rc+u0BxZKUTjUp
         W1LEWRj1gIVHEb7RWmkGVZfNGeFdgs6/5RpiHYhtzptsMikqkhoJmFUEUhCp9HaXaG
         SavskajYFNHH//uju0c6DC23KTNMg4J7ak7xPCcQrcNvI5CRNjxnpLe/G/ysEE9mDX
         PJQwUAloR/aF0sADmaFr/jRrmUO/zTGxhEHa2nxMQl0AdXTD09jh5b8g5Kl10aHHQO
         5OPEKyRK0CqYg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/11] net: use eth_hw_addr_set()
Date:   Fri,  1 Oct 2021 14:32:19 -0700
Message-Id: <20211001213228.1735079-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert sw drivers from memcpy(... ETH_ADDR) to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - memcpy(dev->dev_addr, np, ETH_ALEN)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c  | 2 +-
 drivers/net/ipvlan/ipvlan_main.c | 2 +-
 drivers/net/macvlan.c            | 2 +-
 net/bridge/br_stp_if.c           | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 382bebc2420d..479d2835a220 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2536,7 +2536,7 @@ static int netvsc_probe(struct hv_device *dev,
 		goto rndis_failed;
 	}
 
-	memcpy(net->dev_addr, device_info->mac_adr, ETH_ALEN);
+	eth_hw_addr_set(net, device_info->mac_adr);
 
 	/* We must get rtnl lock before scheduling nvdev->subchan_work,
 	 * otherwise netvsc_subchan_work() can get rtnl lock first and wait
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index c0b21a5580d5..cca4a00f1c51 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -579,7 +579,7 @@ int ipvlan_link_new(struct net *src_net, struct net_device *dev,
 	 * world but keep using the physical-dev address for the outgoing
 	 * packets.
 	 */
-	memcpy(dev->dev_addr, phy_dev->dev_addr, ETH_ALEN);
+	eth_hw_addr_set(dev, phy_dev->dev_addr);
 
 	dev->priv_flags |= IFF_NO_RX_HANDLER;
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 35f46ad040b0..63563edfd4a6 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -202,7 +202,7 @@ static void macvlan_hash_change_addr(struct macvlan_dev *vlan,
 	/* Now that we are unhashed it is safe to change the device
 	 * address without confusing packet delivery.
 	 */
-	memcpy(vlan->dev->dev_addr, addr, ETH_ALEN);
+	eth_hw_addr_set(vlan->dev, addr);
 	macvlan_hash_add(vlan);
 }
 
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index ba55851fe132..75204d36d7f9 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -233,7 +233,7 @@ void br_stp_change_bridge_id(struct net_bridge *br, const unsigned char *addr)
 
 	memcpy(oldaddr, br->bridge_id.addr, ETH_ALEN);
 	memcpy(br->bridge_id.addr, addr, ETH_ALEN);
-	memcpy(br->dev->dev_addr, addr, ETH_ALEN);
+	eth_hw_addr_set(br->dev, addr);
 
 	list_for_each_entry(p, &br->port_list, list) {
 		if (ether_addr_equal(p->designated_bridge.addr, oldaddr))
-- 
2.31.1

