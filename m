Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD45D6EFE6F
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242925AbjD0ATU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242889AbjD0ATJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:09 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072F93C25;
        Wed, 26 Apr 2023 17:19:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f315712406so4552385e9.0;
        Wed, 26 Apr 2023 17:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554743; x=1685146743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iogxZrwR7jS1339aenDmYf0QuXCUsrtwcvqfdOp9YTo=;
        b=VvUZgyjloOwBQWEwDCk9HROKQf7018Fx3k0+8aWr0YvHw6rfL9iawxkTyqDRRL0MAI
         vj8IIo6dctAy+dPSR0E1Nvb5vtAdE7jzFiq9pjzpbjh9liT+po4HZivFduykxiieWX0h
         eUKt/lOK+HcrPtBkoMo5zOO/Svu0to2KyxJYIJiDCawvyr1mnwWYqgLHbJLP4Ocniogu
         HD/y6i0R3dSvNYA1k7wwGLFiKi9MZW+wdv26OAPXjB5u9ft1JsFMBXisOrvSNmPNqd9l
         0RXm/pT4DXyuq9ttgcbu7QjOuZ7hEPFgmiHm31l+QioTvL5hkZoEEDXMMPfBn2gFzmYI
         nunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554743; x=1685146743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iogxZrwR7jS1339aenDmYf0QuXCUsrtwcvqfdOp9YTo=;
        b=PomFfTE6wX6T93MEQwDxWCe7Fc2nbIaUhTT0J3mlwuCcdBoHDV39e7LjowzewNneaZ
         ARCIJTL5DG0HjJYQ3HcXdeHZrM4jZAvF5z0aCqYQ2BWFCqMTQ7FFdRPeaxiM7A0Jtj/Q
         TG5/VZugbNgKK5KpBuJVOZT0jGJ0zTV2V2FGyN9PFIYD3nGWxd4hjfTHIAeLOXyZ1q27
         qPsKnLAtwdnBkhYyXSHe1BhRwP4GtiEe5R+Q30FsY6o7SmwsWlrVwCfm3HGHud+G/+V3
         x/jiweXupVH6jY5VA8/8sIvD7397/RogdYrZW0MhCkAeELPeRLBCHXlFGNqTQ0GlKBeq
         zNVg==
X-Gm-Message-State: AC+VfDyAQbLtcusITqzGT2pVJLuDe4H0g1CZBQF0R3vIMz4p0rvY/tWE
        LB5bUCW8wRv4GeEpU1rGzcyD9wFnuiA=
X-Google-Smtp-Source: ACHHUZ6pDKpk7ugYsov0sXthhW3RglYjLlnYtLTtwloTM0RBpFG31uF/2n6o/JAMzixOk7Pn2hxRmw==
X-Received: by 2002:a1c:ed0e:0:b0:3f1:6ead:e396 with SMTP id l14-20020a1ced0e000000b003f16eade396mr44681wmh.17.1682554743205;
        Wed, 26 Apr 2023 17:19:03 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:19:02 -0700 (PDT)
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
Subject: [PATCH 09/11] leds: trigger: netdev: init mode if hw control already active
Date:   Thu, 27 Apr 2023 02:15:39 +0200
Message-Id: <20230427001541.18704-10-ansuelsmth@gmail.com>
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

On netdev trigger activation, hw control may be already active by
default. If this is the case, init the already active mode and set the
bool to hw_control bool to true to reflect the already set mode in the
trigger_data.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 61bc19fd0c7a..27df24e6d559 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -465,6 +465,13 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(50));
 	trigger_data->last_activity = 0;
 
+	/* Check if hw control is active by default on the LED.
+	 * Init already enabled mode in hw control.
+	 */
+	if (led_trigger_can_hw_control(led_cdev) &&
+	    !led_cdev->hw_control_get(led_cdev, &trigger_data->mode))
+		trigger_data->hw_control = true;
+
 	led_set_trigger_data(led_cdev, trigger_data);
 
 	rc = register_netdevice_notifier(&trigger_data->notifier);
-- 
2.39.2

