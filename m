Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2614C421B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiBYKSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiBYKSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:18:46 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46BB17E376
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=77a3jqevgZL1+oiS2NRmN4fBD0B+EDHsJf10YO0s0GM=; b=bsxsLDV5B1Hpj+pnD6DoqpUM5g
        IZivvUT8/s1GkQ/Aq5JvqbLqQQwAZpt+mGhcaoiTtjV4JV7W3uubc+duEQHx1ZPzdiMagA7aZEaa2
        cyjHAM8AS9/8BQI4+aSrHUcVs1z6r30xutkGGVdK3/oZMli9estX8Tvn0vGAj2j6tlbc=;
Received: from p200300daa7204f00f847964d075b2b3d.dip0.t-ipconnect.de ([2003:da:a720:4f00:f847:964d:75b:2b3d] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nNXfw-0007J1-Lh; Fri, 25 Feb 2022 11:18:12 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 00/11] MediaTek SoC flow offload improvements + wireless support
Date:   Fri, 25 Feb 2022 11:17:59 +0100
Message-Id: <20220225101811.72103-1-nbd@nbd.name>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains the following improvements to mediatek ethernet flow
offload support:

- support dma-coherent on ethernet to improve performance
- add ipv6 offload support
- rework hardware flow table entry handling to improve dealing with hash
  collisions and competing flows
- support creating offload entries from user space
- support creating offload entries with just source/destination mac address,
  vlan and output device information
- add driver changes for supporting the Wireless Ethernet Dispatch core,
  which can be used to offload flows from ethernet to MT7915 PCIe WLAN
  devices

David Bentham (1):
  net: ethernet: mtk_eth_soc: add ipv6 flow offload support

Felix Fietkau (10):
  net: ethernet: mtk_eth_soc: add support for coherent DMA
  arm64: dts: mediatek: mt7622: add support for coherent DMA
  net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch
    (WED)
  net: ethernet: mtk_eth_soc: implement flow offloading to WED devices
  arm64: dts: mediatek: mt7622: introduce nodes for Wireless Ethernet
    Dispatch
  net: ethernet: mtk_eth_soc: support TC_SETUP_BLOCK for PPE offload
  net: ethernet: mtk_eth_soc: allocate struct mtk_ppe separately
  net: ethernet: mtk_eth_soc: rework hardware flow table management
  net: ethernet: mtk_eth_soc: remove bridge flow offload type entry
    support
  net: ethernet: mtk_eth_soc: support creating mac address based offload
    entries

 arch/arm64/boot/dts/mediatek/mt7622.dtsi      |  32 +-
 drivers/net/ethernet/mediatek/Kconfig         |   4 +
 drivers/net/ethernet/mediatek/Makefile        |   5 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 131 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  14 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 368 +++++++-
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  89 +-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   1 -
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 189 +++-
 drivers/net/ethernet/mediatek/mtk_wed.c       | 875 ++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed.h       | 135 +++
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   | 175 ++++
 drivers/net/ethernet/mediatek/mtk_wed_ops.c   |   8 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h  | 251 +++++
 include/linux/netdevice.h                     |   7 +
 include/linux/soc/mediatek/mtk_wed.h          | 131 +++
 net/core/dev.c                                |   4 +
 17 files changed, 2294 insertions(+), 125 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_ops.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_regs.h
 create mode 100644 include/linux/soc/mediatek/mtk_wed.h

-- 
2.32.0 (Apple Git-132)

