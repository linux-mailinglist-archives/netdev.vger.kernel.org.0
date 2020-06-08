Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CE21F27D9
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbgFHXYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731638AbgFHXYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:24:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239C620897;
        Mon,  8 Jun 2020 23:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658675;
        bh=LdNzVHSOMoY3VrTfF8wSlN0qzmWL8FJ+lC8X3l9ZdLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrJYx+0HibGNUBPp/rZ9Oy7C1fHOeqrUSmMSxn6oBrkMtgGk6cgcqZ8TByj0yBtUB
         EK8HW2J1tUIw+71P3gGd73TrIcliTBSe4LxIY41hO39q8DvIzVJQU3H2TF59Yf3Ma8
         TDpkyqrOJG7FqyTFwhhrmdvgi2nAgfUXdDq8HNi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 087/106] net: ethernet: fec: move GPR register offset and bit into DT
Date:   Mon,  8 Jun 2020 19:22:19 -0400
Message-Id: <20200608232238.3368589-87-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 8a448bf832af537d26aa557d183a16943dce4510 ]

The commit da722186f654 (net: fec: set GPR bit on suspend by DT
configuration) set the GPR reigster offset and bit in driver for
wake on lan feature.

But it introduces two issues here:
- one SOC has two instances, they have different bit
- different SOCs may have different offset and bit

So to support wake-on-lan feature on other i.MX platforms, it should
configure the GPR reigster offset and bit from DT.

So the patch is to improve the commit da722186f654 (net: fec: set GPR
bit on suspend by DT configuration) to support multiple ethernet
instances on i.MX series.

v2:
 * switch back to store the quirks bitmask in driver_data
v3:
 * suggested by Sascha Hauer, use a struct fec_devinfo for
   abstracting differences between different hardware variants,
   it can give more freedom to describe the differences.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 48c58f93b124..6702bc2dd92f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -88,8 +88,6 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 struct fec_devinfo {
 	u32 quirks;
-	u8 stop_gpr_reg;
-	u8 stop_gpr_bit;
 };
 
 static const struct fec_devinfo fec_imx25_info = {
@@ -112,8 +110,6 @@ static const struct fec_devinfo fec_imx6q_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
 		  FEC_QUIRK_HAS_RACC,
-	.stop_gpr_reg = 0x34,
-	.stop_gpr_bit = 27,
 };
 
 static const struct fec_devinfo fec_mvf600_info = {
@@ -3401,19 +3397,23 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 }
 
 static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
-				   struct fec_devinfo *dev_info,
 				   struct device_node *np)
 {
 	struct device_node *gpr_np;
+	u32 out_val[3];
 	int ret = 0;
 
-	if (!dev_info)
-		return 0;
-
-	gpr_np = of_parse_phandle(np, "gpr", 0);
+	gpr_np = of_parse_phandle(np, "fsl,stop-mode", 0);
 	if (!gpr_np)
 		return 0;
 
+	ret = of_property_read_u32_array(np, "fsl,stop-mode", out_val,
+					 ARRAY_SIZE(out_val));
+	if (ret) {
+		dev_dbg(&fep->pdev->dev, "no stop mode property\n");
+		return ret;
+	}
+
 	fep->stop_gpr.gpr = syscon_node_to_regmap(gpr_np);
 	if (IS_ERR(fep->stop_gpr.gpr)) {
 		dev_err(&fep->pdev->dev, "could not find gpr regmap\n");
@@ -3422,8 +3422,8 @@ static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
 		goto out;
 	}
 
-	fep->stop_gpr.reg = dev_info->stop_gpr_reg;
-	fep->stop_gpr.bit = dev_info->stop_gpr_bit;
+	fep->stop_gpr.reg = out_val[1];
+	fep->stop_gpr.bit = out_val[2];
 
 out:
 	of_node_put(gpr_np);
@@ -3501,7 +3501,7 @@ fec_probe(struct platform_device *pdev)
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
-	ret = fec_enet_init_stop_mode(fep, dev_info, np);
+	ret = fec_enet_init_stop_mode(fep, np);
 	if (ret)
 		goto failed_stop_mode;
 
-- 
2.25.1

