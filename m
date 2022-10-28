Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30574610D07
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJ1JYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJ1JXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:23:48 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267AE1C7101;
        Fri, 28 Oct 2022 02:23:46 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2B0CD100010;
        Fri, 28 Oct 2022 09:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666949025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVCo+qJ107g74qlxH0135gqiKeQVlluCp/a9Jyn0PmE=;
        b=HpD8XyUuZK+FJhasdTq2lPAygD8pMLYGMJSv3/vWKQ4EpIXi2YbEy/M+C5dN5qrkCmjVV1
        eM4LbHMvR2ltEHpAWrO1SQUoGrQE2Hf6hnM2h+VGkRIKaa+ouRlrX2YNSRZbuYRvXZLpnH
        CkDbmKh0pw8WajKbGEA1pNBmKR6JUe+wEexmP3AB229AlBWG6bq7XpwJYQYExnKlvvYxmZ
        6GAkXVRGBLCSIFib8GZ1vplSmvZniZP5L+5n+p9qPzmh068jWS6euQ+1VsmTcMf3Bb62tj
        TFO2oSra5W6BtlQaGgx41kQDaSt2I8pq2sOjjKpZRZ8wgdoaLuYf7zyIvdlulQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 3/5] nvmem: layouts: Add ONIE tlv layout driver
Date:   Fri, 28 Oct 2022 11:23:35 +0200
Message-Id: <20221028092337.822840-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028092337.822840-1-miquel.raynal@bootlin.com>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This layout applies no top of any non volatile storage device containing
an ONIE table factory flashed. This table follows the tlv
(type-length-value) organization described in the link below. We cannot
afford using regular parsers because the content of these tables is
manufacturer specific and must be dynamically discovered.

Link: https://opencomputeproject.github.io/onie/design-spec/hw_requirements.html
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/nvmem/layouts/Kconfig    |   9 ++
 drivers/nvmem/layouts/Makefile   |   1 +
 drivers/nvmem/layouts/onie-tlv.c | 240 +++++++++++++++++++++++++++++++
 3 files changed, 250 insertions(+)
 create mode 100644 drivers/nvmem/layouts/onie-tlv.c

diff --git a/drivers/nvmem/layouts/Kconfig b/drivers/nvmem/layouts/Kconfig
index 3db0c139a8b7..ff346f9f9273 100644
--- a/drivers/nvmem/layouts/Kconfig
+++ b/drivers/nvmem/layouts/Kconfig
@@ -19,4 +19,13 @@ config NVMEM_LAYOUT_U_BOOT_ENV
 
 	  If unsure, say N.
 
+config NVMEM_LAYOUT_ONIE_TLV
+	bool "ONIE tlv support"
+	select CRC32
+	help
+	  Say Y here if you want to support the Open Compute Project ONIE
+	  Type-Length-Value standard table.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/drivers/nvmem/layouts/Makefile b/drivers/nvmem/layouts/Makefile
index dae93fff2b85..0ec076cf541d 100644
--- a/drivers/nvmem/layouts/Makefile
+++ b/drivers/nvmem/layouts/Makefile
@@ -5,3 +5,4 @@
 
 obj-$(CONFIG_NVMEM_LAYOUT_SL28_VPD) += sl28vpd.o
 obj-$(CONFIG_NVMEM_LAYOUT_U_BOOT_ENV) += u-boot-env.o
