Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFCEA6A0B
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbfICNh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:37:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:13478 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfICNh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 09:37:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 06:37:44 -0700
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="183556492"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 06:37:41 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     jani.nikula@intel.com,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/2] drm: convert to use yesno(), onoff(), enableddisabled(), plural() helpers
Date:   Tue,  3 Sep 2019 16:37:31 +0300
Message-Id: <20190903133731.2094-2-jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903133731.2094-1-jani.nikula@intel.com>
References: <20190903133731.2094-1-jani.nikula@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THIS IS NOT FOR MERGING; DEMO FOR PREVIOUS PATCH ONLY!

Further conversion should be done incrementally and by
driver/subsystem. This here is the result of running the following on
the below cocci patch:

$ spatch --sp-file yesno.cocci --in-place --dir drivers/gpu/drm

I wish I knew how to not duplicate stuff in the cocci patch so much...

@enableddisabled@
expression E;
@@
(
- (E) ? "enabled" : "disabled"
+ enableddisabled(E)
|
- E ? "enabled" : "disabled"
+ enableddisabled(E)
)

@reverse_enableddisabled@
expression A, B;
@@
(
- (A == B) ? "disabled" : "enabled"
+ enableddisabled(A != B)
|
- (A != B) ? "disabled" : "enabled"
+ enableddisabled(A == B)
|
- A == B ? "disabled" : "enabled"
+ enableddisabled(A != B)
|
- A != B ? "disabled" : "enabled"
+ enableddisabled(A == B)
|
- A ? "disabled" : "enabled"
+ enableddisabled(!A)
)

@yesno@
expression E;
@@
(
- (E) ? "yes" : "no"
+ yesno(E)
|
- E ? "yes" : "no"
+ yesno(E)
)

@reverse_yesno@
expression A, B;
@@
(
- (A == B) ? "no" : "yes"
+ yesno(A != B)
|
- (A != B) ? "no" : "yes"
+ yesno(A == B)
|
- A == B ? "no" : "yes"
+ yesno(A != B)
|
- A != B ? "no" : "yes"
+ yesno(A == B)
|
- A ? "no" : "yes"
+ yesno(!A)
)

@onoff@
expression E;
@@
(
- (E) ? "on" : "off"
+ onoff(E)
|
- E ? "on" : "off"
+ onoff(E)
)

@reverse_onoff@
expression A, B;
@@
(
- (A == B) ? "off" : "on"
+ onoff(A != B)
|
- (A != B) ? "off" : "on"
+ onoff(A == B)
|
- A == B ? "off" : "on"
+ onoff(A != B)
|
- A != B ? "off" : "on"
+ onoff(A == B)
|
- A ? "off" : "on"
+ onoff(!A)
)

@plural@
expression E;
@@
(
- (E > 1) ? "s" : ""
+ plural(E)
|
- E > 1 ? "s" : ""
+ plural(E)
|
- (E == 1) ? "" : "s"
+ plural(E)
|
- E == 1 ? "" : "s"
+ plural(E)
)

Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: Vishal Kulkarni <vishal@chelsio.com>
Cc: netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  2 +-
 drivers/gpu/drm/amd/amdgpu/atom.c                  |  2 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c |  3 ++-
 drivers/gpu/drm/bridge/tc358767.c                  |  2 +-
 drivers/gpu/drm/drm_client_modeset.c               |  2 +-
 drivers/gpu/drm/drm_dp_helper.c                    |  2 +-
 drivers/gpu/drm/drm_edid_load.c                    |  2 +-
 drivers/gpu/drm/drm_gem.c                          |  2 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |  2 +-
 drivers/gpu/drm/omapdrm/dss/dispc.c                |  2 +-
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |  6 ++----
 drivers/gpu/drm/qxl/qxl_display.c                  |  2 +-
 drivers/gpu/drm/radeon/atom.c                      |  2 +-
 drivers/gpu/drm/radeon/radeon_acpi.c               |  2 +-
 drivers/gpu/drm/sti/sti_hda.c                      |  4 ++--
 drivers/gpu/drm/sti/sti_tvout.c                    |  2 +-
 drivers/gpu/drm/sun4i/sun4i_backend.c              |  2 +-
 drivers/gpu/drm/sun4i/sun8i_ui_layer.c             |  2 +-
 drivers/gpu/drm/v3d/v3d_debugfs.c                  | 10 +++++-----
 drivers/gpu/drm/virtio/virtgpu_debugfs.c           |  2 +-
 22 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 1e41367ef74e..65f0ee0f4ccd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -292,7 +292,7 @@ static int amdgpu_atif_get_notification_params(struct amdgpu_atif *atif)
 
 out:
 	DRM_DEBUG_DRIVER("Notification %s, command code = %#x\n",
-			(n->enabled ? "enabled" : "disabled"),
+			(enableddisabled(n->enabled)),
 			n->command_code);
 	kfree(info);
 	return err;
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index dd30f4e61a8c..b59a83fae853 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -737,7 +737,7 @@ static void atom_op_jump(atom_exec_context *ctx, int *ptr, int arg)
 		break;
 	}
 	if (arg != ATOM_COND_ALWAYS)
