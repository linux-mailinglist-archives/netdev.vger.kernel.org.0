Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDFC250861
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 20:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHXSpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 14:45:38 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:38878 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHXSpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 14:45:36 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id C902A20044;
        Mon, 24 Aug 2020 20:45:01 +0200 (CEST)
Date:   Mon, 24 Aug 2020 20:45:00 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, David Airlie <airlied@linux.ie>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linaro-mm-sig@lists.linaro.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, mauro.chehab@huawei.com,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liuyao An <anliuyao@huawei.com>,
        Rongrong Zou <zourongrong@gmail.com>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200824184500.GA102202@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <20200819152120.GA106437@ravnborg.org>
 <20200819174027.70b39ee9@coco.lan>
 <20200819173558.GA3733@ravnborg.org>
 <20200821155801.0b820fc6@coco.lan>
 <20200821155505.GA300361@ravnborg.org>
 <20200824180225.1a515b6a@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824180225.1a515b6a@coco.lan>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f+hm+t6M c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=5ZcqSyvnpjgQ-p8ichIA:9 a=26muVd9ceU5IaJe2:21
        a=8KoBv8ssgUNpjl4-:21 a=CjuIK1q_8ugA:10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro.

> Before posting the big patch series again, let me send the new
> version folded into a single patch.

Review 1/N

Lots of small details I missed last time.
A good thing is that there is an opportunity to delete som more code.

	Sam

> diff --git a/drivers/staging/hikey9xx/gpu/Kconfig b/drivers/staging/hikey9xx/gpu/Kconfig
> new file mode 100644
> index 000000000000..8578ca953785
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/Kconfig
> @@ -0,0 +1,10 @@
> +config DRM_HISI_KIRIN9XX
> +	tristate "DRM Support for Hisilicon Kirin9xx series SoCs Platform"
> +	depends on DRM && OF && ARM64
> +	select DRM_KMS_HELPER
> +	select DRM_GEM_CMA_HELPER
> +	select DRM_KMS_CMA_HELPER
> +	select DRM_MIPI_DSI
> +	help
> +	  Choose this option if you have a HiSilicon Kirin960 or Kirin970.
> +	  If M is selected the module will be called kirin9xx-drm.
> diff --git a/drivers/staging/hikey9xx/gpu/Makefile b/drivers/staging/hikey9xx/gpu/Makefile
> new file mode 100644
> index 000000000000..5f7974a95367
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +kirin9xx-drm-y := kirin9xx_drm_drv.o \
> +		  kirin9xx_drm_dss.o \
> +		  kirin9xx_drm_dpe_utils.o \
> +		  kirin970_defs.o kirin960_defs.o \
> +		  kirin9xx_drm_overlay_utils.o
> +
> +obj-$(CONFIG_DRM_HISI_KIRIN9XX) += kirin9xx-drm.o kirin9xx_dw_drm_dsi.o

General comment which is true for many many Makefile's
I have never understood the love of '\'.
Something like this works equally well:

kirin9xx-drm-y := kirin9xx_drm_drv.o kirin9xx_drm_dss.o
kirin9xx-drm-y += kirin9xx_drm_dpe_utils.o kirin970_defs.o
kirin9xx-drm-y += kirin960_defs.o kirin9xx_drm_overlay_utils.o

obj-$(CONFIG_DRM_HISI_KIRIN9XX) += kirin9xx-drm.o kirin9xx_dw_drm_dsi.o


> diff --git a/drivers/staging/hikey9xx/gpu/kirin960_defs.c b/drivers/staging/hikey9xx/gpu/kirin960_defs.c
> new file mode 100644
> index 000000000000..c5e1ec03c818
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin960_defs.c
> @@ -0,0 +1,346 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2008-2011, Hisilicon Tech. Co., Ltd. All rights reserved.
> + * Copyright (c) 2008-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#include <drm/drm_atomic.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fourcc.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_plane_helper.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin960_dpe_reg.h"
All includes blocks should be sorted.

The list of include files looks far too large for this simple file.
Reduce to the relevant include files.

