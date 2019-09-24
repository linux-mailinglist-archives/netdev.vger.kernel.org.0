Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09497BC800
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 14:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440951AbfIXMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 08:40:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55140 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440880AbfIXMkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 08:40:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so2118565wmp.4
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 05:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SsMkvTjzqdcv1JEo+MfolD/Ondy618koO6p8isgB+tw=;
        b=HgPKDdhOnAeLQm9SK/0nwZRUzwOab0z6FPeRchFJ+g04K0hEZN3gL8hRktqH3MQfWh
         hIeRvI/O5kscFgS5Ex0xya/vKvZzw+bbFvzYdZpQwioqLlPIVZK1uO7wjAvpDUdxAEZV
         sJ7FEBF53gCCh0BpYPK6A8sWk6o9n/anHKcSMKfQZwX7qEz61Hvf3Gbmp1ZNmCtEhXu8
         it3BjGuoU7fbbSB1NfsPOnENFWia9JKCgSxvDPDeU2IpLIycND+QtEffZgdv10LhecvF
         q/tY4cTKDQaqaF1awpV0seTPj3MSoDVPNiL4npGT6f35G3kmKrVAQpsbE5LLKQ4+Ss3L
         qIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsMkvTjzqdcv1JEo+MfolD/Ondy618koO6p8isgB+tw=;
        b=dGj77rGu8DRBN37YSZHreIuBKoP6jZpHLUxWST1HO4zfSf9BkL8IE47O8wfzqScMJB
         Axbvd97XgAdm0GxZHlsJZGTQ7nbuj7RZOySlzIJ0MB6+Orj1mLQWoQvcHSW1TQeFkGCs
         yS1OhUXOq0p1W6rTm8cpE7ScO3VlMbAuCEEQRDS/F1D10X/jj4fvpFvHhHZiy0MrBcXY
         c8SSwTJFGhzIPIYzhYypwdwk/e/ZeE/MWvtrclIZ8IYItU1l/J/YFnHbhWZ1WraplTRE
         m0HATYnepHgb5dqT976nxNK/k4Dcv6kvtvgvyvM+7/0e0RMVPSe0fNDAsAduysQcVzey
         vgvQ==
X-Gm-Message-State: APjAAAWk96ZCbIGUKuXjhTdKYH1luUmC0Sd8jV3TNXju9sMv3PlzVtPi
        VzlvScBZU1ZPy5EHMi0rwtFyLg==
X-Google-Smtp-Source: APXvYqwhd6HKsNf6x/UVStz+5R20IfOFptFTqKEKERT9VnXEhCxUEH1/aOaV7bSWG8nwf44HSVJXVQ==
X-Received: by 2002:a1c:7704:: with SMTP id t4mr2558489wmi.133.1569328810562;
        Tue, 24 Sep 2019 05:40:10 -0700 (PDT)
Received: from starbuck.baylibre.local (uluru.liltaz.com. [163.172.81.188])
        by smtp.googlemail.com with ESMTPSA id u83sm2888165wme.0.2019.09.24.05.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 05:40:10 -0700 (PDT)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     Jerome Brunet <jbrunet@baylibre.com>, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Tero Kristo <t-kristo@ti.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH 2/3] clk: let init callback return an error code
