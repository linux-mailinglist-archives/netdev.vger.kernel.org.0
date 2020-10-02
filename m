Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439E02819F3
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388511AbgJBRlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388451AbgJBRlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 13:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601660494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/7vjx4YQggU5P4+9tDYCKqR6WKcqIg5SqfaCkwhvzos=;
        b=dATggcoI6I6OgFEQn9d+VlNkMlwpg0pEJ/NT4EKA/3B48OXJcoUhw+gh+RsyrMdMTbHayJ
        oXCkacVC3d7bw/bDtMPG6heeIz4Nf+dJSCUdqfufXRUOxwH4y7/VddRRj31TgyzRE8sQKx
        XaArxzia7gFjmaySUUnS3swKftDdT94=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304--go0TehuOVuZF_E4HJmLqg-1; Fri, 02 Oct 2020 13:41:32 -0400
X-MC-Unique: -go0TehuOVuZF_E4HJmLqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AA0857244;
        Fri,  2 Oct 2020 17:41:23 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0F7D1002382;
        Fri,  2 Oct 2020 17:41:20 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to disable legacy interfaces
Date:   Fri,  2 Oct 2020 13:40:01 -0400
Message-Id: <20201002174001.3012643-7-jarod@redhat.com>
In-Reply-To: <20201002174001.3012643-1-jarod@redhat.com>
References: <20201002174001.3012643-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 drivers/net/bonding/bond_main.c       |  4 ++--
 drivers/net/bonding/bond_options.c    |  4 ++--
 drivers/net/bonding/bond_procfs.c     |  8 ++++++++
 drivers/net/bonding/bond_sysfs.c      | 14 ++++++++++----
 drivers/net/bonding/bond_sysfs_port.c |  6 ++++--
 6 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c3dbe64e628e..1a13894820cb 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -56,6 +56,18 @@ config BONDING
 	  To compile this driver as a module, choose M here: the module
 	  will be called bonding.
 
+config BONDING_LEGACY_INTERFACES
+	default y
+	bool "Maintain legacy bonding interface names"
+	help
+	  The bonding driver historically made use of the terms "master" and
+	  "slave" to describe it's component members. This has since been
+	  changed to "bond" and "port" as part of a broader effort to remove
+	  the use of socially problematic language from the kernel. However,
+	  removing all such cases requires breaking long-standing user-facing
+	  interfaces in /proc and /sys, which will not be done, unless you
+	  opt out of them here, by selecting 'N'.
+
 config DUMMY
 	tristate "Dummy net driver support"
 	help
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b8a351d85da4..226d5fb76221 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -194,7 +194,7 @@ module_param(lp_interval, uint, 0);
 MODULE_PARM_DESC(lp_interval, "The number of seconds between instances where "
 			      "the bonding driver sends learning packets to "
 			      "each port's peer switch. The default is 1.");
-/* legacy compatability module parameters */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 module_param_named(all_slaves_active, apa, int, 0644);
 MODULE_PARM_DESC(all_slaves_active, "Keep all frames received on an interface "
 				     "by setting active flag for all slaves; "
@@ -205,7 +205,7 @@ MODULE_PARM_DESC(packets_per_slave, "Packets to send per slave in balance-rr "
 				    "mode; 0 for a random slave, 1 packet per "
 				    "slave (default), >1 packets per slave. "
 				    "(Legacy compat synonym for packets_per_port).");
-/* end legacy compatability module parameters */
+#endif
 
 /*----------------------------- Global variables ----------------------------*/
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 8e4050c2b08e..630079ba5452 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -434,7 +434,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.values = bond_intmax_tbl,
 		.set = bond_option_peer_notif_delay_set
 	},
-/* legacy sysfs interfaces */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	[BOND_OPT_PACKETS_PER_SLAVE] = {
 		.id = BOND_OPT_PACKETS_PER_SLAVE,
 		.name = "packets_per_slave",
@@ -467,7 +467,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_ports_set
 	},
-/* end legacy sysfs interfaces */
+#endif
 };
 
 /* Searches for an option by name */
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 2e65472e3c58..8e4a03d86329 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -86,8 +86,10 @@ static void bond_info_show_bond_dev(struct seq_file *seq)
 		primary = rcu_dereference(bond->primary_port);
 		seq_printf(seq, "Primary Port: %s",
 			   primary ? primary->dev->name : "None");
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 		seq_printf(seq, "Primary Slave: %s",
 			   primary ? primary->dev->name : "None");
