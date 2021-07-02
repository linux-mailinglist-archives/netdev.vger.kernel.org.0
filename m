Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5C73B9BD2
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 07:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhGBFI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 01:08:26 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:45022 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhGBFIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 01:08:24 -0400
Received: by mail-pf1-f175.google.com with SMTP id g21so7935727pfc.11;
        Thu, 01 Jul 2021 22:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZHyt3+LG2baJPoF6oYUnqH2Ny32xxJeP55C1q2v0yjU=;
        b=IcxXVS7qsf/CRSG6Ai9M5Ed6NKyZNZvFSM4obGzOrBNMSq6gvuB4fOoPxLldKFPsZY
         fGy43/fIxLK3Q1jCMlFIYeOc0DL11PZgu3gbMgneMa5fS6oBM+9iKUqxnQUV720+edsr
         qx5veg8NBJenYCpHPujva48BE6iMVMKZgJoi2fFP2ilU1sODAdu9zmfXSV8aGq9he/3w
         R2dfBKU7c/RRiFfuSWlgcZuT3qbHC+kbWv4UUkxfIIYFueddaQGxokz+gZVzQttIaeJj
         JRzYyvBqS6R2E9DOL1DKzcmV7QmPjtj67//m+jT8GXBEEWRuxRgbsRJ2qQBZn7ZEVxVs
         QAzA==
X-Gm-Message-State: AOAM532ogLvQJgevRO+qH/GxkWpdwIes0CRptxCqRkS/K/ZV03Aqrfc6
        GGuEviPaY+z0MwrfxwzMs9I=
X-Google-Smtp-Source: ABdhPJwQmgBWpGocCbyEu0g8XIOKIG/7LyO6WvorZddl8nZ2mB4zIbh6lcMsQU9xRVlET7N4VV4ufQ==
X-Received: by 2002:a62:dd83:0:b029:2e8:e511:c32f with SMTP id w125-20020a62dd830000b02902e8e511c32fmr3345881pff.49.1625202351800;
        Thu, 01 Jul 2021 22:05:51 -0700 (PDT)
Received: from localhost ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id r21sm11535226pjz.12.2021.07.01.22.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 22:05:51 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org, tj@kernel.org, shuah@kernel.org,
        akpm@linux-foundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com
Cc:     jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        mcgrof@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] selftests: add tests_sysfs module
Date:   Thu,  1 Jul 2021 22:05:40 -0700
Message-Id: <20210702050543.2693141-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702050543.2693141-1-mcgrof@kernel.org>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a new selftest module which can be used to test sysfs, which
would otherwise require using an existing driver. This lets us muck
with a template driver to test breaking things without affecting
system behaviour or requiring the dependencies of a real device
driver.

A series of 28 tests are added. Support for using two device types are
supported:

  * misc
  * block

Contrary to sysctls, sysfs requires a full write to happen at once, and
so we reduce the digit tests to single writes. Two main sysfs knobs are
provided for testing reading/storing, one which doesn't inclur any
delays and another which can incur programmed delays. What locks are
held, if any, are configurable, at module load time, or through dynamic
configuration at run time.

Since sysfs is a technically filesystem, but a pseudo one, which
requires a kernel user, our test_sysfs module and respective test script
embraces fstests format for tests in the kernel ring bufffer. Likewise,
a scraper for kernel crashes is provided which matches what fstests does
as well.

Two tests are kept disabled as they currently cause a deadlock, and so
this provides a mechanism to easily show proof and demo how the deadlock
can happen:

Demos the deadlock with a device specific lock
./tools/testing/selftests/sysfs/sysfs.sh -t 0027

Demos the deadlock with rtnl_lock()
./tools/testing/selftests/sysfs/sysfs.sh -t 0028

Two separate solutions to the deadlock issue have been proposed,
and so now its a matter of either documenting this limitation or
eventually adopting a generic fix.

This selftests will shortly be expanded upon with more tests which
require further kernel changes in order to provide better test
coverage.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 MAINTAINERS                            |    7 +
 lib/Kconfig.debug                      |   10 +
 lib/Makefile                           |    1 +
 lib/test_sysfs.c                       |  953 +++++++++++++++++++
 tools/testing/selftests/sysfs/Makefile |   12 +
 tools/testing/selftests/sysfs/config   |    2 +
 tools/testing/selftests/sysfs/sysfs.sh | 1202 ++++++++++++++++++++++++
 7 files changed, 2187 insertions(+)
 create mode 100644 lib/test_sysfs.c
 create mode 100644 tools/testing/selftests/sysfs/Makefile
 create mode 100644 tools/testing/selftests/sysfs/config
 create mode 100755 tools/testing/selftests/sysfs/sysfs.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 80ae7dbf8723..76f6bee86770 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17705,6 +17705,13 @@ L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-pci-dwc-mshc.c
 
+SYSFS TEST DRIVER
+M:	Luis Chamberlain <mcgrof@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	lib/test_sysfs.c
+F:	tools/testing/selftests/sysfs/
+
 SYSTEM CONFIGURATION (SYSCON)
 M:	Lee Jones <lee.jones@linaro.org>
 M:	Arnd Bergmann <arnd@arndb.de>
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d1467658361f..f9b9074c40f4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2343,6 +2343,16 @@ config TEST_SYSCTL
 
 	  If unsure, say N.
 
+config TEST_SYSFS
+	tristate "sysfs test driver"
+	depends on SYSFS
+	help
+	  This builds the "test_sysfs" module. This driver enables to test the
+	  sysfs file system safely without affecting production knobs which
+	  might alter system functionality.
+
+	  If unsure, say N.
+
 config BITFIELD_KUNIT
 	tristate "KUnit test bitfield functions at runtime"
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index f982b8f94007..f151cb9e428a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
 obj-$(CONFIG_TEST_BITOPS) += test_bitops.o
 CFLAGS_test_bitops.o += -Werror
 obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
+obj-$(CONFIG_TEST_SYSFS) += test_sysfs.o
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
 obj-$(CONFIG_TEST_IDA) += test_ida.o
 obj-$(CONFIG_KASAN_KUNIT_TEST) += test_kasan.o
