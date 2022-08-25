Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FFD5A1B84
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244113AbiHYVpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244093AbiHYVpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:45:20 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBB5AF4A1;
        Thu, 25 Aug 2022 14:44:57 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 5AD7398F8;
        Thu, 25 Aug 2022 23:44:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bZ0MB2oqU++FCqLOXHr3+VjUWFBZ0liXMlmqroQmEUU=;
        b=uyKoL9zfJgM6YR5kpaLWJ9M/6XYY+6B1YfX/EgNk0VuTy1k+ps1CY+IJv5zklWHYhG16nj
        47TW5CYs/4ntqSnpePVEKP9A7WGN38riPevWIWzwtLXqS+elvWN6lfQ46GLppOOdHf/GO7
        1a18I8IEQmgtXuZ4vFO8uGdIHX8WQ1wE7b2yrBR7a14xv9SoyweOAv0DSjjerLYZCqU4c0
        pIjgeb1ZkP6PVQwko6Y80CHBMlXyuz6gNIN3lGFU5DJn9YlnMWN9TFPeFmj4T8R+g7wBvd
        sLThdknz2cPx4RVc6fYylF/v/Ma2275hx/aCWfaCaxPHM1TYqGdwJRbRiN5vKg==
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
Subject: [PATCH v1 11/14] nvmem: core: export nvmem device size
Date:   Thu, 25 Aug 2022 23:44:20 +0200
Message-Id: <20220825214423.903672-12-michael@walle.cc>
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

Export the size of the nvmem device. NVMEM layout drivers might need it
and might not have access to the device which is registering the NVMEM
device.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nvmem/core.c           | 13 +++++++++++++
 include/linux/nvmem-consumer.h |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index cbfbe6264e6c..f46ae358fe88 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -2031,6 +2031,19 @@ const char *nvmem_dev_name(struct nvmem_device *nvmem)
 }
 EXPORT_SYMBOL_GPL(nvmem_dev_name);
 
+/**
+ * nvmem_device_size() - Get the size of a given nvmem device.
+ *
+ * @nvmem: nvmem device.
+ *
+ * Return: size of the nvmem device.
+ */
+size_t nvmem_device_size(struct nvmem_device *nvmem)
+{
+	return nvmem->size;
+}
+EXPORT_SYMBOL_GPL(nvmem_device_size);
+
 static int __init nvmem_init(void)
 {
 	return bus_register(&nvmem_bus_type);
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 761b8ef78adc..6b2a80a5fdd5 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -90,6 +90,7 @@ ssize_t nvmem_device_cell_read(struct nvmem_device *nvmem,
 			   struct nvmem_cell_info *info, void *buf);
 int nvmem_device_cell_write(struct nvmem_device *nvmem,
 			    struct nvmem_cell_info *info, void *buf);
+size_t nvmem_device_size(struct nvmem_device *nvmem);
 
 const char *nvmem_dev_name(struct nvmem_device *nvmem);
 
@@ -219,6 +220,11 @@ static inline int nvmem_device_write(struct nvmem_device *nvmem,
 	return -EOPNOTSUPP;
 }
 
+static inline size_t nvmem_device_size(struct nvmem_device *nvmem)
+{
+	return 0;
+}
+
 static inline const char *nvmem_dev_name(struct nvmem_device *nvmem)
 {
 	return NULL;
-- 
2.30.2

