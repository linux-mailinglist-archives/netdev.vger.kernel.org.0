Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA604550CD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbhKQWyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241452AbhKQWx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:53:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D102361B93;
        Wed, 17 Nov 2021 22:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637189459;
        bh=8QI5zgNX6FAyW+1FqIk7tgJ+sJMwphnuLdkZC0QM4Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GG2ipseL/uFWU2Qo6JZvtYZcNJA7FJWUJqGCiANSjSgUpyeRQ3gpb5JX9IqoqN05M
         g21wyLNpPA+5ux8Kt7Op3BVIe6BcbQ5Ij1LXe1KKb2clYUrjAI+j/MWE1mb+Fw+KfS
         VvuJSLIQopbNyuAtUWh2jRRIuJ+cyy65oKRvKWaPQg2Zz1pZIQZuOaROzHDXezDpfr
         iX/oiswVWfB+k2d4YgmJjYwLXyFyNvVWTQGT8STyyGSpMXRpgyGWn/Z69jaa5rPlvJ
         KblvGjvl4lQk62uoeI38Z6d6q/KOvO0/KK41lOGXJXkceLlxwA+IiawvCnH8RkeXPs
         dM3Fn1uRps4kQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/8] net: Update documentation for *_get_phy_mode() functions
Date:   Wed, 17 Nov 2021 23:50:44 +0100
Message-Id: <20211117225050.18395-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117225050.18395-1-kabel@kernel.org>
References: <20211117225050.18395-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the `phy-mode` DT property can be an array of strings instead
of just one string, update the documentation for of_get_phy_mode(),
fwnode_get_phy_mode() and device_get_phy_mode() saying that if multiple
strings are present, the first one is returned.

Conventionally the property was used to represent the mode we want the
PHY to operate in, but we extended this to mean the list of all
supported modes by that PHY on that particular board.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/base/property.c | 14 ++++++++------
 net/core/of_net.c       |  9 +++++----
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index f1f35b48ab8b..e12aef10f7fd 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -893,12 +893,13 @@ enum dev_dma_attr device_get_dma_attr(struct device *dev)
 EXPORT_SYMBOL_GPL(device_get_dma_attr);
 
 /**
- * fwnode_get_phy_mode - Get phy mode for given firmware node
+ * fwnode_get_phy_mode - Get first phy mode for given firmware node
  * @fwnode:	Pointer to the given node
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type', and return its index in phy_modes table, or errno in
- * error case.
+ * 'phy-connection-type', and returns its index in phy_modes table, or errno in
+ * error case. If there are multiple strings in the property, the first one is
+ * used.
  */
 int fwnode_get_phy_mode(struct fwnode_handle *fwnode)
 {
@@ -921,12 +922,13 @@ int fwnode_get_phy_mode(struct fwnode_handle *fwnode)
 EXPORT_SYMBOL_GPL(fwnode_get_phy_mode);
 
 /**
- * device_get_phy_mode - Get phy mode for given device
+ * device_get_phy_mode - Get first phy mode for given device
  * @dev:	Pointer to the given device
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type', and return its index in phy_modes table, or errno in
- * error case.
+ * 'phy-connection-type', and returns its index in phy_modes table, or errno in
+ * error case. If there are multiple strings in the property, the first one is
+ * used.
  */
 int device_get_phy_mode(struct device *dev)
 {
diff --git a/net/core/of_net.c b/net/core/of_net.c
index f1a9bf7578e7..7cd10f0ef679 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -14,14 +14,15 @@
 #include <linux/nvmem-consumer.h>
 
 /**
- * of_get_phy_mode - Get phy mode for given device_node
+ * of_get_phy_mode - Get first phy mode for given device_node
  * @np:	Pointer to the given device_node
  * @interface: Pointer to the result
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type'. The index in phy_modes table is set in
- * interface and 0 returned. In case of error interface is set to
- * PHY_INTERFACE_MODE_NA and an errno is returned, e.g. -ENODEV.
+ * 'phy-connection-type'. If there are more string in the property, the first
+ * one is used. The index in phy_modes table is set in interface and 0 returned.
+ * In case of error interface is set to PHY_INTERFACE_MODE_NA and an errno is
+ * returned, e.g. -ENODEV.
  */
 int of_get_phy_mode(struct device_node *np, phy_interface_t *interface)
 {
-- 
2.32.0

