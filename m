Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F0692DA5
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBKDSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBKDSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:18:35 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C83C3D;
        Fri, 10 Feb 2023 19:18:34 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E20ED6602112;
        Sat, 11 Feb 2023 03:18:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085513;
        bh=LNDJxjgOHZY/eKro/BYac5WDP/pGehw2tg2CONtqn2Q=;
        h=From:To:Cc:Subject:Date:From;
        b=HQoyAHzUSYcBTbkOlPiVQHjFJZH8Q1anOFaBK7aWcCdwa+BPuqeNEz8nRgYuf5eLk
         UIXUYdhWbw2EaE2ndJCMAi7y6MYmhmtBhlq/Qhd9AUZP2SgDVG0wEg82H6PnoiIZ/g
         P4/fn/t4P+5HGfszaushNeBZj9U4zxx5Vdt2llPbvTZn9uW5sP9JBlqowgqksLP+jG
         M8vfRqUFzpvwlxEzfVMjp0Fdx4qRzavPAKFKvnlsI9kP8LebVASZD/H3Lv/Fh7Kv9C
         93aOUEQTb1tt0At6R3yXB3CWh7/+5ThDcz9bA/nMujXCyNnz8+Akd2CYdRUgjUGXLS
         Aue/+FZSRQboQ==
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
To:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: [PATCH 00/12] Enable networking support for StarFive JH7100 SoC
Date:   Sat, 11 Feb 2023 05:18:09 +0200
Message-Id: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds ethernet support for the StarFive JH7100 SoC and 
makes it available for the StarFive VisionFive V1 and BeagleV Starlight 
boards, although I could only validate on the former SBC.

The work is heavily based on the reference implementation [1] and requires 
the non-coherent DMA support provided by Emil via the Sifive Composable 
Cache controller.

Also note there is an overlap in "[PATCH 08/12] net: stmmac: Add glue layer 
for StarFive JH7100 SoC" with the Yanhong Wang's upstreaming attempt [2]:
"[PATCH v4 5/7] net: stmmac: Add glue layer for StarFive JH7110 SoCs". 

Since I cannot test the JH7110 SoC, I dropped the support for it from Emil's
variant of the stmmac glue layer. Hence, we might need a bit of coordination
in order to get this properly merged.

[1] https://github.com/starfive-tech/linux/commits/visionfive
[2] https://lore.kernel.org/linux-riscv/20230118061701.30047-6-yanhong.wang@starfivetech.com/

Cristian Ciocaltea (7):
  dt-bindings: riscv: sifive-ccache: Add compatible for StarFive JH7100
    SoC
  dt-bindings: riscv: sifive-ccache: Add 'uncached-offset' property
  dt-bindings: net: Add StarFive JH7100 SoC
  riscv: dts: starfive: Add dma-noncoherent for JH7100 SoC
  riscv: dts: starfive: jh7100: Add ccache DT node
  riscv: dts: starfive: jh7100: Add sysmain and gmac DT nodes
  riscv: dts: starfive: jh7100-common: Setup pinmux and enable gmac

Emil Renner Berthing (5):
  soc: sifive: ccache: Add StarFive JH7100 support
  soc: sifive: ccache: Add non-coherent DMA handling
  riscv: Implement non-coherent DMA support via SiFive cache flushing
  dt-bindings: mfd: syscon: Add StarFive JH7100 sysmain compatible
  net: stmmac: Add glue layer for StarFive JH7100 SoC

 .../devicetree/bindings/mfd/syscon.yaml       |   1 +
 .../devicetree/bindings/net/snps,dwmac.yaml   |  15 +-
 .../bindings/net/starfive,jh7100-dwmac.yaml   | 106 ++++++++++++
 .../bindings/riscv/sifive,ccache0.yaml        |  33 +++-
 MAINTAINERS                                   |   6 +
 arch/riscv/Kconfig                            |   6 +-
 .../boot/dts/starfive/jh7100-common.dtsi      |  78 +++++++++
 arch/riscv/boot/dts/starfive/jh7100.dtsi      |  55 +++++++
 arch/riscv/mm/dma-noncoherent.c               |  37 ++++-
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 155 ++++++++++++++++++
 drivers/soc/sifive/Kconfig                    |   1 +
 drivers/soc/sifive/sifive_ccache.c            |  71 +++++++-
 include/soc/sifive/sifive_ccache.h            |  21 +++
 15 files changed, 587 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7100-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c

-- 
2.39.1

