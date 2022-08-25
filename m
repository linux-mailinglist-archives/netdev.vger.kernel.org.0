Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274255A1B6F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbiHYVpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244037AbiHYVoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:44:55 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644C01B2;
        Thu, 25 Aug 2022 14:44:43 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6040D7F33;
        Thu, 25 Aug 2022 23:44:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1sp5/kkEDpWTbOg3Ndn4ZClXb29lF1uZP1Ae5XU6TA4=;
        b=dXLkeSe1HwYbBEAOtiRi9JnilfPJocBO5wlRfw2xtkMEt/34KjdMxxpRTeezpBMIXnPcVY
        YId8mvjkj5FqGxhmN5dmROp3ilJNNR/+5cdzpIK5SKWdujGe0lOKCnBB+qZH45lKuxL0HA
        UvTBgDpdtpVes7qhOgsClgyxAg+4kVJ0rry5f+O/31dXTAZOaH1Tv2OOBJHPv2Ah53jbWE
        GGFZS5GrBRomJ+VlUbo1SHHXayjJQC8HgQdnQNwx/la6r/I7UIfoC7BbwJ9Vnfhs7DIzM2
        B1pJTt4F7jTCNvWA7Zhhur9H+wsO3AEjVuHlco7T3GCnpLJJoBVS8ELYca67ng==
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v1 06/14] nvmem: core: introduce NVMEM layouts
Date:   Thu, 25 Aug 2022 23:44:15 +0200
Message-Id: <20220825214423.903672-7-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825214423.903672-1-michael@walle.cc>
References: <20220825214423.903672-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NVMEM layouts are used to generate NVMEM cells during runtime. Think of
an EEPROM with a well-defined conent. For now, the content can be
described by a device tree or a board file. But this only works if the
offsets and lengths are static and don't change. One could also argue
that putting the layout of the EEPROM in the device tree is the wrong
place. Instead, the device tree should just have a specific compatible
string.

Right now there are two use cases:
 (1) The NVMEM cell needs special processing. E.g. if it only specifies
     a base MAC address offset and you need to add an offset, or it
     needs to parse a MAC from ASCII format or some proprietary format.
     (Post processing of cells is added in a later commit).
 (2) u-boot environment parsing. The cells don't have a particular
     offset but it needs parsing the content to determine the offsets
     and length.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/Kconfig          |  2 ++
 drivers/nvmem/Makefile         |  1 +
 drivers/nvmem/core.c           | 57 ++++++++++++++++++++++++++++++++++
 drivers/nvmem/layouts/Kconfig  |  5 +++
 drivers/nvmem/layouts/Makefile |  4 +++
 include/linux/nvmem-provider.h | 38 +++++++++++++++++++++++
 6 files changed, 107 insertions(+)
 create mode 100644 drivers/nvmem/layouts/Kconfig
 create mode 100644 drivers/nvmem/layouts/Makefile

diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
index bab8a29c9861..1416837b107b 100644
--- a/drivers/nvmem/Kconfig
+++ b/drivers/nvmem/Kconfig
@@ -357,4 +357,6 @@ config NVMEM_U_BOOT_ENV
 
 	  If compiled as module it will be called nvmem_u-boot-env.
 
+source "drivers/nvmem/layouts/Kconfig"
+
 endif
diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
index 399f9972d45b..cd5a5baa2f3a 100644
--- a/drivers/nvmem/Makefile
+++ b/drivers/nvmem/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_NVMEM)		+= nvmem_core.o
 nvmem_core-y			:= core.o
+obj-y				+= layouts/
 
 # Devices
 obj-$(CONFIG_NVMEM_BCM_OCOTP)	+= nvmem-bcm-ocotp.o
diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 3dfd149374a8..5357fc378700 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -74,6 +74,9 @@ static LIST_HEAD(nvmem_lookup_list);
 
 static BLOCKING_NOTIFIER_HEAD(nvmem_notifier);
 
+static DEFINE_SPINLOCK(nvmem_layout_lock);
+static LIST_HEAD(nvmem_layouts);
+
 static int __nvmem_reg_read(struct nvmem_device *nvmem, unsigned int offset,
 			    void *val, size_t bytes)
 {
@@ -744,6 +747,56 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 	return 0;
 }
 
