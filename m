Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305514EB162
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbiC2QJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbiC2QJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:09:32 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC2125EC9E;
        Tue, 29 Mar 2022 09:07:47 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 153B722248;
        Tue, 29 Mar 2022 18:07:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648570065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oMRRGxH9Nujm513vUQGqeoV9eWcBeG+UrYAR14zPiq4=;
        b=T1R4x9qKNyyq+h+eSQc5n0FHJgNEaXWcPh29FID8XNTX+F1t/FMMaYSvgI5czlcztelKre
        41WwR7bVZRsYuJRktfqW8huZiqQsrHsNmzpUMDhbI0aaDeKxMSBRp8ENd814rp3lZ1RCCJ
        EsqtjJKxG26+SIu88W8ZCu1gYxhkzns=
From:   Michael Walle <michael@walle.cc>
To:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Date:   Tue, 29 Mar 2022 18:07:26 +0200
Message-Id: <20220329160730.3265481-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220329160730.3265481-1-michael@walle.cc>
References: <20220329160730.3265481-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More and more drivers will check for bad characters in the hwmon name
and all are using the same code snippet. Consolidate that code by adding
a new hwmon_sanitize_name() function.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 Documentation/hwmon/hwmon-kernel-api.rst |  9 ++++-
 drivers/hwmon/hwmon.c                    | 49 ++++++++++++++++++++++++
 include/linux/hwmon.h                    |  3 ++
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
index c41eb6108103..12f4a9bcef04 100644
--- a/Documentation/hwmon/hwmon-kernel-api.rst
+++ b/Documentation/hwmon/hwmon-kernel-api.rst
@@ -50,6 +50,10 @@ register/unregister functions::
 
   void devm_hwmon_device_unregister(struct device *dev);
 
+  char *hwmon_sanitize_name(const char *name);
+
+  char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
+
 hwmon_device_register_with_groups registers a hardware monitoring device.
 The first parameter of this function is a pointer to the parent device.
 The name parameter is a pointer to the hwmon device name. The registration
@@ -93,7 +97,10 @@ removal would be too late.
 
 All supported hwmon device registration functions only accept valid device
 names. Device names including invalid characters (whitespace, '*', or '-')
-will be rejected. The 'name' parameter is mandatory.
+will be rejected. The 'name' parameter is mandatory. Before calling a
+register function you should either use hwmon_sanitize_name or
+devm_hwmon_sanitize_name to replace any invalid characters with an
+underscore.
 
 Using devm_hwmon_device_register_with_info()
 --------------------------------------------
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 989e2c8496dd..619ef9f9a16e 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -1057,6 +1057,55 @@ void devm_hwmon_device_unregister(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(devm_hwmon_device_unregister);
 
+static char *__hwmon_sanitize_name(struct device *dev, const char *old_name)
+{
+	char *name, *p;
+
+	if (dev)
+		name = devm_kstrdup(dev, old_name, GFP_KERNEL);
+	else
+		name = kstrdup(old_name, GFP_KERNEL);
+	if (!name)
+		return NULL;
+
+	for (p = name; *p; p++)
+		if (hwmon_is_bad_char(*p))
+			*p = '_';
+
+	return name;
+}
+
+/**
+ * hwmon_sanitize_name - Replaces invalid characters in a hwmon name
+ * @name: NUL-terminated name
+ *
+ * Allocates a new string where any invalid characters will be replaced
+ * by an underscore.
+ *
+ * Returns newly allocated name or %NULL in case of error.
+ */
+char *hwmon_sanitize_name(const char *name)
+{
+	return __hwmon_sanitize_name(NULL, name);
+}
+EXPORT_SYMBOL_GPL(hwmon_sanitize_name);
+
+/**
+ * devm_hwmon_sanitize_name - resource managed hwmon_sanitize_name()
+ * @dev: device to allocate memory for
+ * @name: NUL-terminated name
+ *
+ * Allocates a new string where any invalid characters will be replaced
+ * by an underscore.
+ *
+ * Returns newly allocated name or %NULL in case of error.
+ */
+char *devm_hwmon_sanitize_name(struct device *dev, const char *name)
+{
+	return __hwmon_sanitize_name(dev, name);
+}
+EXPORT_SYMBOL_GPL(devm_hwmon_sanitize_name);
+
 static void __init hwmon_pci_quirks(void)
 {
 #if defined CONFIG_X86 && defined CONFIG_PCI
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index eba380b76d15..4efaf06fd2b8 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -461,6 +461,9 @@ void devm_hwmon_device_unregister(struct device *dev);
 int hwmon_notify_event(struct device *dev, enum hwmon_sensor_types type,
 		       u32 attr, int channel);
 
+char *hwmon_sanitize_name(const char *name);
+char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
+
 /**
  * hwmon_is_bad_char - Is the char invalid in a hwmon name
  * @ch: the char to be considered
-- 
2.30.2

