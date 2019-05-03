Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACABD1305B
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfECOfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:35:23 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:17188 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728170AbfECOfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 10:35:21 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id F2A164AC7;
        Fri,  3 May 2019 16:27:25 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 0334bf48;
        Fri, 3 May 2019 16:27:24 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/10] of_net: add NVMEM support to of_get_mac_address
Date:   Fri,  3 May 2019 16:27:06 +0200
Message-Id: <1556893635-18549-2-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556893635-18549-1-git-send-email-ynezz@true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many embedded devices have information such as MAC addresses stored
inside NVMEMs like EEPROMs and so on. Currently there are only two
drivers in the tree which benefit from NVMEM bindings.

Adding support for NVMEM into every other driver would mean adding a lot
of repetitive code. This patch allows us to configure MAC addresses in
various devices like ethernet and wireless adapters directly from
of_get_mac_address, which is already used by almost every driver in the
tree.

Predecessor of this patch which used directly MTD layer has originated
in OpenWrt some time ago and supports already about 497 use cases in 357
device tree files.

Cc: Alban Bedel <albeu@free.fr>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---

 Changes since v1:

  * moved handling of nvmem after mac-address and local-mac-address properties

 Changes since v2:

  * moved of_get_mac_addr_nvmem after of_get_mac_addr(np, "address") call
  * replaced kzalloc, kmemdup and kfree with it's devm variants
  * introduced of_has_nvmem_mac_addr helper which checks if DT node has nvmem
    cell with `mac-address`
  * of_get_mac_address now returns ERR_PTR encoded error value

 Changes since v3:

  * removed of_has_nvmem_mac_addr helper as it's not needed now
  * of_get_mac_address now returns only valid pointer or ERR_PTR encoded error value

 drivers/of/of_net.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index d820f3e..9649cd5 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -8,8 +8,10 @@
 #include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/of_net.h>
+#include <linux/of_platform.h>
 #include <linux/phy.h>
 #include <linux/export.h>
+#include <linux/device.h>
 
 /**
  * of_get_phy_mode - Get phy mode for given device_node
@@ -47,12 +49,52 @@ static const void *of_get_mac_addr(struct device_node *np, const char *name)
 	return NULL;
 }
 
+static const void *of_get_mac_addr_nvmem(struct device_node *np)
+{
+	int ret;
+	u8 mac[ETH_ALEN];
+	struct property *pp;
+	struct platform_device *pdev = of_find_device_by_node(np);
+
+	if (!pdev)
+		return ERR_PTR(-ENODEV);
+
+	ret = nvmem_get_mac_address(&pdev->dev, &mac);
+	if (ret)
+		return ERR_PTR(ret);
+
+	pp = devm_kzalloc(&pdev->dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return ERR_PTR(-ENOMEM);
+
+	pp->name = "nvmem-mac-address";
+	pp->length = ETH_ALEN;
+	pp->value = devm_kmemdup(&pdev->dev, mac, ETH_ALEN, GFP_KERNEL);
+	if (!pp->value) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	ret = of_add_property(np, pp);
+	if (ret)
+		goto free;
+
+	return pp->value;
+free:
+	devm_kfree(&pdev->dev, pp->value);
+	devm_kfree(&pdev->dev, pp);
+
+	return ERR_PTR(ret);
+}
+
 /**
  * Search the device tree for the best MAC address to use.  'mac-address' is
  * checked first, because that is supposed to contain to "most recent" MAC
  * address. If that isn't set, then 'local-mac-address' is checked next,
- * because that is the default address.  If that isn't set, then the obsolete
- * 'address' is checked, just in case we're using an old device tree.
+ * because that is the default address. If that isn't set, then the obsolete
+ * 'address' is checked, just in case we're using an old device tree. If any
+ * of the above isn't set, then try to get MAC address from nvmem cell named
+ * 'mac-address'.
  *
  * Note that the 'address' property is supposed to contain a virtual address of
  * the register set, but some DTS files have redefined that property to be the
@@ -64,6 +106,8 @@ static const void *of_get_mac_addr(struct device_node *np, const char *name)
  * addresses.  Some older U-Boots only initialized 'local-mac-address'.  In
  * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
  * but is all zeros.
+ *
+ * Return: Will be a valid pointer on success and ERR_PTR in case of error.
 */
 const void *of_get_mac_address(struct device_node *np)
 {
@@ -77,6 +121,10 @@ const void *of_get_mac_address(struct device_node *np)
 	if (addr)
 		return addr;
 
-	return of_get_mac_addr(np, "address");
+	addr = of_get_mac_addr(np, "address");
+	if (addr)
+		return addr;
+
+	return of_get_mac_addr_nvmem(np);
 }
 EXPORT_SYMBOL(of_get_mac_address);
-- 
1.9.1