+#endif
 		if (primary) {
 			optval = bond_opt_get_val(BOND_OPT_PRIMARY_RESELECT,
 						  bond->params.primary_reselect);
@@ -97,8 +99,10 @@ static void bond_info_show_bond_dev(struct seq_file *seq)
 
 		seq_printf(seq, "\nCurrently Active Port: %s\n",
 			   (curr) ? curr->dev->name : "None");
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 		seq_printf(seq, "Currently Active Slave: %s\n",
 			   (curr) ? curr->dev->name : "None");
+#endif
 	}
 
 	seq_printf(seq, "MII Status: %s\n", netif_carrier_ok(bond->dev) ?
@@ -176,7 +180,9 @@ static void bond_info_show_port(struct seq_file *seq,
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 
 	seq_printf(seq, "\nPort Interface: %s\n", port->dev->name);
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	seq_printf(seq, "Slave Interface: %s\n", port->dev->name);
+#endif
 	seq_printf(seq, "MII Status: %s\n", bond_port_link_status(port->link));
 	if (port->speed == SPEED_UNKNOWN)
 		seq_printf(seq, "Speed: %s\n", "Unknown");
@@ -194,7 +200,9 @@ static void bond_info_show_port(struct seq_file *seq,
 	seq_printf(seq, "Permanent HW addr: %*phC\n",
 		   port->dev->addr_len, port->perm_hwaddr);
 	seq_printf(seq, "Port queue ID: %d\n", port->queue_id);
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	seq_printf(seq, "Slave queue ID: %d\n", port->queue_id);
+#endif
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		const struct ad_port *ad_port = &PORT_AD_INFO(port)->ad_port;
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 1c2f44a76f31..1911027ea2e1 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -150,6 +150,7 @@ static const struct class_attribute class_attr_bonding_devs = {
 	.store = bonding_store_bonds,
 };
 
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 /* "show" function for the bond_masters attribute.
  * The class parameter is ignored.
  */
@@ -187,6 +188,7 @@ static const struct class_attribute class_attr_bonding_masters = {
 	.show = bonding_show_bonds_legacy,
 	.store = bonding_store_bonds_legacy,
 };
+#endif
 
 /* Generic "store" method for bonding sysfs option setting */
 static ssize_t bonding_sysfs_store_option(struct device *d,
@@ -771,7 +773,7 @@ static ssize_t bonding_show_ad_user_port_key(struct device *d,
 static DEVICE_ATTR(ad_user_port_key, 0644,
 		   bonding_show_ad_user_port_key, bonding_sysfs_store_option);
 
-/* legacy sysfs interfaces */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 static DEVICE_ATTR(slaves, 0644, bonding_show_ports,
 		   bonding_sysfs_store_option);
 static DEVICE_ATTR(active_slave, 0644,
@@ -780,7 +782,7 @@ static DEVICE_ATTR(all_slaves_active, 0644,
 		   bonding_show_ports_active, bonding_sysfs_store_option);
 static DEVICE_ATTR(packets_per_slave, 0644,
 		   bonding_show_packets_per_port, bonding_sysfs_store_option);
-/* end legacy sysfs interfaces */
+#endif
 
 static struct attribute *per_bond_attrs[] = {
 	&dev_attr_ports.attr,
@@ -819,12 +821,12 @@ static struct attribute *per_bond_attrs[] = {
 	&dev_attr_ad_actor_sys_prio.attr,
 	&dev_attr_ad_actor_system.attr,
 	&dev_attr_ad_user_port_key.attr,
-/* legacy sysfs interfaces */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	&dev_attr_slaves.attr,
 	&dev_attr_active_slave.attr,
 	&dev_attr_all_slaves_active.attr,
 	&dev_attr_packets_per_slave.attr,
-/* end legacy sysfs interfaces */
+#endif
 	NULL,
 };
 
@@ -871,6 +873,7 @@ int bond_create_sysfs(struct bond_net *bn)
 		return ret;
 	}
 
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	bn->class_attr_bonding_masters = class_attr_bonding_masters;
 	sysfs_attr_init(&bn->class_attr_bonding_masters.attr);
 
@@ -884,6 +887,7 @@ int bond_create_sysfs(struct bond_net *bn)
 			       class_attr_bonding_masters.attr.name);
 		ret = 0;
 	}
+#endif
 
 	return ret;
 
@@ -893,7 +897,9 @@ int bond_create_sysfs(struct bond_net *bn)
 void bond_destroy_sysfs(struct bond_net *bn)
 {
 	netdev_class_remove_file_ns(&bn->class_attr_bonding_devs, bn->net);
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	netdev_class_remove_file_ns(&bn->class_attr_bonding_masters, bn->net);
+#endif
 }
 
 /* Initialize sysfs for each bond.  This sets up and registers
diff --git a/drivers/net/bonding/bond_sysfs_port.c b/drivers/net/bonding/bond_sysfs_port.c
index 0d427b407fcb..81fbe3deeb3e 100644
--- a/drivers/net/bonding/bond_sysfs_port.c
+++ b/drivers/net/bonding/bond_sysfs_port.c
@@ -152,11 +152,12 @@ int bond_sysfs_port_add(struct bond_port *port)
 	if (err)
 		goto err_kobject_put;
 
-	/* legacy sysfs interface */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	err = sysfs_create_link(&(port->dev->dev.kobj), &port->kobj,
 				"bonding_slave");
 	if (err)
 		goto err_kobject_put;
+#endif
 
 	for (a = port_attrs; *a; ++a) {
 		err = sysfs_create_file(&port->kobj, &((*a)->attr));
@@ -178,8 +179,9 @@ void bond_sysfs_port_del(struct bond_port *port)
 	for (a = port_attrs; *a; ++a)
 		sysfs_remove_file(&port->kobj, &((*a)->attr));
 
-	/* legacy sysfs interface */
+#ifdef CONFIG_BONDING_LEGACY_INTERFACES
 	sysfs_remove_link(&(port->dev->dev.kobj), "bonding_slave");
+#endif
 
 	kobject_put(&port->kobj);
 }
-- 
2.27.0

