Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A8671A45
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjARLQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjARLQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:16:13 -0500
Received: from riemann.telenet-ops.be (riemann.telenet-ops.be [IPv6:2a02:1800:110:4::f00:10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EB57F997
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:29:31 -0800 (PST)
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by riemann.telenet-ops.be (Postfix) with ESMTPS id 4Nxhd70Rt1z4xgD5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 11:21:47 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:4745:2e6d:e3a6:3327])
        by xavier.telenet-ops.be with bizsmtp
        id AAFN290092zf9gW01AFNxV; Wed, 18 Jan 2023 11:15:42 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pI5TQ-005aIh-PT;
        Wed, 18 Jan 2023 11:15:22 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pI5TW-001JW3-3f;
        Wed, 18 Jan 2023 11:15:22 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6/7] usb: host: ehci-exynos: Convert to devm_of_phy_optional_get()
Date:   Wed, 18 Jan 2023 11:15:19 +0100
Message-Id: <96fce347ffa2d6efaa3fd24bf2d91e2a0a91c371.1674036164.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674036164.git.geert+renesas@glider.be>
References: <cover.1674036164.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new devm_of_phy_optional_get() helper instead of open-coding the
same operation.

This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
handle NULL parameters fine.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/usb/host/ehci-exynos.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index a333231616f437b8..0f8d7df4937b2da4 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -80,19 +80,12 @@ static int exynos_ehci_get_phy(struct device *dev,
 			return -EINVAL;
 		}
 
-		phy = devm_of_phy_get(dev, child, NULL);
+		phy = devm_of_phy_optional_get(dev, child, NULL);
 		exynos_ehci->phy[phy_number] = phy;
 		if (IS_ERR(phy)) {
-			ret = PTR_ERR(phy);
-			if (ret == -EPROBE_DEFER) {
-				of_node_put(child);
-				return ret;
-			} else if (ret != -ENOSYS && ret != -ENODEV) {
-				dev_err(dev,
-					"Error retrieving usb2 phy: %d\n", ret);
-				of_node_put(child);
-				return ret;
-			}
+			of_node_put(child);
+			return dev_err_probe(dev, PTR_ERR(phy),
+					     "Error retrieving usb2 phy\n");
 		}
 	}
 
@@ -108,12 +101,10 @@ static int exynos_ehci_phy_enable(struct device *dev)
 	int ret = 0;
 
 	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ehci->phy[i]))
-			ret = phy_power_on(exynos_ehci->phy[i]);
+		ret = phy_power_on(exynos_ehci->phy[i]);
 	if (ret)
 		for (i--; i >= 0; i--)
-			if (!IS_ERR(exynos_ehci->phy[i]))
-				phy_power_off(exynos_ehci->phy[i]);
+			phy_power_off(exynos_ehci->phy[i]);
 
 	return ret;
 }
@@ -125,8 +116,7 @@ static void exynos_ehci_phy_disable(struct device *dev)
 	int i;
 
 	for (i = 0; i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ehci->phy[i]))
-			phy_power_off(exynos_ehci->phy[i]);
+		phy_power_off(exynos_ehci->phy[i]);
 }
 
 static void exynos_setup_vbus_gpio(struct device *dev)
-- 
2.34.1

