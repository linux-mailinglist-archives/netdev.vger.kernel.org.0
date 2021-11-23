Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3945A88B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhKWQnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232435AbhKWQnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC06060F90;
        Tue, 23 Nov 2021 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685638;
        bh=LI6uHS/wP+avmLAUWSW6X7r65Xj3azfYhtW66M34qvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teftqRymS3caKyn8wpTtAPB4pfIbSdGIZLfsAbRx7iXbtBtBaDG4BOXo7zBj/bbXQ
         hUpO9+C6U3DT7NLBksFt0PTHanlexQ56lmiJWVU5IwgLRefS+Xlov5lAXfTxr4D1LQ
         axXrAQdSqA27dyhUSZdgEyUYcsP31hdP3sn+sAAyjPZ/l39JwO+mfC3tOV6abtJUXN
         vV4NVqcw+DFNXjk2hMi+y4niN91tk8LstwFKm9eihOgk25UY2DksOS+AmZPiEwg0WC
         JyK3tavZnxsrYVA7jKkk/YfhbsdHdHY9oFEZHBs68B1tsTmsVQiTVy7U42j85Yjq0s
         pbDN1vT0U9N2Q==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 3/8] device property: add helper function for getting phy mode bitmap
Date:   Tue, 23 Nov 2021 17:40:22 +0100
Message-Id: <20211123164027.15618-4-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123164027.15618-1-kabel@kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the 'phy-mode' property can be a string array containing more
PHY modes, add helper function fwnode_get_phy_modes() that reads this
property and fills in PHY interfaces bitmap.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/base/property.c  | 34 ++++++++++++++++++++++++++++++++++
 include/linux/property.h |  3 +++
 2 files changed, 37 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index e12aef10f7fd..9f9dbc2ae386 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -921,6 +921,40 @@ int fwnode_get_phy_mode(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(fwnode_get_phy_mode);
 
+/**
+ * fwnode_get_phy_modes - Fill in phy modes bitmap for given firmware node
+ * @fwnode:	Pointer to the given node
+ * @interfaces:	Phy modes bitmask, as declared by DECLARE_PHY_INTERFACE_MASK()
+ *
+ * Reads the strings from property 'phy-mode' or 'phy-connection-type' and fills
+ * interfaces bitmask. Returns 0 on success, or errno on error.
+ */
+int fwnode_get_phy_modes(struct fwnode_handle *fwnode,
+			 unsigned long *interfaces)
+{
+	const char *modes[PHY_INTERFACE_MODE_MAX];
+	int len, i, j;
+
+	len = fwnode_property_read_string_array(fwnode, "phy-mode", modes,
+						ARRAY_SIZE(modes));
+	if (len < 0)
+		len = fwnode_property_read_string_array(fwnode,
+							"phy-connection-type",
+							modes,
+							ARRAY_SIZE(modes));
+	if (len < 0)
+		return len;
+
+	phy_interface_zero(interfaces);
+	for (i = 0; i < len; ++i)
+		for (j = 0; j < PHY_INTERFACE_MODE_MAX; j++)
+			if (!strcasecmp(modes[i], phy_modes(j)))
+				__set_bit(j, interfaces);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fwnode_get_phy_modes);
+
 /**
  * device_get_phy_mode - Get first phy mode for given device
  * @dev:	Pointer to the given device
diff --git a/include/linux/property.h b/include/linux/property.h
index 88fa726a76df..99a74d524b2b 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -391,6 +391,9 @@ const void *device_get_match_data(struct device *dev);
 int device_get_phy_mode(struct device *dev);
 
 int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
+int fwnode_get_phy_modes(struct fwnode_handle *fwnode,
+			 unsigned long *interfaces);
+
 struct fwnode_handle *fwnode_graph_get_next_endpoint(
 	const struct fwnode_handle *fwnode, struct fwnode_handle *prev);
 struct fwnode_handle *
-- 
2.32.0

