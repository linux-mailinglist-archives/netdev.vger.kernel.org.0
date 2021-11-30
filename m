Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED90B462BAF
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbhK3EdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbhK3EdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:33:18 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149F4C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:30:00 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s37so8693030pga.9
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rVd0p0qPdjtJb23/eNriQgRfhdECQDddPitiqfM/+00=;
        b=cYkFvwtJ9WqMSPlUyqjxGFuosdWlT5CWNE3nIlXU3AV/KKAIpVP6gdY1YURF+sJfCZ
         hnYl3SRAhjUYjG/fb5fqXr1LltL/TyMAqmIAfjQ0MumVHlVtjlA69nj7lDHxioK3e/xD
         K5jH7YxH0XfNk3cz2rF2cwtfCvjUJL9p3vdErgnJzE+ypA6F4cbsnVDVRTyp1A6ZXd3l
         nnYdpjwHqYpa363KBU3k2F/yUuwdW37W2AIAudkonjJMftNicHsliYZKn8EE6VxdbuTY
         vl91jAe0x9hFhOXSFiPhA5gxd58++quIA8f4dZtLxAr2tglRkclwa8s1zbthPiAkj/wH
         0OYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rVd0p0qPdjtJb23/eNriQgRfhdECQDddPitiqfM/+00=;
        b=Yi4a6GJJQcUS+TbMBR/XOi8YnXKn6T/yD/NQl29fW6UrJ3UF3SgyiTnrMH0xykdzpI
         4KMvDjqqBa+vcPFwo3qBSmFKDeFqk3qSz3CACF9oL3e4E0OqpuqcC+FmmmyULNgQzeoo
         R867Vfee3LvihZKe7mNhbu+Ba8dzmg58ia7kwCRHEiK1z2C5/GLI3o4Dk0yaYtn9pzmt
         4jziAgqw26hyNqqRN97rBfkpUjAzkmkWemWRe6bLl+F6Mz/G3VlJ/vDy8vCU3MjYqdti
         7NxRVs2eMpADFBWq0RA+t+U7EsomFy4NI8XGe08PkVqZuIrbrm9sgQPMsRGOBp9mXBg4
         7k1g==
X-Gm-Message-State: AOAM530IQlDK1GOxI1AkCmZmDmQSuMM3VNyJCzyIGKXaIz98rd+vF4j9
        OD7QaIxz02wYqXVtQ72nQxNX04RlJqI=
X-Google-Smtp-Source: ABdhPJz+blLtrxSzpfyB4o0aA7X+CaeQYJeJXEpHiK6Or6sv+rgLt8KDVbdepubP0aIUPk2wx9ltfw==
X-Received: by 2002:a63:2049:: with SMTP id r9mr37755924pgm.413.1638246599051;
        Mon, 29 Nov 2021 20:29:59 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q9sm11697014pfj.9.2021.11.29.20.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:29:58 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCHv4 net-next] Bonding: add arp_missed_max option
Date:   Tue, 30 Nov 2021 12:29:47 +0800
Message-Id: <20211130042948.1629239-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we use hard code number to verify if we are in the
arp_interval timeslice. But some user may want to reduce/extend
the verify timeslice. With the similar team option 'missed_max'
the uers could change that number based on their own environment.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v2: set IFLA_BOND_MISSED_MAX to NLA_U8, and limit the values to 1-255
v3: rename the option name to arp_missed_max
v4: Update document description based on Jay's suggestion.
---
 Documentation/networking/bonding.rst | 11 +++++++++++
 drivers/net/bonding/bond_main.c      | 17 +++++++++--------
 drivers/net/bonding/bond_netlink.c   | 15 +++++++++++++++
 drivers/net/bonding/bond_options.c   | 28 ++++++++++++++++++++++++++++
 drivers/net/bonding/bond_procfs.c    |  2 ++
 drivers/net/bonding/bond_sysfs.c     | 13 +++++++++++++
 include/net/bond_options.h           |  1 +
 include/net/bonding.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 tools/include/uapi/linux/if_link.h   |  1 +
 10 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 31cfd7d674a6..e5a07cb48f68 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -421,6 +421,17 @@ arp_all_targets
 		consider the slave up only when all of the arp_ip_targets
 		are reachable
 
