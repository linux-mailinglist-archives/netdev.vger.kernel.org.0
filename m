Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A99302EAB
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbhAYWI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733167AbhAYWGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:06:12 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E387C06178A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:36 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g1so17424329edu.4
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wkV08S57GvvCzTx5Fnpz+cxQKWVR7Zpw/qGH9NAjvF8=;
        b=s/zMIfZIDIWekP7fDaw59hCmdqTkMsTK+kinMAplWTcx5x1Nsc5nYCkR7hfMzKcvMO
         Wmwa7cSta55YrlNL7yvYdEk8T0dZSrdrT2wXCM5QOOpy3caiQVK4K4xJKRnmqMaEhtfN
         CfT/J75LEWJQsSI7h6PpS3GK1yJd4YVZA9yIq9hxJLtZqFxuGhSiDZnSfyr2cm1Pk5o+
         fnBV9mH8hWQ4lyIU6DsCib8jm7naaOcr9F83ymT42kN2MO2Ahp2dULuA66nI5/9OCPAB
         ZOR15ZoLRmO7ElonnYkyK0WsqMnm1uMczYqSxeYzQa6KQ2JVw8nEzieKo0q3gfrgzetZ
         JuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkV08S57GvvCzTx5Fnpz+cxQKWVR7Zpw/qGH9NAjvF8=;
        b=b/5ZQOE9SDCe6l8k7XiYvkcwOyHt7xOkCOYpy8N8CbRc64+FPCi0rDt1TRb6A/55gR
         K/RUVht6DVnNXyecI39BXwnBbN5zn53rL6maLT/ptMCgQWp1ykAUrpfZ+dEVWJ7+elpC
         vp2twpm+HQ7AIqEyVzP/B0sIpiqQNEpXu2Y4OAretYzLGg10eyVjgBbZSZkFO1syJQAz
         qdqoGxsLWCKmD4hFVAXXGVAY4dEMg73GalUTodqHdLwc3QfPRpgyLv0JvicCX6nUbID4
         0UxMj8BE0Uc4R5jtucBxbZmN5vi0zoguc6Fx0MpkboYEuOOnepN65MIEHAQKfqWc78Gr
         JITg==
X-Gm-Message-State: AOAM531/Ur4268WNTE0daUgP14UGpaxaCRgj9XFScWp35Q1BBm7vLmU2
        eOo0r53n+3M6ao5aOMceSXk=
X-Google-Smtp-Source: ABdhPJxCKBcRaLVIM+85wOv9Uy9gUqva0CBjDPAUoJg4E4E8N/8fHaTn2h2/xb3Jam5eCIJqxq/NPg==
X-Received: by 2002:a05:6402:22b7:: with SMTP id cx23mr2191897edb.313.1611612274913;
        Mon, 25 Jan 2021 14:04:34 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v7 net-next 08/11] net: dsa: allow changing the tag protocol via the "tagging" device attribute
Date:   Tue, 26 Jan 2021 00:03:30 +0200
Message-Id: <20210125220333.1004365-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently DSA exposes the following sysfs:
$ cat /sys/class/net/eno2/dsa/tagging
ocelot