-		SDEBUG("   taken: %s\n", execute ? "yes" : "no");
+		SDEBUG("   taken: %s\n", yesno(execute));
 	SDEBUG("   target: 0x%04X\n", target);
 	if (execute) {
 		if (ctx->last_jump == (ctx->start + target)) {
diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
index 3be8eb21fd6e..1e025cbd5e81 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
@@ -2918,7 +2918,8 @@ static int vega10_enable_disable_PCC_limit_feature(struct pp_hwmgr *hwmgr, bool
 
 	if (data->smu_features[GNLD_PCC_LIMIT].supported) {
 		if (enable == data->smu_features[GNLD_PCC_LIMIT].enabled)
-			pr_info("GNLD_PCC_LIMIT has been %s \n", enable ? "enabled" : "disabled");
+			pr_info("GNLD_PCC_LIMIT has been %s \n",
+				enableddisabled(enable));
 		PP_ASSERT_WITH_CODE(!vega10_enable_smc_features(hwmgr,
 				enable, data->smu_features[GNLD_PCC_LIMIT].smu_feature_bitmap),
 				"Attempt to Enable PCC Limit feature Failed!",
diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 13ade28a36a8..debce316a02d 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -653,7 +653,7 @@ static int tc_get_display_props(struct tc_data *tc)
 		"enhanced" : "non-enhanced");
 	dev_dbg(tc->dev, "Downspread: %s, scrambler: %s\n",
 		tc->link.spread ? "0.5%" : "0.0%",
-		tc->link.scrambler_dis ? "disabled" : "enabled");
+		enableddisabled(!tc->link.scrambler_dis));
 	dev_dbg(tc->dev, "Display ASSR: %d, TC358767 ASSR: %d\n",
 		tc->link.assr, tc->assr);
 
diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
index c8922b7cac09..264fa3a9ffd4 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -213,7 +213,7 @@ static void drm_client_connectors_enabled(struct drm_connector **connectors,
 		connector = connectors[i];
 		enabled[i] = drm_connector_enabled(connector, true);
 		DRM_DEBUG_KMS("connector %d enabled? %s\n", connector->base.id,
-			      connector->display_info.non_desktop ? "non desktop" : enabled[i] ? "yes" : "no");
+			      connector->display_info.non_desktop ? "non desktop" : yesno(enabled[i]));
 
 		any_enabled |= enabled[i];
 	}
diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 0b994d083a89..fabdb3222e87 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -600,7 +600,7 @@ void drm_dp_downstream_debug(struct seq_file *m,
 			     DP_DWN_STRM_PORT_PRESENT;
 
 	seq_printf(m, "\tDP branch device present: %s\n",
-		   branch_device ? "yes" : "no");
+		   yesno(branch_device));
 
 	if (!branch_device)
 		return;
diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index d38b3b255926..a5af002adf73 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -255,7 +255,7 @@ static void *edid_load(struct drm_connector *connector, const char *name,
 
 	DRM_INFO("Got %s EDID base block and %d extension%s from "
 	    "\"%s\" for connector \"%s\"\n", (builtin >= 0) ? "built-in" :
-	    "external", valid_extensions, valid_extensions == 1 ? "" : "s",
+	    "external", valid_extensions, plural(valid_extensions),
 	    name, connector_name);
 
 out:
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index a8c4468f03d9..53c2f5705c79 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1208,7 +1208,7 @@ void drm_gem_print_info(struct drm_printer *p, unsigned int indent,
 			  drm_vma_node_start(&obj->vma_node));
 	drm_printf_indent(p, indent, "size=%zu\n", obj->size);
 	drm_printf_indent(p, indent, "imported=%s\n",
-			  obj->import_attach ? "yes" : "no");
+			  yesno(obj->import_attach));
 
 	if (obj->funcs && obj->funcs->print_info)
 		obj->funcs->print_info(p, indent, obj);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 592b92782fab..5da343a753b1 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -16006,7 +16006,7 @@ int intel_modeset_init(struct drm_device *dev)
 
 	DRM_DEBUG_KMS("%d display pipe%s available.\n",
 		      INTEL_INFO(dev_priv)->num_pipes,
-		      INTEL_INFO(dev_priv)->num_pipes > 1 ? "s" : "");
+		      plural(INTEL_INFO(dev_priv)->num_pipes));
 
 	for_each_pipe(dev_priv, pipe) {
 		ret = intel_crtc_init(dev_priv, pipe);
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index fe3a10255c36..eec68ebe7cad 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -277,7 +277,7 @@ static void nouveau_dsm_pci_probe(struct pci_dev *pdev, acpi_handle *dhandle_out
 		nouveau_optimus_dsm(dhandle, NOUVEAU_DSM_OPTIMUS_CAPS, 0,
 				    &result);
 		dev_info(&pdev->dev, "optimus capabilities: %s, status %s%s\n",
-			 (result & OPTIMUS_ENABLED) ? "enabled" : "disabled",
+			 enableddisabled(result & OPTIMUS_ENABLED),
 			 (result & OPTIMUS_DYNAMIC_PWR_CAP) ? "dynamic power, " : "",
 			 (result & OPTIMUS_HDA_CODEC_MASK) ? "hda bios codec supported" : "");
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
index a11637b0f6cc..05c733598f4f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
@@ -94,7 +94,7 @@ void
 nvkm_i2c_aux_monitor(struct nvkm_i2c_aux *aux, bool monitor)
 {
 	struct nvkm_i2c_pad *pad = aux->pad;
-	AUX_TRACE(aux, "monitor: %s", monitor ? "yes" : "no");
+	AUX_TRACE(aux, "monitor: %s", yesno(monitor));
 	if (monitor)
 		nvkm_i2c_pad_mode(pad, NVKM_I2C_PAD_AUX);
 	else
diff --git a/drivers/gpu/drm/omapdrm/dss/dispc.c b/drivers/gpu/drm/omapdrm/dss/dispc.c
index 785c5546067a..9766101d8ab0 100644
--- a/drivers/gpu/drm/omapdrm/dss/dispc.c
+++ b/drivers/gpu/drm/omapdrm/dss/dispc.c
@@ -1506,7 +1506,7 @@ void dispc_enable_fifomerge(struct dispc_device *dispc, bool enable)
 		return;
 	}
 
-	DSSDBG("FIFO merge %s\n", enable ? "enabled" : "disabled");
+	DSSDBG("FIFO merge %s\n", enableddisabled(enable));
 	REG_FLD_MOD(dispc, DISPC_CONFIG, enable ? 1 : 0, 14, 14);
 }
 
diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index b30fcaa2d0f5..671ae88cabba 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -1408,8 +1408,7 @@ static int dsi_dump_dsi_clocks(struct seq_file *s, void *p)
 				DSS_CLK_SRC_PLL2_1),
 			cinfo->clkout[HSDIV_DISPC],
 			cinfo->mX[HSDIV_DISPC],
-			dispc_clk_src == DSS_CLK_SRC_FCK ?
-			"off" : "on");
+			onoff(dispc_clk_src != DSS_CLK_SRC_FCK));
 
 	seq_printf(s,	"DSI_PLL_HSDIV_DSI (%s)\t%-16lum_dsi %u\t(%s)\n",
 			dss_get_clk_source_name(dsi_module == 0 ?
@@ -1417,8 +1416,7 @@ static int dsi_dump_dsi_clocks(struct seq_file *s, void *p)
 				DSS_CLK_SRC_PLL2_2),
 			cinfo->clkout[HSDIV_DSI],
 			cinfo->mX[HSDIV_DSI],
-			dsi_clk_src == DSS_CLK_SRC_FCK ?
-			"off" : "on");
+			onoff(dsi_clk_src != DSS_CLK_SRC_FCK));
 
 	seq_printf(s,	"- DSI%d -\n", dsi_module + 1);
 
diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 8b319ebbb0fb..bae1d1277f21 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -355,7 +355,7 @@ static void qxl_crtc_update_monitors_config(struct drm_crtc *crtc,
 
 	DRM_DEBUG_KMS("head %d, %dx%d, at +%d+%d, %s (%s)\n",
 		      i, head.width, head.height, head.x, head.y,
-		      crtc->state->active ? "on" : "off", reason);
+		      onoff(crtc->state->active), reason);
 	if (oldcount != qdev->monitors_config->count)
 		DRM_DEBUG_KMS("active heads %d -> %d (%d total)\n",
 			      oldcount, qdev->monitors_config->count,
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 2c27627b6659..e6dd0f5c67b8 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -722,7 +722,7 @@ static void atom_op_jump(atom_exec_context *ctx, int *ptr, int arg)
 		break;
 	}
 	if (arg != ATOM_COND_ALWAYS)
-		SDEBUG("   taken: %s\n", execute ? "yes" : "no");
+		SDEBUG("   taken: %s\n", yesno(execute));
 	SDEBUG("   target: 0x%04X\n", target);
 	if (execute) {
 		if (ctx->last_jump == (ctx->start + target)) {
diff --git a/drivers/gpu/drm/radeon/radeon_acpi.c b/drivers/gpu/drm/radeon/radeon_acpi.c
index 6cf1645e7a1a..0decdd9781f4 100644
--- a/drivers/gpu/drm/radeon/radeon_acpi.c
+++ b/drivers/gpu/drm/radeon/radeon_acpi.c
@@ -299,7 +299,7 @@ static int radeon_atif_get_notification_params(acpi_handle handle,
 
 out:
 	DRM_DEBUG_DRIVER("Notification %s, command code = %#x\n",
-			(n->enabled ? "enabled" : "disabled"),
+			(enableddisabled(n->enabled)),
 			n->command_code);
 	kfree(info);
 	return err;
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 94e404f13234..80a196d13647 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -317,7 +317,7 @@ static void hda_enable_hd_dacs(struct sti_hda *hda, bool enable)
 static void hda_dbg_cfg(struct seq_file *s, int val)
 {
 	seq_puts(s, "\tAWG ");
-	seq_puts(s, val & CFG_AWG_ASYNC_EN ? "enabled" : "disabled");
+	seq_puts(s, enableddisabled(val & CFG_AWG_ASYNC_EN));
 }
 
 static void hda_dbg_awg_microcode(struct seq_file *s, void __iomem *reg)
@@ -338,7 +338,7 @@ static void hda_dbg_video_dacs_ctrl(struct seq_file *s, void __iomem *reg)
 
 	seq_printf(s, "\n\n  %-25s 0x%08X", "VIDEO_DACS_CONTROL", val);
 	seq_puts(s, "\tHD DACs ");
-	seq_puts(s, val & DAC_CFG_HD_HZUVW_OFF_MASK ? "disabled" : "enabled");
+	seq_puts(s, enableddisabled(!(val & DAC_CFG_HD_HZUVW_OFF_MASK)));
 }
 
 static int hda_dbg_show(struct seq_file *s, void *data)
diff --git a/drivers/gpu/drm/sti/sti_tvout.c b/drivers/gpu/drm/sti/sti_tvout.c
index e1b3c8cb7287..1f169ed177e9 100644
--- a/drivers/gpu/drm/sti/sti_tvout.c
+++ b/drivers/gpu/drm/sti/sti_tvout.c
@@ -491,7 +491,7 @@ static void tvout_dbg_vip(struct seq_file *s, int val)
 static void tvout_dbg_hd_dac_cfg(struct seq_file *s, int val)
 {
 	seq_printf(s, "\t%-24s %s", "HD DAC:",
-		   val & 1 ? "disabled" : "enabled");
+		   enableddisabled(!(val & 1)));
 }
 
 static int tvout_dbg_show(struct seq_file *s, void *data)
diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index 78d8c3afe825..f1e301060123 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -273,7 +273,7 @@ int sun4i_backend_update_layer_formats(struct sun4i_backend *backend,
 			   interlaced ? SUN4I_BACKEND_MODCTL_ITLMOD_EN : 0);
 
 	DRM_DEBUG_DRIVER("Switching display backend interlaced mode %s\n",
-			 interlaced ? "on" : "off");
+			 onoff(interlaced));
 
 	val = SUN4I_BACKEND_ATTCTL_REG0_LAY_GLBALPHA(state->alpha >> 8);
 	if (state->alpha != DRM_BLEND_ALPHA_OPAQUE)
