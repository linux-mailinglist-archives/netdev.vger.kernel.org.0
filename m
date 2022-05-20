Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E8752F222
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352425AbiETSMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbiETSMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:12:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7106B41D7;
        Fri, 20 May 2022 11:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 738066178C;
        Fri, 20 May 2022 18:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25B0C385A9;
        Fri, 20 May 2022 18:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070331;
        bh=XH5tR/ceOrMA3qoQoBm41vju6F5mQ+4rINaDTk1L2Lw=;
        h=From:To:Cc:Subject:Date:From;
        b=DCjxGgLpX5eb4k63KxSdtXSNIoGzheVdUukHoZ43p83DSb6T5Zlamxl2h5feiMVoR
         5kBwL03Yse+QLYtpdI3sLMx/DMaMjrGtICwmV6bOQRR5EsNcU3EzKq7CS6Qlnw+cD+
         x9fop2UXLr4kh/7RljZVjc2m7b4X61MnmdqJgZDCHP09CMIXkDx21R6VH8fqlJj9tV
         qtEd799ETKPS6cZ45V1FROeBehhNk5lWl5NopZqMpYqT3v/OcyfU6b67tihgtP04q9
         pI4a2sSzka8mu+eHJxcuAXHadJ7E+AsJuvgbrhdtjrlyKnSectvqphWafkgko17/IY
         peucm2OTMC30g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 00/16] introduce mt7986 ethernet support
Date:   Fri, 20 May 2022 20:11:23 +0200
Message-Id: <cover.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for mt7986-eth driver available on mt7986 soc.

Changes since v2:
- rely on GFP_KERNEL whenever possible
- define mtk_reg_map struct to introduce soc register map and avoid macros
- improve comments

Changes since v1:
- drop SRAM option
- convert ring->dma to void
- convert scratch_ring to void
- enable port4
- fix irq dts bindings
- drop gmac1 support from mt7986a-rfb dts for the moment

Lorenzo Bianconi (16):
  arm64: dts: mediatek: mt7986: introduce ethernet nodes
  dt-bindings: net: mediatek,net: add mt7986-eth binding
  net: ethernet: mtk_eth_soc: rely on GFP_KERNEL for dma_alloc_coherent
    whenever possible
  net: ethernet: mtk_eth_soc: move tx dma desc configuration in
    mtk_tx_set_dma_desc
  net: ethernet: mtk_eth_soc: add txd_size to mtk_soc_data
  net: ethernet: mtk_eth_soc: rely on txd_size in
    mtk_tx_alloc/mtk_tx_clean
  net: ethernet: mtk_eth_soc: rely on txd_size in mtk_desc_to_tx_buf
  net: ethernet: mtk_eth_soc: rely on txd_size in txd_to_idx
  net: ethernet: mtk_eth_soc: add rxd_size to mtk_soc_data
  net: ethernet: mtk_eth_soc: rely on txd_size field in
    mtk_poll_tx/mtk_poll_rx
  net: ethernet: mtk_eth_soc: rely on rxd_size field in
    mtk_rx_alloc/mtk_rx_clean
  net: ethernet: mtk_eth_soc: introduce device register map
  net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support
  net: ethernet: mtk_eth_soc: convert ring dma pointer to void
  net: ethernet: mtk_eth_soc: convert scratch_ring pointer to void
  net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset

 .../devicetree/bindings/net/mediatek,net.yaml | 141 ++-
 arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts  |  74 ++
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  39 +
 arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts  |  70 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 834 +++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   | 305 ++++---
 6 files changed, 1113 insertions(+), 350 deletions(-)

-- 
2.35.3

