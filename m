Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DB31560A8
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 22:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBGVSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 16:18:34 -0500
Received: from lists.gateworks.com ([108.161.130.12]:52303 "EHLO
        lists.gateworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgBGVSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 16:18:34 -0500
X-Greylist: delayed 2267 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Feb 2020 16:18:34 EST
Received: from 68-189-91-139.static.snlo.ca.charter.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by lists.gateworks.com with esmtp (Exim 4.82)
        (envelope-from <tharvey@gateworks.com>)
        id 1j0ARF-0004wm-Ik; Fri, 07 Feb 2020 20:41:21 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, rrichter@marvell.com, sgoutham@marvell.com,
        andrew@lunn.ch, Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH] net: thunderx: use proper interface type for RGMII
Date:   Fri,  7 Feb 2020 12:40:26 -0800
Message-Id: <1581108026-28170-1-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The configuration of the OCTEONTX XCV_DLL_CTL register via
xcv_init_hw() is such that the RGMII RX delay is bypassed
leaving the RGMII TX delay enabled in the MAC:

	/* Configure DLL - enable or bypass
	 * TX no bypass, RX bypass
	 */
	cfg = readq_relaxed(xcv->reg_base + XCV_DLL_CTL);
	cfg &= ~0xFF03;
	cfg |= CLKRX_BYP;
	writeq_relaxed(cfg, xcv->reg_base + XCV_DLL_CTL);

This would coorespond to a interface type of PHY_INTERFACE_MODE_RGMII_RXID
and not PHY_INTERFACE_MODE_RGMII.

Fixing this allows RGMII PHY drivers to do the right thing (enable
RX delay in the PHY) instead of erroneously enabling both delays in the
PHY.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index c4f6ec0..17a4110 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1039,7 +1039,7 @@ static int phy_interface_mode(u8 lmac_type)
 	if (lmac_type == BGX_MODE_QSGMII)
 		return PHY_INTERFACE_MODE_QSGMII;
 	if (lmac_type == BGX_MODE_RGMII)
-		return PHY_INTERFACE_MODE_RGMII;
+		return PHY_INTERFACE_MODE_RGMII_RXID;
 
 	return PHY_INTERFACE_MODE_SGMII;
 }
-- 
2.7.4

