Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C45EDC51
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiI1MJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbiI1MJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:09:24 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE77965551
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 05:09:21 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4McwGH0gBqzHqLb;
        Wed, 28 Sep 2022 20:07:03 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 20:09:19 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>
Subject: [net-next v2] net: bonding: Convert to use sysfs_emit()/sysfs_emit_at() APIs
Date:   Wed, 28 Sep 2022 20:30:14 +0800
Message-ID: <1664368214-11462-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the value
to be returned to user space.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/bonding/bond_sysfs.c       | 106 ++++++++++++++++-----------------
 drivers/net/bonding/bond_sysfs_slave.c |  28 ++++-----
 2 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 9b5a5df..8996bd0 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -47,10 +47,10 @@ static ssize_t bonding_show_bonds(struct class *cls,
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buf + res, "++more++ ");
+			res += sysfs_emit_at(buf, res, "++more++ ");
 			break;
 		}
-		res += sprintf(buf + res, "%s ", bond->dev->name);
+		res += sysfs_emit_at(buf, res, "%s ", bond->dev->name);
 	}
 	if (res)
 		buf[res-1] = '\n'; /* eat the leftover space */
@@ -178,10 +178,10 @@ static ssize_t bonding_show_slaves(struct device *d,
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buf + res, "++more++ ");
+			res += sysfs_emit_at(buf, res, "++more++ ");
 			break;
 		}
-		res += sprintf(buf + res, "%s ", slave->dev->name);
+		res += sysfs_emit_at(buf, res, "%s ", slave->dev->name);
 	}
 
 	rtnl_unlock();
@@ -203,7 +203,7 @@ static ssize_t bonding_show_mode(struct device *d,
 
 	val = bond_opt_get_val(BOND_OPT_MODE, BOND_MODE(bond));
 
-	return sprintf(buf, "%s %d\n", val->string, BOND_MODE(bond));
+	return sysfs_emit(buf, "%s %d\n", val->string, BOND_MODE(bond));
 }
 static DEVICE_ATTR(mode, 0644, bonding_show_mode, bonding_sysfs_store_option);
 
@@ -217,7 +217,7 @@ static ssize_t bonding_show_xmit_hash(struct device *d,
 
 	val = bond_opt_get_val(BOND_OPT_XMIT_HASH, bond->params.xmit_policy);
 
-	return sprintf(buf, "%s %d\n", val->string, bond->params.xmit_policy);
+	return sysfs_emit(buf, "%s %d\n", val->string, bond->params.xmit_policy);
 }
 static DEVICE_ATTR(xmit_hash_policy, 0644,
 		   bonding_show_xmit_hash, bonding_sysfs_store_option);
@@ -233,7 +233,7 @@ static ssize_t bonding_show_arp_validate(struct device *d,
 	val = bond_opt_get_val(BOND_OPT_ARP_VALIDATE,
 			       bond->params.arp_validate);
 
-	return sprintf(buf, "%s %d\n", val->string, bond->params.arp_validate);
+	return sysfs_emit(buf, "%s %d\n", val->string, bond->params.arp_validate);
 }
 static DEVICE_ATTR(arp_validate, 0644, bonding_show_arp_validate,
 		   bonding_sysfs_store_option);
