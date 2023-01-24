Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5876D67A137
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbjAXSiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjAXSiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:38:04 -0500
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9B839BA1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:37:58 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:2f4a:8573:c294:b2ce])
        by xavier.telenet-ops.be with bizsmtp
        id CidZ2900656uRqi01idZDF; Tue, 24 Jan 2023 19:37:56 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAe-007HCL-GZ;
        Tue, 24 Jan 2023 19:37:33 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAm-002n0W-Uv;
        Tue, 24 Jan 2023 19:37:32 +0100
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
Subject: [PATCH treewide v2 0/9] phy: Add devm_of_phy_optional_get() helper
Date:   Tue, 24 Jan 2023 19:37:19 +0100
Message-Id: <cover.1674584626.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
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

	Hi Vinod et al,

While there exist several optional_get() PHY helper functions, there is
no optional variant of devm_of_phy_get(), leading to several drivers
implementing this theirselves, sometimes in buggy ways.

Hence this series, after two cleanup patches, introduces a
devm_of_phy_optional_get() helper(), and converts existing users of
devm_of_phy_get() where appropriate.

Changes compared to v1[1]:
  - Incorporate "[PATCH v2 1/9] phy: Remove unused phy_optional_get()",
    as it touches the same documentation,
  - New patch "[PATCH v2 2/9] doc: phy: Document devm_of_phy_get()",
  - Print an error message in case of failure, as requested by RobH,
  - Update Documentation,
  - Clarify removed checks for -ENODEV and -ENOSYS,
  - Remove error printing in case of real failures from callers,
  - Rebase am65-cpsw change on top of commit 854617f52ab42418 ("net:
    ethernet: ti: am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY") in
    net-next (next-20230123 and later),
  - Add Reviewed-by, Acked-by.

Most of this series been compile-tested only, but the new helper itself
has been tested with a new user[2].

Thanks for your comments!

[1] "[PATCH treewide 0/7] phy: Add devm_of_phy_optional_get() helper"
    https://lore.kernel.org/r/cover.1674036164.git.geert+renesas@glider.be
[2] "[PATCH 12/12] can: rcar_canfd: Add transceiver support"
    https://lore.kernel.org/r/e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be

Geert Uytterhoeven (9):
  phy: Remove unused phy_optional_get()
  doc: phy: Document devm_of_phy_get()
  phy: Add devm_of_phy_optional_get() helper
  net: fman: memac: Convert to devm_of_phy_optional_get()
  net: lan966x: Convert to devm_of_phy_optional_get()
  net: ethernet: ti: am65-cpsw: Convert to devm_of_phy_optional_get()
  PCI: tegra: Convert to devm_of_phy_optional_get()
  usb: host: ehci-exynos: Convert to devm_of_phy_optional_get()
  usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()

 Documentation/driver-api/phy/phy.rst          | 24 +++++----
 .../net/ethernet/freescale/fman/fman_memac.c  |  9 ++--
 .../ethernet/microchip/lan966x/lan966x_main.c |  5 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  8 ++-
 drivers/pci/controller/pci-tegra.c            |  5 +-
 drivers/phy/phy-core.c                        | 51 +++++++++++--------
 drivers/usb/host/ehci-exynos.c                | 23 +++------
 drivers/usb/host/ohci-exynos.c                | 23 +++------
 include/linux/phy/phy.h                       | 16 +++---
 9 files changed, 75 insertions(+), 89 deletions(-)

-- 
2.34.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
