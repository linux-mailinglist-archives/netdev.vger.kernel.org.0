Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807016B48D3
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjCJPHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbjCJPGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:06:40 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E9410B1F2;
        Fri, 10 Mar 2023 06:59:48 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-536af432ee5so103212207b3.0;
        Fri, 10 Mar 2023 06:59:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678460267;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y8VxmsrmA7atBWmoRBJdFjgV8EvMVWqE3uCteVpsl+8=;
        b=G2LpOUgY2IFeTjxU5dGKuIuNWsbr3ymz4jmAkVqwChZXIqV4dVKvNjIfk4FpeSXACb
         j3le/eceFLjsDhD+oppyN9QOU5J17/PlOJTsIN509vQFpRG4kfcmNkvCfN96xf3TFkkv
         ZsBP1IJNpp0TifzYnuNZdYvz96s4SEGNeUNl9d/x3bPfnJUFn14zp4g0f4MEaWREuEgC
         IMTm72p0hI0uon3GgX2A6vXVFIICdf3vzbfSGyVqK+Gn5w/KeX+sCzeaQmeTCWEzWhAV
         oectsszIqM71hIKLDEyYfZks1ryoH7FOss6JYkZw5iyzGvFPePzEuAMG1xiabvO33Jm5
         euVA==
X-Gm-Message-State: AO0yUKVpLC8hVvrYn3uwyBNj4nZmbKzNHJPvAQAHJIDEat5cv/eGcceN
        A1A3b20MWxgXKtD1ImGKjUfLgYKthA==
X-Google-Smtp-Source: AK7set+G8pLQ8MjEBu46eB9gZaZLsD0Z0lOMgGUc6toPZtLYpaxnR3yE6Cfzfxe2snlYX/ydKEao0A==
X-Received: by 2002:a05:6808:5d0:b0:384:28af:539c with SMTP id d16-20020a05680805d000b0038428af539cmr11489276oij.56.1678459705214;
        Fri, 10 Mar 2023 06:48:25 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p127-20020acaf185000000b00383ece4c29bsm994982oih.6.2023.03.10.06.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 06:48:24 -0800 (PST)
Received: (nullmailer pid 1544109 invoked by uid 1000);
        Fri, 10 Mar 2023 14:47:16 -0000
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH] net: Use of_property_present() for testing DT property presence
Date:   Fri, 10 Mar 2023 08:47:16 -0600
Message-Id: <20230310144716.1544083-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is preferred to use typed property access functions (i.e.
of_property_read_<type> functions) rather than low-level
of_get_property/of_find_property functions for reading properties. As
part of this, convert of_get_property/of_find_property calls to the
recently added of_property_present() helper when we just want to test
for presence of a property and nothing more.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/net/mdio/of_mdio.c                            | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 510822d6d0d9..bf10d0688eea 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -131,7 +131,7 @@ bool of_mdiobus_child_is_phy(struct device_node *child)
 		return true;
 	}
 
-	if (!of_find_property(child, "compatible", NULL))
+	if (!of_property_present(child, "compatible"))
 		return true;
 
 	return false;
@@ -203,7 +203,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	/* auto scan for PHYs with empty reg property */
 	for_each_available_child_of_node(np, child) {
 		/* Skip PHYs with reg property set */
-		if (of_find_property(child, "reg", NULL))
+		if (of_property_present(child, "reg"))
 			continue;
 
 		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index fdd0c9abc1a1..e62f880fdde7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -122,7 +122,7 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 		sdio->drive_strength = val;
 
 	/* make sure there are interrupts defined in the node */
-	if (!of_find_property(np, "interrupts", NULL))
+	if (!of_property_present(np, "interrupts"))
 		return;
 
 	irq = irq_of_parse_and_map(np, 0);
-- 
2.39.2