@@ -248,7 +248,7 @@ static ssize_t bonding_show_arp_all_targets(struct device *d,
 
 	val = bond_opt_get_val(BOND_OPT_ARP_ALL_TARGETS,
 			       bond->params.arp_all_targets);
-	return sprintf(buf, "%s %d\n",
+	return sysfs_emit(buf, "%s %d\n",
 		       val->string, bond->params.arp_all_targets);
 }
 static DEVICE_ATTR(arp_all_targets, 0644,
@@ -265,7 +265,7 @@ static ssize_t bonding_show_fail_over_mac(struct device *d,
 	val = bond_opt_get_val(BOND_OPT_FAIL_OVER_MAC,
 			       bond->params.fail_over_mac);
 
-	return sprintf(buf, "%s %d\n", val->string, bond->params.fail_over_mac);
+	return sysfs_emit(buf, "%s %d\n", val->string, bond->params.fail_over_mac);
 }
 static DEVICE_ATTR(fail_over_mac, 0644,
 		   bonding_show_fail_over_mac, bonding_sysfs_store_option);
@@ -277,7 +277,7 @@ static ssize_t bonding_show_arp_interval(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.arp_interval);
+	return sysfs_emit(buf, "%d\n", bond->params.arp_interval);
 }
 static DEVICE_ATTR(arp_interval, 0644,
 		   bonding_show_arp_interval, bonding_sysfs_store_option);
@@ -292,8 +292,8 @@ static ssize_t bonding_show_arp_targets(struct device *d,
 
 	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
 		if (bond->params.arp_targets[i])
-			res += sprintf(buf + res, "%pI4 ",
-				       &bond->params.arp_targets[i]);
+			res += sysfs_emit_at(buf, res, "%pI4 ",
+					     &bond->params.arp_targets[i]);
 	}
 	if (res)
 		buf[res-1] = '\n'; /* eat the leftover space */
@@ -310,7 +310,7 @@ static ssize_t bonding_show_missed_max(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%u\n", bond->params.missed_max);
+	return sysfs_emit(buf, "%u\n", bond->params.missed_max);
 }
 static DEVICE_ATTR(arp_missed_max, 0644,
 		   bonding_show_missed_max, bonding_sysfs_store_option);
@@ -322,7 +322,7 @@ static ssize_t bonding_show_downdelay(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.downdelay * bond->params.miimon);
+	return sysfs_emit(buf, "%d\n", bond->params.downdelay * bond->params.miimon);
 }
 static DEVICE_ATTR(downdelay, 0644,
 		   bonding_show_downdelay, bonding_sysfs_store_option);
@@ -333,7 +333,7 @@ static ssize_t bonding_show_updelay(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.updelay * bond->params.miimon);
+	return sysfs_emit(buf, "%d\n", bond->params.updelay * bond->params.miimon);
 
 }
 static DEVICE_ATTR(updelay, 0644,
@@ -345,8 +345,8 @@ static ssize_t bonding_show_peer_notif_delay(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n",
-		       bond->params.peer_notif_delay * bond->params.miimon);
+	return sysfs_emit(buf, "%d\n",
+			  bond->params.peer_notif_delay * bond->params.miimon);
 }
 static DEVICE_ATTR(peer_notif_delay, 0644,
 		   bonding_show_peer_notif_delay, bonding_sysfs_store_option);
@@ -361,7 +361,7 @@ static ssize_t bonding_show_lacp_active(struct device *d,
 
 	val = bond_opt_get_val(BOND_OPT_LACP_ACTIVE, bond->params.lacp_active);
 
-	return sprintf(buf, "%s %d\n", val->string, bond->params.lacp_active);
+	return sysfs_emit(buf, "%s %d\n", val->string, bond->params.lacp_active);
 }
 static DEVICE_ATTR(lacp_active, 0644,
 		   bonding_show_lacp_active, bonding_sysfs_store_option);
@@ -375,7 +375,7 @@ static ssize_t bonding_show_lacp_rate(struct device *d,
 
 	val = bond_opt_get_val(BOND_OPT_LACP_RATE, bond->params.lacp_fast);
 
-	return sprintf(buf, "%s %d\n", val->string, bond->params.lacp_fast);
+	return sysfs_emit(buf, "%s %d\n", val->string, bond->params.lacp_fast);
 }
 static DEVICE_ATTR(lacp_rate, 0644,
 		   bonding_show_lacp_rate, bonding_sysfs_store_option);
@@ -386,7 +386,7 @@ static ssize_t bonding_show_min_links(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%u\n", bond->params.min_links);
+	return sysfs_emit(buf, "%u\n", bond->params.min_links);
 }
 static DEVICE_ATTR(min_links, 0644,
 		   bonding_show_min_links, bonding_sysfs_store_option);
@@ -400,7 +400,7 @@ static ssize_t bonding_show_ad_select(struct device *d,
 
 	val = bond_opt_get_val(BOND_OPT_AD_SELECT, bond->params.ad_select);
 
-	return sprintf(buf, "%s %d\n", val->string, bond->params.ad_select);
+	return sysfs_emit(buf, "%s %d\n", val->string, bond->params.ad_select);
 }
 static DEVICE_ATTR(ad_select, 0644,
 		   bonding_show_ad_select, bonding_sysfs_store_option);
