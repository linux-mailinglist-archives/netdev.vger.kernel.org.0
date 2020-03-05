Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F4817AEFB
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 20:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgCETbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 14:31:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:58932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCETbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 14:31:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E377AC58;
        Thu,  5 Mar 2020 19:31:02 +0000 (UTC)
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 5F9CD20ED8; Thu,  5 Mar 2020 20:31:01 +0100 (CET)
Date:   Thu, 5 Mar 2020 20:31:01 +0100
From:   Jiri Wiesner <jwiesner@suse.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Andreas Taschner <Andreas.Taschner@suse.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ipvlan: do not add hardware address of master to its
 unicast filter list
Message-ID: <20200305193101.GA16264@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ipvlan/ipvlan_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index a70662261a5a..f23214003d42 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -178,7 +178,7 @@ static int ipvlan_open(struct net_device *dev)
 		ipvlan_ht_addr_add(ipvlan, addr);
 	rcu_read_unlock();
 
-	return dev_uc_add(phy_dev, phy_dev->dev_addr);
+	return 0;
 }
 
 static int ipvlan_stop(struct net_device *dev)
@@ -190,8 +190,6 @@ static int ipvlan_stop(struct net_device *dev)
 	dev_uc_unsync(phy_dev, dev);
 	dev_mc_unsync(phy_dev, dev);
 
-	dev_uc_del(phy_dev, phy_dev->dev_addr);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(addr, &ipvlan->addrs, anode)
 		ipvlan_ht_addr_del(addr);
-- 
2.16.4