which is a read-only device attribute, introduced in the kernel as
commit 98cdb4807123 ("net: dsa: Expose tagging protocol to user-space"),
and used by libpcap since its commit 993db3800d7d ("Add support for DSA
link-layer types").

It would be nice if we could extend this device attribute by making it
writable:
$ echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging

This is useful with DSA switches that can make use of more than one
tagging protocol. It may be useful in dsa_loop in the future too, to
perform offline testing of various taggers, or for changing between dsa
and edsa on Marvell switches, if that is desirable.

In terms of implementation, drivers can now move their tagging protocol
configuration outside of .setup/.teardown, and into .set_tag_protocol
and .del_tag_protocol. The calling order is:

.setup -> [.set_tag_protocol -> .del_tag_protocol]+ -> .teardown

There was one more contract between the DSA framework and drivers, which
is that if a CPU port needs to account for the tagger overhead in its
MTU configuration, it must do that privately. Which means it needs the
information about what tagger it uses before we call its MTU
configuration function. That promise is still held.

Writing to the tagging sysfs will first tear down the tagging protocol
for all switches in the tree attached to that DSA master, then will
attempt setup with the new tagger.

Writing will fail quickly with -EOPNOTSUPP for drivers that don't
support .set_tag_protocol, since that is checked during the deletion
phase. It is assumed that all switches within the same DSA tree use the
same driver, and therefore either all have .set_tag_protocol implemented,
or none do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v7:
- Hold the rtnl_mutex in dsa_tree_change_tag_proto and change the calling
  convention such that drivers now expect rtnl_mutex to be held.
- Call {set,del}_tag_protocol for DSA links with the tag_ops of the DSA
  tree and not of their own dp, since the latter is an invalid pointer
  never set up by anybody.
- Wrap the calls done at probe and remove time into some helper
  functions called dsa_switch_inform_initial_tag_proto and
  dsa_switch_inform_tag_proto_gone. Call dsa_switch_inform_tag_proto_gone
  more vigorously during the probe error path.

Changes in v6:
- Removed redundant tree_index from dsa_notifier_tag_proto_info.
- Call .{set,del}_tag_protocol for the DSA links too.
- Check for ops::set_tag_protocol only once instead of in a loop.
- Check for ops::set_tag_protocol in dsa_switch_tag_proto_set too.

Changes in v5:
- Update the sysfs documentation
- Make the tagger_lock per DSA switch tree instead of per DSA switch,
  and hold it across the entire delete -> set procedure.
- Use dsa_tree_notify instead of dsa_broadcast.

Changes in v4:
Patch is new.

 Documentation/ABI/testing/sysfs-class-net-dsa |  11 +-
 include/net/dsa.h                             |  15 +++
 net/dsa/dsa.c                                 |  20 +++
 net/dsa/dsa2.c                                | 119 +++++++++++++++++-
 net/dsa/dsa_priv.h                            |  16 +++
 net/dsa/master.c                              |  26 +++-
 net/dsa/port.c                                |   8 ++
 net/dsa/slave.c                               |  35 ++++--
 net/dsa/switch.c                              |  84 +++++++++++++
 9 files changed, 314 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-dsa b/Documentation/ABI/testing/sysfs-class-net-dsa
index 985d84c585c6..e2da26b44dd0 100644
--- a/Documentation/ABI/testing/sysfs-class-net-dsa
+++ b/Documentation/ABI/testing/sysfs-class-net-dsa
@@ -3,5 +3,12 @@ Date:		August 2018
 KernelVersion:	4.20
 Contact:	netdev@vger.kernel.org
 Description:
-		String indicating the type of tagging protocol used by the
-		DSA slave network device.
+		On read, this file returns a string indicating the type of
+		tagging protocol used by the DSA network devices that are
+		attached to this master interface.
+		On write, this file changes the tagging protocol of the
+		attached DSA switches, if this operation is supported by the
+		driver. Changing the tagging protocol must be done with the DSA
+		interfaces and the master interface all administratively down.
+		See the "name" field of each registered struct dsa_device_ops
+		for a list of valid values.
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b8af1d6c879a..0d8251de520f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -485,9 +485,24 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
+	/*
+	 * Tagging protocol helpers.
+	 * Switches that support a single tagging protocol should implement
+	 * only @get_tag_protocol and hardcode the protocol that they support.
+	 * Switches which can operate using multiple tagging protocols should
+	 * report in @get_tag_protocol the tagger in current use. They can
+	 * optionally set up the tagging protocol in @set_tag_protocol and
+	 * perform teardown (memory deallocation, etc) in @del_tag_protocol.
+	 * The framework guarantees paired calls to the last two functions.
+	 * These helpers are called with @port as the CPU ports and DSA links.
+	 */
 	enum dsa_tag_protocol (*get_tag_protocol)(struct dsa_switch *ds,
 						  int port,
 						  enum dsa_tag_protocol mprot);
+	int	(*set_tag_protocol)(struct dsa_switch *ds, int port,
+				    enum dsa_tag_protocol proto);
+	void	(*del_tag_protocol)(struct dsa_switch *ds, int port,
+				    enum dsa_tag_protocol proto);
 
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index f4ce3c5826a0..aa23736685ba 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -84,6 +84,26 @@ const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
 	return ops->name;
 };
 
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
+{
+	const struct dsa_device_ops *ops = NULL;
+	struct dsa_tag_driver *dsa_tag_driver;
+
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
+		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
+
+		if (!sysfs_streq(buf, tmp->name))
+			continue;
+
+		ops = tmp;
+		break;
+	}
+	mutex_unlock(&dsa_tag_drivers_lock);
+
+	return ops;
+}
+
 const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
 {
 	struct dsa_tag_driver *dsa_tag_driver;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 42f22955e111..a7253f3586a1 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -667,6 +667,47 @@ static const struct devlink_ops dsa_devlink_ops = {
 	.sb_occ_tc_port_bind_get	= dsa_devlink_sb_occ_tc_port_bind_get,
 };
 
+static int dsa_switch_inform_initial_tag_proto(struct dsa_switch *ds)
+{
+	enum dsa_tag_protocol proto = ds->dst->tag_ops->proto;
+	struct dsa_port *dp;
+	int err;
+
+	if (!ds->ops->set_tag_protocol)
+		return 0;
+
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if ((dsa_is_cpu_port(ds, dp->index) ||
+		     dsa_is_dsa_port(ds, dp->index)) && dp->ds == ds) {
+			rtnl_lock();
+			err = ds->ops->set_tag_protocol(ds, dp->index, proto);
+			rtnl_unlock();
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static void dsa_switch_inform_tag_proto_gone(struct dsa_switch *ds)
+{
+	enum dsa_tag_protocol proto = ds->dst->tag_ops->proto;
+	struct dsa_port *dp;
+
+	if (!ds->ops->del_tag_protocol)
+		return;
+
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if ((dsa_is_cpu_port(ds, dp->index) ||
+		     dsa_is_dsa_port(ds, dp->index)) && dp->ds == ds) {
+			rtnl_lock();
+			ds->ops->del_tag_protocol(ds, dp->index, proto);
+			rtnl_unlock();
+		}
+	}
+}
+
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
@@ -717,26 +758,39 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err < 0)
 		goto unregister_notifier;
 
+	/* Notify the switches of their tagging protocol after the .setup()
+	 * method, but before we start registering the user ports, whose MTU
+	 * configuration on the CPU port might depend upon the tagger.
+	 */
+	err = dsa_switch_inform_initial_tag_proto(ds);
+	if (err)
+		goto teardown;
+
 	devlink_params_publish(ds->devlink);
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
 		if (!ds->slave_mii_bus) {
 			err = -ENOMEM;
-			goto unregister_notifier;
+			goto teardown_tag_proto;
 		}
 
 		dsa_slave_mii_bus_init(ds);
 
 		err = mdiobus_register(ds->slave_mii_bus);
 		if (err < 0)
-			goto unregister_notifier;
+			goto teardown_tag_proto;
 	}
 
 	ds->setup = true;
 
 	return 0;
 
