Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E1C60958F
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiJWS2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiJWS2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2DE5247A;
        Sun, 23 Oct 2022 11:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFD660F3C;
        Sun, 23 Oct 2022 18:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1D4C433D6;
        Sun, 23 Oct 2022 18:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666549702;
        bh=wkdAvPA8Pnc0jF12FSsd05dlVyH8gvyil6OYR7WwYcU=;
        h=From:To:Cc:Subject:Date:From;
        b=f0Ds0AHZjDZcVPc3tT6C665O4qlBfFr1PCUOw2anA8I5yQzxi9hzhN5F75we7LfVi
         ojAyCmPxenQA2aS6KFUPqU4a/UQQbsyWrGTAvAxESFXebRbO6qg2zSkSEitEwWTWKL
         mlXzPoIilV5Ddxr7lJ6D3WSomaAQmOUMRNVChwZFy50UXtYNm+zVbpwf8Edn2tzqJY
         ZPMSAuUzmp0aNR1ZL9NcKg4nzD6OFhckGGeeKdRegzKKgffgmr11Z5h2kR4CjU56no
         /c83ic05+YGC6FmA5pUgfKQ0l4XUbNl1LrH9R+jzU5LcpjFdGGBWoP39luiNb4eC08
         GT3KMla+apxMA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 0/6] introduce WED RX support to MT7986 SoC
Date:   Sun, 23 Oct 2022 20:28:04 +0200
Message-Id: <cover.1666549145.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Changes since v1:
- fix sparse warnings
- rely on memory-region property in mt7622-wed.yaml
- some more binding fixes

Lorenzo Bianconi (6):
  arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet
    Dispatch
  dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
  net: ethernet: mtk_wed: introduce wed mcu support
  net: ethernet: mtk_wed: introduce wed wo support
  net: ethernet: mtk_wed: add configure wed wo support
  net: ethernet: mtk_wed: add rx mib counters

 .../arm/mediatek/mediatek,mt7622-wed.yaml     |  91 +++
 .../arm/mediatek/mediatek,mt7986-wo-boot.yaml |  46 ++
 .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml |  49 ++
 .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  |  50 ++
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  73 +++
 drivers/net/ethernet/mediatek/Makefile        |   2 +-
 drivers/net/ethernet/mediatek/mtk_wed.c       | 577 ++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_wed.h       |  21 +
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   |  87 +++
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c   | 390 ++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed_regs.h  | 129 +++-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c    | 545 +++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed_wo.h    | 287 +++++++++
 include/linux/soc/mediatek/mtk_wed.h          | 104 +++-
 14 files changed, 2407 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_mcu.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.h

-- 
2.37.3

