Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A779459246
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbhKVP7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240329AbhKVP7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:59:36 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D4DC0613F4
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:56:16 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id MTvb260044C55Sk01Tvbry; Mon, 22 Nov 2021 16:56:16 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe6-00EL3Y-3R; Mon, 22 Nov 2021 16:54:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe5-00HGyg-Ij; Mon, 22 Nov 2021 16:54:17 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 06/17] clk: ti: Use bitfield helpers
Date:   Mon, 22 Nov 2021 16:53:59 +0100
Message-Id: <86b6110cca540b59f3012d4fc16391cf1b53cc6b.1637592133.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637592133.git.geert+renesas@glider.be>
References: <cover.1637592133.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the field_{get,prep}() helpers, instead of open-coding the same
operations.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.
Marked RFC, as this depends on [PATCH 01/17], but follows a different
path to upstream.
---
 drivers/clk/ti/apll.c     | 25 +++++-------
 drivers/clk/ti/dpll3xxx.c | 81 +++++++++++++++++----------------------
 2 files changed, 44 insertions(+), 62 deletions(-)

diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
index ac5bc8857a51456e..145a42ff050f076b 100644
--- a/drivers/clk/ti/apll.c
+++ b/drivers/clk/ti/apll.c
@@ -15,6 +15,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/module.h>
@@ -62,7 +63,7 @@ static int dra7_apll_enable(struct clk_hw *hw)
 
 	v = ti_clk_ll_ops->clk_readl(&ad->control_reg);
 	v &= ~ad->enable_mask;
-	v |= APLL_FORCE_LOCK << __ffs(ad->enable_mask);
+	v |= field_prep(ad->enable_mask, APLL_FORCE_LOCK);
 	ti_clk_ll_ops->clk_writel(v, &ad->control_reg);
 
 	state <<= __ffs(ad->idlest_mask);
@@ -101,7 +102,7 @@ static void dra7_apll_disable(struct clk_hw *hw)
 
 	v = ti_clk_ll_ops->clk_readl(&ad->control_reg);
 	v &= ~ad->enable_mask;
-	v |= APLL_AUTO_IDLE << __ffs(ad->enable_mask);
+	v |= field_prep(ad->enable_mask, APLL_AUTO_IDLE);
 	ti_clk_ll_ops->clk_writel(v, &ad->control_reg);
 }
 
@@ -114,11 +115,8 @@ static int dra7_apll_is_enabled(struct clk_hw *hw)
 	ad = clk->dpll_data;
 
 	v = ti_clk_ll_ops->clk_readl(&ad->control_reg);
-	v &= ad->enable_mask;
 
-	v >>= __ffs(ad->enable_mask);
-
-	return v == APLL_AUTO_IDLE ? 0 : 1;
+	return field_get(ad->enable_mask, v) == APLL_AUTO_IDLE ? 0 : 1;
 }
 
 static u8 dra7_init_apll_parent(struct clk_hw *hw)
@@ -242,14 +240,9 @@ static int omap2_apll_is_enabled(struct clk_hw *hw)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	struct dpll_data *ad = clk->dpll_data;
-	u32 v;
-
-	v = ti_clk_ll_ops->clk_readl(&ad->control_reg);
-	v &= ad->enable_mask;
-
-	v >>= __ffs(ad->enable_mask);
+	u32 v = ti_clk_ll_ops->clk_readl(&ad->control_reg);
 
-	return v == OMAP2_EN_APLL_LOCKED ? 1 : 0;
+	return field_get(ad->enable_mask, v) == OMAP2_EN_APLL_LOCKED ? 1 : 0;
 }
 
 static unsigned long omap2_apll_recalc(struct clk_hw *hw,
@@ -272,7 +265,7 @@ static int omap2_apll_enable(struct clk_hw *hw)
 
 	v = ti_clk_ll_ops->clk_readl(&ad->control_reg);
 	v &= ~ad->enable_mask;
-	v |= OMAP2_EN_APLL_LOCKED << __ffs(ad->enable_mask);
+	v |= field_prep(ad->enable_mask, OMAP2_EN_APLL_LOCKED);
 	ti_clk_ll_ops->clk_writel(v, &ad->control_reg);
 
 	while (1) {
@@ -302,7 +295,7 @@ static void omap2_apll_disable(struct clk_hw *hw)
 
 	v = ti_clk_ll_ops->clk_readl(&ad->control_reg);
 	v &= ~ad->enable_mask;
-	v |= OMAP2_EN_APLL_STOPPED << __ffs(ad->enable_mask);
+	v |= field_prep(ad->enable_mask, OMAP2_EN_APLL_STOPPED);
 	ti_clk_ll_ops->clk_writel(v, &ad->control_reg);
 }
 
@@ -320,7 +313,7 @@ static void omap2_apll_set_autoidle(struct clk_hw_omap *clk, u32 val)
 
 	v = ti_clk_ll_ops->clk_readl(&ad->autoidle_reg);
 	v &= ~ad->autoidle_mask;
-	v |= val << __ffs(ad->autoidle_mask);
+	v |= field_prep(ad->autoidle_mask, val);
 	ti_clk_ll_ops->clk_writel(v, &ad->control_reg);
 }
 
