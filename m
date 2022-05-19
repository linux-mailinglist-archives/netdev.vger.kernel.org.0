Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D9652DCAB
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243195AbiESSY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242656AbiESSY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:24:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DDD93995
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:24:27 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j25so8324516wrc.9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0zXiDiE6F3yYGhahJvZZTWKFFsEbzGr9QORv3wWtDJQ=;
        b=V8wIWjQy0gnRJ9VHvwB+urOZ0vIubT+3rhYgmm5p2O881Y+q62VYVuLxSOO2d8HzKo
         dgi+Z2Q+pTPSMW7/OU2S8ysoHBOfvYhpdb/8CxJs/2JEUl/QO7JY7ZYu4azf2DKFFgvP
         9omkOKGItCBP63Bp7QYszAGr8vt/UYwlfri9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0zXiDiE6F3yYGhahJvZZTWKFFsEbzGr9QORv3wWtDJQ=;
        b=PeMD8RprAsrPTt7txBn1EI3TdRXGB+UPFyya/JYOTmv8AZXR/Q/omabIOWk6HgP2C2
         6YNv/dXT4oXC2buv2z8Vbinqb2q3SpPctZIIdNlUsPIwdW1x7oE14U+mY30+tPGtRASZ
         JS1tlSwJ1U2DHJPn98MKDpNET2qflPzbpMFkw0kbVUqDUhrqYFG21px5cYqMP8dRC8YT
         cpHnLS3gEU/g87E4kgck9AeWmipt6eOHf8ALQWBa2gDcubWSqEOZP85YrSsKJhxHVJG8
         B7H9SqdCUuqyh6HI5JLvGjXlv6JPTaB7gpUlVvHYYxi49cBbJB61vM50NdXPdGiGtXmg
         VqXQ==
X-Gm-Message-State: AOAM530AOFK44CeW8VT+VVPNgJ4e9Z1dLd2cTg0EwKva6EM2spmjzUDS
        +jDNCW7AGjJ9W6goim3I+C9BIG9DszbeMg==
X-Google-Smtp-Source: ABdhPJyxkl0D4C71ONRFHsez4klPGUACYyG/JPCSQKzy7QiwGL+Wl1vK/I4QBqbK3IDiKlfzyYoMow==
X-Received: by 2002:a5d:5888:0:b0:20d:270f:6b61 with SMTP id n8-20020a5d5888000000b0020d270f6b61mr5133314wrf.211.1652984666107;
        Thu, 19 May 2022 11:24:26 -0700 (PDT)
Received: from tom-ThinkPad-T14s-Gen-2i.station (net-188-217-53-154.cust.vodafonedsl.it. [188.217.53.154])
        by smtp.gmail.com with ESMTPSA id y7-20020a05600c17c700b003942a244f45sm183796wmo.30.2022.05.19.11.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:24:25 -0700 (PDT)
From:   Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Cc:     tommaso.merciai@amarulasolutions.com,
        alberto.bianchi@amarulasolutions.com, michael@amarulasolutions.com,
        linuxfancy@googlegroups.com, linux-amarula@amarulasolutions.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: DP83822: enable rgmii mode if phy_interface_is_rgmii
Date:   Thu, 19 May 2022 20:24:23 +0200
Message-Id: <20220519182423.1554379-1-tommaso.merciai@amarulasolutions.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGMII mode can be enable from dp83822 straps, and also writing bit 9
of register 0x17 - RMII and Status Register (RCSR).
When phy_interface_is_rgmii this mode must be enabled

References:
 - https://www.ti.com/lit/gpn/dp83822i p66

Signed-off-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Suggested-by: Alberto Bianchi <alberto.bianchi@amarulasolutions.com>
Tested-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
---
 drivers/net/phy/dp83822.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index ce17b2af3218..66fa61fb86db 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -408,6 +408,10 @@ static int dp83822_config_init(struct phy_device *phydev)
 			if (err)
 				return err;
 		}
+
+		/* Enable RGMII Mode */
+		phy_set_bits_mmd(phydev, DP83822_DEVADDR,
+					MII_DP83822_RCSR, BIT(9));
 	}
 
 	if (dp83822->fx_enabled) {
-- 
2.25.1

