Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09035A1B6E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244026AbiHYVpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243995AbiHYVoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:44:54 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888D1E011;
        Thu, 25 Aug 2022 14:44:45 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 636D77F30;
        Thu, 25 Aug 2022 23:44:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15N6Y1O6mrdYDQeeW+ZVCCeb0FHsLTdQzLkYbuf1kUQ=;
        b=xuRu5WlMQ04gNJGGHxI/xsV8GpoWXfOEr9Qrg8OWaRdZ1EZHVPxwG65/VPybaBgVuvYTzo
        RYzVqbP91tPRsfMqYwJb2SrhmaLUnDnc4zzMtJrIR8pGqppk+UrmhE2//+ARgPkQpcJ3rF
        bHJe7WxcGzRe1g+h1XwkOfIwUjNt6a2MjcPwj/6EmmB3iO2y7NhpAjVsbrsr4tNEXhcTpa
        HF+l4mT1rZHRhxWKSzzPGCF8AAbVvo1C5Oluft+8dwBxw59UaqZ+s8ueOhL0W4bSP/Sodv
        9ti+z2g88T1hzM5mQoW1X93QLk1hLtgIIhnPJdPMLhaAJMrNmRarRnIkB+/f6Q==
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
Subject: [PATCH v1 03/14] nvmem: core: add an index parameter to the cell
Date:   Thu, 25 Aug 2022 23:44:12 +0200
Message-Id: <20220825214423.903672-4-michael@walle.cc>
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

Sometimes a cell can represend multiple values. For example, a base
ethernet address stored in the NVMEM can be expanded into multiple
discreet ones by adding an offset.

For this use case, introduce an index parameter which is then used to
distiguish between values. This parameter will then be passed to the
post process hook which can then use it to create different values
during reading.

