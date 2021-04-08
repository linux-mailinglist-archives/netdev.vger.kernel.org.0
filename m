Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABF6358EE4
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhDHVBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:01:22 -0400
Received: from polaris.svanheule.net ([84.16.241.116]:60018 "EHLO
        polaris.svanheule.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbhDHVBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 17:01:19 -0400
Received: from terra.local.svanheule.net (unknown [IPv6:2a02:a03f:eaff:9f01:6fea:16c6:2e86:c69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id 45EFD1ECD3A;
        Thu,  8 Apr 2021 22:52:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1617915165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HNkVs+fE0nRqWoxJ2FcJAWlbxwCmExLGCCRESK3LDM=;
        b=BQOidEbcOT/4k0hOP/F1nFpEt48nXyqtyQ4ej2uJ+cG+/VNcb3EdZ6j11OXT4LaC1YfjAN
        EbE38ByMxwkiNfqctu5NTiakv6EEki6OCdSDHNlpNqOccZvP1sCh7ZxLAF8/ZU42JzWxEw
        QsWsyRmw3BoyUilV0TMRAfmHA8sgoRAC+4e2jScAza6fDMAtET2ykgdOVFgzeepZq7r9wY
        /en+FRDQhL0opFMzgHlCQqOom7rclq79NV2Z/LZULoXPe1lpsTD/rw4wkqVMZzMVMni0Mw
        QymMJ4gVbcMRu9WcMu1Lz+T4LWycPeSUz+k1DP9ocVAKexoV9J410wgRcX/vNA==
From:   Sander Vanheule <sander@svanheule.net>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     bert@biot.com, Sander Vanheule <sander@svanheule.net>
Subject: [RFC PATCH 1/2] regmap: add miim bus support
Date:   Thu,  8 Apr 2021 22:52:34 +0200
Message-Id: <489e8a2d22dc8a5aaa3600289669c3bf0a15ba19.1617914861.git.sander@svanheule.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617914861.git.sander@svanheule.net>
References: <cover.1617914861.git.sander@svanheule.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basic support for MIIM bus access. Support only includes clause-22
register access, with 5-bit addresses, and 16-bit wide registers.

Signed-off-by: Sander Vanheule <sander@svanheule.net>
---
 drivers/base/regmap/Kconfig       |  6 +++-
 drivers/base/regmap/Makefile      |  1 +
 drivers/base/regmap/regmap-miim.c | 58 +++++++++++++++++++++++++++++++
 include/linux/regmap.h            | 36 +++++++++++++++++++
 4 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/regmap/regmap-miim.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 50b1e2d06a25..5bcd9789284e 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -4,7 +4,7 @@
 # subsystems should select the appropriate symbols.
 
 config REGMAP
-	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_W1 || REGMAP_AC97 || REGMAP_MMIO || REGMAP_IRQ || REGMAP_SOUNDWIRE || REGMAP_SOUNDWIRE_MBQ || REGMAP_SCCB || REGMAP_I3C || REGMAP_SPI_AVMM)
+	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_W1 || REGMAP_AC97 || REGMAP_MMIO || REGMAP_IRQ || REGMAP_SOUNDWIRE || REGMAP_SOUNDWIRE_MBQ || REGMAP_SCCB || REGMAP_I3C || REGMAP_SPI_AVMM || REGMAP_MIIM)
 	select IRQ_DOMAIN if REGMAP_IRQ
 	bool
 
@@ -36,6 +36,10 @@ config REGMAP_W1
 	tristate
 	depends on W1
 
+config REGMAP_MIIM
+	tristate
+	depends on MDIO_DEVICE
+
 config REGMAP_MMIO
 	tristate
 
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 33f63adb5b3d..d80920bd42ce 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_REGMAP_SOUNDWIRE_MBQ) += regmap-sdw-mbq.o
 obj-$(CONFIG_REGMAP_SCCB) += regmap-sccb.o
 obj-$(CONFIG_REGMAP_I3C) += regmap-i3c.o
 obj-$(CONFIG_REGMAP_SPI_AVMM) += regmap-spi-avmm.o
