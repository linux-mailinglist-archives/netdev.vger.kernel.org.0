Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AB5487A29
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbiAGQNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:13:13 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59994 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiAGQNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:13:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12DE6CE29D0;
        Fri,  7 Jan 2022 16:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C593C36AE0;
        Fri,  7 Jan 2022 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641571989;
        bh=83/n4ZAnkRUSzrKK07xZm9MS+CQvcwVMRbi8XDDcOhg=;
        h=From:To:Cc:Subject:Date:From;
        b=qfT3Cijs8sRl/YQLXEdq39XpXUI2DMjKXXbxIvJFRPuGAK+iAwdSnrwgkxBmHu33L
         34595uLGvoQXaMXs8aj5BX5WEPWvVvfaLqAzkvjhTOlAs+VX/dnmzLVVeh3cGhelZ/
         HebLKE8upDecFvYYUOw5m6M4fDMorfPz+fP2goCdQXFBqSGTD+GcrINt8aHF4TA7Gr
         yahslMq38GXlOOCPtDafL/O7IDHznHKqSwnM4TM2WgcaX6W6r5tPDps55rAoy1NGj/
         RsDfYQJy/iHD+joiE8y/4jICpyeQcvyTfaQUfv3AtJd4YKW6c3717WkvbHY/eU5L/6
         fCFSFlJTQvK3Q==
Received: by pali.im (Postfix)
        id 1BA85B22; Fri,  7 Jan 2022 17:13:06 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] of: net: Add helper function of_get_ethdev_label()
Date:   Fri,  7 Jan 2022 17:12:21 +0100
Message-Id: <20220107161222.14043-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new helper function of_get_ethdev_label() which sets initial name of
specified netdev interface based on DT "label" property. It is same what is
doing DSA function dsa_port_parse_of() for DSA ports.

This helper function can be useful for drivers to make consistency between
DSA and netdev interface names.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 include/linux/of_net.h |  6 ++++++
 net/core/of_net.c      | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 0484b613ca64..532d88127b42 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -15,6 +15,7 @@ struct net_device;
 extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
 extern int of_get_mac_address(struct device_node *np, u8 *mac);
 int of_get_ethdev_address(struct device_node *np, struct net_device *dev);
+int of_get_ethdev_label(struct device_node *np, struct net_device *dev);
 extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
 static inline int of_get_phy_mode(struct device_node *np,
@@ -33,6 +34,11 @@ static inline int of_get_ethdev_address(struct device_node *np, struct net_devic
 	return -ENODEV;
 }
 
+static inline int of_get_ethdev_label(struct device_node *np, struct net_device *dev)
+{
+	return -ENODEV;
+}
+
 static inline struct net_device *of_find_net_device_by_node(struct device_node *np)
 {
 	return NULL;
diff --git a/net/core/of_net.c b/net/core/of_net.c
index f1a9bf7578e7..18fc99c42461 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -168,3 +168,18 @@ int of_get_ethdev_address(struct device_node *np, struct net_device *dev)
 	return ret;
 }
 EXPORT_SYMBOL(of_get_ethdev_address);
+
+int of_get_ethdev_label(struct device_node *np, struct net_device *dev)
+{
+	const char *name = of_get_property(np, "label", NULL);
+
+	if (!name)
+		return -ENOENT;
+
+	if (strlen(name) >= sizeof(dev->name))
+		return -ENAMETOOLONG;
+
+	strcpy(dev->name, name);
+	return 0;
+}
+EXPORT_SYMBOL(of_get_ethdev_label);
-- 
2.20.1

