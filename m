Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178266C49C6
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjCVMAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjCVMAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:00:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4730957D13;
        Wed, 22 Mar 2023 05:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XgMHT2HBO+8IToVuu3CA3Bsm2bp98QNQ8P5z5X5y8NU=; b=0NtkeN4qMvD7jDiREWvOyJSCU0
        f3Lv1ZtKAZb9ei8pVbIdKxj+P3SZjrBkDw7+h48o84JIklRnwWW1x7B5aQobKV2iUUu3KKPzdgJlK
        nplWfaw+n33TZMDanvNXgjErMpdTWvYMW+bf3KA39R0JE20QLhhcbv2hoL/TkDUNlBp+WoWcERamu
        z9WKfuzbv2muUa7lEWqc0Ysu5BlXc25XlLIuEpl12l2mY10qBW4BEQsTaz0H5N4+kxzC03VMVvwxS
        ye404ej6R97DeeigjNz17nHAQ9/55auGtNK+SVqJOLdQQ8gglSQ5h6ZLQ0PQrXcipWdvV2ZNP6KeP
        mbDf02aQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37338 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pex8G-00035B-Ig; Wed, 22 Mar 2023 11:59:56 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pex8F-00Dvnf-Sm; Wed, 22 Mar 2023 11:59:55 +0000
In-Reply-To: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 1/7] software node: allow named software node to
 be created
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pex8F-00Dvnf-Sm@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 22 Mar 2023 11:59:55 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Allow a named software node to be created, which is needed for software
nodes for a fixed-link specification for DSA.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/base/swnode.c    | 14 ++++++++++++--
 include/linux/property.h |  4 ++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 1886995a0b3a..e4d07e1655a9 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -911,8 +911,9 @@ void software_node_unregister(const struct software_node *node)
 EXPORT_SYMBOL_GPL(software_node_unregister);
 
 struct fwnode_handle *
-fwnode_create_software_node(const struct property_entry *properties,
-			    const struct fwnode_handle *parent)
+fwnode_create_named_software_node(const struct property_entry *properties,
+				  const struct fwnode_handle *parent,
+				  const char *name)
 {
 	struct fwnode_handle *fwnode;
 	struct software_node *node;
@@ -930,6 +931,7 @@ fwnode_create_software_node(const struct property_entry *properties,
 		return ERR_CAST(node);
 
 	node->parent = p ? p->node : NULL;
+	node->name = name;
 
 	fwnode = swnode_register(node, p, 1);
 	if (IS_ERR(fwnode))
@@ -937,6 +939,14 @@ fwnode_create_software_node(const struct property_entry *properties,
 
 	return fwnode;
 }
+EXPORT_SYMBOL_GPL(fwnode_create_named_software_node);
+
+struct fwnode_handle *
+fwnode_create_software_node(const struct property_entry *properties,
+			    const struct fwnode_handle *parent)
+{
+	return fwnode_create_named_software_node(properties, parent, NULL);
+}
 EXPORT_SYMBOL_GPL(fwnode_create_software_node);
 
 void fwnode_remove_software_node(struct fwnode_handle *fwnode)
diff --git a/include/linux/property.h b/include/linux/property.h
index 0a29db15ff34..f7100e836eb4 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -495,6 +495,10 @@ void software_node_unregister(const struct software_node *node);
 struct fwnode_handle *
 fwnode_create_software_node(const struct property_entry *properties,
 			    const struct fwnode_handle *parent);
+struct fwnode_handle *
+fwnode_create_named_software_node(const struct property_entry *properties,
+				  const struct fwnode_handle *parent,
+				  const char *name);
 void fwnode_remove_software_node(struct fwnode_handle *fwnode);
 
 int device_add_software_node(struct device *dev, const struct software_node *node);
-- 
2.30.2