Date:   Tue, 24 Sep 2019 14:39:53 +0200
Message-Id: <20190924123954.31561-3-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190924123954.31561-1-jbrunet@baylibre.com>
References: <20190924123954.31561-1-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the init callback is allowed to request resources, it needs a return
value to report the outcome of such a request.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
---

 Sorry about the spam.
 This patch change quite a few files so I have tried to Cc the
 relevant people. Stephen, You may notice that I have added a
 couple of the network people. You need an Ack from one of them
 since the Amlogic G12a mdio mux has a clock which uses the .init()
 callback

 drivers/clk/clk.c                     | 17 ++++++++++------
 drivers/clk/meson/clk-mpll.c          |  4 +++-
 drivers/clk/meson/clk-phase.c         |  4 +++-
 drivers/clk/meson/clk-pll.c           |  4 +++-
 drivers/clk/meson/sclk-div.c          |  4 +++-
 drivers/clk/microchip/clk-core.c      |  8 ++++++--
 drivers/clk/mmp/clk-frac.c            |  4 +++-
 drivers/clk/mmp/clk-mix.c             |  4 +++-
 drivers/clk/qcom/clk-hfpll.c          |  6 ++++--
 drivers/clk/rockchip/clk-pll.c        | 28 ++++++++++++++++-----------
 drivers/clk/ti/clock.h                |  2 +-
 drivers/clk/ti/clockdomain.c          |  8 +++++---
 drivers/net/phy/mdio-mux-meson-g12a.c |  4 +++-
 include/linux/clk-provider.h          | 10 +++++++---
 14 files changed, 72 insertions(+), 35 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 232144cca6cf..df853a98fad2 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3298,16 +3298,21 @@ static int __clk_core_init(struct clk_core *core)
 	 * optional platform-specific magic
 	 *
 	 * The .init callback is not used by any of the basic clock types, but
-	 * exists for weird hardware that must perform initialization magic.
-	 * Please consider other ways of solving initialization problems before
-	 * using this callback, as its use is discouraged.
+	 * exists for weird hardware that must perform initialization magic for
+	 * CCF to get an accurate view of clock for any other callbacks. It may
+	 * also be used needs to perform dynamic allocations. Such allocation
+	 * must be freed in the terminate() callback.
+	 * This callback shall not be used to initialize the parameters state,
+	 * such as rate, parent, etc ...
 	 *
 	 * If it exist, this callback should called before any other callback of
 	 * the clock
 	 */
-	if (core->ops->init)
-		core->ops->init(core->hw);
-
+	if (core->ops->init) {
+		ret = core->ops->init(core->hw);
+		if (ret)
+			goto out;
+	}
 
 	core->parent = __clk_init_parent(core);
 
diff --git a/drivers/clk/meson/clk-mpll.c b/drivers/clk/meson/clk-mpll.c
index 2d39a8bc367c..fc9df4860872 100644
--- a/drivers/clk/meson/clk-mpll.c
+++ b/drivers/clk/meson/clk-mpll.c
@@ -129,7 +129,7 @@ static int mpll_set_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static void mpll_init(struct clk_hw *hw)
+static int mpll_init(struct clk_hw *hw)
 {
 	struct clk_regmap *clk = to_clk_regmap(hw);
 	struct meson_clk_mpll_data *mpll = meson_clk_mpll_data(clk);
@@ -151,6 +151,8 @@ static void mpll_init(struct clk_hw *hw)
 	/* Set the magic misc bit if required */
 	if (MESON_PARM_APPLICABLE(&mpll->misc))
 		meson_parm_write(clk->map, &mpll->misc, 1);
+
+	return 0;
 }
 
 const struct clk_ops meson_clk_mpll_ro_ops = {
diff --git a/drivers/clk/meson/clk-phase.c b/drivers/clk/meson/clk-phase.c
index 80c3ada193a4..fe22e171121a 100644
--- a/drivers/clk/meson/clk-phase.c
+++ b/drivers/clk/meson/clk-phase.c
@@ -78,7 +78,7 @@ meson_clk_triphase_data(struct clk_regmap *clk)
 	return (struct meson_clk_triphase_data *)clk->data;
 }
 
-static void meson_clk_triphase_sync(struct clk_hw *hw)
+static int meson_clk_triphase_sync(struct clk_hw *hw)
 {
 	struct clk_regmap *clk = to_clk_regmap(hw);
 	struct meson_clk_triphase_data *tph = meson_clk_triphase_data(clk);
@@ -88,6 +88,8 @@ static void meson_clk_triphase_sync(struct clk_hw *hw)
 	val = meson_parm_read(clk->map, &tph->ph0);
 	meson_parm_write(clk->map, &tph->ph1, val);
 	meson_parm_write(clk->map, &tph->ph2, val);
+
+	return 0;
 }
 
 static int meson_clk_triphase_get_phase(struct clk_hw *hw)
