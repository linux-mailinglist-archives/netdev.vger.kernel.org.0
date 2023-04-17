Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14676E4CBA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDQPUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjDQPU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:20:29 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BABB776;
        Mon, 17 Apr 2023 08:20:10 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2f8405b3dc1so994270f8f.3;
        Mon, 17 Apr 2023 08:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744809; x=1684336809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHm0NEeKo/+Hb6SrTm0b3FIHftdZOu6XAUw1fVTOEDE=;
        b=f7eiMBl5UAWig4VdU1DlcxCLoj1EfYUVVg7JpiHKaafFUz99uhdi4lT95IhqXM3Zu7
         pcxDeQiHnPIcHqMxkJif3yuhy1I/eW6RlwwGQoYThH6bCzNON4/2R3Ql1kfXkEsDCZly
         tn0w5fq4Cs/l9kXyJAg9uNZioe4p4MwL9PTpyOajFFA/8fR43ivxu8rdhsv+jtZDaVRG
         MkQvQA57+JCM3wx442ZHowbIBB2NJwT1/W3SaGpGSR54VhQd+AzcfehSreC+S3r14isK
         WQtAQntwbljPzhBPcun7OvRP0Dl3obXL8cFIT+tMR0aEYtI7LAPX+k5lTdFVmZ30vLPq
         WQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744809; x=1684336809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHm0NEeKo/+Hb6SrTm0b3FIHftdZOu6XAUw1fVTOEDE=;
        b=NGxSVH8OP3x0NczWYRGJMsh4hAHjBETurHVGKLWsV3GnxCJ0hhjBzZ+CCp2PPFSQRe
         ytUeAL7GrmC5qZTu2WN9vhyyQGQytKGSjlNmAVhxHArHxJS1xdCvaxAa6JZEDR7c/XWv
         XFeBV4T3w6x8+HItqRa0MQyi7Po3KvRoChKM/JJ6ghyCdYWrtN8oHyKOWupO1nZ7jz32
         qodIbOHQfKtrpzyAh7cpgNc2px5VIa7aDhKvSMvxJ3LLOj2T4BQVvQHEsfrSPmGN/v4u
         pOiYyKu6Ap0b1beW0rvm1W5eV8rNa7iqg4nwRZXb6dRTqHfxMM1MwOrTVw0Mfd1BWsZ6
         z/Rg==
X-Gm-Message-State: AAQBX9d3YIoj/LsQ6nwChRyLofwIMTERgMyVuls3jluPJL1tO5vMNmrs
        E777b4T6rOoN71V80bGby9o=
X-Google-Smtp-Source: AKy350Yuafm0kp2sjylWkkoW9sS/ZBvqUBWgbUq3h005//0MPbGON/ecb2mOALLbhnFKUajEkyyv2w==
X-Received: by 2002:a5d:5409:0:b0:2f8:5d73:dbf0 with SMTP id g9-20020a5d5409000000b002f85d73dbf0mr5806755wrv.27.1681744809066;
        Mon, 17 Apr 2023 08:20:09 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:20:00 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 04/16] leds: Provide stubs for when CLASS_LED & NEW_LEDS are disabled
Date:   Mon, 17 Apr 2023 17:17:26 +0200
Message-Id: <20230417151738.19426-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Provide stubs for devm_led_classdev_register_ext() and
led_init_default_state_get() so that LED drivers embedded within other
drivers such as PHYs and Ethernet switches still build when LEDS_CLASS
or NEW_LEDS are disabled. This also helps with Kconfig dependencies,
which are somewhat hairy for phylib and mdio and only get worse when
adding a dependency on LED_CLASS.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/leds.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index d71201a968b6..aa48e643f655 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -82,7 +82,15 @@ struct led_init_data {
 	bool devname_mandatory;
 };
 
+#if IS_ENABLED(CONFIG_NEW_LEDS)
 enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
+#else
+static inline enum led_default_state
+led_init_default_state_get(struct fwnode_handle *fwnode)
+{
+	return LEDS_DEFSTATE_OFF;
+}
+#endif
 
 struct led_hw_trigger_type {
 	int dummy;
@@ -217,9 +225,19 @@ static inline int led_classdev_register(struct device *parent,
 	return led_classdev_register_ext(parent, led_cdev, NULL);
 }
 
+#if IS_ENABLED(CONFIG_LEDS_CLASS)
 int devm_led_classdev_register_ext(struct device *parent,
 					  struct led_classdev *led_cdev,
 					  struct led_init_data *init_data);
+#else
+static inline int
+devm_led_classdev_register_ext(struct device *parent,
+			       struct led_classdev *led_cdev,
+			       struct led_init_data *init_data)
+{
+	return 0;
+}
+#endif
 
 static inline int devm_led_classdev_register(struct device *parent,
 					     struct led_classdev *led_cdev)
-- 
2.39.2