diff --git a/drivers/clk/ti/dpll3xxx.c b/drivers/clk/ti/dpll3xxx.c
index e32b3515f9e76b67..21c94d758eed92b7 100644
--- a/drivers/clk/ti/dpll3xxx.c
+++ b/drivers/clk/ti/dpll3xxx.c
@@ -15,6 +15,7 @@
  * Richard Woodruff, Tony Lindgren, Tuukka Tikkanen, Karthik Dasu
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/list.h>
@@ -53,7 +54,7 @@ static void _omap3_dpll_write_clken(struct clk_hw_omap *clk, u8 clken_bits)
 
 	v = ti_clk_ll_ops->clk_readl(&dd->control_reg);
 	v &= ~dd->enable_mask;
-	v |= clken_bits << __ffs(dd->enable_mask);
+	v |= field_prep(dd->enable_mask, clken_bits);
 	ti_clk_ll_ops->clk_writel(v, &dd->control_reg);
 }
 
@@ -333,8 +334,8 @@ static void omap3_noncore_dpll_ssc_program(struct clk_hw_omap *clk)
 
 		v = ti_clk_ll_ops->clk_readl(&dd->ssc_modfreq_reg);
 		v &= ~(dd->ssc_modfreq_mant_mask | dd->ssc_modfreq_exp_mask);
-		v |= mantissa << __ffs(dd->ssc_modfreq_mant_mask);
-		v |= exponent << __ffs(dd->ssc_modfreq_exp_mask);
+		v |= field_prep(dd->ssc_modfreq_mant_mask, mantissa);
+		v |= field_prep(dd->ssc_modfreq_exp_mask, exponent);
 		ti_clk_ll_ops->clk_writel(v, &dd->ssc_modfreq_reg);
 
 		deltam_step = dd->last_rounded_m * dd->ssc_deltam;
@@ -348,8 +349,7 @@ static void omap3_noncore_dpll_ssc_program(struct clk_hw_omap *clk)
 		if (deltam_step > 0xFFFFF)
 			deltam_step = 0xFFFFF;
 
-		deltam_ceil = (deltam_step & dd->ssc_deltam_int_mask) >>
-		    __ffs(dd->ssc_deltam_int_mask);
+		deltam_ceil = field_get(dd->ssc_deltam_int_mask, deltam_step);
 		if (deltam_step & dd->ssc_deltam_frac_mask)
 			deltam_ceil++;
 
@@ -363,8 +363,8 @@ static void omap3_noncore_dpll_ssc_program(struct clk_hw_omap *clk)
 
 		v = ti_clk_ll_ops->clk_readl(&dd->ssc_deltam_reg);
 		v &= ~(dd->ssc_deltam_int_mask | dd->ssc_deltam_frac_mask);
-		v |= deltam_step << __ffs(dd->ssc_deltam_int_mask |
-					  dd->ssc_deltam_frac_mask);
+		v |= field_prep(dd->ssc_deltam_int_mask | dd->ssc_deltam_frac_mask,
+				deltam_step);
 		ti_clk_ll_ops->clk_writel(v, &dd->ssc_deltam_reg);
 	} else {
 		ctrl &= ~dd->ssc_enable_mask;
@@ -398,7 +398,7 @@ static int omap3_noncore_dpll_program(struct clk_hw_omap *clk, u16 freqsel)
 	if (ti_clk_get_features()->flags & TI_CLK_DPLL_HAS_FREQSEL) {
 		v = ti_clk_ll_ops->clk_readl(&dd->control_reg);
 		v &= ~dd->freqsel_mask;
-		v |= freqsel << __ffs(dd->freqsel_mask);
+		v |= field_prep(dd->freqsel_mask, freqsel);
 		ti_clk_ll_ops->clk_writel(v, &dd->control_reg);
 	}
 
@@ -414,20 +414,20 @@ static int omap3_noncore_dpll_program(struct clk_hw_omap *clk, u16 freqsel)
 	}
 
 	v &= ~(dd->mult_mask | dd->div1_mask);