diff --git a/drivers/clk/meson/clk-pll.c b/drivers/clk/meson/clk-pll.c
index ddb1e5634739..489092dde3a6 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -277,7 +277,7 @@ static int meson_clk_pll_wait_lock(struct clk_hw *hw)
 	return -ETIMEDOUT;
 }
 
-static void meson_clk_pll_init(struct clk_hw *hw)
+static int meson_clk_pll_init(struct clk_hw *hw)
 {
 	struct clk_regmap *clk = to_clk_regmap(hw);
 	struct meson_clk_pll_data *pll = meson_clk_pll_data(clk);
@@ -288,6 +288,8 @@ static void meson_clk_pll_init(struct clk_hw *hw)
 				       pll->init_count);
 		meson_parm_write(clk->map, &pll->rst, 0);
 	}
+
+	return 0;
 }
 
 static int meson_clk_pll_is_enabled(struct clk_hw *hw)
diff --git a/drivers/clk/meson/sclk-div.c b/drivers/clk/meson/sclk-div.c
index 3acf03780221..76d31c0a3342 100644
--- a/drivers/clk/meson/sclk-div.c
+++ b/drivers/clk/meson/sclk-div.c
@@ -216,7 +216,7 @@ static int sclk_div_is_enabled(struct clk_hw *hw)
 	return 0;
 }
 
-static void sclk_div_init(struct clk_hw *hw)
+static int sclk_div_init(struct clk_hw *hw)
 {
 	struct clk_regmap *clk = to_clk_regmap(hw);
 	struct meson_sclk_div_data *sclk = meson_sclk_div_data(clk);
@@ -231,6 +231,8 @@ static void sclk_div_init(struct clk_hw *hw)
 		sclk->cached_div = val + 1;
 
 	sclk_div_get_duty_cycle(hw, &sclk->cached_duty);
+
+	return 0;
 }
 
 const struct clk_ops meson_sclk_div_ops = {
diff --git a/drivers/clk/microchip/clk-core.c b/drivers/clk/microchip/clk-core.c
index 567755d6f844..1b4f023cdc8b 100644
--- a/drivers/clk/microchip/clk-core.c
+++ b/drivers/clk/microchip/clk-core.c
@@ -266,10 +266,12 @@ static void roclk_disable(struct clk_hw *hw)
 	writel(REFO_ON | REFO_OE, PIC32_CLR(refo->ctrl_reg));
 }
 
-static void roclk_init(struct clk_hw *hw)
+static int roclk_init(struct clk_hw *hw)
 {
 	/* initialize clock in disabled state */
 	roclk_disable(hw);
+
+	return 0;
 }
 
 static u8 roclk_get_parent(struct clk_hw *hw)
@@ -880,7 +882,7 @@ static int sclk_set_parent(struct clk_hw *hw, u8 index)
 	return err;
 }
 
-static void sclk_init(struct clk_hw *hw)
+static int sclk_init(struct clk_hw *hw)
 {
 	struct pic32_sys_clk *sclk = clkhw_to_sys_clk(hw);
 	unsigned long flags;
@@ -899,6 +901,8 @@ static void sclk_init(struct clk_hw *hw)
 		writel(v, sclk->slew_reg);
 		spin_unlock_irqrestore(&sclk->core->reg_lock, flags);
 	}
+
+	return 0;
 }
 
 /* sclk with post-divider */
diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index 90bf181f191a..fabc09aca6c4 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -109,7 +109,7 @@ static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
 	return 0;
 }
 
