Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53170FC4FC
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKNLDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:03:10 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34660 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKNLDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:03:01 -0500
Received: by mail-lj1-f193.google.com with SMTP id 139so6204916ljf.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 03:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jb+MOMLuIdaHgEwx11sXFvRMBqWhHSyGkvnIDPsupdw=;
        b=WOUcLW3G2Iayeuu5sPm24T439/72x+v6kvdOeZ3yyOFnInpWwaMAAiMlvEh+zz1v99
         KB41QGiNZmpNupPI2zSDjYAUMw+jOuNTtO6FDm4F9YE1ldnhegAL+Omp0xYCregSGy+S
         Zq9g75zHJ0vatkL7Y7LxTzPd5/s0ZaJslKRZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jb+MOMLuIdaHgEwx11sXFvRMBqWhHSyGkvnIDPsupdw=;
        b=alx8NrRnq5lGYS6dd4oTe/zS2re5EdKTTXp/NVOxmyUvpvlTvdr+zxydKr31URaZTA
         0xWn6Yp3A/GNm5AMSXD5Sd8SD5xjAEEwLqsNydlNxa+eoYYvgmnW6Ncc+z7nOi37ICmw
         NQv9V/G4627aiiDRHu16X6p7Mt3GMnMsH8Lf3XI58IINk1qd8W9/6PEKpf8mWVcvye3G
         wyKeOXBNxDT6mxfOviujqxav+3gvc0gc5Z7L8oD2H6zc0wRwXJckdLOhpimXpfCkNyOY
         M0Lk1JgaHKKzPHfLRcKbyfMiWbKimR2kCEp849hy+2V8p+qtI0TXuVv2GsoOSRS8sKTz
         XkxQ==
X-Gm-Message-State: APjAAAXi6ezST68lMd9Z2al9p5L+VY4mHcX3XcEXhS2D/cjXxI5T/Jdm
        KAX+B4fSK9baWeCg6DBt8Rl2Bg==
X-Google-Smtp-Source: APXvYqyjNPi9tG3t/0IsBhpN6J0yN3A7dgHIGn4FZvEHTpjYDUeeXcxIhq+h6bgnCPrbA2iTYR8Fgw==
X-Received: by 2002:a2e:7307:: with SMTP id o7mr6253561ljc.10.1573729379406;
        Thu, 14 Nov 2019 03:02:59 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id x5sm2498795lfg.71.2019.11.14.03.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 03:02:59 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Marc Zyngier <maz@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
Date:   Thu, 14 Nov 2019 12:02:53 +0100
Message-Id: <20191114110254.32171-3-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
References: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
have interrupt lines connected to the shared IRQ2_B LS1021A pin.

Switching to interrupts offloads the PHY library from the task of
polling the MDIO status and AN registers (1, 4, 5) every second.

Unfortunately, the BCM5464R quad PHY connected to the switch does not
appear to have an interrupt line routed to the SoC.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 5b7689094b70..9d8f0c2a8aba 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -203,11 +203,15 @@
 	/* AR8031 */
 	sgmii_phy1: ethernet-phy@1 {
 		reg = <0x1>;
+		/* SGMII1_PHY_INT_B: connected to IRQ2, active low */
+		interrupts-extended = <&extirq 2 IRQ_TYPE_LEVEL_LOW>;
 	};
 
 	/* AR8031 */
 	sgmii_phy2: ethernet-phy@2 {
 		reg = <0x2>;
+		/* SGMII2_PHY_INT_B: connected to IRQ2, active low */
+		interrupts-extended = <&extirq 2 IRQ_TYPE_LEVEL_LOW>;
 	};
 
 	/* BCM5464 quad PHY */
-- 
2.23.0

