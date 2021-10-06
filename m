Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFF64241A7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbhJFPrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239252AbhJFPqz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:46:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A525611CC;
        Wed,  6 Oct 2021 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535102;
        bh=0IQ+B7FmtJ9SYz6UKBV0dAR2MpQAjrmhaJDCWRKkdjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap7RvVWItXTAcsDPRBwCwo+Fhgi0M3r7S2WErzE21WieD5bobQsBl9ZWSGRQ5U+rl
         1KnufNCKtr9QfSBdKdx6NOtK6lgFVo4mIrgRXqGo3hat9xEeFY/FvSIyG0OoS2CmvN
         c3mdMjaH5udb+khn+3ptk65G5MOH54zaMLtDrBgw2n0TWno6uX6iq008Twk9OMoMiV
         /lIN6UXWqF4t7EMk0iU67hvke4WVkWjV7GXBR21cD8CrDrl7GylSMKwAQDQ1Jl2m5x
         rEyNrUxBOd1VW632uX1Zcp1iIPGauxjyw3Qw8f0CvkS13kbQukuuPdQqVWYgPstV0E
         t2nnlfwm41BQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        andrew@lunn.ch, jeremy.linton@arm.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/9] device property: move mac addr helpers to eth.c
Date:   Wed,  6 Oct 2021 08:44:21 -0700
Message-Id: <20211006154426.3222199-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006154426.3222199-1-kuba@kernel.org>
References: <20211006154426.3222199-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the mac address helpers out, eth.c already contains
a bunch of similar helpers.

Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: new patch
---
 drivers/base/property.c     | 63 -------------------------------------
 include/linux/etherdevice.h |  6 ++++
 include/linux/property.h    |  4 ---
 net/ethernet/eth.c          | 63 +++++++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 67 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 453918eb7390..f1f35b48ab8b 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -15,7 +15,6 @@
 #include <linux/of_graph.h>
 #include <linux/of_irq.h>
 #include <linux/property.h>
-#include <linux/etherdevice.h>
 #include <linux/phy.h>
 
 struct fwnode_handle *dev_fwnode(struct device *dev)
@@ -935,68 +934,6 @@ int device_get_phy_mode(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_get_phy_mode);
 
