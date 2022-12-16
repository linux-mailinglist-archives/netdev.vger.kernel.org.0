Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA864E78D
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 08:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiLPHF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 02:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLPHFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 02:05:48 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3EEE26;
        Thu, 15 Dec 2022 23:05:44 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 1207324E345;
        Fri, 16 Dec 2022 15:05:38 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 15:05:38 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX173.cuchost.com (172.16.6.93) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 16 Dec 2022 15:05:36 +0800
From:   Yanhong Wang <yanhong.wang@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v2 0/9] Add Ethernet driver for StarFive JH7110 SoC
Date:   Fri, 16 Dec 2022 15:06:23 +0800
Message-ID: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds ethernet support for the StarFive JH7110 RISC-V SoC.
The series includes PHY and MAC drivers. The PHY model is
YT8531 (from Motorcomm Inc), and the MAC version is dwmac-5.20
(from Synopsys DesignWare). For more information and support,
you can visit RVspace wiki[1].
	
This patchset should be applied after the patchset [2], [3], [4].

[1] https://wiki.rvspace.org/
[2] https://lore.kernel.org/all/20221118010627.70576-1-hal.feng@starfivetech.com/
[3] https://lore.kernel.org/all/20221118011108.70715-1-hal.feng@starfivetech.com/
[4] https://lore.kernel.org/all/20221118011714.70877-1-hal.feng@starfivetech.com/

Changes in v2:
- Recovered the author of the 1st and 3rd patches back to Emil Renner Berthing.
- Added a new patch to update maxitems number of resets property in 'snps,dwmac.yaml'.
- Fixed the check errors reported by "make dt_binding_check".
- Renamed the dt-binding 'starfive,dwmac-plat.yaml' to 'starfive,jh71x0-dwmac.yaml'.
- Updated the example context in the dt-binding 'starfive,jh71x0-dwmac.yaml'.
- Added new dt-binding 'motorcomm,yt8531.yaml' to describe details of phy clock
  delay configuration parameters.
- Added more comments for PHY driver setting. For more details, see
  'motorcomm,yt8531.yaml'.
- Moved mdio device tree node from 'jh7110-starfive-visionfive-v2.dts' to 'jh7110.dtsi'.
- Re-worded the commit message of several patches.
- Renamed all the functions with starfive_eth_plat prefix in 'dwmac-starfive-plat.c'.
- Added "starfive,jh7100-dwmac" compatible string and special init to support JH7100.

v1: https://patchwork.kernel.org/project/linux-riscv/patch/20221201090242.2381-8-yanhong.wang@starfivetech.com/

Emil Renner Berthing (2):
  dt-bindings: net: snps,dwmac: Add dwmac-5.20 version
  net: stmmac: platform: Add snps,dwmac-5.20 IP compatible string

Yanhong Wang (7):
  dt-bindings: net: snps,dwmac: Update the maxitems number of resets and
    reset-names
  dt-bindings: net: Add bindings for StarFive dwmac
  dt-bindings: net: motorcomm: add support for Motorcomm YT8531
  net: phy: motorcomm: Add YT8531 phy support
  net: stmmac: Add glue layer for StarFive JH71x0 SoCs
  riscv: dts: starfive: jh7110: Add ethernet device node
  riscv: dts: starfive: visionfive-v2: Add phy clock delay train
    configuration

 .../bindings/net/motorcomm,yt8531.yaml        | 111 ++++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   |  20 +-
 .../bindings/net/starfive,jh71x0-dwmac.yaml   | 103 +++++++++
 MAINTAINERS                                   |   7 +
 .../jh7110-starfive-visionfive-v2.dts         |  28 +++
 arch/riscv/boot/dts/starfive/jh7110.dtsi      |  93 ++++++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../stmicro/stmmac/dwmac-starfive-plat.c      | 167 +++++++++++++++
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   3 +-
 drivers/net/phy/Kconfig                       |   3 +-
 drivers/net/phy/motorcomm.c                   | 202 ++++++++++++++++++
 12 files changed, 744 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
 create mode 100644 Documentation/devicetree/bindings/net/starfive,jh71x0-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c


base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
prerequisite-patch-id: 8ebfffa09b478904bf7c516f76e2d824ddb60140
prerequisite-patch-id: e8dd8258a4c4062eee2cf07c4607d52baea71f3a
prerequisite-patch-id: d050d884d7b091ff30508a70f5ce5164bb3b72e5
prerequisite-patch-id: 0e41f8cfd4861fcbf6f2e6a2559ce28f0450299e
prerequisite-patch-id: 6e1652501859b85f101ff3b15ced585d43c71c1b
prerequisite-patch-id: 587628a67adad5c655e5f998bf6c4a368ec07d3c
prerequisite-patch-id: 596490c0e397df6c0249c1306fbb1d5bf00b5b83
prerequisite-patch-id: dc873317826b50364344b25ac5cd74e811403f3d
prerequisite-patch-id: a50150f41d8e874553023187e22eb24dffae8d16
prerequisite-patch-id: 735e62255c75801bdc4c0b4107850bce821ff7f5
prerequisite-patch-id: 9d2e83a2dd43e193f534283fab73e90b4f435043
prerequisite-patch-id: 7a43e0849a9afa3c6f83547fd16d9271b07619e5
prerequisite-patch-id: e7aa6fb05314bad6d94c465f3f59969871bf3d2e
prerequisite-patch-id: 6276b2a23818c65ff2ad3d65b562615690cffee9
prerequisite-patch-id: d834ece14ffb525b8c3e661e78736692f33fca9b
prerequisite-patch-id: 4c17a3ce4dae9b788795d915bf775630f5c43c53
prerequisite-patch-id: dabb913fd478e97593e45c23fee4be9fd807f851
prerequisite-patch-id: ba61df106fbe2ada21e8f22c3d2cfaf7809c84b6
prerequisite-patch-id: 287572fb64f83f5d931034f7c75674907584a087
prerequisite-patch-id: 536114f0732646095ef5302a165672b3290d4c75
prerequisite-patch-id: 258ea5f9b8bf41b6981345dcc81795f25865d38f
prerequisite-patch-id: 8b6f2c9660c0ac0ee4e73e4c21aca8e6b75e81b9
prerequisite-patch-id: e09e995700a814a763aa304ad3881a7222acf556
prerequisite-patch-id: 841cd71b556b480d6a5a5e332eeca70d6a76ec3f
prerequisite-patch-id: d074c7ffa2917a9f754d5801e3f67bc980f9de4c
prerequisite-patch-id: 5f59bc7cbbf1230e5ff4761fa7c1116d4e6e5d71
prerequisite-patch-id: d5da3475c6a3588e11a1678feb565bdd459b548e
-- 
2.17.1