+arp_missed_max
+
+	Specifies the number of arp_interval monitor checks that must
+	fail in order for an interface to be marked down by the ARP monitor.
+
+	In order to provide orderly failover semantics, backup interfaces
+	are permitted an extra monitor check (i.e., they must fail
+	arp_missed_max + 1 times before being marked down).
+
+	The default value is 2, and the allowable range is 1 - 255.
+
 downdelay
 
 	Specifies the time, in milliseconds, to wait before disabling
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cf73eacdda91..f3aa49b97f81 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3129,8 +3129,8 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			 * when the source ip is 0, so don't take the link down
 			 * if we don't know our ip yet
 			 */
-			if (!bond_time_in_interval(bond, trans_start, 2) ||
-			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
+			if (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+			    !bond_time_in_interval(bond, slave->last_rx, bond->params.missed_max)) {
 
 				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
@@ -3224,7 +3224,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 
 		/* Backup slave is down if:
 		 * - No current_arp_slave AND
-		 * - more than 3*delta since last receive AND
+		 * - more than (missed_max+1)*delta since last receive AND
 		 * - the bond has an IP address
 		 *
 		 * Note: a non-null current_arp_slave indicates
@@ -3236,20 +3236,20 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		 */
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
-		    !bond_time_in_interval(bond, last_rx, 3)) {
+		    !bond_time_in_interval(bond, last_rx, bond->params.missed_max + 1)) {
 			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 
 		/* Active slave is down if:
-		 * - more than 2*delta since transmitting OR
-		 * - (more than 2*delta since receive AND
+		 * - more than missed_max*delta since transmitting OR
+		 * - (more than missed_max*delta since receive AND
 		 *    the bond has an IP address)
 		 */
 		trans_start = dev_trans_start(slave->dev);
 		if (bond_is_active_slave(slave) &&
-		    (!bond_time_in_interval(bond, trans_start, 2) ||
-		     !bond_time_in_interval(bond, last_rx, 2))) {
+		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
 			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
@@ -5822,6 +5822,7 @@ static int bond_check_params(struct bond_params *params)
 	params->arp_interval = arp_interval;
 	params->arp_validate = arp_validate_value;
 	params->arp_all_targets = arp_all_targets_value;
+	params->missed_max = 2;
 	params->updelay = updelay;
 	params->downdelay = downdelay;
 	params->peer_notif_delay = 0;
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 5d54e11d18fa..1007bf6d385d 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -110,6 +110,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 					    .len  = ETH_ALEN },
 	[IFLA_BOND_TLB_DYNAMIC_LB]	= { .type = NLA_U8 },
 	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
+	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U8 },
 };
 
 static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
@@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			return err;
 	}
 
+	if (data[IFLA_BOND_MISSED_MAX]) {
+		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
+
+		bond_opt_initval(&newval, missed_max);
+		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -515,6 +525,7 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 		nla_total_size(ETH_ALEN) + /* IFLA_BOND_AD_ACTOR_SYSTEM */
 		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
 		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MISSED_MAX */
 		0;
 }
 
@@ -650,6 +661,10 @@ static int bond_fill_info(struct sk_buff *skb,
 		       bond->params.tlb_dynamic_lb))
 		goto nla_put_failure;
 
+	if (nla_put_u8(skb, IFLA_BOND_MISSED_MAX,
+		       bond->params.missed_max))
+		goto nla_put_failure;
+
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info info;
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a8fde3bc458f..0f48921c4f15 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -78,6 +78,8 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 					   const struct bond_opt_value *newval);
 static int bond_option_ad_user_port_key_set(struct bonding *bond,
 					    const struct bond_opt_value *newval);
