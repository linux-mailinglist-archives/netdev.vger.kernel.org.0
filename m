Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA233188FB
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhBKLDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:03:23 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29902 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231148AbhBKKvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:51:51 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BAoA09008163;
        Thu, 11 Feb 2021 02:50:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RjJNiGJReKD0qbzF9XCnYxSSFbqd935Y+Xf2kaH9nzs=;
 b=TUMy30s4wVazPyzf9b/Cl5EX3tAHisYhc/UtpHgu3JAy5s0+LGaTS55pTFGZNvSt3TNw
 Rc042K3kcijnMhfr5tjvdkt18lVhVB9ffGyDBY9PLzS2qanmgigv09r8E96GzDeU8F5n
 20S+AlMdZhBw6y11QNxVk1b8fiL8IyJOPxqnvpXBMlNembSTtrKwMA8zlVbY2xFHc5bT
 16385Qc2uZxaC9/XNWEo4Tts5wwmBv4AXYdHaUPlMfDFXYEAMZWju6+GGEk191DSFuRy
 JNsM2lPAsDfLpThmDuZPpMKa+ZSsP7G6F41Bx+CHzdXqTsHLQEnJhwz2bqroHuoL3LuX rQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrpr62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 02:50:35 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:50:33 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:50:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 02:50:33 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 43DA23F7044;
        Thu, 11 Feb 2021 02:50:29 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <gregory.clement@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v13 net-next 04/15] net: mvpp2: always compare hw-version vs MVPP21
Date:   Thu, 11 Feb 2021 12:48:51 +0200
Message-ID: <1613040542-16500-5-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Currently we have PP2v1 and PP2v2 hw-versions, with some different
handlers depending upon condition hw_version = MVPP21/MVPP22.
In a future there will be also PP2v3. Let's use now the generic
"if equal/notEqual MVPP21" for all cases instead of "if MVPP22".