-	v |= dd->last_rounded_m << __ffs(dd->mult_mask);
-	v |= (dd->last_rounded_n - 1) << __ffs(dd->div1_mask);
+	v |= field_prep(dd->mult_mask, dd->last_rounded_m);
+	v |= field_prep(dd->div1_mask, dd->last_rounded_n - 1);
 
 	/* Configure dco and sd_div for dplls that have these fields */
 	if (dd->dco_mask) {
 		_lookup_dco(clk, &dco, dd->last_rounded_m, dd->last_rounded_n);
 		v &= ~(dd->dco_mask);
-		v |= dco << __ffs(dd->dco_mask);
+		v |= field_prep(dd->dco_mask, dco);
 	}
 	if (dd->sddiv_mask) {
 		_lookup_sddiv(clk, &sd_div, dd->last_rounded_m,
 			      dd->last_rounded_n);
 		v &= ~(dd->sddiv_mask);
-		v |= sd_div << __ffs(dd->sddiv_mask);
+		v |= field_prep(dd->sddiv_mask, sd_div);
 	}
 
 	/*
@@ -728,7 +728,6 @@ int omap3_noncore_dpll_set_rate_and_parent(struct clk_hw *hw,
 static u32 omap3_dpll_autoidle_read(struct clk_hw_omap *clk)
 {
 	const struct dpll_data *dd;
-	u32 v;
 
 	if (!clk || !clk->dpll_data)
 		return -EINVAL;
@@ -738,11 +737,8 @@ static u32 omap3_dpll_autoidle_read(struct clk_hw_omap *clk)
 	if (!dd->autoidle_mask)
 		return -EINVAL;
 
-	v = ti_clk_ll_ops->clk_readl(&dd->autoidle_reg);
-	v &= dd->autoidle_mask;
-	v >>= __ffs(dd->autoidle_mask);
-
-	return v;
+	return field_get(dd->autoidle_mask,
+			 ti_clk_ll_ops->clk_readl(&dd->autoidle_reg));
 }
 
 /**
@@ -774,7 +770,7 @@ static void omap3_dpll_allow_idle(struct clk_hw_omap *clk)
 	 */
 	v = ti_clk_ll_ops->clk_readl(&dd->autoidle_reg);
 	v &= ~dd->autoidle_mask;
-	v |= DPLL_AUTOIDLE_LOW_POWER_STOP << __ffs(dd->autoidle_mask);
+	v |= field_prep(dd->autoidle_mask, DPLL_AUTOIDLE_LOW_POWER_STOP);
 	ti_clk_ll_ops->clk_writel(v, &dd->autoidle_reg);
 }
 
@@ -799,7 +795,7 @@ static void omap3_dpll_deny_idle(struct clk_hw_omap *clk)
 
 	v = ti_clk_ll_ops->clk_readl(&dd->autoidle_reg);
 	v &= ~dd->autoidle_mask;
-	v |= DPLL_AUTOIDLE_DISABLE << __ffs(dd->autoidle_mask);
+	v |= field_prep(dd->autoidle_mask, DPLL_AUTOIDLE_DISABLE);
 	ti_clk_ll_ops->clk_writel(v, &dd->autoidle_reg);
 }
 