@@ -412,7 +412,7 @@ static ssize_t bonding_show_num_peer_notif(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.num_peer_notif);
+	return sysfs_emit(buf, "%d\n", bond->params.num_peer_notif);
 }
 static DEVICE_ATTR(num_grat_arp, 0644,
 		   bonding_show_num_peer_notif, bonding_sysfs_store_option);
@@ -426,7 +426,7 @@ static ssize_t bonding_show_miimon(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.miimon);
+	return sysfs_emit(buf, "%d\n", bond->params.miimon);
 }
 static DEVICE_ATTR(miimon, 0644,
 		   bonding_show_miimon, bonding_sysfs_store_option);
@@ -443,7 +443,7 @@ static ssize_t bonding_show_primary(struct device *d,
 	rcu_read_lock();
 	primary = rcu_dereference(bond->primary_slave);
 	if (primary)
-		count = sprintf(buf, "%s\n", primary->dev->name);
+		count = sysfs_emit(buf, "%s\n", primary->dev->name);
 	rcu_read_unlock();
 
 	return count;
@@ -462,8 +462,8 @@ static ssize_t bonding_show_primary_reselect(struct device *d,
 	val = bond_opt_get_val(BOND_OPT_PRIMARY_RESELECT,
 			       bond->params.primary_reselect);
 
-	return sprintf(buf, "%s %d\n",
-		       val->string, bond->params.primary_reselect);
+	return sysfs_emit(buf, "%s %d\n",
+			  val->string, bond->params.primary_reselect);
 }
 static DEVICE_ATTR(primary_reselect, 0644,
 		   bonding_show_primary_reselect, bonding_sysfs_store_option);
@@ -475,7 +475,7 @@ static ssize_t bonding_show_carrier(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.use_carrier);
+	return sysfs_emit(buf, "%d\n", bond->params.use_carrier);
 }
 static DEVICE_ATTR(use_carrier, 0644,
 		   bonding_show_carrier, bonding_sysfs_store_option);
@@ -493,7 +493,7 @@ static ssize_t bonding_show_active_slave(struct device *d,
 	rcu_read_lock();
 	slave_dev = bond_option_active_slave_get_rcu(bond);
 	if (slave_dev)
-		count = sprintf(buf, "%s\n", slave_dev->name);
+		count = sysfs_emit(buf, "%s\n", slave_dev->name);
 	rcu_read_unlock();
 
 	return count;
@@ -509,7 +509,7 @@ static ssize_t bonding_show_mii_status(struct device *d,
 	struct bonding *bond = to_bond(d);
 	bool active = netif_carrier_ok(bond->dev);
 
-	return sprintf(buf, "%s\n", active ? "up" : "down");
+	return sysfs_emit(buf, "%s\n", active ? "up" : "down");
 }
 static DEVICE_ATTR(mii_status, 0444, bonding_show_mii_status, NULL);
 
@@ -524,9 +524,9 @@ static ssize_t bonding_show_ad_aggregator(struct device *d,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
 
-		count = sprintf(buf, "%d\n",
-				bond_3ad_get_active_agg_info(bond, &ad_info)
-				?  0 : ad_info.aggregator_id);
+		count = sysfs_emit(buf, "%d\n",
+				   bond_3ad_get_active_agg_info(bond, &ad_info)
+				   ?  0 : ad_info.aggregator_id);
 	}
 
 	return count;
@@ -545,9 +545,9 @@ static ssize_t bonding_show_ad_num_ports(struct device *d,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
 
-		count = sprintf(buf, "%d\n",
-				bond_3ad_get_active_agg_info(bond, &ad_info)
-				?  0 : ad_info.ports);
+		count = sysfs_emit(buf, "%d\n",
+				   bond_3ad_get_active_agg_info(bond, &ad_info)
+				   ?  0 : ad_info.ports);
 	}
 
 	return count;
@@ -566,9 +566,9 @@ static ssize_t bonding_show_ad_actor_key(struct device *d,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN)) {
 		struct ad_info ad_info;
 
-		count = sprintf(buf, "%d\n",
-				bond_3ad_get_active_agg_info(bond, &ad_info)
-				?  0 : ad_info.actor_key);
+		count = sysfs_emit(buf, "%d\n",
+				   bond_3ad_get_active_agg_info(bond, &ad_info)
+				   ?  0 : ad_info.actor_key);
 	}
 
 	return count;
