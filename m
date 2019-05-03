Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98513080
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfECOfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:35:17 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:17089 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfECOfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 10:35:16 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 52D994AD8;
        Fri,  3 May 2019 16:27:50 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 58992be4;
        Fri, 3 May 2019 16:27:48 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/10] ARM: Kirkwood: support of_get_mac_address new ERR_PTR error
Date:   Fri,  3 May 2019 16:27:14 +0200
Message-Id: <1556893635-18549-10-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556893635-18549-1-git-send-email-ynezz@true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was NVMEM support added to of_get_mac_address, so it could now return
ERR_PTR encoded error values, so we need to adjust all current users of
of_get_mac_address to this new fact.

Signed-off-by: Petr Štetiar <ynezz@true.cz>
---

 Changes since v3:

  * IS_ERR_OR_NULL -> IS_ERR

 arch/arm/mach-mvebu/kirkwood.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-mvebu/kirkwood.c b/arch/arm/mach-mvebu/kirkwood.c
index 0aa8810..9b5f4d6 100644
--- a/arch/arm/mach-mvebu/kirkwood.c
+++ b/arch/arm/mach-mvebu/kirkwood.c
@@ -92,7 +92,8 @@ static void __init kirkwood_dt_eth_fixup(void)
 			continue;
 
 		/* skip disabled nodes or nodes with valid MAC address*/
-		if (!of_device_is_available(pnp) || of_get_mac_address(np))
+		if (!of_device_is_available(pnp) ||
+		    !IS_ERR(of_get_mac_address(np)))
 			goto eth_fixup_skip;
 
 		clk = of_clk_get(pnp, 0);
-- 
1.9.1

