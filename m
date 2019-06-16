Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E9447669
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 20:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfFPS36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 14:29:58 -0400
Received: from mx.0dd.nl ([5.2.79.48]:35810 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfFPS36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 14:29:58 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Jun 2019 14:29:56 EDT
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id F2C1160743;
        Sun, 16 Jun 2019 20:20:29 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="FN0hLvbF";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id B867D1C65C75;
        Sun, 16 Jun 2019 20:20:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com B867D1C65C75
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1560709229;
        bh=FVz7Hn4FLBbfcWH9mwHn/c+q2RITenYFgIKX1MKhYCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FN0hLvbFuwlQgK6xPtWy5fqR54Ff84xdsrphIIXG+WUQ4QJW72tqJF6p8YfBf+aJ7
         3GW2x6uBRW9ejmGind7x0drMPvLDJ0NKrSbxj4svV54M9YuSeUm3pIMUjJK+J2YzCc
         1TnUt1XpdxYQworIBPiKx/+Yrm7N9t/cAHDwy5DteKdYG6VFyqHImr+By1CxmiG2Pg
         AWwkbHe7zuowI7rpLBqhGAF8c8tfoGXcbmrWcwMaXavwRp4NfUsCrV326WThnk+JH5
         LIgLQ7g6/C3PCQsdxd/Y7+AduwmUIMrs1ZiVbY+rVS5Chz0mUBTMzhKumHFBQbZVMT
         xFVogJiQQt5Ww==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next 2/2] net: dsa: mt7530: Add MT7621 TRGMII mode support
Date:   Sun, 16 Jun 2019 20:20:10 +0200
Message-Id: <20190616182010.18778-3-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190616182010.18778-1-opensource@vdorst.com>
References: <20190616182010.18778-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7621 internal MT7530 switch also supports TRGMII mode.
TRGMII speed is 1200MBit.

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c7d352da5448..88de4e880417 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -435,11 +435,20 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
 		trgint = 0;
 		ncpo1 = 0x0c80;
 		ssc_delta = 0x87;
+
+		/* Port 6 delay settings RGMII central align */
+		mt7530_rmw(priv, MT7530_TRGMII_TXCTRL, BIT(30) | BIT(28), 0);
+		mt7530_write(priv, MT7530_TRGMII_TCK_CTRL, 0x0855);
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
-		ncpo1 = 0x1400;
+		/* PLL frequency: MT7621 150MHz, other 162.5MHz */
+		ncpo1 = (priv->id == ID_MT7621 ? 0x0780 : 0x1400);
 		ssc_delta = 0x57;
+
+		/* Port 6 delay settings TRGMII central align */
+		mt7530_rmw(priv, MT7530_TRGMII_TXCTRL, 0, BIT(30));
+		mt7530_write(priv, MT7530_TRGMII_TCK_CTRL, 0x0055);
 		break;
 	default:
 		dev_err(priv->dev, "xMII mode %d not supported\n", mode);
@@ -507,7 +516,9 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 				   RD_TAP_MASK, RD_TAP(16));
 	else
-		mt7623_trgmii_set(priv, GSW_INTF_MODE, INTF_MODE_TRGMII);
+		if (priv->id != ID_MT7621)
+			mt7623_trgmii_set(priv, GSW_INTF_MODE,
+					  INTF_MODE_TRGMII);
 
 	return 0;
 }
-- 
2.20.1

