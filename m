Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E866E3C73CA
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhGMQKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhGMQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:10:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14A4C0613DD;
        Tue, 13 Jul 2021 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x2Sy3YhydFPX1Q2Umb3BUnJX0kadND+lgagPMkUjMfo=; b=klbQOeKNCYGbm3zi1+R4/C+YAo
        XPVDCEAfGBg9ua0mSE5b7R0kQzHvMppwRq0VmrsrvimJNjOcqewOWYKCoS5J1DzdlNSa4ZTWuF2hN
        X+jyyVQPBk4II1mr1rYRxcNLlnjl0CWfm4eFoVvwy0EYQv/CdoQBScU76oeXWQm4vybg=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Kwl-0008TX-SE; Tue, 13 Jul 2021 18:07:47 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Subject: [RFC 0/7] Ethernet->WLAN hardware flow offloading support on MT7622
Date:   Tue, 13 Jul 2021 18:07:38 +0200
Message-Id: <20210713160745.59707-1-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds hardware flow offloading for routing/NAT packets from
ethernet to WLAN on MT7622 SoC, in combination with MT7915 WLAN devices
This only offloads one direction, WLAN->Ethernet offload is not supported by
MT7622 (but will be in newer SoC designs).

In order to make this work, the SoC contains a subsystem named Wireless
Ethernet Dispatch. It intercepts access to the WLAN DMA register space and
controls the DMA queues in order to be able to inject packets coming in from
the packet processing engine (PPE). It also intercepts IRQs from PCIe.


Felix Fietkau (7):
  mac80211: add support for .ndo_fill_forward_path
  net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch
    (WED)
  net: ethernet: mtk_eth_soc: implement flow offloading to WED devices
  mt76: dma: add wrapper macro for accessing queue registers
  mt76: make number of tokens configurable dynamically
  mt76: mt7915: remove irq parameter from mt7915_mmio_init
  mt76: mt7915: add Wireless Ethernet Dispatch support

 arch/arm64/boot/dts/mediatek/mt7622.dtsi      |  22 +
 drivers/net/ethernet/mediatek/Kconfig         |   4 +
 drivers/net/ethernet/mediatek/Makefile        |   5 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  23 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   3 +
 drivers/net/ethernet/mediatek/mtk_ppe.c       |  18 +
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  14 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  67 +-
 drivers/net/ethernet/mediatek/mtk_wed.c       | 837 ++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed.h       | 123 +++
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   | 175 ++++
 drivers/net/ethernet/mediatek/mtk_wed_ops.c   |   8 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h  | 248 ++++++
 drivers/net/wireless/mediatek/mt76/dma.c      | 111 ++-
 drivers/net/wireless/mediatek/mt76/mac80211.c |   5 +-
 drivers/net/wireless/mediatek/mt76/mmio.c     |   9 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  36 +-
 .../net/wireless/mediatek/mt76/mt7603/dma.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt7615/dma.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   4 +-
 .../net/wireless/mediatek/mt76/mt7915/dma.c   |  38 +-
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 123 ++-
 .../net/wireless/mediatek/mt76/mt7915/mac.h   |   2 +
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  32 +
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   |   4 +
 .../net/wireless/mediatek/mt76/mt7915/mmio.c  |   2 +-
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |   3 +-
 .../net/wireless/mediatek/mt76/mt7915/pci.c   |  98 +-
 .../net/wireless/mediatek/mt76/mt7915/regs.h  |  19 +-
 .../net/wireless/mediatek/mt76/mt7921/dma.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c       |  21 +-
 include/linux/netdevice.h                     |   7 +
 include/linux/soc/mediatek/mtk_wed.h          | 127 +++
 include/net/mac80211.h                        |   5 +
 net/core/dev.c                                |   4 +
 net/mac80211/driver-ops.h                     |  22 +
 net/mac80211/ieee80211_i.h                    |   2 +-
 net/mac80211/iface.c                          |  58 ++
 net/mac80211/trace.h                          |   7 +
 39 files changed, 2187 insertions(+), 115 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_ops.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_regs.h
 create mode 100644 include/linux/soc/mediatek/mtk_wed.h

-- 
2.30.1