-static void clk_factor_init(struct clk_hw *hw)
+static int clk_factor_init(struct clk_hw *hw)
 {
 	struct mmp_clk_factor *factor = to_clk_factor(hw);
 	struct mmp_clk_factor_masks *masks = factor->masks;
@@ -146,6 +146,8 @@ static void clk_factor_init(struct clk_hw *hw)
 
 	if (factor->lock)
 		spin_unlock_irqrestore(factor->lock, flags);
+
+	return 0;
 }
 
 static const struct clk_ops clk_factor_ops = {
diff --git a/drivers/clk/mmp/clk-mix.c b/drivers/clk/mmp/clk-mix.c
index 90814b2613c0..d2cd36c54474 100644
--- a/drivers/clk/mmp/clk-mix.c
+++ b/drivers/clk/mmp/clk-mix.c
@@ -419,12 +419,14 @@ static int mmp_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	}
 }
 
-static void mmp_clk_mix_init(struct clk_hw *hw)
+static int mmp_clk_mix_init(struct clk_hw *hw)
 {
 	struct mmp_clk_mix *mix = to_clk_mix(hw);
 
 	if (mix->table)
 		_filter_clk_table(mix, mix->table, mix->table_size);
+
+	return 0;
 }
 
 const struct clk_ops mmp_clk_mix_ops = {
diff --git a/drivers/clk/qcom/clk-hfpll.c b/drivers/clk/qcom/clk-hfpll.c
index 3c04805f2a55..e847d586a73a 100644
--- a/drivers/clk/qcom/clk-hfpll.c
+++ b/drivers/clk/qcom/clk-hfpll.c
@@ -196,7 +196,7 @@ static unsigned long clk_hfpll_recalc_rate(struct clk_hw *hw,
 	return l_val * parent_rate;
 }
 
-static void clk_hfpll_init(struct clk_hw *hw)
+static int clk_hfpll_init(struct clk_hw *hw)
 {
 	struct clk_hfpll *h = to_clk_hfpll(hw);
 	struct hfpll_data const *hd = h->d;
@@ -206,7 +206,7 @@ static void clk_hfpll_init(struct clk_hw *hw)
 	regmap_read(regmap, hd->mode_reg, &mode);
 	if (mode != (PLL_BYPASSNL | PLL_RESET_N | PLL_OUTCTRL)) {
 		__clk_hfpll_init_once(hw);
-		return;
+		return 0;
 	}
 
 	if (hd->status_reg) {
@@ -218,6 +218,8 @@ static void clk_hfpll_init(struct clk_hw *hw)
 			__clk_hfpll_init_once(hw);
 		}
 	}
+
+	return 0;
 }
 
 static int hfpll_is_enabled(struct clk_hw *hw)
diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index 198417d56300..10560d963baf 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -282,7 +282,7 @@ static int rockchip_rk3036_pll_is_enabled(struct clk_hw *hw)
 	return !(pllcon & RK3036_PLLCON1_PWRDOWN);
 }
 
-static void rockchip_rk3036_pll_init(struct clk_hw *hw)
+static int rockchip_rk3036_pll_init(struct clk_hw *hw)
 {
 	struct rockchip_clk_pll *pll = to_rockchip_clk_pll(hw);
 	const struct rockchip_pll_rate_table *rate;
@@ -290,14 +290,14 @@ static void rockchip_rk3036_pll_init(struct clk_hw *hw)
 	unsigned long drate;
 
 	if (!(pll->flags & ROCKCHIP_PLL_SYNC_RATE))
-		return;
+		return 0;
 
 	drate = clk_hw_get_rate(hw);
 	rate = rockchip_get_pll_settings(pll, drate);
 
 	/* when no rate setting for the current rate, rely on clk_set_rate */
 	if (!rate)
-		return;
+		return 0;
 
 	rockchip_rk3036_pll_get_params(pll, &cur);
 
@@ -319,13 +319,15 @@ static void rockchip_rk3036_pll_init(struct clk_hw *hw)
 		if (!parent) {
 			pr_warn("%s: parent of %s not available\n",
 				__func__, __clk_get_name(hw->clk));
-			return;
+			return 0;
 		}
 
 		pr_debug("%s: pll %s: rate params do not match rate table, adjusting\n",
 			 __func__, __clk_get_name(hw->clk));
 		rockchip_rk3036_pll_set_params(pll, rate);
 	}
