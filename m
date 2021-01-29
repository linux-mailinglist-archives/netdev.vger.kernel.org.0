Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779893082D5
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhA2BD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhA2BB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:59 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E9EC06178B
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id kg20so10586720ejc.4
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g6TVqiVDGE4d/SSYz2mt/7XIG+t/sRgjGN7UeRXPCx0=;
        b=C7CKhgAV4Fyx8Sik8tZ5iRrpjAlJfA+3kQ8J6VzAtOWj9weN7j5W2OwQsiy5ybYx4A
         JHCwn+T98qQfXgHMI3S2aMlFbH6OrqU64LeQhU5+PJjc4CGIxU0jW4enZvI3g2E/hIuU
         mb7ekp/w0G6lqTIZ5lIMcIg3TsjYFD5F7EIVN0ae+5EbNNGBccgVVeJiCjm4KZFn38q1
         IqQD0jSMJg23DUpJ3Pi7ZENsTV1DIeDfjUg+bPP0rvWMuAQ5NfYTwmBj6Zyo0E4MMfB7
         App/YcaC1rlo8o6wvhwitzWelUPK82v/UDMO8S59AeWyXETAu8Y1bAEdtQd/XkC7vI6l
         /hYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g6TVqiVDGE4d/SSYz2mt/7XIG+t/sRgjGN7UeRXPCx0=;
        b=sqHYiTRrBqIaGePH+f0WaiEcftS19CG5EVfYuBhU6Hvsy+Y+DMFDTja9TaVxP6gs0w
         LPkQW3dWJx8A+Bj9Vrf3wl/yOebetr3T1wSdquP9RlrbscRHoQ2swspt66ZbQSB+zNBj
         DfhVosoMMeo3S6DNQTig4yJFagq9zjeeh/ocFnwl/UMqIqCcObO2tRR9KDBouG3k21UC
         amkbkpb/+FrZZ8U0a05BJF8b4GTMXphjukFMLLyoMJ269a5gr6GyUNlMSbXCZKDtivzA
         orP7rZleIhLCl2Kfc+EnEDwxjWYAyeIwGhmz8+uYxMq2yPpC2QWXKa/HttgdjTw27IqZ
         r32g==
X-Gm-Message-State: AOAM531c8Z0fftF0pe2R7DWwekQI/O0mztb2c/gPfeMYgrCodx8dxZwd
        Duj5F96PQDsRb9Ju6eGeKtc=
X-Google-Smtp-Source: ABdhPJwHJtpnL89iDbxmRoaYCCCRvTgR8nd/8aOmFULoNKcTB9rXB89QQ6n/cQA57lk6ag/WRtHxZQ==
X-Received: by 2002:a17:906:f919:: with SMTP id lc25mr2177326ejb.323.1611882039681;
        Thu, 28 Jan 2021 17:00:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:39 -0800 (PST)
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
Subject: [PATCH v8 net-next 08/11] net: dsa: allow changing the tag protocol via the "tagging" device attribute
Date:   Fri, 29 Jan 2021 03:00:06 +0200
Message-Id: <20210129010009.3959398-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
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

In terms of implementation, drivers can support this feature by
implementing .change_tag_protocol, which should always leave the switch
in a consistent state: either with the new protocol if things went well,
or with the old one if something failed. Teardown of the old protocol,
if necessary, must be handled by the driver.

Some things remain as before:
- The .get_tag_protocol is currently only called at probe time, to load
  the initial tagging protocol driver. Nonetheless, new drivers should
  report the tagging protocol in current use now.
- The driver should manage by itself the initial setup of tagging
  protocol, no later than the .setup() method, as well as destroying
  resources used by the last tagger in use, no earlier than the
  .teardown() method.

For multi-switch DSA trees, error handling is a bit more complicated,
since e.g. the 5th out of 7 switches may fail to change the tag
protocol. When that happens, a revert to the original tag protocol is
attempted, but that may fail too, leaving the tree in an inconsistent
state despite each individual switch implementing .change_tag_protocol
transactionally. Since the intersection between drivers that implement
.change_tag_protocol and drivers that support D in DSA is currently the
empty set, the possibility for this error to happen is ignored for now.

Testing:

$ insmod mscc_felix.ko
[   79.549784] mscc_felix 0000:00:00.5: Adding to iommu group 14
[   79.565712] mscc_felix 0000:00:00.5: Failed to register DSA switch: -517
$ insmod tag_ocelot.ko
$ rmmod mscc_felix.ko
$ insmod mscc_felix.ko
[   97.261724] libphy: VSC9959 internal MDIO bus: probed
[   97.267363] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 0
[   97.274998] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 1
[   97.282561] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 2
[   97.289700] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 3
[   97.599163] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   97.862034] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   97.950731] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii link mode
[   97.964278] 8021q: adding VLAN 0 to HW filter on device swp0
[   98.146161] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   98.238649] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii link mode
[   98.251845] 8021q: adding VLAN 0 to HW filter on device swp1
[   98.433916] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   98.485542] mscc_felix 0000:00:00.5: configuring for fixed/internal link mode
[   98.503584] mscc_felix 0000:00:00.5: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   98.527948] device eno2 entered promiscuous mode
[   98.544755] DSA: tree 0 setup

$ ping 10.0.0.1
PING 10.0.0.1 (10.0.0.1): 56 data bytes
64 bytes from 10.0.0.1: seq=0 ttl=64 time=2.337 ms
64 bytes from 10.0.0.1: seq=1 ttl=64 time=0.754 ms
^C
--- 10.0.0.1 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.754/1.545/2.337 ms

$ cat /sys/class/net/eno2/dsa/tagging
ocelot
$ cat ./test_ocelot_8021q.sh
        #!/bin/bash

        ip link set swp0 down
        ip link set swp1 down
        ip link set swp2 down
        ip link set swp3 down
        ip link set swp5 down
        ip link set eno2 down
        echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
        ip link set eno2 up
        ip link set swp0 up
        ip link set swp1 up
        ip link set swp2 up
        ip link set swp3 up
        ip link set swp5 up
$ ./test_ocelot_8021q.sh
./test_ocelot_8021q.sh: line 9: echo: write error: Protocol not available
$ rmmod tag_ocelot.ko
rmmod: can't unload module 'tag_ocelot': Resource temporarily unavailable
$ insmod tag_ocelot_8021q.ko
$ ./test_ocelot_8021q.sh
$ cat /sys/class/net/eno2/dsa/tagging
ocelot-8021q
$ rmmod tag_ocelot.ko
$ rmmod tag_ocelot_8021q.ko
rmmod: can't unload module 'tag_ocelot_8021q': Resource temporarily unavailable
$ ping 10.0.0.1
PING 10.0.0.1 (10.0.0.1): 56 data bytes
64 bytes from 10.0.0.1: seq=0 ttl=64 time=0.953 ms
64 bytes from 10.0.0.1: seq=1 ttl=64 time=0.787 ms
64 bytes from 10.0.0.1: seq=2 ttl=64 time=0.771 ms
$ rmmod mscc_felix.ko
[  645.544426] mscc_felix 0000:00:00.5: Link is Down
[  645.838608] DSA: tree 0 torn down
$ rmmod tag_ocelot_8021q.ko

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v8:
- Take reference on tagging driver module in dsa_find_tagger_by_name.
- Replaced DSA_NOTIFIER_TAG_PROTO_SET and DSA_NOTIFIER_TAG_PROTO_DEL
  with a single DSA_NOTIFIER_TAG_PROTO.
- Combined .set_tag_protocol and .del_tag_protocol into a single
  .change_tag_protocol, and we're no longer calling those 2 functions at
  probe and unbind time.
- Dropped review tags due to amount of changes.

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

 Documentation/ABI/testing/sysfs-class-net-dsa | 11 +++-
 include/net/dsa.h                             |  9 +++
 net/dsa/dsa.c                                 | 26 +++++++++
 net/dsa/dsa2.c                                | 55 ++++++++++++++++++-
 net/dsa/dsa_priv.h                            | 15 +++++
 net/dsa/master.c                              | 39 ++++++++++++-
 net/dsa/port.c                                |  8 +++
 net/dsa/slave.c                               | 35 ++++++++----
 net/dsa/switch.c                              | 55 +++++++++++++++++++
 9 files changed, 235 insertions(+), 18 deletions(-)

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
index b8af1d6c879a..7ea3918b2e61 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -485,9 +485,18 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
+	/*
+	 * Tagging protocol helpers called for the CPU ports and DSA links.
+	 * @get_tag_protocol retrieves the initial tagging protocol and is
+	 * mandatory. Switches which can operate using multiple tagging
+	 * protocols should implement @change_tag_protocol and report in
+	 * @get_tag_protocol the tagger in current use.
+	 */
 	enum dsa_tag_protocol (*get_tag_protocol)(struct dsa_switch *ds,
 						  int port,
 						  enum dsa_tag_protocol mprot);