+teardown_tag_proto:
+	dsa_switch_inform_tag_proto_gone(ds);
+teardown:
+	if (ds->ops->teardown)
+		ds->ops->teardown(ds);
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink_ports:
@@ -761,6 +815,7 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (ds->slave_mii_bus && ds->ops->phy_read)
 		mdiobus_unregister(ds->slave_mii_bus);
 
+	dsa_switch_inform_tag_proto_gone(ds);
 	dsa_switch_unregister_notifier(ds);
 
 	if (ds->ops->teardown)
@@ -941,6 +996,62 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	dst->setup = false;
 }
 
+/* Since the dsa/tagging sysfs device attribute is per master, the assumption
+ * is that all DSA switches within a tree share the same tagger, otherwise
+ * they would have formed disjoint trees (different "dsa,member" values).
+ */
+int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
+			      struct net_device *master,
+			      const struct dsa_device_ops *tag_ops,
+			      const struct dsa_device_ops *old_tag_ops)
+{
+	struct dsa_notifier_tag_proto_info info;
+	struct dsa_port *dp;
+	int err = -EBUSY;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	/* At the moment we don't allow changing the tag protocol under
+	 * traffic. The rtnl_mutex also happens to serialize concurrent
+	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
+	 * restriction, there needs to be another mutex which serializes this.
+	 */
+	if (master->flags & IFF_UP)
+		goto out_unlock;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (!dsa_is_user_port(dp->ds, dp->index))
+			continue;
+
+		if (dp->slave->flags & IFF_UP)
+			goto out_unlock;
+	}
+
+	info.tag_ops = old_tag_ops;
+	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DEL, &info);
+	if (err)
+		goto out_unlock;
+
+	info.tag_ops = tag_ops;
+	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);
+	if (err)
+		goto out_unwind_tagger;
+
+	dst->tag_ops = tag_ops;
+
+	rtnl_unlock();
+
+	return 0;
+
+out_unwind_tagger:
+	info.tag_ops = old_tag_ops;
+	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);
+out_unlock:
+	rtnl_unlock();
+	return err;
+}
+
 static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 {
 	struct dsa_switch_tree *dst = ds->dst;
@@ -1032,9 +1143,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 		return -EINVAL;
 	}
 	dst->tag_ops = tag_ops;
