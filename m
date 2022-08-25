Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C75A1B64
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244114AbiHYVpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244102AbiHYVpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:45:20 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E17AE86C;
        Thu, 25 Aug 2022 14:44:57 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id BEDAF9940;
        Thu, 25 Aug 2022 23:44:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SeCVdA3bXlV8Eh2A/uKpeXFDQGz4VrONVW7h3UMJflw=;
        b=SrK95MdyNPdm35JmzNnsnJZEqjSE7MtuKN8ewIPL1PlCOa29L/ED50nDjExsXnCconCVKQ
        4tJaCF3cDan+n+8m6W90Bps4wHK/q8U7vQaocRAuFhwwIk8iJLauBRSW3F67efM9cvutOd
        gDOGDpo8qpCuqWn3UspsBlryE2YEbHpF+o/4KSkOLjgq6H6iAXrgKb/fqykI2nl6K4/upK
        urR/kzpOAavfuyy7y0a01qWx2eKKXWC9oexOlJGMrbRtjHlXH1aDMVliZidTKs3RfbBatw
        GV/oBJP4gkxBo8VZy0d+VAtnivbX7bay6yHvjSneZd2WCO0801DiyG3cMLwuLw==
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
Subject: [RFC PATCH v1 12/14] nvmem: layouts: rewrite the u-boot-env driver as a NVMEM layout
Date:   Thu, 25 Aug 2022 23:44:21 +0200
Message-Id: <20220825214423.903672-13-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825214423.903672-1-michael@walle.cc>
References: <20220825214423.903672-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of hardcoding the underlying access method mtd_read() and
duplicating all the error handling, rewrite the driver as a nvmem
layout which just uses nvmem_device_read() and thus works with any
NVMEM device.

But because this is now not a device anymore, the compatible string
will have to be changed so the device will still be probed:
  compatible = "u-boot,env";
to
  compatible = "u-boot,env", "nvmem-cells";

"nvmem-cells" will tell the mtd layer to register a nvmem_device().
"u-boot,env" will tell the NVMEM that it should apply the u-boot
environment layout to the NVMEM device.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/layouts/Kconfig      |   8 ++
 drivers/nvmem/layouts/Makefile     |   1 +
 drivers/nvmem/layouts/u-boot-env.c | 143 +++++++++++++++++++
 drivers/nvmem/u-boot-env.c         | 218 -----------------------------
 4 files changed, 152 insertions(+), 218 deletions(-)
 create mode 100644 drivers/nvmem/layouts/u-boot-env.c
 delete mode 100644 drivers/nvmem/u-boot-env.c

diff --git a/drivers/nvmem/layouts/Kconfig b/drivers/nvmem/layouts/Kconfig
index 75082f6b471d..3db0c139a8b7 100644
--- a/drivers/nvmem/layouts/Kconfig
+++ b/drivers/nvmem/layouts/Kconfig
@@ -11,4 +11,12 @@ config NVMEM_LAYOUT_SL28_VPD
 
 	  If unsure, say N.
 