+int nvmem_register_layout(struct nvmem_layout *layout)
+{
+	spin_lock(&nvmem_layout_lock);
+	list_add(&layout->node, &nvmem_layouts);
+	spin_unlock(&nvmem_layout_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvmem_register_layout);
+
+static struct nvmem_layout *nvmem_get_compatible_layout(struct device_node *np)
+{
+	struct nvmem_layout *p, *ret = NULL;
+
+	spin_lock(&nvmem_layout_lock);
+
+	list_for_each_entry(p, &nvmem_layouts, node) {
+		if (of_match_node(p->of_match_table, np)) {
+			ret = p;
+			break;
+		}
+	}
+
+	spin_unlock(&nvmem_layout_lock);
+
+	return ret;
+}
+
+static int nvmem_add_cells_from_layout(struct nvmem_device *nvmem)
+{
+	struct nvmem_layout *layout;
+
+	layout = nvmem_get_compatible_layout(nvmem->dev.of_node);
+	if (layout)
+		layout->add_cells(&nvmem->dev, nvmem, layout);
+
+	return 0;
+}
+
+const void *nvmem_layout_get_match_data(struct nvmem_device *nvmem,
+					struct nvmem_layout *layout)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(layout->of_match_table, nvmem->dev.of_node);
+
+	return match ? match->data : NULL;
+}
+EXPORT_SYMBOL_GPL(nvmem_layout_get_match_data);
+
 /**
  * nvmem_register() - Register a nvmem device for given nvmem_config.
  * Also creates a binary entry in /sys/bus/nvmem/devices/dev-name/nvmem
@@ -872,6 +925,10 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	if (rval)
 		goto err_remove_cells;
 
+	rval = nvmem_add_cells_from_layout(nvmem);
+	if (rval)
+		goto err_remove_cells;
+
 	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);
 
 	return nvmem;
diff --git a/drivers/nvmem/layouts/Kconfig b/drivers/nvmem/layouts/Kconfig
new file mode 100644
index 000000000000..9ad3911d1605
--- /dev/null
+++ b/drivers/nvmem/layouts/Kconfig
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+menu "Layout Types"
+
+endmenu
diff --git a/drivers/nvmem/layouts/Makefile b/drivers/nvmem/layouts/Makefile
new file mode 100644
index 000000000000..6fdb3c60a4fa
--- /dev/null
+++ b/drivers/nvmem/layouts/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for nvmem layouts.
+#
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index e710404959e7..323685841e9f 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -127,6 +127,28 @@ struct nvmem_cell_table {
 	struct list_head	node;
 };
 
+/**
+ * struct nvmem_layout - NVMEM layout definitions
+ *
+ * @name:		Layout name.
+ * @of_match_table:	Open firmware match table.
+ * @add_cells:		Will be called if a nvmem device is found which
+ *			has this layout. The function will add layout
+ *			specific cells with nvmem_add_one_cell().
+ * @node:		List node.
+ *
+ * A nvmem device can hold a well defined structure which can just be
+ * evaluated during runtime. For example a TLV list, or a list of "name=val"
+ * pairs. A nvmem layout can parse the nvmem device and add appropriate
+ * cells.
+ */
+struct nvmem_layout {
+	const char *name;
+	const struct of_device_id *of_match_table;
+	int (*add_cells)(struct nvmem_device *nvmem, struct nvmem_layout *layout);
+	struct list_head node;
+};
+
 #if IS_ENABLED(CONFIG_NVMEM)
 
 struct nvmem_device *nvmem_register(const struct nvmem_config *cfg);
@@ -141,6 +163,10 @@ void nvmem_del_cell_table(struct nvmem_cell_table *table);
 int nvmem_add_one_cell(struct nvmem_device *nvmem,
 		       const struct nvmem_cell_info *info);
 
+int nvmem_register_layout(struct nvmem_layout *layout);
+const void *nvmem_layout_get_match_data(struct nvmem_device *nvmem,
+					struct nvmem_layout *layout);
+
 #else
 
 static inline struct nvmem_device *nvmem_register(const struct nvmem_config *c)
@@ -161,5 +187,17 @@ static inline void nvmem_del_cell_table(struct nvmem_cell_table *table) {}
 static inline int nvmem_add_one_cell(struct nvmem_device *nvmem,
 				     const struct nvmem_cell_info *info) {}
 
+static inline int nvmem_register_layout(struct nvmem_layout *layout)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline const void *
+nvmem_layout_get_match_data(struct nvmem_device *nvmem,
+			    struct nvmem_layout *layout)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_NVMEM */
 #endif  /* ifndef _LINUX_NVMEM_PROVIDER_H */
-- 
2.30.2