-	dp->filter = tag_ops->filter;
-	dp->rcv = tag_ops->rcv;
-	dp->tag_ops = tag_ops;
+	dsa_port_set_tag_protocol(dp, tag_ops);
 	dp->dst = dst;
 
 	return 0;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 3cc1e6d76e3a..bf6f1d4c2fee 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -28,6 +28,8 @@ enum {
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
+	DSA_NOTIFIER_TAG_PROTO_SET,
+	DSA_NOTIFIER_TAG_PROTO_DEL,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -82,6 +84,11 @@ struct dsa_notifier_mtu_info {
 	int mtu;
 };
 
+/* DSA_NOTIFIER_TAG_PROTO_* */
+struct dsa_notifier_tag_proto_info {
+	const struct dsa_device_ops *tag_ops;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -115,6 +122,7 @@ struct dsa_slave_priv {
 /* dsa.c */
 const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
@@ -139,6 +147,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 }
 
 /* port.c */
+void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
+			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
@@ -201,6 +211,8 @@ int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
+void dsa_slave_setup_tagger(struct net_device *slave);
+int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
@@ -285,6 +297,10 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
+int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
+			      struct net_device *master,
+			      const struct dsa_device_ops *tag_ops,
+			      const struct dsa_device_ops *old_tag_ops);
 
 extern struct list_head dsa_tree_list;
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index cb3a5cf99b25..6c0068fbecda 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -280,7 +280,31 @@ static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "%s\n",
 		       dsa_tag_protocol_to_str(cpu_dp->tag_ops));
 }
-static DEVICE_ATTR_RO(tagging);
+
+static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	const struct dsa_device_ops *ops;
+	int err;
+
+	ops = dsa_find_tagger_by_name(buf);
+	/* Bad tagger name, or module is not loaded? */
+	if (!ops)
+		return -ENOENT;
+
+	if (ops == cpu_dp->tag_ops)
+		goto out;
+
+	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, dev, ops,
+					cpu_dp->tag_ops);
+	if (err)
+		return err;
+out:
+	return count;
+}
+static DEVICE_ATTR_RW(tagging);
 
 static struct attribute *dsa_slave_attrs[] = {
 	&dev_attr_tagging.attr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index a8886cf40160..5e079a61528e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -526,6 +526,14 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
+void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
+			       const struct dsa_device_ops *tag_ops)
+{
+	cpu_dp->filter = tag_ops->filter;
+	cpu_dp->rcv = tag_ops->rcv;
+	cpu_dp->tag_ops = tag_ops;
+}
+
 static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 {
 	struct device_node *phy_dn;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f2fb433f3828..b0571ab4e5a7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1430,7 +1430,7 @@ static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 	dsa_hw_port_list_free(&hw_port_list);
 }
 
-static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
+int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -1708,6 +1708,27 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	return ret;
 }
 
