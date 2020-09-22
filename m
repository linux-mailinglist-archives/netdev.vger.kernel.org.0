Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EED27434C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgIVNiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:38:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbgIVNiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7UBh2txzNciOwWT0oD5ed5uKbIsnrWhGepoeIRarhZo=;
        b=RhMJBGgRPjSeZRhNRXagZuf4dZ5mFqHIkBSUsaW9XQcm+jANPuJGe2X3odf5OWBpnN4Qtj
        Vb5Fcc6pcAOnDgK2hbvUXDY8Fg4UnKieURw5U2az3gikHERhzm2bezPs/v2eLTJq9MnocT
        KgX1H6mle+F3aVwV1K/+8w2czMJz6R4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-oK4Vn4xQM3-2vbe47NByCQ-1; Tue, 22 Sep 2020 09:38:18 -0400
X-MC-Unique: oK4Vn4xQM3-2vbe47NByCQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C10AAF206;
        Tue, 22 Sep 2020 13:38:09 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC6578808;
        Tue, 22 Sep 2020 13:38:08 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/5] bonding: make Kconfig toggle to disable legacy interfaces
Date:   Tue, 22 Sep 2020 09:37:30 -0400
Message-Id: <20200922133731.33478-5-jarod@redhat.com>
In-Reply-To: <20200922133731.33478-1-jarod@redhat.com>
References: <20200922133731.33478-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, enable retaining all user-facing API that includes the use of
master and slave, but add a Kconfig knob that allows those that wish to
remove it entirely do so in one shot.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/Kconfig                   | 12 ++++++++++++
 drivers/net/bonding/bond_options.c    |  4 ++--
 drivers/net/bonding/bond_procfs.c     | 14 ++++++++++----
 drivers/net/bonding/bond_sysfs.c      | 15 ++++++++++-----
 drivers/net/bonding/bond_sysfs_link.c | 12 ++++++++----
 include/net/bond_options.h            |  4 ++--
 include/net/bonding.h                 |  2 ++
 7 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c3dbe64e628e..3640694be34d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -56,6 +56,18 @@ config BONDING
 	  To compile this driver as a module, choose M here: the module
 	  will be called bonding.
 
+config BONDING_LEGACY_INTERFACES
+	default y
+	bool "Maintain legacy interface names"
+	help
+	  The bonding driver historically made use of the terms "master" and
+	  "slave" to describe it's component members. This has since been
+	  changed to "aggregator" and "link" as part of a broader effort to
+	  remove the use of socially problematic language from the kernel.
+	  However, removing all such cases requires breaking long-standing
+	  user-facing interfaces in /proc and /sys, which will not be done,
+	  unless you opt out of them here, by selecting 'N'.
+
 config DUMMY
 	tristate "Dummy net driver support"
 	help
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 437df9a207a6..7bf1a13a3c17 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -434,7 +434,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.values = bond_intmax_tbl,
 		.set = bond_option_peer_notif_delay_set
 	},
-/* legacy sysfs interface names */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	[BOND_OPT_PACKETS_PER_SLAVE] = {
 		.id = BOND_OPT_PACKETS_PER_SLAVE,
 		.name = "packets_per_slave",
@@ -474,7 +474,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_links_set
 	},
-/* end legacy sysfs interface names */
+#endif
 };
 
 /* Searches for an option by name */
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index abd265d6e975..91ece68607b2 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -7,6 +7,12 @@
 
 #include "bonding_priv.h"
 
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
+const char *linkdesc = "Slave";
+#else
+const char *linkdesc = "Link";
+#endif
+
 static void *bond_info_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
