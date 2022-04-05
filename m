Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7506A4F35B2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiDEKyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243818AbiDEJkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:40:31 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EA0B91B0;
        Tue,  5 Apr 2022 02:25:03 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8682B2223B;
        Tue,  5 Apr 2022 11:25:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649150701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+OFxAn9prM8mlm3/zovhOFPWTcQhEUSgagLc9/Iqw8c=;
        b=lWcLxt3Tyls2AX8fUDpAGI+eTePpel7GXEKE8H2v25yRlmp2+EMIZgUGs5GYikS5jjacpW
        56KoBnCyeNyVpJsLrfscrM1XjQESDvk+WpEnnUkcFoiMbTFuTborr1JPXQSnvPX1jW+bzk
        OoUzmWD+M6YlQRqXVyANQhB/d4XStcA=
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
        netdev@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v4 1/2] hwmon: introduce hwmon_sanitize_name()
Date:   Tue,  5 Apr 2022 11:24:51 +0200
Message-Id: <20220405092452.4033674-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220405092452.4033674-1-michael@walle.cc>
References: <20220405092452.4033674-1-michael@walle.cc>
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
 Documentation/hwmon/hwmon-kernel-api.rst | 16 +++++++
 drivers/hwmon/hwmon.c                    | 53 ++++++++++++++++++++++++
 include/linux/hwmon.h                    |  3 ++
 3 files changed, 72 insertions(+)

diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
index c41eb6108103..e2975d5caf34 100644
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
@@ -95,6 +99,18 @@ All supported hwmon device registration functions only accept valid device
 names. Device names including invalid characters (whitespace, '*', or '-')
 will be rejected. The 'name' parameter is mandatory.
 
+If the driver doesn't use a static device name (for example it uses
+dev_name()), and therefore cannot make sure the name only contains valid
+characters, hwmon_sanitize_name can be used. This convenience function
+will duplicate the string and replace any invalid characters with an
+underscore. It will allocate memory for the new string and it is the
+responsibility of the caller to release the memory when the device is
+removed.
+
+devm_hwmon_sanitize_name is the resource managed version of
+hwmon_sanitize_name; the memory will be freed automatically on device
+removal.
+
 Using devm_hwmon_device_register_with_info()
 --------------------------------------------
 
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 989e2c8496dd..5915ccfdb7d9 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -1057,6 +1057,59 @@ void devm_hwmon_device_unregister(struct device *dev)
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
+		return ERR_PTR(-ENOMEM);
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
+ * by an underscore. It is the responsibility of the caller to release
+ * the memory.
+ *
+ * Returns newly allocated name, or ERR_PTR on error.
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
+ * Returns newly allocated name, or ERR_PTR on error.
+ */
+char *devm_hwmon_sanitize_name(struct device *dev, const char *name)
+{
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
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