At the moment, there is only support for the device tree path. You can
add the index to the phandle, e.g.

  &net {
          nvmem-cells = <&base_mac_address 2>;
          nvmem-cell-names = "mac-address";
  };

  &nvmem_provider {
          base_mac_address: base-mac-address@0 {
                  #nvmem-cell-cells = <1>;
                  reg = <0 6>;
          };
  };

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/core.c           | 37 ++++++++++++++++++++++++----------
 drivers/nvmem/imx-ocotp.c      |  4 ++--
 include/linux/nvmem-provider.h |  4 ++--
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 321d7d63e068..ab055e4fc409 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -60,6 +60,7 @@ struct nvmem_cell_entry {
 struct nvmem_cell {
 	struct nvmem_cell_entry *entry;
 	const char		*id;
+	int			index;
 };
 
 static DEFINE_MUTEX(nvmem_mutex);
@@ -1127,7 +1128,8 @@ struct nvmem_device *devm_nvmem_device_get(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(devm_nvmem_device_get);
 
-static struct nvmem_cell *nvmem_create_cell(struct nvmem_cell_entry *entry, const char *id)
+static struct nvmem_cell *nvmem_create_cell(struct nvmem_cell_entry *entry,
+					    const char *id, int index)
 {
 	struct nvmem_cell *cell;
 	const char *name = NULL;
@@ -1146,6 +1148,7 @@ static struct nvmem_cell *nvmem_create_cell(struct nvmem_cell_entry *entry, cons
 
 	cell->id = name;
 	cell->entry = entry;
+	cell->index = index;
 
 	return cell;
 }
@@ -1184,7 +1187,7 @@ nvmem_cell_get_from_lookup(struct device *dev, const char *con_id)
 				__nvmem_device_put(nvmem);
 				cell = ERR_PTR(-ENOENT);
 			} else {
-				cell = nvmem_create_cell(cell_entry, con_id);
+				cell = nvmem_create_cell(cell_entry, con_id, 0);
 				if (IS_ERR(cell))
 					__nvmem_device_put(nvmem);
 			}
@@ -1232,15 +1235,27 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
 	struct nvmem_device *nvmem;
 	struct nvmem_cell_entry *cell_entry;
 	struct nvmem_cell *cell;
+	struct of_phandle_args cell_spec;
 	int index = 0;
+	int cell_index = 0;
+	int ret;
 
 	/* if cell name exists, find index to the name */
 	if (id)
 		index = of_property_match_string(np, "nvmem-cell-names", id);
 
-	cell_np = of_parse_phandle(np, "nvmem-cells", index);
-	if (!cell_np)
-		return ERR_PTR(-ENOENT);
+	ret = of_parse_phandle_with_optional_args(np, "nvmem-cells",
+						  "#nvmem-cell-cells",
+						  index, &cell_spec);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (cell_spec.args_count > 1)
+		return ERR_PTR(-EINVAL);
+
+	cell_np = cell_spec.np;
+	if (cell_spec.args_count)
+		cell_index = cell_spec.args[0];
 
 	nvmem_np = of_get_next_parent(cell_np);
 	if (!nvmem_np)
@@ -1257,7 +1272,7 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
 		return ERR_PTR(-ENOENT);
 	}
 
-	cell = nvmem_create_cell(cell_entry, id);
+	cell = nvmem_create_cell(cell_entry, id, cell_index);
 	if (IS_ERR(cell))
 		__nvmem_device_put(nvmem);
 
@@ -1410,8 +1425,8 @@ static void nvmem_shift_read_buffer_in_place(struct nvmem_cell_entry *cell, void
 }
 
 static int __nvmem_cell_read(struct nvmem_device *nvmem,
-		      struct nvmem_cell_entry *cell,
-		      void *buf, size_t *len, const char *id)
+			     struct nvmem_cell_entry *cell,
+			     void *buf, size_t *len, const char *id, int index)
 {
 	int rc;
 
@@ -1425,7 +1440,7 @@ static int __nvmem_cell_read(struct nvmem_device *nvmem,
 		nvmem_shift_read_buffer_in_place(cell, buf);
 
 	if (nvmem->cell_post_process) {
-		rc = nvmem->cell_post_process(nvmem->priv, id,
+		rc = nvmem->cell_post_process(nvmem->priv, id, index,
 					      cell->offset, buf, cell->bytes);
 		if (rc)
 			return rc;
@@ -1460,7 +1475,7 @@ void *nvmem_cell_read(struct nvmem_cell *cell, size_t *len)
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	rc = __nvmem_cell_read(nvmem, cell->entry, buf, len, cell->id);
+	rc = __nvmem_cell_read(nvmem, cell->entry, buf, len, cell->id, cell->index);
 	if (rc) {
 		kfree(buf);
 		return ERR_PTR(rc);
@@ -1773,7 +1788,7 @@ ssize_t nvmem_device_cell_read(struct nvmem_device *nvmem,
 	if (rc)
 		return rc;
 
-	rc = __nvmem_cell_read(nvmem, &cell, buf, &len, NULL);
+	rc = __nvmem_cell_read(nvmem, &cell, buf, &len, NULL, 0);
 	if (rc)
 		return rc;
 
diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
index 14284e866f26..e9b52ecb3f72 100644
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -222,8 +222,8 @@ static int imx_ocotp_read(void *context, unsigned int offset,
 	return ret;
 }
 
-static int imx_ocotp_cell_pp(void *context, const char *id, unsigned int offset,
-			     void *data, size_t bytes)
+static int imx_ocotp_cell_pp(void *context, const char *id, int index,
+			     unsigned int offset, void *data, size_t bytes)
 {
 	struct ocotp_priv *priv = context;
 
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 50caa117cb62..8f964b394292 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -20,8 +20,8 @@ typedef int (*nvmem_reg_read_t)(void *priv, unsigned int offset,
 typedef int (*nvmem_reg_write_t)(void *priv, unsigned int offset,
 				 void *val, size_t bytes);
 /* used for vendor specific post processing of cell data */
-typedef int (*nvmem_cell_post_process_t)(void *priv, const char *id, unsigned int offset,
-					  void *buf, size_t bytes);
+typedef int (*nvmem_cell_post_process_t)(void *priv, const char *id, int index,
+					 unsigned int offset, void *buf, size_t bytes);
 
 enum nvmem_type {
 	NVMEM_TYPE_UNKNOWN = 0,
-- 
2.30.2

