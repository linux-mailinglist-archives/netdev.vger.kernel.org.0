Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2825AAE2
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 14:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfF2MZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 08:25:13 -0400
Received: from mx.0dd.nl ([5.2.79.48]:50844 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfF2MZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 08:25:13 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id B87C45FE8C;
        Sat, 29 Jun 2019 14:25:10 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="aEffR9Jl";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 84F421CE691F;
        Sat, 29 Jun 2019 14:25:10 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 84F421CE691F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561811110;
        bh=Bu6E7/v0dN+ECBnl6aRpZhpeAg3S+W/5IW/5FrwWJIw=;
        h=From:To:Cc:Subject:Date:From;
        b=aEffR9JlqHiIo6LHHQKWWJmHDp7ZdKOWTyteHfr77OCeZZIhlA+nrzJ+XuokwILvR
         htzgQ0zUQgfdNUOMlKDFxkq6p0Ik1aPSMzjd8l1ftgQcJ07EtWNx0k5yk/8zhf8Eqk
         jOauos5ZEFrB1uenxLCF6/ai3m9frVJskIJeXyLMhirvNH2YfBenbpG1NAWEmASqBa
         LFOcaw30CHft9da3TEu4gj0fO4rA2pwAakO09Ug306FTzEiIr1Hu/PJS2mf4+CoFTa
         CBEIilfylObw3ok9aZQrJfx2Bb6DxrSibeJQNHZYRInnh8acA4C1yneM4MiCCNyYuC
         mDFbvn86S9ybg==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH] net: ethernet: mediatek: Allow non TRGMII mode with MT7621 DDR2 devices
Date:   Sat, 29 Jun 2019 14:24:51 +0200
Message-Id: <20190629122451.19578-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No reason to error out on a MT7621 device with DDR2 memory when non
TRGMII mode is selected.
Only MT7621 DDR2 clock setup is not supported for TRGMII mode.
But non TRGMII mode doesn't need any special clock setup.

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 066712f2e985..b20b3a5a1ebb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -139,9 +139,12 @@ static int mt7621_gmac0_rgmii_adjust(struct mtk_eth *eth,
 {
 	u32 val;
 
-	/* Check DDR memory type. Currently DDR2 is not supported. */
+	/* Check DDR memory type.
+	 * Currently TRGMII mode with DDR2 memory is not supported.
+	 */
 	regmap_read(eth->ethsys, ETHSYS_SYSCFG, &val);
-	if (val & SYSCFG_DRAM_TYPE_DDR2) {
+	if (interface == PHY_INTERFACE_MODE_TRGMII &&
+	    val & SYSCFG_DRAM_TYPE_DDR2) {
 		dev_err(eth->dev,
 			"TRGMII mode with DDR2 memory is not supported!\n");
 		return -EOPNOTSUPP;
-- 
2.20.1

