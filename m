Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCA96179FB
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiKCJ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiKCJ3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:29:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF664E0C1;
        Thu,  3 Nov 2022 02:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7992B61DD4;
        Thu,  3 Nov 2022 09:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF3CC433C1;
        Thu,  3 Nov 2022 09:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667467718;
        bh=S/F8Xv1K2g426RUX/9UHQYE4rfAx8qVSyI51yE7iV6k=;
        h=From:To:Cc:Subject:Date:From;
        b=SqCSdZcJuEOc4qeMi3Hspx4fiaEzeIqa9FJ++XSyVVNQE/wfiYBqeUjDONbXo7Mqm
         9FwJdcHUcWsjGditUGL3HKwZhdgkY2X2WdZYxO3bZ7znv8huK232/gFKYb85qtqrkj
         Nqh/ivuGh2PTfKhSObHehx2nwR0ex3BykLR4nhbwpqE65VepPIDWjQUsj1tPbK0KT8
         uOIvO1sUT0m5wGqWTNWL5z5wCfdd/4z4XDwY19PBIJQ/6EstUVK23lU66kPthuNSKB
         ANN+YrH4ZG0p+YKhGlF2qMueWR+unsPjcgvgEu6FfjGGWbt6xAh8pUN8sl06wZBVLt
         8GC23EdQ6vWVw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
Subject: [PATCH v3 net-next 0/8] introduce WED RX support to MT7986 SoC
Date:   Thu,  3 Nov 2022 10:27:59 +0100
Message-Id: <cover.1667466887.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to TX counterpart available on MT7622 and MT7986, introduce
RX Wireless Ethernet Dispatch available on MT7986 SoC in order to
offload traffic received by wlan nic to the wired interfaces (lan/wan).

Changes since v2:
- rely on of_reserved_mem APIs in mcu code
- add some dts fixes
- rename {tx,rx}_wdma in {rx,tx}_wdma
- update entry in maintainers file

Changes since v1:
- fix sparse warnings
- rely on memory-region property in mt7622-wed.yaml
- some more binding fixes

Lorenzo Bianconi (7):
  arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet
    Dispatch
  dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
  net: ethernet: mtk_wed: introduce wed wo support
  net: ethernet: mtk_wed: rename tx_wdma array in rx_wdma
  net: ethernet: mtk_wed: add configure wed wo support
  net: ethernet: mtk_wed: add rx mib counters
  MAINTAINERS: update MEDIATEK ETHERNET entry

Sujuan Chen (1):
  net: ethernet: mtk_wed: introduce wed mcu support

 .../arm/mediatek/mediatek,mt7622-wed.yaml     |  62 +-
 .../arm/mediatek/mediatek,mt7986-wo-boot.yaml |  47 ++
 .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml |  50 ++
 .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  |  50 ++
 MAINTAINERS                                   |   1 +
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  75 +++
 drivers/net/ethernet/mediatek/Makefile        |   2 +-
 drivers/net/ethernet/mediatek/mtk_wed.c       | 609 ++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_wed.h       |  21 +
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   |  87 +++
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c   | 392 +++++++++++
 drivers/net/ethernet/mediatek/mtk_wed_regs.h  | 129 +++-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c    | 508 +++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed_wo.h    | 284 ++++++++
 include/linux/soc/mediatek/mtk_wed.h          | 106 ++-
 15 files changed, 2366 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_mcu.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.h

-- 
2.38.1

