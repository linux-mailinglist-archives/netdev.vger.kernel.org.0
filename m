Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E2C6EFE75
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243006AbjD0AT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242939AbjD0ATL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:11 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0E44211;
        Wed, 26 Apr 2023 17:19:05 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f178da21b2so79931105e9.1;
        Wed, 26 Apr 2023 17:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554744; x=1685146744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBKN5zR+bZsVZZXVBwIaaiTdBOy/v9Tih4PGMa1audw=;
        b=EDqy/JeBOr/vK/v8belVS70yp7rvvpGs2gxe/1EMwcub9XE5s+UzATQRzT2lSWBVJQ
         Row5FvTI7FSxTPa41huW1g6wkxr+aBqpKZxSrzQ0Fpw1o82aNNVwobRf/f1ZFfBBZVaP
         /NTafu8FovHH8k3/FfZzmHAc/BGJXn8gwM/5oZIWW6BgE4ZUBXYNIAW2aGtwtfT5iGW8
         2V+TWmoAZmyZjbHEmzQ8JZyTW/sW7F1NzJGizx7EVEblt2I/wVcTq5+dQ7iWRHNsS0mK
         vdrpVsRionks8I40Egv+SfUbS6bezvR//KA2gRL4hTloL4rFkzlRvU5DFZeHHS8yCX/V
         yGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554744; x=1685146744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aBKN5zR+bZsVZZXVBwIaaiTdBOy/v9Tih4PGMa1audw=;
        b=LScA0NZQnmzmSgd2m7EPJZpFkLpHMFq7gvGKKq4AzFCCRWu+q3Qdkwwb6BrRiq64EH
         sbe9CbZpJxvEPMJiyfNv4U3qq9wbVEiI2pbYQeMln7I29wL6VCU+tcWE7JnC0UgxssWS
         FKv5sKoEREtiyY7dGMJFcDJlfMUbVbF+pou71JRWD1vveLALKovr396irzx0IROXiA45
         2m0IafYflmkZ07NUWNbXMxBG24KDFMnpPQUiZI6eCHI66NkRy2BGU2Tyz5ktf5+AT5hN
         xPu4KmdEoibKAbp3Khxujk5eNi+p2JkexcpRszaJk5nVQD+1uCQgn6UyIEwgWD7yb6Ch
         4KLA==
X-Gm-Message-State: AAQBX9ffJLwjGs14lelkXiyqldwNO9O2rKkND/80q0TDTXOekCwNS/mC
        Ag/ZJ8pqAVnYKOdv/CsIyb3/6zAk7Uw=
X-Google-Smtp-Source: AKy350bPjB8OcXmb5MG8wdbdCErgUpF7tDHlz0V4uyLt2MWIqiJaqjQWRJSETnxmMb14xDegy5SnGg==
X-Received: by 2002:a5d:46c8:0:b0:2f9:8e93:d376 with SMTP id g8-20020a5d46c8000000b002f98e93d376mr16374599wrs.56.1682554744381;
        Wed, 26 Apr 2023 17:19:04 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:19:04 -0700 (PDT)
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
Subject: [PATCH 10/11] leds: trigger: netdev: expose netdev trigger modes in linux include
Date:   Thu, 27 Apr 2023 02:15:40 +0200
Message-Id: <20230427001541.18704-11-ansuelsmth@gmail.com>
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

Expose netdev trigger modes to make them accessible by LED driver that
will support netdev trigger for hw control.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c |  9 ---------
 include/linux/leds.h                  | 10 ++++++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 27df24e6d559..7d01e8becb08 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -54,15 +54,6 @@ struct led_netdev_data {
 	bool hw_control;
 };
 
-enum led_trigger_netdev_modes {
-	TRIGGER_NETDEV_LINK = 0,
-	TRIGGER_NETDEV_TX,
-	TRIGGER_NETDEV_RX,
-
-	/* keep last */
-	__TRIGGER_NETDEV_MAX,
-};
-
 static void set_baseline_state(struct led_netdev_data *trigger_data)
 {
 	int current_brightness;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index b9152bff3a96..a55f6c528dce 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -500,6 +500,16 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 
 #endif /* CONFIG_LEDS_TRIGGERS */
 
+/* Trigger specific enum */
+enum led_trigger_netdev_modes {
+	TRIGGER_NETDEV_LINK = 0,
+	TRIGGER_NETDEV_TX,
+	TRIGGER_NETDEV_RX,
+
+	/* keep last */
+	__TRIGGER_NETDEV_MAX,
+};
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.39.2

