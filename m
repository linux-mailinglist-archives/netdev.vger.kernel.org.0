Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC0F34A3CF
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhCZJLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:11:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:55374 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhCZJLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 05:11:06 -0400
IronPort-SDR: sSuvITzQfxujkQP75KxeaFR+cRJ2XU+m4Ace8qodvulht/fioprPbzjzb22XgZXd73KKVV+DAa
 zDKyPyDY2l6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191142628"
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="191142628"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 02:11:05 -0700
IronPort-SDR: TSNpPYngjz1bCdJYwcrM5FrvgT970Uy9njyWKJv1snBYWQKILjtzkcJJTfKHnTNHnPflxV6olg
 KIYvnOQdJP1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="594113441"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga005.jf.intel.com with ESMTP; 26 Mar 2021 02:10:57 -0700
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net-next] net: stmmac: Fix kernel panic due to NULL pointer dereference of fpe_cfg
Date:   Fri, 26 Mar 2021 17:10:46 +0800
Message-Id: <20210326091046.26391-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

In this patch, "net: stmmac: support FPE link partner hand-shaking
procedure", priv->plat->fpe_cfg wouldn`t be "devm_kzalloc"ed if
dma_cap->frpsel is 0 (Flexible Rx Parser is not supported in SoC) in
tc_init(). So, fpe_cfg will be remain as NULL and accessing it will cause
kernel panic.

To fix this, move the "devm_kzalloc"ing of priv->plat->fpe_cfg before
dma_cap->frpsel checking in tc_init(). Additionally, checking of
priv->dma_cap.fpesel is added before calling stmmac_fpe_link_state_handle()
as only FPE supported SoC is allowed to call the function.

Below is the kernel panic dump reported by Marek Szyprowski
<m.szyprowski@samsung.com>:

meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.0:00] driver [RTL8211F Gigabit Ethernet] (irq=35)
meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rgmii link mode
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000001
Mem abort info:
...
user pgtable: 4k pages, 48-bit VAs, pgdp=00000000044eb000
[0000000000000001] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in: dw_hdmi_i2s_audio dw_hdmi_cec meson_gxl realtek meson_gxbb_wdt snd_soc_meson_axg_sound_card dwmac_generic axg_audio meson_dw_hdmi crct10dif_ce snd_soc_meson_card_utils snd_soc_meson_axg_tdmout panfrost rc_odroid gpu_sched reset_meson_audio_arb meson_ir snd_soc_meson_g12a_tohdmitx snd_soc_meson_axg_frddr sclk_div clk_phase snd_soc_meson_codec_glue dwmac_meson8b snd_soc_meson_axg_fifo stmmac_platform meson_rng meson_drm stmmac rtc_meson_vrtc rng_core meson_canvas pwm_meson dw_hdmi mdio_mux_meson_g12a pcs_xpcs snd_soc_meson_axg_tdm_interface snd_soc_meson_axg_tdm_formatter nvmem_meson_efuse display_connector
CPU: 1 PID: 7 Comm: kworker/u8:0 Not tainted 5.12.0-rc4-next-20210325+
Hardware name: Hardkernel ODROID-C4 (DT)
Workqueue: events_power_efficient phylink_resolve
pstate: 20400009 (nzCv daif +PAN -UAO -TCO BTYPE=--)
pc : stmmac_mac_link_up+0x14c/0x348 [stmmac]
lr : stmmac_mac_link_up+0x284/0x348 [stmmac] ...
Call trace:
 stmmac_mac_link_up+0x14c/0x348 [stmmac]
 phylink_resolve+0x104/0x420
 process_one_work+0x2a8/0x718
 worker_thread+0x48/0x460
 kthread+0x134/0x160
 ret_from_fork+0x10/0x18
Code: b971ba60 350007c0 f958c260 f9402000 (39400401)
---[ end trace 0c9deb6c510228aa ]---

Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking
procedure")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 ++++--
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 +++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 170296820af0..27faf5e49360 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -997,7 +997,8 @@ static void stmmac_mac_link_down(struct phylink_config *config,
 	stmmac_eee_init(priv);
 	stmmac_set_eee_pls(priv, priv->hw, false);
 
-	stmmac_fpe_link_state_handle(priv, false);
+	if (priv->dma_cap.fpesel)
+		stmmac_fpe_link_state_handle(priv, false);
 }
 
 static void stmmac_mac_link_up(struct phylink_config *config,
@@ -1097,7 +1098,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		stmmac_set_eee_pls(priv, priv->hw, true);
 	}
 
-	stmmac_fpe_link_state_handle(priv, true);
+	if (priv->dma_cap.fpesel)
+		stmmac_fpe_link_state_handle(priv, true);
 }
 
 static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 1d84ee359808..4e70efc45458 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -254,6 +254,16 @@ static int tc_init(struct stmmac_priv *priv)
 			 priv->flow_entries_max);
 	}
 
+	if (!priv->plat->fpe_cfg) {
+		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
+						   sizeof(*priv->plat->fpe_cfg),
+						   GFP_KERNEL);
+		if (!priv->plat->fpe_cfg)
+			return -ENOMEM;
+	} else {
+		memset(priv->plat->fpe_cfg, 0, sizeof(*priv->plat->fpe_cfg));
+	}
+
 	/* Fail silently as we can still use remaining features, e.g. CBS */
 	if (!dma_cap->frpsel)
 		return 0;
@@ -298,16 +308,6 @@ static int tc_init(struct stmmac_priv *priv)
 	dev_info(priv->device, "Enabling HW TC (entries=%d, max_off=%d)\n",
 			priv->tc_entries_max, priv->tc_off_max);
 
-	if (!priv->plat->fpe_cfg) {
-		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
-						   sizeof(*priv->plat->fpe_cfg),
-						   GFP_KERNEL);
-		if (!priv->plat->fpe_cfg)
-			return -ENOMEM;
-	} else {
-		memset(priv->plat->fpe_cfg, 0, sizeof(*priv->plat->fpe_cfg));
-	}
-
 	return 0;
 }
 
-- 
2.17.1

