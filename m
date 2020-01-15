Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9013CE2C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgAOUml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:42:41 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38039 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbgAOUmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:42:40 -0500
Received: by mail-pl1-f196.google.com with SMTP id f20so7320660plj.5;
        Wed, 15 Jan 2020 12:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pYJ0/Gf5qtH64hczIWpRH1LUaKRAVpiQYAGAKZXYUro=;
        b=tv3oXgb+92XM4g1yeM7eAqPDsqQCfg7RAFkQ/b92bLB+R17ZdwIyagAWdy9Y7rRVrT
         5IrL95V7f9YBNMl/poXuXXTdNK4XnJ14ZaN6qao9B5iJG1a59vlSvEml5pCZRei3jXkX
         gpKjJE/wFHKJaOtYtt23HusuahJFWOZIRoQKzNKbIAmQtqEVRHCmXwbKk5DE0eu07Vqg
         zpDPvcYfE7MpdURPtSQ2Oz4WF7grBbqBlhIGekf5zslUnYLWKWBWXOIFsrV6J5nt0DNh
         RdebjLcOhFrWWe+cE3mabMaWyFOX3CdHCAlNPQY+fshAC+EidARcRM+hukZPsm1FuMhZ
         UeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pYJ0/Gf5qtH64hczIWpRH1LUaKRAVpiQYAGAKZXYUro=;
        b=tFnjcs+aUYAvY0KLUjuq1hM9uLXZeYf5O8l+pX/LMRVLtbEwjiiy7N5BzA9TTMxNMz
         9LvcI2M2A1OHQUumtJcLWUY6r5kkeZu7nw8D0PkxSQU5iVvaLK/Q9Rsp3tiRzdjLcQxK
         rg8m+6N0FwLY9/7hEKR52dgROQotLlPtw/pCM3k+zf4WW0f/AjdQJpRnK8tUsNXxjUQI
         9di4g42/GZ2YgQMW7xPjiegu57Ox5gn4M65tJI3VRTvdBYpL4gKMNvABHrtdNo4k3lzP
         4wnnDc7BJJhUiWM4um/C5EZWLmHRnasjxqZEjOXeWg+0c2CIjLbJSsZBC2BkCOiWxUyZ
         +45g==
X-Gm-Message-State: APjAAAWAf7H+AoKwjZvG3/nInXlreu/aSUxQpAdD2kZ4rkd0U7dOif21
        SK5AsyqruuqtXg6bIcbzkKiVBSUG
X-Google-Smtp-Source: APXvYqzuXMyDHWztobZOOWk3hK2legh6q/XV4enXiWrSBSl6kHaBtMjYba+1QyocXjlUKhNtofeKLA==
X-Received: by 2002:a17:90a:ec10:: with SMTP id l16mr2081518pjy.19.1579120959459;
        Wed, 15 Jan 2020 12:42:39 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r28sm21297398pgk.39.2020.01.15.12.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 12:42:38 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, rmk+kernel@armlinux.org.uk,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: phy: Maintain MDIO device and bus statistics
Date:   Wed, 15 Jan 2020 12:42:20 -0800
Message-Id: <20200115204228.26094-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We maintain global statistics for an entire MDIO bus, as well as broken
down, per MDIO bus address statistics. Given that it is possible for
MDIO devices such as switches to access MDIO bus addressies for which
there is not a mdio_device instance created (therefore not a a
corresponding device directory in sysfs either), we also maintain
per-address statistics under the statistics folder. The layout looks
like this:

/sys/class/mdio_bus/../statistics/
	transfers
	errrors
	writes
	reads
	transfers_<addr>
	errors_<addr>
	writes_<addr>
	reads_<addr>

When a mdio_device instance is registered, a statistics/ folder is
created with the tranfers, errors, writes and reads attributes which
point to the appropriate MDIO bus statistics structure.

