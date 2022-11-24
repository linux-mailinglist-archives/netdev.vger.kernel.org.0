Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E29E63775B
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiKXLQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiKXLQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:16:27 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5CF6F823;
        Thu, 24 Nov 2022 03:16:17 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 045551C0011;
        Thu, 24 Nov 2022 11:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669288575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iqamt5mLLD+qd4tqrrabyPW2zioP4EH/FA6Onx8TCjE=;
        b=j8P8jkPBu+FFh608QlWPILTFa+HXFsBGw9GL4FtslbZj8suyb485us3KRhMSe0oVmimLxp
        nu9Zvo9+PK7SdQ9wdwLZ/lWqinBNyEdGA6MEI0vd+uQ6SR0Arpy2tqiBMh/075N/zYbqso
        IhigVz6HpMNJm2yGSMXR1v+Ow3BpYNV9x0tHCbjPoiiF8paOO1Cs2QGG9sUivAN1vBWp92
        cbLtQjD4sykXG8vrCX+AluFLga9zKZ9ZBB/th6bDDP0LKmAb8FDgvOjnqsm1npaTukC24l
        trzTtU7yqmfBUmSMB3SatGpaXcIPq43/rHD+HXWn6+nB6jPwZbzGTVqF8XUCZw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Marcin Wojtas <mw@semihalf.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next v2 5/7] of: net: export of_get_mac_address_nvmem()
Date:   Thu, 24 Nov 2022 12:15:54 +0100
Message-Id: <20221124111556.264647-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124111556.264647-1-miquel.raynal@bootlin.com>
References: <20221124111556.264647-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export

	of_get_mac_addr_nvmem()

and rename it to

	of_get_mac_address_nvmem()

in order to fit the convention followed by the existing exported helpers
of the same kind.

This way, OF compatible drivers using eg. fwnode_get_mac_address() can
do a direct call to it instead of calling of_get_mac_address() just for
the nvmem step, avoiding to repeat an expensive DT lookup which has
already been done once.

Eventually, fwnode_get_mac_address() should probably be updated to
perform the nvmem lookup directly, but as of today, nvmem cells seem not
to be supported by ACPI yet which would defeat this kind of extension.

Suggested-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/of_net.h | 6 ++++++
 net/core/of_net.c      | 5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 0484b613ca64..d88715a0b3a5 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -14,6 +14,7 @@
 struct net_device;
 extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
 extern int of_get_mac_address(struct device_node *np, u8 *mac);
+extern int of_get_mac_address_nvmem(struct device_node *np, u8 *mac);
 int of_get_ethdev_address(struct device_node *np, struct net_device *dev);
 extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
@@ -28,6 +29,11 @@ static inline int of_get_mac_address(struct device_node *np, u8 *mac)
 	return -ENODEV;
 }
 
+static inline int of_get_mac_address_nvmem(struct device_node *np, u8 *mac)
+{
+	return -ENODEV;
+}
+
 static inline int of_get_ethdev_address(struct device_node *np, struct net_device *dev)
 {
 	return -ENODEV;
diff --git a/net/core/of_net.c b/net/core/of_net.c
index f1a9bf7578e7..55d3fe229269 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -57,7 +57,7 @@ static int of_get_mac_addr(struct device_node *np, const char *name, u8 *addr)
 	return -ENODEV;
 }
 
-static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
+int of_get_mac_address_nvmem(struct device_node *np, u8 *addr)
 {
 	struct platform_device *pdev = of_find_device_by_node(np);
 	struct nvmem_cell *cell;
@@ -94,6 +94,7 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 
 	return 0;
 }
+EXPORT_SYMBOL(of_get_mac_address_nvmem);
 
 /**
  * of_get_mac_address()
@@ -140,7 +141,7 @@ int of_get_mac_address(struct device_node *np, u8 *addr)
 	if (!ret)
 		return 0;
 
-	return of_get_mac_addr_nvmem(np, addr);
+	return of_get_mac_address_nvmem(np, addr);
 }
 EXPORT_SYMBOL(of_get_mac_address);
 
-- 
2.34.1

