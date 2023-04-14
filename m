Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD06E2BB7
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjDNVYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjDNVYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:24:13 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B285D6A70;
        Fri, 14 Apr 2023 14:24:11 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4ec81245ae1so62156e87.0;
        Fri, 14 Apr 2023 14:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681507449; x=1684099449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2EiDytvabdYN54DIeMJTMZ/ViwsZyEhMHyZ0a9MJx4o=;
        b=f4bXWIVQdBvGSTrlBLVpdjpmOpLlf/2zdUUYvWsYmqr1oM2sa0uOWGdPjMUDAYU19/
         9FRa/pjk5Bh3ItGibXEqYg/jPR8uXoOme2v5qsFilkyI+hJuLgtAaAP9vRbRD8YPJ9TP
         TpQqaHKYS5JmhzpF/ivSf9LXQccZOYBd1u4hUxOGwpamErBL0Cep+J/a0+Wzl1LRhsXm
         jWv/tCmWNbN8VVWD7Zo+g7mvIMoZqGYJgXlSuc4an0E+nlmGC6kqB1X3Cnjq0IEAEZvq
         IRQerQ4SWmll4wSfdfNPParLM5LNk7Abli51mYfUvneX2An3VzgOyeQvd75oQzfsFTTK
         9e7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681507449; x=1684099449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2EiDytvabdYN54DIeMJTMZ/ViwsZyEhMHyZ0a9MJx4o=;
        b=L33sktSagTnIN+jS7RSlkaqsQtjDUMBQ2Tl+55arRAgqWxdLlU6jhFCBy5vAgNqHwy
         pNbvLKHZ4X0z2qc7CbKw4bUmMWPa5njqLUjKwLItstX0H0+u3lVZDbg8+fA7etXyA9Of
         cc6zDflrl37qBvS4zZIF9cPvl9hnesTVSDG6F5oLuta0LBqTmY6aUat6CX4jssn4jXC/
         cWKI2k376nF8/obV5XjjhpiJAJyeyCUED9pV7gsqowIlOPBe4dqPB3dYubGMytWeeVQt
         m1Uljdkupr5PXM/+tJFt1pfA5PQCBn8pR8AiIz3kEPU8WZZT65OOaSSdagChZswEoAeS
         EUXg==
X-Gm-Message-State: AAQBX9fd/SXRr/o8na+YSqZ1tp8AGv8jPGpr/XFjDytM7pPkOVqKx9lz
        +4jYsaYNh5m+NUFBrSYV+Z8=
X-Google-Smtp-Source: AKy350ZI1VywWQcvXG6FwGA8wlIsDCE6CZLzEI5r5l8KCp0+nQsf0jYJpptE+LEBb49w6SKevH1t1w==
X-Received: by 2002:a19:7003:0:b0:4db:3605:9bd3 with SMTP id h3-20020a197003000000b004db36059bd3mr55621lfc.17.1681507449498;
        Fri, 14 Apr 2023 14:24:09 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id m11-20020a056512014b00b004ecad67a925sm961263lfo.66.2023.04.14.14.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:24:09 -0700 (PDT)
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
Subject: [PATCH 3/3] wifi: ath11k: support reading radio MAC from DT
Date:   Fri, 14 Apr 2023 23:23:56 +0200
Message-Id: <20230414212356.9326-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230414212356.9326-1-zajec5@gmail.com>
References: <20230414212356.9326-1-zajec5@gmail.com>
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