Statistics are 64-bit unsigned quantities and maintained through the
u64_stats_sync.h helper functions.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- tracked per MDIO address statististics in separate attributes
- global statistics sum all per MDIO address statistics instead of
  requiring another stats structure

 Documentation/ABI/testing/sysfs-bus-mdio |  63 +++++++
 drivers/net/phy/mdio_bus.c               | 226 ++++++++++++++++++++++-
 include/linux/phy.h                      |  10 +
 3 files changed, 297 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-mdio

diff --git a/Documentation/ABI/testing/sysfs-bus-mdio b/Documentation/ABI/testing/sysfs-bus-mdio
new file mode 100644
index 000000000000..da86efc7781b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-mdio
@@ -0,0 +1,63 @@
+What:          /sys/bus/mdio_bus/devices/.../statistics/
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		This folder contains statistics about global and per
+		MDIO bus address statistics.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/transfers
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of transfers for this MDIO bus.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/errors
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of transfer errors for this MDIO bus.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/writes
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of write transactions for this MDIO bus.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/reads
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of read transactions for this MDIO bus.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/transfers_<addr>
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of transfers for this MDIO bus address.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/errors_<addr>
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of transfer errors for this MDIO bus address.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/writes_<addr>
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of write transactions for this MDIO bus address.
+
+What:          /sys/bus/mdio_bus/devices/.../statistics/reads_<addr>
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		Total number of read transactions for this MDIO bus address.
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 8d753bb07227..f2d017b09362 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -158,9 +158,11 @@ struct mii_bus *mdiobus_alloc_size(size_t size)
 	if (size)
 		bus->priv = (void *)bus + aligned_size;
 
-	/* Initialise the interrupts to polling */
-	for (i = 0; i < PHY_MAX_ADDR; i++)
+	/* Initialise the interrupts to polling and 64-bit seqcounts */
+	for (i = 0; i < PHY_MAX_ADDR; i++) {
 		bus->irq[i] = PHY_POLL;
+		u64_stats_init(&bus->stats[i].syncp);
+	}
 
 	return bus;
 }
@@ -249,9 +251,190 @@ static void mdiobus_release(struct device *d)
 	kfree(bus);
 }
 
