Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1981E62B491
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbiKPIHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiKPIHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:07:44 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48467DFEA
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 00:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OdZ8AwChaDF14axSXBpypGBs6g6mLcCrCi38LgTnupQ=; b=SvSuoBBX2S1kePhXOKAI3g9Muw
        QwC7xmN2fdqkcWXu6EmlXn8duP0YrsEWIDGZWBqZEIRuEXftIWRi6QqCFJJMzJEXxH8LMx/hgYoBr
        QH7Hw0iHmsOSyNKW+s1RNjUsyR62txMRm3qOwjuMf9BsrfYbkTauC8f38BOfLXEizDZI=;
Received: from p200300daa72ee10015f07c5633889601.dip0.t-ipconnect.de ([2003:da:a72e:e100:15f0:7c56:3388:9601] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ovDSI-002Xoe-Ud; Wed, 16 Nov 2022 09:07:35 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Multiqueue support for mtk_eth_soc
Date:   Wed, 16 Nov 2022 09:07:28 +0100
Message-Id: <20221116080734.44013-1-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements multiqueue support on devices with QDMA (MT7621 and newer)
by using the SoC's traffic shaper function, which is part of the QDMA engine.

The driver exposes traffic shaper queues as network stack queues and configures
them to the link speed limit.
This fixes an issue where traffic to slower ports would drown out traffic to
faster ports. It also fixes packet drops and jitter when running hardware
offloaded traffic alongside traffic from the CPU.

Felix Fietkau (6):
  net: ethernet: mtk_eth_soc: increase tx ring size for QDMA devices
  net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full
  net: ethernet: mtk_eth_soc: avoid port_mg assignment on MT7622 and
    newer
  net: ethernet: mtk_eth_soc: implement multi-queue support for per-port
    queues
  net: dsa: tag_mtk: assign per-port queues
  net: ethernet: mediatek: ppe: assign per-port queues for offloaded
    traffic

 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 328 ++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  28 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c       |  22 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h       |   4 +
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  12 +-
 net/dsa/tag_mtk.c                             |   2 +
 6 files changed, 324 insertions(+), 72 deletions(-)

-- 
2.38.1

