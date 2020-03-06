Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289E417C32E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 17:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCFQko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 11:40:44 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38273 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgCFQko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 11:40:44 -0500
Received: by mail-wr1-f65.google.com with SMTP id t11so3135603wrw.5;
        Fri, 06 Mar 2020 08:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjHnSwyS0af+P6Jfh8Jzg4HPNo9WQiL8yOX1s0HApbQ=;
        b=CbSaDyS3tlGIXzJPDGmj9+AIlYyU7Yowmve6GEk50xA6VmLmZxHH5HW67z5v9akxJN
         nGmqQ1FAjSNx511yM1rus1wIj4/+IgiLa4jFXAq3t+VnZPbcJi2ejnaUkV6b5SKW6kyN
         hzxB5IKSXIbWozwe8M041xvmZrKHB1s6eVUpG+MsHaDJ0Spfb05SAOeiwB8cKCN/Pn2e
         fPhbdTuB2mYwsxcsDnol2mJBRBqcYUpJIndkM4bjmdNdbvdjzaAKHs5iHbBERWAoQ6Ed
         IPbTM3kZsKjUscXO0/PBVdGu+tjOfbi+/lP9+Wz2T8EPTasDaTPRevA4VXyeTR6nXrpn
         tWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjHnSwyS0af+P6Jfh8Jzg4HPNo9WQiL8yOX1s0HApbQ=;
        b=HEHMBh0UYUlIFvTZojR6CHwOCMsQjOW+cbPCURX6XjucphBnqC8TznvHR9u9vAiZRG
         +DT/3acVEwKjw7IiIS/DZtKHuU52z8qr2dS1lfADxTBainjTXzJnTn+pZwEdKmlqySrX
         fqyWOY9+empd3EfgapmgA3tl5Kct0ML55a5VcRv3axKm1U+P18wMVYQ8N5HLwuB7bNv/
         p8uG+fxfzrRdfnqZPIB0gRePPqL7j5n5RPauGjRsJ6Y8UPyOJaoESaxkR6Kk40E5sTtG
         0rvADhpMlC7IHbRanrkDgq0avIxpY4vZ0u/e7Uf7/0/4Uso5rS1AMMiX0qGEBCHcanYD
         1HNA==
X-Gm-Message-State: ANhLgQ3tlARANZPWXha64Il9qcWpSTGzfJV6ejQHYCYCBJIQFsED7k/J
        Y8vI4DEpdIrCVoupn8QAm8Y=
X-Google-Smtp-Source: ADFU+vtU+an94UKd4UPfywLnbr+VHC0wDCwOSaA/3LsprBBI1hOWapF4bBHrYJWtYeuKNmQC60ln8A==
X-Received: by 2002:adf:8162:: with SMTP id 89mr882490wrm.45.1583512841997;
        Fri, 06 Mar 2020 08:40:41 -0800 (PST)
Received: from localhost.localdomain ([2a02:810d:1b40:644:c890:7487:7d:ef6f])
        by smtp.gmail.com with ESMTPSA id c11sm48946421wrp.51.2020.03.06.08.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 08:40:41 -0800 (PST)
From:   Markus Fuchs <mklntf@gmail.com>
To:     mklntf@gmail.com
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: platform: Fix misleading interrupt error msg
Date:   Fri,  6 Mar 2020 17:38:48 +0100
Message-Id: <20200306163848.5910-1-mklntf@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not every stmmac based platform makes use of the eth_wake_irq or eth_lpi
interrupts. Use the platform_get_irq_byname_optional variant for these
interrupts, so no error message is displayed, if they can't be found.
Rather print an information to hint something might be wrong to assist
debugging on platforms which use these interrupts.

Signed-off-by: Markus Fuchs <mklntf@gmail.com>
---
On my cyclone V socfpga platform I get error messages after updating to
Linux Kernel 5.4.24

Starting kernel ...