+#define MDIO_BUS_STATS_ATTR(field, file)				\
+static ssize_t mdio_bus_##field##_show(struct device *dev,		\
+				       struct device_attribute *attr,	\
+				       char *buf)			\
+{									\
+	struct mii_bus *bus = to_mii_bus(dev);				\
+	return mdio_bus_global_stats_##field##_show(bus, buf);		\
+}									\
+static struct device_attribute dev_attr_mdio_bus_##field = {		\
+	.attr = { .name = file, .mode = 0444 },				\
+	.show = mdio_bus_##field##_show,				\
+};									\
+static ssize_t mdio_bus_device_##field##_show(struct device *dev,	\
+					      struct device_attribute *attr,\
+					      char *buf)		\
+{									\
+	struct mdio_device *mdiodev = to_mdio_device(dev);		\
+	struct mii_bus *bus = mdiodev->bus;				\
+	int addr = mdiodev->addr;					\
+	return mdio_bus_stats_##field##_show(&bus->stats[addr], buf);	\
+}									\
+static struct device_attribute dev_attr_mdio_bus_device_##field = {	\
+	.attr = { .name = file, .mode = 0444 },				\
+	.show = mdio_bus_device_##field##_show,				\
+}
+
+#define MDIO_BUS_STATS_SHOW_NAME(name, file, field)			\
+static ssize_t mdio_bus_stats_##name##_show(struct mdio_bus_stats *s,	\
+					    char *buf)			\
+{									\
+	unsigned int start;						\
+	ssize_t len;							\
+	u64 tmp = 0;							\
+	do {								\
+		start = u64_stats_fetch_begin(&s->syncp);		\
+		tmp += u64_stats_read(&s->field);			\
+	} while (u64_stats_fetch_retry(&s->syncp, start));		\
+	len = sprintf(buf, "%llu\n", tmp);				\
+	return len;							\
+}									\
+static ssize_t mdio_bus_global_stats_##name##_show(struct mii_bus *bus,	\
+						   char *buf)		\
+{									\
+	struct mdio_bus_stats *s;					\
+	unsigned int start;						\
+	unsigned int i;							\
+	ssize_t len;							\
+	u64 tmp = 0;							\
+	for (i = 0; i < PHY_MAX_ADDR; i++) {				\
+		s = &bus->stats[i];					\
+		do {							\
+			start = u64_stats_fetch_begin(&s->syncp);	\
+			tmp += u64_stats_read(&s->field);		\
+		} while (u64_stats_fetch_retry(&s->syncp, start));	\
+	}								\
+	len = sprintf(buf, "%llu\n", tmp);				\
+	return len;							\
+}									\
+MDIO_BUS_STATS_ATTR(name, file)
+
+#define MDIO_BUS_STATS_SHOW(field)					\
+	MDIO_BUS_STATS_SHOW_NAME(field, __stringify(field), field)
+
+#define MDIO_BUS_STATS_ADDR_ATTR(field, addr, file)			\
+static ssize_t mdio_bus_##field##_##addr##_show(struct device *dev,	\
+						struct device_attribute *attr, \
+						char *buf)		\
+{									\
+	struct mii_bus *bus = to_mii_bus(dev);				\
+	return mdio_bus_stats_##field##_show(&bus->stats[addr], buf);	\
+}									\
+static struct device_attribute dev_attr_mdio_bus_addr_##field##_##addr = { \
+	.attr = { .name = file, .mode = 0444 },				\
+	.show = mdio_bus_##field##_##addr##_show,			\
+}									\
+
+#define MDIO_BUS_STATS_ADDR_SHOW(field, addr)				\
+	MDIO_BUS_STATS_ADDR_ATTR(field, addr,				\
+				 __stringify(field) "_" __stringify(addr))
+
+MDIO_BUS_STATS_SHOW(transfers);
+MDIO_BUS_STATS_SHOW(errors);
+MDIO_BUS_STATS_SHOW(writes);
+MDIO_BUS_STATS_SHOW(reads);
+
+#define MDIO_BUS_STATS_ADDR_SHOW_GROUP(addr)				\
+	MDIO_BUS_STATS_ADDR_SHOW(transfers, addr);			\
+	MDIO_BUS_STATS_ADDR_SHOW(errors, addr);				\
+	MDIO_BUS_STATS_ADDR_SHOW(writes, addr);				\
+	MDIO_BUS_STATS_ADDR_SHOW(reads, addr)				\
+
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(0);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(1);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(2);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(3);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(4);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(5);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(6);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(7);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(8);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(9);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(10);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(11);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(12);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(13);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(14);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(15);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(16);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(17);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(18);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(19);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(20);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(21);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(22);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(23);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(24);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(25);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(26);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(27);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(28);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(29);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(30);
+MDIO_BUS_STATS_ADDR_SHOW_GROUP(31);
+
+#define MDIO_BUS_STATS_ADDR_ATTR_GROUP(addr)				\
+	&dev_attr_mdio_bus_addr_transfers_##addr.attr,			\
+	&dev_attr_mdio_bus_addr_errors_##addr.attr,			\
+	&dev_attr_mdio_bus_addr_writes_##addr.attr,			\
+	&dev_attr_mdio_bus_addr_reads_##addr.attr			\
+
+static struct attribute *mdio_bus_statistics_attrs[] = {
+	&dev_attr_mdio_bus_transfers.attr,
+	&dev_attr_mdio_bus_errors.attr,
+	&dev_attr_mdio_bus_writes.attr,
+	&dev_attr_mdio_bus_reads.attr,
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(0),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(1),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(2),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(3),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(4),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(5),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(6),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(7),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(8),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(9),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(10),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(11),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(12),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(13),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(14),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(15),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(16),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(17),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(18),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(19),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(20),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(21),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(22),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(23),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(24),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(25),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(26),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(27),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(28),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(29),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(30),
+	MDIO_BUS_STATS_ADDR_ATTR_GROUP(31),
+	NULL,
+};
+
+static const struct attribute_group mdio_bus_statistics_group = {
+	.name	= "statistics",
+	.attrs	= mdio_bus_statistics_attrs,
+};
+
+static const struct attribute_group *mdio_bus_groups[] = {
+	&mdio_bus_statistics_group,
+	NULL,
+};
+
 static struct class mdio_bus_class = {
 	.name		= "mdio_bus",
 	.dev_release	= mdiobus_release,
+	.dev_groups	= mdio_bus_groups,
 };
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
@@ -530,6 +713,24 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 }
 EXPORT_SYMBOL(mdiobus_scan);
 
