Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A56046DF
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiJSNWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiJSNVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:21:34 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 583201DDC37;
        Wed, 19 Oct 2022 06:06:50 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,195,1661785200"; 
   d="scan'208";a="137159774"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 19 Oct 2022 17:51:10 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 79CEF400BC18;
        Wed, 19 Oct 2022 17:51:10 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, kabel@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH RFC 1/3] net: mdio: Add of_phy_connect_with_host_param()
Date:   Wed, 19 Oct 2022 17:50:50 +0900
Message-Id: <20221019085052.933385-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To set host parameters from an ethernet driver, add a new function
of_phy_connect_with_host_param().

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/mdio/of_mdio.c | 42 ++++++++++++++++++++++++++++++++++++++
 include/linux/of_mdio.h    |  7 +++++++
 include/linux/phy.h        |  8 ++++++++
 3 files changed, 57 insertions(+)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 796e9c7857d0..a2b0c3f84eea 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -298,6 +298,48 @@ struct phy_device *of_phy_connect(struct net_device *dev,
 }
 EXPORT_SYMBOL(of_phy_connect);
 
+/**
+ * of_phy_connect_with_host_params
+ * - Connect to the phy described in the device tree with host parameters
+ * @dev: pointer to net_device claiming the phy
+ * @phy_np: Pointer to device tree node for the PHY
+ * @hndlr: Link state callback for the network device
+ * @flags: flags to pass to the PHY
+ * @iface: PHY data interface type
+ * @host_interfaces: PHY data interface type by host
+ * @host_speed: PHY data interface speed by host
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure. The
+ * refcount must be dropped by calling phy_disconnect() or phy_detach().
+ */
+struct phy_device *
+of_phy_connect_with_host_params(struct net_device *dev,
+				struct device_node *phy_np,
+				void (*hndlr)(struct net_device *), u32 flags,
+				phy_interface_t iface,
+				unsigned long *host_interfaces,
+				int host_speed)
+{
+	struct phy_device *phy = of_phy_find_device(phy_np);
+	int ret;
+
+	if (!phy)
+		return NULL;
+
+	phy->dev_flags |= flags;
+	phy_interface_copy(phy->host_interfaces, host_interfaces);
+	phy->host_speed = host_speed;
+
+	ret = phy_connect_direct(dev, phy, hndlr, iface);
+
+	/* refcount is held by phy_connect_direct() on success */
+	put_device(&phy->mdio.dev);
+
+	return ret ? NULL : phy;
+}
+EXPORT_SYMBOL(of_phy_connect_with_host_params);
+
 /**
  * of_phy_get_and_connect
  * - Get phy node and connect to the phy described in the device tree
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index da633d34ab86..1df6edca7578 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -24,6 +24,13 @@ of_phy_connect(struct net_device *dev, struct device_node *phy_np,
 	       void (*hndlr)(struct net_device *), u32 flags,
 	       phy_interface_t iface);
 struct phy_device *
+of_phy_connect_with_host_params(struct net_device *dev,
+				struct device_node *phy_np,
+				void (*hndlr)(struct net_device *), u32 flags,
+				phy_interface_t iface,
+				unsigned long *host_interfaces,
+				int host_speed);
+struct phy_device *
 of_phy_get_and_connect(struct net_device *dev, struct device_node *np,
 		       void (*hndlr)(struct net_device *));
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ddf66198f751..000df47f8ae6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -185,6 +185,12 @@ static inline void phy_interface_or(unsigned long *dst, const unsigned long *a,
 	bitmap_or(dst, a, b, PHY_INTERFACE_MODE_MAX);
 }
 
+static inline void phy_interface_copy(unsigned long *dst,
+				      const unsigned long *src)
+{
+	bitmap_copy(dst, src, PHY_INTERFACE_MODE_MAX);
+}
+
 static inline void phy_interface_set_rgmii(unsigned long *intf)
 {
 	__set_bit(PHY_INTERFACE_MODE_RGMII, intf);
@@ -675,6 +681,8 @@ struct phy_device {
 	/* Host supported PHY interface types. Should be ignored if empty. */
 	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
 
+	int host_speed;
+
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
 
-- 
2.25.1