diff --git a/lib/test_sysfs.c b/lib/test_sysfs.c
new file mode 100644
index 000000000000..8e844e30e8f9
--- /dev/null
+++ b/lib/test_sysfs.c
@@ -0,0 +1,953 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * sysfs test driver
+ *
+ * Copyright (C) 2021 Luis Chamberlain <mcgrof@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or at your option any
+ * later version; or, when distributed separately from the Linux kernel or
+ * when incorporated into other software packages, subject to the following
+ * license:
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of copyleft-next (version 0.3.1 or later) as published
+ * at http://copyleft-next.org/.
+ */
+
+/*
+ * This module allows us to add race conditions which we can test for
+ * against the sysfs filesystem.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/async.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <linux/rtnetlink.h>
+#include <linux/genhd.h>
+#include <linux/blkdev.h>
+
+static bool enable_lock;
+module_param(enable_lock, bool_enable_only, 0644);
+MODULE_PARM_DESC(enable_lock,
+		 "enable locking on reads / stores from the start");
+
+static bool enable_lock_on_rmmod;
+module_param(enable_lock_on_rmmod, bool_enable_only, 0644);
+MODULE_PARM_DESC(enable_lock_on_rmmod,
+		 "enable locking on rmmod");
+
+static bool use_rtnl_lock;
+module_param(use_rtnl_lock, bool_enable_only, 0644);
+MODULE_PARM_DESC(use_rtnl_lock,
+		 "use an rtnl_lock instead of the device mutex_lock");
+
+static unsigned int write_delay_msec_y = 500;
+module_param_named(write_delay_msec_y, write_delay_msec_y, uint, 0644);
+MODULE_PARM_DESC(write_delay_msec_y, "msec write delay for writes to y");
+
+static unsigned int test_devtype;
+module_param_named(devtype, test_devtype, uint, 0644);
+MODULE_PARM_DESC(devtype, "device type to register");
+
+static bool enable_busy_alloc;
+module_param(enable_busy_alloc, bool_enable_only, 0644);
+MODULE_PARM_DESC(enable_busy_alloc, "do a fake allocation during writes");
+
+static bool enable_debugfs;
+module_param(enable_debugfs, bool_enable_only, 0644);
+MODULE_PARM_DESC(enable_debugfs, "enable a few debugfs files");
+
+static bool enable_verbose_writes;
+module_param(enable_verbose_writes, bool_enable_only, 0644);
+MODULE_PARM_DESC(enable_debugfs, "enable stores to print verbose information");
+
+static unsigned int delay_rmmod_ms;
+module_param_named(delay_rmmod_ms, delay_rmmod_ms, uint, 0644);
+MODULE_PARM_DESC(delay_rmmod_ms, "if set how many ms to delay rmmod before device deletion");
+
+static bool enable_verbose_rmmod;
+module_param(enable_verbose_rmmod, bool_enable_only, 0644);
+MODULE_PARM_DESC(enable_verbose_rmmod, "enable verbose print messages on rmmod");
+
+static int sysfs_test_major;
+
+/**
+ * test_config - used for configuring how the sysfs test device will behave
+ *
+ * @enable_lock: if enabled a lock will be used when reading/storing variables
+ * @enable_lock_on_rmmod: if enabled a lock will be used when reading/storing
+ *	sysfs attributes, but it will also be used to lock on rmmod. This is
+ *	useful to test for a deadlock.
+ * @use_rtnl_lock: if enabled instead of configuration specific mutex, we'll
+ *	use the rtnl_lock. If your test case is modifying this on the fly
+ *	while doing other stores / reads, things will break as a lock can be
+ *	left contending. Best is that tests use this knob serially, without
+ *	allowing userspace to modify other knobs while this one changes.
+ * @write_delay_msec_y: the amount of delay to use when writing to y
+ * @enable_busy_alloc: if enabled we'll do a large allocation between
+ *	writes. We immediately free right away. We also schedule to give the
+ *	kernel some time to re-use any memory we don't need. This is intened
+ *	to mimic typical driver behaviour.
+ */
+struct test_config {
+	bool enable_lock;
+	bool enable_lock_on_rmmod;
+	bool use_rtnl_lock;
+	unsigned int write_delay_msec_y;
+	bool enable_busy_alloc;
+};
+
+/**
+ * enum sysfs_test_devtype - sysfs device type
+ * @TESTDEV_TYPE_MISC: misc device type
+ * @TESTDEV_TYPE_BLOCK: use a block device for the sysfs test device.
+ */
+enum sysfs_test_devtype {
+	TESTDEV_TYPE_MISC = 0,
+	TESTDEV_TYPE_BLOCK,
+};
+
+/**
+ * sysfs_test_device - test device to help test sysfs
+ *
+ * @devtype: the type of device to use
+ * @config: configuration for the test
+ * @config_mutex: protects configuration of test
+ * @misc_dev: we use a misc device under the hood
+ * @disk: represents a disk when used as a block device
+ * @dev: pointer to misc_dev's own struct device
+ * @dev_idx: unique ID for test device
+ * @x: variable we can use to test read / store
+ * @y: slow variable we can use to test read / store
+ */
+struct sysfs_test_device {
+	enum sysfs_test_devtype devtype;
+	struct test_config config;
+	struct mutex config_mutex;
+	struct miscdevice misc_dev;
+	struct gendisk *disk;
+	struct device *dev;
+	int dev_idx;
+	int x;
+	int y;
+};
+
+struct sysfs_test_device *first_test_dev;
+
+static struct miscdevice *dev_to_misc_dev(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static struct sysfs_test_device *misc_dev_to_test_dev(struct miscdevice *misc_dev)
+{
+	return container_of(misc_dev, struct sysfs_test_device, misc_dev);
+}
+
+static struct sysfs_test_device *devblock_to_test_dev(struct device *dev)
+{
+	return (struct sysfs_test_device *)dev_to_disk(dev)->private_data;
+}
+
+static struct sysfs_test_device *devmisc_to_testdev(struct device *dev)
+{
+	struct miscdevice *misc_dev;
+
+	misc_dev = dev_to_misc_dev(dev);
+	return misc_dev_to_test_dev(misc_dev);
+}
+
+static struct sysfs_test_device *dev_to_test_dev(struct device *dev)
+{
+	if (test_devtype == TESTDEV_TYPE_MISC)
+		return devmisc_to_testdev(dev);
+	else if (test_devtype == TESTDEV_TYPE_BLOCK)
+		return devblock_to_test_dev(dev);
+	return NULL;
+}
+
+static void test_dev_config_lock(struct sysfs_test_device *test_dev)
+{
+	struct test_config *config;
+
+	config = &test_dev->config;
+	if (config->enable_lock) {
+		if (config->use_rtnl_lock)
+			rtnl_lock();
+		else
+			mutex_lock(&test_dev->config_mutex);
+	}
+}
+
+static void test_dev_config_unlock(struct sysfs_test_device *test_dev)
+{
+	struct test_config *config;
+
+	config = &test_dev->config;
+	if (config->enable_lock) {
+		if (config->use_rtnl_lock)
+			rtnl_unlock();
+		else
+			mutex_unlock(&test_dev->config_mutex);
+	}
+}
+
+static void test_dev_config_lock_rmmod(struct sysfs_test_device *test_dev)
+{
+	struct test_config *config;
+
+	config = &test_dev->config;
+	if (config->enable_lock_on_rmmod)
+		test_dev_config_lock(test_dev);
+}
+
+static void test_dev_config_unlock_rmmod(struct sysfs_test_device *test_dev)
+{
+	struct test_config *config;
+
+	config = &test_dev->config;
+	if (config->enable_lock_on_rmmod)
+		test_dev_config_unlock(test_dev);
+}
+
+static void free_test_dev_sysfs(struct sysfs_test_device *test_dev)
+{
+	if (test_dev) {
+		kfree_const(test_dev->misc_dev.name);
+		test_dev->misc_dev.name = NULL;
+		kfree(test_dev);
+		test_dev = NULL;
+	}
+}
+
+static void test_sysfs_reset_vals(struct sysfs_test_device *test_dev)
+{
+	test_dev->x = 3;
+	test_dev->y = 4;
+}
+
+static ssize_t config_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config = &test_dev->config;
+	int len = 0;
+
+	test_dev_config_lock(test_dev);
+
+	len += snprintf(buf, PAGE_SIZE,
+			"Configuration for: %s\n",
+			dev_name(dev));
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"x:\t%d\n",
+			test_dev->x);
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"y:\t%d\n",
+			test_dev->y);
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"enable_lock:\t%s\n",
+			config->enable_lock ? "true" : "false");
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"enable_lock_on_rmmmod:\t%s\n",
+			config->enable_lock_on_rmmod ? "true" : "false");
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"use_rtnl_lock:\t%s\n",
+			config->use_rtnl_lock ? "true" : "false");
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"write_delay_msec_y:\t%d\n",
+			config->write_delay_msec_y);
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"enable_busy_alloc:\t%s\n",
+			config->enable_busy_alloc ? "true" : "false");
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"enable_debugfs:\t%s\n",
+			enable_debugfs ? "true" : "false");
+
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"enable_verbose_writes:\t%s\n",
+			enable_verbose_writes ? "true" : "false");
+
+	test_dev_config_unlock(test_dev);
+
+	return len;
+}
+static DEVICE_ATTR_RO(config);
+
+static ssize_t reset_store(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+
+	config = &test_dev->config;
+
+	/*
+	 * We compromise and simplify this condition and do not use a lock
+	 * here as the lock type can change.
+	 */
+	config->enable_lock = false;
+	config->enable_lock_on_rmmod = false;
+	config->use_rtnl_lock = false;
+	config->enable_busy_alloc = false;
+	test_sysfs_reset_vals(test_dev);
+
+	dev_info(dev, "reset\n");
+
+	return count;
+}
+static DEVICE_ATTR_WO(reset);
+
+static void test_dev_busy_alloc(struct sysfs_test_device *test_dev)
+{
+	struct test_config *config;
+	char *ignore;
+
+	config = &test_dev->config;
+	if (!config->enable_busy_alloc)
+		return;
+
+	ignore = kzalloc(sizeof(struct sysfs_test_device) * 10, GFP_KERNEL);
+	kfree(ignore);
+
+	schedule();
+}
+
+static ssize_t test_dev_x_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	int ret;
+
+	test_dev_busy_alloc(test_dev);
+	test_dev_config_lock(test_dev);
+
+	ret = kstrtoint(buf, 10, &test_dev->x);
+	if (ret)
+		count = ret;
+
+	if (enable_verbose_writes)
+		dev_info(test_dev->dev, "wrote x = %d\n", test_dev->x);
+
+	test_dev_config_unlock(test_dev);
+
+	return count;
+}
+
+static ssize_t test_dev_x_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	int ret;
+
+	test_dev_config_lock(test_dev);
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", test_dev->x);
+	test_dev_config_unlock(test_dev);
+
+	return ret;
+}
+static DEVICE_ATTR_RW(test_dev_x);
+
+static ssize_t test_dev_y_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	int y;
+	int ret;
+
+	test_dev_busy_alloc(test_dev);
+	test_dev_config_lock(test_dev);
+
+	config = &test_dev->config;
+
+	ret = kstrtoint(buf, 10, &y);
+	if (ret)
+		count = ret;
+
+	msleep(config->write_delay_msec_y);
+	test_dev->y = test_dev->x + y + 7;
+
+	if (enable_verbose_writes)
+		dev_info(test_dev->dev, "wrote y = %d\n", test_dev->y);
+
+	test_dev_config_unlock(test_dev);
+
+	return count;
+}
+
+static ssize_t test_dev_y_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	int ret;
+
+	test_dev_config_lock(test_dev);
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", test_dev->y);
+	test_dev_config_unlock(test_dev);
+
+	return ret;
+}
+static DEVICE_ATTR_RW(test_dev_y);
+
+static ssize_t config_enable_lock_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	int ret;
+	int val;
+
+	config = &test_dev->config;
+	ret = kstrtoint(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	/*
+	 * We compromise for simplicty and do not lock when changing
+	 * locking configuration, with the assumption userspace tests
+	 * will know this.
+	 */
+	if (val)
+		config->enable_lock = true;
+	else
+		config->enable_lock = false;
+
+	return count;
+}
+
+static ssize_t config_enable_lock_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	ssize_t ret;
+
+	config = &test_dev->config;
+
+	test_dev_config_lock(test_dev);
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", config->enable_lock);
+	test_dev_config_unlock(test_dev);
+
+	return ret;
+}
+static DEVICE_ATTR_RW(config_enable_lock);
+
+static ssize_t config_enable_lock_on_rmmod_store(struct device *dev,
+						 struct device_attribute *attr,
+						 const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	int ret;
+	int val;
+
+	config = &test_dev->config;
+	ret = kstrtoint(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	test_dev_config_lock(test_dev);
+	if (val)
+		config->enable_lock_on_rmmod = true;
+	else
+		config->enable_lock_on_rmmod = false;
+	test_dev_config_unlock(test_dev);
+
+	return count;
+}
+
+static ssize_t config_enable_lock_on_rmmod_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	ssize_t ret;
+
+	config = &test_dev->config;
+
+	test_dev_config_lock(test_dev);
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", config->enable_lock_on_rmmod);
+	test_dev_config_unlock(test_dev);
+
+	return ret;
+}
+static DEVICE_ATTR_RW(config_enable_lock_on_rmmod);
+
+static ssize_t config_use_rtnl_lock_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	int ret;
+	int val;
+
+	config = &test_dev->config;
+	ret = kstrtoint(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	/*
+	 * We compromise and simplify this condition and do not use a lock
+	 * here as the lock type can change.
+	 */
+	if (val)
+		config->use_rtnl_lock = true;
+	else
+		config->use_rtnl_lock = false;
+
+	return count;
+}
+
+static ssize_t config_use_rtnl_lock_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+
+	config = &test_dev->config;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", config->use_rtnl_lock);
+}
+static DEVICE_ATTR_RW(config_use_rtnl_lock);
+
+static ssize_t config_write_delay_msec_y_store(struct device *dev,
+					       struct device_attribute *attr,
+					       const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	int ret;
+	int val;
+
+	config = &test_dev->config;
+	ret = kstrtoint(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	test_dev_config_lock(test_dev);
+	config->write_delay_msec_y = val;
+	test_dev_config_unlock(test_dev);
+
+	return count;
+}
+
+static ssize_t config_write_delay_msec_y_show(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+
+	config = &test_dev->config;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", config->write_delay_msec_y);
+}
+static DEVICE_ATTR_RW(config_write_delay_msec_y);
+
+static ssize_t config_enable_busy_alloc_store(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t count)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+	int ret;
+	int val;
+
+	config = &test_dev->config;
+	ret = kstrtoint(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	test_dev_config_lock(test_dev);
+	config->enable_busy_alloc = val;
+	test_dev_config_unlock(test_dev);
+
+	return count;
+}
+
+static ssize_t config_enable_busy_alloc_show(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	struct sysfs_test_device *test_dev = dev_to_test_dev(dev);
+	struct test_config *config;
+
+	config = &test_dev->config;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", config->enable_busy_alloc);
+}
+static DEVICE_ATTR_RW(config_enable_busy_alloc);
+
+#define TEST_SYSFS_DEV_ATTR(name)		(&dev_attr_##name.attr)
+
+static struct attribute *test_dev_attrs[] = {
+	/* Generic driver knobs go here */
+	TEST_SYSFS_DEV_ATTR(config),
+	TEST_SYSFS_DEV_ATTR(reset),
+
+	/* These are used to test sysfs */
+	TEST_SYSFS_DEV_ATTR(test_dev_x),
+	TEST_SYSFS_DEV_ATTR(test_dev_y),
+
+	/*
+	 * These are configuration knobs to modify how we test sysfs when
+	 * doing reads / stores.
+	 */
+	TEST_SYSFS_DEV_ATTR(config_enable_lock),
+	TEST_SYSFS_DEV_ATTR(config_enable_lock_on_rmmod),
+	TEST_SYSFS_DEV_ATTR(config_use_rtnl_lock),
+	TEST_SYSFS_DEV_ATTR(config_write_delay_msec_y),
+	TEST_SYSFS_DEV_ATTR(config_enable_busy_alloc),
+
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(test_dev);
+
+static int sysfs_test_dev_alloc_miscdev(struct sysfs_test_device *test_dev)
+{
+	struct miscdevice *misc_dev;
+
+	misc_dev = &test_dev->misc_dev;
+	misc_dev->minor = MISC_DYNAMIC_MINOR;
+	misc_dev->name = kasprintf(GFP_KERNEL, "test_sysfs%d", test_dev->dev_idx);
+	if (!misc_dev->name) {
+		pr_err("Cannot alloc misc_dev->name\n");
+		return -ENOMEM;
+	}
+	misc_dev->groups = test_dev_groups;
+
+	return 0;
+}
+
+static int testdev_open(struct block_device *bdev, fmode_t mode)
+{
+	return -EINVAL;
+}
+
+static blk_qc_t testdev_submit_bio(struct bio *bio)
+{
+	return BLK_QC_T_NONE;
+}
+
+static void testdev_slot_free_notify(struct block_device *bdev,
+				     unsigned long index)
+{
+}
+
+static int testdev_rw_page(struct block_device *bdev, sector_t sector,
+			   struct page *page, unsigned int op)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct block_device_operations sysfs_testdev_ops = {
+	.open = testdev_open,
+	.submit_bio = testdev_submit_bio,
+	.swap_slot_free_notify = testdev_slot_free_notify,
+	.rw_page = testdev_rw_page,
+	.owner = THIS_MODULE
+};
+
+static int sysfs_test_dev_alloc_blockdev(struct sysfs_test_device *test_dev)
+{
+	struct request_queue *queue;
+	int ret = -ENOMEM;
+
+	queue = blk_alloc_queue(NUMA_NO_NODE);
+	if (!queue) {
+		pr_err("Error allocating disk queue for device %d\n",
+			test_dev->dev_idx);
+		goto out;
+	}
+	test_dev->disk = alloc_disk(1);
+	if (!test_dev->disk) {
+		pr_err("Error allocating disk structure for device %d\n",
+		       test_dev->dev_idx);
+		blk_cleanup_queue(queue);
+		goto out;
+	}
+
+	test_dev->disk->major = sysfs_test_major;
+	test_dev->disk->first_minor = test_dev->dev_idx + 1;
+	test_dev->disk->fops = &sysfs_testdev_ops;
+	test_dev->disk->queue = queue;
+	test_dev->disk->private_data = test_dev;
+	snprintf(test_dev->disk->disk_name, 16, "test_sysfs%d",
+		 test_dev->dev_idx);
+	set_capacity(test_dev->disk, 0);
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, test_dev->disk->queue);
+	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, test_dev->disk->queue);
+	blk_queue_physical_block_size(test_dev->disk->queue, PAGE_SIZE);
+	blk_queue_max_discard_sectors(test_dev->disk->queue, UINT_MAX);
+	blk_queue_flag_set(QUEUE_FLAG_DISCARD, test_dev->disk->queue);
+
+	return 0;
+out:
+	return ret;
+}
+
+static struct sysfs_test_device *alloc_test_dev_sysfs(int idx)
+{
+	struct sysfs_test_device *test_dev;
+	int ret;
+
+	switch (test_devtype) {
+	case TESTDEV_TYPE_MISC:
+	       fallthrough;
+	case TESTDEV_TYPE_BLOCK:
+		break;
+	default:
+		return NULL;
+	}
+
+	test_dev = kzalloc(sizeof(struct sysfs_test_device), GFP_KERNEL);
+	if (!test_dev)
+		goto err_out;
+
+	mutex_init(&test_dev->config_mutex);
+	test_dev->dev_idx = idx;
+	test_dev->devtype = test_devtype;
+
+	if (test_dev->devtype == TESTDEV_TYPE_MISC) {
+		ret = sysfs_test_dev_alloc_miscdev(test_dev);
+		if (ret)
+			goto err_out_free;
+	} else if (test_dev->devtype == TESTDEV_TYPE_BLOCK) {
+		ret = sysfs_test_dev_alloc_blockdev(test_dev);
+		if (ret)
+			goto err_out_free;
+	}
+	return test_dev;
+
+err_out_free:
+	kfree(test_dev);
+	test_dev = NULL;
+err_out:
+	return NULL;
+}
+
+static int register_test_dev_sysfs_misc(struct sysfs_test_device *test_dev)
+{
+	int ret;
+
+	ret = misc_register(&test_dev->misc_dev);
+	if (ret)
+		return ret;
+
+	test_dev->dev = test_dev->misc_dev.this_device;
+
+	return 0;
+}
+
+static int register_test_dev_sysfs_block(struct sysfs_test_device *test_dev)
+{
+	device_add_disk(NULL, test_dev->disk, test_dev_groups);
+	test_dev->dev = disk_to_dev(test_dev->disk);
+
+	return 0;
+}
+
+static struct sysfs_test_device *register_test_dev_sysfs(void)
+{
+	struct sysfs_test_device *test_dev = NULL;
+	int ret;
+
+	test_dev = alloc_test_dev_sysfs(0);
+	if (!test_dev)
+		goto out;
+
+	if (test_dev->devtype == TESTDEV_TYPE_MISC) {
+		ret = register_test_dev_sysfs_misc(test_dev);
+		if (ret) {
+			pr_err("could not register misc device: %d\n", ret);
+			goto out_free_dev;
+		}
+	} else if (test_dev->devtype == TESTDEV_TYPE_BLOCK) {
+		ret = register_test_dev_sysfs_block(test_dev);
+		if (ret) {
+			pr_err("could not register block device: %d\n", ret);
+			goto out_free_dev;
+		}
+	}
+
+	dev_info(test_dev->dev, "interface ready\n");
+
+out:
+	return test_dev;
+out_free_dev:
+	free_test_dev_sysfs(test_dev);
+	return NULL;
+}
+
+static struct sysfs_test_device *register_test_dev_set_config(void)
+{
+	struct sysfs_test_device *test_dev;
+	struct test_config *config;
+
+	test_dev = register_test_dev_sysfs();
+	if (!test_dev)
+		return NULL;
+
+	config = &test_dev->config;
+
+	if (enable_lock)
+		config->enable_lock = true;
+	if (enable_lock_on_rmmod)
+		config->enable_lock_on_rmmod = true;
+	if (use_rtnl_lock)
+		config->use_rtnl_lock = true;
+	if (enable_busy_alloc)
+		config->enable_busy_alloc = true;
+
+	config->write_delay_msec_y = write_delay_msec_y;
+	test_sysfs_reset_vals(test_dev);
+
+	return test_dev;
+}
+
+static void unregister_test_dev_sysfs_misc(struct sysfs_test_device *test_dev)
+{
+	misc_deregister(&test_dev->misc_dev);
+}
+
+static void unregister_test_dev_sysfs_block(struct sysfs_test_device *test_dev)
+{
+	del_gendisk(test_dev->disk);
+	blk_cleanup_queue(test_dev->disk->queue);
+	put_disk(test_dev->disk);
+}
+
+static void unregister_test_dev_sysfs(struct sysfs_test_device *test_dev)
+{
+	test_dev_config_lock_rmmod(test_dev);
+
+	dev_info(test_dev->dev, "removing interface\n");
+
+	if (test_dev->devtype == TESTDEV_TYPE_MISC)
+		unregister_test_dev_sysfs_misc(test_dev);
+	else if (test_dev->devtype == TESTDEV_TYPE_BLOCK)
+		unregister_test_dev_sysfs_block(test_dev);
+
+	test_dev_config_unlock_rmmod(test_dev);
+
+	free_test_dev_sysfs(test_dev);
+}
+
+static struct dentry *debugfs_dir;
+
+/* When read represents how many times we have reset the first_test_dev */
+static u8 reset_first_test_dev;
+
+static ssize_t read_reset_first_test_dev(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	ssize_t len;
+	char buf[32];
+
+	reset_first_test_dev++;
+	len = sprintf(buf, "%d\n", reset_first_test_dev);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_reset_first_test_dev(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	if (!first_test_dev) {
+		module_put(THIS_MODULE);
+		return -ENODEV;
+	}
+
+	dev_info(first_test_dev->dev, "going to reset first interface ...\n");
+
+	unregister_test_dev_sysfs(first_test_dev);
+	first_test_dev = register_test_dev_set_config();
+
+	dev_info(first_test_dev->dev, "first interface reset complete\n");
+
+	module_put(THIS_MODULE);
+
+	return count;
+}
+
+static const struct file_operations fops_reset_first_test_dev = {
+	.read = read_reset_first_test_dev,
+	.write = write_reset_first_test_dev,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static int __init test_sysfs_init(void)
+{
+	first_test_dev = register_test_dev_set_config();
+	if (!first_test_dev)
+		return -ENOMEM;
+
+	if (!enable_debugfs)
+		return 0;
+
+	debugfs_dir = debugfs_create_dir("test_sysfs", NULL);
+	if (!debugfs_dir) {
+		unregister_test_dev_sysfs(first_test_dev);
+		return -ENOMEM;
+	}
+
+	debugfs_create_file("reset_first_test_dev", 0600, debugfs_dir,
+			    NULL, &fops_reset_first_test_dev);
+	return 0;
+}
+module_init(test_sysfs_init);
+
+static void __exit test_sysfs_exit(void)
+{
+	if (enable_debugfs)
+		debugfs_remove(debugfs_dir);
+	if (delay_rmmod_ms)
+		msleep(delay_rmmod_ms);
+	unregister_test_dev_sysfs(first_test_dev);
+	if (enable_verbose_rmmod)
+		pr_info("unregister_test_dev_sysfs() completed\n");
+	first_test_dev = NULL;
+}
+module_exit(test_sysfs_exit);
+
+MODULE_AUTHOR("Luis Chamberlain <mcgrof@kernel.org>");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/sysfs/Makefile b/tools/testing/selftests/sysfs/Makefile
new file mode 100644
index 000000000000..fde99caa2338
--- /dev/null
+++ b/tools/testing/selftests/sysfs/Makefile
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Makefile for sysfs selftests.
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests".
+all:
+
+TEST_PROGS := sysfs.sh
+
+include ../lib.mk
+
+# Nothing to clean up.
+clean:
diff --git a/tools/testing/selftests/sysfs/config b/tools/testing/selftests/sysfs/config
new file mode 100644
index 000000000000..9196f452ecd5
--- /dev/null
+++ b/tools/testing/selftests/sysfs/config
@@ -0,0 +1,2 @@
+CONFIG_SYSFS=m
+CONFIG_TEST_SYSFS=m
diff --git a/tools/testing/selftests/sysfs/sysfs.sh b/tools/testing/selftests/sysfs/sysfs.sh
new file mode 100755
index 000000000000..681b27579f6f
--- /dev/null
+++ b/tools/testing/selftests/sysfs/sysfs.sh
@@ -0,0 +1,1202 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (C) 2021 Luis Chamberlain <mcgrof@kernel.org>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the Free
+# Software Foundation; either version 2 of the License, or at your option any
+# later version; or, when distributed separately from the Linux kernel or
+# when incorporated into other software packages, subject to the following
+# license:
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of copyleft-next (version 0.3.1 or later) as published
+# at http://copyleft-next.org/.
+
+# This performs a series tests against the sysfs filesystem.
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+TEST_NAME="sysfs"
+TEST_DRIVER="test_${TEST_NAME}"
+TEST_DIR=$(dirname $0)
+TEST_FILE=$(mktemp)
+
+# This represents
+#
+# TEST_ID:TEST_COUNT:ENABLED:TARGET
+#
+# TEST_ID: is the test id number
+# TEST_COUNT: number of times we should run the test
+# ENABLED: 1 if enabled, 0 otherwise
+# TARGET: test target file required on the test_sysfs module
+#
+# Once these are enabled please leave them as-is. Write your own test,
+# we have tons of space.
+ALL_TESTS="0001:3:1:test_dev_x:misc"
+ALL_TESTS="$ALL_TESTS 0002:3:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0003:3:1:test_dev_x:misc"
+ALL_TESTS="$ALL_TESTS 0004:3:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0005:1:1:test_dev_x:misc"
+ALL_TESTS="$ALL_TESTS 0006:1:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0007:1:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0008:1:1:test_dev_x:misc"
+ALL_TESTS="$ALL_TESTS 0009:1:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0010:1:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0011:1:1:test_dev_x:misc"
+ALL_TESTS="$ALL_TESTS 0012:1:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0013:1:1:test_dev_y:misc"
+ALL_TESTS="$ALL_TESTS 0014:3:1:test_dev_x:block" # block equivalent set
+ALL_TESTS="$ALL_TESTS 0015:3:1:test_dev_x:block"
+ALL_TESTS="$ALL_TESTS 0016:3:1:test_dev_x:block"
+ALL_TESTS="$ALL_TESTS 0017:3:1:test_dev_y:block"
+ALL_TESTS="$ALL_TESTS 0018:1:1:test_dev_x:block"
+ALL_TESTS="$ALL_TESTS 0019:1:1:test_dev_y:block"
+ALL_TESTS="$ALL_TESTS 0020:1:1:test_dev_y:block"
+ALL_TESTS="$ALL_TESTS 0021:1:1:test_dev_x:block"
+ALL_TESTS="$ALL_TESTS 0022:1:1:test_dev_y:block"
+ALL_TESTS="$ALL_TESTS 0023:1:1:test_dev_y:block"
+ALL_TESTS="$ALL_TESTS 0024:1:1:test_dev_x:block"
+ALL_TESTS="$ALL_TESTS 0025:1:1:test_dev_y:block"
+ALL_TESTS="$ALL_TESTS 0026:1:1:test_dev_y:block"
+ALL_TESTS="$ALL_TESTS 0027:1:0:test_dev_x:block" # deadlock test
+ALL_TESTS="$ALL_TESTS 0028:1:0:test_dev_x:block" # deadlock test with rntl_lock
+
+allow_user_defaults()
+{
+	if [ -z $DIR ]; then
+		case $TEST_DEV_TYPE in
+		misc)
+			DIR="/sys/devices/virtual/misc/${TEST_DRIVER}0"
+			;;
+		block)
+			DIR="/sys/devices/virtual/block/${TEST_DRIVER}0"
+			;;
+		*)
+			DIR="/sys/devices/virtual/misc/${TEST_DRIVER}0"
+			;;
+		esac
+	fi
+	case $TEST_DEV_TYPE in
+		misc)
+			MODPROBE_TESTDEV_TYPE=""
+			;;
+		block)
+			MODPROBE_TESTDEV_TYPE="devtype=1"
+			;;
+		*)
+			MODPROBE_TESTDEV_TYPE=""
+			;;
+	esac
+	if [ -z $SYSFS_DEBUGFS_DIR ]; then
+		SYSFS_DEBUGFS_DIR="/sys/kernel/debug/test_sysfs"
+	fi
+	if [ -z $PAGE_SIZE ]; then
+		PAGE_SIZE=$(getconf PAGESIZE)
+	fi
+	if [ -z $MAX_DIGITS ]; then
+		MAX_DIGITS=$(($PAGE_SIZE/8))
+	fi
+	if [ -z $INT_MAX ]; then
+		INT_MAX=$(getconf INT_MAX)
+	fi
+	if [ -z $UINT_MAX ]; then
+		UINT_MAX=$(getconf UINT_MAX)
+	fi
+}
+
+test_reqs()
+{
+	uid=$(id -u)
+	if [ $uid -ne 0 ]; then
+		echo $msg must be run as root >&2
+		exit $ksft_skip
+	fi
+
+	if ! which modprobe 2> /dev/null > /dev/null; then
+		echo "$0: You need modprobe installed" >&2
+		exit $ksft_skip
+	fi
+	if ! which getconf 2> /dev/null > /dev/null; then
+		echo "$0: You need getconf installed"
+		exit $ksft_skip
+	fi
+	if ! which diff 2> /dev/null > /dev/null; then
+		echo "$0: You need diff installed"
+		exit $ksft_skip
+	fi
+	if ! which perl 2> /dev/null > /dev/null; then
+		echo "$0: You need perl installed"
+		exit $ksft_skip
+	fi
+}
+
+call_modprobe()
+{
+	modprobe $TEST_DRIVER $MODPROBE_TESTDEV_TYPE $FIRST_MODPROBE_ARGS $MODPROBE_ARGS
+	return $?
+}
+
+modprobe_reset()
+{
+	modprobe -q -r $TEST_DRIVER
+	call_modprobe
+	return $?
+}
+
+modprobe_reset_enable_debugfs()
+{
+	FIRST_MODPROBE_ARGS="enable_debugfs=1"
+	modprobe_reset
+	unset FIRST_MODPROBE_ARGS
+}
+
+modprobe_reset_enable_lock_on_rmmod()
+{
+	FIRST_MODPROBE_ARGS="enable_lock=1 enable_lock_on_rmmod=1 enable_verbose_writes=1"
+	modprobe_reset
+	unset FIRST_MODPROBE_ARGS
+}
+
+modprobe_reset_enable_rtnl_lock_on_rmmod()
+{
+	FIRST_MODPROBE_ARGS="enable_lock=1 use_rtnl_lock=1 enable_lock_on_rmmod=1"
+	FIRST_MODPROBE_ARGS="$FIRST_MODPROBE_ARGS enable_verbose_writes=1"
+	modprobe_reset
+	unset FIRST_MODPROBE_ARGS
+}
+
+load_req_mod()
+{
+	modprobe_reset
+	if [ ! -d $DIR ]; then
+		if ! modprobe -q -n $TEST_DRIVER; then
+			echo "$0: module $TEST_DRIVER not found [SKIP]"
+			echo "You must set CONFIG_TEST_SYSFS=m in your kernel" >&2
+			exit $ksft_skip
+		fi
+		call_modprobe
+		if [ $? -ne 0 ]; then
+			echo "$0: modprobe $TEST_DRIVER failed."
+			exit
+		fi
+	fi
+}
+
+config_reset()
+{
+	if ! echo -n "1" >"$DIR"/reset; then
+		echo "$0: reset should have worked" >&2
+		exit 1
+	fi
+}
+
+debugfs_reset_first_test_dev_ignore_errors()
+{
+	echo -n "1" >"$SYSFS_DEBUGFS_DIR"/reset_first_test_dev
+}
+
+set_orig()
+{
+	if [[ ! -z $TARGET ]] && [[ ! -z $ORIG ]]; then
+		if [ -f ${TARGET} ]; then
+			echo "${ORIG}" > "${TARGET}"
+		fi
+	fi
+}
+
+set_test()
+{
+	echo "${TEST_STR}" > "${TARGET}"
+}
+
+set_test_ignore_errors()
+{
+	echo "${TEST_STR}" > "${TARGET}" 2> /dev/null
+}
+
+verify()
+{
+	local seen
+	seen=$(cat "$1")
+	target_short=$(basename $TARGET)
+	case $target_short in
+	test_dev_x)
+		if [ "${seen}" != "${TEST_STR}" ]; then
+			return 1
+		fi
+		;;
+	test_dev_y)
+		DIRNAME=$(dirname $1)
+		EXPECTED_RESULT=""
+		# If our target was the test file then what we write to it
+		# is the same as what that we expect when we read from it.
+		# When we write to test_dev_y directly though we expect
+		# a computed value which is driver specific.
+		if [[ "$DIRNAME" == "/tmp" ]]; then
+			let EXPECTED_RESULT="${TEST_STR}"
+		else
+			x=$(cat ${DIR}/test_dev_x)
+			let EXPECTED_RESULT="$x+${TEST_STR}+7"
+		fi
+
+		if [[ "${seen}" != "${EXPECTED_RESULT}" ]]; then
+			return 1
+		fi
+		;;
+	*)
+		echo "Unsupported target type update test script: $target_short"
+		exit 1
+	esac
+	return 0
+}
+
+verify_diff_w()
+{
+	echo "$TEST_STR" | diff -q -w -u - $1 > /dev/null
+	return $?
+}
+
+test_rc()
+{
+	if [[ $rc != 0 ]]; then
+		echo "Failed test, return value: $rc" >&2
+		exit $rc
+	fi
+}
+
+test_finish()
+{
+	set_orig
+	rm -f "${TEST_FILE}"
+
+	if [ ! -z ${old_strict} ]; then
+		echo ${old_strict} > ${WRITES_STRICT}
+	fi
+	exit $rc
+}
+
+# kernfs requires us to write everything we want in one shot because
+# There is no easy way for us to know if userspace is only doing a partial
+# write, so we don't support them. We expect the entire buffer to come on
+# the first write.  If you're writing a value, first read the file,
+# modify only the value you're changing, then write entire buffer back.
+# Since we are only testing digits we just full single writes and old stuff.
+# For more details, refer to kernfs_fop_write_iter().
+run_numerictests_single_write()
+{
+	echo "== Testing sysfs behavior against ${TARGET} =="
+
+	rc=0
+
+	echo -n "Writing test file ... "
+	echo "${TEST_STR}" > "${TEST_FILE}"
+	if ! verify "${TEST_FILE}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Checking the sysfs file is not set to test value ... "
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Writing to sysfs file from shell ... "
+	set_test
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Resetting sysfs file to original value ... "
+	set_orig
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	# Now that we've validated the sanity of "set_test" and "set_orig",
+	# we can use those functions to set starting states before running
+	# specific behavioral tests.
+
+	echo -n "Writing to the entire sysfs file in a single write ... "
+	set_orig
+	dd if="${TEST_FILE}" of="${TARGET}" bs=4096 2>/dev/null
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Writing to the sysfs file with multiple long writes ... "
+	set_orig
+	(perl -e 'print "A" x 50;'; echo "${TEST_STR}") | \
+		dd of="${TARGET}" bs=50 2>/dev/null
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+	test_rc
+}
+
+reset_vals()
+{
+	echo -n 3 > $DIR/test_dev_x
+	echo -n 4 > $DIR/test_dev_x
+}
+
+check_failure()
+{
+	echo -n "Testing that $1 fails as expected..."
+	reset_vals
+	TEST_STR="$1"
+	orig="$(cat $TARGET)"
+	echo -n "$TEST_STR" > $TARGET 2> /dev/null
+
+	# write should fail and $TARGET should retain its original value
+	if [ $? = 0 ] || [ "$(cat $TARGET)" != "$orig" ]; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+	test_rc
+}
+
+load_modreqs()
+{
+	export TEST_DEV_TYPE=$(get_test_type $1)
+	unset DIR
+	allow_user_defaults
+	load_req_mod
+}
+
+target_exists()
+{
+	TARGET="${DIR}/$1"
+	TEST_ID="$2"
+
+	if [ ! -f ${TARGET} ] ; then
+		echo "Target for test $TEST_ID: $TARGET does not exist, skipping test ..."
+		return 0
+	fi
+	return 1
+}
+
+config_enable_lock()
+{
+	if ! echo -n 1 > $DIR/config_enable_lock; then
+		echo "$0: Unable to enable locks" >&2
+		exit 1
+	fi
+}
+
+config_write_delay_msec_y()
+{
+	if ! echo -n $1 > $DIR/config_write_delay_msec_y ; then
+		echo "$0: Unable to set write_delay_msec_y to $1" >&2
+		exit 1
+	fi
+}
+
+# Default filter for dmesg scanning.
+# Ignore lockdep complaining about its own bugginess when scanning dmesg
+# output, because we shouldn't be failing filesystem tests on account of
+# lockdep.
+_check_dmesg_filter()
+{
+	egrep -v -e "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low" \
+		-e "BUG: MAX_STACK_TRACE_ENTRIES too low"
+}
+
+check_dmesg()
+{
+	# filter out intentional WARNINGs or Oopses
+	local filter=${1:-_check_dmesg_filter}
+
+	_dmesg_since_test_start | $filter >$seqres.dmesg
+	egrep -q -e "kernel BUG at" \
+	     -e "WARNING:" \
+	     -e "\bBUG:" \
+	     -e "Oops:" \
+	     -e "possible recursive locking detected" \
+	     -e "Internal error" \
+	     -e "(INFO|ERR): suspicious RCU usage" \
+	     -e "INFO: possible circular locking dependency detected" \
+	     -e "general protection fault:" \
+	     -e "BUG .* remaining" \
+	     -e "UBSAN:" \
+	     $seqres.dmesg
+	if [ $? -eq 0 ]; then
+		echo "something found in dmesg (see $seqres.dmesg)"
+		return 1
+	else
+		if [ "$KEEP_DMESG" != "yes" ]; then
+			rm -f $seqres.dmesg
+		fi
+		return 0
+	fi
+}
+
+log_kernel_fstest_dmesg()
+{
+	export FSTYP="$1"
+	export seqnum="$FSTYP/$2"
+	export date_time=$(date +"%F %T")
+	echo "run fstests $seqnum at $date_time" > /dev/kmsg
+}
+
+modprobe_loop()
+{
+	while true; do
+		call_modprobe > /dev/null 2>&1
+		modprobe -r $TEST_DRIVER > /dev/null 2>&1
+	done > /dev/null 2>&1
+}
+
+write_loop()
+{
+	while true; do
+		set_test_ignore_errors > /dev/null 2>&1
+		TEST_STR=$(( $TEST_STR + 1 ))
+	done > /dev/null 2>&1
+}
+
+write_loop_reset()
+{
+	while true; do
+		set_test_ignore_errors > /dev/null 2>&1
+		debugfs_reset_first_test_dev_ignore_errors > /dev/null 2>&1
+	done > /dev/null 2>&1
+}
+
+write_loop_bg()
+{
+	BG_WRITES=1000 > /dev/null 2>&1
+	while true; do
+		for i in $(seq 1 $BG_WRITES); do
+			set_test_ignore_errors > /dev/null 2>&1 &
+			TEST_STR=$(( $TEST_STR + 1 ))
+		done > /dev/null 2>&1
+		wait
+	done > /dev/null 2>&1
+	wait
+}
+
+reset_loop()
+{
+	while true; do
+		debugfs_reset_first_test_dev_ignore_errors > /dev/null 2>&1
+	done > /dev/null 2>&1
+}
+
+kill_trigger_loop()
+{
+
+	local my_first_loop_pid=$1
+	local my_second_loop_pid=$2
+	local my_sleep_max=$3
+	local my_loop=0
+
+	while true; do
+		sleep 1
+		if [[ $my_loop -ge $my_sleep_max ]]; then
+			break
+		fi
+		let my_loop=$my_loop+1
+	done
+
+	kill -s TERM $my_first_loop_pid 2>&1 > /dev/null
+	kill -s TERM $my_second_loop_pid 2>&1 > /dev/null
+}
+
+_dmesg_since_test_start()
+{
+	# search the dmesg log of last run of $seqnum for possible failures
+	# use sed \cregexpc address type, since $seqnum contains "/"
+	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | tac
+}
+
+sysfs_test_0001()
+{
+	TARGET="${DIR}/$(get_test_target 0001)"
+	config_reset
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	run_numerictests_single_write
+}
+
+sysfs_test_0002()
+{
+	TARGET="${DIR}/$(get_test_target 0002)"
+	config_reset
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	run_numerictests_single_write
+}
+
+sysfs_test_0003()
+{
+	TARGET="${DIR}/$(get_test_target 0003)"
+	config_reset
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	config_enable_lock
+
+	run_numerictests_single_write
+}
+
+sysfs_test_0004()
+{
+	TARGET="${DIR}/$(get_test_target 0004)"
+	config_reset
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	config_enable_lock
+
+	run_numerictests_single_write
+}
+
+sysfs_test_0005()
+{
+	TARGET="${DIR}/$(get_test_target 0005)"
+	modprobe_reset
+	config_reset
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop writing x while loading/unloading the module... "
+
+	modprobe_loop &
+	modprobe_pid=$!
+
+	write_loop &
+	write_pid=$!
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0006()
+{
+	TARGET="${DIR}/$(get_test_target 0006)"
+	modprobe_reset
+	config_reset
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop writing y while loading/unloading the module... "
+	modprobe_loop &
+	modprobe_pid=$!
+
+	write_loop &
+	write_pid=$!
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0007()
+{
+	TARGET="${DIR}/$(get_test_target 0007)"
+	modprobe_reset
+	config_reset
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop writing y with a larger delay while loading/unloading the module... "
+
+	MODPROBE_ARGS="write_delay_msec_y=1500"
+	modprobe_loop > /dev/null 2>&1 &
+	modprobe_pid=$!
+	unset MODPROBE_ARGS
+
+	write_loop &
+	write_pid=$!
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0008()
+{
+	TARGET="${DIR}/$(get_test_target 0008)"
+	modprobe_reset
+	config_reset
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop busy writing x while loading/unloading the module... "
+
+	modprobe_loop > /dev/null 2>&1 &
+	modprobe_pid=$!
+
+	write_loop_bg > /dev/null 2>&1 &
+	write_pid=$!
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0009()
+{
+	TARGET="${DIR}/$(get_test_target 0009)"
+	modprobe_reset
+	config_reset
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop busy writing y while loading/unloading the module... "
+
+	modprobe_loop > /dev/null 2>&1 &
+	modprobe_pid=$!
+
+	write_loop_bg > /dev/null 2>&1 &
+	write_pid=$!
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0010()
+{
+	TARGET="${DIR}/$(get_test_target 0010)"
+	modprobe_reset
+	config_reset
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop busy writing y with a larger delay while loading/unloading the module... "
+	modprobe -q -r $TEST_DRIVER > /dev/null 2>&1
+
+	MODPROBE_ARGS="write_delay_msec_y=1500"
+	modprobe_loop > /dev/null 2>&1 &
+	modprobe_pid=$!
+	unset MODPROBE_ARGS
+
+	write_loop_bg > /dev/null 2>&1 &
+	write_pid=$!
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0011()
+{
+	TARGET="${DIR}/$(get_test_target 0011)"
+	modprobe_reset_enable_debugfs
+	config_reset
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop writing x and resetting ... "
+
+	write_loop > /dev/null 2>&1 &
+	write_pid=$!
+
+	reset_loop > /dev/null 2>&1 &
+	reset_pid=$!
+
+	kill_trigger_loop $write_pid $reset_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0012()
+{
+	TARGET="${DIR}/$(get_test_target 0012)"
+	modprobe_reset_enable_debugfs
+	config_reset
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop writing y and resetting ... "
+
+	write_loop > /dev/null 2>&1 &
+	write_pid=$!
+
+	reset_loop > /dev/null 2>&1 &
+	reset_pid=$!
+
+	kill_trigger_loop $write_pid $reset_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0013()
+{
+	TARGET="${DIR}/$(get_test_target 0013)"
+	modprobe_reset_enable_debugfs
+	config_reset
+	reset_vals
+	config_write_delay_msec_y 1500
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Loop writing y with a larger delay and resetting ... "
+
+	write_loop > /dev/null 2>&1 &
+	write_pid=$!
+
+	reset_loop > /dev/null 2>&1 &
+	reset_pid=$!
+
+	kill_trigger_loop $write_pid $reset_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0014()
+{
+	sysfs_test_0001
+}
+
+sysfs_test_0015()
+{
+	sysfs_test_0002
+}
+
+sysfs_test_0016()
+{
+	sysfs_test_0003
+}
+
+sysfs_test_0017()
+{
+	sysfs_test_0004
+}
+
+sysfs_test_0018()
+{
+	sysfs_test_0005
+}
+
+sysfs_test_0019()
+{
+	sysfs_test_0006
+}
+
+sysfs_test_0020()
+{
+	sysfs_test_0007
+}
+
+sysfs_test_0021()
+{
+	sysfs_test_0008
+}
+
+sysfs_test_0022()
+{
+	sysfs_test_0009
+}
+
+sysfs_test_0023()
+{
+	sysfs_test_0010
+}
+
+sysfs_test_0024()
+{
+	sysfs_test_0011
+}
+
+sysfs_test_0025()
+{
+	sysfs_test_0012
+}
+
+sysfs_test_0026()
+{
+	sysfs_test_0013
+}
+
+sysfs_test_0027()
+{
+	TARGET="${DIR}/$(get_test_target 0027)"
+	modprobe_reset_enable_lock_on_rmmod
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Test for possible rmmod deadlock while writing x ... "
+
+	write_loop > /dev/null 2>&1 &
+	write_pid=$!
+
+	MODPROBE_ARGS="enable_lock=1 enable_lock_on_rmmod=1 enable_verbose_writes=1"
+	modprobe_loop > /dev/null 2>&1 &
+	modprobe_pid=$!
+	unset MODPROBE_ARGS
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0028()
+{
+	TARGET="${DIR}/$(get_test_target 0028)"
+	modprobe_reset_enable_lock_on_rmmod
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+	WAIT_TIME=2
+
+	echo -n "Test for possible rmmod deadlock using rtnl_lock while writing x ... "
+
+	write_loop > /dev/null 2>&1 &
+	write_pid=$!
+
+	MODPROBE_ARGS="enable_lock=1 enable_lock_on_rmmod=1 use_rtnl_lock=1 enable_verbose_writes=1"
+	modprobe_loop > /dev/null 2>&1 &
+	modprobe_pid=$!
+	unset MODPROBE_ARGS
+
+	kill_trigger_loop $modprobe_pid $write_pid $WAIT_TIME > /dev/null 2>&1 &
+	kill_pid=$!
+
+	wait $kill_pid > /dev/null 2>&1
+
+	if [[ $? -eq 0 ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+test_gen_desc()
+{
+	echo -n "$1 x $(get_test_count $1)"
+}
+
+list_tests()
+{
+	echo "Test ID list:"
+	echo
+	echo "TEST_ID x NUM_TEST"
+	echo "TEST_ID:   Test ID"
+	echo "NUM_TESTS: Number of recommended times to run the test"
+	echo
+	echo "$(test_gen_desc 0001) - misc test writing x in different ways"
+	echo "$(test_gen_desc 0002) - misc test writing y in different ways"
+	echo "$(test_gen_desc 0003) - misc test writing x in different ways using a mutex lock"
+	echo "$(test_gen_desc 0004) - misc test writing y in different ways using a mutex lock"
+	echo "$(test_gen_desc 0005) - misc test writing x load and remove the test_sysfs module"
+	echo "$(test_gen_desc 0006) - misc writing y load and remove the test_sysfs module"
+	echo "$(test_gen_desc 0007) - misc test writing y larger delay, load, remove test_sysfs"
+	echo "$(test_gen_desc 0008) - misc test busy writing x remove test_sysfs module"
+	echo "$(test_gen_desc 0009) - misc test busy writing y remove the test_sysfs module"
+	echo "$(test_gen_desc 0010) - misc test busy writing y larger delay, remove test_sysfs"
+	echo "$(test_gen_desc 0011) - misc test writing x and resetting device"
+	echo "$(test_gen_desc 0012) - misc test writing y and resetting device"
+	echo "$(test_gen_desc 0013) - misc test writing y with a larger delay and resetting device"
+	echo "$(test_gen_desc 0014) - block test writing x in different ways"
+	echo "$(test_gen_desc 0015) - block test writing y in different ways"
+	echo "$(test_gen_desc 0016) - block test writing x in different ways using a mutex lock"
+	echo "$(test_gen_desc 0017) - block test writing y in different ways using a mutex lock"
+	echo "$(test_gen_desc 0018) - block test writing x load and remove the test_sysfs module"
+	echo "$(test_gen_desc 0019) - block test writing y load and remove the test_sysfs module"
+	echo "$(test_gen_desc 0020) - block test writing y larger delay, load, remove test_sysfs"
+	echo "$(test_gen_desc 0021) - block test busy writing x remove the test_sysfs module"
+	echo "$(test_gen_desc 0022) - block test busy writing y remove the test_sysfs module"
+	echo "$(test_gen_desc 0023) - block test busy writing y larger delay, remove test_sysfs"
+	echo "$(test_gen_desc 0024) - block test writing x and resetting device"
+	echo "$(test_gen_desc 0025) - block test writing y and resetting device"
+	echo "$(test_gen_desc 0026) - block test writing y larger delay and resetting device"
+	echo "$(test_gen_desc 0027) - test rmmod deadlock while writing x ... "
+	echo "$(test_gen_desc 0028) - test rmmod deadlock using rtnl_lock while writing x ..."
+}
+
+usage()
+{
+	NUM_TESTS=$(grep -o ' ' <<<"$ALL_TESTS" | grep -c .)
+	let NUM_TESTS=$NUM_TESTS+1
+	MAX_TEST=$(printf "%04d\n" $NUM_TESTS)
+	echo "Usage: $0 [ -t <4-number-digit> ] | [ -w <4-number-digit> ] |"
+	echo "		 [ -s <4-number-digit> ] | [ -c <4-number-digit> <test- count>"
+	echo "           [ all ] [ -h | --help ] [ -l ]"
+	echo ""
+	echo "Valid tests: 0001-$MAX_TEST"
+	echo ""
+	echo "    all     Runs all tests (default)"
+	echo "    -t      Run test ID the number amount of times is recommended"
+	echo "    -w      Watch test ID run until it runs into an error"
+	echo "    -c      Run test ID once"
+	echo "    -s      Run test ID x test-count number of times"
+	echo "    -l      List all test ID list"
+	echo " -h|--help  Help"
+	echo
+	echo "If an error every occurs execution will immediately terminate."
+	echo "If you are adding a new test try using -w <test-ID> first to"
+	echo "make sure the test passes a series of tests."
+	echo
+	echo Example uses:
+	echo
+	echo "$TEST_NAME.sh            -- executes all tests"
+	echo "$TEST_NAME.sh -t 0002    -- Executes test ID 0002 number of times is recomended"
+	echo "$TEST_NAME.sh -w 0002    -- Watch test ID 0002 run until an error occurs"
+	echo "$TEST_NAME.sh -s 0002    -- Run test ID 0002 once"
+	echo "$TEST_NAME.sh -c 0002 3  -- Run test ID 0002 three times"
+	echo
+	list_tests
+	exit 1
+}
+
+test_num()
+{
+	re='^[0-9]+$'
+	if ! [[ $1 =~ $re ]]; then
+		usage
+	fi
+}
+
+get_test_count()
+{
+	test_num $1
+	TEST_NUM=$(echo $1 | sed 's/^0*//')
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$TEST_NUM'}')
+	echo ${TEST_DATA} | awk -F":" '{print $2}'
+}
+
+get_test_enabled()
+{
+	test_num $1
+	TEST_NUM=$(echo $1 | sed 's/^0*//')
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$TEST_NUM'}')
+	echo ${TEST_DATA} | awk -F":" '{print $3}'
+}
+
+get_test_target()
+{
+	test_num $1
+	TEST_NUM=$(echo $1 | sed 's/^0*//')
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$TEST_NUM'}')
+	echo ${TEST_DATA} | awk -F":" '{print $4}'
+}
+
+get_test_type()
+{
+	test_num $1
+	TEST_NUM=$(echo $1 | sed 's/^0*//')
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$TEST_NUM'}')
+	echo ${TEST_DATA} | awk -F":" '{print $5}'
+}
+
+run_all_tests()
+{
+	for i in $ALL_TESTS ; do
+		TEST_ID=$(echo $i | awk -F":" '{print $1}')
+		ENABLED=$(get_test_enabled $TEST_ID)
+		TEST_COUNT=$(get_test_count $TEST_ID)
+		TEST_TARGET=$(get_test_target $TEST_ID)
+		if [[ $ENABLED -eq "1" ]]; then
+			test_case $TEST_ID $TEST_COUNT $TEST_TARGET
+		else
+			echo -n "Skipping test $TEST_ID as its disabled, likely "
+			echo "could crash your system ..."
+		fi
+	done
+}
+
+watch_log()
+{
+	if [ $# -ne 3 ]; then
+		clear
+	fi
+	echo "Running test: $2 - run #$1"
+}
+
+watch_case()
+{
+	i=0
+	while [ 1 ]; do
+
+		if [ $# -eq 1 ]; then
+			test_num $1
+			watch_log $i ${TEST_NAME}_test_$1
+			${TEST_NAME}_test_$1
+			check_dmesg
+			if [[ $? -eq 0 ]]; then
+				exit 1
+			fi
+		else
+			watch_log $i all
+			run_all_tests
+		fi
+		let i=$i+1
+	done
+}
+
+test_case()
+{
+	NUM_TESTS=$2
+
+	i=0
+
+	load_modreqs $1
+	if target_exists $3 $1; then
+		return
+	fi
+
+	while [[ $i -lt $NUM_TESTS ]]; do
+		test_num $1
+		watch_log $i ${TEST_NAME}_test_$1 noclear
+		log_kernel_fstest_dmesg sysfs $1
+		RUN_TEST=${TEST_NAME}_test_$1
+		$RUN_TEST
+		let i=$i+1
+	done
+	check_dmesg
+	if [[ $? -ne 0 ]]; then
+		exit 1
+	fi
+}
+
+parse_args()
+{
+	if [ $# -eq 0 ]; then
+		run_all_tests
+	else
+		if [[ "$1" = "all" ]]; then
+			run_all_tests
+		elif [[ "$1" = "-w" ]]; then
+			shift
+			watch_case $@
+		elif [[ "$1" = "-t" ]]; then
+			shift
+			test_num $1
+			test_case $1 $(get_test_count $1) $(get_test_target $1)
+		elif [[ "$1" = "-c" ]]; then
+			shift
+			test_num $1
+			test_num $2
+			test_case $1 $2 $(get_test_target $1)
+		elif [[ "$1" = "-s" ]]; then
+			shift
+			test_case $1 1 $(get_test_target $1)
+		elif [[ "$1" = "-l" ]]; then
+			list_tests
+		elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
+			usage
+		else
+			usage
+		fi
+	fi
+}
+
+test_reqs
+allow_user_defaults
+
+trap "test_finish" EXIT
+
+parse_args $@
+
+exit 0
-- 
2.27.0