@@ -587,9 +587,9 @@ static ssize_t bonding_show_ad_partner_key(struct device *d,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN)) {
 		struct ad_info ad_info;
 
-		count = sprintf(buf, "%d\n",
-				bond_3ad_get_active_agg_info(bond, &ad_info)
-				?  0 : ad_info.partner_key);
+		count = sysfs_emit(buf, "%d\n",
+				   bond_3ad_get_active_agg_info(bond, &ad_info)
+				   ?  0 : ad_info.partner_key);
 	}
 
 	return count;
@@ -609,7 +609,7 @@ static ssize_t bonding_show_ad_partner_mac(struct device *d,
 		struct ad_info ad_info;
 
 		if (!bond_3ad_get_active_agg_info(bond, &ad_info))
-			count = sprintf(buf, "%pM\n", ad_info.partner_system);
+			count = sysfs_emit(buf, "%pM\n", ad_info.partner_system);
 	}
 
 	return count;
@@ -634,11 +634,11 @@ static ssize_t bonding_show_queue_id(struct device *d,
 			/* not enough space for another interface_name:queue_id pair */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buf + res, "++more++ ");
+			res += sysfs_emit_at(buf, res, "++more++ ");
 			break;
 		}
-		res += sprintf(buf + res, "%s:%d ",
-			       slave->dev->name, slave->queue_id);
+		res += sysfs_emit_at(buf, res, "%s:%d ",
+				     slave->dev->name, slave->queue_id);
 	}
 	if (res)
 		buf[res-1] = '\n'; /* eat the leftover space */
@@ -658,7 +658,7 @@ static ssize_t bonding_show_slaves_active(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.all_slaves_active);
+	return sysfs_emit(buf, "%d\n", bond->params.all_slaves_active);
 }
 static DEVICE_ATTR(all_slaves_active, 0644,
 		   bonding_show_slaves_active, bonding_sysfs_store_option);
@@ -670,7 +670,7 @@ static ssize_t bonding_show_resend_igmp(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.resend_igmp);
+	return sysfs_emit(buf, "%d\n", bond->params.resend_igmp);
 }
 static DEVICE_ATTR(resend_igmp, 0644,
 		   bonding_show_resend_igmp, bonding_sysfs_store_option);
@@ -682,7 +682,7 @@ static ssize_t bonding_show_lp_interval(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.lp_interval);
+	return sysfs_emit(buf, "%d\n", bond->params.lp_interval);
 }
 static DEVICE_ATTR(lp_interval, 0644,
 		   bonding_show_lp_interval, bonding_sysfs_store_option);
@@ -693,7 +693,7 @@ static ssize_t bonding_show_tlb_dynamic_lb(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.tlb_dynamic_lb);
+	return sysfs_emit(buf, "%d\n", bond->params.tlb_dynamic_lb);
 }
 static DEVICE_ATTR(tlb_dynamic_lb, 0644,
 		   bonding_show_tlb_dynamic_lb, bonding_sysfs_store_option);
@@ -705,7 +705,7 @@ static ssize_t bonding_show_packets_per_slave(struct device *d,
 	struct bonding *bond = to_bond(d);
 	unsigned int packets_per_slave = bond->params.packets_per_slave;
 
-	return sprintf(buf, "%u\n", packets_per_slave);
+	return sysfs_emit(buf, "%u\n", packets_per_slave);
 }
 static DEVICE_ATTR(packets_per_slave, 0644,
 		   bonding_show_packets_per_slave, bonding_sysfs_store_option);
@@ -717,7 +717,7 @@ static ssize_t bonding_show_ad_actor_sys_prio(struct device *d,
 	struct bonding *bond = to_bond(d);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN))
-		return sprintf(buf, "%hu\n", bond->params.ad_actor_sys_prio);
+		return sysfs_emit(buf, "%hu\n", bond->params.ad_actor_sys_prio);
 
 	return 0;
 }
