Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515494809EA
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 15:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhL1O0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 09:26:20 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:39345 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbhL1O0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 09:26:18 -0500
Received: from mwalle01.kontron.local. (unknown [IPv6:2a02:810b:4340:43bf:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9F525223F0;
        Tue, 28 Dec 2021 15:26:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1640701577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gO75fbORJwY+TXVhnGrE0yVM6et/4Z8anMHQZ7vRi/A=;
        b=C2lVNyfqfOq6QNs7YFqSZ+JcQGmswKroPgG6BxNEKUOpMGS0MqodsetivvQyt/ybDoA7rc
        BUibxaGeLAqcx5TpI5EqsGgcx41tG3PtYWEB6ZAcwW0kV2xNoeOCbkueefWO4RDc5C0Z01
        WPzv9X7DeGAAukmDfDvemCDA8uzdHoE=
From:   Michael Walle <michael@walle.cc>
To:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH 4/8] nvmem: core: add transformations support
Date:   Tue, 28 Dec 2021 15:25:45 +0100
Message-Id: <20211228142549.1275412-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211228142549.1275412-1-michael@walle.cc>
References: <20211228142549.1275412-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes the value of an nvmem cell must be transformed. For example, a
MAC address might be stored in ASCII representation or we might need to
swap bytes. We might also want to expand one value to mutliple ones, for
example, the nvmem cell might just store a base MAC address to which we
need to add an offset to get an address for different network
interfaces.

Add initial support to add such transformations based on the device tree
compatible string of the NVMEM device. It will reuse the nvmem post
process hook. Both are mutually exclusive.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/Kconfig           |  7 +++++++
 drivers/nvmem/Makefile          |  1 +
 drivers/nvmem/core.c            |  7 +++++++
 drivers/nvmem/transformations.c | 28 ++++++++++++++++++++++++++++
 include/linux/nvmem-provider.h  |  9 +++++++++
 5 files changed, 52 insertions(+)
 create mode 100644 drivers/nvmem/transformations.c

diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
index da414617a54d..94dd60b2654e 100644
--- a/drivers/nvmem/Kconfig
+++ b/drivers/nvmem/Kconfig
@@ -21,6 +21,13 @@ config NVMEM_SYSFS
 	 This interface is mostly used by userspace applications to
 	 read/write directly into nvmem.
 
+config NVMEM_TRANSFORMATIONS
+	bool "Support cell transformations"
+	help
+	  Say Y to support to expand one NVMEM cell into multiple values. For
+	  example, when the NVMEM cell stores a base MAC address and it should
+	  be expanded to be used for multiple network adapters.
+
 config NVMEM_IMX_IIM
 	tristate "i.MX IC Identification Module support"
 	depends on ARCH_MXC || COMPILE_TEST
diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
index dcbbde35b6a8..4e6d877fdfaf 100644
--- a/drivers/nvmem/Makefile
+++ b/drivers/nvmem/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_NVMEM)		+= nvmem_core.o
 nvmem_core-y			:= core.o
+nvmem_core-$(CONFIG_NVMEM_TRANSFORMATIONS)	+= transformations.o
 
 # Devices
 obj-$(CONFIG_NVMEM_BCM_OCOTP)	+= nvmem-bcm-ocotp.o
diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 31d77c51dbe3..30e4b58a6dca 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -838,6 +838,13 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 		}
 	}
 
+	/*
+	 * Transformations are using the same post process hook, therefore they
+	 * are mutually exclusive.
+	 */
+	if (!nvmem->cell_post_process)
+		nvmem->cell_post_process = nvmem_get_transformations(nvmem->dev.of_node);
+
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
 
 	rval = device_register(&nvmem->dev);
diff --git a/drivers/nvmem/transformations.c b/drivers/nvmem/transformations.c
new file mode 100644
index 000000000000..61642a9feefb
--- /dev/null
+++ b/drivers/nvmem/transformations.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * nvmem cell transformations
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/nvmem-provider.h>
+#include <linux/of.h>
+
+struct nvmem_transformations {
+	const char *compatible;
+	nvmem_cell_post_process_t pp;
+};
+
+static const struct nvmem_transformations nvmem_transformations[] = {
+	{}
+};
+
+nvmem_cell_post_process_t nvmem_get_transformations(struct device_node *np)
+{
+	const struct nvmem_transformations *transform = nvmem_transformations;
+
+	for (; transform->compatible; transform++)
+		if (of_device_is_compatible(np, transform->compatible))
+			return transform->pp;
+
+	return NULL;
+}
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 8cf8593c8ae7..efc6ffdcb7e0 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -138,6 +138,15 @@ int devm_nvmem_unregister(struct device *dev, struct nvmem_device *nvmem);
 void nvmem_add_cell_table(struct nvmem_cell_table *table);
 void nvmem_del_cell_table(struct nvmem_cell_table *table);
 
+#if IS_ENABLED(CONFIG_NVMEM_TRANSFORMATIONS)
+nvmem_cell_post_process_t nvmem_get_transformations(struct device_node *np);
+#else
+static inline nvmem_cell_post_process_t nvmem_get_transformations(struct device_node *np)
+{
+	return NULL;
+}
+#endif
+
 #else
 
 static inline struct nvmem_device *nvmem_register(const struct nvmem_config *c)
-- 
2.30.2

