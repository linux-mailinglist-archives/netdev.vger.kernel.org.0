Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D13F4BE984
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380820AbiBUQjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380785AbiBUQjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:09 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9482E22BCA;
        Mon, 21 Feb 2022 08:38:36 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::229])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id E3897D2381;
        Mon, 21 Feb 2022 16:29:13 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DFC37FF811;
        Mon, 21 Feb 2022 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xXIueXWvKxX/LWoZoq8jZVCI0+VYYMkfxQec0Aoej8w=;
        b=k9pOzn/E8KfAwsEXXS7qTBi2mXEUtZG4qKbix+L1jspzTevhd5LWGxEAv85ivZ7qWQhUei
        WyOsKvz8JiRFtKGrD/OXRZXhT5fHPxjeJ1+49RdQaM5W0hVZBeyyQ1O2PpwgDBcv8LCmuk
        tZtwKY1gzZWnRWWoogwQaANIgQVzRp7KGVMUG4LGmLgTjb/RJAy7XpS0GX+5alDLrGqqw4
        Aqq/lR+k4CPkwel6dkE0G54BIxePw/YD+jg0gClUw+mWilAcyi4SuL1Uq4SSIfzryj8Zjm
        zIsgBH18h658z2Cq598xFuSu9n5EVLEibMm76swdi72qjnldQJKkb191qY0o4A==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC 01/10] property: add fwnode_match_node()
Date:   Mon, 21 Feb 2022 17:26:43 +0100
Message-Id: <20220221162652.103834-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220221162652.103834-1-clement.leger@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function equivalent to of_match_node() which is usable for fwnode
support. Matching is based on the compatible property and it returns
the best matches for the node according to the compatible list
ordering.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/base/property.c  | 23 +++++++++++++++++++++++
 include/linux/property.h |  3 +++
 2 files changed, 26 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index e6497f6877ee..434c2713fd99 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1158,6 +1158,29 @@ int fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL(fwnode_graph_parse_endpoint);
 
+const struct of_device_id *fwnode_match_node(const struct fwnode_handle *fwnode,
+					     const struct of_device_id *matches)
+{
+	int index;
+	const struct of_device_id *best_match = NULL;
+	int best_index = INT_MAX;
+
+	if (!matches)
+		return NULL;
+
+	for (; matches->name[0] || matches->type[0] || matches->compatible[0]; matches++) {
+		index = fwnode_property_match_string(fwnode, "compatible",
+						     matches->compatible);
+		if (index >= 0 && index < best_index) {
+			best_match = matches;
+			best_index = index;
+		}
+	}
+
+	return best_match;
+}
+EXPORT_SYMBOL(fwnode_match_node);
+
 const void *device_get_match_data(struct device *dev)
 {
 	return fwnode_call_ptr_op(dev_fwnode(dev), device_get_match_data, dev);
diff --git a/include/linux/property.h b/include/linux/property.h
index 7399a0b45f98..978ecf6be34e 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -446,6 +446,9 @@ static inline void *device_connection_find_match(struct device *dev,
 	return fwnode_connection_find_match(dev_fwnode(dev), con_id, data, match);
 }
 
+const struct of_device_id *fwnode_match_node(const struct fwnode_handle *fwnode,
+					     const struct of_device_id *matches);
+
 /* -------------------------------------------------------------------------- */
 /* Software fwnode support - when HW description is incomplete or missing */
 
-- 
2.34.1