+static void mdiobus_stats_acct(struct mdio_bus_stats *stats, bool op, int ret)
+{
+	u64_stats_update_begin(&stats->syncp);
+
+	u64_stats_inc(&stats->transfers);
+	if (ret < 0) {
+		u64_stats_inc(&stats->errors);
+		goto out;
+	}
+
+	if (op)
+		u64_stats_inc(&stats->reads);
+	else
+		u64_stats_inc(&stats->writes);
+out:
+	u64_stats_update_end(&stats->syncp);
+}
+
 /**
  * __mdiobus_read - Unlocked version of the mdiobus_read function
  * @bus: the mii_bus struct
@@ -549,6 +750,7 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 	retval = bus->read(bus, addr, regnum);
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
+	mdiobus_stats_acct(&bus->stats[addr], true, retval);
 
 	return retval;
 }
@@ -574,6 +776,7 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 	err = bus->write(bus, addr, regnum, val);
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
+	mdiobus_stats_acct(&bus->stats[addr], false, err);
 
 	return err;
 }
@@ -719,8 +922,27 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static struct attribute *mdio_bus_device_statistics_attrs[] = {
+	&dev_attr_mdio_bus_device_transfers.attr,
+	&dev_attr_mdio_bus_device_errors.attr,
+	&dev_attr_mdio_bus_device_writes.attr,
+	&dev_attr_mdio_bus_device_reads.attr,
+	NULL,
+};
+
+static const struct attribute_group mdio_bus_device_statistics_group = {
+	.name	= "statistics",
+	.attrs	= mdio_bus_device_statistics_attrs,
+};
+
+static const struct attribute_group *mdio_bus_dev_groups[] = {
+	&mdio_bus_device_statistics_group,
+	NULL,
+};
+
 struct bus_type mdio_bus_type = {
 	.name		= "mdio_bus",
+	.dev_groups	= mdio_bus_dev_groups,
 	.match		= mdio_bus_match,
 	.uevent		= mdio_uevent,
 };
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2929d0bc307f..b7de7d45135e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -22,6 +22,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/mod_devicetable.h>
+#include <linux/u64_stats_sync.h>
 
 #include <linux/atomic.h>
 
@@ -212,6 +213,14 @@ struct sfp_bus;
 struct sfp_upstream_ops;
 struct sk_buff;
 
+struct mdio_bus_stats {
+	struct u64_stats_sync syncp;
+	u64_stats_t transfers;
+	u64_stats_t errors;
+	u64_stats_t writes;
+	u64_stats_t reads;
+};
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -224,6 +233,7 @@ struct mii_bus {
 	int (*read)(struct mii_bus *bus, int addr, int regnum);
 	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
 	int (*reset)(struct mii_bus *bus);
+	struct mdio_bus_stats stats[PHY_MAX_ADDR];
 
 	/*
 	 * A lock to ensure that only one thing can read/write
-- 
2.17.1

