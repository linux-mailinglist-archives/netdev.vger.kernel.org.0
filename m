Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796CD67A14C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbjAXSiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbjAXSiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:38:07 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D007A457F6
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:37:58 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:2f4a:8573:c294:b2ce])
        by laurent.telenet-ops.be with bizsmtp
        id CidZ2900K56uRqi01idZ2h; Tue, 24 Jan 2023 19:37:55 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAe-007HCs-OB;
        Tue, 24 Jan 2023 19:37:33 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAn-002n1A-8j;
        Tue, 24 Jan 2023 19:37:33 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
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
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-phy@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 9/9] usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()
Date:   Tue, 24 Jan 2023 19:37:28 +0100
Message-Id: <3adc5dd1149a17ea7daf4463549feab886c6b145.1674584626.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674584626.git.geert+renesas@glider.be>
References: <cover.1674584626.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new devm_of_phy_optional_get() helper instead of open-coding the
same operation.

As devm_of_phy_optional_get() returns NULL if either the PHY cannot be
found, or if support for the PHY framework is not enabled, it is no
longer needed to check for -ENODEV or -ENOSYS.

This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
handle NULL parameters fine.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
v2:
  - Add Acked-by,
  - Clarify removed checks for -ENODEV and -ENOSYS,
  - Remove error printing in case of real failures.
---
 drivers/usb/host/ohci-exynos.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 8d7977fd5d3bd502..8af17c1ee5cc8f1e 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -69,19 +69,11 @@ static int exynos_ohci_get_phy(struct device *dev,
 			return -EINVAL;
 		}
 
-		phy = devm_of_phy_get(dev, child, NULL);
+		phy = devm_of_phy_optional_get(dev, child, NULL);
 		exynos_ohci->phy[phy_number] = phy;
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
+			return PTR_ERR(phy);
 		}
 	}
 
@@ -97,12 +89,10 @@ static int exynos_ohci_phy_enable(struct device *dev)
 	int ret = 0;
 
 	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ohci->phy[i]))
-			ret = phy_power_on(exynos_ohci->phy[i]);
+		ret = phy_power_on(exynos_ohci->phy[i]);
 	if (ret)
 		for (i--; i >= 0; i--)
-			if (!IS_ERR(exynos_ohci->phy[i]))
-				phy_power_off(exynos_ohci->phy[i]);
+			phy_power_off(exynos_ohci->phy[i]);
 
 	return ret;
 }
@@ -114,8 +104,7 @@ static void exynos_ohci_phy_disable(struct device *dev)
 	int i;
 
 	for (i = 0; i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ohci->phy[i]))
-			phy_power_off(exynos_ohci->phy[i]);
+		phy_power_off(exynos_ohci->phy[i]);
 }
 
 static int exynos_ohci_probe(struct platform_device *pdev)
-- 
2.34.1

