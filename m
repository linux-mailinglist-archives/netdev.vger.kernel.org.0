Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F0213D347
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 05:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgAPEtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 23:49:04 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39542 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgAPEtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 23:49:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id b137so9262253pga.6;
        Wed, 15 Jan 2020 20:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NNgC8URUObjPh/YC7hnq+98De8oAXFfUTUmW2MkxkCU=;
        b=QW4UoIBlHOeUYdmwwg4VZzqc/0D2TnvYNCLrXm55cHxmPxdXBzBJd0ppFom6yWzzc6
         HvuPm8xa1Re6vu2y4hplGebo0+S2NZYFa+h3iiOvpx6B2BKfpF4F45Pcdd/Ie9hWj3Di
         4w4u/gllh6Zw9sj46k9nWJvpZ5LVvGvcc/DxHJX9HsY3RNHRzm8DkSRKAx/swVRKlVJZ
         LufkY9SasMbMB59Kp60AbBx7NTHuHd6fSV8ua/jheOS6pbhVGgyLH2VYOsMr24m1LG1j
         OUeh5IsKVAi19kt9mEd8O2R/ri17PCQNT3rAm4fDMmG6qFdpONypzaLDz0vo3kAhHzET
         7N4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NNgC8URUObjPh/YC7hnq+98De8oAXFfUTUmW2MkxkCU=;
        b=EWbzagu4UefrYTNZK4RvCaL6GDumxxuekE4OEr7pgXOBXzbBRjhwsoRqr+cmpuYO65
         3j/ZhLPXERpZoefhRq3dRz0P6/FuS55vGJET1VpYFoEy1BbkXsNE9Q+ylSSqmbwE9qNa
         XItCvDPBItRIW8qSs9lmUlY5p1wjtnlgVHYiCBL6Jz2L8uGXbiySqspsEwa89iDGj95u
         73BxZNSHbAbAh9he0GVxbuxUQ2W/OqeHRQOUjggnjHrziukfh0TQPaYpV0HGqg1Gp0L0
         mSgKvOILOZvaRgHLKYouTi+z8gQNDKe8Zs63YoxEFcqqsQPG5ysTJ5y5Jl9ZjzFY3IrG
         Mfxw==
X-Gm-Message-State: APjAAAUqtodvEcfOXmA3WhvK6fOGzONUY5sUF/zQRMWePg6+arCRxpCT
        KA8xz0nJWRMgV2RKz2o/zijd5O45
X-Google-Smtp-Source: APXvYqxTTBAaexaKv26C0+W/misLuI+Zah1nh40YPpOBtcZXizsfZpT//0wBGWNjncbK4BswyNGIUA==
X-Received: by 2002:a62:296:: with SMTP id 144mr35646687pfc.120.1579150142883;
        Wed, 15 Jan 2020 20:49:02 -0800 (PST)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w11sm24173488pfi.77.2020.01.15.20.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 20:49:02 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, rmk+kernel@armlinux.org.uk,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v3] net: phy: Maintain MDIO device and bus statistics
Date:   Wed, 15 Jan 2020 20:48:50 -0800
Message-Id: <20200116044856.1819-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We maintain global statistics for an entire MDIO bus, as well as broken
down, per MDIO bus address statistics. Given that it is possible for
MDIO devices such as switches to access MDIO bus addresses for which
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
Changes in v3:

- make extensive use of dev_ext_attribute which allows us to reduce
  the number of "show" functions down to only two, this represents a
  51.57% reduction in text segment compared to v2. We store the
  address and the field offset from within the structure int the
  dev_ext_attribute "var" field and declare our structures anonymously
- greatly remove the use of macros to ease code maintenance

Changes in v2:

- tracked per MDIO address statististics in separate attributes
- global statistics sum all per MDIO address statistics instead of
  requiring another stats structure

 Documentation/ABI/testing/sysfs-bus-mdio |  63 ++++++
 drivers/net/phy/mdio_bus.c               | 251 ++++++++++++++++++++++-
 include/linux/phy.h                      |  11 +
 3 files changed, 323 insertions(+), 2 deletions(-)
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
index 8d753bb07227..9bb9f37f21dc 100644
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
@@ -249,9 +251,215 @@ static void mdiobus_release(struct device *d)
 	kfree(bus);
 }
 
+struct mdio_bus_stat_attr {
+	int addr;
+	unsigned int field_offset;
+};
+
+static u64 mdio_bus_get_stat(struct mdio_bus_stats *s, unsigned int offset)
+{
+	const char *p = (const char *)s + offset;
+	unsigned int start;
+	u64 val = 0;
+
+	do {
+		start = u64_stats_fetch_begin(&s->syncp);
+		val = u64_stats_read((const u64_stats_t *)p);
+	} while (u64_stats_fetch_retry(&s->syncp, start));
+
+	return val;
+}
+
+static u64 mdio_bus_get_global_stat(struct mii_bus *bus, unsigned int offset)
+{
+	unsigned int i;
+	u64 val = 0;
+
+	for (i = 0; i < PHY_MAX_ADDR; i++)
+		val += mdio_bus_get_stat(&bus->stats[i], offset);
+
+	return val;
+}
+
+static ssize_t mdio_bus_stat_field_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct mii_bus *bus = to_mii_bus(dev);
+	struct mdio_bus_stat_attr *sattr;
+	struct dev_ext_attribute *eattr;
+	u64 val;
+
+	eattr = container_of(attr, struct dev_ext_attribute, attr);
+	sattr = eattr->var;
+
+	if (sattr->addr < 0)
+		val = mdio_bus_get_global_stat(bus, sattr->field_offset);
+	else
+		val = mdio_bus_get_stat(&bus->stats[sattr->addr],
+					sattr->field_offset);
+
+	return sprintf(buf, "%llu\n", val);
+}
+
+static ssize_t mdio_bus_device_stat_field_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct mdio_device *mdiodev = to_mdio_device(dev);
+	struct mii_bus *bus = mdiodev->bus;
+	struct mdio_bus_stat_attr *sattr;
+	struct dev_ext_attribute *eattr;
+	int addr = mdiodev->addr;
+	u64 val;
+
+	eattr = container_of(attr, struct dev_ext_attribute, attr);
+	sattr = eattr->var;
+
+	val = mdio_bus_get_stat(&bus->stats[addr], sattr->field_offset);
+
+	return sprintf(buf, "%llu\n", val);
+}
+
+#define MDIO_BUS_STATS_ATTR_DECL(field, file)				\
+static struct dev_ext_attribute dev_attr_mdio_bus_##field = {		\
+	.attr = { .attr = { .name = file, .mode = 0444 },		\
+		     .show = mdio_bus_stat_field_show,			\
+	},								\
+	.var = &((struct mdio_bus_stat_attr) {				\
+		-1, offsetof(struct mdio_bus_stats, field)		\
+	}),								\
+};									\
+static struct dev_ext_attribute dev_attr_mdio_bus_device_##field = {	\
+	.attr = { .attr = { .name = file, .mode = 0444 },		\
+		     .show = mdio_bus_device_stat_field_show,		\
+	},								\
+	.var = &((struct mdio_bus_stat_attr) {				\
+		-1, offsetof(struct mdio_bus_stats, field)		\
+	}),								\
+};
+
+#define MDIO_BUS_STATS_ATTR(field)					\
+	MDIO_BUS_STATS_ATTR_DECL(field, __stringify(field))
+
+MDIO_BUS_STATS_ATTR(transfers);
+MDIO_BUS_STATS_ATTR(errors);
+MDIO_BUS_STATS_ATTR(writes);
+MDIO_BUS_STATS_ATTR(reads);
+
+#define MDIO_BUS_STATS_ADDR_ATTR_DECL(field, addr, file)		\
+static struct dev_ext_attribute dev_attr_mdio_bus_addr_##field##_##addr = { \
+	.attr = { .attr = { .name = file, .mode = 0444 },		\
+		     .show = mdio_bus_stat_field_show,			\
+	},								\
+	.var = &((struct mdio_bus_stat_attr) {				\
+		addr, offsetof(struct mdio_bus_stats, field)		\
+	}),								\
+}
+
+#define MDIO_BUS_STATS_ADDR_ATTR(field, addr)				\
+	MDIO_BUS_STATS_ADDR_ATTR_DECL(field, addr,			\
+				 __stringify(field) "_" __stringify(addr))
+
+#define MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(addr)			\
+	MDIO_BUS_STATS_ADDR_ATTR(transfers, addr);			\
+	MDIO_BUS_STATS_ADDR_ATTR(errors, addr);				\
+	MDIO_BUS_STATS_ADDR_ATTR(writes, addr);				\
+	MDIO_BUS_STATS_ADDR_ATTR(reads, addr)				\
+
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(0);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(1);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(2);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(3);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(4);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(5);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(6);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(7);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(8);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(9);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(10);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(11);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(12);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(13);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(14);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(15);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(16);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(17);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(18);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(19);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(20);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(21);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(22);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(23);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(24);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(25);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(26);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(27);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(28);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(29);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(30);
+MDIO_BUS_STATS_ADDR_ATTR_GROUP_DECL(31);
+
+#define MDIO_BUS_STATS_ADDR_ATTR_GROUP(addr)				\
+	&dev_attr_mdio_bus_addr_transfers_##addr.attr.attr,		\
+	&dev_attr_mdio_bus_addr_errors_##addr.attr.attr,		\
+	&dev_attr_mdio_bus_addr_writes_##addr.attr.attr,		\
+	&dev_attr_mdio_bus_addr_reads_##addr.attr.attr			\
+
+static struct attribute *mdio_bus_statistics_attrs[] = {
+	&dev_attr_mdio_bus_transfers.attr.attr,
+	&dev_attr_mdio_bus_errors.attr.attr,
+	&dev_attr_mdio_bus_writes.attr.attr,
+	&dev_attr_mdio_bus_reads.attr.attr,
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
@@ -530,6 +738,24 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
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
@@ -549,6 +775,7 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 	retval = bus->read(bus, addr, regnum);
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
+	mdiobus_stats_acct(&bus->stats[addr], true, retval);
 
 	return retval;
 }
