Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A065A1B74
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbiHYVp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244132AbiHYVpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:45:24 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42D5B0B0A;
        Thu, 25 Aug 2022 14:45:00 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6FBB09A85;
        Thu, 25 Aug 2022 23:44:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nth7meiA2xr5pQl/XbPzao+ZyDgzCDmZKYRlc5VVO/s=;
        b=eytzSDjsqNF/AtrKIpLHPc64+/1RcJpJZsXUd6+UDVIwHUGDq0YKl1YkfEU1fmGSDAqc9Z
        xVgQaHH1VyWOgoDcKlox+a9zSJBOefmPk0Z9JhpXtXSD9BXZE2PO/hGOp5tPSTrtAPkrR8
        sdCgUYFwNlDA8QHHnUW5r6DQMpV8bXkvUP/DRN4RFsyyNHO8UFzcGe5tYiHriwWfO7ZP8P
        Chc+o3yWSo92MrlShk92VomI5fZ/UFVeSg/UA/Rsd7ALwFgeyZX5AZ6OAYrn9cJA4IQpZ7
        RUCHCvAIRZUPbEFRKej/yOogdyJDGXU07or0kO4ifAQLmwHFO44Uz5VyMJVrJQ==
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
Subject: [RFC PATCH v1 13/14] nvmem: layouts: u-boot-env: add device node
Date:   Thu, 25 Aug 2022 23:44:22 +0200
Message-Id: <20220825214423.903672-14-michael@walle.cc>
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

Register the device node so we can actually make use of the cells from
within the device tree.

This obviously only works if the environment variable name can be mapped
to the device node, which isn't always the case. Think of "_" vs "-".
But for simple things like ethaddr, this will work.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/layouts/u-boot-env.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/layouts/u-boot-env.c b/drivers/nvmem/layouts/u-boot-env.c
index 40b7e9a778c4..0901cc1f5acd 100644
--- a/drivers/nvmem/layouts/u-boot-env.c
+++ b/drivers/nvmem/layouts/u-boot-env.c
@@ -5,9 +5,11 @@
 
 #include <linux/crc32.h>
 #include <linux/dev_printk.h>
+#include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/nvmem-consumer.h>
 #include <linux/nvmem-provider.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 
 enum u_boot_env_format {
@@ -26,7 +28,8 @@ struct u_boot_env_image_redundant {
 	u8 data[];
 } __packed;
 
-static int u_boot_env_add_cells(struct nvmem_device *nvmem, uint8_t *buf,
+static int u_boot_env_add_cells(struct device *dev,
+				struct nvmem_device *nvmem, uint8_t *buf,
 				size_t data_offset, size_t data_len)
 {
 	struct nvmem_cell_info info = {0};
@@ -46,6 +49,7 @@ static int u_boot_env_add_cells(struct nvmem_device *nvmem, uint8_t *buf,
 		info.name = var;
 		info.offset = data_offset + value - data;
 		info.bytes = strlen(value);
+		info.np = of_get_child_by_name(dev->of_node, var);
 
 		err = nvmem_add_one_cell(nvmem, &info);
 		if (err)
@@ -113,7 +117,7 @@ static int u_boot_add_cells(struct device *dev, struct nvmem_device *nvmem,
 	}
 
 	buf[size - 1] = '\0';
-	err = u_boot_env_add_cells(nvmem, buf, data_offset, data_len);
+	err = u_boot_env_add_cells(dev, nvmem, buf, data_offset, data_len);
 	if (err)
 		dev_err(dev, "Failed to add cells: %d\n", err);
 
-- 
2.30.2