+config NVMEM_LAYOUT_U_BOOT_ENV
+	bool "U-Boot environment support"
+	select CRC32
+	help
+	  Say Y here if you want to support u-boot's environment.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/drivers/nvmem/layouts/Makefile b/drivers/nvmem/layouts/Makefile
index fc617b9e87d0..dae93fff2b85 100644
--- a/drivers/nvmem/layouts/Makefile
+++ b/drivers/nvmem/layouts/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_NVMEM_LAYOUT_SL28_VPD) += sl28vpd.o
+obj-$(CONFIG_NVMEM_LAYOUT_U_BOOT_ENV) += u-boot-env.o
diff --git a/drivers/nvmem/layouts/u-boot-env.c b/drivers/nvmem/layouts/u-boot-env.c
new file mode 100644
index 000000000000..40b7e9a778c4
--- /dev/null
+++ b/drivers/nvmem/layouts/u-boot-env.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Rafał Miłecki <rafal@milecki.pl>
+ */
+
+#include <linux/crc32.h>
+#include <linux/dev_printk.h>
+#include <linux/mod_devicetable.h>
+#include <linux/nvmem-consumer.h>
+#include <linux/nvmem-provider.h>
+#include <linux/slab.h>
+
+enum u_boot_env_format {
+	U_BOOT_FORMAT_SINGLE,
+	U_BOOT_FORMAT_REDUNDANT,
+};
+
+struct u_boot_env_image_single {
+	__le32 crc32;
+	u8 data[];
+} __packed;
+
+struct u_boot_env_image_redundant {
+	__le32 crc32;
+	u8 mark;
+	u8 data[];
+} __packed;
+
+static int u_boot_env_add_cells(struct nvmem_device *nvmem, uint8_t *buf,
+				size_t data_offset, size_t data_len)
+{
+	struct nvmem_cell_info info = {0};
+	char *data = buf + data_offset;
+	char *var, *value, *eq;
+	int err;
+
+	for (var = data;
+	     var < data + data_len && *var;
+	     var = value + strlen(value) + 1) {
+		eq = strchr(var, '=');
+		if (!eq)
+			break;
+		*eq = '\0';
+		value = eq + 1;
+
+		info.name = var;
+		info.offset = data_offset + value - data;
+		info.bytes = strlen(value);
+
+		err = nvmem_add_one_cell(nvmem, &info);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int u_boot_add_cells(struct device *dev, struct nvmem_device *nvmem,
+			    struct nvmem_layout *layout)
+{
+	size_t size = nvmem_device_size(nvmem);
+	enum u_boot_env_format format;
+	size_t crc32_data_offset;
+	size_t crc32_data_len;
+	size_t crc32_offset;
+	size_t data_offset;
+	size_t data_len;
+	u32 crc32;
+	u32 calc;
+	u8 *buf;
+	int err;
+
+	format = (uintptr_t)nvmem_layout_get_match_data(nvmem, layout);
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	err = nvmem_device_read(nvmem, 0, size, buf);
+	if (err < 0) {
+		dev_err(dev, "Failed to read from nvmem device (%pe)\n",
+			ERR_PTR(err));
+		goto err_kfree;
+	} else if (err != size) {
+		dev_err(dev, "Short read from nvmem device.\n");
+		err = -EIO;
+		goto err_kfree;
+	}
+
+	switch (format) {
+	case U_BOOT_FORMAT_SINGLE:
+		crc32_offset = offsetof(struct u_boot_env_image_single, crc32);
+		crc32_data_offset = offsetof(struct u_boot_env_image_single, data);
+		data_offset = offsetof(struct u_boot_env_image_single, data);
+		break;
+	case U_BOOT_FORMAT_REDUNDANT:
+		crc32_offset = offsetof(struct u_boot_env_image_redundant, crc32);
+		crc32_data_offset = offsetof(struct u_boot_env_image_redundant, mark);
+		data_offset = offsetof(struct u_boot_env_image_redundant, data);
+		break;
+	}
+	crc32 = le32_to_cpu(*(u32 *)(buf + crc32_offset));
+	crc32_data_len = size - crc32_data_offset;
+	data_len = size - data_offset;
+
+	calc = crc32(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
+	if (calc != crc32) {
+		dev_err(dev, "Invalid calculated CRC32: 0x%08x (expected: 0x%08x)\n", calc, crc32);
+		err = -EINVAL;
+		goto err_kfree;
+	}
+
+	buf[size - 1] = '\0';
+	err = u_boot_env_add_cells(nvmem, buf, data_offset, data_len);
+	if (err)
+		dev_err(dev, "Failed to add cells: %d\n", err);
+
+err_kfree:
+	kfree(buf);
+err_out:
+	return err;
+}
+
+static const struct of_device_id u_boot_env_of_match_table[] = {
+	{ .compatible = "u-boot,env", .data = (void *)U_BOOT_FORMAT_SINGLE, },
+	{ .compatible = "u-boot,env-redundant-bool", .data = (void *)U_BOOT_FORMAT_REDUNDANT, },
+	{ .compatible = "u-boot,env-redundant-count", .data = (void *)U_BOOT_FORMAT_REDUNDANT, },
+	{},
+};
+
+static struct nvmem_layout u_boot_env_layout = {
+	.name = "u_boot_env",
+	.of_match_table = u_boot_env_of_match_table,
+	.add_cells = u_boot_add_cells,
+};
+
+static int __init u_boot_env_init(void)
+{
+	return nvmem_register_layout(&u_boot_env_layout);
+}
+subsys_initcall(u_boot_env_init);
diff --git a/drivers/nvmem/u-boot-env.c b/drivers/nvmem/u-boot-env.c
deleted file mode 100644
index 9b9abfb8f187..000000000000
--- a/drivers/nvmem/u-boot-env.c
+++ /dev/null
@@ -1,218 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2022 Rafał Miłecki <rafal@milecki.pl>
- */
-
-#include <linux/crc32.h>
-#include <linux/mod_devicetable.h>
-#include <linux/module.h>
-#include <linux/mtd/mtd.h>
-#include <linux/nvmem-consumer.h>
-#include <linux/nvmem-provider.h>
-#include <linux/of_device.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-
-enum u_boot_env_format {
-	U_BOOT_FORMAT_SINGLE,
-	U_BOOT_FORMAT_REDUNDANT,
-};
-
-struct u_boot_env {
-	struct device *dev;
-	enum u_boot_env_format format;
-
-	struct mtd_info *mtd;
-
-	/* Cells */
-	struct nvmem_cell_info *cells;
-	int ncells;
-};
-
-struct u_boot_env_image_single {
-	__le32 crc32;
-	uint8_t data[];
-} __packed;
-
-struct u_boot_env_image_redundant {
-	__le32 crc32;
-	u8 mark;
-	uint8_t data[];
-} __packed;
-
-static int u_boot_env_read(void *context, unsigned int offset, void *val,
-			   size_t bytes)
-{
-	struct u_boot_env *priv = context;
-	struct device *dev = priv->dev;
-	size_t bytes_read;
-	int err;
-
-	err = mtd_read(priv->mtd, offset, bytes, &bytes_read, val);
-	if (err && !mtd_is_bitflip(err)) {
-		dev_err(dev, "Failed to read from mtd: %d\n", err);
-		return err;
-	}
-
-	if (bytes_read != bytes) {
-		dev_err(dev, "Failed to read %zu bytes\n", bytes);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static int u_boot_env_add_cells(struct u_boot_env *priv, uint8_t *buf,
-				size_t data_offset, size_t data_len)
-{
-	struct device *dev = priv->dev;
-	char *data = buf + data_offset;
-	char *var, *value, *eq;
-	int idx;
-
-	priv->ncells = 0;
-	for (var = data; var < data + data_len && *var; var += strlen(var) + 1)
-		priv->ncells++;
-
-	priv->cells = devm_kcalloc(dev, priv->ncells, sizeof(*priv->cells), GFP_KERNEL);
-	if (!priv->cells)
-		return -ENOMEM;
-
-	for (var = data, idx = 0;
-	     var < data + data_len && *var;
-	     var = value + strlen(value) + 1, idx++) {
-		eq = strchr(var, '=');
-		if (!eq)
-			break;
-		*eq = '\0';
-		value = eq + 1;
-
-		priv->cells[idx].name = devm_kstrdup(dev, var, GFP_KERNEL);
-		if (!priv->cells[idx].name)
-			return -ENOMEM;
-		priv->cells[idx].offset = data_offset + value - data;
-		priv->cells[idx].bytes = strlen(value);
-	}
-
-	if (WARN_ON(idx != priv->ncells))
-		priv->ncells = idx;
-
-	return 0;
-}
-
-static int u_boot_env_parse(struct u_boot_env *priv)
-{
-	struct device *dev = priv->dev;
-	size_t crc32_data_offset;
-	size_t crc32_data_len;
-	size_t crc32_offset;
-	size_t data_offset;
-	size_t data_len;
-	uint32_t crc32;
-	uint32_t calc;
-	size_t bytes;
-	uint8_t *buf;
-	int err;
-
-	buf = kcalloc(1, priv->mtd->size, GFP_KERNEL);
-	if (!buf) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-
-	err = mtd_read(priv->mtd, 0, priv->mtd->size, &bytes, buf);
-	if ((err && !mtd_is_bitflip(err)) || bytes != priv->mtd->size) {
-		dev_err(dev, "Failed to read from mtd: %d\n", err);
-		goto err_kfree;
-	}
-
-	switch (priv->format) {
-	case U_BOOT_FORMAT_SINGLE:
-		crc32_offset = offsetof(struct u_boot_env_image_single, crc32);
-		crc32_data_offset = offsetof(struct u_boot_env_image_single, data);
-		data_offset = offsetof(struct u_boot_env_image_single, data);
-		break;
-	case U_BOOT_FORMAT_REDUNDANT:
-		crc32_offset = offsetof(struct u_boot_env_image_redundant, crc32);
-		crc32_data_offset = offsetof(struct u_boot_env_image_redundant, mark);
-		data_offset = offsetof(struct u_boot_env_image_redundant, data);
-		break;
-	}
-	crc32 = le32_to_cpu(*(uint32_t *)(buf + crc32_offset));
-	crc32_data_len = priv->mtd->size - crc32_data_offset;
-	data_len = priv->mtd->size - data_offset;
-
-	calc = crc32(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
-	if (calc != crc32) {
-		dev_err(dev, "Invalid calculated CRC32: 0x%08x (expected: 0x%08x)\n", calc, crc32);
-		err = -EINVAL;
-		goto err_kfree;
-	}
-
-	buf[priv->mtd->size - 1] = '\0';
-	err = u_boot_env_add_cells(priv, buf, data_offset, data_len);
-	if (err)
-		dev_err(dev, "Failed to add cells: %d\n", err);
-
-err_kfree:
-	kfree(buf);
-err_out:
-	return err;
-}
-
-static int u_boot_env_probe(struct platform_device *pdev)
-{
-	struct nvmem_config config = {
-		.name = "u-boot-env",
-		.reg_read = u_boot_env_read,
-	};
-	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
-	struct u_boot_env *priv;
-	int err;
-
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-	priv->dev = dev;
-
-	priv->format = (uintptr_t)of_device_get_match_data(dev);
-
-	priv->mtd = of_get_mtd_device_by_node(np);
-	if (IS_ERR(priv->mtd)) {
-		dev_err_probe(dev, PTR_ERR(priv->mtd), "Failed to get %pOF MTD\n", np);
-		return PTR_ERR(priv->mtd);
-	}
-
-	err = u_boot_env_parse(priv);
-	if (err)
-		return err;
-
-	config.dev = dev;
-	config.cells = priv->cells;
-	config.ncells = priv->ncells;
-	config.priv = priv;
-	config.size = priv->mtd->size;
-
-	return PTR_ERR_OR_ZERO(devm_nvmem_register(dev, &config));
-}
-
-static const struct of_device_id u_boot_env_of_match_table[] = {
-	{ .compatible = "u-boot,env", .data = (void *)U_BOOT_FORMAT_SINGLE, },
-	{ .compatible = "u-boot,env-redundant-bool", .data = (void *)U_BOOT_FORMAT_REDUNDANT, },
-	{ .compatible = "u-boot,env-redundant-count", .data = (void *)U_BOOT_FORMAT_REDUNDANT, },
-	{},
-};
-
-static struct platform_driver u_boot_env_driver = {
-	.probe = u_boot_env_probe,
-	.driver = {
-		.name = "u_boot_env",
-		.of_match_table = u_boot_env_of_match_table,
-	},
-};
-module_platform_driver(u_boot_env_driver);
-
-MODULE_AUTHOR("Rafał Miłecki");
-MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(of, u_boot_env_of_match_table);
-- 
2.30.2

