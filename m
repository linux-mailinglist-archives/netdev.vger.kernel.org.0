Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC36EFE79
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbjD0ATJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbjD0ATB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:01 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D991FF2;
        Wed, 26 Apr 2023 17:18:59 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f315712406so4551005e9.0;
        Wed, 26 Apr 2023 17:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554738; x=1685146738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P3YTYYS21+pNeT0fpIDxBpeIvQtUm9X7UHJe+LvhUmc=;
        b=WqZHvtwy44nCqhuHOJeT+uRbCZ40ThRmY6HFy6dTe00EZT3Tf5Wa5ZWzTAGWYFjN9k
         tPhfKZ5Ngo3XCiUaE19Qd87GSdxbuj/5K7i6F3gZpXp7J4swNovpAyRZCc33wiqEgGhv
         sfy766e55PAApIT2+TweD4dKOLrZTCtEW7vWZ5MORchJPfvk1jXWYU3kKr+MYzcCdHFh
         OZM8Hc95UNdQaUgTAl7BH60dHXMfAjdkGZ2RRC9UxyfE2mGjaglS+9684PHIDf5uoaFj
         5pPy6FJcgSyuO+PQ8euOAEtXc7XWzRbHxbhPtv+6cRrKOjGnFjhdgBmQbvUKe5wq+55c
         CQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554738; x=1685146738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3YTYYS21+pNeT0fpIDxBpeIvQtUm9X7UHJe+LvhUmc=;
        b=iJFkpUXGYRURRJ0LqxYVoXqh2HjlauDKKckq/sFxNs1LbIb3AMCVVd6yd7yPze7oOe
         uaUEoOjDfgKNwLceseWIcvtCSymRL/Zr4JwbvzdwhgB0qsY4cPA1F643mkypNLcpmU0k
         kNF0Zutqh0Z3XSSz23AoNlCI7rXIa3N90zcDG3IWgreaGNX2cXra9/tRTgj9tDtbbdYm
         8rqMRmt7GL0fv36T8JLZRz5htmNlcX21wetiyj8xJ36LMFQjdbf6tMX8q6iwSseAnEYH
         LwI2MKRErFOc9T2c++r9Q3pRtlAyfG3nL+7rTC0vdmL+/YVHdsLEPniqSdH5LVdheAem
         E3dQ==
X-Gm-Message-State: AC+VfDxoLJWxi6fsTH8sucWLCs8Qi/2q/STU6AEA7UXXyIAXqf+oRszc
        7Q5sYIywdqWQCWXIgDcTvDIvx2Pg8tA=
X-Google-Smtp-Source: ACHHUZ6BWlCi67VAlpbuLSwmnBVGf+3J4jUSYkXOOC2bNcAQ2FHXi87rgktltjONam28hEQAga0fmg==
X-Received: by 2002:a05:600c:1c22:b0:3f1:7a31:2c86 with SMTP id j34-20020a05600c1c2200b003f17a312c86mr2980252wms.16.1682554737558;
        Wed, 26 Apr 2023 17:18:57 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:18:57 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 04/11] Documentation: leds: leds-class: Document new Hardware driven LEDs APIs
Date:   Thu, 27 Apr 2023 02:15:34 +0200
Message-Id: <20230427001541.18704-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230427001541.18704-1-ansuelsmth@gmail.com>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
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

Document new Hardware driven LEDs APIs.

Some LEDs can be programmed to be entirely driven by hw. This is not
limited to blink but also to turn off or on autonomously.
To support this feature, a LED needs to implement various additional
ops and needs to declare specific support for the supported triggers.

Add documentation for each required value and API to make hw control
possible and implementable by both LEDs and triggers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 56 +++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..a7bc31e9b919 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,62 @@ Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
 hardware blinking function, if any.
 
+Hardware driven LEDs
+====================
+
+Some LEDs can be programmed to be entirely driven by hw. This is not
+limited to blink but also to turn off or on autonomously.
+To support this feature, a LED needs to implement various additional
+ops and needs to declare specific support for the supported triggers.
+
+With hw control we refer to the LED driven by hardware.
+
+LED driver must define the following value to support hw control:
+
+    - hw_control_trigger:
+               unique trigger name supported by the LED in hw control
+               mode.
+
+    - trigger_supported_flags_mask:
+                mask of the different supported trigger mode for the
+                defined trigger in hw control mode.
+
+LED driver must implement the following API to support hw control:
+
+     - hw_control_set:
+                activate hw control, LED driver will use the provided
+                flags passed from the supported trigger, parse them to
+                a set of mode and setup the LED to be driven by hardware
+                following the requested modes.
+
+                Set LED_OFF via the brightness_set to deactivate hw control.
+
+    - hw_control_get:
+                get from a LED already in hw control, the active modes,
+                parse them and set in flags the current active flags for
+                the supported trigger.
+
+    - hw_control_is_supported:
+                check if the flags passed by the supported trigger can
+                be parsed and activate hw control on the LED.
+
+LED driver can activate additional modes by default to workaround the
+impossibility of supporting each different mode on the supported trigger.
+Example are hardcoding the blink speed to a set interval, enable special
+feature like bypassing blink if some requirements are not met.
+
+A helper led_trigger_can_hw_control() is provided to check if the LED
+can actually run in hw control.
+
+A trigger should first use such helper to verify if hw control is possible,
+use hw_control_is_supported to check if the flags are supported and only at
+the end use hw_control_set to activate hw control.
+
+A trigger can use hw_control_get to check if a LED is already in hw control
+and init their flags.
+
+When the LED is in hw control, no software blink is possible and doing so
+will effectively disable hw control.
 
 Known Issues
 ============
-- 
2.39.2

