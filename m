Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A92F5E90
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 11:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKIK5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 05:57:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34062 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfKIK47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 05:56:59 -0500
Received: by mail-wm1-f68.google.com with SMTP id v3so9172406wmh.1;
        Sat, 09 Nov 2019 02:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JHLfdo8EDYpxKc5h1UVzYd5rkwgO5xInaju1os9b+ho=;
        b=SfmDrMNFhZrsAWXRX9Nk5Koc/lkJ6XYxu32hCyrsCin2aAcMyn0oie0m+oobQbQ74W
         9YhqazEroPzLtEjVmTQD7BcMEaaaXl795pYJp9bme3oBttWkPqXjrm9SE43wmJDyFu11
         o1VT3TOucgjsyqvcDOwOVZWq3C5Wu21rNAmN4vCC/fYG8MbRGMhMZYs4EZKa2OWO2o2q
         F7jhzABV386Zk9F4v4LFklNGpqqE7GUs/55ny5MeUh8ABfp85taeVVfAdskUG8+53NZ0
         RtGWo1z1VPJB5JoCJ4N25e3toiXE0LjsNte7cSPp4tX5oTFuFFGiUfGXsboDvYYDGuBo
         ITKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JHLfdo8EDYpxKc5h1UVzYd5rkwgO5xInaju1os9b+ho=;
        b=nMRco2rPBf1vDw5xYAKKDAW3snMBpXJFJzeTSE43EjALWI1qF5fLqcjf5b0gwbar4U
         CwqkoLpIb+cbygheZLVVwvopCq8xLTl2MzIbJz/GgHJVZ0bzZtN1LecIxLmO2cXfiNKY
         vxqxeAsUiiWbiZcTPPwu8pjTnWCi+mf1Z/YXfPAZ/fhT5lxl7mttk0KMk+cz2MUA5qeB
         Z2ucJgkUPQD4bbJfmwaJLBcEzEwkMJAazYtA4NAwtRFz8k+qP66aXqDoYNmJqxWKFkhz
         CEEC7OPBe0FZN2YJIPjAVHPYYd+TtxP9hHv0S55fVM4MnU3LB1grEt/xmjeA3rs+bX1V
         nzjQ==
X-Gm-Message-State: APjAAAWEaOsfZlZn7TcXjYQK9tmqCvdyOQLLlQVdjuNHXSru2x0Ahsaa
        nRglxZWfvRfwtdej2bOYUWQ=
X-Google-Smtp-Source: APXvYqxhXAZg/XDWVA2jUZjEBESbC0l9FJaojQQtz3TAEVdRDHSDneX5AN2Bqc3wy8oUC8OTUHaU8A==
X-Received: by 2002:a1c:6146:: with SMTP id v67mr12605556wmb.102.1573297017263;
        Sat, 09 Nov 2019 02:56:57 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id l10sm14846296wrg.90.2019.11.09.02.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 02:56:56 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
Date:   Sat,  9 Nov 2019 12:56:42 +0200
Message-Id: <20191109105642.30700-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
have interrupt lines connected to the shared IRQ2_B LS1021A pin.

The interrupts are active low, but the GICv2 controller does not support
active-low and falling-edge interrupts, so the only mode it can be
configured in is rising-edge.

The interrupt number was obtained by subtracting 32 from the listed
interrupt ID from LS1021ARM.pdf Table 5-1. Interrupt assignments.

Switching to interrupts offloads the PHY library from the task of
polling the MDIO status and AN registers (1, 4, 5) every second.

Unfortunately, the BCM5464R quad PHY connected to the switch does not
appear to have an interrupt line routed to the SoC.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 5b7689094b70..4532b2bd3fd1 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -203,11 +203,15 @@
 	/* AR8031 */
 	sgmii_phy1: ethernet-phy@1 {
 		reg = <0x1>;
+		/* SGMII1_PHY_INT_B: connected to IRQ2, active low */
+		interrupts = <GIC_SPI 165 IRQ_TYPE_EDGE_RISING>;
 	};
 
 	/* AR8031 */
 	sgmii_phy2: ethernet-phy@2 {
 		reg = <0x2>;
+		/* SGMII2_PHY_INT_B: connected to IRQ2, active low */
+		interrupts = <GIC_SPI 165 IRQ_TYPE_EDGE_RISING>;
 	};
 
 	/* BCM5464 quad PHY */
-- 
2.17.1