This patch does not change any functionality.
It is not intended to introduce PP2v3.
It just modifies MVPP21/MVPP22 check-condition
bringing it to generic and unified form correct for new-code
introducing and PP2v3 net-next generation.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 38 ++++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index eec3796..17cd161 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -319,7 +319,7 @@ static int mvpp2_get_nrxqs(struct mvpp2 *priv)
 {
 	unsigned int nrxqs;
 
-	if (priv->hw_version == MVPP22 && queue_mode == MVPP2_QDIST_SINGLE_MODE)
+	if (priv->hw_version != MVPP21 && queue_mode == MVPP2_QDIST_SINGLE_MODE)
 		return 1;
 
 	/* According to the PPv2.2 datasheet and our experiments on
@@ -446,7 +446,7 @@ static void mvpp2_bm_bufs_get_addrs(struct device *dev, struct mvpp2 *priv,
 				      MVPP2_BM_PHY_ALLOC_REG(bm_pool->id));
 	*phys_addr = mvpp2_thread_read(priv, thread, MVPP2_BM_VIRT_ALLOC_REG);
 
-	if (priv->hw_version == MVPP22) {
+	if (priv->hw_version != MVPP21) {
 		u32 val;
 		u32 dma_addr_highbits, phys_addr_highbits;
 
@@ -742,7 +742,7 @@ static inline void mvpp2_bm_pool_put(struct mvpp2_port *port, int pool,
 	if (test_bit(thread, &port->priv->lock_map))
 		spin_lock_irqsave(&port->bm_lock[thread], flags);
 
-	if (port->priv->hw_version == MVPP22) {
+	if (port->priv->hw_version != MVPP21) {
 		u32 val = 0;
 
 		if (sizeof(dma_addr_t) == 8)
@@ -1172,7 +1172,7 @@ static void mvpp2_interrupts_unmask(void *arg)
 	u32 val;
 	int i;
 
-	if (port->priv->hw_version != MVPP22)
+	if (port->priv->hw_version == MVPP21)
 		return;
 
 	if (mask)
@@ -1199,7 +1199,7 @@ static bool mvpp2_port_supports_xlg(struct mvpp2_port *port)
 
 static bool mvpp2_port_supports_rgmii(struct mvpp2_port *port)
 {
-	return !(port->priv->hw_version == MVPP22 && port->gop_id == 0);
+	return !(port->priv->hw_version != MVPP21 && port->gop_id == 0);
 }
 
 /* Port configuration routines */
@@ -1817,7 +1817,7 @@ static void mvpp2_mac_reset_assert(struct mvpp2_port *port)
 	      MVPP2_GMAC_PORT_RESET_MASK;
 	writel(val, port->base + MVPP2_GMAC_CTRL_2_REG);
 
-	if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
+	if (port->priv->hw_version != MVPP21 && port->gop_id == 0) {
 		val = readl(port->base + MVPP22_XLG_CTRL0_REG) &
 		      ~MVPP22_XLG_CTRL0_MAC_RESET_DIS;
 		writel(val, port->base + MVPP22_XLG_CTRL0_REG);
@@ -1830,7 +1830,7 @@ static void mvpp22_pcs_reset_assert(struct mvpp2_port *port)
 	void __iomem *mpcs, *xpcs;
 	u32 val;
 
-	if (port->priv->hw_version != MVPP22 || port->gop_id != 0)
+	if (port->priv->hw_version == MVPP21 || port->gop_id != 0)
 		return;
 
 	mpcs = priv->iface_base + MVPP22_MPCS_BASE(port->gop_id);
@@ -1851,7 +1851,7 @@ static void mvpp22_pcs_reset_deassert(struct mvpp2_port *port)
 	void __iomem *mpcs, *xpcs;
 	u32 val;
 
-	if (port->priv->hw_version != MVPP22 || port->gop_id != 0)
+	if (port->priv->hw_version == MVPP21 || port->gop_id != 0)
 		return;
 
 	mpcs = priv->iface_base + MVPP22_MPCS_BASE(port->gop_id);
@@ -4188,7 +4188,7 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
 	/* Enable interrupts on all threads */
 	mvpp2_interrupts_enable(port);
 
-	if (port->priv->hw_version == MVPP22)
+	if (port->priv->hw_version != MVPP21)
 		mvpp22_mode_reconfigure(port);
 
 	if (port->phylink) {
@@ -4404,7 +4404,7 @@ static int mvpp2_open(struct net_device *dev)
 		valid = true;
 	}
 
-	if (priv->hw_version == MVPP22 && port->port_irq) {
+	if (priv->hw_version != MVPP21 && port->port_irq) {
 		err = request_irq(port->port_irq, mvpp2_port_isr, 0,
 				  dev->name, port);
 		if (err) {
@@ -6052,7 +6052,7 @@ static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
 			     MVPP2_GMAC_PORT_RESET_MASK,
 			     MVPP2_GMAC_PORT_RESET_MASK);
 
-		if (port->priv->hw_version == MVPP22) {
+		if (port->priv->hw_version != MVPP21) {
 			mvpp22_gop_mask_irq(port);
 
 			phy_power_off(port->comphy);
@@ -6106,7 +6106,7 @@ static int mvpp2_mac_finish(struct phylink_config *config, unsigned int mode,
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 
-	if (port->priv->hw_version == MVPP22 &&
+	if (port->priv->hw_version != MVPP21 &&
 	    port->phy_interface != interface) {
 		port->phy_interface = interface;
 
@@ -6786,7 +6786,7 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	if (dram_target_info)
 		mvpp2_conf_mbus_windows(dram_target_info, priv);
 
-	if (priv->hw_version == MVPP22)
+	if (priv->hw_version != MVPP21)
 		mvpp2_axi_init(priv);
 
 	/* Disable HW PHY polling */
@@ -6930,7 +6930,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
 	}
 
-	if (priv->hw_version == MVPP22 && dev_of_node(&pdev->dev)) {
+	if (priv->hw_version != MVPP21 && dev_of_node(&pdev->dev)) {
 		priv->sysctrl_base =
 			syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
 							"marvell,system-controller");
@@ -6943,7 +6943,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->sysctrl_base = NULL;
 	}
 
-	if (priv->hw_version == MVPP22 &&
+	if (priv->hw_version != MVPP21 &&
 	    mvpp2_get_nrxqs(priv) * 2 <= MVPP2_BM_MAX_POOLS)
 		priv->percpu_pools = 1;
 
@@ -6988,7 +6988,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 		if (err < 0)
 			goto err_pp_clk;
 
-		if (priv->hw_version == MVPP22) {
+		if (priv->hw_version != MVPP21) {
 			priv->mg_clk = devm_clk_get(&pdev->dev, "mg_clk");
 			if (IS_ERR(priv->mg_clk)) {
 				err = PTR_ERR(priv->mg_clk);
@@ -7029,7 +7029,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (priv->hw_version == MVPP22) {
+	if (priv->hw_version != MVPP21) {
 		err = dma_set_mask(&pdev->dev, MVPP2_DESC_DMA_MASK);
 		if (err)
 			goto err_axi_clk;
@@ -7104,10 +7104,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->axi_clk);
 
 err_mg_core_clk:
-	if (priv->hw_version == MVPP22)
+	if (priv->hw_version != MVPP21)
 		clk_disable_unprepare(priv->mg_core_clk);
 err_mg_clk:
-	if (priv->hw_version == MVPP22)
+	if (priv->hw_version != MVPP21)
 		clk_disable_unprepare(priv->mg_clk);
 err_gop_clk:
 	clk_disable_unprepare(priv->gop_clk);
-- 
1.9.1