@@ -857,8 +853,8 @@ unsigned long omap3_clkoutx2_recalc(struct clk_hw *hw,
 
 	WARN_ON(!dd->enable_mask);
 
-	v = ti_clk_ll_ops->clk_readl(&dd->control_reg) & dd->enable_mask;
-	v >>= __ffs(dd->enable_mask);
+	v = field_get(dd->enable_mask,
+		      ti_clk_ll_ops->clk_readl(&dd->control_reg));
 	if ((v != OMAP3XXX_EN_DPLL_LOCKED) || (dd->flags & DPLL_J_TYPE))
 		rate = parent_rate;
 	else
@@ -877,19 +873,17 @@ int omap3_core_dpll_save_context(struct clk_hw *hw)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	struct dpll_data *dd;
-	u32 v;
 
 	dd = clk->dpll_data;
 
-	v = ti_clk_ll_ops->clk_readl(&dd->control_reg);
-	clk->context = (v & dd->enable_mask) >> __ffs(dd->enable_mask);
+	clk->context = field_get(dd->enable_mask,
+				 ti_clk_ll_ops->clk_readl(&dd->control_reg));
 
 	if (clk->context == DPLL_LOCKED) {
-		v = ti_clk_ll_ops->clk_readl(&dd->mult_div1_reg);
-		dd->last_rounded_m = (v & dd->mult_mask) >>
-						__ffs(dd->mult_mask);
-		dd->last_rounded_n = ((v & dd->div1_mask) >>
-						__ffs(dd->div1_mask)) + 1;
+		u32 v = ti_clk_ll_ops->clk_readl(&dd->mult_div1_reg);
+
+		dd->last_rounded_m = field_get(dd->mult_mask, v);
+		dd->last_rounded_n = field_get(dd->div1_mask, v) + 1;
 	}
 
 	return 0;
@@ -916,8 +910,8 @@ void omap3_core_dpll_restore_context(struct clk_hw *hw)
 
 		v = ti_clk_ll_ops->clk_readl(&dd->mult_div1_reg);
 		v &= ~(dd->mult_mask | dd->div1_mask);
-		v |= dd->last_rounded_m << __ffs(dd->mult_mask);
-		v |= (dd->last_rounded_n - 1) << __ffs(dd->div1_mask);
+		v |= field_prep(dd->mult_mask, dd->last_rounded_m);
+		v |= field_prep(dd->div1_mask, dd->last_rounded_n - 1);
 		ti_clk_ll_ops->clk_writel(v, &dd->mult_div1_reg);
 
 		_omap3_dpll_write_clken(clk, DPLL_LOCKED);
@@ -938,19 +932,17 @@ int omap3_noncore_dpll_save_context(struct clk_hw *hw)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	struct dpll_data *dd;
-	u32 v;
 
 	dd = clk->dpll_data;
 
-	v = ti_clk_ll_ops->clk_readl(&dd->control_reg);
-	clk->context = (v & dd->enable_mask) >> __ffs(dd->enable_mask);
+	clk->context = field_get(dd->enable_mask,
+				 ti_clk_ll_ops->clk_readl(&dd->control_reg));
 
 	if (clk->context == DPLL_LOCKED) {
-		v = ti_clk_ll_ops->clk_readl(&dd->mult_div1_reg);
-		dd->last_rounded_m = (v & dd->mult_mask) >>
-						__ffs(dd->mult_mask);
-		dd->last_rounded_n = ((v & dd->div1_mask) >>
-						__ffs(dd->div1_mask)) + 1;
+		u32 v = ti_clk_ll_ops->clk_readl(&dd->mult_div1_reg);
+
+		dd->last_rounded_m = field_get(dd->mult_mask, v);
+		dd->last_rounded_n = field_get(dd->div1_mask, v) + 1;
 	}
 
 	return 0;
@@ -974,12 +966,9 @@ void omap3_noncore_dpll_restore_context(struct clk_hw *hw)
 	ctrl = ti_clk_ll_ops->clk_readl(&dd->control_reg);
 	mult_div1 = ti_clk_ll_ops->clk_readl(&dd->mult_div1_reg);
 
-	if (clk->context == ((ctrl & dd->enable_mask) >>
-			     __ffs(dd->enable_mask)) &&
-	    dd->last_rounded_m == ((mult_div1 & dd->mult_mask) >>
-				   __ffs(dd->mult_mask)) &&
-	    dd->last_rounded_n == ((mult_div1 & dd->div1_mask) >>
-				   __ffs(dd->div1_mask)) + 1) {
+	if (clk->context == field_get(dd->enable_mask, ctrl) &&
+	    dd->last_rounded_m == field_get(dd->mult_mask, mult_div1) &&
+	    dd->last_rounded_n == field_get(dd->div1_mask, mult_div1) + 1) {
 		/* nothing to be done */
 		return;
 	}
-- 
2.25.1

