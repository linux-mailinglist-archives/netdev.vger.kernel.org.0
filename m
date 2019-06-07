Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B1838E36
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbfFGPAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:00:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfFGPAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:00:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DBB3C3078ABD;
        Fri,  7 Jun 2019 15:00:17 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFE0282F5D;
        Fri,  7 Jun 2019 15:00:14 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 6/7] bonding/alb: convert to using slave printk macros
Date:   Fri,  7 Jun 2019 10:59:31 -0400
Message-Id: <20190607145933.37058-7-jarod@redhat.com>
In-Reply-To: <20190607145933.37058-1-jarod@redhat.com>
References: <20190607145933.37058-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 07 Jun 2019 15:00:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of these printk instances benefit from having both master and slave
device information included, so convert to using a standardized macro
format and remove redundant information.

Suggested-by: Joe Perches <joe@perches.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_alb.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 790e41c6fdd0..8c79bad2a9a5 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -300,7 +300,7 @@ static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* update rx hash table for this ARP */
 		rlb_update_entry_from_arp(bond, arp);
-		netdev_dbg(bond->dev, "Server received an ARP Reply from client\n");
+		slave_dbg(bond->dev, slave->dev, "Server received an ARP Reply from client\n");
 	}
 out:
 	return RX_HANDLER_ANOTHER;
@@ -442,8 +442,9 @@ static void rlb_update_client(struct rlb_client_info *client_info)
 				 client_info->slave->dev->dev_addr,
 				 client_info->mac_dst);
 		if (!skb) {
-			netdev_err(client_info->slave->bond->dev,
-				   "failed to create an ARP packet\n");
+			slave_err(client_info->slave->bond->dev,
+				  client_info->slave->dev,
+				  "failed to create an ARP packet\n");
 			continue;
 		}
 
@@ -667,14 +668,15 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 		if (tx_slave)
 			bond_hw_addr_copy(arp->mac_src, tx_slave->dev->dev_addr,
 					  tx_slave->dev->addr_len);
-		netdev_dbg(bond->dev, "Server sent ARP Reply packet\n");
+		netdev_dbg(bond->dev, "(slave %s): Server sent ARP Reply packet\n",
+			   tx_slave ? tx_slave->dev->name : "NULL");
 	} else if (arp->op_code == htons(ARPOP_REQUEST)) {
 		/* Create an entry in the rx_hashtbl for this client as a
 		 * place holder.
 		 * When the arp reply is received the entry will be updated
 		 * with the correct unicast address of the client.
 		 */
-		rlb_choose_channel(skb, bond);
+		tx_slave = rlb_choose_channel(skb, bond);
 
 		/* The ARP reply packets must be delayed so that
 		 * they can cancel out the influence of the ARP request.
@@ -687,7 +689,8 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 		 * updated with their assigned mac.
 		 */
 		rlb_req_update_subnet_clients(bond, arp->ip_src);
-		netdev_dbg(bond->dev, "Server sent ARP Request packet\n");
+		netdev_dbg(bond->dev, "(slave %s): Server sent ARP Request packet\n",
+			   tx_slave ? tx_slave->dev->name : "NULL");
 	}
 
 	return tx_slave;
@@ -923,9 +926,8 @@ static void alb_send_lp_vid(struct slave *slave, u8 mac_addr[],
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = slave->dev;
 
-	netdev_dbg(slave->bond->dev,
-		   "Send learning packet: dev %s mac %pM vlan %d\n",
-		   slave->dev->name, mac_addr, vid);
+	slave_dbg(slave->bond->dev, slave->dev,
+		  "Send learning packet: mac %pM vlan %d\n", mac_addr, vid);
 
 	if (vid)
 		__vlan_hwaccel_put_tag(skb, vlan_proto, vid);
@@ -1016,8 +1018,7 @@ static int alb_set_slave_mac_addr(struct slave *slave, u8 addr[],
 	memcpy(ss.__data, addr, len);
 	ss.ss_family = dev->type;
 	if (dev_set_mac_address(dev, (struct sockaddr *)&ss, NULL)) {
-		netdev_err(slave->bond->dev, "dev_set_mac_address of dev %s failed! ALB mode requires that the base driver support setting the hw address also when the network device's interface is open\n",
-			   dev->name);
+		slave_err(slave->bond->dev, dev, "dev_set_mac_address on slave failed! ALB mode requires that the base driver support setting the hw address also when the network device's interface is open\n");
 		return -EOPNOTSUPP;
 	}
 	return 0;
@@ -1192,12 +1193,11 @@ static int alb_handle_addr_collision_on_attach(struct bonding *bond, struct slav
 		alb_set_slave_mac_addr(slave, free_mac_slave->perm_hwaddr,
 				       free_mac_slave->dev->addr_len);
 
-		netdev_warn(bond->dev, "the hw address of slave %s is in use by the bond; giving it the hw address of %s\n",
-			    slave->dev->name, free_mac_slave->dev->name);
+		slave_warn(bond->dev, slave->dev, "the slave hw address is in use by the bond; giving it the hw address of %s\n",
+			   free_mac_slave->dev->name);
 
 	} else if (has_bond_addr) {
-		netdev_err(bond->dev, "the hw address of slave %s is in use by the bond; couldn't find a slave with a free hw address to give it (this should not have happened)\n",
-			   slave->dev->name);
+		slave_err(bond->dev, slave->dev, "the slave hw address is in use by the bond; couldn't find a slave with a free hw address to give it (this should not have happened)\n");
 		return -EFAULT;
 	}
 
-- 
2.20.1

