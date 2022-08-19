Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861B45998C7
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347478AbiHSJ0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348149AbiHSJ0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:26:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9769EF43AC;
        Fri, 19 Aug 2022 02:26:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id jl18so3674123plb.1;
        Fri, 19 Aug 2022 02:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc;
        bh=CY0i8QDQ2vMQNk28GilQevsgpB2jxQ4GU9BTJPqju0A=;
        b=V6VES/pqGZOotRcLtKIhAnYf7veaonsx2TJtUMdgIRxpOaUvBhyStlwTTN26Se75si
         I/lXTlcucawVRBqonOpdH5uv6nMJp1qPfxzn6dUSImpnOE4uq2DRgYH/xuMFoVNfGWU7
         0S+w+0Fiu7JWM4piIHf7Lznwcq85h6KLyVveLJXeeqMqAzWgx5OxvDvAkj6DYeZe08hX
         H+raLrv395kelnjQoonzodMzo35teDgNhd8RJUvy5HQTwJ8quBBciLszY6qcSJFbVf53
         a5e7+c6zNR04u9QEvamnmpz/em5devLzzktLfV2aw4+ZEjMCd472Y97F1C3xaXbtVrgB
         3KEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc;
        bh=CY0i8QDQ2vMQNk28GilQevsgpB2jxQ4GU9BTJPqju0A=;
        b=oxC5iH6taHQPNCk5CFxT/v3bu/BIUeAuIm4+pFFdXaaqKYV1S856NsyvNXTH9YPzRl
         vBYrpkpoz/bLx8ieQG95ZvRj4gupxro1pu/eCN609oaRc1cjn6+jbmMvjKinL+zoc9gq
         Ojb8deiM0WIaAPTbyL1oY32qASCrOrTCp2L1FfoSKPuM4A+wAp4hP1yIi44JKd2hcZ4K
         sJJxEcN+bOi7Vts04hrlTQFY2n4q0LPrdxFr+wcyqN7c/GC6gycN7OjoLll/C83Ayoy/
         krrCz87you1dCnMo3LqG0rV0vKf5DLfTupKmR1cJHsO7KwZb99MlkQ2+lOViWjJ1iBs8
         Dk6g==
X-Gm-Message-State: ACgBeo2dsBMW6dPqf0lN9BcY0xMrLypjrE8j8mE/dzvgBUEFnSlkiRXT
        qpqnnp0uErwIUVqWStSMioUV6XQFp0i2DlD2vEM=
X-Google-Smtp-Source: AA6agR6CaacXLaiXjbr51gDGZPJLXr0bmzyMubFLsYlgmuOvIISNjqeh2W9NA8BvP7ITEYy0ZiulAw==
X-Received: by 2002:a17:90a:2eca:b0:1fa:a687:cfd9 with SMTP id h10-20020a17090a2eca00b001faa687cfd9mr13353735pjs.78.1660901181102;
        Fri, 19 Aug 2022 02:26:21 -0700 (PDT)
Received: from localhost.localdomain ([104.28.240.138])
        by smtp.gmail.com with ESMTPSA id n12-20020a170903110c00b001709e3c755fsm2759533plh.230.2022.08.19.02.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 02:26:20 -0700 (PDT)
From:   Qingfang DENG <dqfext@gmail.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: phylink: allow RGMII/RTBI in-band status
Date:   Fri, 19 Aug 2022 17:26:06 +0800
Message-Id: <20220819092607.2628716-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.34.1
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

As per RGMII specification v2.0, section 3.4.1, RGMII/RTBI has an
optional in-band status feature where the PHY's link status, speed and
duplex mode can be passed to the MAC.
Allow RGMII/RTBI to use in-band status.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
---
 drivers/net/phy/phylink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..57186d322835 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -632,6 +632,11 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
 		case PHY_INTERFACE_MODE_QSGMII:
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+		case PHY_INTERFACE_MODE_RTBI:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
-- 
2.34.1

