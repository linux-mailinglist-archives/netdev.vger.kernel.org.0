Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAC06BDEDD
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCQCeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCQCd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:56 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD84B5FD3;
        Thu, 16 Mar 2023 19:33:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so4274481wmb.5;
        Thu, 16 Mar 2023 19:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=MvAPnp/x+3dMsvqIme9hGfx9GPOwYDjvy8ULFwF3i0oLJvBJU+A1zIKILf+YJ4XXHT
         Y8ZKl12i0S4zR5V/gxxmVWtEZclaGFU0a7rjZopfgg8s3ScN74UXXMi7aNKb1/RnASL1
         VkYE2z+7jNDDGAPEpMEMMKO3N26Skm+QUWiEOXzXExbEF1HiCa/92f1OIAa/Y50pk2pM
         yjPclHyazOaxbhMeR0cpaNnmQirvDukmpaXkxbZ2XM5R6QuncXVRAxwiDsyjeaK6wppC
         krJGkwGWxn5SjhBpvWqHcoXE2S2gmmxlwUyYvTCSSkiG3lci42ojwgr0LmW1RMQzuKRb
         OMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=oGQUgJbljQSz4GgcrpykIFXd62s3eZqcgRtSFoD6eB7GoHviDBh5uNoG9VPKDkNxle
         R0+7uYB0J4X0rYEqOhyO8p/LkCisVQs5Q/LAHa+CYEKAJAt07z6EbvxYqWY4O9ZW38Zk
         YyiFVE32V76Smhp4TuZwfYqXducsxMDgxAKU09IOHluJM7cJi2l83f9+o78DnXvo/r03
         Ya6FnNA7z2ljxddgiQfdG3U8uQQAEmK5Dsljxz0uboWLZbORvmVUYzA/Siywv84cbRQ4
         F3i6Y+Z1KTIR+DtkLN7+QfxjZ58I1017LGOM39YAd12jvDTXcYWZb4+2gj0X9MOG5y+L
         Oh8w==
X-Gm-Message-State: AO0yUKXYZdjfin3vJtjGYdUgUAuh7zjbY+DMGZmvaCn1lKEa0eG0GQ/F
        ohY//njFOAm9iIoXyXFozl0=
X-Google-Smtp-Source: AK7set9NVXvJxrdQHvGCR6rIaEr1kTfeoZr8ogQyqlxsK4KW9JwQSINmWoPljf8J0n1ShQDa7dj3RQ==
X-Received: by 2002:a05:600c:3514:b0:3e2:6c6:31a6 with SMTP id h20-20020a05600c351400b003e206c631a6mr22785631wmq.9.1679020414336;
        Thu, 16 Mar 2023 19:33:34 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:34 -0700 (PDT)
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v4 11/14] arm: qcom: dt: Drop unevaluated properties in switch nodes for rb3011
Date:   Fri, 17 Mar 2023 03:31:22 +0100
Message-Id: <20230317023125.486-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPQ8064 MikroTik RB3011UiAS-RM DT have currently unevaluted properties
in the 2 switch nodes. The bindings #address-cells and #size-cells are
redundant and cause warning for 'Unevaluated properties are not
allowed'.

Drop these bindings to mute these warning as they should not be there
from the start.

Cc: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index f908889c4f95..47a5d1849c72 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -38,8 +38,6 @@ mdio0: mdio-0 {
 
 		switch0: switch@10 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <0 0>;
 
@@ -105,8 +103,6 @@ mdio1: mdio-1 {
 
 		switch1: switch@14 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <1 0>;
 
-- 
2.39.2

