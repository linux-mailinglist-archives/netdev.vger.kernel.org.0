Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BCB54AC69
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbiFNIqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355873AbiFNIqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:46:25 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2786434B2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:20 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 20so12779207lfz.8
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cmCUkZyYqf+fSr+qmDna92LF/wD5Dj/Ah1fbqp/t9Fc=;
        b=Lhk2HAruK6blf2W2bSttgu1d3q5FpOqeHtDxEokN5BstejeSqf7oKTZJqKzbbEhyce
         YMleKqWyPKI0c2R9KA2xZc6Br0LmeyolK1HHT2x2roKGKKLBx1R0Idq/Eq+60YZ6uPSM
         v+/ciSTtW7Tyb18KJq3p0Mx3YpseXHWSDPyxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cmCUkZyYqf+fSr+qmDna92LF/wD5Dj/Ah1fbqp/t9Fc=;
        b=OLXMJaNaFSKcl+YlNBlzj1zH4mWqfDtGy1OSpfhm5OSkfdDA23+p/nL5/ulpoOPfYn
         HAJV5olz+S1upcKq8xNO0M/AYiHnrghS6MiOQrxLRWJMPSdpZEMPZHqULA7qILG2xiOs
         52wlTs76048ZK73/BHtvPcq5QOGv5/5I8w9l9K1KAWYqVcS0Fw1vmLWDdxkCLYTIW2YL
         VA48pefY/TXUTTtppWPt7qHc0h/tE5EhJ0ci9M7C44NI91/NEFCQyQZrHYHNuGjlV4sD
         V5pRSzQOhTgpMjA5kQLukiHWy687lADTXmcAl/9/sD9R+e6gOjkK687O9lF3MTgO5Fom
         jLVg==
X-Gm-Message-State: AOAM532BEUuHuCXtHAlvjXeVgKEFX8fooPlxpghSGVFN+Y75VYMMoQ7v
        uxmt40NN2hE2s6x/b5oJfDHO/NPYFlhon7Mn
X-Google-Smtp-Source: AGRyM1tnVrDoaAyRb7zBWF5L0aoS5WCry23V8yDCUItYQSOXYDQhQDayc83GCERdmZO4XMcgqES6Rw==
X-Received: by 2002:a05:6512:31c5:b0:479:47a1:2024 with SMTP id j5-20020a05651231c500b0047947a12024mr2407749lfe.420.1655196378944;
        Tue, 14 Jun 2022 01:46:18 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id g1-20020ac24d81000000b0047255d2118fsm1306116lfe.190.2022.06.14.01.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:46:18 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH net-next v2 2/3] linux/phy.h: add phydev_err_probe() wrapper for dev_err_probe()
Date:   Tue, 14 Jun 2022 10:46:11 +0200
Message-Id: <20220614084612.325229-3-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220614084612.325229-1-linux@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
 <20220614084612.325229-1-linux@rasmusvillemoes.dk>
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

