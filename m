Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C996E5D96
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjDRJjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjDRJiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:38:52 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202881BE1;
        Tue, 18 Apr 2023 02:38:49 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4ec816c9d03so2085472e87.2;
        Tue, 18 Apr 2023 02:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681810727; x=1684402727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2EiDytvabdYN54DIeMJTMZ/ViwsZyEhMHyZ0a9MJx4o=;
        b=Mgp+FdmjTOO8yLjct8Ey6wAnQpaKYZlpn2pHIG/2fXHgwHj/Ymsw2LgM4jEvE+za4O
         jAp/K7vJGFvKrT3Du403FmySbg0WVdwsklAz0iRECcpDaazBXpH62uSP6gUCQG0Q+uPH
         gfhOAYxFyRewQeY9zawHDscntVwKav0mwa5QqidN9YpWT1+rwN2ck5CYjjqenxl03Tl7
         tRe4tdK6V//ly3ZSmdFwmmlHxVGg79S5O4pJvxFMywh3NuWbwReXEWVmWD0oXdylO2x7
         d/c20YL0TytiL9Amg2m/gKdQbF1YHytZTgBDbYhT91FWNjluR8A0ZG92/MlBjt5QbpZV
         2qjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681810727; x=1684402727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2EiDytvabdYN54DIeMJTMZ/ViwsZyEhMHyZ0a9MJx4o=;
        b=jbkC9Rcgnd7CUrzhPAY9HGIO/mPw8Y6Tr/5zJ5xYrlAkHvjM3zb7xURkDf1HFEoQyy
         g/z2DCPVIuVgwVvs7zEadobYtkze3nRvXYeTr64xNBoXZELtPDA45TVXknCnQxMV4Lii
         g7Pj3qA/pjJNePzGV6X+cyRO9U1t2MTewOOvUz0HUcC7e3HOoxJw+PhXPRg/AzVX2klz
         jsoPfGExfMOILAQQQA4A4IugzOBPRbKjdMmg6P+VQYIzgY/5QGPSzRsJqC2jxbM9D8Y9
         2d6jXA55itplXOYZ90cyoDeDbITpBHi44hOOPWqRxIYSEgKcFnzOlNImK0PPM2f2neZm
         GjgQ==
X-Gm-Message-State: AAQBX9caHYT8SwPuzEXrFH/PdxY11ATu0UItJiUCi+MYIh1kwygxbzwN
        /4A5ryhOckfrEW/+kIajbu0=
X-Google-Smtp-Source: AKy350ZXxaKlonTpKEaCIg1QXYK9jvpC8SvvkEmTVCX2/ZXSW9v2VJsf2RGCeOgoAGtNFBxH/Rf4eA==
X-Received: by 2002:ac2:46c9:0:b0:4ed:c537:d0ca with SMTP id p9-20020ac246c9000000b004edc537d0camr1608334lfo.59.1681810727353;
        Tue, 18 Apr 2023 02:38:47 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id x27-20020a05651c105b00b002a8c2a4fe99sm967813ljm.28.2023.04.18.02.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 02:38:46 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 3/3] wifi: ath11k: support reading radio MAC from DT
Date:   Tue, 18 Apr 2023 11:38:22 +0200
Message-Id: <20230418093822.24005-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418093822.24005-1-zajec5@gmail.com>
References: <20230418093822.24005-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

On some devices (most routers) MAC is stored in an NVMEM cell. Support
reading it.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/ath/ath11k/mac.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ad5a22d12bd3..6550bb5b2ece 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
 #include <linux/inetdevice.h>
+#include <linux/of_net.h>
 #include <net/if_inet6.h>
 #include <net/ipv6.h>
 
@@ -9292,7 +9293,7 @@ int ath11k_mac_register(struct ath11k_base *ab)
 	struct ath11k_pdev *pdev;
 	int i;
 	int ret;
-	u8 mac_addr[ETH_ALEN] = {0};
+	u8 device_mac_addr[ETH_ALEN] = {0};
 
 	if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
 		return 0;
@@ -9305,18 +9306,22 @@ int ath11k_mac_register(struct ath11k_base *ab)
 	if (ret)
 		return ret;
 
-	device_get_mac_address(ab->dev, mac_addr);
+	device_get_mac_address(ab->dev, device_mac_addr);
 
 	for (i = 0; i < ab->num_radios; i++) {
+		u8 radio_mac_addr[ETH_ALEN];
+
 		pdev = &ab->pdevs[i];
 		ar = pdev->ar;
-		if (ab->pdevs_macaddr_valid) {
+		if (!of_get_mac_address(ar->np, radio_mac_addr)) {
+			ether_addr_copy(ar->mac_addr, radio_mac_addr);
+		} else if (ab->pdevs_macaddr_valid) {
 			ether_addr_copy(ar->mac_addr, pdev->mac_addr);
 		} else {
-			if (is_zero_ether_addr(mac_addr))
+			if (is_zero_ether_addr(device_mac_addr))
 				ether_addr_copy(ar->mac_addr, ab->mac_addr);
 			else
-				ether_addr_copy(ar->mac_addr, mac_addr);
+				ether_addr_copy(ar->mac_addr, device_mac_addr);
 			ar->mac_addr[4] += i;
 		}
 
-- 
2.34.1

