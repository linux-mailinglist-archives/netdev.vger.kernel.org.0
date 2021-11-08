Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BB14476E5
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 01:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhKHA1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 19:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbhKHA1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 19:27:51 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DCAC061570;
        Sun,  7 Nov 2021 16:25:07 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m14so54986261edd.0;
        Sun, 07 Nov 2021 16:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9O/XRGVCAVI4mIZuW0aXJANqTvL2aeHLazO21jBgbbk=;
        b=ZtLgxESjrFl7KTKO/jEHPm1pqgP/DqUqk02bYUqy70Brevi+/JC4fsfptOfW9HecUr
         a7OviZa3pxZsHnS6EVPX5zNo69o+P9XDUH9aupsy2T7NCEzqYTzhV7QhpioWundQB4A0
         jsCgP95Rhy4DMDOgeAy/30MD2415h14XLje49+OFN1eD0v7ta5BnxtsTBx5zv0WpRssj
         4AZ0LZZPLD/ak4tTcpk3yHhmBIRhMhgLj952NYdMwNVuFas2CCfALPcqOsIkHmZ1OuXM
         a1I765jemR2cJcrcB/RcrD37+FctJaKETljP1AkJxiVipRvdltMaJhFIi3oVn1zGtqPX
         lauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9O/XRGVCAVI4mIZuW0aXJANqTvL2aeHLazO21jBgbbk=;
        b=MDaminv6f2pAQ8cbcaF21ErHZyUPoj+4pQss8JJ6sAWy5Uklg+3smAmRR7sPlGltOg
         dWhtVqPa+630+WC+1wkbyNOQkVPkvhEWUQ1pwYnhsuorh3Ri1icLuEKxLkwacE+Inm9e
         S+wTluQrO5AsYgfdqQSDIQSvKG8RdnQT7M0icy9HZ6DmrcvdnFyMPdAo8Rb/7WUyemKi
         PNk2wjEyBMblCEezQl5Ct8qSpZFIAU1K6zfrJPJbb66rzYOmBvxwRaMRnrvUBtUXH4dh
         A3VABL5dojpPzmwC7hZJDNd1gwDTxyvnXWfwg9sHeMOFVGxtmNGb5Ll51NWGfHC8UIhj
         neAg==
X-Gm-Message-State: AOAM531ESxtpjHEp5bRW5a5ZnyyeMEgsHmcpf8A8vNaX6pCOqSQRbkdI
        3IQFlFYeHW/wCPl5bUiO0Qc=
X-Google-Smtp-Source: ABdhPJwkhkgIIWWe2/v7k0YWxERqKg1gWpPIvBZvsNXkxUGuMcmaKUPw1iV3PE2AaiuDKyFhJ94z/w==
X-Received: by 2002:a05:6402:327:: with SMTP id q7mr90521814edw.126.1636331105904;
        Sun, 07 Nov 2021 16:25:05 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id bf8sm8537878edb.46.2021.11.07.16.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 16:25:05 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v2 2/5] leds: add function to configure offload leds
Date:   Mon,  8 Nov 2021 01:24:57 +0100
Message-Id: <20211108002500.19115-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211108002500.19115-1-ansuelsmth@gmail.com>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add configure_offload helper to configure how the LED should work in
offload mode. The function require to support the particular trigger and
will use the passed offload_flags to elaborate the data and apply the
correct configuration. This function will then be used by the offload
trigger to request and update offload configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 24 ++++++++++++++++++++++++
 include/linux/leds.h              | 28 ++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index 5bf6e5d471ce..0a3bbe71dac7 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -190,6 +190,30 @@ If the second argument (enable) to the trigger_offload() method is false, any
 active HW offloading must be deactivated. In this case errors are not permitted
 in the trigger_offload() method and the driver will be set to the new trigger.
 
+The offload trigger will use the function configure_offload() provided by the driver
+that will configure the offloaded mode for the LED.
+This function passes as the first argument (offload_flags) a u32 flag.
+The second argument (cmd) of the configure_offload() method can be used to do various
+operations for the specific trigger. We currently support ENABLE, DISABLE, READ and
+SUPPORTED to enable, disable, read the state of the offload trigger and ask the LED
+driver supports the specific offload trigger.
+
+In ENABLE/DISABLE configure_offload() should configure the LED to enable/disable the
+requested trigger (flags).
+In READ configure_offload() should return 0 or 1 based on the status of the requested
+trigger (flags).
+In SUPPORTED configure_offload() should return 0 or 1 if the LED driver supports the
+requested trigger (flags) or not.
+
+The u32 flag is specific to the trigger and change across them. It's in the LED
+driver interest know how to elaborate this flag and to declare support for a
+particular offload trigger. For this exact reason explicit support for the specific
+trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
+with a not supported trigger.
+If the driver returns -EOPNOTSUPP on configure_offload(), the trigger activation will
+fail as the driver doesn't support that specific offload trigger or doesn't know
+how to handle the provided flags.
+
 Known Issues
 ============
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 949ab461287f..2a1e60e4d73e 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -67,6 +67,15 @@ struct led_hw_trigger_type {
 	int dummy;
 };
 
+#ifdef CONFIG_LEDS_OFFLOAD_TRIGGERS
+enum offload_trigger_cmd {
+	TRIGGER_ENABLE, /* Enable the offload trigger */
+	TRIGGER_DISABLE, /* Disable the offload trigger */
+	TRIGGER_READ, /* Read the status of the offload trigger */
+	TRIGGER_SUPPORTED, /* Ask the driver if the trigger is supported */
+};
+#endif
+
 struct led_classdev {
 	const char		*name;
 	unsigned int brightness;
@@ -160,6 +169,14 @@ struct led_classdev {
 	/* some LEDs cne be driven by HW */
 	int			(*trigger_offload)(struct led_classdev *led_cdev,
 						   bool enable);
+	/* Function to configure how the LEDs should work in offload mode.
+	 * The function require to support the trigger and will use the
+	 * passed flags to elaborate the trigger requested and apply the
+	 * correct configuration.
+	 */
+	int			(*configure_offload)(struct led_classdev *led_cdev,
+						     u32 offload_flags,
+						     enum offload_trigger_cmd cmd);
 #endif
 #endif
 
@@ -417,6 +434,17 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 }
 
 #ifdef CONFIG_LEDS_OFFLOAD_TRIGGERS
+bool led_trigger_offload_is_supported(struct led_classdev *led_cdev, u32 flags)
+{
+	int ret;
+
+	ret = led_cdev->configure_offload(led_cdev, flags, TRIGGER_SUPPORTED);
+	if (ret > 0)
+		return true;
+
+	return false;
+}
+
 static inline int led_trigger_offload(struct led_classdev *led_cdev)
 {
 	int ret;
-- 
2.32.0

