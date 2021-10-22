Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1828D438091
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhJVXX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231712AbhJVXX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 192FF61038;
        Fri, 22 Oct 2021 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944870;
        bh=LEPCiB4pxuxO5v/DCdVzvPTqp4poqFz93p4+GrFC8Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xl6t2+l54iTKSXnu5STBNIUJ9EWRkqC8AQTTRTF13NAMfowJRX007Y9K7XN885thR
         MbqN9apDSTSbcSbiWkUPi9ppsx9g8U19MKSTs0IVLMGTKHeue6qPjR7zm0ot2acPeZ
         9Sw+33WXKprnOSrPaPJYzDIXuNBT9eTQSzgwIgqiT8DL1T3J6LfJES2cP45Vn+nq/u
         Z1VT58XSjAXO6iUAvqs5Ym3myxtpsEdoyOosbOO9ldYVjhFn9oPiR1lNNI/xx7MnZN
         YSEU0xmIOgwkhKAQEE6qD8kMwRRnDVnsufIz0K+DhLUf1Asptykb3hvKLBBIrfYrkf
         plziKpUd+8SXg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: [PATCH net-next v2 4/8] net: bonding: constify and use dev_addr_set()
Date:   Fri, 22 Oct 2021 16:20:59 -0700
Message-Id: <20211022232103.2715312-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
References: <20211022232103.2715312-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Make sure local references to netdev->dev_addr are constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: j.vosburgh@gmail.com
CC: vfalico@gmail.com
CC: andy@greyhouse.net
---
 drivers/net/bonding/bond_alb.c  | 28 +++++++++++++---------------
 drivers/net/bonding/bond_main.c |  2 +-
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 7d3752cbf761..2ec8e015c7b3 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -50,7 +50,7 @@ struct arp_pkt {
 #pragma pack()
 
 /* Forward declaration */
-static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
+static void alb_send_learning_packets(struct slave *slave, const u8 mac_addr[],
 				      bool strict_match);
 static void rlb_purge_src_ip(struct bonding *bond, struct arp_pkt *arp);
 static void rlb_src_unlink(struct bonding *bond, u32 index);
@@ -353,7 +353,8 @@ static struct slave *rlb_next_rx_slave(struct bonding *bond)
  *
  * Caller must hold RTNL
  */
-static void rlb_teach_disabled_mac_on_primary(struct bonding *bond, u8 addr[])
+static void rlb_teach_disabled_mac_on_primary(struct bonding *bond,
+					      const u8 addr[])
 {
 	struct slave *curr_active = rtnl_dereference(bond->curr_active_slave);
 
@@ -904,7 +905,7 @@ static void rlb_clear_vlan(struct bonding *bond, unsigned short vlan_id)
 
 /*********************** tlb/rlb shared functions *********************/
 
-static void alb_send_lp_vid(struct slave *slave, u8 mac_addr[],
+static void alb_send_lp_vid(struct slave *slave, const u8 mac_addr[],
 			    __be16 vlan_proto, u16 vid)
 {
 	struct learning_pkt pkt;
@@ -940,7 +941,7 @@ static void alb_send_lp_vid(struct slave *slave, u8 mac_addr[],
 struct alb_walk_data {
 	struct bonding *bond;
 	struct slave *slave;
-	u8 *mac_addr;
+	const u8 *mac_addr;
 	bool strict_match;
 };
 
@@ -949,9 +950,9 @@ static int alb_upper_dev_walk(struct net_device *upper,
 {
 	struct alb_walk_data *data = (struct alb_walk_data *)priv->data;
 	bool strict_match = data->strict_match;
+	const u8 *mac_addr = data->mac_addr;
 	struct bonding *bond = data->bond;
 	struct slave *slave = data->slave;
-	u8 *mac_addr = data->mac_addr;
 	struct bond_vlan_tag *tags;
 
 	if (is_vlan_dev(upper) &&
@@ -982,7 +983,7 @@ static int alb_upper_dev_walk(struct net_device *upper,
 	return 0;
 }
 
-static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
+static void alb_send_learning_packets(struct slave *slave, const u8 mac_addr[],
 				      bool strict_match)
 {
 	struct bonding *bond = bond_get_bond_by_slave(slave);
@@ -1006,14 +1007,14 @@ static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
 	rcu_read_unlock();
 }
 
-static int alb_set_slave_mac_addr(struct slave *slave, u8 addr[],
+static int alb_set_slave_mac_addr(struct slave *slave, const u8 addr[],
 				  unsigned int len)
 {
 	struct net_device *dev = slave->dev;
 	struct sockaddr_storage ss;
 
 	if (BOND_MODE(slave->bond) == BOND_MODE_TLB) {
-		memcpy(dev->dev_addr, addr, len);
+		__dev_addr_set(dev, addr, len);
 		return 0;
 	}
 
@@ -1242,8 +1243,7 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 		res = dev_set_mac_address(slave->dev, addr, NULL);
 
 		/* restore net_device's hw address */
-		bond_hw_addr_copy(slave->dev->dev_addr, tmp_addr,
-				  slave->dev->addr_len);
+		dev_addr_set(slave->dev, tmp_addr);
 
 		if (res)
 			goto unwind;
@@ -1263,8 +1263,7 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 				  rollback_slave->dev->addr_len);
 		dev_set_mac_address(rollback_slave->dev,
 				    (struct sockaddr *)&ss, NULL);
-		bond_hw_addr_copy(rollback_slave->dev->dev_addr, tmp_addr,
-				  rollback_slave->dev->addr_len);
+		dev_addr_set(rollback_slave->dev, tmp_addr);
 	}
 
 	return res;
@@ -1727,8 +1726,7 @@ void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave
 		dev_set_mac_address(new_slave->dev, (struct sockaddr *)&ss,
 				    NULL);
 
-		bond_hw_addr_copy(new_slave->dev->dev_addr, tmp_addr,
-				  new_slave->dev->addr_len);
+		dev_addr_set(new_slave->dev, tmp_addr);
 	}
 
 	/* curr_active_slave must be set before calling alb_swap_mac_addr */
@@ -1761,7 +1759,7 @@ int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr)
 	if (res)
 		return res;
 
-	bond_hw_addr_copy(bond_dev->dev_addr, ss->__data, bond_dev->addr_len);
+	dev_addr_set(bond_dev, ss->__data);
 
 	/* If there is no curr_active_slave there is nothing else to do.
 	 * Otherwise we'll need to pass the new address to it and handle
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0c52612cb8e9..ff8da720a33a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -923,7 +923,7 @@ static int bond_set_dev_addr(struct net_device *bond_dev,
 	if (err)
 		return err;
 
-	memcpy(bond_dev->dev_addr, slave_dev->dev_addr, slave_dev->addr_len);
+	__dev_addr_set(bond_dev, slave_dev->dev_addr, slave_dev->addr_len);
 	bond_dev->addr_assign_type = NET_ADDR_STOLEN;
 	call_netdevice_notifiers(NETDEV_CHANGEADDR, bond_dev);
 	return 0;
-- 
2.31.1