diff --git a/drivers/gpu/drm/sun4i/sun8i_ui_layer.c b/drivers/gpu/drm/sun4i/sun8i_ui_layer.c
index dd2a1c851939..c48b1cf07439 100644
--- a/drivers/gpu/drm/sun4i/sun8i_ui_layer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_ui_layer.c
@@ -126,7 +126,7 @@ static int sun8i_ui_layer_update_coord(struct sun8i_mixer *mixer, int channel,
 				   val);
 
 		DRM_DEBUG_DRIVER("Switching display mixer interlaced mode %s\n",
-				 interlaced ? "on" : "off");
+				 onoff(interlaced));
 	}
 
 	/* Set height and width */
diff --git a/drivers/gpu/drm/v3d/v3d_debugfs.c b/drivers/gpu/drm/v3d/v3d_debugfs.c
index 78a78938e81f..0ca71eb2e760 100644
--- a/drivers/gpu/drm/v3d/v3d_debugfs.c
+++ b/drivers/gpu/drm/v3d/v3d_debugfs.c
@@ -147,15 +147,15 @@ static int v3d_v3d_debugfs_ident(struct seq_file *m, void *unused)
 		   V3D_GET_FIELD(ident3, V3D_HUB_IDENT3_IPREV),
 		   V3D_GET_FIELD(ident3, V3D_HUB_IDENT3_IPIDX));
 	seq_printf(m, "MMU:        %s\n",
-		   (ident2 & V3D_HUB_IDENT2_WITH_MMU) ? "yes" : "no");
+		   yesno(ident2 & V3D_HUB_IDENT2_WITH_MMU));
 	seq_printf(m, "TFU:        %s\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_TFU) ? "yes" : "no");
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TFU));
 	seq_printf(m, "TSY:        %s\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_TSY) ? "yes" : "no");
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TSY));
 	seq_printf(m, "MSO:        %s\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_MSO) ? "yes" : "no");
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_MSO));
 	seq_printf(m, "L3C:        %s (%dkb)\n",
-		   (ident1 & V3D_HUB_IDENT1_WITH_L3C) ? "yes" : "no",
+		   yesno(ident1 & V3D_HUB_IDENT1_WITH_L3C),
 		   V3D_GET_FIELD(ident2, V3D_HUB_IDENT2_L3C_NKB));
 
 	for (core = 0; core < cores; core++) {
diff --git a/drivers/gpu/drm/virtio/virtgpu_debugfs.c b/drivers/gpu/drm/virtio/virtgpu_debugfs.c
index ed0fcda713c3..4b6bf4e9abb1 100644
--- a/drivers/gpu/drm/virtio/virtgpu_debugfs.c
+++ b/drivers/gpu/drm/virtio/virtgpu_debugfs.c
@@ -31,7 +31,7 @@
 static void virtio_add_bool(struct seq_file *m, const char *name,
 				    bool value)
 {
-	seq_printf(m, "%-16s : %s\n", name, value ? "yes" : "no");
+	seq_printf(m, "%-16s : %s\n", name, yesno(value));
 }
 
 static void virtio_add_int(struct seq_file *m, const char *name,
-- 
2.20.1

