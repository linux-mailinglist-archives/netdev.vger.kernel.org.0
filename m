Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CD04DDD7F
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbiCRQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238374AbiCRQEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:04:36 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F39C1275F;
        Fri, 18 Mar 2022 09:03:13 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0E66F40020;
        Fri, 18 Mar 2022 16:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647619391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K6nzaAfWaNMngOEuYPSa1o6WfkdK08VPd1q8M2c4niI=;
        b=OSZ5hewzHdXf7aZGTwpgXByUoG8K/3/hBmkg7sfe6OQ8e1KUqsF0Ht5YZQkUzjnwtHpfT8
        fWiNZ8u1zK5nOIaWP3eCDVtADmAeSbXRn+nEaS4swQpTvligBkvahEt/Mr7abhxCIRAmPJ
        eNkYTIhynxXg9yTZshQAGFWSlMCyEWtPI8nezu97mcoLssEi+RK2kx7jY4E9uVGr+pl+WI
        z6/kboPBEoS76PTiWKA1qLYrx6e9wH93LMEBKOjbZrL8r/f2uhq4p3hKX6nH9I2s1+Q6mY
        Jzwwf8OSE+OG+TnN/+AoEbaVLZ2xAzTUbL8jKkMbwo+DJKBbRKbaupM35VrLrA==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [PATCH 1/6] property: add fwnode_property_read_string_index()
Date:   Fri, 18 Mar 2022 17:00:47 +0100
Message-Id: <20220318160059.328208-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318160059.328208-1-clement.leger@bootlin.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fwnode_property_read_string_index() function which allows to
retrieve a string from an array by its index. This function is the
equivalent of of_property_read_string_index() but for fwnode support.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/base/property.c  | 48 ++++++++++++++++++++++++++++++++++++++++
 include/linux/property.h |  3 +++
 2 files changed, 51 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index e6497f6877ee..67c33c11f00c 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -451,6 +451,54 @@ int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL_GPL(fwnode_property_match_string);
 
+/**
+ * fwnode_property_read_string_index - read a string in an array using an index
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property holding the array
+ * @index: Index of the string to look for
+ * @string: Pointer to the string if found
+ *
+ * Find a string by a given index in a string array and if it is found return
+ * the string value in @string.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of strings,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_string_index(const struct fwnode_handle *fwnode,
+				      const char *propname, int index,
+				      const char **string)
+{
+	const char **values;
+	int nval, ret;
+
+	nval = fwnode_property_read_string_array(fwnode, propname, NULL, 0);
+	if (nval < 0)
+		return nval;
+
+	if (index >= nval)
+		return -EINVAL;
+
+	if (nval == 0)
+		return -ENODATA;
+
+	values = kcalloc(nval, sizeof(*values), GFP_KERNEL);
+	if (!values)
+		return -ENOMEM;
+
+	ret = fwnode_property_read_string_array(fwnode, propname, values, nval);
+	if (ret < 0)
+		goto out;
+
+	*string = values[index];
+out:
+	kfree(values);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_string_index);
+
 /**
  * fwnode_property_get_reference_args() - Find a reference with arguments
  * @fwnode:	Firmware node where to look for the reference
diff --git a/include/linux/property.h b/include/linux/property.h
index 7399a0b45f98..a033920eb10a 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -70,6 +70,9 @@ int fwnode_property_read_string_array(const struct fwnode_handle *fwnode,
 				      size_t nval);
 int fwnode_property_read_string(const struct fwnode_handle *fwnode,
 				const char *propname, const char **val);
+int fwnode_property_read_string_index(const struct fwnode_handle *fwnode,
+				      const char *propname, int index,
+				      const char **string);
 int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 				 const char *propname, const char *string);
 int fwnode_property_get_reference_args(const struct fwnode_handle *fwnode,
-- 
2.34.1