+
+	return 0;
 }
 
 static const struct clk_ops rockchip_rk3036_pll_clk_norate_ops = {
@@ -515,7 +517,7 @@ static int rockchip_rk3066_pll_is_enabled(struct clk_hw *hw)
 	return !(pllcon & RK3066_PLLCON3_PWRDOWN);
 }
 
-static void rockchip_rk3066_pll_init(struct clk_hw *hw)
+static int rockchip_rk3066_pll_init(struct clk_hw *hw)
 {
 	struct rockchip_clk_pll *pll = to_rockchip_clk_pll(hw);
 	const struct rockchip_pll_rate_table *rate;
@@ -523,14 +525,14 @@ static void rockchip_rk3066_pll_init(struct clk_hw *hw)
 	unsigned long drate;
 
 	if (!(pll->flags & ROCKCHIP_PLL_SYNC_RATE))
-		return;
+		return 0;
 
 	drate = clk_hw_get_rate(hw);
 	rate = rockchip_get_pll_settings(pll, drate);
 
 	/* when no rate setting for the current rate, rely on clk_set_rate */
 	if (!rate)
-		return;
+		return 0;
 
 	rockchip_rk3066_pll_get_params(pll, &cur);
 
@@ -543,6 +545,8 @@ static void rockchip_rk3066_pll_init(struct clk_hw *hw)
 			 __func__, clk_hw_get_name(hw));
 		rockchip_rk3066_pll_set_params(pll, rate);
 	}
+
+	return 0;
 }
 
 static const struct clk_ops rockchip_rk3066_pll_clk_norate_ops = {
@@ -761,7 +765,7 @@ static int rockchip_rk3399_pll_is_enabled(struct clk_hw *hw)
 	return !(pllcon & RK3399_PLLCON3_PWRDOWN);
 }
 
-static void rockchip_rk3399_pll_init(struct clk_hw *hw)
+static int rockchip_rk3399_pll_init(struct clk_hw *hw)
 {
 	struct rockchip_clk_pll *pll = to_rockchip_clk_pll(hw);
 	const struct rockchip_pll_rate_table *rate;
@@ -769,14 +773,14 @@ static void rockchip_rk3399_pll_init(struct clk_hw *hw)
 	unsigned long drate;
 
 	if (!(pll->flags & ROCKCHIP_PLL_SYNC_RATE))
-		return;
+		return 0;
 
 	drate = clk_hw_get_rate(hw);
 	rate = rockchip_get_pll_settings(pll, drate);
 
 	/* when no rate setting for the current rate, rely on clk_set_rate */
 	if (!rate)
-		return;
+		return 0;
 
 	rockchip_rk3399_pll_get_params(pll, &cur);
 
@@ -798,13 +802,15 @@ static void rockchip_rk3399_pll_init(struct clk_hw *hw)
 		if (!parent) {
 			pr_warn("%s: parent of %s not available\n",
 				__func__, __clk_get_name(hw->clk));
-			return;
+			return 0;
 		}
 
 		pr_debug("%s: pll %s: rate params do not match rate table, adjusting\n",
 			 __func__, __clk_get_name(hw->clk));
 		rockchip_rk3399_pll_set_params(pll, rate);
 	}
