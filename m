Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A94138A7A
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 05:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbgAMEyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 23:54:16 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35789 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387525AbgAMEyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 23:54:15 -0500
Received: by mail-pj1-f66.google.com with SMTP id s7so3735250pjc.0;
        Sun, 12 Jan 2020 20:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jX6qkWmYXUSx+80QFz0j0DhZg4Qpek+NelAh9fppjdQ=;
        b=k3rG7LqnPF2FTFtwNb23rU9ImcmkpyUGYNl2N6+NgpWw7BLCFCt5N5XOguel+QfCnT
         Pu2ygmiFciJFAnMwLnJgFP5UmYr2QINIiUe2ajpKtq86l9lSym16rsoYWoBiLR51Vii7
         dQTdcR1IuiYpDerYrfDwCMpv9YpQg6UyEOQhrcDMzcH42f5EzfsSH2GvbNEvjqka9rwt
         3HPwkQVRZ6udFeJ+1KfnQUmWkfFq7gv2tmsiMRtTjcmchC9UiJ24uwno7blwVEL+RJfN
         gdT84Ss3aIymehIm5s21IAbpjJssdnEDjJA93xmi5O8MnOjqLWWWjYnq9lZJJ6gW1w+H
         owqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jX6qkWmYXUSx+80QFz0j0DhZg4Qpek+NelAh9fppjdQ=;
        b=gi/LECLA/j5a1eBpl+3ckkZ46KiWR6p4L7fx1o4WRV67su4flqBS8OSHGlsdur3mPW
         rBHvUZBwiN7qi31K73XH1yuGh65wX6gf44jBMXtlXcb3T38edeS7sM7PYOtEKN6vKyOb
         mlzmFQDuY51HRuC2KOFKmE5gNeNA+Nxj152Ai5ALhAlyGCQLA/yZ/r7nw+bSTmtVH8cZ
         P6AvVjJzvNzd0QmoaXA595TnSzBKQ679vOMi7AkH2wBCJGF9CtkHgQQ3im30w92Q38C4
         Osse3LEk72nwiWU3evLV5cHa6ooVUoIkEpgKgPlTFqFHEPEnv2tX+IOKec7JYeDD8i/J
         mHtA==
X-Gm-Message-State: APjAAAWYCnG4VsytSeXfO1BNN1wJ6ZFa8Q9UGP0jig+cH3BzALx0AiTO
        +F3Z0SNZZcM6u/9HzY/IPdIk4rf+
X-Google-Smtp-Source: APXvYqwtknO3kxI7C9uPremhfdNnAfkBAYhIa82+deb2Gh5ilyF0a59T2PPmW/2VtZ25g63FZgqORA==
X-Received: by 2002:a17:902:9b94:: with SMTP id y20mr5684488plp.291.1578891254243;
        Sun, 12 Jan 2020 20:54:14 -0800 (PST)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j8sm11723787pfe.182.2020.01.12.20.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 20:54:13 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, rmk+kernel@armlinux.org.uk, kuba@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: Maintain MDIO device and bus statistics
Date:   Sun, 12 Jan 2020 20:53:19 -0800
Message-Id: <20200113045325.13470-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maintain per MDIO device and MDIO bus statistics comprised of the number
of transfers/operations, reads and writes and errors. This is useful for
tracking the per-device and global MDIO bus bandwidth and doing
optimizations as necessary.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/ABI/testing/sysfs-bus-mdio |  34 +++++++
 drivers/net/phy/mdio_bus.c               | 116 +++++++++++++++++++++++
 drivers/net/phy/mdio_device.c            |   1 +
 include/linux/mdio.h                     |  10 ++
 include/linux/phy.h                      |   2 +
 5 files changed, 163 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-mdio

diff --git a/Documentation/ABI/testing/sysfs-bus-mdio b/Documentation/ABI/testing/sysfs-bus-mdio
new file mode 100644
index 000000000000..a552d92890f1
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-mdio
@@ -0,0 +1,34 @@
+What:          /sys/bus/mdio_bus/devices/.../statistics/
+Date:          January 2020
+KernelVersion: 5.6
+Contact:       netdev@vger.kernel.org
+Description:
+		This folder contains statistics about MDIO bus transactions.
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
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 229e480179ff..805bc2e3b139 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -168,6 +168,9 @@ struct mii_bus *mdiobus_alloc_size(size_t size)
 	for (i = 0; i < PHY_MAX_ADDR; i++)
 		bus->irq[i] = PHY_POLL;
 
+	/* Initialize 64-bit seqcounts */
+	u64_stats_init(&bus->stats.syncp);
+
 	return bus;
 }
 EXPORT_SYMBOL(mdiobus_alloc_size);
@@ -255,9 +258,77 @@ static void mdiobus_release(struct device *d)
 	kfree(bus);
 }
 