> +
> +static const u32 kirin960_g_dss_module_base[DSS_CHN_MAX_DEFINE][MODULE_CHN_MAX] = {
> +	{
> +		/* D0 */
> +		MIF_CH0_OFFSET,
> +		AIF0_CH0_OFFSET,
> +		AIF1_CH0_OFFSET,
> +		MCTL_CTL_MUTEX_RCH0,
> +		DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_FLUSH_EN,
> +		DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_OV_OEN,
> +		DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_STARTY,
> +		DSS_MCTRL_SYS_OFFSET + MCTL_MOD0_DBG,
> +		DSS_RCH_D0_DMA_OFFSET,
> +		DSS_RCH_D0_DFC_OFFSET,
> +		0,
> +		0,
> +		0,
> +		0,
> +		0,
> +		0,
> +		DSS_RCH_D0_CSC_OFFSET,
> +	}, {
...
> +	},
> +};
> +
> +static const u32 kirin960_g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX] = {
> +	{
> +		DSS_OVL0_OFFSET,
> +		DSS_MCTRL_CTL0_OFFSET
> +	}, {
> +		DSS_OVL1_OFFSET,
> +		DSS_MCTRL_CTL1_OFFSET
> +	}, {
> +		DSS_OVL2_OFFSET,
> +		DSS_MCTRL_CTL2_OFFSET,
> +	}, {
> +		DSS_OVL3_OFFSET,
> +		DSS_MCTRL_CTL3_OFFSET,
> +	}, {
> +		0,
> +		DSS_MCTRL_CTL4_OFFSET,
> +	}, {
> +		0,
> +		DSS_MCTRL_CTL5_OFFSET,
> +	}
> +};
> +
> +/* SCF_LUT_CHN coef_idx */
> +static const int kirin960_g_scf_lut_chn_coef_idx[DSS_CHN_MAX_DEFINE] = {
> +	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
> +};
> +
> +static const u32 kirin960_g_dss_module_cap[DSS_CHN_MAX_DEFINE][MODULE_CAP_MAX] = {
> +	/* D2 */
> +	{0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
> +	/* D3 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* V0 */
> +	{0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1},
> +	/* G0 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* V1 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* G1 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* D0 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* D1 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +
> +	/* W0 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +	/* W1 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +
> +	/* V2 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* W2 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +};
> +
> +/* number of smrx idx for each channel */
> +static const u32 kirin960_g_dss_chn_sid_num[DSS_CHN_MAX_DEFINE] = {
> +	4, 1, 4, 4, 4, 4, 1, 1, 3, 3, 3, 2
> +};
> +
> +/* start idx of each channel */
> +/* smrx_idx = g_dss_smmu_smrx_idx[chn_idx] + (0 ~ g_dss_chn_sid_num[chn_idx]) */
> +static const u32 kirin960_g_dss_smmu_smrx_idx[DSS_CHN_MAX_DEFINE] = {
> +	0, 4, 5, 9, 13, 17, 21, 22, 26, 29, 23, 32
> +};
> +
> +static const u32 kirin960_g_dss_mif_sid_map[DSS_CHN_MAX] = {
> +	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
> +};
> +
> +void kirin960_dpe_defs(struct dss_hw_ctx *ctx)
> +{
> +	memcpy(&ctx->g_dss_module_base, &kirin960_g_dss_module_base,
> +	       sizeof(kirin960_g_dss_module_base));
> +	memcpy(&ctx->g_dss_module_ovl_base, &kirin960_g_dss_module_ovl_base,
> +	       sizeof(kirin960_g_dss_module_ovl_base));
> +	memcpy(&ctx->g_scf_lut_chn_coef_idx, &kirin960_g_scf_lut_chn_coef_idx,
> +	       sizeof(kirin960_g_scf_lut_chn_coef_idx));
> +	memcpy(&ctx->g_dss_module_cap, &kirin960_g_dss_module_cap,
> +	       sizeof(kirin960_g_dss_module_cap));
> +	memcpy(&ctx->g_dss_chn_sid_num, &kirin960_g_dss_chn_sid_num,
> +	       sizeof(kirin960_g_dss_chn_sid_num));
> +	memcpy(&ctx->g_dss_smmu_smrx_idx, &kirin960_g_dss_smmu_smrx_idx,
> +	       sizeof(kirin960_g_dss_smmu_smrx_idx));
> +
> +	ctx->smmu_offset = DSS_SMMU_OFFSET;
> +	ctx->afbc_header_addr_align = AFBC_HEADER_ADDR_ALIGN;
> +	ctx->dss_mmbuf_clk_rate_power_off = DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF;
> +	ctx->rot_mem_ctrl = ROT_MEM_CTRL;
> +	ctx->dither_mem_ctrl = DITHER_MEM_CTRL;
> +	ctx->arsr2p_lb_mem_ctrl = ARSR2P_LB_MEM_CTRL;
> +	ctx->pxl0_clk_rate_power_off = DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF;
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin960_dpe_reg.h b/drivers/staging/hikey9xx/gpu/kirin960_dpe_reg.h
> new file mode 100644
> index 000000000000..3405fb9076c1
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin960_dpe_reg.h
> @@ -0,0 +1,229 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#ifndef __KIRIN960_DPE_REG_H__
> +#define __KIRIN960_DPE_REG_H__
> +
> +#include "kirin9xx_dpe.h"
It looks strange that a register definition header file needs a higher
level header file.
If the include file is needed there is likely some layering that needs to be fixed?

> +
> +#define CRGPERI_PLL0_CLK_RATE	(1600000000UL)
> +#define CRGPERI_PLL2_CLK_RATE	(960000000UL)
> +#define CRGPERI_PLL3_CLK_RATE	(1600000000UL)
> +
> +/* dss clk power off  */
> +#define DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF	(277000000UL)
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF	(238000000UL)
> +
> +/*****************************************************************************/
> +
> +#define SCPWREN	(0x0D0)
> +#define SCPEREN1 (0x040)
> +#define SCPERDIS1  (0x044)
> +#define SCPERRSTDIS1	(0x090)
> +#define SCISODIS	(0x0C4)
> +
> +/*****************************************************************************/
Why the above block of stars - looks random.


> +
> +/* MODULE BASE ADDRESS */
> +
> +#define DSS_SMMU_OFFSET	(0x8000)
> +
> +#define DSS_RCH_VG0_POST_CLIP_OFFSET	(0x203A0)
> +
> +#define DSS_RCH_VG1_POST_CLIP_OFFSET	(0x283A0)
> +
> +#define DSS_RCH_VG2_POST_CLIP_OFFSET	(0x303A0)
> +#define DSS_RCH_VG2_AFBCD_OFFSET	(0x30900)
> +
> +#define DSS_RCH_G0_POST_CLIP_OFFSET (0x383A0)
> +
> +#define DSS_RCH_G1_POST_CLIP_OFFSET (0x403A0)
> +
> +#define DSS_RCH_D2_AFBCD_OFFSET	(0x50900)
> +
> +#define DSS_RCH_D3_AFBCD_OFFSET	(0x51900)
> +
> +#define DSS_RCH_D1_AFBCD_OFFSET	(0x53900)
> +
> +#define DSS_WCH0_ROT_OFFSET	(0x5A500)
> +
> +#define DSS_WCH1_ROT_OFFSET	(0x5C500)
> +
> +#define DSS_DPP_DEGAMA_OFFSET	(0x70500)
> +#define DSS_DPP_LCP_OFFSET	(0x70900)
> +#define DSS_DPP_ARSR1P_OFFSET	(0x70A00)
> +#define DSS_DPP_BITEXT0_OFFSET	(0x70B00)
> +#define DSS_DPP_LCP_LUT_OFFSET	(0x73000)
> +#define DSS_DPP_ARSR1P_LUT_OFFSET	(0x7B000)
> +
> +#define DSS_POST_SCF_OFFSET	DSS_DPP_ARSR1P_OFFSET
> +#define DSS_POST_SCF_LUT_OFFSET	DSS_DPP_ARSR1P_LUT_OFFSET
> +
> +/* AIF */
> +#define AIF0_CH0_ADD_OFFSET	(DSS_VBIF0_AIF + 0x04)
> +#define AIF0_CH1_ADD_OFFSET	(DSS_VBIF0_AIF + 0x24)
> +#define AIF0_CH2_ADD_OFFSET	(DSS_VBIF0_AIF + 0x44)
> +#define AIF0_CH3_ADD_OFFSET	(DSS_VBIF0_AIF + 0x64)
> +#define AIF0_CH4_ADD_OFFSET	(DSS_VBIF0_AIF + 0x84)
> +#define AIF0_CH5_ADD_OFFSET	(DSS_VBIF0_AIF + 0xa4)
> +#define AIF0_CH6_ADD_OFFSET	(DSS_VBIF0_AIF + 0xc4)
> +#define AIF0_CH7_ADD_OFFSET	(DSS_VBIF0_AIF + 0xe4)
> +#define AIF0_CH8_ADD_OFFSET	(DSS_VBIF0_AIF + 0x104)
> +#define AIF0_CH9_ADD_OFFSET	(DSS_VBIF0_AIF + 0x124)
> +#define AIF0_CH10_ADD_OFFSET	(DSS_VBIF0_AIF + 0x144)
> +#define AIF0_CH11_ADD_OFFSET	(DSS_VBIF0_AIF + 0x164)
> +#define AIF0_CH12_ADD_OFFSET	(DSS_VBIF0_AIF + 0x184)
> +
> +#define AIF1_CH0_ADD_OFFSET	(DSS_VBIF1_AIF + 0x04)
> +#define AIF1_CH1_ADD_OFFSET	(DSS_VBIF1_AIF + 0x24)
> +#define AIF1_CH2_ADD_OFFSET	(DSS_VBIF1_AIF + 0x44)
> +#define AIF1_CH3_ADD_OFFSET	(DSS_VBIF1_AIF + 0x64)
> +#define AIF1_CH4_ADD_OFFSET	(DSS_VBIF1_AIF + 0x84)
> +#define AIF1_CH5_ADD_OFFSET	(DSS_VBIF1_AIF + 0xa4)
> +#define AIF1_CH6_ADD_OFFSET	(DSS_VBIF1_AIF + 0xc4)
> +#define AIF1_CH7_ADD_OFFSET	(DSS_VBIF1_AIF + 0xe4)
> +#define AIF1_CH8_ADD_OFFSET	(DSS_VBIF1_AIF + 0x104)
> +#define AIF1_CH9_ADD_OFFSET	(DSS_VBIF1_AIF + 0x124)
> +#define AIF1_CH10_ADD_OFFSET	(DSS_VBIF1_AIF + 0x144)
> +#define AIF1_CH11_ADD_OFFSET	(DSS_VBIF1_AIF + 0x164)
> +#define AIF1_CH12_ADD_OFFSET	(DSS_VBIF1_AIF + 0x184)
> +
> +/* DFC */
> +#define DFC_GLB_ALPHA	(0x0008)
> +
> +/* ARSR2P v0 */
> +#define ARSR2P_IHRIGHT		(0x00C)
> +#define ARSR2P_IVTOP		(0x010)
> +#define ARSR2P_IVBOTTOM		(0x014)
> +#define ARSR2P_IHINC		(0x018)
> +#define ARSR2P_IVINC		(0x01C)
> +#define ARSR2P_UV_OFFSET		(0x020)
> +#define ARSR2P_MODE		(0x024)
> +#define ARSR2P_SKIN_THRES_Y		(0x028)
> +#define ARSR2P_SKIN_THRES_U		(0x02C)
> +#define ARSR2P_SKIN_THRES_V		(0x030)
> +#define ARSR2P_SKIN_CFG0		(0x034)
> +#define ARSR2P_SKIN_CFG1		(0x038)
> +#define ARSR2P_SKIN_CFG2		(0x03C)
> +#define ARSR2P_SHOOT_CFG1		(0x040)
> +#define ARSR2P_SHOOT_CFG2		(0x044)
> +#define ARSR2P_SHARP_CFG1		(0x048)
> +#define ARSR2P_SHARP_CFG2		(0x04C)
> +#define ARSR2P_SHARP_CFG3		(0x050)
> +#define ARSR2P_SHARP_CFG4		(0x054)
> +#define ARSR2P_SHARP_CFG5		(0x058)
> +#define ARSR2P_SHARP_CFG6		(0x05C)
> +#define ARSR2P_SHARP_CFG7		(0x060)
> +#define ARSR2P_SHARP_CFG8		(0x064)
> +#define ARSR2P_SHARP_CFG9		(0x068)
> +#define ARSR2P_TEXTURW_ANALYSTS		(0x06C)
> +#define ARSR2P_INTPLSHOOTCTRL		(0x070)
> +#define ARSR2P_DEBUG0		(0x074)
> +#define ARSR2P_DEBUG1		(0x078)
> +#define ARSR2P_DEBUG2		(0x07C)
> +#define ARSR2P_DEBUG3		(0x080)
> +#define ARSR2P_LB_MEM_CTRL		(0x084)
> +#define ARSR2P_IHLEFT1		(0x088)
> +#define ARSR2P_IHRIGHT1		(0x090)
> +#define ARSR2P_IVBOTTOM1		(0x094)
> +
> +/* POST_CLIP  v g */
> +#define POST_CLIP_CTL_HRZ	(0x0010)
> +#define POST_CLIP_CTL_VRZ	(0x0014)
> +#define POST_CLIP_EN	(0x0018)
> +
> +/* CSC */
> +
> +#define CSC_ICG_MODULE	(0x0024)
> +
> +/* DMA BUF */
> +
> +#define AFBCE_HREG_HDR_PTR_LO	(0x908)
> +#define AFBCE_HREG_PLD_PTR_LO	(0x90C)
> +
> +#define ROT_MEM_CTRL		(0x538)
> +#define ROT_SIZE	(0x53C)
> +
> +/* DMA aligned limited:  128bits aligned */
> +
> +#define AFBC_HEADER_ADDR_ALIGN	(64)
> +#define AFBC_HEADER_STRIDE_ALIGN	(64)
> +
> +/* DPP */
> +
> +#define DITHER_PARA (0x000)
> +#define DITHER_CTL (0x004)
> +#define DITHER_MATRIX_PART1 (0x008)
> +#define DITHER_MATRIX_PART0 (0x00C)
> +#define DITHER_ERRDIFF_WEIGHT (0x010)
> +#define DITHER_FRC_01_PART1 (0x014)
> +#define DITHER_FRC_01_PART0 (0x018)
> +#define DITHER_FRC_10_PART1 (0x01C)
> +#define DITHER_FRC_10_PART0 (0x020)
> +#define DITHER_FRC_11_PART1 (0x024)
> +#define DITHER_FRC_11_PART0 (0x028)
> +#define DITHER_MEM_CTRL (0x02C)
> +#define DITHER_DBG0 (0x030)
> +#define DITHER_DBG1 (0x034)
> +#define DITHER_DBG2 (0x038)
> +
> +#define LCP_GMP_BYPASS_EN	(0x030)
> +#define LCP_XCC_BYPASS_EN	(0x034)
> +#define LCP_DEGAMA_EN	(0x038)
> +#define LCP_DEGAMA_MEM_CTRL	(0x03C)
> +#define LCP_GMP_MEM_CTRL	(0x040)
> +
> +#define ARSR1P_IHLEFT		(0x000)
> +#define ARSR1P_IHRIGHT		(0x004)
> +#define ARSR1P_IHLEFT1		(0x008)
> +#define ARSR1P_IHRIGHT1		(0x00C)
> +#define ARSR1P_IVTOP		(0x010)
> +#define ARSR1P_IVBOTTOM		(0x014)
> +#define ARSR1P_UV_OFFSET		(0x018)
> +#define ARSR1P_IHINC		(0x01C)
> +#define ARSR1P_IVINC		(0x020)
> +#define ARSR1P_MODE			(0x024)
> +#define ARSR1P_FORMAT		(0x028)
> +#define ARSR1P_SKIN_THRES_Y		(0x02C)
> +#define ARSR1P_SKIN_THRES_U		(0x030)
> +#define ARSR1P_SKIN_THRES_V		(0x034)
> +#define ARSR1P_SKIN_EXPECTED	(0x038)
> +#define ARSR1P_SKIN_CFG			(0x03C)
> +#define ARSR1P_SHOOT_CFG1		(0x040)
> +#define ARSR1P_SHOOT_CFG2		(0x044)
> +#define ARSR1P_SHARP_CFG1		(0x048)
> +#define ARSR1P_SHARP_CFG2		(0x04C)
> +#define ARSR1P_SHARP_CFG3		(0x050)
> +#define ARSR1P_SHARP_CFG4		(0x054)
> +#define ARSR1P_SHARP_CFG5		(0x058)
> +#define ARSR1P_SHARP_CFG6		(0x05C)
> +#define ARSR1P_SHARP_CFG7		(0x060)
> +#define ARSR1P_SHARP_CFG8		(0x064)
> +#define ARSR1P_SHARP_CFG9		(0x068)
> +#define ARSR1P_SHARP_CFG10		(0x06C)
> +#define ARSR1P_SHARP_CFG11		(0x070)
> +#define ARSR1P_DIFF_CTRL		(0x074)
> +#define ARSR1P_LSC_CFG1		(0x078)
> +#define ARSR1P_LSC_CFG2		(0x07C)
> +#define ARSR1P_LSC_CFG3		(0x080)
> +#define ARSR1P_FORCE_CLK_ON_CFG		(0x084)
> +
> +/* BIT EXT */
> +
> +#define LCP_U_GMP_COEF	(0x0000)
> +
> +#define ARSR1P_LSC_GAIN		(0x084)
> +#define ARSR1P_COEFF_H_Y0	(0x0F0)
> +#define ARSR1P_COEFF_H_Y1	(0x114)
> +#define ARSR1P_COEFF_V_Y0	(0x138)
> +#define ARSR1P_COEFF_V_Y1	(0x15C)
> +#define ARSR1P_COEFF_H_UV0	(0x180)
> +#define ARSR1P_COEFF_H_UV1	(0x1A4)
> +#define ARSR1P_COEFF_V_UV0	(0x1C8)
> +#define ARSR1P_COEFF_V_UV1	(0x1EC)
> +
> +#endif
> diff --git a/drivers/staging/hikey9xx/gpu/kirin970_defs.c b/drivers/staging/hikey9xx/gpu/kirin970_defs.c
> new file mode 100644
> index 000000000000..d72d4d5712eb
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin970_defs.c
> @@ -0,0 +1,373 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2008-2011, Hisilicon Tech. Co., Ltd. All rights reserved.
> + * Copyright (c) 2008-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#include <drm/drm_atomic.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fourcc.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_plane_helper.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin970_dpe_reg.h"
Same as before. Sort and reduce to the necessary includes.

> +
> +static const u32 kirin970_g_dss_module_base[DSS_CHN_MAX_DEFINE][MODULE_CHN_MAX] = {
> +	/* D0 */
> +	{
> +	MIF_CH0_OFFSET,   /* MODULE_MIF_CHN */
> +	AIF0_CH0_OFFSET,  /* MODULE_AIF0_CHN */
> +	AIF1_CH0_OFFSET,  /* MODULE_AIF1_CHN */
> +	MCTL_CTL_MUTEX_RCH0,  /* MODULE_MCTL_CHN_MUTEX */
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_FLUSH_EN,  /* MODULE_MCTL_CHN_FLUSH_EN */
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_OV_OEN,  /* MODULE_MCTL_CHN_OV_OEN */
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_STARTY,  /* MODULE_MCTL_CHN_STARTY */
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD0_DBG,  /* MODULE_MCTL_CHN_MOD_DBG */
> +	DSS_RCH_D0_DMA_OFFSET,  /* MODULE_DMA */
> +	DSS_RCH_D0_DFC_OFFSET,  /* MODULE_DFC */
> +	0,  /* MODULE_SCL */
> +	0,  /* MODULE_SCL_LUT */
> +	0,  /* MODULE_ARSR2P */
> +	0,  /* MODULE_ARSR2P_LUT */
> +	0, /* MODULE_POST_CLIP_ES */
> +	0,  /* MODULE_POST_CLIP */
> +	0,  /* MODULE_PCSC */
> +	DSS_RCH_D0_CSC_OFFSET,  /* MODULE_CSC */
> +	},
...
> +	},
> +};
> +
> +static const u32 kirin970_g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX] = {
> +	{DSS_OVL0_OFFSET,
> +	DSS_MCTRL_CTL0_OFFSET},
> +
> +	{DSS_OVL1_OFFSET,
> +	DSS_MCTRL_CTL1_OFFSET},
> +
> +	{DSS_OVL2_OFFSET,
> +	DSS_MCTRL_CTL2_OFFSET},
> +
> +	{DSS_OVL3_OFFSET,
> +	DSS_MCTRL_CTL3_OFFSET},
> +
> +	{0,
> +	DSS_MCTRL_CTL4_OFFSET},
> +
> +	{0,
> +	DSS_MCTRL_CTL5_OFFSET},
> +};
> +
> +/* SCF_LUT_CHN coef_idx */
> +static const int kirin970_g_scf_lut_chn_coef_idx[DSS_CHN_MAX_DEFINE] = {
> +	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
> +};
> +
> +static const u32 kirin970_g_dss_module_cap[DSS_CHN_MAX_DEFINE][MODULE_CAP_MAX] = {
> +	/* D2 */
> +	{0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
> +	/* D3 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* V0 */
> +	{0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1},
> +	/* G0 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* V1 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* G1 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* D0 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* D1 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +
> +	/* W0 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +	/* W1 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +
> +	/* V2 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* W2 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +};
> +
> +/* number of smrx idx for each channel */
> +static const u32 kirin970_g_dss_chn_sid_num[DSS_CHN_MAX_DEFINE] = {
> +	4, 1, 4, 4, 4, 4, 1, 1, 3, 4, 3, 3
> +};
> +
> +/* start idx of each channel */
> +/* smrx_idx = g_dss_smmu_smrx_idx[chn_idx] + (0 ~ g_dss_chn_sid_num[chn_idx]) */
> +static const u32 kirin970_g_dss_smmu_smrx_idx[DSS_CHN_MAX_DEFINE] = {
> +	0, 4, 5, 9, 13, 17, 21, 22, 26, 29, 23, 36
> +};
> +
> +void kirin970_dpe_defs(struct dss_hw_ctx *ctx)
> +{
> +	memcpy(&ctx->g_dss_module_base, &kirin970_g_dss_module_base,
> +	       sizeof(kirin970_g_dss_module_base));
> +	memcpy(&ctx->g_dss_module_ovl_base, &kirin970_g_dss_module_ovl_base,
> +	       sizeof(kirin970_g_dss_module_ovl_base));
> +	memcpy(&ctx->g_scf_lut_chn_coef_idx, &kirin970_g_scf_lut_chn_coef_idx,
> +	       sizeof(kirin970_g_scf_lut_chn_coef_idx));
> +	memcpy(&ctx->g_dss_module_cap, &kirin970_g_dss_module_cap,
> +	       sizeof(kirin970_g_dss_module_cap));
> +	memcpy(&ctx->g_dss_chn_sid_num, &kirin970_g_dss_chn_sid_num,
> +	       sizeof(kirin970_g_dss_chn_sid_num));
> +	memcpy(&ctx->g_dss_smmu_smrx_idx, &kirin970_g_dss_smmu_smrx_idx,
> +	       sizeof(kirin970_g_dss_smmu_smrx_idx));
> +
> +	ctx->smmu_offset = DSS_SMMU_OFFSET;
> +	ctx->afbc_header_addr_align = AFBC_HEADER_ADDR_ALIGN;
> +	ctx->dss_mmbuf_clk_rate_power_off = DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF;
> +	ctx->rot_mem_ctrl = ROT_MEM_CTRL;
> +	ctx->dither_mem_ctrl = DITHER_MEM_CTRL;
> +	ctx->arsr2p_lb_mem_ctrl = ARSR2P_LB_MEM_CTRL;
> +	ctx->pxl0_clk_rate_power_off = DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF;
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h b/drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h
> new file mode 100644
> index 000000000000..6cd1d6f5e8d0
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h
> @@ -0,0 +1,1183 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#ifndef __KIRIN970_DPE_REG_H__
> +#define __KIRIN970_DPE_REG_H__
> +
> +#include "kirin9xx_dpe.h"
Same coment as before, looks like a layering issue if this header file
is needed.

> +
> +#define CRGPERI_PLL0_CLK_RATE	(1660000000UL)
> +#define CRGPERI_PLL2_CLK_RATE	(1920000000UL)
> +#define CRGPERI_PLL3_CLK_RATE	(1200000000UL)
> +#define CRGPERI_PLL7_CLK_RATE	(1782000000UL)
> +
> +/* core_clk: 0.65v-300M, 0.75-415M, 0.8-553.33M */
> +#define DEFAULT_DSS_CORE_CLK_RATE_L3	(554000000UL)
> +#define DEFAULT_DSS_CORE_CLK_RATE_L2	(415000000UL)
> +
> +#define DEFAULT_DSS_CORE_CLK_RATE_ES	(400000000UL)
> +
> +/* pix0_clk: 0.65v-300M, 0.75-415M, 0.8-645M */
> +#define DEFAULT_DSS_PXL0_CLK_RATE_L3	(645000000UL)
> +#define DEFAULT_DSS_PXL0_CLK_RATE_L2	(415000000UL)
> +#define DEFAULT_DSS_PXL0_CLK_RATE_L1	(300000000UL)
> +
> +/* mmbuf_clk: 0.65v-237.14M, 0.75-332M, 0.8-480M */
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_L3	(480000000UL)
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_L2	(332000000UL)
> +
> +/* pix1_clk: 0.65v-254.57M, 0.75-415M, 0.8-594M */
> +#define DEFAULT_DSS_PXL1_CLK_RATE_L3	(594000000UL)
> +#define DEFAULT_DSS_PXL1_CLK_RATE_L2	(415000000UL)
> +#define DEFAULT_DSS_PXL1_CLK_RATE_L1	(255000000UL)
> +
> +/* mdc_dvfs_clk: 0.65v-240M, 0.75-332M, 0.8-553.33M */
> +#define DEFAULT_MDC_CORE_CLK_RATE_L3	(554000000UL)
> +#define DEFAULT_MDC_CORE_CLK_RATE_L2	(332000000UL)
> +#define DEFAULT_MDC_CORE_CLK_RATE_L1	(240000000UL)
> +
> +/* dss clk power off  */
> +#define DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF	(238000000UL)
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF	(208000000UL)
> +
> +/*****************************************************************************/
> +
> +#define PEREN4	(0x040)
> +#define PERDIS4	(0x044)
> +#define PERRSTEN0	(0x060)
> +#define PERRSTDIS5	(0x0A0)
> +#define PEREN6	(0x410)
> +#define PERDIS6	(0x414)
> +
> +/* SYSCTRL */
> +#define SCISODIS	(0x044)
> +#define SCPWREN	(0x060)
> +#define SCPEREN1	(0x170)
> +#define SCPERDIS1	(0x174)
> +#define SCPEREN4	(0x1B0)
> +#define SCPERDIS4	(0x1B4)
> +#define SCPERRSTDIS1	(0x210)
> +
> +/* PCTRL */
> +#define PERI_CTRL33	(0x088)
> +
> +/*****************************************************************************/
> +
> +/* MODULE BASE ADDRESS */
> +
> +/* SMMU */
> +#define DSS_SMMU_OFFSET	(0x80000)
> +
> +/* RCH_V */
> +#define DSS_RCH_VG0_POST_CLIP_OFFSET_ES	(0x203A0)
> +#define DSS_RCH_VG0_POST_CLIP_OFFSET	(0x20480)
> +
> +#define DSS_RCH_VG1_POST_CLIP_OFFSET_ES	(0x283A0)
> +#define DSS_RCH_VG1_POST_CLIP_OFFSET	(0x28480)
> +
> +#define DSS_RCH_VG2_POST_CLIP_OFFSET_ES	(0x303A0)
> +#define DSS_RCH_VG2_POST_CLIP_OFFSET	(0x30480)
> +#define DSS_RCH_VG2_SCL_LUT_OFFSET		(0x31000)   /* ES */
> +
> +/* RCH_G */
> +#define DSS_RCH_G0_POST_CLIP_OFFSET_ES		(0x383A0)
> +#define DSS_RCH_G0_POST_CLIP_OFFSET		(0x38480)
> +
> +#define DSS_RCH_G1_POST_CLIP_OFFSET_ES	(0x403A0)
> +#define DSS_RCH_G1_POST_CLIP_OFFSET		(0x40480)
> +
> +/* RCH_D */
> +
> +/* WCH */
> +#define DSS_WCH0_BITEXT_OFFSET		(0x5A140)
> +#define DSS_WCH0_DITHER_OFFSET            (0x5A1D0)
> +#define DSS_WCH0_PCSC_OFFSET			(0x5A400)
> +#define DSS_WCH0_ROT_OFFSET			(0x5A530)
> +#define DSS_WCH0_FBCE_CREG_CTRL_GATE (0x5A964)
> +
> +#define DSS_WCH1_BITEXT_OFFSET		(0x5C140)
> +#define DSS_WCH1_DITHER_OFFSET            (0x5C1D0)
> +#define DSS_WCH1_SCL_OFFSET			(0x5C200)
> +#define DSS_WCH1_PCSC_OFFSET			(0x5C400)
> +#define DSS_WCH1_ROT_OFFSET			(0x5C530)
> +#define DSS_WCH1_FBCE_CREG_CTRL_GATE	(0x5C964)
> +
> +/* DPP */
> +#define DSS_DPP_CLIP_OFFSET	(0x70180)
> +#define DSS_DPP_XCC_OFFSET	(0x70900)
> +#define DSS_DPP_DEGAMMA_OFFSET	(0x70950)
> +#define DSS_DPP_GMP_OFFSET	(0x709A0)
> +#define DSS_DPP_ARSR_POST_OFFSET	(0x70A00)
> +#define DSS_DPP_GMP_LUT_OFFSET	(0x73000)
> +#define DSS_DPP_GAMA_PRE_LUT_OFFSET	(0x75000)
> +#define DSS_DPP_DEGAMMA_LUT_OFFSET	(0x78000)
> +#define DSS_DPP_ARSR_POST_LUT_OFFSET	(0x7B000)
> +
> +/* for boston es */
> +#define DSS_DPP_LCP_OFFSET_ES	(0x70900)
> +#define DSS_DPP_LCP_LUT_OFFSET_ES	(0x73000)
> +
> +/* POST SCF */
> +#define DSS_POST_SCF_OFFSET	DSS_DPP_ARSR_POST_OFFSET
> +#define DSS_POST_SCF_LUT_OFFSET	DSS_DPP_ARSR_POST_LUT_OFFSET
> +/* POST SCF for ES */
> +#define DSS_POST_SCF_LUT_OFFSET_ES	(0x7B000)
> +
> +/* AIF */
> +
> +/* (0x0004+0x20*n) */
> +#define AIF_CH_HS	(0x0004)
> +/* (0x0008+0x20*n) */
> +#define AIF_CH_LS	(0x0008)
> +
> +/* SMMU */
> +
> +#define SMMU_SMRx_P	(0x10000)
> +#define SMMU_RLD_EN0_P	(0x101F0)
> +#define SMMU_RLD_EN1_P	(0x101F4)
> +#define SMMU_RLD_EN2_P	(0x101F8)
> +#define SMMU_INTMAS_P	(0x10200)
> +#define SMMU_INTRAW_P	(0x10204)
> +#define SMMU_INTSTAT_P	(0x10208)
> +#define SMMU_INTCLR_P	(0x1020C)
> +#define SMMU_SCR_P		(0x10210)
> +#define SMMU_PCB_SCTRL	(0x10214)
> +#define SMMU_PCB_TTBR	(0x10218)
> +#define SMMU_PCB_TTBCR	(0x1021C)
> +#define SMMU_OFFSET_ADDR_P	(0x10220)
> +
> +/* DFC */
> +#define DFC_GLB_ALPHA01		(0x0008)
> +#define DFC_GLB_ALPHA23		(0x0028)
> +#define DFC_BITEXT_CTL		(0x0040)
> +#define DFC_DITHER_CTL1      (0x00D0)
> +
> +/* SCF */
> +
> +/* MACROS */
> +#define SCF_MIN_INPUT	(16) /* SCF min input pix 16x16 */
> +#define SCF_MIN_OUTPUT	(16) /* SCF min output pix 16x16 */
> +
> +#define SCF_INC_FACTOR	BIT(18) /* (262144) */
> +
> +/* ARSR2P ES  v0 */
> +#define ARSR2P_INPUT_WIDTH_HEIGHT_ES	(0x000)
> +#define ARSR2P_OUTPUT_WIDTH_HEIGHT_ES	(0x004)
> +#define ARSR2P_IHLEFT_ES	(0x008)
> +#define ARSR2P_IHRIGHT_ES	(0x00C)
> +#define ARSR2P_IVTOP_ES		(0x010)
> +#define ARSR2P_IVBOTTOM_ES	(0x014)
> +#define ARSR2P_IHINC_ES		(0x018)
> +#define ARSR2P_IVINC_ES		(0x01C)
> +#define ARSR2P_UV_OFFSET_ES	(0x020)
> +#define ARSR2P_MODE_ES		(0x024)
> +#define ARSR2P_SKIN_THRES_Y_ES	(0x028)
> +#define ARSR2P_SKIN_THRES_U_ES	(0x02C)
> +#define ARSR2P_SKIN_THRES_V_ES	(0x030)
> +#define ARSR2P_SKIN_CFG0_ES	(0x034)
> +#define ARSR2P_SKIN_CFG1_ES	(0x038)
> +#define ARSR2P_SKIN_CFG2_ES	(0x03C)
> +#define ARSR2P_SHOOT_CFG1_ES	(0x040)
> +#define ARSR2P_SHOOT_CFG2_ES	(0x044)
> +#define ARSR2P_SHARP_CFG1_ES	(0x048)
> +#define ARSR2P_SHARP_CFG2_ES	(0x04C)
> +#define ARSR2P_SHARP_CFG3_ES	(0x050)
> +#define ARSR2P_SHARP_CFG4_ES	(0x054)
> +#define ARSR2P_SHARP_CFG5_ES	(0x058)
> +#define ARSR2P_SHARP_CFG6_ES	(0x05C)
> +#define ARSR2P_SHARP_CFG7_ES	(0x060)
> +#define ARSR2P_SHARP_CFG8_ES	(0x064)
> +#define ARSR2P_SHARP_CFG9_ES	(0x068)
> +#define ARSR2P_TEXTURW_ANALYSTS_ES	(0x06C)
> +#define ARSR2P_INTPLSHOOTCTRL_ES	(0x070)
> +#define ARSR2P_DEBUG0_ES	(0x074)
> +#define ARSR2P_DEBUG1_ES	(0x078)
> +#define ARSR2P_DEBUG2_ES	(0x07C)
> +#define ARSR2P_DEBUG3_ES	(0x080)
> +#define ARSR2P_LB_MEM_CTRL_ES	(0x084)
> +#define ARSR2P_IHLEFT1_ES	(0x088)
> +#define ARSR2P_IHRIGHT1_ES	(0x090)
> +#define ARSR2P_IVBOTTOM1_ES	(0x094)
> +
> +#define ARSR2P_LUT_COEFY_V_OFFSET_ES	(0x0000)
> +#define ARSR2P_LUT_COEFY_H_OFFSET_ES	(0x0100)
> +#define ARSR2P_LUT_COEFA_V_OFFSET_ES	(0x0300)
> +#define ARSR2P_LUT_COEFA_H_OFFSET_ES	(0x0400)
> +#define ARSR2P_LUT_COEFUV_V_OFFSET_ES	(0x0600)
> +#define ARSR2P_LUT_COEFUV_H_OFFSET_ES	(0x0700)
> +
> +/* ARSR2P  v0 */
> +#define ARSR2P_IHLEFT1 (0x00C)
> +#define ARSR2P_IHRIGHT (0x010)
> +#define ARSR2P_IHRIGHT1 (0x014)
> +#define ARSR2P_IVTOP (0x018)
> +#define ARSR2P_IVBOTTOM (0x01C)
> +#define ARSR2P_IVBOTTOM1 (0x020)
> +#define ARSR2P_IHINC (0x024)
> +#define ARSR2P_IVINC (0x028)
> +#define ARSR2P_OFFSET (0x02C)
> +#define ARSR2P_MODE (0x030)
> +#define ARSR2P_SKIN_THRES_Y (0x034)
> +#define ARSR2P_SKIN_THRES_U (0x038)
> +#define ARSR2P_SKIN_THRES_V (0x03C)
> +#define ARSR2P_SKIN_CFG0 (0x040)
> +#define ARSR2P_SKIN_CFG1 (0x044)
> +#define ARSR2P_SKIN_CFG2 (0x048)
> +#define ARSR2P_SHOOT_CFG1 (0x04C)
> +#define ARSR2P_SHOOT_CFG2 (0x050)
> +#define ARSR2P_SHOOT_CFG3 (0x054)
> +#define ARSR2P_SHARP_CFG1 (0x080)
> +#define ARSR2P_SHARP_CFG2 (0x084)
> +#define ARSR2P_SHARP_CFG3 (0x088)
> +#define ARSR2P_SHARP_CFG4 (0x08C)
> +#define ARSR2P_SHARP_CFG5 (0x090)
> +#define ARSR2P_SHARP_CFG6 (0x094)
> +#define ARSR2P_SHARP_CFG7 (0x098)
> +#define ARSR2P_SHARP_CFG8 (0x09C)
> +#define ARSR2P_SHARP_CFG9 (0x0A0)
> +#define ARSR2P_SHARP_CFG10 (0x0A4)
> +#define ARSR2P_SHARP_CFG11 (0x0A8)
> +#define ARSR2P_SHARP_CFG12 (0x0AC)
> +#define ARSR2P_TEXTURW_ANALYSTS (0x0D0)
> +#define ARSR2P_INTPLSHOOTCTRL (0x0D4)
> +#define ARSR2P_DEBUG0 (0x0D8)
> +#define ARSR2P_DEBUG1 (0x0DC)
> +#define ARSR2P_DEBUG2 (0x0E0)
> +#define ARSR2P_DEBUG3 (0x0E4)
> +#define ARSR2P_LB_MEM_CTRL (0x0E8)
> +
> +/* POST_CLIP  v g */
> +#define POST_CLIP_CTL_HRZ			(0x0004)
> +#define POST_CLIP_CTL_VRZ			(0x0008)
> +#define POST_CLIP_EN				(0x000C)
> +
> +#define POST_CLIP_DISP_SIZE_ES		(0x0000)
> +#define POST_CLIP_CTL_HRZ_ES		(0x0010)
> +#define POST_CLIP_CTL_VRZ_ES		(0x0014)
> +#define POST_CLIP_EN_ES			(0x0018)
> +
> +/* CSC */
> +#define CSC_ICG_MODULE_ES	(0x0024)
> +#define CSC_P00				(0x0010)
> +#define CSC_P01				(0x0014)
> +#define CSC_P02				(0x0018)
> +#define CSC_P10				(0x001C)
> +#define CSC_P11				(0x0020)
> +#define CSC_P12				(0x0024)
> +#define CSC_P20				(0x0028)
> +#define CSC_P21				(0x002C)
> +#define CSC_P22				(0x0030)
> +#define CSC_ICG_MODULE		(0x0034)
> +
> +/* AFBCE */
> +#define AFBCE_HREG_HDR_PTR_L0		(0x908)
> +#define AFBCE_HREG_PLD_PTR_L0		(0x90C)
> +
> +/* ROT */
> +#define ROT_MEM_CTRL_ES		(0x538)
> +#define ROT_SIZE_ES			(0x53C)
> +
> +#define ROT_MEM_CTRL			(0x588)
> +#define ROT_SIZE				(0x58C)
> +#define ROT_422_MODE			(0x590)
> +
> +/* REG_DEFAULT */
> +
> +/* MACROS */
> +
> +/* DMA aligned limited:  128bits aligned */
> +
> +/* 16Bytes */
> +/* 32BPP:1024, 16BPP 512 */
> +
> +#define AFBC_HEADER_ADDR_ALIGN	(16)
> +#define AFBC_HEADER_STRIDE_ALIGN	(16)
> +
> +/* 16Pixels */
> +
> +#define MMBUF_BASE	(0x40) /* (0xea800000) */
> +#define MMBUF_BLOCK0_LINE_NUM	(8)
> +#define MMBUF_BLOCK0_ROT_LINE_NUM	(64)
> +#define MMBUF_BLOCK1_LINE_NUM	(16)
> +
> +#define HFBC_PIC_WIDTH_MIN	(64)
> +#define HFBC_PIC_WIDTH_ROT_MIN	(16)
> +#define HFBC_PIC_WIDTH_MAX	(512)
> +#define HFBC_PIC_WIDTH_ROT_MAX  (4096)
> +#define HFBC_PIC_HEIGHT_MIN	(8)
> +#define HFBC_PIC_HEIGHT_ROT_MIN	(32)
> +#define HFBC_PIC_HEIGHT_MAX	(8196)
> +#define HFBC_PIC_HEIGHT_ROT_MAX	(2160)
> +#define HFBC_BLOCK0_WIDTH_ALIGN	(64)
> +#define HFBC_BLOCK0_HEIGHT_ALIGN     (8)
> +#define HFBC_BLOCK1_WIDTH_ALIGN	 (32)
> +#define HFBC_BLOCK1_HEIGHT_ALIGN   (16)
> +#define HFBC_HEADER_ADDR_ALIGN	  (4)
> +#define HFBC_HEADER_STRIDE_ALIGN	  (32)
> +#define HFBC_HEADER_STRIDE_BLOCK	  (4)
> +#define HFBC_PAYLOAD0_ALIGN_8BIT       (512)
> +#define HFBC_PAYLOAD1_ALIGN_8BIT       (256)
> +#define HFBC_PAYLOAD_ALIGN_10BIT	(1024)
> +
> +#define HFBCD_BLOCK0_CROP_MAX	(7)
> +#define HFBCD_BLOCK0_ROT_CROP_MAX	(63)
> +#define HFBCD_BLOCK1_CROP_MAX	(15)
> +
> +/* MCTL  SYS */
> +/* SECU */
> +#define MCTL_RCH0_SECU_GATE		(0x0080)
> +#define MCTL_RCH1_SECU_GATE		(0x0084)
> +#define MCTL_RCH2_SECU_GATE		(0x0088)
> +#define MCTL_RCH3_SECU_GATE		(0x008C)
> +#define MCTL_RCH4_SECU_GATE		(0x0090)
> +#define MCTL_RCH5_SECU_GATE		(0x0094)
> +#define MCTL_RCH6_SECU_GATE		(0x0098)
> +#define MCTL_RCH7_SECU_GATE		(0x009C)
> +#define MCTL_RCH8_SECU_GATE		(0x00A0)
> +#define MCTL_OV2_SECU_GATE		(0x00B0)
> +#define MCTL_OV3_SECU_GATE		(0x00B4)
> +#define MCTL_DSI0_SECU_CFG			(0x00C0)
> +#define MCTL_DSI1_SECU_CFG			(0x00C4)
> +#define MCTL_DP_SECU_GATE			(0x00C8)
> +#define MCTL_DSI_MUX_SECU_GATE	(0x00CC)
> +/* FLUSH EN */
> +/* SW FOR RCH */
> +#define MCTL_RCH8_OV_OEN	(0x015C)
> +/* SW FOR OV */
> +#define MCTL_RCH_OV0_SEL1  (0x0190)
> +#define MCTL_RCH_OV1_SEL1  (0x0194)
> +#define MCTL_RCH_OV2_SEL1  (0x0198)
> +/* SW FOR WCH */
> +/* SW FOR OV2/3 OUTPUT */
> +/* SW */
> +/* RCH STARTY */
> +#define MCTL_RCH8_STARTY	(0x01E0)
> +/* LP */
> +
> +/* RCH */
> +#define MCTL_MOD_DBG_ADD_CH_NUM (2)  /* copybit */
> +
> +/* SBL */
> +/* SBL FOR ES */
> +#define SBL_REG_FRMT_MODE_ES                          (0x0000)
> +#define SBL_REG_FRMT_DBUF_CTRL_ES                     (0x0008)
> +#define SBL_REG_FRMT_FRAME_WIDTH_7_TO_0_ES            (0x0010)
> +#define SBL_REG_FRMT_FRAME_WIDTH_15_TO_8_ES           (0x0014)
> +#define SBL_REG_FRMT_FRAME_HEIGHT_7_TO_0_ES           (0x0018)
> +#define SBL_REG_FRMT_FRAME_HEIGHT_15_TO_8_ES          (0x001c)
> +#define SBL_REG_FRMT_ROI_HOR_START_7_TO_0_ES          (0x0080)
> +#define SBL_REG_FRMT_ROI_HOR_START_15_TO_8_ES         (0x0084)
> +#define SBL_REG_FRMT_ROI_HOR_END_7_TO_0_ES            (0x0088)
> +#define SBL_REG_FRMT_ROI_HOR_END_15_TO_8_ES           (0x008c)
> +#define SBL_REG_FRMT_ROI_VER_START_7_TO_0_ES          (0x0090)
> +#define SBL_REG_FRMT_ROI_VER_START_15_TO_8_ES         (0x0094)
> +#define SBL_REG_FRMT_ROI_VER_END_7_TO_0_ES            (0x0098)
> +#define SBL_REG_FRMT_ROI_VER_END_15_TO_8_ES           (0x009c)
> +#define SBL_REG_CALC_CONTROL_0_ES                     (0x0400)
> +#define SBL_REG_CALC_CONTROL_1_ES                     (0x0404)
> +#define SBL_REG_CALC_AMBIENT_LIGHT_7_TO_0_ES          (0x0408)
> +#define SBL_REG_CALC_AMBIENT_LIGHT_15_TO_8_ES         (0x040c)
> +#define SBL_REG_CALC_BACKLIGHT_7_TO_0_ES              (0x0410)
> +#define SBL_REG_CALC_BACKLIGHT_15_TO_8_ES             (0x0414)
> +#define SBL_REG_CALC_ASSERTIVENESS_ES                 (0x0418)
> +#define SBL_REG_CALC_TF_CONTROL_ES                    (0x041c)
> +#define SBL_REG_CALC_STRENGTH_MANUAL_7_TO_0_ES        (0x0420)
> +#define SBL_REG_CALC_STRENGTH_MANUAL_9_TO_8_ES        (0x0424)
> +#define SBL_REG_CALC_GAIN_AA_MANUAL_7_TO_0_ES         (0x0428)
> +#define SBL_REG_CALC_GAIN_AA_MANUAL_11_TO_8_ES        (0x042c)
> +#define SBL_REG_CALC_ROI_FACTOR_IN_7_TO_0_ES          (0x0430)
> +#define SBL_REG_CALC_ROI_FACTOR_IN_15_TO_8_ES         (0x0434)
> +#define SBL_REG_CALC_ROI_FACTOR_OUT_7_TO_0_ES         (0x0438)
> +#define SBL_REG_CALC_ROI_FACTOR_OUT_15_TO_8_ES        (0x043c)
> +#define SBL_REG_CALC_PSR_DELTA_CHANGE_7_TO_0_ES       (0x0448)
> +#define SBL_REG_CALC_PSR_DELTA_CHANGE_15_TO_8_ES      (0x044c)
> +#define SBL_REG_CALC_PSR_DELTA_SETTLE_7_TO_0_ES       (0x0450)
> +#define SBL_REG_CALC_PSR_DELTA_SETTLE_15_TO_8_ES      (0x0454)
> +#define SBL_REG_CALC_AL_SCALE_7_TO_0_ES               (0x0458)
> +#define SBL_REG_CALC_AL_SCALE_15_TO_8_ES              (0x045c)
> +#define SBL_REG_CALC_AL_TF_STEP_SAMPLE_ES             (0x0460)
> +#define SBL_REG_CALC_AL_TF_STEP_WAIT_7_TO_0_ES        (0x0468)
> +#define SBL_REG_CALC_AL_TF_STEP_WAIT_11_TO_8_ES       (0x046c)
> +#define SBL_REG_CALC_AL_TF_STEP_WAITUP_7_TO_0_ES      (0x0470)
> +#define SBL_REG_CALC_AL_TF_STEP_WAITUP_11_TO_8_ES     (0x0474)
> +#define SBL_REG_CALC_AL_TF_STEP_SIZE_7_TO_0_ES        (0x0478)
> +#define SBL_REG_CALC_AL_TF_STEP_SIZE_11_TO_8_ES       (0x047c)
> +#define SBL_REG_CALC_AL_TF_LIMIT_7_TO_0_ES            (0x0480)
> +#define SBL_REG_CALC_AL_TF_LIMIT_15_TO_8_ES           (0x0484)
> +#define SBL_REG_CALC_AL_TF_ALPHA_ES                   (0x0488)
> +#define SBL_REG_CALC_AL_TF_ALPHA_UP_ES                (0x048c)
> +#define SBL_REG_CALC_AL_TF_NOISE_7_TO_0_ES            (0x0490)
> +#define SBL_REG_CALC_AL_TF_NOISE_15_TO_8_ES           (0x0494)
> +#define SBL_REG_CALC_AL_TF_M_INC_7_TO_0_ES            (0x0498)
> +#define SBL_REG_CALC_AL_TF_M_INC_15_TO_8_ES           (0x049c)
> +#define SBL_REG_CALC_AL_TF_K_INC_7_TO_0_ES            (0x04a0)
> +#define SBL_REG_CALC_AL_TF_K_INC_15_TO_8_ES           (0x04a4)
> +#define SBL_REG_CALC_AL_TF_M_DEC_7_TO_0_ES            (0x04a8)
> +#define SBL_REG_CALC_AL_TF_M_DEC_15_TO_8_ES           (0x04ac)
> +#define SBL_REG_CALC_AL_TF_K_DEC_7_TO_0_ES            (0x04b0)
> +#define SBL_REG_CALC_AL_TF_K_DEC_15_TO_8_ES           (0x04b4)
> +#define SBL_REG_CALC_AL_TF_AGGRESSIVENESS_ES          (0x04b8)
> +#define SBL_REG_CALC_AL_RTF_FILTER_A_7_TO_0_ES        (0x04c0)
> +#define SBL_REG_CALC_AL_RTF_FILTER_A_15_TO_8_ES       (0x04c4)
> +#define SBL_REG_CALC_AL_RTF_FILTER_B_7_TO_0_ES        (0x04c8)
> +#define SBL_REG_CALC_AL_RTF_FILTER_B_15_TO_8_ES       (0x04cc)
> +#define SBL_REG_CALC_AL_RTF_FILTER_C_7_TO_0_ES        (0x04d0)
> +#define SBL_REG_CALC_AL_RTF_FILTER_C_15_TO_8_ES       (0x04d4)
> +#define SBL_REG_CALC_AB_AL_KNEE1_7_TO_0_ES            (0x04d8)
> +#define SBL_REG_CALC_AB_AL_KNEE1_15_TO_8_ES           (0x04dc)
> +#define SBL_REG_CALC_AB_AL_KNEE2_7_TO_0_ES            (0x04e0)
> +#define SBL_REG_CALC_AB_AL_KNEE2_15_TO_8_ES           (0x04e4)
> +#define SBL_REG_CALC_AB_BL_KNEE1_7_TO_0_ES            (0x04e8)
> +#define SBL_REG_CALC_AB_BL_KNEE1_15_TO_8_ES           (0x04ec)
> +#define SBL_REG_CALC_AB_BL_KNEE2_7_TO_0_ES            (0x04f0)
> +#define SBL_REG_CALC_AB_BL_KNEE2_15_TO_8_ES           (0x04f4)
> +#define SBL_REG_CALC_BL_PANEL_MAX_7_TO_0_ES           (0x04f8)
> +#define SBL_REG_CALC_BL_PANEL_MAX_15_TO_8_ES          (0x04fc)
> +#define SBL_REG_CALC_BL_OFFSET_7_TO_0_ES              (0x0500)
> +#define SBL_REG_CALC_BL_OFFSET_15_TO_8_ES             (0x0504)
> +#define SBL_REG_CALC_BL_MIN_7_TO_0_ES                 (0x0508)
> +#define SBL_REG_CALC_BL_MIN_15_TO_8_ES                (0x050c)
> +#define SBL_REG_CALC_BL_ATTEN_ALPHA_7_TO_0_ES         (0x0510)
> +#define SBL_REG_CALC_BL_ATTEN_ALPHA_9_TO_8_ES         (0x0514)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_7_TO_0_ES          (0x0518)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_15_TO_8_ES         (0x051c)
> +#define SBL_REG_CALC_SBC1_TF_STEP_7_TO_0_ES           (0x0520)
> +#define SBL_REG_CALC_SBC1_TF_STEP_15_TO_8_ES          (0x0524)
> +#define SBL_REG_CALC_SBC1_TF_ASYM_ES                  (0x0528)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_LOG_7_TO_0_ES      (0x0530)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_LOG_15_TO_8_ES     (0x0534)
> +#define SBL_REG_CALC_SBC1_TF_STEP_LOG_7_TO_0_ES       (0x0538)
> +#define SBL_REG_CALC_SBC1_TF_STEP_LOG_15_TO_8_ES      (0x053c)
> +#define SBL_REG_CALC_SBC1_TF_ASYM_LOG_ES              (0x0540)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_7_TO_0_ES          (0x0548)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_15_TO_8_ES         (0x054c)
> +#define SBL_REG_CALC_SBC2_TF_STEP_7_TO_0_ES           (0x0550)
> +#define SBL_REG_CALC_SBC2_TF_STEP_15_TO_8_ES          (0x0554)
> +#define SBL_REG_CALC_SBC2_TF_ASYM_ES                  (0x0558)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_LOG_7_TO_0_ES      (0x0560)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_LOG_15_TO_8_ES     (0x0564)
> +#define SBL_REG_CALC_SBC2_TF_STEP_LOG_7_TO_0_ES       (0x0568)
> +#define SBL_REG_CALC_SBC2_TF_STEP_LOG_15_TO_8_ES      (0x056c)
> +#define SBL_REG_CALC_SBC2_TF_ASYM_LOG_ES              (0x0570)
> +#define SBL_REG_CALC_CALIBRATION_A_7_TO_0_ES          (0x05b8)
> +#define SBL_REG_CALC_CALIBRATION_A_15_TO_8_ES         (0x05bc)
> +#define SBL_REG_CALC_CALIBRATION_B_7_TO_0_ES          (0x05c0)
> +#define SBL_REG_CALC_CALIBRATION_B_15_TO_8_ES         (0x05c4)
> +#define SBL_REG_CALC_CALIBRATION_C_7_TO_0_ES          (0x05c8)
> +#define SBL_REG_CALC_CALIBRATION_C_15_TO_8_ES         (0x05cc)
> +#define SBL_REG_CALC_CALIBRATION_D_7_TO_0_ES          (0x05d0)
> +#define SBL_REG_CALC_CALIBRATION_D_15_TO_8_ES         (0x05d4)
> +#define SBL_REG_CALC_CALIBRATION_E_7_TO_0_ES          (0x05d8)
> +#define SBL_REG_CALC_CALIBRATION_E_15_TO_8_ES         (0x05dc)
> +#define SBL_REG_CALC_BACKLIGHT_SCALE_7_TO_0_ES        (0x05e0)
> +#define SBL_REG_CALC_BACKLIGHT_SCALE_15_TO_8_ES       (0x05e4)
> +#define SBL_REG_CALC_GAIN_AA_TF_DEPTH_7_TO_0_ES       (0x05e8)
> +#define SBL_REG_CALC_GAIN_AA_TF_DEPTH_15_TO_8_ES      (0x05ec)
> +#define SBL_REG_CALC_GAIN_AA_TF_STEP_7_TO_0_ES        (0x05f0)
> +#define SBL_REG_CALC_GAIN_AA_TF_STEP_11_TO_8_ES       (0x05f4)
> +#define SBL_REG_CALC_GAIN_AA_TF_ASYM_ES               (0x05f8)
> +#define SBL_REG_CALC_STRENGTH_LIMIT_7_TO_0_ES         (0x0600)
> +#define SBL_REG_CALC_STRENGTH_LIMIT_9_TO_8_ES         (0x0604)
> +#define SBL_REG_CALC_ICUT_HIST_MIN_ES                 (0x0608)
> +#define SBL_REG_CALC_ICUT_BL_MIN_7_TO_0_ES            (0x0610)
> +#define SBL_REG_CALC_ICUT_BL_MIN_15_TO_8_ES           (0x0614)
> +#define SBL_REG_CALC_GAIN_CA_TF_DEPTH_7_TO_0_ES       (0x0618)
> +#define SBL_REG_CALC_GAIN_CA_TF_DEPTH_15_TO_8_ES      (0x061c)
> +#define SBL_REG_CALC_GAIN_CA_TF_STEP_7_TO_0_ES        (0x0620)
> +#define SBL_REG_CALC_GAIN_CA_TF_STEP_11_TO_8_ES       (0x0624)
> +#define SBL_REG_CALC_GAIN_CA_TF_ASYM_ES               (0x0628)
> +#define SBL_REG_CALC_GAIN_MAX_7_TO_0_ES               (0x0630)
> +#define SBL_REG_CALC_GAIN_MAX_11_TO_8_ES              (0x0634)
> +#define SBL_REG_CALC_GAIN_MIDDLE_7_TO_0_ES            (0x0638)
> +#define SBL_REG_CALC_GAIN_MIDDLE_11_TO_8_ES           (0x063c)
> +#define SBL_REG_CALC_BRIGHTPR_ES                      (0x0640)
> +#define SBL_REG_CALC_BPR_CORRECT_ES                   (0x0648)
> +#define SBL_CALC_BACKLIGHT_OUT_7_TO_0_ES              (0x0650)
> +#define SBL_CALC_BACKLIGHT_OUT_15_TO_8_ES             (0x0654)
> +#define SBL_CALC_STRENGTH_INROI_OUT_7_TO_0_ES         (0x0658)
> +#define SBL_CALC_STRENGTH_INROI_OUT_9_TO_8_ES         (0x065c)
> +#define SBL_CALC_STRENGTH_OUTROI_OUT_7_TO_0_ES        (0x0660)
> +#define SBL_CALC_STRENGTH_OUTROI_OUT_9_TO_8_ES        (0x0664)
> +#define SBL_CALC_DARKENH_OUT_7_TO_0_ES                (0x0668)
> +#define SBL_CALC_DARKENH_OUT_15_TO_8_ES               (0x066c)
> +#define SBL_CALC_BRIGHTPR_OUT_ES                      (0x0670)
> +#define SBL_CALC_STAT_OUT_7_TO_0_ES                   (0x0678)
> +#define SBL_CALC_STAT_OUT_15_TO_8_ES                  (0x067c)
> +#define SBL_REG_CALC_AL_DELTA_SETTLE_7_TO_0_ES        (0x0680)
> +#define SBL_REG_CALC_AL_DELTA_SETTLE_15_TO_8_ES       (0x0684)
> +#define SBL_REG_CALC_BL_DELTA_SETTLE_7_TO_0_ES        (0x0688)
> +#define SBL_REG_CALC_BL_DELTA_SETTLE_15_TO_8_ES       (0x068c)
> +#define SBL_CALC_AL_CALIB_LUT_ADDR_I_ES               (0x06c0)
> +#define SBL_CALC_AL_CALIB_LUT_DATA_W_7_TO_0_ES        (0x06d0)
> +#define SBL_CALC_AL_CALIB_LUT_DATA_W_15_TO_8_ES       (0x06d4)
> +#define SBL_CALC_BL_IN_LUT_ADDR_I_ES                  (0x0700)
> +#define SBL_CALC_BL_IN_LUT_DATA_W_7_TO_0_ES           (0x0710)
> +#define SBL_CALC_BL_IN_LUT_DATA_W_15_TO_8_ES          (0x0714)
> +#define SBL_CALC_BL_OUT_LUT_ADDR_I_ES                 (0x0740)
> +#define SBL_CALC_BL_OUT_LUT_DATA_W_7_TO_0_ES          (0x0750)
> +#define SBL_CALC_BL_OUT_LUT_DATA_W_15_TO_8_ES         (0x0754)
> +#define SBL_CALC_BL_ATTEN_LUT_ADDR_I_ES               (0x0780)
> +#define SBL_CALC_BL_ATTEN_LUT_DATA_W_7_TO_0_ES        (0x0790)
> +#define SBL_CALC_BL_ATTEN_LUT_DATA_W_15_TO_8_ES       (0x0794)
> +#define SBL_CALC_BL_AUTO_LUT_ADDR_I_ES                (0x07c0)
> +#define SBL_CALC_BL_AUTO_LUT_DATA_W_7_TO_0_ES         (0x07d0)
> +#define SBL_CALC_BL_AUTO_LUT_DATA_W_15_TO_8_ES        (0x07d4)
> +#define SBL_CALC_AL_CHANGE_LUT_ADDR_I_ES              (0x0800)
> +#define SBL_CALC_AL_CHANGE_LUT_DATA_W_7_TO_0_ES       (0x0810)
> +#define SBL_CALC_AL_CHANGE_LUT_DATA_W_15_TO_8_ES      (0x0814)
> +#define SBL_REG_CABC_INTENSITY_7_TO_0_ES              (0x0900)
> +#define SBL_REG_CABC_INTENSITY_11_TO_8_ES             (0x0904)
> +#define SBL_REG_CABC_ICUT_SELECT_ES                   (0x0908)
> +#define SBL_REG_CABC_ICUT_MANUAL_ES                   (0x090c)
> +#define SBL_CABC_ICUT_OUT_ES                          (0x0910)
> +#define SBL_REG_CORE1_VC_CONTROL_0_ES                 (0x0c00)
> +#define SBL_REG_CORE1_IRDX_CONTROL_0_ES               (0x0c40)
> +#define SBL_REG_CORE1_IRDX_CONTROL_1_ES               (0x0c44)
> +#define SBL_REG_CORE1_IRDX_VARIANCE_ES                (0x0c4c)
> +#define SBL_REG_CORE1_IRDX_SLOPE_MAX_ES               (0x0c50)
> +#define SBL_REG_CORE1_IRDX_SLOPE_MIN_ES               (0x0c54)
> +#define SBL_REG_CORE1_IRDX_BLACK_LEVEL_7_TO_0_ES      (0x0c58)
> +#define SBL_REG_CORE1_IRDX_BLACK_LEVEL_9_TO_8_ES      (0x0c5c)
> +#define SBL_REG_CORE1_IRDX_WHITE_LEVEL_7_TO_0_ES      (0x0c60)
> +#define SBL_REG_CORE1_IRDX_WHITE_LEVEL_9_TO_8_ES      (0x0c64)
> +#define SBL_REG_CORE1_IRDX_LIMIT_AMPL_ES              (0x0c68)
> +#define SBL_REG_CORE1_IRDX_DITHER_ES                  (0x0c6c)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_INROI_7_TO_0_ES   (0x0c70)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_INROI_9_TO_8_ES   (0x0c74)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_OUTROI_7_TO_0_ES  (0x0c78)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_OUTROI_9_TO_8_ES  (0x0c7c)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_ADDR_I_ES        (0x0c80)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_DATA_W_7_TO_0_ES (0x0c84)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_DATA_W_11_TO_8_ES (0x0c88)
> +#define SBL_CORE1_IRDX_COLOR_LUT_ADDR_I_ES            (0x0cc0)
> +#define SBL_CORE1_IRDX_COLOR_LUT_DATA_W_7_TO_0_ES     (0x0cc4)
> +#define SBL_CORE1_IRDX_COLOR_LUT_DATA_W_11_TO_8_ES    (0x0cc8)
> +#define SBL_REG_CORE1_IRDX_FILTER_CTRL_ES             (0x0d00)
> +#define SBL_REG_CORE1_IRDX_SVARIANCE_ES               (0x0d04)
> +#define SBL_REG_CORE1_IRDX_BRIGHTPR_ES                (0x0d08)
> +#define SBL_REG_CORE1_IRDX_CONTRAST_ES                (0x0d0c)
> +#define SBL_REG_CORE1_IRDX_DARKENH_7_TO_0_ES          (0x0d10)
> +#define SBL_REG_CORE1_IRDX_DARKENH_15_TO_8_ES         (0x0d14)
> +#define SBL_REG_CORE1_DTHR_CONTROL_ES                 (0x0dc0)
> +#define SBL_REG_CORE1_LOGO_TOP_ES                     (0x0dd0)
> +#define SBL_REG_CORE1_LOGO_LEFT_ES                    (0x0dd4)
> +#define SBL_REG_CORE1_CA_D_ARTITHRESH_7_TO_0_ES       (0x0e00)
> +#define SBL_REG_CORE1_CA_D_ARTITHRESH_9_TO_8_ES       (0x0e04)
> +#define SBL_CORE1_CA_STR_ATTEN_7_TO_0_ES              (0x0e10)
> +#define SBL_CORE1_CA_STR_ATTEN_15_TO_8_ES             (0x0e14)
> +#define SBL_CORE1_CA_STR_ATTEN_16_ES                  (0x0e18)
> +#define SBL_REG_CORE1_FRD_D_THRESH_7_TO_0_ES          (0x0e20)
> +#define SBL_REG_CORE1_FRD_D_THRESH_9_TO_8_ES          (0x0e24)
> +#define SBL_REG_CORE1_REG0_7_TO_0_ES                  (0x0e28)
> +#define SBL_REG_CORE1_REG0_15_TO_8_ES                 (0x0e2c)
> +#define SBL_REG_CORE1_REG1_7_TO_0_ES                  (0x0e30)
> +#define SBL_REG_CORE1_REG1_15_TO_8_ES                 (0x0e34)
> +#define SBL_REG_CORE1_REG2_7_TO_0_ES                  (0x0e38)
> +#define SBL_REG_CORE1_REG2_15_TO_8_ES                 (0x0e3c)
> +#define SBL_REG_CORE1_REG3_7_TO_0_ES                  (0x0e40)
> +#define SBL_REG_CORE1_REG3_15_TO_8_ES                 (0x0e44)
> +#define SBL_REG_CORE1_REG4_7_TO_0_ES                  (0x0e48)
> +#define SBL_REG_CORE1_REG4_15_TO_8_ES                 (0x0e4c)
> +#define SBL_REG_CORE1_REG5_7_TO_0_ES                  (0x0e50)
> +#define SBL_REG_CORE1_REG5_15_TO_8_ES                 (0x0e54)
> +#define SBL_CORE1_REG_OUT0_7_TO_0_ES                  (0x0e58)
> +#define SBL_CORE1_REG_OUT0_15_TO_8_ES                 (0x0e5c)
> +#define SBL_CORE1_REG_OUT1_7_TO_0_ES                  (0x0e60)
> +#define SBL_CORE1_REG_OUT1_15_TO_8_ES                 (0x0e64)
> +
> +/* SBL for 970 */
> +#define SBL_REG_FRMT_MODE                                  (0x0000)
> +#define SBL_REG_FRMT_FRAME_DIMEN                           (0x0004)
> +#define SBL_REG_FRMT_HW_VERSION                            (0x0014)
> +#define SBL_REG_FRMT_ROI_HOR                               (0x0020)
> +#define SBL_REG_FRMT_ROI_VER                               (0x0024)
> +#define SBL_REG_CALC_CONTROL                               (0x0100)
> +#define SBL_REG_AL_BL                                      (0x0104)
> +#define SBL_REG_FILTERS_CTRL                               (0x0108)
> +#define SBL_REG_MANUAL                                     (0x010c)
> +#define SBL_REG_CALC_ROI_FACTOR                            (0x0110)
> +#define SBL_REG_CALC_PSR_DELTA                             (0x0114)
> +#define SBL_REG_CALC_AL                                    (0x0118)
> +#define SBL_REG_CALC_AL_TF_STEP_WAIT                       (0x011c)
> +#define SBL_REG_CALC_AL_TF_STEP_SIZE_LIMIT                 (0x0120)
> +#define SBL_REG_CALC_AL_TF_ALPHA                           (0x0124)
> +#define SBL_REG_CALC_AL_TF_NOISE_M_INC                     (0x0128)
> +#define SBL_REG_CALC_AL_TF_K_INC_M_DEC                     (0x012c)
> +#define SBL_REG_CALC_AL_TF_K_DEC_AGGRESSIVENESS            (0x0130)
> +#define SBL_REG_CALC_AL_RTF_FILTER_A_7_TO_0                (0x0134)
> +#define SBL_REG_CALC_AL_RTF_FILTER_C_AB_AL_KNEE1           (0x0138)
> +#define SBL_REG_CALC_AB_AL_KNEE2_AB_BL_KNEE1               (0x013c)
> +#define SBL_REG_CALC_AB_BL_KNEE2_BL_PANEL_MAX              (0x0140)
> +#define SBL_REG_CALC_BL_OFFSET_BL_MIN                      (0x0144)
> +#define SBL_REG_CALC_BL_ATTEN_ALPHA_SBC1_TF_DEPTH          (0x0148)
> +#define SBL_REG_CALC_SBC1_TF_STEP_SBC1_TF_ASYM             (0x014c)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_LOG_SBC1_TF_STEP_LOG    (0x0150)
> +#define SBL_REG_CALC_SBC1_TF_ASYM_LOG_SBC2_TF_DEPTH        (0x0154)
> +#define SBL_REG_CALC_SBC2_TF_STEP_SBC2_TF_ASYM             (0x0158)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_LOG_SBC2_TF_STEP_LOG    (0x015c)
> +#define SBL_REG_CALC_SBC2_TF_ASYM_LOG                      (0x0160)
> +#define SBL_REG_CALC_CALIBRATION_A_B                       (0x0170)
> +#define SBL_REG_CALC_CALIBRATION_C_D                       (0x0174)
> +#define SBL_REG_CALC_CALIBRATION_E_BACKLIGHT_SCALE         (0x0178)
> +#define SBL_REG_CALC_GAIN_AA_TF_DEPTH_STEP                 (0x017c)
> +#define SBL_REG_CALC_GAIN_AA_TF_ASYM_STRENGTH_LIMIT        (0x0180)
> +#define SBL_REG_CALC_ICUT_HIST_MIN_ICUT_BL_MIN             (0x0184)
> +#define SBL_REG_CALC_GAIN_CA_TF_DEPTH_GAIN_CA_TF_STEP      (0x0188)
> +#define SBL_REG_CALC_GAIN_CA_TF_ASYM_GAIN_MAX              (0x018c)
> +#define SBL_REG_CALC_GAIN_MIDDLE_CALC_BRIGHTPR             (0x0190)
> +#define SBL_REG_CALC_BPR_CORRECT_CALC_BACKLIGHT_OUT        (0x0194)
> +#define SBL_CALC_STRENGTH_INROI_OUTROI_OUT                 (0x0198)
> +#define SBL_CALC_DARKENH_OUT_CALC_BRIGHTPR_OUT             (0x019c)
> +#define SBL_CALC_STAT_OUT                                  (0x01A0)
> +#define SBL_REG_CALC_BL_DELTA_SETTLE                       (0x01A4)
> +#define SBL_CALC_AL_CALIB_LUT_ADDR_I                       (0x01B0)
> +#define SBL_CALC_AL_CALIB_LUT_DATA_W                       (0x01B4)
> +#define SBL_CALC_BL_IN_LUT_ADDR_I                          (0x01C0)
> +#define SBL_CALC_BL_IN_LUT_DATA_W                          (0x01C4)
> +#define SBL_CALC_BL_OUT_LUT_ADDR_I                         (0x01D0)
> +#define SBL_CALC_BL_OUT_LUT_DATA_W                         (0x01D4)
> +#define SBL_CALC_BL_ATTEN_LUT_ADDR_I                       (0x01E0)
> +#define SBL_CALC_BL_ATTEN_LUT_DATA_W                       (0x01E4)
> +#define SBL_CALC_BL_AUTO_LUT_ADDR_I                        (0x01F0)
> +#define SBL_CALC_BL_AUTO_LUT_DATA_W                        (0x01F4)
> +#define SBL_CALC_AL_CHANGE_LUT_ADDR_I                      (0x0200)
> +#define SBL_CALC_AL_CHANGE_LUT_DATA_W                      (0x0204)
> +#define SBL_REG_CABC_INTENSITY_CABC_ICUT_SELECT            (0x0240)
> +#define SBL_REG_CABC_ICUT_MANUAL_CABC_ICUT_OUT             (0x0244)
> +#define SBL_REG_VC_VC_CONTROL_0                            (0x0300)
> +#define SBL_REG_VC_IRDX_CONTROL                            (0x0308)
> +#define SBL_REG_VC_IRDX_ALPHA_MANUAL_VC_IRDX_BETA_MANUA    (0x030c)
> +#define SBL_REG_VC_IRDX_VARIANCE                           (0x0310)
> +#define SBL_REG_VC_IRDX_SLOPE_MAX_MIN                      (0x0314)
> +#define SBL_REG_VC_IRDX_BLACK_WHITE_LEVEL_7_TO_0           (0x0318)
> +#define SBL_REG_VC_IRDX_LIMIT_AMPL_VC_IRDX_DITHER          (0x031c)
> +#define SBL_REG_VC_IRDX_STRENGTH_INROI_OUTROI              (0x0320)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_ADDR_I                (0x0324)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_DATA_W                (0x0328)
> +#define SBL_CORE1_IRDX_COLOR_LUT_ADDR_I                    (0x0334)
> +#define SBL_CORE1_IRDX_COLOR_LUT_DATA_W                    (0x0338)
> +#define SBL_REG_VC_IRDX_FILTER_CTRL                        (0x0344)
> +#define SBL_REG_VC_IRDX_BRIGHTPR                           (0x0348)
> +#define SBL_REG_VC_IRDX_CONTRAST                           (0x034c)
> +#define SBL_REG_VC_IRDX_DARKENH                            (0x0350)
> +#define SBL_REG_VC_DTHR_CONTROL                            (0x0370)
> +#define SBL_REG_VC_LOGO_TOP_LEFT                           (0x0374)
> +#define SBL_REG_VC_CA_D_ARTITHRESH                         (0x0380)
> +#define SBL_VC_CA_STR_ATTEN                                (0x0384)
> +#define SBL_REG_VC_REG1_REG2                               (0x038c)
> +#define SBL_REG_VC_REG3_REG4                               (0x0390)
> +#define SBL_REG_VC_REG5_REG_OUT0                           (0x0394)
> +#define SBL_VC_REG_OUT1                                    (0x0398)
> +#define SBL_VC_ANTI_FLCKR_CONTROL                          (0x039c)
> +#define SBL_VC_ANTI_FLCKR_RFD_FRD_THR                      (0x03a0)
> +#define SBL_VC_ANTI_FLCKR_SCD_THR_ANTI_FLCKR_FD3_SC_DLY    (0x03a4)
> +#define SBL_VC_ANTI_FLCKR_AL_ANTI_FLCKR_T_DURATION         (0x03a8)
> +#define SBL_VC_ANTI_FLCKR_ALPHA                            (0x03ac)
> +
> +/* DPP */
> +/* DPP TOP */
> +/* #define DPP_ARSR1P_MEM_CTRL	(0x01C) */
> +#define DPP_ARSR_POST_MEM_CTRL	(0x01C)
> +/* #define DPP_ARSR1P	(0x048) */
> +
> +/* DITHER */
> +#define DITHER_CTL1 (0x000)
> +#define DITHER_CTL0 (0x004)
> +#define DITHER_TRI_THD12_0 (0x008)
> +#define DITHER_TRI_THD12_1 (0x00C)
> +#define DITHER_TRI_THD10 (0x010)
> +#define DITHER_TRI_THD12_UNI_0 (0x014)
> +#define DITHER_TRI_THD12_UNI_1 (0x018)
> +#define DITHER_TRI_THD10_UNI (0x01C)
> +#define DITHER_BAYER_CTL (0x020)
> +#define DITHER_BAYER_ALPHA_THD (0x024)
> +#define DITHER_MATRIX_PART1 (0x028)
> +#define DITHER_MATRIX_PART0 (0x02C)
> +#define DITHER_HIFREQ_REG_INI_CFG_EN (0x030)
> +#define DITHER_HIFREQ_REG_INI0_0 (0x034)
> +#define DITHER_HIFREQ_REG_INI0_1 (0x038)
> +#define DITHER_HIFREQ_REG_INI0_2 (0x03C)
> +#define DITHER_HIFREQ_REG_INI0_3 (0x040)
> +#define DITHER_HIFREQ_REG_INI1_0 (0x044)
> +#define DITHER_HIFREQ_REG_INI1_1 (0x048)
> +#define DITHER_HIFREQ_REG_INI1_2 (0x04C)
> +#define DITHER_HIFREQ_REG_INI1_3 (0x050)
> +#define DITHER_HIFREQ_REG_INI2_0 (0x054)
> +#define DITHER_HIFREQ_REG_INI2_1 (0x058)
> +#define DITHER_HIFREQ_REG_INI2_2 (0x05C)
> +#define DITHER_HIFREQ_REG_INI2_3 (0x060)
> +#define DITHER_HIFREQ_POWER_CTRL (0x064)
> +#define DITHER_HIFREQ_FILT_0 (0x068)
> +#define DITHER_HIFREQ_FILT_1 (0x06C)
> +#define DITHER_HIFREQ_FILT_2 (0x070)
> +#define DITHER_HIFREQ_THD_R0 (0x074)
> +#define DITHER_HIFREQ_THD_R1 (0x078)
> +#define DITHER_HIFREQ_THD_G0 (0x07C)
> +#define DITHER_HIFREQ_THD_G1 (0x080)
> +#define DITHER_HIFREQ_THD_B0 (0x084)
> +#define DITHER_HIFREQ_THD_B1 (0x088)
> +#define DITHER_HIFREQ_DBG0 (0x08C)
> +#define DITHER_HIFREQ_DBG1 (0x090)
> +#define DITHER_HIFREQ_DBG2 (0x094)
> +#define DITHER_ERRDIFF_CTL (0x098)
> +#define DITHER_ERRDIFF_WEIGHT (0x09C)
> +#define DITHER_FRC_CTL (0x0A0)
> +#define DITHER_FRC_01_PART1 (0x0A4)
> +#define DITHER_FRC_01_PART0 (0x0A8)
> +#define DITHER_FRC_10_PART1 (0x0AC)
> +#define DITHER_FRC_10_PART0 (0x0B0)
> +#define DITHER_FRC_11_PART1 (0x0B4)
> +#define DITHER_FRC_11_PART0 (0x0B8)
> +#define DITHER_MEM_CTRL (0x0BC)
> +#define DITHER_DBG0 (0x0C0)
> +#define DITHER_DBG1 (0x0C4)
> +#define DITHER_DBG2 (0x0C8)
> +#define DITHER_CTRL2 (0x0CC)
> +
> +/* Dither for ES */
> +#define DITHER_PARA_ES (0x000)
> +#define DITHER_CTL_ES (0x004)
> +#define DITHER_MATRIX_PART1_ES (0x008)
> +#define DITHER_MATRIX_PART0_ES (0x00C)
> +#define DITHER_ERRDIFF_WEIGHT_ES (0x010)
> +#define DITHER_FRC_01_PART1_ES (0x014)
> +#define DITHER_FRC_01_PART0_ES (0x018)
> +#define DITHER_FRC_10_PART1_ES (0x01C)
> +#define DITHER_FRC_10_PART0_ES (0x020)
> +#define DITHER_FRC_11_PART1_ES (0x024)
> +#define DITHER_FRC_11_PART0_ES (0x028)
> +#define DITHER_MEM_CTRL_ES (0x02C)
> +#define DITHER_DBG0_ES (0x030)
> +#define DITHER_DBG1_ES (0x034)
> +#define DITHER_DBG2_ES (0x038)
> +
> +/* CSC_RGB2YUV_10bits  CSC_YUV2RGB_10bits */
> +
> +/* GAMA */
> +#define GAMA_LUT_SEL (0x008)
> +#define GAMA_DBG0 (0x00C)
> +#define GAMA_DBG1 (0x010)
> +
> +/* ACM for ES */
> +#define ACM_EN_ES            (0x000)
> +#define ACM_SATA_OFFSET_ES   (0x004)
> +#define ACM_HUESEL_ES        (0x008)
> +#define ACM_CSC_IDC0_ES      (0x00C)
> +#define ACM_CSC_IDC1_ES      (0x010)
> +#define ACM_CSC_IDC2_ES      (0x014)
> +#define ACM_CSC_P00_ES       (0x018)
> +#define ACM_CSC_P01_ES       (0x01C)
> +#define ACM_CSC_P02_ES       (0x020)
> +#define ACM_CSC_P10_ES       (0x024)
> +#define ACM_CSC_P11_ES       (0x028)
> +#define ACM_CSC_P12_ES       (0x02C)
> +#define ACM_CSC_P20_ES       (0x030)
> +#define ACM_CSC_P21_ES       (0x034)
> +#define ACM_CSC_P22_ES       (0x038)
> +#define ACM_CSC_MRREC_ES     (0x03C)
> +#define ACM_R0_H_ES          (0x040)
> +#define ACM_R1_H_ES          (0x044)
> +#define ACM_R2_H_ES          (0x048)
> +#define ACM_R3_H_ES          (0x04C)
> +#define ACM_R4_H_ES          (0x050)
> +#define ACM_R5_H_ES          (0x054)
> +#define ACM_R6_H_ES          (0x058)
> +#define ACM_LUT_DIS0_ES      (0x05C)
> +#define ACM_LUT_DIS1_ES      (0x060)
> +#define ACM_LUT_DIS2_ES      (0x064)
> +#define ACM_LUT_DIS3_ES      (0x068)
> +#define ACM_LUT_DIS4_ES      (0x06C)
> +#define ACM_LUT_DIS5_ES      (0x070)
> +#define ACM_LUT_DIS6_ES      (0x074)
> +#define ACM_LUT_DIS7_ES      (0x078)
> +#define ACM_LUT_PARAM0_ES    (0x07C)
> +#define ACM_LUT_PARAM1_ES    (0x080)
> +#define ACM_LUT_PARAM2_ES    (0x084)
> +#define ACM_LUT_PARAM3_ES    (0x088)
> +#define ACM_LUT_PARAM4_ES    (0x08C)
> +#define ACM_LUT_PARAM5_ES    (0x090)
> +#define ACM_LUT_PARAM6_ES    (0x094)
> +#define ACM_LUT_PARAM7_ES    (0x098)
> +#define ACM_LUT_SEL_ES       (0x09C)
> +#define ACM_MEM_CTRL_ES      (0x0A0)
> +#define ACM_DEBUG_TOP_ES     (0x0A4)
> +#define ACM_DEBUG_CFG_ES     (0x0A8)
> +#define ACM_DEBUG_W_ES       (0x0AC)
> +
> +/* ACM */
> +#define ACM_HUE_RLH01 (0x040)
> +#define ACM_HUE_RLH23 (0x044)
> +#define ACM_HUE_RLH45 (0x048)
> +#define ACM_HUE_RLH67 (0x04C)
> +#define ACM_HUE_PARAM01 (0x060)
> +#define ACM_HUE_PARAM23 (0x064)
> +#define ACM_HUE_PARAM45 (0x068)
> +#define ACM_HUE_PARAM67 (0x06C)
> +#define ACM_HUE_SMOOTH0 (0x070)
> +#define ACM_HUE_SMOOTH1 (0x074)
> +#define ACM_HUE_SMOOTH2 (0x078)
> +#define ACM_HUE_SMOOTH3 (0x07C)
> +#define ACM_HUE_SMOOTH4 (0x080)
> +#define ACM_HUE_SMOOTH5 (0x084)
> +#define ACM_HUE_SMOOTH6 (0x088)
> +#define ACM_HUE_SMOOTH7 (0x08C)
> +#define ACM_DBG_TOP (0x0A4)
> +#define ACM_DBG_CFG (0x0A8)
> +#define ACM_DBG_W (0x0AC)
> +#define ACM_COLOR_CHOOSE (0x0B0)
> +#define ACM_RGB2YUV_IDC0 (0x0C0)
> +#define ACM_RGB2YUV_IDC1 (0x0C4)
> +#define ACM_RGB2YUV_IDC2 (0x0C8)
> +#define ACM_RGB2YUV_P00 (0x0CC)
> +#define ACM_RGB2YUV_P01 (0x0D0)
> +#define ACM_RGB2YUV_P02 (0x0D4)
> +#define ACM_RGB2YUV_P10 (0x0D8)
> +#define ACM_RGB2YUV_P11 (0x0DC)
> +#define ACM_RGB2YUV_P12 (0x0E0)
> +#define ACM_RGB2YUV_P20 (0x0E4)
> +#define ACM_RGB2YUV_P21 (0x0E8)
> +#define ACM_RGB2YUV_P22 (0x0EC)
> +#define ACM_FACE_CRTL (0x100)
> +#define ACM_FACE_STARTXY (0x104)
> +#define ACM_FACE_SMOOTH_LEN01 (0x108)
> +#define ACM_FACE_SMOOTH_LEN23 (0x10C)
> +#define ACM_FACE_SMOOTH_PARAM0 (0x118)
> +#define ACM_FACE_SMOOTH_PARAM1 (0x11C)
> +#define ACM_FACE_SMOOTH_PARAM2 (0x120)
> +#define ACM_FACE_SMOOTH_PARAM3 (0x124)
> +#define ACM_FACE_SMOOTH_PARAM4 (0x128)
> +#define ACM_FACE_SMOOTH_PARAM5 (0x12C)
> +#define ACM_FACE_SMOOTH_PARAM6 (0x130)
> +#define ACM_FACE_SMOOTH_PARAM7 (0x134)
> +#define ACM_FACE_AREA_SEL (0x138)
> +#define ACM_FACE_SAT_LH (0x13C)
> +#define ACM_FACE_SAT_SMOOTH_LH (0x140)
> +#define ACM_FACE_SAT_SMO_PARAM_LH (0x148)
> +#define ACM_L_CONT_EN (0x160)
> +#define ACM_LC_PARAM01 (0x174)
> +#define ACM_LC_PARAM23 (0x178)
> +#define ACM_LC_PARAM45 (0x17C)
> +#define ACM_LC_PARAM67 (0x180)
> +#define ACM_L_ADJ_CTRL (0x1A0)
> +#define ACM_CAPTURE_CTRL (0x1B0)
> +#define ACM_CAPTURE_IN (0x1B4)
> +#define ACM_CAPTURE_OUT (0x1B8)
> +#define ACM_INK_CTRL (0x1C0)
> +#define ACM_INK_OUT (0x1C4)
> +
> +/* ACE FOR ES */
> +
> +/* LCP */
> +#define LCP_GMP_BYPASS_EN_ES	(0x030)
> +#define LCP_XCC_BYPASS_EN_ES	(0x034)
> +#define LCP_DEGAMA_EN_ES	(0x038)
> +#define LCP_DEGAMA_MEM_CTRL_ES	(0x03C)
> +#define LCP_GMP_MEM_CTRL_ES	(0x040)
> +
> +/* XCC */
> +#define XCC_COEF_00 (0x000)
> +#define XCC_COEF_01 (0x004)
> +#define XCC_COEF_02 (0x008)
> +#define XCC_COEF_03 (0x00C)
> +#define XCC_COEF_10 (0x010)
> +#define XCC_COEF_11 (0x014)
> +#define XCC_COEF_12 (0x018)
> +#define XCC_COEF_13 (0x01C)
> +#define XCC_COEF_20 (0x020)
> +#define XCC_COEF_21 (0x024)
> +#define XCC_COEF_22 (0x028)
> +#define XCC_COEF_23 (0x02C)
> +#define XCC_EN (0x034)
> +
> +/* DEGAMMA */
> +#define DEGAMA_EN (0x000)
> +#define DEGAMA_MEM_CTRL (0x004)
> +#define DEGAMA_LUT_SEL (0x008)
> +#define DEGAMA_DBG0 (0x00C)
> +#define DEGAMA_DBG1 (0x010)
> +
> +/* GMP */
> +#define GMP_EN (0x000)
> +#define GMP_MEM_CTRL (0x004)
> +#define GMP_LUT_SEL (0x008)
> +#define GMP_DBG_W0 (0x00C)
> +#define GMP_DBG_R0 (0x010)
> +#define GMP_DBG_R1 (0x014)
> +#define GMP_DBG_R2 (0x018)
> +
> +/* ARSR1P ES */
> +#define ARSR1P_IHLEFT_ES		(0x000)
> +#define ARSR1P_IHRIGHT_ES          (0x004)
> +#define ARSR1P_IHLEFT1_ES          (0x008)
> +#define ARSR1P_IHRIGHT1_ES         (0x00C)
> +#define ARSR1P_IVTOP_ES            (0x010)
> +#define ARSR1P_IVBOTTOM_ES         (0x014)
> +#define ARSR1P_UV_OFFSET_ES		(0x018)
> +#define ARSR1P_IHINC_ES            (0x01C)
> +#define ARSR1P_IVINC_ES            (0x020)
> +#define ARSR1P_MODE_ES		(0x024)
> +#define ARSR1P_FORMAT_ES           (0x028)
> +#define ARSR1P_SKIN_THRES_Y_ES	(0x02C)
> +#define ARSR1P_SKIN_THRES_U_ES	(0x030)
> +#define ARSR1P_SKIN_THRES_V_ES	(0x034)
> +#define ARSR1P_SKIN_EXPECTED_ES    (0x038)
> +#define ARSR1P_SKIN_CFG_ES		(0x03C)
> +#define ARSR1P_SHOOT_CFG1_ES		(0x040)
> +#define ARSR1P_SHOOT_CFG2_ES		(0x044)
> +#define ARSR1P_SHARP_CFG1_ES		(0x048)
> +#define ARSR1P_SHARP_CFG2_ES		(0x04C)
> +#define ARSR1P_SHARP_CFG3_ES		(0x050)
> +#define ARSR1P_SHARP_CFG4_ES		(0x054)
> +#define ARSR1P_SHARP_CFG5_ES		(0x058)
> +#define ARSR1P_SHARP_CFG6_ES		(0x05C)
> +#define ARSR1P_SHARP_CFG7_ES		(0x060)
> +#define ARSR1P_SHARP_CFG8_ES		(0x064)
> +#define ARSR1P_SHARP_CFG9_ES		(0x068)
> +#define ARSR1P_SHARP_CFG10_ES		(0x06C)
> +#define ARSR1P_SHARP_CFG11_ES		(0x070)
> +#define ARSR1P_DIFF_CTRL_ES		(0x074)
> +#define ARSR1P_LSC_CFG1_ES         (0x078)
> +#define ARSR1P_LSC_CFG2_ES         (0x07C)
> +#define ARSR1P_LSC_CFG3_ES         (0x080)
> +#define ARSR1P_FORCE_CLK_ON_CFG_ES	(0x084)
> +
> +/* ARSR1P */
> +
> +#define ARSR_POST_IHLEFT (0x000)
> +#define ARSR_POST_IHRIGHT (0x004)
> +#define ARSR_POST_IHLEFT1 (0x008)
> +#define ARSR_POST_IHRIGHT1 (0x00C)
> +#define ARSR_POST_IVTOP (0x010)
> +#define ARSR_POST_IVBOTTOM (0x014)
> +#define ARSR_POST_UV_OFFSET (0x018)
> +#define ARSR_POST_IHINC (0x01C)
> +#define ARSR_POST_IVINC (0x020)
> +#define ARSR_POST_MODE (0x024)
> +#define ARSR_POST_FORMAT (0x028)
> +#define ARSR_POST_SKIN_THRES_Y (0x02C)
> +#define ARSR_POST_SKIN_THRES_U (0x030)
> +#define ARSR_POST_SKIN_THRES_V (0x034)
> +#define ARSR_POST_SKIN_EXPECTED (0x038)
> +#define ARSR_POST_SKIN_CFG (0x03C)
> +#define ARSR_POST_SHOOT_CFG1 (0x040)
> +#define ARSR_POST_SHOOT_CFG2 (0x044)
> +#define ARSR_POST_SHOOT_CFG3 (0x048)
> +#define ARSR_POST_SHARP_CFG1_H (0x04C)
> +#define ARSR_POST_SHARP_CFG1_L (0x050)
> +#define ARSR_POST_SHARP_CFG2_H (0x054)
> +#define ARSR_POST_SHARP_CFG2_L (0x058)
> +#define ARSR_POST_SHARP_CFG3 (0x05C)
> +#define ARSR_POST_SHARP_CFG4 (0x060)
> +#define ARSR_POST_SHARP_CFG5 (0x064)
> +#define ARSR_POST_SHARP_CFG6 (0x068)
> +#define ARSR_POST_SHARP_CFG6_CUT (0x06C)
> +#define ARSR_POST_SHARP_CFG7 (0x070)
> +#define ARSR_POST_SHARP_CFG7_RATIO (0x074)
> +#define ARSR_POST_SHARP_CFG8 (0x078)
> +#define ARSR_POST_SHARP_CFG9 (0x07C)
> +#define ARSR_POST_SHARP_CFG10 (0x080)
> +#define ARSR_POST_SHARP_CFG11 (0x084)
> +#define ARSR_POST_DIFF_CTRL (0x088)
> +#define ARSR_POST_SKIN_SLOP_Y (0x08C)
> +#define ARSR_POST_SKIN_SLOP_U (0x090)
> +#define ARSR_POST_SKIN_SLOP_V (0x094)
> +#define ARSR_POST_FORCE_CLK_ON_CFG (0x098)
> +#define ARSR_POST_DEBUG_RW_0 (0x09C)
> +#define ARSR_POST_DEBUG_RW_1 (0x0A0)
> +#define ARSR_POST_DEBUG_RW_2 (0x0A4)
> +#define ARSR_POST_DEBUG_RO_0 (0x0A8)
> +#define ARSR_POST_DEBUG_RO_1 (0x0AC)
> +#define ARSR_POST_DEBUG_RO_2 (0x0B0)
> +
> +/* BIT EXT */
> +
> +/* GAMA PRE LUT */
> +#define U_GAMA_PRE_R_COEF	(0x000)
> +#define U_GAMA_PRE_G_COEF	(0x400)
> +#define U_GAMA_PRE_B_COEF	(0x800)
> +#define U_GAMA_PRE_R_LAST_COEF (0x200)
> +#define U_GAMA_PRE_G_LAST_COEF (0x600)
> +#define U_GAMA_PRE_B_LAST_COEF (0xA00)
> +
> +/* ACM LUT */
> +#define ACM_U_ACM_SATR_FACE_COEF (0x500)
> +#define ACM_U_ACM_LTA_COEF (0x580)
> +#define ACM_U_ACM_LTR0_COEF (0x600)
> +#define ACM_U_ACM_LTR1_COEF (0x640)
> +#define ACM_U_ACM_LTR2_COEF (0x680)
> +#define ACM_U_ACM_LTR3_COEF (0x6C0)
> +#define ACM_U_ACM_LTR4_COEF (0x700)
> +#define ACM_U_ACM_LTR5_COEF (0x740)
> +#define ACM_U_ACM_LTR6_COEF (0x780)
> +#define ACM_U_ACM_LTR7_COEF (0x7C0)
> +#define ACM_U_ACM_LH0_COFF (0x800)
> +#define ACM_U_ACM_LH1_COFF (0x880)
> +#define ACM_U_ACM_LH2_COFF (0x900)
> +#define ACM_U_ACM_LH3_COFF (0x980)
> +#define ACM_U_ACM_LH4_COFF (0xA00)
> +#define ACM_U_ACM_LH5_COFF (0xA80)
> +#define ACM_U_ACM_LH6_COFF (0xB00)
> +#define ACM_U_ACM_LH7_COFF (0xB80)
> +#define ACM_U_ACM_CH0_COFF (0xC00)
> +#define ACM_U_ACM_CH1_COFF (0xC80)
> +#define ACM_U_ACM_CH2_COFF (0xD00)
> +#define ACM_U_ACM_CH3_COFF (0xD80)
> +#define ACM_U_ACM_CH4_COFF (0xE00)
> +#define ACM_U_ACM_CH5_COFF (0xE80)
> +#define ACM_U_ACM_CH6_COFF (0xF00)
> +#define ACM_U_ACM_CH7_COFF (0xF80)
> +
> +/* LCP LUT */
> +#define GMP_U_GMP_COEF	(0x0000)
> +
> +#define U_DEGAMA_R_COEF	(0x0000)
> +#define U_DEGAMA_G_COEF	(0x0400)
> +#define U_DEGAMA_B_COEF	(0x0800)
> +#define U_DEGAMA_R_LAST_COEF (0x0200)
> +#define U_DEGAMA_G_LAST_COEF (0x0600)
> +#define U_DEGAMA_B_LAST_COEF (0x0A00)
> +
> +/* ARSR1P LUT for ES */
> +#define ARSR1P_LSC_GAIN_ES		(0x084)  /* 0xB07C+0x4*range27 */
> +#define ARSR1P_COEFF_H_Y0_ES	(0x0F0)  /* 0xB0E8+0x4*range9 */
> +#define ARSR1P_COEFF_H_Y1_ES	(0x114)  /* 0xB10C+0x4*range9 */
> +#define ARSR1P_COEFF_V_Y0_ES	(0x138)  /* 0xB130+0x4*range9 */
> +#define ARSR1P_COEFF_V_Y1_ES	(0x15C)  /* 0xB154+0x4*range9 */
> +#define ARSR1P_COEFF_H_UV0_ES	(0x180)  /* 0xB178+0x4*range9 */
> +#define ARSR1P_COEFF_H_UV1_ES	(0x1A4)  /* 0xB19C+0x4*range9 */
> +#define ARSR1P_COEFF_V_UV0_ES	(0x1C8)  /* 0xB1C0+0x4*range9 */
> +#define ARSR1P_COEFF_V_UV1_ES	(0x1EC)  /* 0xB1E4+0x4*range9 */
> +
> +/* ARSR1P LUT */
> +#define ARSR_POST_COEFF_H_Y0	(0x0F0)  /* 0xB0E8+0x4*range9 */
> +#define ARSR_POST_COEFF_H_Y1	(0x114)  /* 0xB10C+0x4*range9 */
> +#define ARSR_POST_COEFF_V_Y0	(0x138)  /* 0xB130+0x4*range9 */
> +#define ARSR_POST_COEFF_V_Y1	(0x15C)  /* 0xB154+0x4*range9 */
> +#define ARSR_POST_COEFF_H_UV0	(0x180)  /* 0xB178+0x4*range9 */
> +#define ARSR_POST_COEFF_H_UV1	(0x1A4)  /* 0xB19C+0x4*range9 */
> +#define ARSR_POST_COEFF_V_UV0	(0x1C8)  /* 0xB1C0+0x4*range9 */
> +#define ARSR_POST_COEFF_V_UV1	(0x1EC)  /* 0xB1E4+0x4*range9 */
> +
> +/* DPE */
> +#define DPE_INT_STAT (0x0000)
> +#define DPE_INT_UNMASK (0x0004)
> +#define DPE_BYPASS_ACE (0x0008)
> +#define DPE_BYPASS_ACE_STAT (0x000c)
> +#define DPE_UPDATE_LOCAL (0x0010)
> +#define DPE_LOCAL_VALID (0x0014)
> +#define DPE_GAMMA_AB_SHADOW (0x0018)
> +#define DPE_GAMMA_AB_WORK (0x001c)
> +#define DPE_GLOBAL_HIST_AB_SHADOW (0x0020)
> +#define DPE_GLOBAL_HIST_AB_WORK (0x0024)
> +#define DPE_IMAGE_INFO (0x0030)
> +#define DPE_HALF_BLOCK_INFO (0x0034)
> +#define DPE_XYWEIGHT (0x0038)
> +#define DPE_LHIST_SFT (0x003c)
> +#define DPE_ROI_START_POINT (0x0040)
> +#define DPE_ROI_WIDTH_HIGH (0x0044)
> +#define DPE_ROI_MODE_CTRL (0x0048)
> +#define DPE_ROI_HIST_STAT_MODE (0x004c)
> +#define DPE_HUE (0x0050)
> +#define DPE_SATURATION (0x0054)
> +#define DPE_VALUE (0x0058)
> +#define DPE_SKIN_GAIN (0x005c)
> +#define DPE_UP_LOW_TH (0x0060)
> +#define DPE_RGB_BLEND_WEIGHT (0x0064)
> +#define DPE_FNA_STATISTIC (0x0068)
> +#define DPE_UP_CNT (0x0070)
> +#define DPE_LOW_CNT (0x0074)
> +#define DPE_SUM_SATURATION (0x0078)
> +#define DPE_GLOBAL_HIST_LUT_ADDR (0x0080)
> +#define DPE_LHIST_EN (0x0100)
> +#define DPE_LOCAL_HIST_VxHy_2z_2z1 (0x0104)
> +#define DPE_GAMMA_EN (0x0108)
> +#define DPE_GAMMA_W (0x0108)
> +#define DPE_GAMMA_R (0x0110)
> +#define DPE_GAMMA_VxHy_3z2_3z1_3z_W (0x010c)
> +#define DPE_GAMMA_EN_HV_R (0x0110)
> +#define DPE_GAMMA_VxHy_3z2_3z1_3z_R (0x0114)
> +#define DPE_INIT_GAMMA (0x0120)
> +#define DPE_MANUAL_RELOAD (0x0124)
> +#define DPE_RAMCLK_FUNC (0x0128)
> +#define DPE_CLK_GATE (0x012c)
> +#define DPE_GAMMA_RAM_A_CFG_MEM_CTRL (0x0130)
> +#define DPE_GAMMA_RAM_B_CFG_MEM_CTRL (0x0134)
> +#define DPE_LHIST_RAM_CFG_MEM_CTRL (0x0138)
> +#define DPE_GAMMA_RAM_A_CFG_PM_CTRL (0x0140)
> +#define DPE_GAMMA_RAM_B_CFG_PM_CTRL (0x0144)
> +#define DPE_LHIST_RAM_CFG_PM_CTRL (0x0148)
> +#define DPE_SAT_GLOBAL_HIST_LUT_ADDR (0x0180)
> +#define DPE_FNA_EN (0x0200)
> +#define DPE_FNA_ADDR (0x0200)
> +#define DPE_FNA_DATA (0x0204)
> +#define DPE_FNA_VxHy (0x0204)
> +#define DPE_UPDATE_FNA (0x0208)
> +#define DPE_FNA_VALID (0x0210)
> +#define DPE_DB_PIPE_CFG (0x0220)
> +#define DPE_DB_PIPE_EXT_WIDTH (0x0224)
> +#define DPE_DB_PIPE_FULL_IMG_WIDTH (0x0228)
> +#define DPE_ACE_DBG0 (0x0300)
> +#define DPE_ACE_DBG1 (0x0304)
> +#define DPE_ACE_DBG2 (0x0308)
> +#define DPE_BYPASS_NR (0x0400)
> +#define DPE_S3_SOME_BRIGHTNESS01 (0x0410)
> +#define DPE_S3_SOME_BRIGHTNESS23 (0x0414)
> +#define DPE_S3_SOME_BRIGHTNESS4 (0x0418)
> +#define DPE_S3_MIN_MAX_SIGMA (0x0420)
> +#define DPE_S3_GREEN_SIGMA03 (0x0430)
> +#define DPE_S3_GREEN_SIGMA45 (0x0434)
> +#define DPE_S3_RED_SIGMA03 (0x0440)
> +#define DPE_S3_RED_SIGMA45 (0x0444)
> +#define DPE_S3_BLUE_SIGMA03 (0x0450)
> +#define DPE_S3_BLUE_SIGMA45 (0x0454)
> +#define DPE_S3_WHITE_SIGMA03 (0x0460)
> +#define DPE_S3_WHITE_SIGMA45 (0x0464)
> +#define DPE_S3_FILTER_LEVEL (0x0470)
> +#define DPE_S3_SIMILARITY_COEFF (0x0474)
> +#define DPE_S3_V_FILTER_WEIGHT_ADJ (0x0478)
> +#define DPE_S3_HUE (0x0480)
> +#define DPE_S3_SATURATION (0x0484)
> +#define DPE_S3_VALUE (0x0488)
> +#define DPE_S3_SKIN_GAIN (0x048c)
> +#define DPE_NR_RAMCLK_FUNC (0x0490)
> +#define DPE_NR_CLK_GATE (0x0494)
> +#define DPE_NR_RAM_A_CFG_MEM_CTRL (0x0498)
> +#define DPE_NR_RAM_A_CFG_PM_CTRL (0x049c)
> +
> +/* IFBC */
> +
> +/* LDI */
> +#define LDI_DP_DSI_SEL		(0x0080)
> +
> +/* MIPI DSI */
> +
> +#define AUTO_ULPS_MODE	(0x00E0)
> +#define AUTO_ULPS_ENTER_DELAY	(0x00E4)
> +#define AUTO_ULPS_WAKEUP_TIME	(0x00E8)
> +#define AUTO_ULPS_MIN_TIME  (0xF8)
> +#define DSI_MEM_CTRL  (0x0194)
> +#define DSI_PM_CTRL  (0x0198)
> +#define DSI_DEBUG  (0x019C)
> +
> +/* MMBUF */
> +
> +/* MEDIA_CRG */
> +#define MEDIA_PEREN0	(0x000)
> +#define MEDIA_PERDIS0	(0x004)
> +#define MEDIA_PERDIS1	(0x014)
> +#define MEDIA_PERDIS2	(0x024)
> +#define MEDIA_PERRSTEN0	(0x030)
> +#define MEDIA_PERRSTDIS0	(0x034)
> +#define MEDIA_PERRSTDIS1	(0x040)
> +#define MEDIA_CLKDIV8  (0x080)
> +#define MEDIA_CLKDIV9  (0x084)
> +#define MEDIA_PEREN1	(0x010)
> +#define MEDIA_PEREN2	(0x020)
> +#define PERRSTEN_GENERAL_SEC (0xA00)
> +#define PERRSTDIS_GENERAL_SEC (0xA04)
> +
> +#endif
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h b/drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h
> new file mode 100644
> index 000000000000..26add227c389
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h
> @@ -0,0 +1,2457 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#ifndef __KIRIN_DPE_H__
> +#define __KIRIN_DPE_H__
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/string.h>
> +#include <linux/platform_device.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/wait.h>
> +#include <linux/bug.h>
> +#include <linux/iommu.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +
> +#include <drm/drm_plane.h>
> +#include <drm/drm_crtc.h>
Reduce headers to what is necessary.
This seems to be a common pattern.
Each header file shall include only what is required by that header
file. And .c file shall include the header file they need.

Note - for a poitner use forward and do not incldue the header.

> +
> +/* vcc name */
> +#define REGULATOR_PDP_NAME	"ldo3"

...

> +struct mipi_ifbc_division {
> +	u32 xres_div;
> +	u32 yres_div;
> +	u32 comp_mode;
> +	u32 pxl0_div2_gt_en;
> +	u32 pxl0_div4_gt_en;
> +	u32 pxl0_divxcfg;
> +	u32 pxl0_dsi_gt_en;
> +};

...

> +
> +/*****************************************************************************/
> +
> +#define to_dss_crtc(crtc) container_of(crtc, struct dss_crtc, base)
> +#define to_dss_plane(plane) container_of(plane, struct dss_plane, base)

These upcasts belongs to the header file that contains the struct that
they upcast too. So thay should be next to struct dss_crtc and struct
dss_plane.

> +
> +#endif
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.c
> new file mode 100644
> index 000000000000..5669914697a1
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.c
> @@ -0,0 +1,912 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
> + * Copyright (c) 2013-2020, Huawei Technologies Co., Ltd
> + */
> +#include <drm/drm_drv.h>
> +#include <drm/drm_mipi_dsi.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_dpe.h"
> +
> +struct mipi_ifbc_division g_mipi_ifbc_division[MIPI_DPHY_NUM][IFBC_TYPE_MAX] = {
Only used in this file => static

> +	/* single mipi */
> +	{
> +			/* none */
> +		{
> +			XRES_DIV_1, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_0, PXL0_DSI_GT_EN_1
> +		}, {
> +			/* orise2x */
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* orise3x */
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_1, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* himax2x */
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_2, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* rsp2x */
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_3, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*
> +			 * rsp3x
> +			 * NOTE: in reality: xres_div = 1.5, yres_div = 2,
> +			 * amended in "mipi_ifbc_get_rect" function
> +			 */
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_4, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa2x_1pipe */
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa3x_1pipe */
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa2x_2pipe */
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa3x_2pipe */
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}
> +
> +	/* dual mipi */
> +	}, {
> +		{
> +			/* none */
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* orise2x */
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* orise3x */
> +			XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_1, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* himax2x */
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_2, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* rsp2x */
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_3, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* rsp3x */
> +			XRES_DIV_3, YRES_DIV_2, IFBC_COMP_MODE_4, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa2x_1pipe */
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa3x_1pipe */
> +			XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa2x_2pipe */
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/* vesa3x_2pipe */
> +			XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, 3
> +		}
> +	}
> +};
> +
> +u32 set_bits32(u32 old_val, uint32_t val, uint8_t bw, uint8_t bs)
Not used - can be deleted. Remember to delete prototype in header file.

> +{
> +	u32 mask = (1UL << bw) - 1UL;
> +	u32 tmp = 0;
> +
> +	tmp = old_val;
> +	tmp &= ~(mask << bs);
> +
> +	return (tmp | ((val & mask) << bs));
> +}
> +
> +static int mipi_ifbc_get_rect(struct dss_hw_ctx *ctx, struct dss_rect *rect)
> +{
> +	u32 ifbc_type;
> +	u32 mipi_idx;
> +	u32 xres_div;
> +	u32 yres_div;
> +
> +	ifbc_type = IFBC_TYPE_NONE;
> +	mipi_idx = 0;
> +
> +	xres_div = g_mipi_ifbc_division[mipi_idx][ifbc_type].xres_div;
> +	yres_div = g_mipi_ifbc_division[mipi_idx][ifbc_type].yres_div;
> +
> +	if ((rect->w % xres_div) > 0)
> +		drm_err(ctx->dev,
> +			"xres(%d) is not division_h(%d) pixel aligned!\n",
> +			rect->w, xres_div);
> +
> +	if ((rect->h % yres_div) > 0)
> +		drm_err(ctx->dev,
> +			"yres(%d) is not division_v(%d) pixel aligned!\n",
> +			rect->h, yres_div);
> +
> +	/*
> +	 * NOTE: rsp3x && single_mipi CMD mode amended xres_div = 1.5,
> +	 *  yres_div = 2,
> +	 * VIDEO mode amended xres_div = 3, yres_div = 1
> +	 */
> +	rect->w /= xres_div;
> +	rect->h /= yres_div;
> +
> +	return 0;
> +}
> +
> +static void init_ldi_pxl_div(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *ldi_base;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	u32 ifbc_type = 0;
> +	u32 mipi_idx = 0;
> +	u32 pxl0_div2_gt_en = 0;
> +	u32 pxl0_div4_gt_en = 0;
> +	u32 pxl0_divxcfg = 0;
> +	u32 pxl0_dsi_gt_en = 0;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	ifbc_type = IFBC_TYPE_NONE;
> +	mipi_idx = 0;
> +
> +	pxl0_div2_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_div2_gt_en;
> +	pxl0_div4_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_div4_gt_en;
> +	pxl0_divxcfg = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_divxcfg;
> +	pxl0_dsi_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_dsi_gt_en;
> +
> +	set_reg(ldi_base + LDI_PXL0_DIV2_GT_EN, pxl0_div2_gt_en, 1, 0);
> +	set_reg(ldi_base + LDI_PXL0_DIV4_GT_EN, pxl0_div4_gt_en, 1, 0);
> +	set_reg(ldi_base + LDI_PXL0_GT_EN, 0x1, 1, 0);
> +	set_reg(ldi_base + LDI_PXL0_DSI_GT_EN, pxl0_dsi_gt_en, 2, 0);
> +	set_reg(ldi_base + LDI_PXL0_DIVXCFG, pxl0_divxcfg, 3, 0);
> +}
> +
> +void init_other(struct dss_crtc *acrtc)
Only used in this file => static
(And drop prototype in header file)

> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *dss_base = ctx->base;
> +
> +	/**
> +	 * VESA_CLK_SEL is set to 0 for initial,
> +	 * 1 is needed only by vesa dual pipe compress
> +	 */
> +	set_reg(dss_base + DSS_LDI0_OFFSET + LDI_VESA_CLK_SEL, 0, 1, 0);
> +}
> +
> +void init_ldi(struct dss_crtc *acrtc)
Only used in this file => static
(And drop prototype in header file)

> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *ldi_base;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	struct dss_rect rect = {0, 0, 0, 0};
> +	u32 hfp, hbp, hsw, vfp, vbp, vsw;
> +	u32 vsync_plr = 0;
> +	u32 hsync_plr = 0;
> +	u32 pixelclk_plr = 0;
> +	u32 data_en_plr = 0;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	hsw = mode->hsync_end - mode->hsync_start;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	vsw = mode->vsync_end - mode->vsync_start;
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	rect.x = 0;
> +	rect.y = 0;
> +	rect.w = mode->hdisplay;
> +	rect.h = mode->vdisplay;
> +	mipi_ifbc_get_rect(ctx, &rect);
> +
> +	init_ldi_pxl_div(acrtc);
> +
> +	writel(hfp | ((hbp + DSS_WIDTH(hsw)) << 16),
> +	       ldi_base + LDI_DPI0_HRZ_CTRL0);
> +	writel(0, ldi_base + LDI_DPI0_HRZ_CTRL1);
> +	writel(DSS_WIDTH(rect.w), ldi_base + LDI_DPI0_HRZ_CTRL2);
> +	writel(vfp | (vbp << 16), ldi_base + LDI_VRT_CTRL0);
> +	writel(DSS_HEIGHT(vsw), ldi_base + LDI_VRT_CTRL1);
> +	writel(DSS_HEIGHT(rect.h), ldi_base + LDI_VRT_CTRL2);
> +
> +	writel(vsync_plr | (hsync_plr << 1) | (pixelclk_plr << 2) | (data_en_plr << 3),
> +	       ldi_base + LDI_PLR_CTRL);
> +
> +	/* bpp */
> +	set_reg(ldi_base + LDI_CTRL, acrtc->out_format, 2, 3);
> +	/* bgr */
> +	set_reg(ldi_base + LDI_CTRL, acrtc->bgr_fmt, 1, 13);
> +
> +	/* for ddr pmqos */
> +	writel(vfp, ldi_base + LDI_VINACT_MSK_LEN);
> +
> +	/* cmd event sel */
> +	writel(0x1, ldi_base + LDI_CMD_EVENT_SEL);
> +
> +	/* for 1Hz LCD and mipi command LCD */
> +	set_reg(ldi_base + LDI_DSI_CMD_MOD_CTRL, 0x1, 1, 1);
> +
> +	/* ldi_data_gate(ctx, true); */
> +
> +	/* normal */
> +	set_reg(ldi_base + LDI_WORK_MODE, 0x1, 1, 0);
> +
> +	/* ldi disable */
> +	set_reg(ldi_base + LDI_CTRL, 0x0, 1, 0);
> +}
> +
> +void deinit_ldi(struct dss_crtc *acrtc)
Only used in this file => static
(And drop prototype in header file)

> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *ldi_base;
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	/* ldi disable */
> +	set_reg(ldi_base + LDI_CTRL, 0, 1, 0);
> +}
> +
> +void init_dbuf(struct dss_crtc *acrtc)
Only used in this file => static
(And drop prototype in header file)

> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +	char __iomem *dbuf_base;
> +
> +	int sram_valid_num = 0;
> +	int sram_max_mem_depth = 0;
> +	int sram_min_support_depth = 0;
> +
> +	u32 thd_rqos_in = 0;
> +	u32 thd_rqos_out = 0;
> +	u32 thd_wqos_in = 0;
> +	u32 thd_wqos_out = 0;
> +	u32 thd_cg_in = 0;
> +	u32 thd_cg_out = 0;
> +	u32 thd_wr_wait = 0;
> +	u32 thd_cg_hold = 0;
> +	u32 thd_flux_req_befdfs_in = 0;
> +	u32 thd_flux_req_befdfs_out = 0;
> +	u32 thd_flux_req_aftdfs_in = 0;
> +	u32 thd_flux_req_aftdfs_out = 0;
> +	u32 thd_dfs_ok = 0;
> +	u32 dfs_ok_mask = 0;
> +	u32 thd_flux_req_sw_en = 1;
> +	u32 hfp, hbp, hsw, vfp, vbp, vsw;
> +
> +	int dfs_time = 0;
> +	int dfs_time_min = 0;
> +	int depth = 0;
> +	int dfs_ram = 0;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	hsw = mode->hsync_end - mode->hsync_start;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	vsw = mode->vsync_end - mode->vsync_start;
> +
> +	dbuf_base = ctx->base + DSS_DBUF0_OFFSET;
> +
> +	if (mode->hdisplay * mode->vdisplay >= RES_4K_PHONE) {
> +		dfs_time_min = DFS_TIME_MIN_4K;
> +		dfs_ram = 0x0;
> +	} else {
> +		dfs_time_min = DFS_TIME_MIN;
> +		dfs_ram = 0xF00;
> +	}
> +
> +	dfs_time = DFS_TIME;
> +	depth = DBUF0_DEPTH;
> +
> +	/*
> +	 * int K = 0;
> +	 * int Tp = 1000000  / adj_mode->clock;
> +	 * K = (hsw + hbp + mode->hdisplay +
> +	 *	hfp) / mode->hdisplay;
> +	 * thd_cg_out = dfs_time / (Tp * K * 6);
> +	 */
> +	thd_cg_out = (dfs_time * adj_mode->clock * 1000UL * mode->hdisplay) /
> +		     (((hsw + hbp + hfp) + mode->hdisplay) * 6 * 1000000UL);
> +
> +	sram_valid_num = thd_cg_out / depth;
> +	thd_cg_in = (sram_valid_num + 1) * depth - 1;
> +
> +	sram_max_mem_depth = (sram_valid_num + 1) * depth;
> +
> +	thd_rqos_in = thd_cg_out * 85 / 100;
> +	thd_rqos_out = thd_cg_out;
> +	thd_flux_req_befdfs_in = GET_FLUX_REQ_IN(sram_max_mem_depth);
> +	thd_flux_req_befdfs_out = GET_FLUX_REQ_OUT(sram_max_mem_depth);
> +
> +	sram_min_support_depth = dfs_time_min * mode->hdisplay / (1000000 / 60 / (mode->vdisplay +
> +				 vbp + vfp + vsw) * (DBUF_WIDTH_BIT / 3 / BITS_PER_BYTE));
> +
> +	thd_flux_req_aftdfs_in = (sram_max_mem_depth - sram_min_support_depth) / 3;
> +	thd_flux_req_aftdfs_out = 2 * (sram_max_mem_depth - sram_min_support_depth) / 3;
> +
> +	thd_dfs_ok = thd_flux_req_befdfs_in;
> +
> +	writel(mode->hdisplay * mode->vdisplay, dbuf_base + DBUF_FRM_SIZE);
> +	writel(DSS_WIDTH(mode->hdisplay), dbuf_base + DBUF_FRM_HSIZE);
> +	writel(sram_valid_num, dbuf_base + DBUF_SRAM_VALID_NUM);
> +
> +	writel((thd_rqos_out << 16) | thd_rqos_in, dbuf_base + DBUF_THD_RQOS);
> +	writel((thd_wqos_out << 16) | thd_wqos_in, dbuf_base + DBUF_THD_WQOS);
> +	writel((thd_cg_out << 16) | thd_cg_in, dbuf_base + DBUF_THD_CG);
> +	writel((thd_cg_hold << 16) | thd_wr_wait, dbuf_base + DBUF_THD_OTHER);
> +	writel((thd_flux_req_befdfs_out << 16) | thd_flux_req_befdfs_in,
> +	       dbuf_base + DBUF_THD_FLUX_REQ_BEF);
> +	writel((thd_flux_req_aftdfs_out << 16) | thd_flux_req_aftdfs_in,
> +	       dbuf_base + DBUF_THD_FLUX_REQ_AFT);
> +	writel(thd_dfs_ok, dbuf_base + DBUF_THD_DFS_OK);
> +	writel((dfs_ok_mask << 1) | thd_flux_req_sw_en,
> +	       dbuf_base + DBUF_FLUX_REQ_CTRL);
> +
> +	writel(0x1, dbuf_base + DBUF_DFS_LP_CTRL);
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		writel(dfs_ram, dbuf_base + DBUF_DFS_RAM_MANAGE);
> +}
> +
> +void init_dpp(struct dss_crtc *acrtc)
Only used in this file => static
(And drop prototype in header file)

> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +	char __iomem *dpp_base;
> +	char __iomem *mctl_sys_base;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	dpp_base = ctx->base + DSS_DPP_OFFSET;
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +
> +	writel((DSS_HEIGHT(mode->vdisplay) << 16) | DSS_WIDTH(mode->hdisplay),
> +	       dpp_base + DPP_IMG_SIZE_BEF_SR);
> +	writel((DSS_HEIGHT(mode->vdisplay) << 16) | DSS_WIDTH(mode->hdisplay),
> +	       dpp_base + DPP_IMG_SIZE_AFT_SR);
> +}
> +
> +void enable_ldi(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *ldi_base;
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	/* ldi enable */
> +	set_reg(ldi_base + LDI_CTRL, 0x1, 1, 0);
> +}
> +
> +void disable_ldi(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *ldi_base;
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	/* ldi disable */
> +	set_reg(ldi_base + LDI_CTRL, 0x0, 1, 0);
> +}
> +
> +void dpe_interrupt_clear(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *dss_base;
> +	u32 clear;
> +
> +	dss_base = ctx->base;
> +
> +	clear = ~0;
> +	writel(clear, dss_base + GLB_CPU_PDP_INTS);
> +	writel(clear, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS);
> +	writel(clear, dss_base + DSS_DPP_OFFSET + DPP_INTS);
> +
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_MCTL_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_WCH0_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_WCH1_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH0_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH1_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH2_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH3_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH4_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH5_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH6_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH7_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_DSS_GLB_INTS);
> +}
> +
> +void dpe_interrupt_unmask(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *dss_base;
> +	u32 unmask;
> +
> +	dss_base = ctx->base;
> +
> +	unmask = ~0;
> +	unmask &= ~(BIT_ITF0_INTS | BIT_MMU_IRPT_NS);
> +	writel(unmask, dss_base + GLB_CPU_PDP_INT_MSK);
> +
> +	unmask = ~0;
> +	unmask &= ~(BIT_VSYNC | BIT_LDI_UNFLOW);
> +
> +	writel(unmask, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +}
> +
> +void dpe_interrupt_mask(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *dss_base;
> +	u32 mask;
> +
> +	dss_base = ctx->base;
> +
> +	mask = ~0;
> +	writel(mask, dss_base + GLB_CPU_PDP_INT_MSK);
> +	writel(mask, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +	writel(mask, dss_base + DSS_DPP_OFFSET + DPP_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_DSS_GLB_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_MCTL_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_WCH0_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_WCH1_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH0_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH1_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH2_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH3_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH4_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH5_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH6_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH7_INT_MSK);
> +}
> +
> +int dpe_init(struct dss_crtc *acrtc)
> +{
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	init_dbuf(acrtc);
> +	init_dpp(acrtc);
> +	init_other(acrtc);
> +	init_ldi(acrtc);
> +
> +	hisifb_dss_on(acrtc->ctx);
> +	hisi_dss_mctl_on(acrtc->ctx);
> +
> +	hisi_dss_mctl_mutex_lock(acrtc->ctx);
> +
> +	hisi_dss_ovl_base_config(acrtc->ctx, mode->hdisplay, mode->vdisplay);
> +
> +	hisi_dss_mctl_mutex_unlock(acrtc->ctx);
> +
> +	enable_ldi(acrtc);
> +
> +	mdelay(60);
> +
> +	return 0;
> +}
> +
> +int dpe_deinit(struct dss_crtc *acrtc)
> +{
> +	deinit_ldi(acrtc);
> +
> +	return 0;
> +}
> +
> +void dpe_check_itf_status(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	char __iomem *mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +	int tmp = 0;
> +	int delay_count = 0;
> +	bool is_timeout = true;
> +	int itf_idx = 0;
> +
> +	while (1) {
> +		tmp = readl(mctl_sys_base + MCTL_MOD17_STATUS + itf_idx * 0x4);
> +		if (((tmp & 0x10) == 0x10) || delay_count > 100) {
> +			is_timeout = (delay_count > 100) ? true : false;
> +			delay_count = 0;
> +			break;
> +		}
> +		mdelay(1);
> +		++delay_count;
> +	}
> +
> +	if (is_timeout)
> +		DRM_DEBUG_DRIVER("mctl_itf%d not in idle status,ints=0x%x !\n",
> +				 itf_idx, tmp);
drm_dbg(), same goes for other DRM_DEBUG_DRIVER() uses.
Find drmdevice via acrtc.

> +}
> +
> +void dss_inner_clk_pdp_disable(struct dss_hw_ctx *ctx)
> +{
> +}
> +
> +void dss_inner_clk_pdp_enable(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *dss_base;
> +
> +	dss_base = ctx->base;
> +
> +	writel(0x00000088, dss_base + DSS_IFBC_OFFSET + IFBC_MEM_CTRL);
> +	writel(0x00000888, dss_base + DSS_DSC_OFFSET + DSC_MEM_CTRL);
> +	writel(0x00000008, dss_base + DSS_LDI0_OFFSET + LDI_MEM_CTRL);
> +	writel(0x00000008, dss_base + DSS_DBUF0_OFFSET + DBUF_MEM_CTRL);
> +	writel(0x00000008, dss_base + DSS_DPP_DITHER_OFFSET + ctx->dither_mem_ctrl);
> +}
> +
> +void dss_inner_clk_common_enable(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *dss_base = ctx->base;
> +
> +	/* core/axi/mmbuf */
> +	writel(0x00000008, dss_base + DSS_CMDLIST_OFFSET + CMD_MEM_CTRL);  /* cmd mem */
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_VG0_SCL_OFFSET + SCF_COEF_MEM_CTRL); /* rch_v0 ,scf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG0_SCL_OFFSET + SCF_LB_MEM_CTRL); /* rch_v0 ,scf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG0_ARSR_OFFSET + ctx->arsr2p_lb_mem_ctrl); /* rch_v0 ,arsr2p mem */
> +	writel(0x00000008, dss_base + DSS_RCH_VG0_DMA_OFFSET + VPP_MEM_CTRL); /* rch_v0 ,vpp mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG0_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_v0 ,dma_buf mem */
> +	writel(0x00008888, dss_base + DSS_RCH_VG0_DMA_OFFSET + AFBCD_MEM_CTRL); /* rch_v0 ,afbcd mem */
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_VG1_SCL_OFFSET + SCF_COEF_MEM_CTRL); /* rch_v1 ,scf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG1_SCL_OFFSET + SCF_LB_MEM_CTRL); /* rch_v1 ,scf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG1_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_v1 ,dma_buf mem */
> +	writel(0x00008888, dss_base + DSS_RCH_VG1_DMA_OFFSET + AFBCD_MEM_CTRL); /* rch_v1 ,afbcd mem */
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		writel(0x88888888,
> +		       dss_base + DSS_RCH_VG0_DMA_OFFSET + HFBCD_MEM_CTRL);
> +		writel(0x00000888,
> +		       dss_base + DSS_RCH_VG0_DMA_OFFSET + HFBCD_MEM_CTRL_1);
> +		writel(0x88888888,
> +		       dss_base + DSS_RCH_VG1_DMA_OFFSET + HFBCD_MEM_CTRL);
> +		writel(0x00000888,
> +		       dss_base + DSS_RCH_VG1_DMA_OFFSET + HFBCD_MEM_CTRL_1);
> +	} else {
> +		writel(0x00000088,
> +		       dss_base + DSS_RCH_VG2_SCL_OFFSET + SCF_COEF_MEM_CTRL); /* rch_v2 ,scf mem */
> +		writel(0x00000008,
> +		       dss_base + DSS_RCH_VG2_SCL_OFFSET + SCF_LB_MEM_CTRL); /* rch_v2 ,scf mem */
> +	}
> +
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG2_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_v2 ,dma_buf mem */
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_G0_SCL_OFFSET + SCF_COEF_MEM_CTRL); /* rch_g0 ,scf mem */
> +	writel(0x0000008, dss_base + DSS_RCH_G0_SCL_OFFSET + SCF_LB_MEM_CTRL); /* rch_g0 ,scf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_G0_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_g0 ,dma_buf mem */
> +	writel(0x00008888, dss_base + DSS_RCH_G0_DMA_OFFSET + AFBCD_MEM_CTRL); /* rch_g0 ,afbcd mem */
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_G1_SCL_OFFSET + SCF_COEF_MEM_CTRL); /* rch_g1 ,scf mem */
> +	writel(0x0000008, dss_base + DSS_RCH_G1_SCL_OFFSET + SCF_LB_MEM_CTRL); /* rch_g1 ,scf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_G1_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_g1 ,dma_buf mem */
> +	writel(0x00008888, dss_base + DSS_RCH_G1_DMA_OFFSET + AFBCD_MEM_CTRL); /* rch_g1 ,afbcd mem */
> +
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D0_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_d0 ,dma_buf mem */
> +	writel(0x00008888, dss_base + DSS_RCH_D0_DMA_OFFSET + AFBCD_MEM_CTRL); /* rch_d0 ,afbcd mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D1_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_d1 ,dma_buf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D2_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_d2 ,dma_buf mem */
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D3_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* rch_d3 ,dma_buf mem */
> +
> +	writel(0x00000008, dss_base + DSS_WCH0_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* wch0 DMA/AFBCE mem */
> +	writel(0x00000888, dss_base + DSS_WCH0_DMA_OFFSET + AFBCE_MEM_CTRL); /* wch0 DMA/AFBCE mem */
> +	writel(0x00000008, dss_base + DSS_WCH0_DMA_OFFSET + ctx->rot_mem_ctrl); /* wch0 rot mem */
> +	writel(0x00000008, dss_base + DSS_WCH1_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* wch1 DMA/AFBCE mem */
> +	writel(0x00000888, dss_base + DSS_WCH1_DMA_OFFSET + AFBCE_MEM_CTRL); /* wch1 DMA/AFBCE mem */
> +	writel(0x00000008, dss_base + DSS_WCH1_DMA_OFFSET + ctx->rot_mem_ctrl); /* wch1 rot mem */
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		writel(0x00000088,
> +		       dss_base + DSS_WCH1_DMA_OFFSET + WCH_SCF_COEF_MEM_CTRL);
> +		writel(0x00000008,
> +		       dss_base + DSS_WCH1_DMA_OFFSET + WCH_SCF_LB_MEM_CTRL);
> +		writel(0x02605550, dss_base + GLB_DSS_MEM_CTRL);
> +	} else {
> +		writel(0x00000008,
> +		       dss_base + DSS_WCH2_DMA_OFFSET + DMA_BUF_MEM_CTRL); /* wch2 DMA/AFBCE mem */
> +		writel(0x00000008,
> +		       dss_base + DSS_WCH2_DMA_OFFSET + ctx->rot_mem_ctrl); /* wch2 rot mem */
> +	}
> +}
> +
> +int dpe_irq_enable(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	if (ctx->irq)
> +		enable_irq(ctx->irq);
> +
> +	return 0;
> +}
> +
> +int dpe_irq_disable(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	if (ctx->irq)
> +		disable_irq(ctx->irq);
> +
> +	return 0;
> +}
> +
> +int dpe_common_clk_enable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +	struct clk *clk_tmp;
> +
> +	clk_tmp = ctx->dss_mmbuf_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_mmbuf_clk clk_prepare failed, error=%d!\n",
> +			        ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_mmbuf_clk clk_enable failed, error=%d!\n",
> +	   ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	clk_tmp = ctx->dss_axi_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_axi_clk clk_prepare failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_axi_clk clk_enable failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	clk_tmp = ctx->dss_pclk_dss_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_pclk_dss_clk clk_prepare failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_pclk_dss_clk clk_enable failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_common_clk_disable(struct dss_hw_ctx *ctx)
> +{
> +	struct clk *clk_tmp;
> +
> +	clk_tmp = ctx->dss_pclk_dss_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	clk_tmp = ctx->dss_axi_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	clk_tmp = ctx->dss_mmbuf_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_inner_clk_enable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +	struct clk *clk_tmp;
> +
> +	clk_tmp = ctx->dss_pri_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_pri_clk clk_prepare failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_pri_clk clk_enable failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	clk_tmp = ctx->dss_pxl0_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				" dss_pxl0_clk clk_prepare failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			drm_err(ctx->dev, " dss_pxl0_clk clk_enable failed, error=%d!\n",
> +				ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_inner_clk_disable(struct dss_hw_ctx *ctx)
> +{
> +	struct clk *clk_tmp;
> +
> +	clk_tmp = ctx->dss_pxl0_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	clk_tmp = ctx->dss_pri_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_set_clk_rate(struct dss_hw_ctx *ctx)
> +{
> +	u64 clk_rate;
> +	int ret = 0;
> +
> +	clk_rate = DEFAULT_DSS_CORE_CLK_RATE_L1;
> +	ret = clk_set_rate(ctx->dss_pri_clk, DEFAULT_DSS_CORE_CLK_RATE_L1);
> +	if (ret < 0) {
> +		drm_err(ctx->dev,
> +			"dss_pri_clk clk_set_rate failed, error=%d!\n", ret);
> +		return -EINVAL;
> +	}
> +	drm_dbg(ctx->dev, "dss_pri_clk:[%llu]->[%llu].\n",
> +		clk_rate, (uint64_t)clk_get_rate(ctx->dss_pri_clk));
> +
> +	clk_rate = DEFAULT_DSS_MMBUF_CLK_RATE_L1;
> +	ret = clk_set_rate(ctx->dss_mmbuf_clk, DEFAULT_DSS_MMBUF_CLK_RATE_L1);
> +	if (ret < 0) {
> +		drm_err(ctx->dev,
> +			"dss_mmbuf clk_set_rate failed, error=%d!\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	drm_dbg(ctx->dev, "dss_mmbuf_clk:[%llu]->[%llu].\n",
> +		clk_rate, (uint64_t)clk_get_rate(ctx->dss_mmbuf_clk));
> +
> +	return ret;
> +}
> +
> +int dpe_set_pixel_clk_rate_on_pll0(struct dss_hw_ctx *ctx)
Not used - delete

> +{
> +	int ret;
> +	u64 clk_rate;
> +
> +	clk_rate = ctx->pxl0_clk_rate_power_off;
> +	ret = clk_set_rate(ctx->dss_pxl0_clk, clk_rate);
> +	if (ret < 0) {
> +		drm_err(ctx->dev,
> +			"dss_pxl0_clk clk_set_rate(%llu) failed, error=%d!\n",
> +			  clk_rate, ret);
> +		return -EINVAL;
> +	}
> +	drm_dbg(ctx->dev, "dss_pxl0_clk:[%llu]->[%llu].\n",
> +		clk_rate, (uint64_t)clk_get_rate(ctx->dss_pxl0_clk));
> +
> +	return ret;
> +}
> +
> +int dpe_set_common_clk_rate_on_pll0(struct dss_hw_ctx *ctx)
Not used - delete
> +{
> +	int ret;
> +	u64 clk_rate;
> +
> +	clk_rate = ctx->dss_mmbuf_clk_rate_power_off;
> +	ret = clk_set_rate(ctx->dss_mmbuf_clk, clk_rate);
> +	if (ret < 0) {
> +		drm_err(ctx->dev,
> +			"dss_mmbuf clk_set_rate(%llu) failed, error=%d!\n",
> +			clk_rate, ret);
> +		return -EINVAL;
> +	}
> +	DRM_INFO("dss_mmbuf_clk:[%llu]->[%llu].\n",
> +		 clk_rate, (uint64_t)clk_get_rate(ctx->dss_mmbuf_clk));
> +
> +	clk_rate = DEFAULT_DSS_CORE_CLK_RATE_POWER_OFF;
> +	ret = clk_set_rate(ctx->dss_pri_clk, clk_rate);
> +	if (ret < 0) {
> +		drm_err(ctx->dev,
> +			"dss_pri_clk clk_set_rate(%llu) failed, error=%d!\n",
> +			clk_rate, ret);
> +		return -EINVAL;
> +	}
> +	drm_dbg(ctx->dev, "dss_pri_clk:[%llu]->[%llu].\n",
> +		clk_rate, (uint64_t)clk_get_rate(ctx->dss_pri_clk));
> +
> +	return ret;
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.h b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.h
> new file mode 100644
> index 000000000000..a3071388a86c
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.h
> @@ -0,0 +1,230 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
> + * Copyright (c) 2013-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#ifndef KIRIN_DRM_DPE_UTILS_H
> +#define KIRIN_DRM_DPE_UTILS_H
> +
> +#include <linux/kernel.h>
> +
> +#include <drm/drm_plane.h>
> +#include <drm/drm_crtc.h>
> +
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin9xx_dpe.h"
> +
> +enum dss_channel {
> +	DSS_CH1 = 0,	/* channel 1 for primary plane */
> +	DSS_CH_NUM
> +};
> +
> +#define PRIMARY_CH	DSS_CH1 /* primary plane */
> +
> +#define HISI_FB_PIXEL_FORMAT_UNSUPPORT 800
> +
> +struct dss_hw_ctx {
> +	struct drm_device *dev;

drm_device is supposed to be embedded in struct dss_hw_ctx, and not a
pointer.

> +	void __iomem *base;
> +	struct regmap *noc_regmap;
> +	struct reset_control *reset;
> +	u32 g_dss_version_tag;
> +
> +	void __iomem *noc_dss_base;
> +	void __iomem *peri_crg_base;
> +	void __iomem *pmc_base;
> +	void __iomem *sctrl_base;
> +	void __iomem *media_crg_base;
> +	void __iomem *pctrl_base;
> +	void __iomem *mmbuf_crg_base;
Not used, delete

> +	void __iomem *pmctrl_base;
> +
> +	struct clk *dss_axi_clk;
> +	struct clk *dss_pclk_dss_clk;
> +	struct clk *dss_pri_clk;
> +	struct clk *dss_pxl0_clk;
> +	struct clk *dss_pxl1_clk;
> +	struct clk *dss_mmbuf_clk;
> +	struct clk *dss_pclk_mmbuf_clk;
Not used - delete.
> +
> +	struct dss_clk_rate *dss_clk;
Not used. Delete struct and this field.

> +
> +	struct regulator *dpe_regulator;
> +	struct regulator *mmbuf_regulator;
Not used - delete.

> +	struct regulator *mediacrg_regulator;
Not used - delete.

> +
> +	bool power_on;
> +	int irq;
> +
> +	wait_queue_head_t vactive0_end_wq;
> +	u32 vactive0_end_flag;
Seems not to be used - delete.

> +	ktime_t vsync_timestamp;
> +	ktime_t vsync_timestamp_prev;
vsync_timestamp is only assinged and vsync_timestamp_prev is not used.
Delete.

I gave up verifying the rest - there is some cleaning to be done here.

> +
> +	struct iommu_domain *mmu_domain;
> +	char __iomem *screen_base;
> +	unsigned long smem_start;
> +	unsigned long screen_size;
> +
> +	/* Version-specific data */
> +	u32 g_dss_module_base[DSS_CHN_MAX_DEFINE][MODULE_CHN_MAX];
> +	u32 g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX];
> +	int g_scf_lut_chn_coef_idx[DSS_CHN_MAX_DEFINE];
> +	u32 g_dss_module_cap[DSS_CHN_MAX_DEFINE][MODULE_CAP_MAX];
> +	u32 g_dss_chn_sid_num[DSS_CHN_MAX_DEFINE];
> +	u32 g_dss_smmu_smrx_idx[DSS_CHN_MAX_DEFINE];
> +	u32 smmu_offset;
> +	u32 afbc_header_addr_align;
> +	u32 dss_mmbuf_clk_rate_power_off;
> +	u32 rot_mem_ctrl;
> +	u32 dither_mem_ctrl;
> +	u32 arsr2p_lb_mem_ctrl;
> +	u32 pxl0_clk_rate_power_off;
> +};
> +
> +void kirin960_dpe_defs(struct dss_hw_ctx *ctx);
> +void kirin970_dpe_defs(struct dss_hw_ctx *ctx);
> +
> +struct dss_clk_rate {
> +	u64 dss_pri_clk_rate;
> +	u64 dss_pclk_dss_rate;
> +	u64 dss_pclk_pctrl_rate;
> +	u64 dss_mmbuf_rate;
> +	u32 dss_voltage_value; /* 0:0.7v, 2:0.8v */
> +	u32 reserved;
> +};
> +
> +struct dss_crtc {
> +	struct drm_crtc base;
> +	struct dss_hw_ctx *ctx;
> +	bool enable;
> +	u32 out_format;
> +	u32 bgr_fmt;
> +};
> +
> +struct dss_plane {
> +	struct drm_plane base;
> +	/* void *ctx; */
> +	void *acrtc;
> +	u8 ch; /* channel */
> +};
> +
> +struct dss_data {
> +	struct dss_crtc acrtc;
> +	struct dss_plane aplane[DSS_CH_NUM];
> +	struct dss_hw_ctx ctx;
> +};
I looks like dss_data should be dropped and the above should be embedded
in struct dss_hw_ctx. This would simplyfy things and it would all be
allocated in one go.

> +
> +struct dss_img {
> +	u32 format;
> +	u32 width;
> +	u32 height;
> +	u32 bpp;		/* bytes per pixel */
> +	u32 buf_size;
> +	u32 stride;
> +	u32 stride_plane1;
> +	u32 stride_plane2;
> +	u64 phy_addr;
> +	u64 vir_addr;
> +	u32 offset_plane1;
> +	u32 offset_plane2;
> +
> +	u64 afbc_header_addr;
> +	u64 afbc_payload_addr;
> +	u32 afbc_header_stride;
> +	u32 afbc_payload_stride;
> +	u32 afbc_scramble_mode;
> +	u32 mmbuf_base;
> +	u32 mmbuf_size;
> +
> +	u32 mmu_enable;
> +	u32 csc_mode;
> +	u32 secure_mode;
> +	s32 shared_fd;
> +	u32 reserved0;
> +};
> +
> +struct dss_rect {
> +	s32 x;
> +	s32 y;
> +	s32 w;
> +	s32 h;
> +};
Hmm, use drm_rect?

> +
> +struct drm_dss_layer {
> +	struct dss_img img;
> +	struct dss_rect src_rect;
> +	struct dss_rect src_rect_mask;
> +	struct dss_rect dst_rect;
> +	u32 transform;
> +	s32 blending;
> +	u32 glb_alpha;
> +	u32 color;		/* background color or dim color */
> +	s32 layer_idx;
> +	s32 chn_idx;
> +	u32 need_cap;
> +	s32 acquire_fence;
> +};
There seems to be some relation between a dss layer and a drm panle
missing somewhere.

> +
> +static inline void set_reg(char __iomem *addr, uint32_t val, uint8_t bw,
> +			   uint8_t bs)
> +{
> +	u32 mask = (1UL << bw) - 1UL;
> +	u32 tmp = 0;
> +
> +	tmp = readl(addr);
> +	tmp &= ~(mask << bs);
> +
> +	writel(tmp | ((val & mask) << bs), addr);
> +}
> +
> +u32 set_bits32(u32 old_val, uint32_t val, uint8_t bw, uint8_t bs);
> +
> +void init_dbuf(struct dss_crtc *acrtc);
> +void init_dpp(struct dss_crtc *acrtc);
> +void init_other(struct dss_crtc *acrtc);
> +void init_ldi(struct dss_crtc *acrtc);
> +
> +void deinit_ldi(struct dss_crtc *acrtc);
> +void enable_ldi(struct dss_crtc *acrtc);
> +void disable_ldi(struct dss_crtc *acrtc);
> +
> +void dss_inner_clk_pdp_enable(struct dss_hw_ctx *ctx);
> +void dss_inner_clk_pdp_disable(struct dss_hw_ctx *ctx);
> +void dss_inner_clk_common_enable(struct dss_hw_ctx *ctx);
> +void dss_inner_clk_common_disable(struct dss_hw_ctx *ctx);
> +void dpe_interrupt_clear(struct dss_crtc *acrtc);
> +void dpe_interrupt_unmask(struct dss_crtc *acrtc);
> +void dpe_interrupt_mask(struct dss_crtc *acrtc);
> +int dpe_common_clk_enable(struct dss_hw_ctx *ctx);
> +int dpe_common_clk_disable(struct dss_hw_ctx *ctx);
> +int dpe_inner_clk_enable(struct dss_hw_ctx *ctx);
> +int dpe_inner_clk_disable(struct dss_hw_ctx *ctx);
> +int dpe_set_clk_rate(struct dss_hw_ctx *ctx);
> +
> +int dpe_irq_enable(struct dss_crtc *acrtc);
> +int dpe_irq_disable(struct dss_crtc *acrtc);
> +
> +int dpe_init(struct dss_crtc *acrtc);
> +int dpe_deinit(struct dss_crtc *acrtc);
> +void dpe_check_itf_status(struct dss_crtc *acrtc);
> +int dpe_set_clk_rate_on_pll0(struct dss_hw_ctx *ctx);
> +int dpe_set_common_clk_rate_on_pll0(struct dss_hw_ctx *ctx);
> +int dpe_set_pixel_clk_rate_on_pll0(struct dss_hw_ctx *ctx);
> +
> +void hisifb_dss_on(struct dss_hw_ctx *ctx);
> +void hisi_dss_mctl_on(struct dss_hw_ctx *ctx);
> +
> +void hisi_dss_unflow_handler(struct dss_hw_ctx *ctx, bool unmask);
> +int hisi_dss_mctl_mutex_lock(struct dss_hw_ctx *ctx);
> +int hisi_dss_mctl_mutex_unlock(struct dss_hw_ctx *ctx);
> +int hisi_dss_ovl_base_config(struct dss_hw_ctx *ctx, u32 xres, u32 yres);
> +
> +u32 hisi_dss_get_channel_formats(struct drm_device *dev, u8 ch, const u32 **formats);
> +
> +void hisi_fb_pan_display(struct drm_plane *plane);
> +
> +u32 dpe_get_format(struct dss_hw_ctx *ctx, u32 pixel_format);
> +
> +#endif