-static void *fwnode_get_mac_addr(struct fwnode_handle *fwnode,
-				 const char *name, char *addr,
-				 int alen)
-{
-	int ret = fwnode_property_read_u8_array(fwnode, name, addr, alen);
-
-	if (ret == 0 && alen == ETH_ALEN && is_valid_ether_addr(addr))
-		return addr;
-	return NULL;
-}
-
-/**
- * fwnode_get_mac_address - Get the MAC from the firmware node
- * @fwnode:	Pointer to the firmware node
- * @addr:	Address of buffer to store the MAC in
- * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
- *
- * Search the firmware node for the best MAC address to use.  'mac-address' is
- * checked first, because that is supposed to contain to "most recent" MAC
- * address. If that isn't set, then 'local-mac-address' is checked next,
- * because that is the default address.  If that isn't set, then the obsolete
- * 'address' is checked, just in case we're using an old device tree.
- *
- * Note that the 'address' property is supposed to contain a virtual address of
- * the register set, but some DTS files have redefined that property to be the
- * MAC address.
- *
- * All-zero MAC addresses are rejected, because those could be properties that
- * exist in the firmware tables, but were not updated by the firmware.  For
- * example, the DTS could define 'mac-address' and 'local-mac-address', with
- * zero MAC addresses.  Some older U-Boots only initialized 'local-mac-address'.
- * In this case, the real MAC is in 'local-mac-address', and 'mac-address'
- * exists but is all zeros.
-*/
-void *fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen)
-{
-	char *res;
-
-	res = fwnode_get_mac_addr(fwnode, "mac-address", addr, alen);
-	if (res)
-		return res;
-
-	res = fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen);
-	if (res)
-		return res;
-
-	return fwnode_get_mac_addr(fwnode, "address", addr, alen);
-}
-EXPORT_SYMBOL(fwnode_get_mac_address);
-
-/**
- * device_get_mac_address - Get the MAC for a given device
- * @dev:	Pointer to the device
- * @addr:	Address of buffer to store the MAC in
- * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
- */
-void *device_get_mac_address(struct device *dev, char *addr, int alen)
-{
-	return fwnode_get_mac_address(dev_fwnode(dev), addr, alen);
-}
-EXPORT_SYMBOL(device_get_mac_address);
-
 /**
  * fwnode_irq_get - Get IRQ directly from a fwnode
  * @fwnode:	Pointer to the firmware node
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index c8442d954d19..b3b6591d84c6 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -26,9 +26,15 @@
 
 #ifdef __KERNEL__
 struct device;
+struct fwnode_handle;
+
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
 unsigned char *arch_get_platform_mac_address(void);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf);
+void *device_get_mac_address(struct device *dev, char *addr, int alen);
+void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
+			     char *addr, int alen);
+
 u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 len);
 __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
 extern const struct header_ops eth_header_ops;
diff --git a/include/linux/property.h b/include/linux/property.h
index 357513a977e5..4fb081684255 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -389,11 +389,7 @@ const void *device_get_match_data(struct device *dev);
 
 int device_get_phy_mode(struct device *dev);
 
-void *device_get_mac_address(struct device *dev, char *addr, int alen);
-
 int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
-void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
-			     char *addr, int alen);
 struct fwnode_handle *fwnode_graph_get_next_endpoint(
 	const struct fwnode_handle *fwnode, struct fwnode_handle *prev);
 struct fwnode_handle *
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index b57530c231a6..9ea45aae04ee 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -51,6 +51,7 @@
 #include <linux/if_ether.h>
 #include <linux/of_net.h>
 #include <linux/pci.h>
+#include <linux/property.h>
 #include <net/dst.h>
 #include <net/arp.h>
 #include <net/sock.h>
@@ -558,3 +559,65 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 	return 0;
 }
 EXPORT_SYMBOL(nvmem_get_mac_address);
+
+static void *fwnode_get_mac_addr(struct fwnode_handle *fwnode,
+				 const char *name, char *addr,
+				 int alen)
+{
+	int ret = fwnode_property_read_u8_array(fwnode, name, addr, alen);
+
+	if (ret == 0 && alen == ETH_ALEN && is_valid_ether_addr(addr))
+		return addr;
+	return NULL;
+}
+
+/**
+ * fwnode_get_mac_address - Get the MAC from the firmware node
+ * @fwnode:	Pointer to the firmware node
+ * @addr:	Address of buffer to store the MAC in
+ * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
+ *
+ * Search the firmware node for the best MAC address to use.  'mac-address' is
+ * checked first, because that is supposed to contain to "most recent" MAC
+ * address. If that isn't set, then 'local-mac-address' is checked next,
+ * because that is the default address.  If that isn't set, then the obsolete
+ * 'address' is checked, just in case we're using an old device tree.
+ *
+ * Note that the 'address' property is supposed to contain a virtual address of
+ * the register set, but some DTS files have redefined that property to be the
+ * MAC address.
+ *
+ * All-zero MAC addresses are rejected, because those could be properties that
+ * exist in the firmware tables, but were not updated by the firmware.  For
+ * example, the DTS could define 'mac-address' and 'local-mac-address', with
+ * zero MAC addresses.  Some older U-Boots only initialized 'local-mac-address'.
+ * In this case, the real MAC is in 'local-mac-address', and 'mac-address'
+ * exists but is all zeros.
+ */
+void *fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen)
+{
+	char *res;
+
+	res = fwnode_get_mac_addr(fwnode, "mac-address", addr, alen);
+	if (res)
+		return res;
+
+	res = fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen);
+	if (res)
+		return res;
+
+	return fwnode_get_mac_addr(fwnode, "address", addr, alen);
+}
+EXPORT_SYMBOL(fwnode_get_mac_address);
+
+/**
+ * device_get_mac_address - Get the MAC for a given device
+ * @dev:	Pointer to the device
+ * @addr:	Address of buffer to store the MAC in
+ * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
+ */
+void *device_get_mac_address(struct device *dev, char *addr, int alen)
+{
+	return fwnode_get_mac_address(dev_fwnode(dev), addr, alen);
+}
+EXPORT_SYMBOL(device_get_mac_address);
-- 
2.31.1