+#define MDIO_BUS_STATS_ATTR(field, file)				\
+static ssize_t mdio_bus_##field##_show(struct device *dev,		\
+				       struct device_attribute *attr,	\
+				       char *buf)			\
+{									\
+	struct mii_bus *bus = to_mii_bus(dev);				\
+	return mdio_bus_stats_##field##_show(&bus->stats, buf);		\
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
+	return mdio_bus_stats_##field##_show(&mdiodev->stats, buf);	\
+}									\
+static struct device_attribute dev_attr_mdio_bus_device_##field = {	\
+	.attr = { .name = file, .mode = 0444 },				\
+	.show = mdio_bus_device_##field##_show,				\
+}
+
+#define MDIO_BUS_STATS_SHOW_NAME(name, file, field, format_string)	\
+static ssize_t mdio_bus_stats_##name##_show(struct mdio_bus_stats *s,	\
+					    char *buf)			\
+{									\
+	unsigned int start;						\
+	ssize_t len;							\
+	u64 tmp;							\
+	do {								\
+		start = u64_stats_fetch_begin(&s->syncp);		\
+		tmp = u64_stats_read(&s->field);			\
+	} while (u64_stats_fetch_retry(&s->syncp, start));		\
+	len = sprintf(buf, format_string ## "\n", tmp);			\
+	return len;							\
+}									\
+MDIO_BUS_STATS_ATTR(name, file)
+
+#define MDIO_BUS_STATS_SHOW(field, format_string)			\
+	MDIO_BUS_STATS_SHOW_NAME(field, __stringify(field),		\
+				      field, format_string)
+
+MDIO_BUS_STATS_SHOW(transfers, "%llu");
+MDIO_BUS_STATS_SHOW(errors, "%llu");
+MDIO_BUS_STATS_SHOW(writes, "%llu");
+MDIO_BUS_STATS_SHOW(reads, "%llu");
+
+static struct attribute *mdio_bus_statistics_attrs[] = {
+	&dev_attr_mdio_bus_transfers.attr,
+	&dev_attr_mdio_bus_errors.attr,
+	&dev_attr_mdio_bus_writes.attr,
+	&dev_attr_mdio_bus_reads.attr,
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
@@ -536,6 +607,24 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
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
@@ -548,6 +637,7 @@ EXPORT_SYMBOL(mdiobus_scan);
  */
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 {
+	struct mdio_device *mdiodev = bus->mdio_map[addr];
 	int retval;
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
@@ -555,6 +645,9 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 	retval = bus->read(bus, addr, regnum);
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
+	mdiobus_stats_acct(&bus->stats, true, retval);
+	if (mdiodev)
+		mdiobus_stats_acct(&mdiodev->stats, true, retval);
 
 	return retval;
 }
@@ -573,6 +666,7 @@ EXPORT_SYMBOL(__mdiobus_read);
  */
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 {
+	struct mdio_device *mdiodev = bus->mdio_map[addr];
 	int err;
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
@@ -580,6 +674,9 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 	err = bus->write(bus, addr, regnum, val);
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
+	mdiobus_stats_acct(&bus->stats, false, err);
+	if (mdiodev)
+		mdiobus_stats_acct(&mdiodev->stats, false, err);
 
 	return err;
 }
@@ -725,8 +822,27 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
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
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index c1d345c3cab3..e89ed990de7d 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -53,6 +53,7 @@ struct mdio_device *mdio_device_create(struct mii_bus *bus, int addr)
 	if (!mdiodev)
 		return ERR_PTR(-ENOMEM);
 
+	u64_stats_init(&mdiodev->stats.syncp);
 	mdiodev->dev.release = mdio_device_release;
 	mdiodev->dev.parent = &bus->dev;
 	mdiodev->dev.bus = &mdio_bus_type;
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index a7604248777b..d6035d973a0d 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -8,6 +8,7 @@
 
 #include <uapi/linux/mdio.h>
 #include <linux/mod_devicetable.h>
+#include <linux/u64_stats_sync.h>
 
 struct gpio_desc;
 struct mii_bus;
@@ -23,11 +24,20 @@ enum mdio_mutex_lock_class {
 	MDIO_MUTEX_NESTED,
 };
 
+struct mdio_bus_stats {
+	struct u64_stats_sync syncp;
+	u64_stats_t transfers;
+	u64_stats_t errors;
+	u64_stats_t writes;
+	u64_stats_t reads;
+};
+
 struct mdio_device {
 	struct device dev;
 
 	struct mii_bus *bus;
 	char modalias[MDIO_NAME_SIZE];
+	struct mdio_bus_stats stats;
 
 	int (*bus_match)(struct device *dev, struct device_driver *drv);
 	void (*device_free)(struct mdio_device *mdiodev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5932bb8e9c35..8d3ac1ebfef2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -22,6 +22,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/mod_devicetable.h>
+#include <linux/u64_stats_sync.h>
 
 #include <linux/atomic.h>
 
@@ -224,6 +225,7 @@ struct mii_bus {
 	int (*read)(struct mii_bus *bus, int addr, int regnum);
 	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
 	int (*reset)(struct mii_bus *bus);
+	struct mdio_bus_stats stats;
 
 	/*
 	 * A lock to ensure that only one thing can read/write
-- 
2.19.1

