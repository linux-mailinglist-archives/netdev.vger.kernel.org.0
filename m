Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5852618A5A9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgCRUzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgCRUzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72EB208DB;
        Wed, 18 Mar 2020 20:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564938;
        bh=PCQiCcLpjOfTjr2w4cHvIxBjxX8NXcJ9mXahb2ETR8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CZk27v5Hizcf+vaPfM1MaaQmMY0mh78baAgcNFU/kT7Vknq/dyB/4Sfb3XZmN8am
         hewM2OzyUVBbRCU649sJoYq8NR2jFPRXxePCSDB9KQRNUIZGCEiHq2qP7mUkjLsbi2
         kzcQztzqLzLO9WnmuNQNaQk+Z+uCA28gj6J8yYCY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Wiesner <jwiesner@suse.com>,
        Per Sundstrom <per.sundstrom@redqube.se>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/37] ipvlan: do not add hardware address of master to its unicast filter list
Date:   Wed, 18 Mar 2020 16:54:56 -0400
Message-Id: <20200318205509.17053-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>

[ Upstream commit 63aae7b17344d4b08a7d05cb07044de4c0f9dcc6 ]

There is a problem when ipvlan slaves are created on a master device that
is a vmxnet3 device (ipvlan in VMware guests). The vmxnet3 driver does not
support unicast address filtering. When an ipvlan device is brought up in
ipvlan_open(), the ipvlan driver calls dev_uc_add() to add the hardware
address of the vmxnet3 master device to the unicast address list of the
master device, phy_dev->uc. This inevitably leads to the vmxnet3 master
device being forced into promiscuous mode by __dev_set_rx_mode().

Promiscuous mode is switched on the master despite the fact that there is
still only one hardware address that the master device should use for
filtering in order for the ipvlan device to be able to receive packets.
The comment above struct net_device describes the uc_promisc member as a
"counter, that indicates, that promiscuous mode has been enabled due to
the need to listen to additional unicast addresses in a device that does
not implement ndo_set_rx_mode()". Moreover, the design of ipvlan
guarantees that only the hardware address of a master device,
phy_dev->dev_addr, will be used to transmit and receive all packets from
its ipvlan slaves. Thus, the unicast address list of the master device
should not be modified by ipvlan_open() and ipvlan_stop() in order to make
ipvlan a workable option on masters that do not support unicast address
filtering.

Fixes: 2ad7bf3638411 ("ipvlan: Initial check-in of the IPVLAN driver")
Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 0115a2868933c..87f605a33c37a 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -236,7 +236,6 @@ static void ipvlan_uninit(struct net_device *dev)
 static int ipvlan_open(struct net_device *dev)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
-	struct net_device *phy_dev = ipvlan->phy_dev;
 	struct ipvl_addr *addr;
 
 	if (ipvlan->port->mode == IPVLAN_MODE_L3 ||
@@ -250,7 +249,7 @@ static int ipvlan_open(struct net_device *dev)
 		ipvlan_ht_addr_add(ipvlan, addr);
 	rcu_read_unlock();
 
-	return dev_uc_add(phy_dev, phy_dev->dev_addr);
+	return 0;
 }
 
 static int ipvlan_stop(struct net_device *dev)
@@ -262,8 +261,6 @@ static int ipvlan_stop(struct net_device *dev)
 	dev_uc_unsync(phy_dev, dev);
 	dev_mc_unsync(phy_dev, dev);
 
-	dev_uc_del(phy_dev, phy_dev->dev_addr);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(addr, &ipvlan->addrs, anode)
 		ipvlan_ht_addr_del(addr);
-- 
2.20.1