@@ -731,7 +731,7 @@ static ssize_t bonding_show_ad_actor_system(struct device *d,
 	struct bonding *bond = to_bond(d);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN))
-		return sprintf(buf, "%pM\n", bond->params.ad_actor_system);
+		return sysfs_emit(buf, "%pM\n", bond->params.ad_actor_system);
 
 	return 0;
 }
@@ -746,7 +746,7 @@ static ssize_t bonding_show_ad_user_port_key(struct device *d,
 	struct bonding *bond = to_bond(d);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD && capable(CAP_NET_ADMIN))
-		return sprintf(buf, "%hu\n", bond->params.ad_user_port_key);
+		return sysfs_emit(buf, "%hu\n", bond->params.ad_user_port_key);
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 69b0a37..313866f 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -22,30 +22,30 @@ static ssize_t state_show(struct slave *slave, char *buf)
 {
 	switch (bond_slave_state(slave)) {
 	case BOND_STATE_ACTIVE:
-		return sprintf(buf, "active\n");
+		return sysfs_emit(buf, "active\n");
 	case BOND_STATE_BACKUP:
-		return sprintf(buf, "backup\n");
+		return sysfs_emit(buf, "backup\n");
 	default:
-		return sprintf(buf, "UNKNOWN\n");
+		return sysfs_emit(buf, "UNKNOWN\n");
 	}
 }
 static SLAVE_ATTR_RO(state);
 
 static ssize_t mii_status_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%s\n", bond_slave_link_status(slave->link));
+	return sysfs_emit(buf, "%s\n", bond_slave_link_status(slave->link));
 }
 static SLAVE_ATTR_RO(mii_status);
 
 static ssize_t link_failure_count_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%d\n", slave->link_failure_count);
+	return sysfs_emit(buf, "%d\n", slave->link_failure_count);
 }
 static SLAVE_ATTR_RO(link_failure_count);
 
 static ssize_t perm_hwaddr_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%*phC\n",
+	return sysfs_emit(buf, "%*phC\n",
 		       slave->dev->addr_len,
 		       slave->perm_hwaddr);
 }
@@ -53,7 +53,7 @@ static ssize_t perm_hwaddr_show(struct slave *slave, char *buf)
 
 static ssize_t queue_id_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%d\n", slave->queue_id);
+	return sysfs_emit(buf, "%d\n", slave->queue_id);
 }
 static SLAVE_ATTR_RO(queue_id);
 
@@ -64,11 +64,11 @@ static ssize_t ad_aggregator_id_show(struct slave *slave, char *buf)
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
 		agg = SLAVE_AD_INFO(slave)->port.aggregator;
 		if (agg)
-			return sprintf(buf, "%d\n",
-				       agg->aggregator_identifier);
+			return sysfs_emit(buf, "%d\n",
+					  agg->aggregator_identifier);
 	}
 
-	return sprintf(buf, "N/A\n");
+	return sysfs_emit(buf, "N/A\n");
 }
 static SLAVE_ATTR_RO(ad_aggregator_id);
 
@@ -79,11 +79,11 @@ static ssize_t ad_actor_oper_port_state_show(struct slave *slave, char *buf)
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
 		ad_port = &SLAVE_AD_INFO(slave)->port;
 		if (ad_port->aggregator)
-			return sprintf(buf, "%u\n",
+			return sysfs_emit(buf, "%u\n",
 				       ad_port->actor_oper_port_state);
 	}
 
-	return sprintf(buf, "N/A\n");
+	return sysfs_emit(buf, "N/A\n");
 }
 static SLAVE_ATTR_RO(ad_actor_oper_port_state);
 
@@ -94,11 +94,11 @@ static ssize_t ad_partner_oper_port_state_show(struct slave *slave, char *buf)
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
 		ad_port = &SLAVE_AD_INFO(slave)->port;
 		if (ad_port->aggregator)
-			return sprintf(buf, "%u\n",
+			return sysfs_emit(buf, "%u\n",
 				       ad_port->partner_oper.port_state);
 	}
 
-	return sprintf(buf, "N/A\n");
+	return sysfs_emit(buf, "N/A\n");
 }
 static SLAVE_ATTR_RO(ad_partner_oper_port_state);
 
-- 
1.8.3.1