+	int	(*change_tag_protocol)(struct dsa_switch *ds, int port,
+				       enum dsa_tag_protocol proto);
 
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index f4ce3c5826a0..84cad1be9ce4 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -84,6 +84,32 @@ const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
 	return ops->name;
 };
 
+/* Function takes a reference on the module owning the tagger,
+ * so dsa_tag_driver_put must be called afterwards.
+ */
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
+{
+	const struct dsa_device_ops *ops = ERR_PTR(-ENOPROTOOPT);
+	struct dsa_tag_driver *dsa_tag_driver;
+
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
+		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
+
+		if (!sysfs_streq(buf, tmp->name))
+			continue;
+
+		if (!try_module_get(dsa_tag_driver->owner))
+			break;
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
index 63035a898ca8..96249c4ad5f2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -942,6 +942,57 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
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
+	info.tag_ops = tag_ops;
+	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
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
+	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
+out_unlock:
+	rtnl_unlock();
+	return err;
+}
+
 static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 {
 	struct dsa_switch_tree *dst = ds->dst;
@@ -1038,9 +1089,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 
 	dp->master = master;
 	dp->type = DSA_PORT_TYPE_CPU;
-	dp->filter = dst->tag_ops->filter;
-	dp->rcv = dst->tag_ops->rcv;
-	dp->tag_ops = dst->tag_ops;
+	dsa_port_set_tag_protocol(dp, dst->tag_ops);
 	dp->dst = dst;
 
 	return 0;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 3cc1e6d76e3a..edca57b558ad 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -28,6 +28,7 @@ enum {
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
+	DSA_NOTIFIER_TAG_PROTO,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -82,6 +83,11 @@ struct dsa_notifier_mtu_info {
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
@@ -115,6 +121,7 @@ struct dsa_slave_priv {
 /* dsa.c */
 const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
@@ -139,6 +146,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 }
 
 /* port.c */
+void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
+			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
@@ -201,6 +210,8 @@ int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
+void dsa_slave_setup_tagger(struct net_device *slave);
+int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
@@ -285,6 +296,10 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
+int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
+			      struct net_device *master,
+			      const struct dsa_device_ops *tag_ops,
+			      const struct dsa_device_ops *old_tag_ops);
 
 extern struct list_head dsa_tree_list;
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index cb3a5cf99b25..052a977914a6 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -280,7 +280,44 @@ static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "%s\n",
 		       dsa_tag_protocol_to_str(cpu_dp->tag_ops));
 }
-static DEVICE_ATTR_RO(tagging);
+
+static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	const struct dsa_device_ops *new_tag_ops, *old_tag_ops;
+	struct net_device *dev = to_net_dev(d);
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	int err;
+
+	old_tag_ops = cpu_dp->tag_ops;
+	new_tag_ops = dsa_find_tagger_by_name(buf);
+	/* Bad tagger name, or module is not loaded? */
+	if (IS_ERR(new_tag_ops))
+		return PTR_ERR(new_tag_ops);
+
+	if (new_tag_ops == old_tag_ops)
+		/* Drop the temporarily held duplicate reference, since
+		 * the DSA switch tree uses this tagger.
+		 */
+		goto out;
+
+	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, dev, new_tag_ops,
+					old_tag_ops);
+	if (err) {
+		/* On failure the old tagger is restored, so we don't need the
+		 * driver for the new one.
+		 */
+		dsa_tag_driver_put(new_tag_ops);
+		return err;
+	}
+
+	/* On success we no longer need the module for the old tagging protocol
+	 */
+out:
+	dsa_tag_driver_put(old_tag_ops);
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
index cc0b25f3adea..5026e4143663 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -297,6 +297,58 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
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
+static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
+				       struct dsa_notifier_tag_proto_info *info)
+{
+	const struct dsa_device_ops *tag_ops = info->tag_ops;
+	int port, err;
+
+	if (!ds->ops->change_tag_protocol)
+		return -EOPNOTSUPP;
+
+	ASSERT_RTNL();
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_tag_proto_match(ds, port, info)) {
+			err = ds->ops->change_tag_protocol(ds, port,
+							   tag_ops->proto);
+			if (err)
+				return err;
+
+			if (dsa_is_cpu_port(ds, port))
+				dsa_port_set_tag_protocol(dsa_to_port(ds, port),
+							  tag_ops);
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
@@ -343,6 +395,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_MTU:
 		err = dsa_switch_mtu(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_PROTO:
+		err = dsa_switch_change_tag_proto(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.25.1

