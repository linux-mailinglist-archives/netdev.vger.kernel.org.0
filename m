Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6CA4EB16E
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbiC2QJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiC2QJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:09:34 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18F1E2F65;
        Tue, 29 Mar 2022 09:07:51 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CCA752224F;
        Tue, 29 Mar 2022 18:07:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648570067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ICyBKbcIANIRXFbM3XwImZyH8BggKJrVFsuGIGCnPIc=;
        b=ndwGVfNH2rpEswAMlPNbXXbh/lBTRKacuLkziFr1tB0krx0Qj0RmAAFSztGBTn5oG4mnfc
        rnuNqBGNCVjI0QIYPpga+VJw129Ccp6ZtVBazrxSplfXu/MizJRnretLRYOLt2ng95IQyk
        F7Cj3FuQCCEFWj8jXdm3l44NR4jOMyM=
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
Subject: [PATCH RFC v2 5/5] hwmon: move hwmon_is_bad_char() into core
Date:   Tue, 29 Mar 2022 18:07:30 +0200
Message-Id: <20220329160730.3265481-6-michael@walle.cc>
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

With the last user of this function converted to hwmon_sanitize_name(),
move the function into the core itself and make it private.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/hwmon/hwmon.c | 20 ++++++++++++++++++++
 include/linux/hwmon.h | 23 -----------------------
 2 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 619ef9f9a16e..f19b69b066ef 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -1057,6 +1057,26 @@ void devm_hwmon_device_unregister(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(devm_hwmon_device_unregister);
 
+/**
+ * hwmon_is_bad_char - Is the char invalid in a hwmon name
+ * @ch: the char to be considered
+ *
+ * Returns true if the char is invalid, false otherwise.
+ */
+static bool hwmon_is_bad_char(const char ch)
+{
+	switch (ch) {
+	case '-':
+	case '*':
+	case ' ':
+	case '\t':
+	case '\n':
+		return true;
+	default:
+		return false;
+	}
+}
+
 static char *__hwmon_sanitize_name(struct device *dev, const char *old_name)
 {
 	char *name, *p;
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 4efaf06fd2b8..6a60e3a4acc0 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -464,27 +464,4 @@ int hwmon_notify_event(struct device *dev, enum hwmon_sensor_types type,
 char *hwmon_sanitize_name(const char *name);
 char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
 
-/**
- * hwmon_is_bad_char - Is the char invalid in a hwmon name
- * @ch: the char to be considered
- *
- * hwmon_is_bad_char() can be used to determine if the given character
- * may not be used in a hwmon name.
- *
- * Returns true if the char is invalid, false otherwise.
- */
-static inline bool hwmon_is_bad_char(const char ch)
-{
-	switch (ch) {
-	case '-':
-	case '*':
-	case ' ':
-	case '\t':
-	case '\n':
-		return true;
-	default:
-		return false;
-	}
-}
-
 #endif
-- 
2.30.2