@@ -574,6 +801,7 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 	err = bus->write(bus, addr, regnum, val);
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
+	mdiobus_stats_acct(&bus->stats[addr], false, err);
 
 	return err;
 }
@@ -719,8 +947,27 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static struct attribute *mdio_bus_device_statistics_attrs[] = {
+	&dev_attr_mdio_bus_device_transfers.attr.attr,
+	&dev_attr_mdio_bus_device_errors.attr.attr,
+	&dev_attr_mdio_bus_device_writes.attr.attr,
+	&dev_attr_mdio_bus_device_reads.attr.attr,
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
index 2929d0bc307f..99a87f02667f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -22,6 +22,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/mod_devicetable.h>
+#include <linux/u64_stats_sync.h>
 
 #include <linux/atomic.h>
 
@@ -212,6 +213,15 @@ struct sfp_bus;
 struct sfp_upstream_ops;
 struct sk_buff;
 
+struct mdio_bus_stats {
+	u64_stats_t transfers;
+	u64_stats_t errors;
+	u64_stats_t writes;
+	u64_stats_t reads;
+	/* Must be last, add new statistics above */
+	struct u64_stats_sync syncp;
+};
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -224,6 +234,7 @@ struct mii_bus {
 	int (*read)(struct mii_bus *bus, int addr, int regnum);
 	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
 	int (*reset)(struct mii_bus *bus);
+	struct mdio_bus_stats stats[PHY_MAX_ADDR];
 
 	/*
 	 * A lock to ensure that only one thing can read/write
-- 
2.19.1