@@ -84,7 +90,7 @@ static void bond_info_show_aggregator(struct seq_file *seq)
 
 	if (bond_uses_primary(bond)) {
 		primary = rcu_dereference(bond->primary_link);
-		seq_printf(seq, "Primary Slave: %s",
+		seq_printf(seq, "Primary %s: %s", linkdesc,
 			   primary ? primary->dev->name : "None");
 		if (primary) {
 			optval = bond_opt_get_val(BOND_OPT_PRIMARY_RESELECT,
@@ -93,7 +99,7 @@ static void bond_info_show_aggregator(struct seq_file *seq)
 				   optval->string);
 		}
 
-		seq_printf(seq, "\nCurrently Active Slave: %s\n",
+		seq_printf(seq, "\nCurrently Active %s: %s\n", linkdesc,
 			   (curr) ? curr->dev->name : "None");
 	}
 
@@ -171,7 +177,7 @@ static void bond_info_show_link(struct seq_file *seq,
 {
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 
-	seq_printf(seq, "\nSlave Interface: %s\n", link->dev->name);
+	seq_printf(seq, "\n%s Interface: %s\n", linkdesc, link->dev->name);
 	seq_printf(seq, "MII Status: %s\n",
 		   bond_link_status(link->link_state));
 	if (link->speed == SPEED_UNKNOWN)
@@ -189,7 +195,7 @@ static void bond_info_show_link(struct seq_file *seq,
 
 	seq_printf(seq, "Permanent HW addr: %*phC\n",
 		   link->dev->addr_len, link->perm_hwaddr);
-	seq_printf(seq, "Slave queue ID: %d\n", link->queue_id);
+	seq_printf(seq, "%s queue ID: %d\n", linkdesc, link->queue_id);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		const struct port *port = &LINK_AD_INFO(link)->port;
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 0a4d095b8c3d..9065f24e31c0 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -150,6 +150,7 @@ static const struct class_attribute class_attr_bonding_aggregators = {
 	.store = bonding_store_bonds,
 };
 
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 /* "show" function for the bond_masters attribute.
  * The class parameter is ignored.
  */
@@ -178,7 +179,6 @@ static ssize_t bonding_store_bonds_legacy(struct class *cls,
 	return __bonding_store_bonds(bn, buffer, count);
 }
 
-/* legacy sysfs interface name */
 static const struct class_attribute class_attr_bonding_masters = {
 	.attr = {
 		.name = "bonding_masters",
@@ -187,6 +187,7 @@ static const struct class_attribute class_attr_bonding_masters = {
 	.show = bonding_show_bonds_legacy,
 	.store = bonding_store_bonds_legacy,
 };
+#endif
 
 /* Generic "store" method for bonding sysfs option setting */
 static ssize_t bonding_sysfs_store_option(struct device *d,
@@ -771,7 +772,7 @@ static ssize_t bonding_show_ad_user_port_key(struct device *d,
 static DEVICE_ATTR(ad_user_port_key, 0644,
 		   bonding_show_ad_user_port_key, bonding_sysfs_store_option);
 
-/* legacy sysfs interface names */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 static DEVICE_ATTR(slaves, 0644, bonding_show_links,
 		   bonding_sysfs_store_option);
 static DEVICE_ATTR(min_slaves, 0644,
@@ -782,7 +783,7 @@ static DEVICE_ATTR(all_slaves_active, 0644,
 		   bonding_show_links_active, bonding_sysfs_store_option);
 static DEVICE_ATTR(packets_per_slave, 0644,
 		   bonding_show_packets_per_link, bonding_sysfs_store_option);
-/* end legacy sysfs interface names */
+#endif
 
 static struct attribute *per_bond_attrs[] = {
 	&dev_attr_links.attr,
@@ -821,13 +822,13 @@ static struct attribute *per_bond_attrs[] = {
 	&dev_attr_ad_actor_sys_prio.attr,
 	&dev_attr_ad_actor_system.attr,
 	&dev_attr_ad_user_port_key.attr,
-/* legacy sysfs interface names */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	&dev_attr_slaves.attr,
 	&dev_attr_active_slave.attr,
 	&dev_attr_all_slaves_active.attr,
 	&dev_attr_min_slaves.attr,
 	&dev_attr_packets_per_slave.attr,
-/* end legacy sysfs interface names */
+#endif
 	NULL,
 };
 
@@ -874,6 +875,7 @@ int bond_create_sysfs(struct bond_net *bn)
 		return ret;
 	}
 
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	bn->class_attr_bonding_masters = class_attr_bonding_masters;
 	sysfs_attr_init(&bn->class_attr_bonding_masters.attr);
 
@@ -888,14 +890,17 @@ int bond_create_sysfs(struct bond_net *bn)
 		ret = 0;
 	}
 
+#endif
 	return ret;
 }
 
 /* Remove /sys/class/net/bonding_aggregators and _masters. */
 void bond_destroy_sysfs(struct bond_net *bn)
 {
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	netdev_class_remove_file_ns(&bn->class_attr_bonding_masters,
 				    bn->net);
+#endif
 	netdev_class_remove_file_ns(&bn->class_attr_bonding_aggregators,
 				    bn->net);
 }
diff --git a/drivers/net/bonding/bond_sysfs_link.c b/drivers/net/bonding/bond_sysfs_link.c
index 595db312df10..f0cb43a9773b 100644
--- a/drivers/net/bonding/bond_sysfs_link.c
+++ b/drivers/net/bonding/bond_sysfs_link.c
@@ -48,8 +48,9 @@ static ssize_t link_failure_count_show(struct link *link, char *buf)
 	return sprintf(buf, "%d\n", link->link_failure_count);
 }
 static LINK_ATTR_RO(link_failure_count);
-/* legacy sysfs interface */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 static LINK_ATTR(slave_failure_count, 0444, link_failure_count_show);
+#endif
 
 static ssize_t perm_hwaddr_show(struct link *link, char *buf)
 {
@@ -119,8 +120,9 @@ static const struct link_attribute *link_attrs[] = {
 	&link_attr_ad_aggregator_id,
 	&link_attr_ad_actor_oper_port_state,
 	&link_attr_ad_partner_oper_port_state,
-/* legacy sysfs interface */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	&link_attr_slave_failure_count,
+#endif
 	NULL
 };
 
@@ -156,11 +158,12 @@ int bond_sysfs_link_add(struct link *link)
 	if (err)
 		goto err_kobject_put;
 
-/* legacy sysfs interface */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	err = sysfs_create_link(&(link->dev->dev.kobj), &link->kobj,
 				"bonding_slave");
 	if (err)
 		goto err_kobject_put;
+#endif
 
 	for (a = link_attrs; *a; ++a) {
 		err = sysfs_create_file(&link->kobj, &((*a)->attr));
@@ -182,8 +185,9 @@ void bond_sysfs_link_del(struct link *link)
 	for (a = link_attrs; *a; ++a)
 		sysfs_remove_file(&link->kobj, &((*a)->attr));
 
-/* legacy sysfs interface */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	sysfs_remove_link(&(link->dev->dev.kobj), "bonding_slave");
+#endif
 
 	kobject_put(&link->kobj);
 }
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 2c2e4a94bdc2..48c5bb20cf46 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -64,13 +64,13 @@ enum {
 	BOND_OPT_AD_USER_PORT_KEY,
 	BOND_OPT_NUM_PEER_NOTIF_ALIAS,
 	BOND_OPT_PEER_NOTIF_DELAY,
-/* legacy sysfs interface names */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	BOND_OPT_PACKETS_PER_SLAVE,
 	BOND_OPT_MINSLAVES,
 	BOND_OPT_ACTIVE_SLAVE,
 	BOND_OPT_ALL_SLAVES_ACTIVE,
 	BOND_OPT_SLAVES,
-/* end legacy sysfs interface names */
+#endif
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index af3fecc27a19..d43f1a7450b0 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -614,7 +614,9 @@ struct bond_net {
 	struct proc_dir_entry	*proc_dir;
 #endif
 	struct class_attribute	class_attr_bonding_aggregators;
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	struct class_attribute	class_attr_bonding_masters;
+#endif
 };
 
 int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct link *link);
-- 
2.27.0

