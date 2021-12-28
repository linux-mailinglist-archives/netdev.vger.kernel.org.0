Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797414809ED
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 15:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhL1O0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 09:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhL1O0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 09:26:19 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3C6C061574;
        Tue, 28 Dec 2021 06:26:17 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [IPv6:2a02:810b:4340:43bf:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6FE7A223EA;
        Tue, 28 Dec 2021 15:26:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1640701574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9V3jjNX+h+SC4H3w7ArRhed6jMoCjU/AbUnBIS3w/EM=;
        b=LLhbIGksetqq4w9fP6GpIS0VEN7pDz+IZgJ9KsI4qai8ysx1kwMrd4/YF7cwhZYcSSBcrK
        ZAonKjulneohhOMhH2XUbPNhfnAKdBQ54/RjwWXzwP55OmrwgzpIhYMc//gUFNTSRkaVdC
        +5oBNdiL6m7B4iMg0FCyoQJm9XV2qIs=
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
Subject: [PATCH 1/8] of: base: add of_parse_phandle_with_optional_args()
Date:   Tue, 28 Dec 2021 15:25:42 +0100
Message-Id: <20211228142549.1275412-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211228142549.1275412-1-michael@walle.cc>
References: <20211228142549.1275412-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new variant of the of_parse_phandle_with_args() which treats the
cells name as optional. If it's missing, it is assumed that the phandle
has no arguments.

Up until now, a nvmem node didn't have any arguments, so all the device
trees haven't any '#*-cells' property. But there is a need for an
additional argument for the phandle, for which we need a '#*-cells'
property. Therefore, we need to support nvmem nodes with and without
this property.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/of/base.c  | 23 +++++++++++++++++++++++
 include/linux/of.h | 12 ++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 5b907600f5b0..fb28bb26276e 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1543,6 +1543,29 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 }
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
+/**
+ * of_parse_phandle_with_optional_args() - Find a node pointed by phandle in a list
+ *
+ * Same as of_parse_phandle_args() except that if the cells_name property is
+ * not found, cell_count of 0 is assumed.
+ *
+ * This is used to useful, if you have a phandle which didn't have arguments
+ * before and thus doesn't have a '#*-cells' property but is now migrated to
+ * having arguments while retaining backwards compatibility.
+ */
+int of_parse_phandle_with_optional_args(const struct device_node *np,
+					const char *list_name,
+					const char *cells_name, int index,
+					struct of_phandle_args *out_args)
+{
+	if (index < 0)
+		return -EINVAL;
+
+	return __of_parse_phandle_with_args(np, list_name, cells_name,
+					    0, index, out_args);
+}
+EXPORT_SYMBOL(of_parse_phandle_with_optional_args);
+
 /**
  * of_parse_phandle_with_args_map() - Find a node pointed by phandle in a list and remap it
  * @np:		pointer to a device tree node containing a list
diff --git a/include/linux/of.h b/include/linux/of.h
index ff143a027abc..ccace453d25f 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -376,6 +376,9 @@ extern int of_parse_phandle_with_args_map(const struct device_node *np,
 extern int of_parse_phandle_with_fixed_args(const struct device_node *np,
 	const char *list_name, int cells_count, int index,
 	struct of_phandle_args *out_args);
+extern int of_parse_phandle_with_optional_args(const struct device_node *np,
+	const char *list_name, const char *cells_name, int index,
+	struct of_phandle_args *out_args);
 extern int of_count_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name);
 
@@ -897,6 +900,15 @@ static inline int of_parse_phandle_with_fixed_args(const struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int of_parse_phandle_with_optional_args(const struct device_node *np,
+						      char *list_name,
+						      int cells_count,
+						      int index,
+						      struct of_phandle_args *out_args)
+{
+	return -ENOSYS;
+}
+
 static inline int of_count_phandle_with_args(const struct device_node *np,
 					     const char *list_name,
 					     const char *cells_name)
-- 
2.30.2