+obj-$(CONFIG_REGMAP_MIIM) += regmap-miim.o
diff --git a/drivers/base/regmap/regmap-miim.c b/drivers/base/regmap/regmap-miim.c
new file mode 100644
index 000000000000..a560d2910417
--- /dev/null
+++ b/drivers/base/regmap/regmap-miim.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/errno.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+
+static int regmap_miim_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct mdio_device *mdio_dev = context;
+	int ret;
+
+	ret = mdiobus_read(mdio_dev->bus, mdio_dev->addr, reg);
+	*val = ret & 0xffff;
+
+	return ret < 0 ? ret : 0;
+}
+
+static int regmap_miim_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct mdio_device *mdio_dev = context;
+
+	return mdiobus_write(mdio_dev->bus, mdio_dev->addr, reg, val);
+}
+
+static const struct regmap_bus regmap_miim_bus = {
+	.reg_write = regmap_miim_write,
+	.reg_read = regmap_miim_read,
+};
+
+struct regmap *__regmap_init_miim(struct mdio_device *mdio_dev,
+	const struct regmap_config *config, struct lock_class_key *lock_key,
+	const char *lock_name)
+{
+	if (config->reg_bits != 5 || config->val_bits != 16)
+		return ERR_PTR(-ENOTSUPP);
+
+	return __regmap_init(&mdio_dev->dev, &regmap_miim_bus, mdio_dev, config,
+		lock_key, lock_name);
+}
+EXPORT_SYMBOL_GPL(__regmap_init_miim);
+
+struct regmap *__devm_regmap_init_miim(struct mdio_device *mdio_dev,
+	const struct regmap_config *config, struct lock_class_key *lock_key,
+	const char *lock_name)
+{
+	if (config->reg_bits != 5 || config->val_bits != 16)
+		return ERR_PTR(-ENOTSUPP);
+
+	return __devm_regmap_init(&mdio_dev->dev, &regmap_miim_bus, mdio_dev,
+		config, lock_key, lock_name);
+}
+EXPORT_SYMBOL_GPL(__devm_regmap_init_miim);
+
+MODULE_AUTHOR("Sander Vanheule <sander@svanheule.net>");
+MODULE_DESCRIPTION("Regmap MIIM Module");
+MODULE_LICENSE("GPL v2");
+
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 2cc4ecd36298..f25630f793c3 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -27,6 +27,7 @@ struct device_node;
 struct i2c_client;
 struct i3c_device;
 struct irq_domain;
+struct mdio_device;
 struct slim_device;
 struct spi_device;
 struct spmi_device;
@@ -538,6 +539,10 @@ struct regmap *__regmap_init_i2c(struct i2c_client *i2c,
 				 const struct regmap_config *config,
 				 struct lock_class_key *lock_key,
 				 const char *lock_name);
+struct regmap *__regmap_init_miim(struct mdio_device *mdio_dev,
+				 const struct regmap_config *config,
+				 struct lock_class_key *lock_key,
+				 const char *lock_name);
 struct regmap *__regmap_init_sccb(struct i2c_client *i2c,
 				  const struct regmap_config *config,
 				  struct lock_class_key *lock_key,
@@ -594,6 +599,10 @@ struct regmap *__devm_regmap_init_i2c(struct i2c_client *i2c,
 				      const struct regmap_config *config,
 				      struct lock_class_key *lock_key,
 				      const char *lock_name);
+struct regmap *__devm_regmap_init_miim(struct mdio_device *mdio_dev,
+				      const struct regmap_config *config,
+				      struct lock_class_key *lock_key,
+				      const char *lock_name);
 struct regmap *__devm_regmap_init_sccb(struct i2c_client *i2c,
 				       const struct regmap_config *config,
 				       struct lock_class_key *lock_key,
@@ -697,6 +706,19 @@ int regmap_attach_dev(struct device *dev, struct regmap *map,
 	__regmap_lockdep_wrapper(__regmap_init_i2c, #config,		\
 				i2c, config)
 
+/**
+ * regmap_init_miim() - Initialise register map
+ *
+ * @mdio_dev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+#define regmap_init_miim(mdio_dev, config)				\
+	__regmap_lockdep_wrapper(__regmap_init_miim, #config,		\
+				mdio_dev, config)
+
 /**
  * regmap_init_sccb() - Initialise register map
  *
@@ -888,6 +910,20 @@ bool regmap_ac97_default_volatile(struct device *dev, unsigned int reg);
 	__regmap_lockdep_wrapper(__devm_regmap_init_i2c, #config,	\
 				i2c, config)
 
+/**
+ * devm_regmap_init_miim() - Initialise managed register map
+ *
+ * @mdio_dev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+#define devm_regmap_init_miim(mdio_dev, config)				\
+	__regmap_lockdep_wrapper(__devm_regmap_init_miim, #config,	\
+				mdio_dev, config)
+
 /**
  * devm_regmap_init_sccb() - Initialise managed register map
  *
-- 
2.30.2