+void dsa_slave_setup_tagger(struct net_device *slave)
+{
+	struct dsa_port *dp = dsa_slave_to_port(slave);
+	struct dsa_slave_priv *p = netdev_priv(slave);
+	const struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = cpu_dp->master;
+
+	if (cpu_dp->tag_ops->tail_tag)
+		slave->needed_tailroom = cpu_dp->tag_ops->overhead;
+	else
+		slave->needed_headroom = cpu_dp->tag_ops->overhead;
+	/* Try to save one extra realloc later in the TX path (in the master)
+	 * by also inheriting the master's needed headroom and tailroom.
+	 * The 8021q driver also does this.
+	 */
+	slave->needed_headroom += master->needed_headroom;
+	slave->needed_tailroom += master->needed_tailroom;
+
+	p->xmit = cpu_dp->tag_ops->xmit;
+}
+
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
 static void dsa_slave_set_lockdep_class_one(struct net_device *dev,
 					    struct netdev_queue *txq,
@@ -1782,16 +1803,6 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
-	if (cpu_dp->tag_ops->tail_tag)
-		slave_dev->needed_tailroom = cpu_dp->tag_ops->overhead;
-	else
-		slave_dev->needed_headroom = cpu_dp->tag_ops->overhead;
-	/* Try to save one extra realloc later in the TX path (in the master)
-	 * by also inheriting the master's needed headroom and tailroom.
-	 * The 8021q driver also does this.
-	 */
-	slave_dev->needed_headroom += master->needed_headroom;
-	slave_dev->needed_tailroom += master->needed_tailroom;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
@@ -1814,8 +1825,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	p->dp = port;
 	INIT_LIST_HEAD(&p->mall_tc_list);
-	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
+	dsa_slave_setup_tagger(slave_dev);
 
 	rtnl_lock();
 	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index cc0b25f3adea..17518377a1fa 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -297,6 +297,84 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
 	return 0;
 }
 
+static bool dsa_switch_tag_proto_match(struct dsa_switch *ds, int port,
+				       struct dsa_notifier_tag_proto_info *info)
+{
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+		return true;
+
+	return false;
+}
+
+static int dsa_switch_tag_proto_del(struct dsa_switch *ds,
+				    struct dsa_notifier_tag_proto_info *info)
+{
+	int port;
+
+	/* Check early if we can replace it, so we don't delete it
+	 * for nothing and leave the switch dangling.
+	 */
+	if (!ds->ops->set_tag_protocol)
+		return -EOPNOTSUPP;
+
+	/* The delete method is optional, just the setter is mandatory */
+	if (!ds->ops->del_tag_protocol)
+		return 0;
+
+	ASSERT_RTNL();
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_tag_proto_match(ds, port, info)) {
+			ds->ops->del_tag_protocol(ds, port,
+						  info->tag_ops->proto);
+		}
+	}
+
+	return 0;
+}
+
+static int dsa_switch_tag_proto_set(struct dsa_switch *ds,
+				    struct dsa_notifier_tag_proto_info *info)
+{
+	int port, err;
+
+	if (!ds->ops->set_tag_protocol)
+		return -EOPNOTSUPP;
+
+	ASSERT_RTNL();
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_tag_proto_match(ds, port, info)) {
+			err = ds->ops->set_tag_protocol(ds, port,
+							info->tag_ops->proto);
+			if (err)
+				return err;
+
+			if (dsa_is_cpu_port(ds, port))
+				dsa_port_set_tag_protocol(dsa_to_port(ds, port),
+							  info->tag_ops);
+		}
+	}
+
+	/* Now that changing the tag protocol can no longer fail, let's update
+	 * the remaining bits which are "duplicated for faster access", and the
+	 * bits that depend on the tagger, such as the MTU.
+	 */
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_user_port(ds, port)) {
+			struct net_device *slave;
+
+			slave = dsa_to_port(ds, port)->slave;
+			dsa_slave_setup_tagger(slave);
+
+			/* rtnl_mutex is held in dsa_tree_change_tag_proto */
+			dsa_slave_change_mtu(slave, slave->mtu);
+		}
+	}
+
+	return 0;
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -343,6 +421,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_MTU:
 		err = dsa_switch_mtu(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_PROTO_SET:
+		err = dsa_switch_tag_proto_set(ds, info);
+		break;
+	case DSA_NOTIFIER_TAG_PROTO_DEL:
+		err = dsa_switch_tag_proto_del(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.25.1

