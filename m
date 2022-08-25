Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4235A1B65
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243290AbiHYVpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244032AbiHYVoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:44:54 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72AE5FBF;
        Thu, 25 Aug 2022 14:44:43 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id CEF0D831E;
        Thu, 25 Aug 2022 23:44:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NulQog4Ua6qPEeieWoZCqTlKOCTKSY1NYdQPcq6/xPM=;
        b=0drLSyK7eFBxYhqFpoLJiJmOaKwhJvE1lbTKkxLiiobGwpAY9SicTiJHD012GW5RUJzTtP
        FIoBkqdU89gcF/by0qzLaQ/G8hHxAOpDc8qFXCuLVlsWwTX2eAPFPIwaE6Szcg4RTfcmhC
        XAfBwP3hjSpFneF1lr3mUHyRPdEBJlAlOJgQPdRuI1Ly9a0awIo8/W6ZLqy3vhcx+HoHSz
        yB4e6j9mu0j3nO6Qq9M382Gu5CZZxy2/Eo62boKpUcz4m/Ocjllyw+69KnEMWcf1rWLSio
        d4ERhdGRxd4hZxGIqf1HAe9avFdEUPKnndE/1Qigsy0lQxU102dZ6jXi2jKbog==
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
Subject: [PATCH v1 07/14] nvmem: core: add per-cell post processing
Date:   Thu, 25 Aug 2022 23:44:16 +0200
Message-Id: <20220825214423.903672-8-michael@walle.cc>
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

Instead of relying on the name the consumer is using for the cell, like
it is done for the nvmem .cell_post_process configuration parameter,
provide a per-cell post processing hook. This can then be populated by
the NVMEM provider (or the NVMEM layout) when adding the cell.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/core.c           | 16 ++++++++++++++++
 include/linux/nvmem-consumer.h |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 5357fc378700..cbfbe6264e6c 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -52,6 +52,7 @@ struct nvmem_cell_entry {
 	int			bytes;
 	int			bit_offset;
 	int			nbits;
+	nvmem_cell_post_process_t post_process;
 	struct device_node	*np;
 	struct nvmem_device	*nvmem;
 	struct list_head	node;
@@ -468,6 +469,7 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
 	cell->offset = info->offset;
 	cell->bytes = info->bytes;
 	cell->name = info->name;
+	cell->post_process = info->post_process;
 
 	cell->bit_offset = info->bit_offset;
 	cell->nbits = info->nbits;
@@ -1500,6 +1502,13 @@ static int __nvmem_cell_read(struct nvmem_device *nvmem,
 	if (cell->bit_offset || cell->nbits)
 		nvmem_shift_read_buffer_in_place(cell, buf);
 
+	if (cell->post_process) {
+		rc = cell->post_process(nvmem->priv, id, index,
+					cell->offset, buf, cell->bytes);
+		if (rc)
+			return rc;
+	}
+
 	if (nvmem->cell_post_process) {
 		rc = nvmem->cell_post_process(nvmem->priv, id, index,
 					      cell->offset, buf, cell->bytes);
@@ -1608,6 +1617,13 @@ static int __nvmem_cell_entry_write(struct nvmem_cell_entry *cell, void *buf, si
 	    (cell->bit_offset == 0 && len != cell->bytes))
 		return -EINVAL;
 
+	/*
+	 * Any cells which have a post_process hook are read-only because we
+	 * cannot reverse the operation and it might affect other cells, too.
+	 */
+	if (cell->post_process)
+		return -EINVAL;
+
 	if (cell->bit_offset || cell->nbits) {
 		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
 		if (IS_ERR(buf))
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 980f9c9ac0bc..761b8ef78adc 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -19,6 +19,10 @@ struct device_node;
 struct nvmem_cell;
 struct nvmem_device;
 
+/* duplicated from nvmem-provider.h */
+typedef int (*nvmem_cell_post_process_t)(void *priv, const char *id, int index,
+					 unsigned int offset, void *buf, size_t bytes);
+
 struct nvmem_cell_info {
 	const char		*name;
 	unsigned int		offset;
@@ -26,6 +30,7 @@ struct nvmem_cell_info {
 	unsigned int		bit_offset;
 	unsigned int		nbits;
 	struct device_node	*np;
+	nvmem_cell_post_process_t post_process;
 };
 
 /**
-- 
2.30.2