+
+	return 0;
 }
 
 static const struct clk_ops rockchip_rk3399_pll_clk_norate_ops = {
diff --git a/drivers/clk/ti/clock.h b/drivers/clk/ti/clock.h
index e4b8392ff63c..adef9c16e43b 100644
--- a/drivers/clk/ti/clock.h
+++ b/drivers/clk/ti/clock.h
@@ -252,7 +252,7 @@ extern const struct clk_ops omap_gate_clk_ops;
 
 extern struct ti_clk_features ti_clk_features;
 
-void omap2_init_clk_clkdm(struct clk_hw *hw);
+int omap2_init_clk_clkdm(struct clk_hw *hw);
 int omap2_clkops_enable_clkdm(struct clk_hw *hw);
 void omap2_clkops_disable_clkdm(struct clk_hw *hw);
 
diff --git a/drivers/clk/ti/clockdomain.c b/drivers/clk/ti/clockdomain.c
index 423a99b9f10c..ee56306f79d5 100644
--- a/drivers/clk/ti/clockdomain.c
+++ b/drivers/clk/ti/clockdomain.c
@@ -101,16 +101,16 @@ void omap2_clkops_disable_clkdm(struct clk_hw *hw)
  *
  * Convert a clockdomain name stored in a struct clk 'clk' into a
  * clockdomain pointer, and save it into the struct clk.  Intended to be
- * called during clk_register().  No return value.
+ * called during clk_register(). Returns 0 on success, -EERROR otherwise.
  */
-void omap2_init_clk_clkdm(struct clk_hw *hw)
+int omap2_init_clk_clkdm(struct clk_hw *hw)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	struct clockdomain *clkdm;
 	const char *clk_name;
 
 	if (!clk->clkdm_name)
-		return;
+		return 0;
 
 	clk_name = __clk_get_name(hw->clk);
 
@@ -123,6 +123,8 @@ void omap2_init_clk_clkdm(struct clk_hw *hw)
 		pr_debug("clock: could not associate clk %s to clkdm %s\n",
 			 clk_name, clk->clkdm_name);
 	}
+
+	return 0;
 }
 
 static void __init of_ti_clockdomain_setup(struct device_node *node)
diff --git a/drivers/net/phy/mdio-mux-meson-g12a.c b/drivers/net/phy/mdio-mux-meson-g12a.c
index 7a9ad54582e1..bf86c9c7a288 100644
--- a/drivers/net/phy/mdio-mux-meson-g12a.c
+++ b/drivers/net/phy/mdio-mux-meson-g12a.c
@@ -123,7 +123,7 @@ static int g12a_ephy_pll_is_enabled(struct clk_hw *hw)
 	return (val & PLL_CTL0_LOCK_DIG) ? 1 : 0;
 }
 
-static void g12a_ephy_pll_init(struct clk_hw *hw)
+static int g12a_ephy_pll_init(struct clk_hw *hw)
 {
 	struct g12a_ephy_pll *pll = g12a_ephy_pll_to_dev(hw);
 
@@ -136,6 +136,8 @@ static void g12a_ephy_pll_init(struct clk_hw *hw)
 	writel(0x20200000, pll->base + ETH_PLL_CTL5);
 	writel(0x0000c002, pll->base + ETH_PLL_CTL6);
 	writel(0x00000023, pll->base + ETH_PLL_CTL7);
+
+	return 0;
 }
 
 static const struct clk_ops g12a_ephy_pll_ops = {
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 2fdfe8061363..b82ec4c4ca95 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -190,8 +190,12 @@ struct clk_duty {
  *
  * @init:	Perform platform-specific initialization magic.
  *		This is not not used by any of the basic clock types.
- *		Please consider other ways of solving initialization problems
- *		before using this callback, as its use is discouraged.
+ *		This callback exist for HW which needs to perform some
+ *		initialisation magic for CCF to get an accurate view of the
+ *		clock. It may also be used dynamic resource allocation is
+ *		required. It shall not used to deal with clock parameters,
+ *		such as rate or parents.
+ *		Returns 0 on success, -EERROR otherwise.
  *
  * @debug_init:	Set up type-specific debugfs entries for this clock.  This
  *		is called once, after the debugfs directory entry for this
@@ -243,7 +247,7 @@ struct clk_ops {
 					  struct clk_duty *duty);
 	int		(*set_duty_cycle)(struct clk_hw *hw,
 					  struct clk_duty *duty);
-	void		(*init)(struct clk_hw *hw);
+	int		(*init)(struct clk_hw *hw);
 	void		(*debug_init)(struct clk_hw *hw, struct dentry *dentry);
 };
 
-- 
2.21.0

