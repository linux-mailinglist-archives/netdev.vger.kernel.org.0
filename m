Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D72567A156
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjAXSiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbjAXSiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:38:09 -0500
Received: from weierstrass.telenet-ops.be (weierstrass.telenet-ops.be [IPv6:2a02:1800:110:4::f00:11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A18342BC8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:38:00 -0800 (PST)
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by weierstrass.telenet-ops.be (Postfix) with ESMTPS id 4P1bLt3hXdz4xMLw
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 19:37:58 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:2f4a:8573:c294:b2ce])
        by michel.telenet-ops.be with bizsmtp
        id CidZ2900556uRqi06idZyA; Tue, 24 Jan 2023 19:37:58 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAe-007HCY-JX;
        Tue, 24 Jan 2023 19:37:33 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAn-002n0l-3x;
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
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 4/9] net: fman: memac: Convert to devm_of_phy_optional_get()
Date:   Tue, 24 Jan 2023 19:37:23 +0100
Message-Id: <f2d801cd73cca36a7162819289480d7fc91fcc7e.1674584626.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674584626.git.geert+renesas@glider.be>
References: <cover.1674584626.git.geert+renesas@glider.be>
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

As devm_of_phy_optional_get() returns NULL if either the PHY cannot be
found, or if support for the PHY framework is not enabled, it is no
longer needed to check for -ENODEV or -ENOSYS.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
---
v2:
  - Add Reviewed-by,
  - Clarify removed checks for -ENODEV and -ENOSYS,
  - Remove error printing in case of real failures.
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 9349f841bd0645a0..ddd9d13f1166e120 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1152,13 +1152,12 @@ int memac_initialization(struct mac_device *mac_dev,
 	else
 		memac->sgmii_pcs = pcs;
 
-	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
-	err = PTR_ERR(memac->serdes);
-	if (err == -ENODEV || err == -ENOSYS) {
+	memac->serdes = devm_of_phy_optional_get(mac_dev->dev, mac_node,
+						 "serdes");
+	if (!memac->serdes) {
 		dev_dbg(mac_dev->dev, "could not get (optional) serdes\n");
-		memac->serdes = NULL;
 	} else if (IS_ERR(memac->serdes)) {
-		dev_err_probe(mac_dev->dev, err, "could not get serdes\n");
+		err = PTR_ERR(memac->serdes);
 		goto _return_fm_mac_free;
 	}
 
-- 
2.34.1

