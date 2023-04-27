Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684626EFE68
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242820AbjD0ATB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239857AbjD0AS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:18:57 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716810FC;
        Wed, 26 Apr 2023 17:18:56 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-2f7db354092so4887581f8f.2;
        Wed, 26 Apr 2023 17:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554734; x=1685146734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SdiVbjZmufCfYZGTqSBv0vnzLEDigQlcPetMQEagMHI=;
        b=PP9Yp8ldCRrEWyqntxAeBH9dpX3Pm4XfjetIoe70tuK2lyz6wiUi6/S161gErESXgZ
         K8KJyV0Lkl7+UniI46zqKn+4gTUXH0eTPy5b2faqOcUInObEddcSilK+3kyev4DrxF4F
         bmVzOE3YHeRQRx2wEDnCRr5CB+5wqfjKOVHhoFfHaHkLsLa0wb1KFEg4I3zk1pzwA5MB
         FTGkmg9XPPP9msyPOzDSeBP5+gnJ67cchmYtQAZMm0m99AenFD3ESRwiUAuJ9VCcqHCm
         dz8B2uzTR+TfnrQpPEA+sHeFD0pCCnW45SpgNdnPEOQKrravxll3wfJ6DtlaWoxmk/mz
         Baow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554734; x=1685146734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SdiVbjZmufCfYZGTqSBv0vnzLEDigQlcPetMQEagMHI=;
        b=ACFgr02jYglA5UMEP7/v6wOZ8opBjr6CCH3KwVYraDx5PG3dkS/8Ksbn9gIRAZgU+x
         Y1r+q0+s/Jm5HR8nKNbCIky8I7v2SZspQt7UkP943tDldIv7fK6L6a4/H5eoq2thTLGs
         KmFNofeYjXZJf3irapaU0wkAb2OcIrJw+LRRwFdWNdxvyoVXE8QwPKpgKoZtYB0fAfDY
         hZvRh+3vl9xHm+fVxz4HGuwXl81uUkzyu+01WhTmu7o8Al2OA4wkHS+4pPeBkFFZpdwr
         n+zf7eKtSLtiSJZuNqRfySo0M/qHI3OVQU8Y5q5n/q5BLw+T/8YRq7U1ip8zUCxaLE8P
         1Vcg==
X-Gm-Message-State: AAQBX9dq4l5lITrsey7zWdOEwDOSJ9u09rURy21nXctvrjoAJTtL56R5
        Cgs3yvoYyE3hKMXzWJgd1eA=
X-Google-Smtp-Source: AKy350arhA0yvQiwvx7ByKHU6VdBMqIKBIQcHSqsWw97PkcQJxYOTeEljpCViBCCtOWzwp1u4e+dww==
X-Received: by 2002:adf:dfc3:0:b0:2ef:b3ef:9e82 with SMTP id q3-20020adfdfc3000000b002efb3ef9e82mr15571484wrn.57.1682554734179;
        Wed, 26 Apr 2023 17:18:54 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:18:53 -0700 (PDT)
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
Subject: [PATCH 01/11] leds: add binding for LEDs hw control
Date:   Thu, 27 Apr 2023 02:15:31 +0200
Message-Id: <20230427001541.18704-2-ansuelsmth@gmail.com>
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

Add an option to permit LED driver to declare support for a specific
trigger to use hw control and setup the LED to blink based on specific
provided modes.

Add binding for LEDs hw control. These functions will be used to activate
hardware control where a LED will use the provided flags, from an
unique defined supported trigger, to setup the LED to be driven by
hardware.

Deactivate hardware blink control by setting brightness to LED_OFF via
the brightness_set() callback.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/leds.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index ba4861ec73d3..b3bd1cc8ace8 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -154,6 +154,26 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+	/* Unique trigger name supported by LED set in hw control mode */
+	const char		*hw_control_trigger;
+	/*
+	 * Activate hardware control, LED driver will use the provided flags
+	 * from the supported trigger and setup the LED to be driven by hardware
+	 * following the requested mode from the trigger flags.
+	 * Deactivate hardware blink control by setting brightness to LED_OFF via
+	 * the brightness_set() callback.
+	 */
+	int			(*hw_control_set)(struct led_classdev *led_cdev,
+						  unsigned long flags);
+	/*
+	 * Get from the LED driver the current mode that the LED is set in hw
+	 * control mode and put them in flags.
+	 * Trigger can use this to get the initial state of a LED already set in
+	 * hardware blink control.
+	 */
+	int			(*hw_control_get)(struct led_classdev *led_cdev,
+						  unsigned long *flags);
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
-- 
2.39.2

