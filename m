Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AC9561438
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbiF3IJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiF3IJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:09:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E6F12096;
        Thu, 30 Jun 2022 01:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656576491; x=1688112491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TrBWC54P2CLz/iMBkusZyjETCWePFhmnr/L05n3qk6g=;
  b=Mn0fCMGtYwNRLf99VWdzuH0cTDzQ/4S0sa0T+Fiu3DoiRft3uk3Nd0+/
   41Hu3vxb5+Wr5SPW5NKU0xXJyCRWu7Ez+N30ojzuAiM+OmkyDUXR9HGcL
   dD661VFAUpWzJO5f7UfWss77DP8oETFEMz7G8IUU1N/3HJFOvuBcKJMjm
   RiEqGv+3zKt71dkLB99MJXywMchlgMK5y2etInPUPXgtNNbqI6EzNc6nE
   zMrfWM2jalJLjO0zIXmfZpPwVWouN0PoKs6Z3JZ7ca/Ir1MPwnl0syJgJ
   Sar+363ijZssTIxgwHNYnZ+5SZjQn20QG1DVYatQUSks5ECWyhAIIvv3A
   w==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="102426765"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 01:08:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 01:08:09 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 01:08:05 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Daire McNamara" <daire.mcnamara@microchip.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
Subject: [PATCH v1 10/14] clk: microchip: mpfs: move id & offset out of clock structs
Date:   Thu, 30 Jun 2022 09:05:29 +0100
Message-ID: <20220630080532.323731-11-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630080532.323731-1-conor.dooley@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The id and offset are the only thing differentiating the clock structs
from "regular" clock structures. On the pretext of converting to more
normal structures, move the id and offset out of the clock structs and
into the hw structs instead.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/clk/microchip/clk-mpfs.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/microchip/clk-mpfs.c b/drivers/clk/microchip/clk-mpfs.c
index a23f63bcd074..750f28481498 100644
--- a/drivers/clk/microchip/clk-mpfs.c
+++ b/drivers/clk/microchip/clk-mpfs.c
@@ -53,8 +53,6 @@ struct mpfs_msspll_hw_clock {
 
 struct mpfs_cfg_clock {
 	const struct clk_div_table *table;
-	unsigned int id;
-	u32 reg_offset;
 	u8 shift;
 	u8 width;
 	u8 flags;
@@ -65,12 +63,13 @@ struct mpfs_cfg_hw_clock {
 	void __iomem *sys_base;
 	struct clk_hw hw;
 	struct clk_init_data init;
+	unsigned int id;
+	u32 reg_offset;
 };
 
 #define to_mpfs_cfg_clk(_hw) container_of(_hw, struct mpfs_cfg_hw_clock, hw)
 
 struct mpfs_periph_clock {
-	unsigned int id;
 	u8 shift;
 };
 
@@ -78,6 +77,7 @@ struct mpfs_periph_hw_clock {
 	struct mpfs_periph_clock periph;
 	void __iomem *sys_base;
 	struct clk_hw hw;
+	unsigned int id;
 };
 
 #define to_mpfs_periph_clk(_hw) container_of(_hw, struct mpfs_periph_hw_clock, hw)
@@ -243,7 +243,7 @@ static unsigned long mpfs_cfg_clk_recalc_rate(struct clk_hw *hw, unsigned long p
 	void __iomem *base_addr = cfg_hw->sys_base;
 	u32 val;
 
-	val = readl_relaxed(base_addr + cfg->reg_offset) >> cfg->shift;
+	val = readl_relaxed(base_addr + cfg_hw->reg_offset) >> cfg->shift;
 	val &= clk_div_mask(cfg->width);
 
 	return divider_recalc_rate(hw, prate, val, cfg->table, cfg->flags, cfg->width);
@@ -272,10 +272,10 @@ static int mpfs_cfg_clk_set_rate(struct clk_hw *hw, unsigned long rate, unsigned
 		return divider_setting;
 
 	spin_lock_irqsave(&mpfs_clk_lock, flags);
-	val = readl_relaxed(base_addr + cfg->reg_offset);
+	val = readl_relaxed(base_addr + cfg_hw->reg_offset);
 	val &= ~(clk_div_mask(cfg->width) << cfg_hw->cfg.shift);
 	val |= divider_setting << cfg->shift;
-	writel_relaxed(val, base_addr + cfg->reg_offset);
+	writel_relaxed(val, base_addr + cfg_hw->reg_offset);
 
 	spin_unlock_irqrestore(&mpfs_clk_lock, flags);
 
@@ -289,11 +289,11 @@ static const struct clk_ops mpfs_clk_cfg_ops = {
 };
 
 #define CLK_CFG(_id, _name, _parent, _shift, _width, _table, _flags, _offset) {		\
-	.cfg.id = _id,									\
+	.id = _id,									\
 	.cfg.shift = _shift,								\
 	.cfg.width = _width,								\
 	.cfg.table = _table,								\
-	.cfg.reg_offset = _offset,							\
+	.reg_offset = _offset,								\
 	.cfg.flags = _flags,								\
 	.hw.init = CLK_HW_INIT(_name, _parent, &mpfs_clk_cfg_ops, 0),			\
 }
@@ -306,11 +306,11 @@ static struct mpfs_cfg_hw_clock mpfs_cfg_clks[] = {
 	CLK_CFG(CLK_AHB, "clk_ahb", "clk_msspll", 4, 2, mpfs_div_ahb_table, 0,
 		REG_CLOCK_CONFIG_CR),
 	{
-		.cfg.id = CLK_RTCREF,
+		.id = CLK_RTCREF,
 		.cfg.shift = 0,
 		.cfg.width = 12,
 		.cfg.table = mpfs_div_rtcref_table,
-		.cfg.reg_offset = REG_RTC_CLOCK_CR,
+		.reg_offset = REG_RTC_CLOCK_CR,
 		.cfg.flags = CLK_DIVIDER_ONE_BASED,
 		.hw.init =
 			CLK_HW_INIT_PARENTS_DATA("clk_rtcref", mpfs_ext_ref, &mpfs_clk_cfg_ops, 0),
@@ -338,9 +338,9 @@ static int mpfs_clk_register_cfgs(struct device *dev, struct mpfs_cfg_hw_clock *
 		ret = mpfs_clk_register_cfg(dev, cfg_hw, sys_base);
 		if (ret)
 			return dev_err_probe(dev, ret, "failed to register clock id: %d\n",
-					     cfg_hw->cfg.id);
+					     cfg_hw->id);
 
-		id = cfg_hw->cfg.id;
+		id = cfg_hw->id;
 		data->hw_data.hws[id] = &cfg_hw->hw;
 	}
 
@@ -408,7 +408,7 @@ static const struct clk_ops mpfs_periph_clk_ops = {
 };
 
 #define CLK_PERIPH(_id, _name, _parent, _shift, _flags) {			\
-	.periph.id = _id,							\
+	.id = _id,							\
 	.periph.shift = _shift,							\
 	.hw.init = CLK_HW_INIT_HW(_name, _parent, &mpfs_periph_clk_ops,		\
 				  _flags),					\
@@ -481,9 +481,9 @@ static int mpfs_clk_register_periphs(struct device *dev, struct mpfs_periph_hw_c
 		ret = mpfs_clk_register_periph(dev, periph_hw, sys_base);
 		if (ret)
 			return dev_err_probe(dev, ret, "failed to register clock id: %d\n",
-					     periph_hw->periph.id);
+					     periph_hw->id);
 
-		id = periph_hws[i].periph.id;
+		id = periph_hws[i].id;
 		data->hw_data.hws[id] = &periph_hw->hw;
 	}
 
-- 
2.36.1

