Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE04B49E245
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbiA0MXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:23:05 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:33302 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiA0MXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:23:04 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 20RCMcX0031508; Thu, 27 Jan 2022 21:22:38 +0900
X-Iguazu-Qid: 34tKV35MdxK8a3pfYA
X-Iguazu-QSIG: v=2; s=0; t=1643286157; q=34tKV35MdxK8a3pfYA; m=+h4MiUkJTIU1g/JRnWIqS9O3kEafgLfrraUtYVNfhc8=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1513) id 20RCMaJT006582
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jan 2022 21:22:36 +0900
X-SA-MID: 31148933
From:   Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp
Subject: [PATCH 1/1] net: stmmac: dwmac-visconti: No change to ETHER_CLOCK_SEL for unexpected speed request.
Date:   Thu, 27 Jan 2022 21:17:14 +0900
X-TSB-HOP: ON
X-TSB-HOP2: ON
Message-Id: <20220127121714.22915-2-yuji2.ishikawa@toshiba.co.jp>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220127121714.22915-1-yuji2.ishikawa@toshiba.co.jp>
References: <20220127121714.22915-1-yuji2.ishikawa@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable clk_sel_val is not initialized in the default case of the first switch statement.
In that case, the function should return immediately without any changes to the hardware.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
Signed-off-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index dde5b772a..c3f10a92b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -49,13 +49,15 @@ struct visconti_eth {
 	void __iomem *reg;
 	u32 phy_intf_sel;
 	struct clk *phy_ref_clk;
+	struct device *dev;
 	spinlock_t lock; /* lock to protect register update */
 };
 
 static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct visconti_eth *dwmac = priv;
-	unsigned int val, clk_sel_val;
+	struct net_device *netdev = dev_get_drvdata(dwmac->dev);
+	unsigned int val, clk_sel_val = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dwmac->lock, flags);
@@ -85,7 +87,9 @@ static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 		break;
 	default:
 		/* No bit control */
-		break;
+		netdev_err(netdev, "Unsupported speed request (%d)", speed);
+		spin_unlock_irqrestore(&dwmac->lock, flags);
+		return;
 	}
 
 	writel(val, dwmac->reg + MAC_CTRL_REG);
@@ -229,6 +233,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 
 	spin_lock_init(&dwmac->lock);
 	dwmac->reg = stmmac_res.addr;
+	dwmac->dev = &pdev->dev;
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->fix_mac_speed = visconti_eth_fix_mac_speed;
 
-- 
2.17.1


