Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA9438E38
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfFGPAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729522AbfFGPAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:00:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C74DF307D855;
        Fri,  7 Jun 2019 15:00:18 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06C2F82F5D;
        Fri,  7 Jun 2019 15:00:17 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 7/7] bonding/options: convert to using slave printk macros
Date:   Fri,  7 Jun 2019 10:59:32 -0400
Message-Id: <20190607145933.37058-8-jarod@redhat.com>
In-Reply-To: <20190607145933.37058-1-jarod@redhat.com>
References: <20190607145933.37058-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 07 Jun 2019 15:00:18 +0000 (UTC)
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
 drivers/net/bonding/bond_options.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index b996967af8d9..c9eaf5b59654 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -787,14 +787,12 @@ static int bond_option_active_slave_set(struct bonding *bond,
 
 	if (slave_dev) {
 		if (!netif_is_bond_slave(slave_dev)) {
-			netdev_err(bond->dev, "Device %s is not bonding slave\n",
-				   slave_dev->name);
+			slave_err(bond->dev, slave_dev, "Device is not bonding slave\n");
 			return -EINVAL;
 		}
 
 		if (bond->dev != netdev_master_upper_dev_get(slave_dev)) {
-			netdev_err(bond->dev, "Device %s is not our slave\n",
-				   slave_dev->name);
+			slave_err(bond->dev, slave_dev, "Device is not our slave\n");
 			return -EINVAL;
 		}
 	}
@@ -813,18 +811,15 @@ static int bond_option_active_slave_set(struct bonding *bond,
 
 		if (new_active == old_active) {
 			/* do nothing */
-			netdev_dbg(bond->dev, "%s is already the current active slave\n",
-				   new_active->dev->name);
+			slave_dbg(bond->dev, new_active->dev, "is already the current active slave\n");
 		} else {
 			if (old_active && (new_active->link == BOND_LINK_UP) &&
 			    bond_slave_is_up(new_active)) {
-				netdev_dbg(bond->dev, "Setting %s as active slave\n",
-					   new_active->dev->name);
+				slave_dbg(bond->dev, new_active->dev, "Setting as active slave\n");
 				bond_change_active_slave(bond, new_active);
 			} else {
-				netdev_err(bond->dev, "Could not set %s as active slave; either %s is down or the link is down\n",
-					   new_active->dev->name,
-					   new_active->dev->name);
+				slave_err(bond->dev, new_active->dev, "Could not set as active slave; either %s is down or the link is down\n",
+					  new_active->dev->name);
 				ret = -EINVAL;
 			}
 		}
@@ -1136,8 +1131,7 @@ static int bond_option_primary_set(struct bonding *bond,
 
 	bond_for_each_slave(bond, slave, iter) {
 		if (strncmp(slave->dev->name, primary, IFNAMSIZ) == 0) {
-			netdev_dbg(bond->dev, "Setting %s as primary slave\n",
-				   slave->dev->name);
+			slave_dbg(bond->dev, slave->dev, "Setting as primary slave\n");
 			rcu_assign_pointer(bond->primary_slave, slave);
 			strcpy(bond->params.primary, slave->dev->name);
 			bond->force_primary = true;
@@ -1154,8 +1148,8 @@ static int bond_option_primary_set(struct bonding *bond,
 	strncpy(bond->params.primary, primary, IFNAMSIZ);
 	bond->params.primary[IFNAMSIZ - 1] = 0;
 
-	netdev_dbg(bond->dev, "Recording %s as primary, but it has not been enslaved to %s yet\n",
-		   primary, bond->dev->name);
+	netdev_dbg(bond->dev, "Recording %s as primary, but it has not been enslaved yet\n",
+		   primary);
 
 out:
 	unblock_netpoll_tx();
@@ -1382,12 +1376,12 @@ static int bond_option_slaves_set(struct bonding *bond,
 
 	switch (command[0]) {
 	case '+':
-		netdev_dbg(bond->dev, "Adding slave %s\n", dev->name);
+		slave_dbg(bond->dev, dev, "Enslaving interface\n");
 		ret = bond_enslave(bond->dev, dev, NULL);
 		break;
 
 	case '-':
-		netdev_dbg(bond->dev, "Removing slave %s\n", dev->name);
+		slave_dbg(bond->dev, dev, "Releasing interface\n");
 		ret = bond_release(bond->dev, dev);
 		break;
 
@@ -1451,7 +1445,7 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 	return 0;
 
 err:
-	netdev_err(bond->dev, "Invalid MAC address.\n");
+	netdev_err(bond->dev, "Invalid ad_actor_system MAC address.\n");
 	return -EINVAL;
 }
 
-- 
2.20.1

