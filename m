Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDF253EF80
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 22:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiFFUWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 16:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbiFFUWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 16:22:33 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F83A186
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 13:22:31 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u12so31150628eja.8
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 13:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cmCUkZyYqf+fSr+qmDna92LF/wD5Dj/Ah1fbqp/t9Fc=;
        b=X1/fjuqL6gfslDXWoRX9h2iUMDP2o8h40GZNbgq4k2cPA/WIpPN/LIgiyPkBen6+T+
         ik/ftNMZIdrs+WRaYig6cWAECSG9pNA0q6S54xIM+PMpKpS+7Oe7HLk4Y9JHTB8KpdT6
         TS/RlSX6kawniKhAbMEivgVRmpyGX+Npd9HUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cmCUkZyYqf+fSr+qmDna92LF/wD5Dj/Ah1fbqp/t9Fc=;
        b=vKdsAsIrb+YLaRrWdJcsxJCkvohDn7aW/nNAyN0lEyx7mmTAWO7s7CY1bAniZXEIn4
         o5uCth3b/tjOH4L4wB1PB5dcgsn2xOZE8K1Z+SJc3MZGWpZuDVGLZ1sa6EWSHVCvSsIU
         dQ96glDFcVlaobfxQRW7uBGjuQvV4udZlIG3HZ9Vscsa95ppuRAYPvNuHfjhBEPmgFVr
         ks+WWdpsQJ730xp2Tt0dIHNJJVPTNAwVPAtz6xBAs45GZRU4ALUokdzZ9fQHU6VB4GXg
         HW5u48PUQzDRParBghEbqvM2icGlgnlLhmCD178GN+LJToV01yH826rhWQgC5w+JKaKP
         j3gQ==
X-Gm-Message-State: AOAM5304MS9VWX2i4LCB6Rht6qHYqShzj5e71VMbZ8Eaw5sgEMQWbolQ
        zUqt3XZ+mn7pxSBAyjbwJyIZwpUegpKwyQ==
X-Google-Smtp-Source: ABdhPJyB6ulO52fBmOqz/f6uv8gPY4QaiOeSAQEKRaPOA9PwbUcbRDC6JJFKBVnfBl8X5S7F0Tw6xg==
X-Received: by 2002:a17:906:37c6:b0:70c:f9f:f0c5 with SMTP id o6-20020a17090637c600b0070c0f9ff0c5mr19313158ejc.743.1654546950375;
        Mon, 06 Jun 2022 13:22:30 -0700 (PDT)
Received: from prevas-ravi.tritech.se ([80.208.64.233])
        by smtp.gmail.com with ESMTPSA id d20-20020aa7ce14000000b0042dd4ccccf5sm9043789edv.82.2022.06.06.13.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 13:22:30 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] linux/phy.h: add phydev_err_probe() wrapper for dev_err_probe()
Date:   Mon,  6 Jun 2022 22:22:19 +0200
Message-Id: <20220606202220.1670714-3-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_err_probe() function is quite useful to avoid boilerplate
related to -EPROBE_DEFER handling. Add a phydev_err_probe() helper to
simplify making use of that from phy drivers which otherwise use the
phydev_* helpers.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 508f1149665b..bed9a347481b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1539,6 +1539,9 @@ static inline void phy_device_reset(struct phy_device *phydev, int value)
 #define phydev_err(_phydev, format, args...)	\
 	dev_err(&_phydev->mdio.dev, format, ##args)
 
+#define phydev_err_probe(_phydev, err, format, args...)	\
+	dev_err_probe(&_phydev->mdio.dev, err, format, ##args)
+
 #define phydev_info(_phydev, format, args...)	\
 	dev_info(&_phydev->mdio.dev, format, ##args)
 
-- 
2.31.1

