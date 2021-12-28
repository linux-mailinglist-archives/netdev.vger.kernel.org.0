Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD3F4809FD
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 15:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbhL1O0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 09:26:25 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:49879 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbhL1O0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 09:26:20 -0500
Received: from mwalle01.kontron.local. (unknown [IPv6:2a02:810b:4340:43bf:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E1843223F7;
        Tue, 28 Dec 2021 15:26:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1640701578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8u32QLgP+bx/Avj9/UQOtx/OkwJzp0bCtXU3LJH76Fc=;
        b=rzSLw3hes1+GfIvB++uAojB1vhiOCMw7vvcHgxa+s1zaJWBQvAiY+q7T+ZMDnLMLWnGGom
        6CB6wl8wSGdh6iKpLdafzYSskmGWj0amUyv1546atnOWJRoeOOkoUdgMt/YpMikd8u4S5L
        /7EWzYL0lSOPqOcNW4K5NZ0x6sYrdGc=
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
Subject: [PATCH 6/8] nvmem: transformations: ethernet address offset support
Date:   Tue, 28 Dec 2021 15:25:47 +0100
Message-Id: <20211228142549.1275412-7-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211228142549.1275412-1-michael@walle.cc>
References: <20211228142549.1275412-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An nvmem cell might just contain a base MAC address. To generate a
address of a specific interface, add a transformation to add an offset
to this base address.

Add a generic implementation and the first user of it, namely the sl28
vpd storage.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/transformations.c | 45 +++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/nvmem/transformations.c b/drivers/nvmem/transformations.c
index 61642a9feefb..15cd26da1f83 100644
--- a/drivers/nvmem/transformations.c
+++ b/drivers/nvmem/transformations.c
@@ -12,7 +12,52 @@ struct nvmem_transformations {
 	nvmem_cell_post_process_t pp;
 };
 
+/**
+ * nvmem_transform_mac_address_offset() - Add an offset to a mac address cell
+ *
+ * A simple transformation which treats the index argument as an offset and add
+ * it to a mac address. This is useful, if the nvmem cell stores a base
+ * ethernet address.
+ *
+ * @index: nvmem cell index
+ * @data: nvmem data
+ * @bytes: length of the data
+ *
+ * Return: 0 or negative error code on failure.
+ */
+static int nvmem_transform_mac_address_offset(int index, unsigned int offset,
+					      void *data, size_t bytes)
+{
+	if (bytes != ETH_ALEN)
+		return -EINVAL;
+
+	if (index < 0)
+		return -EINVAL;
+
+	if (!is_valid_ether_addr(data))
+		return -EINVAL;
+
+	eth_addr_add(data, index);
+
+	return 0;
+}
+
+static int nvmem_kontron_sl28_vpd_pp(void *priv, const char *id, int index,
+				     unsigned int offset, void *data,
+				     size_t bytes)
+{
+	if (!id)
+		return 0;
+
+	if (!strcmp(id, "mac-address"))
+		return nvmem_transform_mac_address_offset(index, offset, data,
+							  bytes);
+
+	return 0;
+}
+
 static const struct nvmem_transformations nvmem_transformations[] = {
+	{ .compatible = "kontron,sl28-vpd", .pp = nvmem_kontron_sl28_vpd_pp },
 	{}
 };
 
-- 
2.30.2