+static int bond_option_missed_max_set(struct bonding *bond,
+				      const struct bond_opt_value *newval);
 
 
 static const struct bond_opt_value bond_mode_tbl[] = {
@@ -213,6 +215,13 @@ static const struct bond_opt_value bond_ad_user_port_key_tbl[] = {
 	{ NULL,      -1,    0},
 };
 
+static const struct bond_opt_value bond_missed_max_tbl[] = {
+	{ "minval",	1,	BOND_VALFLAG_MIN},
+	{ "maxval",	255,	BOND_VALFLAG_MAX},
+	{ "default",	2,	BOND_VALFLAG_DEFAULT},
+	{ NULL,		-1,	0},
+};
+
 static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 	[BOND_OPT_MODE] = {
 		.id = BOND_OPT_MODE,
@@ -270,6 +279,15 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.values = bond_intmax_tbl,
 		.set = bond_option_arp_interval_set
 	},
+	[BOND_OPT_MISSED_MAX] = {
+		.id = BOND_OPT_MISSED_MAX,
+		.name = "arp_missed_max",
+		.desc = "Maximum number of missed ARP interval",
+		.unsuppmodes = BIT(BOND_MODE_8023AD) | BIT(BOND_MODE_TLB) |
+			       BIT(BOND_MODE_ALB),
+		.values = bond_missed_max_tbl,
+		.set = bond_option_missed_max_set
+	},
 	[BOND_OPT_ARP_TARGETS] = {
 		.id = BOND_OPT_ARP_TARGETS,
 		.name = "arp_ip_target",
@@ -1186,6 +1204,16 @@ static int bond_option_arp_all_targets_set(struct bonding *bond,
 	return 0;
 }
 
+static int bond_option_missed_max_set(struct bonding *bond,
+				      const struct bond_opt_value *newval)
+{
+	netdev_dbg(bond->dev, "Setting missed max to %s (%llu)\n",
+		   newval->string, newval->value);
+	bond->params.missed_max = newval->value;
+
+	return 0;
+}
+
 static int bond_option_primary_set(struct bonding *bond,
 				   const struct bond_opt_value *newval)
 {
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index f3e3bfd72556..2ec11af5f0cc 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -115,6 +115,8 @@ static void bond_info_show_master(struct seq_file *seq)
 
 		seq_printf(seq, "ARP Polling Interval (ms): %d\n",
 				bond->params.arp_interval);
+		seq_printf(seq, "ARP Missed Max: %u\n",
+				bond->params.missed_max);
 
 		seq_printf(seq, "ARP IP target/s (n.n.n.n form):");
 
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index c48b77167fab..9b5a5df23d21 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -303,6 +303,18 @@ static ssize_t bonding_show_arp_targets(struct device *d,
 static DEVICE_ATTR(arp_ip_target, 0644,
 		   bonding_show_arp_targets, bonding_sysfs_store_option);
 
+/* Show the arp missed max. */
+static ssize_t bonding_show_missed_max(struct device *d,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct bonding *bond = to_bond(d);
+
+	return sprintf(buf, "%u\n", bond->params.missed_max);
+}
+static DEVICE_ATTR(arp_missed_max, 0644,
+		   bonding_show_missed_max, bonding_sysfs_store_option);
+
 /* Show the up and down delays. */
 static ssize_t bonding_show_downdelay(struct device *d,
 				      struct device_attribute *attr,
@@ -779,6 +791,7 @@ static struct attribute *per_bond_attrs[] = {
 	&dev_attr_ad_actor_sys_prio.attr,
 	&dev_attr_ad_actor_system.attr,
 	&dev_attr_ad_user_port_key.attr,
+	&dev_attr_arp_missed_max.attr,
 	NULL,
 };
 
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index e64833a674eb..dd75c071f67e 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -65,6 +65,7 @@ enum {
 	BOND_OPT_NUM_PEER_NOTIF_ALIAS,
 	BOND_OPT_PEER_NOTIF_DELAY,
 	BOND_OPT_LACP_ACTIVE,
+	BOND_OPT_MISSED_MAX,
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 15e083e18f75..f6ae3a4baea4 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -121,6 +121,7 @@ struct bond_params {
 	int xmit_policy;
 	int miimon;
 	u8 num_peer_notif;
+	u8 missed_max;
 	int arp_interval;
 	int arp_validate;
 	int arp_all_targets;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eebd3894fe89..4ac53b30b6dc 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -858,6 +858,7 @@ enum {
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
+	IFLA_BOND_MISSED_MAX,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index eebd3894fe89..4ac53b30b6dc 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -858,6 +858,7 @@ enum {
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
+	IFLA_BOND_MISSED_MAX,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.31.1

