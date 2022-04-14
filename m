Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA42500D47
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbiDNM1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242759AbiDNM1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:14 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED332CE18;
        Thu, 14 Apr 2022 05:24:43 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 975D840012;
        Thu, 14 Apr 2022 12:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZQJox6pfPHfC3qb+4Dol20vx3ou4eYt1gnOvwZ6wUI=;
        b=dhPtZSrAX6XBgNQiE5qpr4/oCiYzDuW+OW9z1Al3KuEWRBFR5NXP5hYiuDxDzZDHnD/mCo
        odGU725IrYUzzY1pFgYrZaZtGNhkdWHbcS4ePfu31ZZHfXgUJSYU1WqI8itvCR+n5WcfjK
        wwYSikUU4HfsFbkNfn4dUcA/yvYYlkSpdqCF3yP7GFjTsBDdqBFfV0WcSI/fgQ55wWKRbJ
        CVdZRsdtMtgEp8Ukcrb4zRdgF+8cT0k4mtOSoggIXVGtQahPXdmJVrMqXA6WAPawIWmmbn
        BGSAUPPtmHRRHiLfYKgzAne9VTMr15HCKH6eJKwYnQMUhXUOqGfWJkIraZvQLg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 01/12] net: dsa: add support for Renesas RZ/N1 A5PSW switch tag code
Date:   Thu, 14 Apr 2022 14:22:39 +0200
Message-Id: <20220414122250.158113-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414122250.158113-1-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DSA tag code for Renesas RZ/N1 Advanced 5 port switch. This switch
uses a special VLAN type followed by 6 bytes which contains other
useful information (port, timestamp, etc).

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 include/net/dsa.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 934958fda962..2aa8eaae4eb9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -53,6 +53,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_SJA1110_VALUE		23
 #define DSA_TAG_PROTO_RTL8_4_VALUE		24
 #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
+#define DSA_TAG_PROTO_RZN1_A5PSW_VALUE		26
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -81,6 +82,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
 	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
+	DSA_TAG_PROTO_RZN1_A5PSW	= DSA_TAG_PROTO_RZN1_A5PSW_VALUE,
 };
 
 struct dsa_switch;
-- 
2.34.1