Deasserting all peripheral resets
[    1.206363] socfpga-dwmac ff700000.ethernet: IRQ eth_wake_irq not found
[    1.213023] socfpga-dwmac ff700000.ethernet: IRQ eth_lpi not found

These interrupts don't matter for my platform and many other stmmac based
ones, as we can see by grepping for 'macirq'.

socfpga.dtsi:                   interrupt-names = "macirq";
socfpga.dtsi:                   interrupt-names = "macirq";
sun7i-a20.dtsi:                 interrupt-names = "macirq";
spear600.dtsi:                  interrupt-names = "macirq", "eth_wake_irq";
artpec6.dtsi:                   interrupt-names = "macirq", "eth_lpi";
rk322x.dtsi:                    interrupt-names = "macirq";
sun9i-a80.dtsi:                 interrupt-names = "macirq";
spear1310.dtsi:                 interrupt-names = "macirq";
spear1310.dtsi:                 interrupt-names = "macirq";
spear1310.dtsi:                 interrupt-names = "macirq";
spear1310.dtsi:                 interrupt-names = "macirq";
stih407-family.dtsi:            interrupt-names = "macirq", "eth_wake_irq";
stm32f429.dtsi:                 interrupt-names = "macirq";
sun6i-a31.dtsi:                 interrupt-names = "macirq";
meson.dtsi:                     interrupt-names = "macirq";
rk3288.dtsi:                    interrupt-names = "macirq", "eth_wake_irq";
sun8i-r40.dtsi:                 interrupt-names = "macirq";
sunxi-h3-h5.dtsi:               interrupt-names = "macirq";
spear3xx.dtsi:                  interrupt-names = "macirq", "eth_wake_irq";
lpc18xx.dtsi:                   interrupt-names = "macirq";
stm32h743.dtsi:                 interrupt-names = "macirq";
socfpga_arria10.dtsi:           interrupt-names = "macirq";
socfpga_arria10.dtsi:           interrupt-names = "macirq";
socfpga_arria10.dtsi:           interrupt-names = "macirq";
rv1108.dtsi:                    interrupt-names = "macirq", "eth_wake_irq";
spear13xx.dtsi:                 interrupt-names = "macirq", "eth_wake_irq";
stm32mp151.dtsi:                interrupt-names = "macirq";
ox820.dtsi:                     interrupt-names = "macirq", "eth_wake_irq";
sun8i-a83t.dtsi:                interrupt-names = "macirq";

So, in my opinion, the error messages are missleading. I believe
the right way to handle this would require more changes though. Some
kind of configuration information, telling which interrupts are required
by the platform and than conditionally call platform_get_irq_byname().
This would print an error message, if something is wrong, on the right
platforms and nothing at all on the others.

.../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index d10ac54bf385..13fafd905db8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -663,16 +663,22 @@ int stmmac_get_platform_resources(struct platform_device *pdev,
 	 * In case the wake up interrupt is not passed from the platform
 	 * so the driver will continue to use the mac irq (ndev->irq)
 	 */
-	stmmac_res->wol_irq = platform_get_irq_byname(pdev, "eth_wake_irq");
+	stmmac_res->wol_irq =
+		platform_get_irq_byname_optional(pdev, "eth_wake_irq");
 	if (stmmac_res->wol_irq < 0) {
 		if (stmmac_res->wol_irq == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
+		dev_info(&pdev->dev, "IRQ eth_wake_irq not found\n");
 		stmmac_res->wol_irq = stmmac_res->irq;
 	}
 
-	stmmac_res->lpi_irq = platform_get_irq_byname(pdev, "eth_lpi");
-	if (stmmac_res->lpi_irq == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	stmmac_res->lpi_irq =
+		platform_get_irq_byname_optional(pdev, "eth_lpi");
+	if (stmmac_res->lpi_irq < 0) {
+		if (stmmac_res->lpi_irq == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		dev_info(&pdev->dev, "IRQ eth_lpi not found\n");
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	stmmac_res->addr = devm_ioremap_resource(&pdev->dev, res);
-- 
2.25.1

