Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20774E95DD
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 13:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbiC1L4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 07:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241638AbiC1L4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 07:56:23 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B58D3F8B5;
        Mon, 28 Mar 2022 04:52:35 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C669122248;
        Mon, 28 Mar 2022 13:52:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648468354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3D7PvrkDUr5KTDJzMRa0QSPBaiykrSuh7utJ8QFltts=;
        b=EwkhqNdABJgZFfNlsZEAHy9TxvWFikceBuWAokZphoGci+5ZVCk7Sw8LZRJSGbK0eBOKr+
        XBrnRRygZScBx3NIQeBsQt/sCWJLVjFYzUhOJRE3iZi3tblWfwVp6GuGLWM2lgXWZZvrfi
        0OLdx2/vBRlsHWaDDDnUOR7Ta3IQhHs=
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
Subject: [PATCH v1 1/2] hwmon: introduce hwmon_sanitize_name()
Date:   Mon, 28 Mar 2022 13:52:25 +0200
Message-Id: <20220328115226.3042322-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220328115226.3042322-1-michael@walle.cc>
References: <20220328115226.3042322-1-michael@walle.cc>
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
 drivers/hwmon/intel-m10-bmc-hwmon.c |  5 +----
 include/linux/hwmon.h               | 16 ++++++++++++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
index 7a08e4c44a4b..e6e55fc30153 100644
--- a/drivers/hwmon/intel-m10-bmc-hwmon.c
+++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
@@ -515,7 +515,6 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
 	struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
 	struct device *hwmon_dev, *dev = &pdev->dev;
 	struct m10bmc_hwmon *hw;
-	int i;
 
 	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
 	if (!hw)
@@ -532,9 +531,7 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
 	if (!hw->hw_name)
 		return -ENOMEM;
 
-	for (i = 0; hw->hw_name[i]; i++)
-		if (hwmon_is_bad_char(hw->hw_name[i]))
-			hw->hw_name[i] = '_';
+	hwmon_sanitize_name(hw->hw_name);
 
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
 							 hw, &hw->chip, NULL);
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index eba380b76d15..210b8c0b2827 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -484,4 +484,20 @@ static inline bool hwmon_is_bad_char(const char ch)
 	}
 }
 
+/**
+ * hwmon_sanitize_name - Replaces invalid characters in a hwmon name
+ * @name: NUL-terminated name
+ *
+ * Invalid characters in the name will be overwritten in-place by an
+ * underscore.
+ */
+static inline void hwmon_sanitize_name(char *name)
+{
+	while (*name) {
+		if (hwmon_is_bad_char(*name))
+			*name = '_';
+		name++;
+	};
+}
+
 #endif
-- 
2.30.2

