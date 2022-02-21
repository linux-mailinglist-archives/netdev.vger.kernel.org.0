Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835E54BE62D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380853AbiBUQjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380793AbiBUQjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:10 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98894237FF;
        Mon, 21 Feb 2022 08:38:39 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 83F0BC3549;
        Mon, 21 Feb 2022 16:29:18 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E0190FF80E;
        Mon, 21 Feb 2022 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yFZyD/xsoWg/S0R33oq47fx2Ang45t7YDLbGipkmDBU=;
        b=owA9gnqTS5qqrRnkgIHNLJMrzZ/Xpguf/yNrSyIkJdRdPNBZiwWwffvpJqwydxsTlrBXIG
        4GqmqKnGSJecFBvzF1zKDEtl5eBZeRrHKTEJUOR4Ditxxp0JQfi1GDtwYNiEkpy8n58X5w
        DQAeRKgHbiUu6XRKL+62CPJpJDXbEVaTvyyznf//QxXDeBvr77b8Ly3Wu8WwL+OrB5K8z7
        YQglolFnIAL2wIUaxw/h3d3o4CM5DFQ+w9In8tyTRvHH3tMD+K/iw+4XYG6EDJjIadrXkj
        0LGjKCnJEuueFOzQdKreE9C5LYJ22XL67mO3FM4EdsizWoorp/DFpab6nAqfPw==
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
Subject: [RFC 04/10] property: add a callback parameter to fwnode_property_match_string()
Date:   Mon, 21 Feb 2022 17:26:46 +0100
Message-Id: <20220221162652.103834-5-clement.leger@bootlin.com>
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

This function will be modified to be reused for
fwnode_property_read_string_index(). In order to avoid copy/paste of
existing code, split the existing function and pass a callback that
will be executed once the string array has been retrieved.

In order to reuse this function with other actions.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/base/property.c | 50 +++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 6ffb3ac4509c..cd1c30999fd9 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -410,10 +410,11 @@ EXPORT_SYMBOL_GPL(fwnode_property_read_string);
  * fwnode_property_match_string - find a string in an array and return index
  * @fwnode: Firmware node to get the property of
  * @propname: Name of the property holding the array
- * @string: String to look for
+ * @cb: callback to execute on the string array
+ * @data: data to be passed to the callback
  *
- * Find a given string in a string array and if it is found return the
- * index back.
+ * Execute a given callback on a string array values and returns the callback
+ * return value.
  *
  * Return: %0 if the property was found (success),
  *	   %-EINVAL if given arguments are not valid,
@@ -421,8 +422,10 @@ EXPORT_SYMBOL_GPL(fwnode_property_read_string);
  *	   %-EPROTO if the property is not an array of strings,
  *	   %-ENXIO if no suitable firmware interface is present.
  */
-int fwnode_property_match_string(const struct fwnode_handle *fwnode,
-	const char *propname, const char *string)
+static int fwnode_property_string_match(const struct fwnode_handle *fwnode,
+					const char *propname,
+					int (*cb)(const char **, int, void *),
+					void *data)
 {
 	const char **values;
 	int nval, ret;
@@ -442,13 +445,46 @@ int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 	if (ret < 0)
 		goto out;
 
+	ret = cb(values, nval, data);
+out:
+	kfree(values);
+	return ret;
+}
+
+static int match_string_callback(const char **values, int nval, void *data)
+{
+	int ret;
+	const char *string = data;
+
 	ret = match_string(values, nval, string);
 	if (ret < 0)
 		ret = -ENODATA;
-out:
-	kfree(values);
+
 	return ret;
 }
+
+/**
+ * fwnode_property_match_string - find a string in an array and return index
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property holding the array
+ * @string: String to look for
+ *
+ * Find a given string in a string array and if it is found return the
+ * index back.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of strings,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_match_string(const struct fwnode_handle *fwnode,
+				 const char *propname, const char *string)
+{
+	return fwnode_property_string_match(fwnode, propname,
+					    match_string_callback,
+					    (void *)string);
+}
 EXPORT_SYMBOL_GPL(fwnode_property_match_string);
 
 /**
-- 
2.34.1