+obj-$(CONFIG_NVMEM_LAYOUT_ONIE_TLV) += onie-tlv.o
diff --git a/drivers/nvmem/layouts/onie-tlv.c b/drivers/nvmem/layouts/onie-tlv.c
new file mode 100644
index 000000000000..5b33f283d8dc
--- /dev/null
+++ b/drivers/nvmem/layouts/onie-tlv.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * ONIE tlv NVMEM cells provider
+ *
+ * Copyright (C) 2022 Open Compute Group ONIE
+ * Author: Miquel Raynal <miquel.raynal@bootlin.com>
+ * Based on the nvmem driver written by: Vadym Kochan <vadym.kochan@plvision.eu>
+ * Inspired by the first layout written by: Rafał Miłecki <rafal@milecki.pl>
+ */
+
+#include <linux/crc32.h>
+#include <linux/etherdevice.h>
+#include <linux/nvmem-consumer.h>
+#include <linux/nvmem-provider.h>
+#include <linux/of.h>
+
+#define ONIE_TLV_MAX_LEN 2048
+#define ONIE_TLV_CRC_FIELD_SZ 6
+#define ONIE_TLV_CRC_SZ 4
+#define ONIE_TLV_HDR_ID	"TlvInfo"
+
+struct onie_tlv_hdr {
+	u8 id[8];
+	u8 version;
+	__be16 data_len;
+} __packed;
+
+struct onie_tlv {
+	u8 type;
+	u8 len;
+} __packed;
+
+static const char *onie_tlv_cell_name(u8 type)
+{
+	switch (type) {
+	case 0x21:
+		return "product-name";
+	case 0x22:
+		return "part-number";
+	case 0x23:
+		return "serial-number";
+	case 0x24:
+		return "mac-address";
+	case 0x25:
+		return "manufacture-date";
+	case 0x26:
+		return "device-version";
+	case 0x27:
+		return "label-revision";
+	case 0x28:
+		return "platforn-name";
+	case 0x29:
+		return "onie-version";
+	case 0x2A:
+		return "num-macs";
+	case 0x2B:
+		return "manufacturer";
+	case 0x2C:
+		return "country-code";
+	case 0x2D:
+		return "vendor";
+	case 0x2E:
+		return "diag-version";
+	case 0x2F:
+		return "service-tag";
+	case 0xFD:
+		return "vendor-extension";
+	case 0xFE:
+		return "crc32";
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+static int onie_tlv_mac_read_cb(const char *id, int index,
+				unsigned int offset, void *buf,
+				size_t bytes)
+{
+	eth_addr_add(buf, index);
+
+	return 0;
+}
+
+static nvmem_cell_post_process_t onie_tlv_read_cb(u8 type, u8 *buf)
+{
+	switch (type) {
+	case 0x24:
+		return &onie_tlv_mac_read_cb;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+static int onie_tlv_add_cells(struct device *dev, struct nvmem_device *nvmem,
+			      size_t data_len, u8 *data)
+{
+	struct nvmem_cell_info cell = {};
+	struct onie_tlv tlv;
+	unsigned int hdr_len = sizeof(struct onie_tlv_hdr);
+	unsigned int offset = 0;
+	int ret;
+
+	while (offset < data_len) {
+		memcpy(&tlv, data + offset, sizeof(tlv));
+		if (offset + tlv.len >= data_len) {
+			dev_err(dev, "Out of bounds field (0x%x bytes at 0x%x)\n",
+				tlv.len, hdr_len + offset);
+			break;
+		}
+
+		cell.name = onie_tlv_cell_name(tlv.type);
+		if (!cell.name)
+			continue;
+
+		cell.offset = hdr_len + offset + sizeof(tlv.type) + sizeof(tlv.len);
+		cell.bytes = tlv.len;
+		cell.np = of_get_child_by_name(dev->of_node, cell.name);
+		cell.read_post_process = onie_tlv_read_cb(tlv.type, data + offset + sizeof(tlv));
+
+		ret = nvmem_add_one_cell(nvmem, &cell);
+		if (ret)
+			return ret;
+
+		offset += sizeof(tlv) + tlv.len;
+	}
+
+	return 0;
+}
+
+static bool onie_tlv_hdr_is_valid(struct device *dev, struct onie_tlv_hdr *hdr)
+{
+	if (memcmp(hdr->id, ONIE_TLV_HDR_ID, sizeof(hdr->id))) {
+		dev_err(dev, "Invalid header\n");
+		return false;
+	}
+
+	if (hdr->version != 0x1) {
+		dev_err(dev, "Invalid version number\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool onie_tlv_crc_is_valid(struct device *dev, size_t table_len, u8 *table)
+{
+	struct onie_tlv crc_hdr;
+	u32 read_crc, calc_crc;
+	__be32 crc_be;
+
+	memcpy(&crc_hdr, table + table_len - ONIE_TLV_CRC_FIELD_SZ, sizeof(crc_hdr));
+	if (crc_hdr.type != 0xfe || crc_hdr.len != ONIE_TLV_CRC_SZ) {
+		dev_err(dev, "Invalid CRC field\n");
+		return false;
+	}
+
+	/* The table contains a JAMCRC, which is XOR'ed compared to the original
+	 * CRC32 implementation as known in the Ethernet world.
+	 */
+	memcpy(&crc_be, table + table_len - ONIE_TLV_CRC_SZ, ONIE_TLV_CRC_SZ);
+	read_crc = be32_to_cpu(crc_be);
+	calc_crc = crc32(~0, table, table_len - ONIE_TLV_CRC_SZ) ^ 0xFFFFFFFF;
+	if (read_crc != calc_crc) {
+		dev_err(dev, "Invalid CRC read: 0x%08x, expected: 0x%08x\n",
+			read_crc, calc_crc);
+		return false;
+	}
+
+	return true;
+}
+
+static int onie_tlv_parse_table(struct device *dev, struct nvmem_device *nvmem,
+				struct nvmem_layout *layout)
+{
+	struct onie_tlv_hdr hdr;
+	size_t table_len, data_len, hdr_len;
+	u8 *table, *data;
+	int ret;
+
+	ret = nvmem_device_read(nvmem, 0, sizeof(hdr), &hdr);
+	if (ret < 0)
+		return ret;
+
+	if (!onie_tlv_hdr_is_valid(dev, &hdr)) {
+		dev_err(dev, "Invalid ONIE TLV header\n");
+		return -EINVAL;
+	}
+
+	hdr_len = sizeof(hdr.id) + sizeof(hdr.version) + sizeof(hdr.data_len);
+	data_len = be16_to_cpu(hdr.data_len);
+	table_len = hdr_len + data_len;
+	if (table_len > ONIE_TLV_MAX_LEN) {
+		dev_err(dev, "Invalid ONIE TLV data length\n");
+		return -EINVAL;
+	}
+
+	table = devm_kmalloc(dev, table_len, GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	ret = nvmem_device_read(nvmem, 0, table_len, table);
+	if (ret != table_len)
+		goto free_data_buf;
+
+	if (!onie_tlv_crc_is_valid(dev, table_len, table)) {
+		ret = -EINVAL;
+		goto free_data_buf;
+	}
+
+	data = table + hdr_len;
+	ret = onie_tlv_add_cells(dev, nvmem, data_len, data);
+	if (ret)
+		goto free_data_buf;
+
+free_data_buf:
+	kfree(table);
+
+	return ret;
+}
+
+static const struct of_device_id onie_tlv_of_match_table[] = {
+	{ .compatible = "onie,tlv-layout", },
+	{},
+};
+
+static struct nvmem_layout onie_tlv_layout = {
+	.name = "ONIE tlv layout",
+	.of_match_table = onie_tlv_of_match_table,
+	.add_cells = onie_tlv_parse_table,
+};
+
+static int __init onie_tlv_init(void)
+{
+	return nvmem_layout_register(&onie_tlv_layout);
+}
+subsys_initcall(onie_tlv_init);
-- 
2.34.1

