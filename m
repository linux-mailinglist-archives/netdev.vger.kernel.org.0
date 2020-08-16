Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AE1245905
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgHPSwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:52:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:59692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgHPSws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 14:52:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4DA1DAC4C;
        Sun, 16 Aug 2020 18:53:10 +0000 (UTC)
Received: by incl.suse.cz (Postfix, from userid 1000)
        id B5F662B667; Sun, 16 Aug 2020 20:52:44 +0200 (CEST)
Date:   Sun, 16 Aug 2020 20:52:44 +0200
From:   Jiri Wiesner <jwiesner@suse.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Taschner <Andreas.Taschner@suse.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] bonding: fix active-backup failover for current ARP slave
Message-ID: <20200816185244.GA31426@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ARP monitor is used for link detection, ARP replies are
validated for all slaves (arp_validate=3) and fail_over_mac is set to
active, two slaves of an active-backup bond may get stuck in a state
where both of them are active and pass packets that they receive to
the bond. This state makes IPv6 duplicate address detection fail. The
state is reached thus:
1. The current active slave goes down because the ARP target
   is not reachable.
2. The current ARP slave is chosen and made active.
3. A new slave is enslaved. This new slave becomes the current active
   slave and can reach the ARP target.
As a result, the current ARP slave stays active after the enslave
action has finished and the log is littered with "PROBE BAD" messages:
> bond0: PROBE: c_arp ens10 && cas ens11 BAD
The workaround is to remove the slave with "going back" status from
the bond and re-enslave it. This issue was encountered when DPDK PMD
interfaces were being enslaved to an active-backup bond.

I would be possible to fix the issue in bond_enslave() or
bond_change_active_slave() but the ARP monitor was fixed instead to
keep most of the actions changing the current ARP slave in the ARP
monitor code. The current ARP slave is set as inactive and backup
during the commit phase. A new state, BOND_LINK_FAIL, has been
introduced for slaves in the context of the ARP monitor. This allows
administrators to see how slaves are rotated for sending ARP requests
and attempts are made to find a new active slave.

Fixes: b2220cad583c9 ("bonding: refactor ARP active-backup monitor")
Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
---
 drivers/net/bonding/bond_main.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c853ca67058c..0ee59ea357f5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2945,6 +2945,9 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 			if (bond_time_in_interval(bond, last_rx, 1)) {
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
+			} else if (slave->link == BOND_LINK_BACK) {
+				bond_propose_link_state(slave, BOND_LINK_FAIL);
+				commit++;
 			}
 			continue;
 		}
@@ -3053,6 +3056,19 @@ static void bond_ab_arp_commit(struct bonding *bond)
 
 			continue;
 
+		case BOND_LINK_FAIL:
+			bond_set_slave_link_state(slave, BOND_LINK_FAIL,
+						  BOND_SLAVE_NOTIFY_NOW);
+			bond_set_slave_inactive_flags(slave,
+						      BOND_SLAVE_NOTIFY_NOW);
+
+			/* A slave has just been enslaved and has become
+			 * the current active slave.
+			 */
+			if (rtnl_dereference(bond->curr_active_slave))
+				RCU_INIT_POINTER(bond->current_arp_slave, NULL);
+			continue;
+
 		default:
 			slave_err(bond->dev, slave->dev,
 				  "impossible: link_new_state %d on slave\n",
@@ -3103,8 +3119,6 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 			return should_notify_rtnl;
 	}
 
-	bond_set_slave_inactive_flags(curr_arp_slave, BOND_SLAVE_NOTIFY_LATER);
-
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (!found && !before && bond_slave_is_up(slave))
 			before = slave;
-- 
2.26.2

