Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9156311B4
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiKSXFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbiKSXFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:05:42 -0500
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342B51A059;
        Sat, 19 Nov 2022 15:05:39 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:05:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899136; x=1669158336;
        bh=V3uAiCPOJvJO1/bAuuTiv4LrpZ20hZIiLLgtCVRDo4U=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=eR6tRKz8seLDf7+ry5VHWMW0aHe5eJO0B7j0qstJY24kVIMAkmXqMjud2QPK7gtUl
         2BAYOURlrT+277C2HhtJl/GGjy4BJXoCOO3pyhrO8P5DrhQNfoMxQui+DwFTLDH/+r
         ElkIsDqhtD+AjG1taIiQY0gDhsfj4b5tuNBi56nRSNNvlDot706nBu4CyBK/dJHyWs
         bZXkeFsik5erghU87capqul7Ohjuhv8r+Jczpr3f1vfUVDa+R7fOtaf90yY//1VMrG
         bzfPOZwpmlKViFlc4Hvb9ze6144L8JO9VQN0gHJKBHFOxzCGvajZEwsmBdLvfP/PCt
         iDqFlEJuNlWBw==
To:     linux-kbuild@vger.kernel.org
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] sound: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-5-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

With 'y' and 'm' mixed for CONFIG_SNC_SOC_WCD93{35,4X,8X}, wcd-clsh-v2.o
is linked to module(s) and also to vmlinux even though the expected
CFLAGS are different between builtins and modules.

This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
Fixing mixed module-builtin objects").

Turn helpers in wcd-clsh-v2.o into inline functions.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-and-tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 sound/soc/codecs/Makefile      |   6 +-
 sound/soc/codecs/wcd-clsh-v2.c | 903 --------------------------------
 sound/soc/codecs/wcd-clsh-v2.h | 917 ++++++++++++++++++++++++++++++++-
 3 files changed, 907 insertions(+), 919 deletions(-)
 delete mode 100644 sound/soc/codecs/wcd-clsh-v2.c

diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 9170ee1447dd..90c3c610a72f 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -279,9 +279,9 @@ snd-soc-uda1334-objs :=3D uda1334.o
 snd-soc-uda134x-objs :=3D uda134x.o
 snd-soc-uda1380-objs :=3D uda1380.o
 snd-soc-wcd-mbhc-objs :=3D wcd-mbhc-v2.o
-snd-soc-wcd9335-objs :=3D wcd-clsh-v2.o wcd9335.o
-snd-soc-wcd934x-objs :=3D wcd-clsh-v2.o wcd934x.o
-snd-soc-wcd938x-objs :=3D wcd938x.o wcd-clsh-v2.o
+snd-soc-wcd9335-objs :=3D wcd9335.o
+snd-soc-wcd934x-objs :=3D wcd934x.o
+snd-soc-wcd938x-objs :=3D wcd938x.o
 snd-soc-wcd938x-sdw-objs :=3D wcd938x-sdw.o
 snd-soc-wl1273-objs :=3D wl1273.o
 snd-soc-wm-adsp-objs :=3D wm_adsp.o
diff --git a/sound/soc/codecs/wcd-clsh-v2.c b/sound/soc/codecs/wcd-clsh-v2.=
c
deleted file mode 100644
index 4c7ebc7fb400..000000000000
--- a/sound/soc/codecs/wcd-clsh-v2.c
+++ /dev/null
@@ -1,903 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
-// Copyright (c) 2017-2018, Linaro Limited
-
-#include <linux/slab.h>
-#include <sound/soc.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include "wcd9335.h"
-#include "wcd-clsh-v2.h"
-
-struct wcd_clsh_ctrl {
-=09int state;
-=09int mode;
-=09int flyback_users;
-=09int buck_users;
-=09int clsh_users;
-=09int codec_version;
-=09struct snd_soc_component *comp;
-};
-
-/* Class-H registers for codecs from and above WCD9335 */
-#define WCD9XXX_A_CDC_RX0_RX_PATH_CFG0=09=09=09WCD9335_REG(0xB, 0x42)
-#define WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK=09=09BIT(6)
-#define WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE=09=09BIT(6)
-#define WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE=09=090
-#define WCD9XXX_A_CDC_RX1_RX_PATH_CFG0=09=09=09WCD9335_REG(0xB, 0x56)
-#define WCD9XXX_A_CDC_RX2_RX_PATH_CFG0=09=09=09WCD9335_REG(0xB, 0x6A)
-#define WCD9XXX_A_CDC_CLSH_K1_MSB=09=09=09WCD9335_REG(0xC, 0x08)
-#define WCD9XXX_A_CDC_CLSH_K1_MSB_COEF_MASK=09=09GENMASK(3, 0)
-#define WCD9XXX_A_CDC_CLSH_K1_LSB=09=09=09WCD9335_REG(0xC, 0x09)
-#define WCD9XXX_A_CDC_CLSH_K1_LSB_COEF_MASK=09=09GENMASK(7, 0)
-#define WCD9XXX_A_ANA_RX_SUPPLIES=09=09=09WCD9335_REG(0x6, 0x08)
-#define WCD9XXX_A_ANA_RX_REGULATOR_MODE_MASK=09=09BIT(1)
-#define WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_H=09=090
-#define WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_AB=09=09BIT(1)
-#define WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_MASK=09=09BIT(2)
-#define WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_UHQA=09=09BIT(2)
-#define WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_DEFAULT=09=090
-#define WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_MASK=09=09BIT(3)
-#define WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_UHQA=09=09BIT(3)
-#define WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_DEFAULT=09=090
-#define WCD9XXX_A_ANA_RX_VNEG_EN_MASK=09=09=09BIT(6)
-#define WCD9XXX_A_ANA_RX_VNEG_EN_SHIFT=09=09=096
-#define WCD9XXX_A_ANA_RX_VNEG_ENABLE=09=09=09BIT(6)
-#define WCD9XXX_A_ANA_RX_VNEG_DISABLE=09=09=090
-#define WCD9XXX_A_ANA_RX_VPOS_EN_MASK=09=09=09BIT(7)
-#define WCD9XXX_A_ANA_RX_VPOS_EN_SHIFT=09=09=097
-#define WCD9XXX_A_ANA_RX_VPOS_ENABLE=09=09=09BIT(7)
-#define WCD9XXX_A_ANA_RX_VPOS_DISABLE=09=09=090
-#define WCD9XXX_A_ANA_HPH=09=09=09=09WCD9335_REG(0x6, 0x09)
-#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_MASK=09=09GENMASK(3, 2)
-#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_UHQA=09=090x08
-#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_LP=09=09=090x04
-#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_NORMAL=09=090x0
-#define WCD9XXX_A_CDC_CLSH_CRC=09=09=09=09WCD9335_REG(0xC, 0x01)
-#define WCD9XXX_A_CDC_CLSH_CRC_CLK_EN_MASK=09=09BIT(0)
-#define WCD9XXX_A_CDC_CLSH_CRC_CLK_ENABLE=09=09BIT(0)
-#define WCD9XXX_A_CDC_CLSH_CRC_CLK_DISABLE=09=090
-#define WCD9XXX_FLYBACK_EN=09=09=09=09WCD9335_REG(0x6, 0xA4)
-#define WCD9XXX_FLYBACK_EN_DELAY_SEL_MASK=09=09GENMASK(6, 5)
-#define WCD9XXX_FLYBACK_EN_DELAY_26P25_US=09=090x40
-#define WCD9XXX_FLYBACK_EN_RESET_BY_EXT_MASK=09=09BIT(4)
-#define WCD9XXX_FLYBACK_EN_PWDN_WITHOUT_DELAY=09=09BIT(4)
-#define WCD9XXX_FLYBACK_EN_PWDN_WITH_DELAY=09=09=090
-#define WCD9XXX_RX_BIAS_FLYB_BUFF=09=09=09WCD9335_REG(0x6, 0xC7)
-#define WCD9XXX_RX_BIAS_FLYB_VNEG_5_UA_MASK=09=09GENMASK(7, 4)
-#define WCD9XXX_RX_BIAS_FLYB_VPOS_5_UA_MASK=09=09GENMASK(3, 0)
-#define WCD9XXX_HPH_L_EN=09=09=09=09WCD9335_REG(0x6, 0xD3)
-#define WCD9XXX_HPH_CONST_SEL_L_MASK=09=09=09GENMASK(7, 3)
-#define WCD9XXX_HPH_CONST_SEL_BYPASS=09=09=090
-#define WCD9XXX_HPH_CONST_SEL_LP_PATH=09=09=090x40
-#define WCD9XXX_HPH_CONST_SEL_HQ_PATH=09=09=090x80
-#define WCD9XXX_HPH_R_EN=09=09=09=09WCD9335_REG(0x6, 0xD6)
-#define WCD9XXX_HPH_REFBUFF_UHQA_CTL=09=09=09WCD9335_REG(0x6, 0xDD)
-#define WCD9XXX_HPH_REFBUFF_UHQA_GAIN_MASK=09=09GENMASK(2, 0)
-#define WCD9XXX_CLASSH_CTRL_VCL_2                       WCD9335_REG(0x6, 0=
x9B)
-#define WCD9XXX_CLASSH_CTRL_VCL_2_VREF_FILT_1_MASK=09GENMASK(5, 4)
-#define WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_50KOHM=090x20
-#define WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_0KOHM=090x0
-#define WCD9XXX_CDC_RX1_RX_PATH_CTL=09=09=09WCD9335_REG(0xB, 0x55)
-#define WCD9XXX_CDC_RX2_RX_PATH_CTL=09=09=09WCD9335_REG(0xB, 0x69)
-#define WCD9XXX_CDC_CLK_RST_CTRL_MCLK_CONTROL=09=09WCD9335_REG(0xD, 0x41)
-#define WCD9XXX_CDC_CLK_RST_CTRL_MCLK_EN_MASK=09=09BIT(0)
-#define WCD9XXX_CDC_CLK_RST_CTRL_MCLK_11P3_EN_MASK=09BIT(1)
-#define WCD9XXX_CLASSH_CTRL_CCL_1                       WCD9335_REG(0x6, 0=
x9C)
-#define WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_MASK=09GENMASK(7, 4)
-#define WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA=090x50
-#define WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_30MA=090x30
-
-#define WCD9XXX_BASE_ADDRESS=09=09=09=090x3000
-#define WCD9XXX_ANA_RX_SUPPLIES=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x008)
-#define WCD9XXX_ANA_HPH=09=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x009)
-#define WCD9XXX_CLASSH_MODE_2=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x098)
-#define WCD9XXX_CLASSH_MODE_3=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x099)
-#define WCD9XXX_FLYBACK_VNEG_CTRL_1=09=09=09(WCD9XXX_BASE_ADDRESS+0x0A5)
-#define WCD9XXX_FLYBACK_VNEG_CTRL_4=09=09=09(WCD9XXX_BASE_ADDRESS+0x0A8)
-#define WCD9XXX_FLYBACK_VNEGDAC_CTRL_2=09=09=09(WCD9XXX_BASE_ADDRESS+0x0AF=
)
-#define WCD9XXX_RX_BIAS_HPH_LOWPOWER=09=09=09(WCD9XXX_BASE_ADDRESS+0x0BF)
-#define WCD9XXX_V3_RX_BIAS_FLYB_BUFF=09=09=09(WCD9XXX_BASE_ADDRESS+0x0C7)
-#define WCD9XXX_HPH_PA_CTL1=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x0D1)
-#define WCD9XXX_HPH_NEW_INT_PA_MISC2=09=09=09(WCD9XXX_BASE_ADDRESS+0x138)
-
-#define CLSH_REQ_ENABLE=09=09true
-#define CLSH_REQ_DISABLE=09false
-#define WCD_USLEEP_RANGE=0950
-
-enum {
-=09DAC_GAIN_0DB =3D 0,
-=09DAC_GAIN_0P2DB,
-=09DAC_GAIN_0P4DB,
-=09DAC_GAIN_0P6DB,
-=09DAC_GAIN_0P8DB,
-=09DAC_GAIN_M0P2DB,
-=09DAC_GAIN_M0P4DB,
-=09DAC_GAIN_M0P6DB,
-};
-
-static inline void wcd_enable_clsh_block(struct wcd_clsh_ctrl *ctrl,
-=09=09=09=09=09 bool enable)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09if ((enable && ++ctrl->clsh_users =3D=3D 1) ||
-=09    (!enable && --ctrl->clsh_users =3D=3D 0))
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_CDC_CLSH_CRC,
-=09=09=09=09      WCD9XXX_A_CDC_CLSH_CRC_CLK_EN_MASK,
-=09=09=09=09      enable);
-=09if (ctrl->clsh_users < 0)
-=09=09ctrl->clsh_users =3D 0;
-}
-
-static inline bool wcd_clsh_enable_status(struct snd_soc_component *comp)
-{
-=09return snd_soc_component_read(comp, WCD9XXX_A_CDC_CLSH_CRC) &
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_CRC_CLK_EN_MASK;
-}
-
-static inline void wcd_clsh_set_buck_mode(struct snd_soc_component *comp,
-=09=09=09=09=09  int mode)
-{
-=09/* set to HIFI */
-=09if (mode =3D=3D CLS_H_HIFI)
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_MASK,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_UHQA);
-=09else
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_MASK,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_DEFAULT);
-}
-
-static void wcd_clsh_v3_set_buck_mode(struct snd_soc_component *component,
-=09=09=09=09=09  int mode)
-{
-=09if (mode =3D=3D CLS_H_HIFI || mode =3D=3D CLS_H_LOHIFI ||
-=09    mode =3D=3D CLS_AB_HIFI || mode =3D=3D CLS_AB_LOHIFI)
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
-=09=09=09=090x08, 0x08); /* set to HIFI */
-=09else
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
-=09=09=09=090x08, 0x00); /* set to default */
-}
-
-static inline void wcd_clsh_set_flyback_mode(struct snd_soc_component *com=
p,
-=09=09=09=09=09     int mode)
-{
-=09/* set to HIFI */
-=09if (mode =3D=3D CLS_H_HIFI)
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_MASK,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_UHQA);
-=09else
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_MASK,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_DEFAULT);
-}
-
-static void wcd_clsh_buck_ctrl(struct wcd_clsh_ctrl *ctrl,
-=09=09=09       int mode,
-=09=09=09       bool enable)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09/* enable/disable buck */
-=09if ((enable && (++ctrl->buck_users =3D=3D 1)) ||
-=09   (!enable && (--ctrl->buck_users =3D=3D 0)))
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_EN_MASK,
-=09=09=09=09enable << WCD9XXX_A_ANA_RX_VPOS_EN_SHIFT);
-=09/*
-=09 * 500us sleep is required after buck enable/disable
-=09 * as per HW requirement
-=09 */
-=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
-}
-
-static void wcd_clsh_v3_buck_ctrl(struct snd_soc_component *component,
-=09=09=09       struct wcd_clsh_ctrl *ctrl,
-=09=09=09       int mode,
-=09=09=09       bool enable)
-{
-=09/* enable/disable buck */
-=09if ((enable && (++ctrl->buck_users =3D=3D 1)) ||
-=09   (!enable && (--ctrl->buck_users =3D=3D 0))) {
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
-=09=09=09=09(1 << 7), (enable << 7));
-=09=09/*
-=09=09 * 500us sleep is required after buck enable/disable
-=09=09 * as per HW requirement
-=09=09 */
-=09=09usleep_range(500, 510);
-=09=09if (mode =3D=3D CLS_H_LOHIFI || mode =3D=3D CLS_H_ULP ||
-=09=09=09mode =3D=3D CLS_H_HIFI || mode =3D=3D CLS_H_LP)
-=09=09=09snd_soc_component_update_bits(component,
-=09=09=09=09=09WCD9XXX_CLASSH_MODE_3,
-=09=09=09=09=090x02, 0x00);
-
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09=09WCD9XXX_CLASSH_MODE_2,
-=09=09=09=09=090xFF, 0x3A);
-=09=09/* 500usec delay is needed as per HW requirement */
-=09=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
-=09}
-}
-
-static void wcd_clsh_flyback_ctrl(struct wcd_clsh_ctrl *ctrl,
-=09=09=09=09  int mode,
-=09=09=09=09  bool enable)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09/* enable/disable flyback */
-=09if ((enable && (++ctrl->flyback_users =3D=3D 1)) ||
-=09   (!enable && (--ctrl->flyback_users =3D=3D 0))) {
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_EN_MASK,
-=09=09=09=09enable << WCD9XXX_A_ANA_RX_VNEG_EN_SHIFT);
-=09=09/* 100usec delay is needed as per HW requirement */
-=09=09usleep_range(100, 110);
-=09}
-=09/*
-=09 * 500us sleep is required after flyback enable/disable
-=09 * as per HW requirement
-=09 */
-=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
-}
-
-static void wcd_clsh_set_gain_path(struct wcd_clsh_ctrl *ctrl, int mode)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-=09int val =3D 0;
-
-=09switch (mode) {
-=09case CLS_H_NORMAL:
-=09case CLS_AB:
-=09=09val =3D WCD9XXX_HPH_CONST_SEL_BYPASS;
-=09=09break;
-=09case CLS_H_HIFI:
-=09=09val =3D WCD9XXX_HPH_CONST_SEL_HQ_PATH;
-=09=09break;
-=09case CLS_H_LP:
-=09=09val =3D WCD9XXX_HPH_CONST_SEL_LP_PATH;
-=09=09break;
-=09}
-
-=09snd_soc_component_update_bits(comp, WCD9XXX_HPH_L_EN,
-=09=09=09=09=09WCD9XXX_HPH_CONST_SEL_L_MASK,
-=09=09=09=09=09val);
-
-=09snd_soc_component_update_bits(comp, WCD9XXX_HPH_R_EN,
-=09=09=09=09=09WCD9XXX_HPH_CONST_SEL_L_MASK,
-=09=09=09=09=09val);
-}
-
-static void wcd_clsh_v2_set_hph_mode(struct snd_soc_component *comp, int m=
ode)
-{
-=09int val =3D 0, gain =3D 0, res_val;
-=09int ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
-
-=09res_val =3D WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_0KOHM;
-=09switch (mode) {
-=09case CLS_H_NORMAL:
-=09=09res_val =3D WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_50KOHM;
-=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_NORMAL;
-=09=09gain =3D DAC_GAIN_0DB;
-=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
-=09=09break;
-=09case CLS_AB:
-=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_NORMAL;
-=09=09gain =3D DAC_GAIN_0DB;
-=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
-=09=09break;
-=09case CLS_H_HIFI:
-=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_UHQA;
-=09=09gain =3D DAC_GAIN_M0P2DB;
-=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
-=09=09break;
-=09case CLS_H_LP:
-=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_LP;
-=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_30MA;
-=09=09break;
-=09}
-
-=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_HPH,
-=09=09=09=09=09WCD9XXX_A_ANA_HPH_PWR_LEVEL_MASK, val);
-=09snd_soc_component_update_bits(comp, WCD9XXX_CLASSH_CTRL_VCL_2,
-=09=09=09=09WCD9XXX_CLASSH_CTRL_VCL_2_VREF_FILT_1_MASK,
-=09=09=09=09res_val);
-=09if (mode !=3D CLS_H_LP)
-=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09WCD9XXX_HPH_REFBUFF_UHQA_CTL,
-=09=09=09=09=09WCD9XXX_HPH_REFBUFF_UHQA_GAIN_MASK,
-=09=09=09=09=09gain);
-=09snd_soc_component_update_bits(comp, WCD9XXX_CLASSH_CTRL_CCL_1,
-=09=09=09=09WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_MASK,
-=09=09=09=09ipeak);
-}
-
-static void wcd_clsh_v3_set_hph_mode(struct snd_soc_component *component,
-=09=09=09=09  int mode)
-{
-=09u8 val;
-
-=09switch (mode) {
-=09case CLS_H_NORMAL:
-=09=09val =3D 0x00;
-=09=09break;
-=09case CLS_AB:
-=09case CLS_H_ULP:
-=09=09val =3D 0x0C;
-=09=09break;
-=09case CLS_AB_HIFI:
-=09case CLS_H_HIFI:
-=09=09val =3D 0x08;
-=09=09break;
-=09case CLS_H_LP:
-=09case CLS_H_LOHIFI:
-=09case CLS_AB_LP:
-=09case CLS_AB_LOHIFI:
-=09=09val =3D 0x04;
-=09=09break;
-=09default:
-=09=09dev_err(component->dev, "%s:Invalid mode %d\n", __func__, mode);
-=09=09return;
-=09}
-
-=09snd_soc_component_update_bits(component, WCD9XXX_ANA_HPH, 0x0C, val);
-}
-
-void wcd_clsh_set_hph_mode(struct wcd_clsh_ctrl *ctrl, int mode)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09if (ctrl->codec_version >=3D WCD937X)
-=09=09wcd_clsh_v3_set_hph_mode(comp, mode);
-=09else
-=09=09wcd_clsh_v2_set_hph_mode(comp, mode);
-
-}
-
-static void wcd_clsh_set_flyback_current(struct snd_soc_component *comp,
-=09=09=09=09=09 int mode)
-{
-
-=09snd_soc_component_update_bits(comp, WCD9XXX_RX_BIAS_FLYB_BUFF,
-=09=09=09=09WCD9XXX_RX_BIAS_FLYB_VPOS_5_UA_MASK, 0x0A);
-=09snd_soc_component_update_bits(comp, WCD9XXX_RX_BIAS_FLYB_BUFF,
-=09=09=09=09WCD9XXX_RX_BIAS_FLYB_VNEG_5_UA_MASK, 0x0A);
-=09/* Sleep needed to avoid click and pop as per HW requirement */
-=09usleep_range(100, 110);
-}
-
-static void wcd_clsh_set_buck_regulator_mode(struct snd_soc_component *com=
p,
-=09=09=09=09=09     int mode)
-{
-=09if (mode =3D=3D CLS_AB)
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_MASK,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_AB);
-=09else
-=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_MASK,
-=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_H);
-}
-
-static void wcd_clsh_v3_set_buck_regulator_mode(struct snd_soc_component *=
component,
-=09=09=09=09=09=09int mode)
-{
-=09snd_soc_component_update_bits(component, WCD9XXX_ANA_RX_SUPPLIES,
-=09=09=09    0x02, 0x00);
-}
-
-static void wcd_clsh_v3_set_flyback_mode(struct snd_soc_component *compone=
nt,
-=09=09=09=09=09=09int mode)
-{
-=09if (mode =3D=3D CLS_H_HIFI || mode =3D=3D CLS_H_LOHIFI ||
-=09    mode =3D=3D CLS_AB_HIFI || mode =3D=3D CLS_AB_LOHIFI) {
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
-=09=09=09=090x04, 0x04);
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_FLYBACK_VNEG_CTRL_4,
-=09=09=09=090xF0, 0x80);
-=09} else {
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
-=09=09=09=090x04, 0x00); /* set to Default */
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_FLYBACK_VNEG_CTRL_4,
-=09=09=09=090xF0, 0x70);
-=09}
-}
-
-static void wcd_clsh_v3_force_iq_ctl(struct snd_soc_component *component,
-=09=09=09=09=09 int mode, bool enable)
-{
-=09if (enable) {
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_FLYBACK_VNEGDAC_CTRL_2,
-=09=09=09=090xE0, 0xA0);
-=09=09/* 100usec delay is needed as per HW requirement */
-=09=09usleep_range(100, 110);
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_CLASSH_MODE_3,
-=09=09=09=090x02, 0x02);
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_CLASSH_MODE_2,
-=09=09=09=090xFF, 0x1C);
-=09=09if (mode =3D=3D CLS_H_LOHIFI || mode =3D=3D CLS_AB_LOHIFI) {
-=09=09=09snd_soc_component_update_bits(component,
-=09=09=09=09=09WCD9XXX_HPH_NEW_INT_PA_MISC2,
-=09=09=09=09=090x20, 0x20);
-=09=09=09snd_soc_component_update_bits(component,
-=09=09=09=09=09WCD9XXX_RX_BIAS_HPH_LOWPOWER,
-=09=09=09=09=090xF0, 0xC0);
-=09=09=09snd_soc_component_update_bits(component,
-=09=09=09=09=09WCD9XXX_HPH_PA_CTL1,
-=09=09=09=09=090x0E, 0x02);
-=09=09}
-=09} else {
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_HPH_NEW_INT_PA_MISC2,
-=09=09=09=090x20, 0x00);
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_RX_BIAS_HPH_LOWPOWER,
-=09=09=09=090xF0, 0x80);
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_HPH_PA_CTL1,
-=09=09=09=090x0E, 0x06);
-=09}
-}
-
-static void wcd_clsh_v3_flyback_ctrl(struct snd_soc_component *component,
-=09=09=09=09  struct wcd_clsh_ctrl *ctrl,
-=09=09=09=09  int mode,
-=09=09=09=09  bool enable)
-{
-=09/* enable/disable flyback */
-=09if ((enable && (++ctrl->flyback_users =3D=3D 1)) ||
-=09   (!enable && (--ctrl->flyback_users =3D=3D 0))) {
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_FLYBACK_VNEG_CTRL_1,
-=09=09=09=090xE0, 0xE0);
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
-=09=09=09=09(1 << 6), (enable << 6));
-=09=09/*
-=09=09 * 100us sleep is required after flyback enable/disable
-=09=09 * as per HW requirement
-=09=09 */
-=09=09usleep_range(100, 110);
-=09=09snd_soc_component_update_bits(component,
-=09=09=09=09WCD9XXX_FLYBACK_VNEGDAC_CTRL_2,
-=09=09=09=090xE0, 0xE0);
-=09=09/* 500usec delay is needed as per HW requirement */
-=09=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
-=09}
-}
-
-static void wcd_clsh_v3_set_flyback_current(struct snd_soc_component *comp=
onent,
-=09=09=09=09int mode)
-{
-=09snd_soc_component_update_bits(component, WCD9XXX_V3_RX_BIAS_FLYB_BUFF,
-=09=09=09=090x0F, 0x0A);
-=09snd_soc_component_update_bits(component, WCD9XXX_V3_RX_BIAS_FLYB_BUFF,
-=09=09=09=090xF0, 0xA0);
-=09/* Sleep needed to avoid click and pop as per HW requirement */
-=09usleep_range(100, 110);
-}
-
-static void wcd_clsh_v3_state_aux(struct wcd_clsh_ctrl *ctrl, int req_stat=
e,
-=09=09=09      bool is_enable, int mode)
-{
-=09struct snd_soc_component *component =3D ctrl->comp;
-
-=09if (is_enable) {
-=09=09wcd_clsh_v3_set_buck_mode(component, mode);
-=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
-=09=09wcd_clsh_v3_set_flyback_current(component, mode);
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
-=09} else {
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, false);
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, false);
-=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
-=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
-=09}
-}
-
-static void wcd_clsh_state_lo(struct wcd_clsh_ctrl *ctrl, int req_state,
-=09=09=09      bool is_enable, int mode)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09if (mode !=3D CLS_AB) {
-=09=09dev_err(comp->dev, "%s: LO cannot be in this mode: %d\n",
-=09=09=09__func__, mode);
-=09=09return;
-=09}
-
-=09if (is_enable) {
-=09=09wcd_clsh_set_buck_regulator_mode(comp, mode);
-=09=09wcd_clsh_set_buck_mode(comp, mode);
-=09=09wcd_clsh_set_flyback_mode(comp, mode);
-=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
-=09=09wcd_clsh_set_flyback_current(comp, mode);
-=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
-=09} else {
-=09=09wcd_clsh_buck_ctrl(ctrl, mode, false);
-=09=09wcd_clsh_flyback_ctrl(ctrl, mode, false);
-=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
-=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
-=09=09wcd_clsh_set_buck_regulator_mode(comp, CLS_H_NORMAL);
-=09}
-}
-
-static void wcd_clsh_v3_state_hph_r(struct wcd_clsh_ctrl *ctrl, int req_st=
ate,
-=09=09=09=09 bool is_enable, int mode)
-{
-=09struct snd_soc_component *component =3D ctrl->comp;
-
-=09if (mode =3D=3D CLS_H_NORMAL) {
-=09=09dev_dbg(component->dev, "%s: Normal mode not applicable for hph_r\n"=
,
-=09=09=09__func__);
-=09=09return;
-=09}
-
-=09if (is_enable) {
-=09=09wcd_clsh_v3_set_buck_regulator_mode(component, mode);
-=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
-=09=09wcd_clsh_v3_force_iq_ctl(component, mode, true);
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
-=09=09wcd_clsh_v3_set_flyback_current(component, mode);
-=09=09wcd_clsh_v3_set_buck_mode(component, mode);
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
-=09=09wcd_clsh_v3_set_hph_mode(component, mode);
-=09} else {
-=09=09wcd_clsh_v3_set_hph_mode(component, CLS_H_NORMAL);
-
-=09=09/* buck and flyback set to default mode and disable */
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_force_iq_ctl(component, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
-=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
-=09}
-}
-
-static void wcd_clsh_state_hph_r(struct wcd_clsh_ctrl *ctrl, int req_state=
,
-=09=09=09=09 bool is_enable, int mode)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09if (mode =3D=3D CLS_H_NORMAL) {
-=09=09dev_err(comp->dev, "%s: Normal mode not applicable for hph_r\n",
-=09=09=09__func__);
-=09=09return;
-=09}
-
-=09if (is_enable) {
-=09=09if (mode !=3D CLS_AB) {
-=09=09=09wcd_enable_clsh_block(ctrl, true);
-=09=09=09/*
-=09=09=09 * These K1 values depend on the Headphone Impedance
-=09=09=09 * For now it is assumed to be 16 ohm
-=09=09=09 */
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB_COEF_MASK,
-=09=09=09=09=090x00);
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB_COEF_MASK,
-=09=09=09=09=090xC0);
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX2_RX_PATH_CFG0,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE);
-=09=09}
-=09=09wcd_clsh_set_buck_regulator_mode(comp, mode);
-=09=09wcd_clsh_set_flyback_mode(comp, mode);
-=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
-=09=09wcd_clsh_set_flyback_current(comp, mode);
-=09=09wcd_clsh_set_buck_mode(comp, mode);
-=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
-=09=09wcd_clsh_v2_set_hph_mode(comp, mode);
-=09=09wcd_clsh_set_gain_path(ctrl, mode);
-=09} else {
-=09=09wcd_clsh_v2_set_hph_mode(comp, CLS_H_NORMAL);
-
-=09=09if (mode !=3D CLS_AB) {
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX2_RX_PATH_CFG0,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE);
-=09=09=09wcd_enable_clsh_block(ctrl, false);
-=09=09}
-=09=09/* buck and flyback set to default mode and disable */
-=09=09wcd_clsh_buck_ctrl(ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_flyback_ctrl(ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
-=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
-=09=09wcd_clsh_set_buck_regulator_mode(comp, CLS_H_NORMAL);
-=09}
-}
-
-static void wcd_clsh_v3_state_hph_l(struct wcd_clsh_ctrl *ctrl, int req_st=
ate,
-=09=09=09=09 bool is_enable, int mode)
-{
-=09struct snd_soc_component *component =3D ctrl->comp;
-
-=09if (mode =3D=3D CLS_H_NORMAL) {
-=09=09dev_dbg(component->dev, "%s: Normal mode not applicable for hph_l\n"=
,
-=09=09=09__func__);
-=09=09return;
-=09}
-
-=09if (is_enable) {
-=09=09wcd_clsh_v3_set_buck_regulator_mode(component, mode);
-=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
-=09=09wcd_clsh_v3_force_iq_ctl(component, mode, true);
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
-=09=09wcd_clsh_v3_set_flyback_current(component, mode);
-=09=09wcd_clsh_v3_set_buck_mode(component, mode);
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
-=09=09wcd_clsh_v3_set_hph_mode(component, mode);
-=09} else {
-=09=09wcd_clsh_v3_set_hph_mode(component, CLS_H_NORMAL);
-
-=09=09/* set buck and flyback to Default Mode */
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_force_iq_ctl(component, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
-=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
-=09}
-}
-
-static void wcd_clsh_state_hph_l(struct wcd_clsh_ctrl *ctrl, int req_state=
,
-=09=09=09=09 bool is_enable, int mode)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09if (mode =3D=3D CLS_H_NORMAL) {
-=09=09dev_err(comp->dev, "%s: Normal mode not applicable for hph_l\n",
-=09=09=09__func__);
-=09=09return;
-=09}
-
-=09if (is_enable) {
-=09=09if (mode !=3D CLS_AB) {
-=09=09=09wcd_enable_clsh_block(ctrl, true);
-=09=09=09/*
-=09=09=09 * These K1 values depend on the Headphone Impedance
-=09=09=09 * For now it is assumed to be 16 ohm
-=09=09=09 */
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB_COEF_MASK,
-=09=09=09=09=090x00);
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB,
-=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB_COEF_MASK,
-=09=09=09=09=090xC0);
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX1_RX_PATH_CFG0,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE);
-=09=09}
-=09=09wcd_clsh_set_buck_regulator_mode(comp, mode);
-=09=09wcd_clsh_set_flyback_mode(comp, mode);
-=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
-=09=09wcd_clsh_set_flyback_current(comp, mode);
-=09=09wcd_clsh_set_buck_mode(comp, mode);
-=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
-=09=09wcd_clsh_v2_set_hph_mode(comp, mode);
-=09=09wcd_clsh_set_gain_path(ctrl, mode);
-=09} else {
-=09=09wcd_clsh_v2_set_hph_mode(comp, CLS_H_NORMAL);
-
-=09=09if (mode !=3D CLS_AB) {
-=09=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX1_RX_PATH_CFG0,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
-=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE);
-=09=09=09wcd_enable_clsh_block(ctrl, false);
-=09=09}
-=09=09/* set buck and flyback to Default Mode */
-=09=09wcd_clsh_buck_ctrl(ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_flyback_ctrl(ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
-=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
-=09=09wcd_clsh_set_buck_regulator_mode(comp, CLS_H_NORMAL);
-=09}
-}
-
-static void wcd_clsh_v3_state_ear(struct wcd_clsh_ctrl *ctrl, int req_stat=
e,
-=09=09=09       bool is_enable, int mode)
-{
-=09struct snd_soc_component *component =3D ctrl->comp;
-
-=09if (is_enable) {
-=09=09wcd_clsh_v3_set_buck_regulator_mode(component, mode);
-=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
-=09=09wcd_clsh_v3_force_iq_ctl(component, mode, true);
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
-=09=09wcd_clsh_v3_set_flyback_current(component, mode);
-=09=09wcd_clsh_v3_set_buck_mode(component, mode);
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
-=09=09wcd_clsh_v3_set_hph_mode(component, mode);
-=09} else {
-=09=09wcd_clsh_v3_set_hph_mode(component, CLS_H_NORMAL);
-
-=09=09/* set buck and flyback to Default Mode */
-=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_force_iq_ctl(component, CLS_H_NORMAL, false);
-=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
-=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
-=09}
-}
-
-static void wcd_clsh_state_ear(struct wcd_clsh_ctrl *ctrl, int req_state,
-=09=09=09       bool is_enable, int mode)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09if (mode !=3D CLS_H_NORMAL) {
-=09=09dev_err(comp->dev, "%s: mode: %d cannot be used for EAR\n",
-=09=09=09__func__, mode);
-=09=09return;
-=09}
-
-=09if (is_enable) {
-=09=09wcd_enable_clsh_block(ctrl, true);
-=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09WCD9XXX_A_CDC_RX0_RX_PATH_CFG0,
-=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
-=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE);
-=09=09wcd_clsh_set_buck_mode(comp, mode);
-=09=09wcd_clsh_set_flyback_mode(comp, mode);
-=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
-=09=09wcd_clsh_set_flyback_current(comp, mode);
-=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
-=09} else {
-=09=09snd_soc_component_update_bits(comp,
-=09=09=09=09=09WCD9XXX_A_CDC_RX0_RX_PATH_CFG0,
-=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
-=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE);
-=09=09wcd_enable_clsh_block(ctrl, false);
-=09=09wcd_clsh_buck_ctrl(ctrl, mode, false);
-=09=09wcd_clsh_flyback_ctrl(ctrl, mode, false);
-=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
-=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
-=09}
-}
-
-static int _wcd_clsh_ctrl_set_state(struct wcd_clsh_ctrl *ctrl, int req_st=
ate,
-=09=09=09=09    bool is_enable, int mode)
-{
-=09switch (req_state) {
-=09case WCD_CLSH_STATE_EAR:
-=09=09if (ctrl->codec_version >=3D WCD937X)
-=09=09=09wcd_clsh_v3_state_ear(ctrl, req_state, is_enable, mode);
-=09=09else
-=09=09=09wcd_clsh_state_ear(ctrl, req_state, is_enable, mode);
-=09=09break;
-=09case WCD_CLSH_STATE_HPHL:
-=09=09if (ctrl->codec_version >=3D WCD937X)
-=09=09=09wcd_clsh_v3_state_hph_l(ctrl, req_state, is_enable, mode);
-=09=09else
-=09=09=09wcd_clsh_state_hph_l(ctrl, req_state, is_enable, mode);
-=09=09break;
-=09case WCD_CLSH_STATE_HPHR:
-=09=09if (ctrl->codec_version >=3D WCD937X)
-=09=09=09wcd_clsh_v3_state_hph_r(ctrl, req_state, is_enable, mode);
-=09=09else
-=09=09=09wcd_clsh_state_hph_r(ctrl, req_state, is_enable, mode);
-=09=09break;
-=09case WCD_CLSH_STATE_LO:
-=09=09if (ctrl->codec_version < WCD937X)
-=09=09=09wcd_clsh_state_lo(ctrl, req_state, is_enable, mode);
-=09=09break;
-=09case WCD_CLSH_STATE_AUX:
-=09=09if (ctrl->codec_version >=3D WCD937X)
-=09=09=09wcd_clsh_v3_state_aux(ctrl, req_state, is_enable, mode);
-=09=09break;
-=09default:
-=09=09break;
-=09}
-
-=09return 0;
-}
-
-/*
- * Function: wcd_clsh_is_state_valid
- * Params: state
- * Description:
- * Provides information on valid states of Class H configuration
- */
-static bool wcd_clsh_is_state_valid(int state)
-{
-=09switch (state) {
-=09case WCD_CLSH_STATE_IDLE:
-=09case WCD_CLSH_STATE_EAR:
-=09case WCD_CLSH_STATE_HPHL:
-=09case WCD_CLSH_STATE_HPHR:
-=09case WCD_CLSH_STATE_LO:
-=09case WCD_CLSH_STATE_AUX:
-=09=09return true;
-=09default:
-=09=09return false;
-=09};
-}
-
-/*
- * Function: wcd_clsh_fsm
- * Params: ctrl, req_state, req_type, clsh_event
- * Description:
- * This function handles PRE DAC and POST DAC conditions of different devi=
ces
- * and updates class H configuration of different combination of devices
- * based on validity of their states. ctrl will contain current
- * class h state information
- */
-int wcd_clsh_ctrl_set_state(struct wcd_clsh_ctrl *ctrl,
-=09=09=09    enum wcd_clsh_event clsh_event,
-=09=09=09    int nstate,
-=09=09=09    enum wcd_clsh_mode mode)
-{
-=09struct snd_soc_component *comp =3D ctrl->comp;
-
-=09if (nstate =3D=3D ctrl->state)
-=09=09return 0;
-
-=09if (!wcd_clsh_is_state_valid(nstate)) {
-=09=09dev_err(comp->dev, "Class-H not a valid new state:\n");
-=09=09return -EINVAL;
-=09}
-
-=09switch (clsh_event) {
-=09case WCD_CLSH_EVENT_PRE_DAC:
-=09=09_wcd_clsh_ctrl_set_state(ctrl, nstate, CLSH_REQ_ENABLE, mode);
-=09=09break;
-=09case WCD_CLSH_EVENT_POST_PA:
-=09=09_wcd_clsh_ctrl_set_state(ctrl, nstate, CLSH_REQ_DISABLE, mode);
-=09=09break;
-=09}
-
-=09ctrl->state =3D nstate;
-=09ctrl->mode =3D mode;
-
-=09return 0;
-}
-
-int wcd_clsh_ctrl_get_state(struct wcd_clsh_ctrl *ctrl)
-{
-=09return ctrl->state;
-}
-
-struct wcd_clsh_ctrl *wcd_clsh_ctrl_alloc(struct snd_soc_component *comp,
-=09=09=09=09=09  int version)
-{
-=09struct wcd_clsh_ctrl *ctrl;
-
-=09ctrl =3D kzalloc(sizeof(*ctrl), GFP_KERNEL);
-=09if (!ctrl)
-=09=09return ERR_PTR(-ENOMEM);
-
-=09ctrl->state =3D WCD_CLSH_STATE_IDLE;
-=09ctrl->comp =3D comp;
-=09ctrl->codec_version =3D version;
-
-=09return ctrl;
-}
-
-void wcd_clsh_ctrl_free(struct wcd_clsh_ctrl *ctrl)
-{
-=09kfree(ctrl);
-}
diff --git a/sound/soc/codecs/wcd-clsh-v2.h b/sound/soc/codecs/wcd-clsh-v2.=
h
index 4e3653058275..3074e9b235d4 100644
--- a/sound/soc/codecs/wcd-clsh-v2.h
+++ b/sound/soc/codecs/wcd-clsh-v2.h
@@ -2,8 +2,14 @@

 #ifndef _WCD_CLSH_V2_H_
 #define _WCD_CLSH_V2_H_
+
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
 #include <sound/soc.h>

+#include "wcd9335.h"
+
 enum wcd_clsh_event {
 =09WCD_CLSH_EVENT_PRE_DAC =3D 1,
 =09WCD_CLSH_EVENT_POST_PA,
@@ -48,18 +54,903 @@ enum wcd_codec_version {
 =09WCD937X  =3D 2,
 =09WCD938X  =3D 3,
 };
-struct wcd_clsh_ctrl;
-
-extern struct wcd_clsh_ctrl *wcd_clsh_ctrl_alloc(
-=09=09=09=09struct snd_soc_component *comp,
-=09=09=09=09int version);
-extern void wcd_clsh_ctrl_free(struct wcd_clsh_ctrl *ctrl);
-extern int wcd_clsh_ctrl_get_state(struct wcd_clsh_ctrl *ctrl);
-extern int wcd_clsh_ctrl_set_state(struct wcd_clsh_ctrl *ctrl,
-=09=09=09=09   enum wcd_clsh_event clsh_event,
-=09=09=09=09   int nstate,
-=09=09=09=09   enum wcd_clsh_mode mode);
-extern void wcd_clsh_set_hph_mode(struct wcd_clsh_ctrl *ctrl,
-=09=09=09=09  int mode);
+
+struct wcd_clsh_ctrl {
+=09int state;
+=09int mode;
+=09int flyback_users;
+=09int buck_users;
+=09int clsh_users;
+=09int codec_version;
+=09struct snd_soc_component *comp;
+};
+
+/* Class-H registers for codecs from and above WCD9335 */
+#define WCD9XXX_A_CDC_RX0_RX_PATH_CFG0=09=09=09WCD9335_REG(0xB, 0x42)
+#define WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK=09=09BIT(6)
+#define WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE=09=09BIT(6)
+#define WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE=09=090
+#define WCD9XXX_A_CDC_RX1_RX_PATH_CFG0=09=09=09WCD9335_REG(0xB, 0x56)
+#define WCD9XXX_A_CDC_RX2_RX_PATH_CFG0=09=09=09WCD9335_REG(0xB, 0x6A)
+#define WCD9XXX_A_CDC_CLSH_K1_MSB=09=09=09WCD9335_REG(0xC, 0x08)
+#define WCD9XXX_A_CDC_CLSH_K1_MSB_COEF_MASK=09=09GENMASK(3, 0)
+#define WCD9XXX_A_CDC_CLSH_K1_LSB=09=09=09WCD9335_REG(0xC, 0x09)
+#define WCD9XXX_A_CDC_CLSH_K1_LSB_COEF_MASK=09=09GENMASK(7, 0)
+#define WCD9XXX_A_ANA_RX_SUPPLIES=09=09=09WCD9335_REG(0x6, 0x08)
+#define WCD9XXX_A_ANA_RX_REGULATOR_MODE_MASK=09=09BIT(1)
+#define WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_H=09=090
+#define WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_AB=09=09BIT(1)
+#define WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_MASK=09=09BIT(2)
+#define WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_UHQA=09=09BIT(2)
+#define WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_DEFAULT=09=090
+#define WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_MASK=09=09BIT(3)
+#define WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_UHQA=09=09BIT(3)
+#define WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_DEFAULT=09=090
+#define WCD9XXX_A_ANA_RX_VNEG_EN_MASK=09=09=09BIT(6)
+#define WCD9XXX_A_ANA_RX_VNEG_EN_SHIFT=09=09=096
+#define WCD9XXX_A_ANA_RX_VNEG_ENABLE=09=09=09BIT(6)
+#define WCD9XXX_A_ANA_RX_VNEG_DISABLE=09=09=090
+#define WCD9XXX_A_ANA_RX_VPOS_EN_MASK=09=09=09BIT(7)
+#define WCD9XXX_A_ANA_RX_VPOS_EN_SHIFT=09=09=097
+#define WCD9XXX_A_ANA_RX_VPOS_ENABLE=09=09=09BIT(7)
+#define WCD9XXX_A_ANA_RX_VPOS_DISABLE=09=09=090
+#define WCD9XXX_A_ANA_HPH=09=09=09=09WCD9335_REG(0x6, 0x09)
+#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_MASK=09=09GENMASK(3, 2)
+#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_UHQA=09=090x08
+#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_LP=09=09=090x04
+#define WCD9XXX_A_ANA_HPH_PWR_LEVEL_NORMAL=09=090x0
+#define WCD9XXX_A_CDC_CLSH_CRC=09=09=09=09WCD9335_REG(0xC, 0x01)
+#define WCD9XXX_A_CDC_CLSH_CRC_CLK_EN_MASK=09=09BIT(0)
+#define WCD9XXX_A_CDC_CLSH_CRC_CLK_ENABLE=09=09BIT(0)
+#define WCD9XXX_A_CDC_CLSH_CRC_CLK_DISABLE=09=090
+#define WCD9XXX_FLYBACK_EN=09=09=09=09WCD9335_REG(0x6, 0xA4)
+#define WCD9XXX_FLYBACK_EN_DELAY_SEL_MASK=09=09GENMASK(6, 5)
+#define WCD9XXX_FLYBACK_EN_DELAY_26P25_US=09=090x40
+#define WCD9XXX_FLYBACK_EN_RESET_BY_EXT_MASK=09=09BIT(4)
+#define WCD9XXX_FLYBACK_EN_PWDN_WITHOUT_DELAY=09=09BIT(4)
+#define WCD9XXX_FLYBACK_EN_PWDN_WITH_DELAY=09=09=090
+#define WCD9XXX_RX_BIAS_FLYB_BUFF=09=09=09WCD9335_REG(0x6, 0xC7)
+#define WCD9XXX_RX_BIAS_FLYB_VNEG_5_UA_MASK=09=09GENMASK(7, 4)
+#define WCD9XXX_RX_BIAS_FLYB_VPOS_5_UA_MASK=09=09GENMASK(3, 0)
+#define WCD9XXX_HPH_L_EN=09=09=09=09WCD9335_REG(0x6, 0xD3)
+#define WCD9XXX_HPH_CONST_SEL_L_MASK=09=09=09GENMASK(7, 3)
+#define WCD9XXX_HPH_CONST_SEL_BYPASS=09=09=090
+#define WCD9XXX_HPH_CONST_SEL_LP_PATH=09=09=090x40
+#define WCD9XXX_HPH_CONST_SEL_HQ_PATH=09=09=090x80
+#define WCD9XXX_HPH_R_EN=09=09=09=09WCD9335_REG(0x6, 0xD6)
+#define WCD9XXX_HPH_REFBUFF_UHQA_CTL=09=09=09WCD9335_REG(0x6, 0xDD)
+#define WCD9XXX_HPH_REFBUFF_UHQA_GAIN_MASK=09=09GENMASK(2, 0)
+#define WCD9XXX_CLASSH_CTRL_VCL_2                       WCD9335_REG(0x6, 0=
x9B)
+#define WCD9XXX_CLASSH_CTRL_VCL_2_VREF_FILT_1_MASK=09GENMASK(5, 4)
+#define WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_50KOHM=090x20
+#define WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_0KOHM=090x0
+#define WCD9XXX_CDC_RX1_RX_PATH_CTL=09=09=09WCD9335_REG(0xB, 0x55)
+#define WCD9XXX_CDC_RX2_RX_PATH_CTL=09=09=09WCD9335_REG(0xB, 0x69)
+#define WCD9XXX_CDC_CLK_RST_CTRL_MCLK_CONTROL=09=09WCD9335_REG(0xD, 0x41)
+#define WCD9XXX_CDC_CLK_RST_CTRL_MCLK_EN_MASK=09=09BIT(0)
+#define WCD9XXX_CDC_CLK_RST_CTRL_MCLK_11P3_EN_MASK=09BIT(1)
+#define WCD9XXX_CLASSH_CTRL_CCL_1                       WCD9335_REG(0x6, 0=
x9C)
+#define WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_MASK=09GENMASK(7, 4)
+#define WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA=090x50
+#define WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_30MA=090x30
+
+#define WCD9XXX_BASE_ADDRESS=09=09=09=090x3000
+#define WCD9XXX_ANA_RX_SUPPLIES=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x008)
+#define WCD9XXX_ANA_HPH=09=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x009)
+#define WCD9XXX_CLASSH_MODE_2=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x098)
+#define WCD9XXX_CLASSH_MODE_3=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x099)
+#define WCD9XXX_FLYBACK_VNEG_CTRL_1=09=09=09(WCD9XXX_BASE_ADDRESS+0x0A5)
+#define WCD9XXX_FLYBACK_VNEG_CTRL_4=09=09=09(WCD9XXX_BASE_ADDRESS+0x0A8)
+#define WCD9XXX_FLYBACK_VNEGDAC_CTRL_2=09=09=09(WCD9XXX_BASE_ADDRESS+0x0AF=
)
+#define WCD9XXX_RX_BIAS_HPH_LOWPOWER=09=09=09(WCD9XXX_BASE_ADDRESS+0x0BF)
+#define WCD9XXX_V3_RX_BIAS_FLYB_BUFF=09=09=09(WCD9XXX_BASE_ADDRESS+0x0C7)
+#define WCD9XXX_HPH_PA_CTL1=09=09=09=09(WCD9XXX_BASE_ADDRESS+0x0D1)
+#define WCD9XXX_HPH_NEW_INT_PA_MISC2=09=09=09(WCD9XXX_BASE_ADDRESS+0x138)
+
+#define CLSH_REQ_ENABLE=09=09true
+#define CLSH_REQ_DISABLE=09false
+#define WCD_USLEEP_RANGE=0950
+
+enum {
+=09DAC_GAIN_0DB =3D 0,
+=09DAC_GAIN_0P2DB,
+=09DAC_GAIN_0P4DB,
+=09DAC_GAIN_0P6DB,
+=09DAC_GAIN_0P8DB,
+=09DAC_GAIN_M0P2DB,
+=09DAC_GAIN_M0P4DB,
+=09DAC_GAIN_M0P6DB,
+};
+
+static inline void wcd_enable_clsh_block(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09 bool enable)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09if ((enable && ++ctrl->clsh_users =3D=3D 1) ||
+=09    (!enable && --ctrl->clsh_users =3D=3D 0))
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_CDC_CLSH_CRC,
+=09=09=09=09      WCD9XXX_A_CDC_CLSH_CRC_CLK_EN_MASK,
+=09=09=09=09      enable);
+=09if (ctrl->clsh_users < 0)
+=09=09ctrl->clsh_users =3D 0;
+}
+
+static inline bool wcd_clsh_enable_status(struct snd_soc_component *comp)
+{
+=09return snd_soc_component_read(comp, WCD9XXX_A_CDC_CLSH_CRC) &
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_CRC_CLK_EN_MASK;
+}
+
+static inline void wcd_clsh_set_buck_mode(struct snd_soc_component *comp,
+=09=09=09=09=09  int mode)
+{
+=09/* set to HIFI */
+=09if (mode =3D=3D CLS_H_HIFI)
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_MASK,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_UHQA);
+=09else
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_MASK,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_PWR_LVL_DEFAULT);
+}
+
+static inline void wcd_clsh_v3_set_buck_mode(struct snd_soc_component *com=
ponent,
+=09=09=09=09=09     int mode)
+{
+=09if (mode =3D=3D CLS_H_HIFI || mode =3D=3D CLS_H_LOHIFI ||
+=09    mode =3D=3D CLS_AB_HIFI || mode =3D=3D CLS_AB_LOHIFI)
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
+=09=09=09=090x08, 0x08); /* set to HIFI */
+=09else
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
+=09=09=09=090x08, 0x00); /* set to default */
+}
+
+static inline void wcd_clsh_set_flyback_mode(struct snd_soc_component *com=
p,
+=09=09=09=09=09     int mode)
+{
+=09/* set to HIFI */
+=09if (mode =3D=3D CLS_H_HIFI)
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_MASK,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_UHQA);
+=09else
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_MASK,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_PWR_LVL_DEFAULT);
+}
+
+static inline  void wcd_clsh_buck_ctrl(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09       int mode,
+=09=09=09=09       bool enable)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09/* enable/disable buck */
+=09if ((enable && (++ctrl->buck_users =3D=3D 1)) ||
+=09   (!enable && (--ctrl->buck_users =3D=3D 0)))
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09WCD9XXX_A_ANA_RX_VPOS_EN_MASK,
+=09=09=09=09enable << WCD9XXX_A_ANA_RX_VPOS_EN_SHIFT);
+=09/*
+=09 * 500us sleep is required after buck enable/disable
+=09 * as per HW requirement
+=09 */
+=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
+}
+
+static inline void wcd_clsh_v3_buck_ctrl(struct snd_soc_component *compone=
nt,
+=09=09=09=09=09 struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09 int mode,
+=09=09=09=09=09 bool enable)
+{
+=09/* enable/disable buck */
+=09if ((enable && (++ctrl->buck_users =3D=3D 1)) ||
+=09   (!enable && (--ctrl->buck_users =3D=3D 0))) {
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
+=09=09=09=09(1 << 7), (enable << 7));
+=09=09/*
+=09=09 * 500us sleep is required after buck enable/disable
+=09=09 * as per HW requirement
+=09=09 */
+=09=09usleep_range(500, 510);
+=09=09if (mode =3D=3D CLS_H_LOHIFI || mode =3D=3D CLS_H_ULP ||
+=09=09=09mode =3D=3D CLS_H_HIFI || mode =3D=3D CLS_H_LP)
+=09=09=09snd_soc_component_update_bits(component,
+=09=09=09=09=09WCD9XXX_CLASSH_MODE_3,
+=09=09=09=09=090x02, 0x00);
+
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09=09WCD9XXX_CLASSH_MODE_2,
+=09=09=09=09=090xFF, 0x3A);
+=09=09/* 500usec delay is needed as per HW requirement */
+=09=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
+=09}
+}
+
+static inline void wcd_clsh_flyback_ctrl(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09 int mode,
+=09=09=09=09=09 bool enable)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09/* enable/disable flyback */
+=09if ((enable && (++ctrl->flyback_users =3D=3D 1)) ||
+=09   (!enable && (--ctrl->flyback_users =3D=3D 0))) {
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09WCD9XXX_A_ANA_RX_VNEG_EN_MASK,
+=09=09=09=09enable << WCD9XXX_A_ANA_RX_VNEG_EN_SHIFT);
+=09=09/* 100usec delay is needed as per HW requirement */
+=09=09usleep_range(100, 110);
+=09}
+=09/*
+=09 * 500us sleep is required after flyback enable/disable
+=09 * as per HW requirement
+=09 */
+=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
+}
+
+static inline void wcd_clsh_set_gain_path(struct wcd_clsh_ctrl *ctrl, int =
mode)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+=09int val =3D 0;
+
+=09switch (mode) {
+=09case CLS_H_NORMAL:
+=09case CLS_AB:
+=09=09val =3D WCD9XXX_HPH_CONST_SEL_BYPASS;
+=09=09break;
+=09case CLS_H_HIFI:
+=09=09val =3D WCD9XXX_HPH_CONST_SEL_HQ_PATH;
+=09=09break;
+=09case CLS_H_LP:
+=09=09val =3D WCD9XXX_HPH_CONST_SEL_LP_PATH;
+=09=09break;
+=09}
+
+=09snd_soc_component_update_bits(comp, WCD9XXX_HPH_L_EN,
+=09=09=09=09=09WCD9XXX_HPH_CONST_SEL_L_MASK,
+=09=09=09=09=09val);
+
+=09snd_soc_component_update_bits(comp, WCD9XXX_HPH_R_EN,
+=09=09=09=09=09WCD9XXX_HPH_CONST_SEL_L_MASK,
+=09=09=09=09=09val);
+}
+
+static inline void wcd_clsh_v2_set_hph_mode(struct snd_soc_component *comp=
,
+=09=09=09=09=09    int mode)
+{
+=09int val =3D 0, gain =3D 0, res_val;
+=09int ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
+
+=09res_val =3D WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_0KOHM;
+=09switch (mode) {
+=09case CLS_H_NORMAL:
+=09=09res_val =3D WCD9XXX_CLASSH_CTRL_VCL_VREF_FILT_R_50KOHM;
+=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_NORMAL;
+=09=09gain =3D DAC_GAIN_0DB;
+=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
+=09=09break;
+=09case CLS_AB:
+=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_NORMAL;
+=09=09gain =3D DAC_GAIN_0DB;
+=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
+=09=09break;
+=09case CLS_H_HIFI:
+=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_UHQA;
+=09=09gain =3D DAC_GAIN_M0P2DB;
+=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_50MA;
+=09=09break;
+=09case CLS_H_LP:
+=09=09val =3D WCD9XXX_A_ANA_HPH_PWR_LEVEL_LP;
+=09=09ipeak =3D WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_30MA;
+=09=09break;
+=09}
+
+=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_HPH,
+=09=09=09=09=09WCD9XXX_A_ANA_HPH_PWR_LEVEL_MASK, val);
+=09snd_soc_component_update_bits(comp, WCD9XXX_CLASSH_CTRL_VCL_2,
+=09=09=09=09WCD9XXX_CLASSH_CTRL_VCL_2_VREF_FILT_1_MASK,
+=09=09=09=09res_val);
+=09if (mode !=3D CLS_H_LP)
+=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09WCD9XXX_HPH_REFBUFF_UHQA_CTL,
+=09=09=09=09=09WCD9XXX_HPH_REFBUFF_UHQA_GAIN_MASK,
+=09=09=09=09=09gain);
+=09snd_soc_component_update_bits(comp, WCD9XXX_CLASSH_CTRL_CCL_1,
+=09=09=09=09WCD9XXX_CLASSH_CTRL_CCL_1_DELTA_IPEAK_MASK,
+=09=09=09=09ipeak);
+}
+
+static inline void wcd_clsh_v3_set_hph_mode(struct snd_soc_component *comp=
onent,
+=09=09=09=09=09    int mode)
+{
+=09u8 val;
+
+=09switch (mode) {
+=09case CLS_H_NORMAL:
+=09=09val =3D 0x00;
+=09=09break;
+=09case CLS_AB:
+=09case CLS_H_ULP:
+=09=09val =3D 0x0C;
+=09=09break;
+=09case CLS_AB_HIFI:
+=09case CLS_H_HIFI:
+=09=09val =3D 0x08;
+=09=09break;
+=09case CLS_H_LP:
+=09case CLS_H_LOHIFI:
+=09case CLS_AB_LP:
+=09case CLS_AB_LOHIFI:
+=09=09val =3D 0x04;
+=09=09break;
+=09default:
+=09=09dev_err(component->dev, "%s:Invalid mode %d\n", __func__, mode);
+=09=09return;
+=09}
+
+=09snd_soc_component_update_bits(component, WCD9XXX_ANA_HPH, 0x0C, val);
+}
+
+static inline void wcd_clsh_set_hph_mode(struct wcd_clsh_ctrl *ctrl, int m=
ode)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09if (ctrl->codec_version >=3D WCD937X)
+=09=09wcd_clsh_v3_set_hph_mode(comp, mode);
+=09else
+=09=09wcd_clsh_v2_set_hph_mode(comp, mode);
+
+}
+
+static inline void wcd_clsh_set_flyback_current(struct snd_soc_component *=
comp,
+=09=09=09=09=09=09int mode)
+{
+
+=09snd_soc_component_update_bits(comp, WCD9XXX_RX_BIAS_FLYB_BUFF,
+=09=09=09=09WCD9XXX_RX_BIAS_FLYB_VPOS_5_UA_MASK, 0x0A);
+=09snd_soc_component_update_bits(comp, WCD9XXX_RX_BIAS_FLYB_BUFF,
+=09=09=09=09WCD9XXX_RX_BIAS_FLYB_VNEG_5_UA_MASK, 0x0A);
+=09/* Sleep needed to avoid click and pop as per HW requirement */
+=09usleep_range(100, 110);
+}
+
+static inline void wcd_clsh_set_buck_regulator_mode(struct snd_soc_compone=
nt *comp,
+=09=09=09=09=09=09    int mode)
+{
+=09if (mode =3D=3D CLS_AB)
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_MASK,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_AB);
+=09else
+=09=09snd_soc_component_update_bits(comp, WCD9XXX_A_ANA_RX_SUPPLIES,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_MASK,
+=09=09=09=09=09WCD9XXX_A_ANA_RX_REGULATOR_MODE_CLS_H);
+}
+
+static inline void wcd_clsh_v3_set_buck_regulator_mode(struct snd_soc_comp=
onent *component,
+=09=09=09=09=09=09       int mode)
+{
+=09snd_soc_component_update_bits(component, WCD9XXX_ANA_RX_SUPPLIES,
+=09=09=09    0x02, 0x00);
+}
+
+static inline void wcd_clsh_v3_set_flyback_mode(struct snd_soc_component *=
component,
+=09=09=09=09=09=09int mode)
+{
+=09if (mode =3D=3D CLS_H_HIFI || mode =3D=3D CLS_H_LOHIFI ||
+=09    mode =3D=3D CLS_AB_HIFI || mode =3D=3D CLS_AB_LOHIFI) {
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
+=09=09=09=090x04, 0x04);
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_FLYBACK_VNEG_CTRL_4,
+=09=09=09=090xF0, 0x80);
+=09} else {
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
+=09=09=09=090x04, 0x00); /* set to Default */
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_FLYBACK_VNEG_CTRL_4,
+=09=09=09=090xF0, 0x70);
+=09}
+}
+
+static inline void wcd_clsh_v3_force_iq_ctl(struct snd_soc_component *comp=
onent,
+=09=09=09=09=09    int mode, bool enable)
+{
+=09if (enable) {
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_FLYBACK_VNEGDAC_CTRL_2,
+=09=09=09=090xE0, 0xA0);
+=09=09/* 100usec delay is needed as per HW requirement */
+=09=09usleep_range(100, 110);
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_CLASSH_MODE_3,
+=09=09=09=090x02, 0x02);
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_CLASSH_MODE_2,
+=09=09=09=090xFF, 0x1C);
+=09=09if (mode =3D=3D CLS_H_LOHIFI || mode =3D=3D CLS_AB_LOHIFI) {
+=09=09=09snd_soc_component_update_bits(component,
+=09=09=09=09=09WCD9XXX_HPH_NEW_INT_PA_MISC2,
+=09=09=09=09=090x20, 0x20);
+=09=09=09snd_soc_component_update_bits(component,
+=09=09=09=09=09WCD9XXX_RX_BIAS_HPH_LOWPOWER,
+=09=09=09=09=090xF0, 0xC0);
+=09=09=09snd_soc_component_update_bits(component,
+=09=09=09=09=09WCD9XXX_HPH_PA_CTL1,
+=09=09=09=09=090x0E, 0x02);
+=09=09}
+=09} else {
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_HPH_NEW_INT_PA_MISC2,
+=09=09=09=090x20, 0x00);
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_RX_BIAS_HPH_LOWPOWER,
+=09=09=09=090xF0, 0x80);
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_HPH_PA_CTL1,
+=09=09=09=090x0E, 0x06);
+=09}
+}
+
+static inline void wcd_clsh_v3_flyback_ctrl(struct snd_soc_component *comp=
onent,
+=09=09=09=09=09    struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09    int mode,
+=09=09=09=09=09    bool enable)
+{
+=09/* enable/disable flyback */
+=09if ((enable && (++ctrl->flyback_users =3D=3D 1)) ||
+=09   (!enable && (--ctrl->flyback_users =3D=3D 0))) {
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_FLYBACK_VNEG_CTRL_1,
+=09=09=09=090xE0, 0xE0);
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_ANA_RX_SUPPLIES,
+=09=09=09=09(1 << 6), (enable << 6));
+=09=09/*
+=09=09 * 100us sleep is required after flyback enable/disable
+=09=09 * as per HW requirement
+=09=09 */
+=09=09usleep_range(100, 110);
+=09=09snd_soc_component_update_bits(component,
+=09=09=09=09WCD9XXX_FLYBACK_VNEGDAC_CTRL_2,
+=09=09=09=090xE0, 0xE0);
+=09=09/* 500usec delay is needed as per HW requirement */
+=09=09usleep_range(500, 500 + WCD_USLEEP_RANGE);
+=09}
+}
+
+static inline void wcd_clsh_v3_set_flyback_current(struct snd_soc_componen=
t *component,
+=09=09=09=09=09=09   int mode)
+{
+=09snd_soc_component_update_bits(component, WCD9XXX_V3_RX_BIAS_FLYB_BUFF,
+=09=09=09=090x0F, 0x0A);
+=09snd_soc_component_update_bits(component, WCD9XXX_V3_RX_BIAS_FLYB_BUFF,
+=09=09=09=090xF0, 0xA0);
+=09/* Sleep needed to avoid click and pop as per HW requirement */
+=09usleep_range(100, 110);
+}
+
+static inline void wcd_clsh_v3_state_aux(struct wcd_clsh_ctrl *ctrl, int r=
eq_state,
+=09=09=09=09=09 bool is_enable, int mode)
+{
+=09struct snd_soc_component *component =3D ctrl->comp;
+
+=09if (is_enable) {
+=09=09wcd_clsh_v3_set_buck_mode(component, mode);
+=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
+=09=09wcd_clsh_v3_set_flyback_current(component, mode);
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
+=09} else {
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, false);
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, false);
+=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
+=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
+=09}
+}
+
+static inline void wcd_clsh_state_lo(struct wcd_clsh_ctrl *ctrl, int req_s=
tate,
+=09=09=09=09     bool is_enable, int mode)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09if (mode !=3D CLS_AB) {
+=09=09dev_err(comp->dev, "%s: LO cannot be in this mode: %d\n",
+=09=09=09__func__, mode);
+=09=09return;
+=09}
+
+=09if (is_enable) {
+=09=09wcd_clsh_set_buck_regulator_mode(comp, mode);
+=09=09wcd_clsh_set_buck_mode(comp, mode);
+=09=09wcd_clsh_set_flyback_mode(comp, mode);
+=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
+=09=09wcd_clsh_set_flyback_current(comp, mode);
+=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
+=09} else {
+=09=09wcd_clsh_buck_ctrl(ctrl, mode, false);
+=09=09wcd_clsh_flyback_ctrl(ctrl, mode, false);
+=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
+=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
+=09=09wcd_clsh_set_buck_regulator_mode(comp, CLS_H_NORMAL);
+=09}
+}
+
+static inline void wcd_clsh_v3_state_hph_r(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09   int req_state,
+=09=09=09=09=09   bool is_enable, int mode)
+{
+=09struct snd_soc_component *component =3D ctrl->comp;
+
+=09if (mode =3D=3D CLS_H_NORMAL) {
+=09=09dev_dbg(component->dev, "%s: Normal mode not applicable for hph_r\n"=
,
+=09=09=09__func__);
+=09=09return;
+=09}
+
+=09if (is_enable) {
+=09=09wcd_clsh_v3_set_buck_regulator_mode(component, mode);
+=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
+=09=09wcd_clsh_v3_force_iq_ctl(component, mode, true);
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
+=09=09wcd_clsh_v3_set_flyback_current(component, mode);
+=09=09wcd_clsh_v3_set_buck_mode(component, mode);
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
+=09=09wcd_clsh_v3_set_hph_mode(component, mode);
+=09} else {
+=09=09wcd_clsh_v3_set_hph_mode(component, CLS_H_NORMAL);
+
+=09=09/* buck and flyback set to default mode and disable */
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_force_iq_ctl(component, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
+=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
+=09}
+}
+
+static inline void wcd_clsh_state_hph_r(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09int req_state, bool is_enable, int mode)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09if (mode =3D=3D CLS_H_NORMAL) {
+=09=09dev_err(comp->dev, "%s: Normal mode not applicable for hph_r\n",
+=09=09=09__func__);
+=09=09return;
+=09}
+
+=09if (is_enable) {
+=09=09if (mode !=3D CLS_AB) {
+=09=09=09wcd_enable_clsh_block(ctrl, true);
+=09=09=09/*
+=09=09=09 * These K1 values depend on the Headphone Impedance
+=09=09=09 * For now it is assumed to be 16 ohm
+=09=09=09 */
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB_COEF_MASK,
+=09=09=09=09=090x00);
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB_COEF_MASK,
+=09=09=09=09=090xC0);
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX2_RX_PATH_CFG0,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE);
+=09=09}
+=09=09wcd_clsh_set_buck_regulator_mode(comp, mode);
+=09=09wcd_clsh_set_flyback_mode(comp, mode);
+=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
+=09=09wcd_clsh_set_flyback_current(comp, mode);
+=09=09wcd_clsh_set_buck_mode(comp, mode);
+=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
+=09=09wcd_clsh_v2_set_hph_mode(comp, mode);
+=09=09wcd_clsh_set_gain_path(ctrl, mode);
+=09} else {
+=09=09wcd_clsh_v2_set_hph_mode(comp, CLS_H_NORMAL);
+
+=09=09if (mode !=3D CLS_AB) {
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX2_RX_PATH_CFG0,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE);
+=09=09=09wcd_enable_clsh_block(ctrl, false);
+=09=09}
+=09=09/* buck and flyback set to default mode and disable */
+=09=09wcd_clsh_buck_ctrl(ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_flyback_ctrl(ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
+=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
+=09=09wcd_clsh_set_buck_regulator_mode(comp, CLS_H_NORMAL);
+=09}
+}
+
+static inline void wcd_clsh_v3_state_hph_l(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09   int req_state, bool is_enable,
+=09=09=09=09=09   int mode)
+{
+=09struct snd_soc_component *component =3D ctrl->comp;
+
+=09if (mode =3D=3D CLS_H_NORMAL) {
+=09=09dev_dbg(component->dev, "%s: Normal mode not applicable for hph_l\n"=
,
+=09=09=09__func__);
+=09=09return;
+=09}
+
+=09if (is_enable) {
+=09=09wcd_clsh_v3_set_buck_regulator_mode(component, mode);
+=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
+=09=09wcd_clsh_v3_force_iq_ctl(component, mode, true);
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
+=09=09wcd_clsh_v3_set_flyback_current(component, mode);
+=09=09wcd_clsh_v3_set_buck_mode(component, mode);
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
+=09=09wcd_clsh_v3_set_hph_mode(component, mode);
+=09} else {
+=09=09wcd_clsh_v3_set_hph_mode(component, CLS_H_NORMAL);
+
+=09=09/* set buck and flyback to Default Mode */
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_force_iq_ctl(component, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
+=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
+=09}
+}
+
+static inline void wcd_clsh_state_hph_l(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09int req_state, bool is_enable, int mode)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09if (mode =3D=3D CLS_H_NORMAL) {
+=09=09dev_err(comp->dev, "%s: Normal mode not applicable for hph_l\n",
+=09=09=09__func__);
+=09=09return;
+=09}
+
+=09if (is_enable) {
+=09=09if (mode !=3D CLS_AB) {
+=09=09=09wcd_enable_clsh_block(ctrl, true);
+=09=09=09/*
+=09=09=09 * These K1 values depend on the Headphone Impedance
+=09=09=09 * For now it is assumed to be 16 ohm
+=09=09=09 */
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_MSB_COEF_MASK,
+=09=09=09=09=090x00);
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB,
+=09=09=09=09=09WCD9XXX_A_CDC_CLSH_K1_LSB_COEF_MASK,
+=09=09=09=09=090xC0);
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX1_RX_PATH_CFG0,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE);
+=09=09}
+=09=09wcd_clsh_set_buck_regulator_mode(comp, mode);
+=09=09wcd_clsh_set_flyback_mode(comp, mode);
+=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
+=09=09wcd_clsh_set_flyback_current(comp, mode);
+=09=09wcd_clsh_set_buck_mode(comp, mode);
+=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
+=09=09wcd_clsh_v2_set_hph_mode(comp, mode);
+=09=09wcd_clsh_set_gain_path(ctrl, mode);
+=09} else {
+=09=09wcd_clsh_v2_set_hph_mode(comp, CLS_H_NORMAL);
+
+=09=09if (mode !=3D CLS_AB) {
+=09=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX1_RX_PATH_CFG0,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
+=09=09=09=09=09    WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE);
+=09=09=09wcd_enable_clsh_block(ctrl, false);
+=09=09}
+=09=09/* set buck and flyback to Default Mode */
+=09=09wcd_clsh_buck_ctrl(ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_flyback_ctrl(ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
+=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
+=09=09wcd_clsh_set_buck_regulator_mode(comp, CLS_H_NORMAL);
+=09}
+}
+
+static inline void wcd_clsh_v3_state_ear(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09 int req_state, bool is_enable,
+=09=09=09=09=09 int mode)
+{
+=09struct snd_soc_component *component =3D ctrl->comp;
+
+=09if (is_enable) {
+=09=09wcd_clsh_v3_set_buck_regulator_mode(component, mode);
+=09=09wcd_clsh_v3_set_flyback_mode(component, mode);
+=09=09wcd_clsh_v3_force_iq_ctl(component, mode, true);
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, mode, true);
+=09=09wcd_clsh_v3_set_flyback_current(component, mode);
+=09=09wcd_clsh_v3_set_buck_mode(component, mode);
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, mode, true);
+=09=09wcd_clsh_v3_set_hph_mode(component, mode);
+=09} else {
+=09=09wcd_clsh_v3_set_hph_mode(component, CLS_H_NORMAL);
+
+=09=09/* set buck and flyback to Default Mode */
+=09=09wcd_clsh_v3_flyback_ctrl(component, ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_buck_ctrl(component, ctrl, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_force_iq_ctl(component, CLS_H_NORMAL, false);
+=09=09wcd_clsh_v3_set_flyback_mode(component, CLS_H_NORMAL);
+=09=09wcd_clsh_v3_set_buck_mode(component, CLS_H_NORMAL);
+=09}
+}
+
+static inline void wcd_clsh_state_ear(struct wcd_clsh_ctrl *ctrl, int req_=
state,
+=09=09=09=09      bool is_enable, int mode)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09if (mode !=3D CLS_H_NORMAL) {
+=09=09dev_err(comp->dev, "%s: mode: %d cannot be used for EAR\n",
+=09=09=09__func__, mode);
+=09=09return;
+=09}
+
+=09if (is_enable) {
+=09=09wcd_enable_clsh_block(ctrl, true);
+=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09WCD9XXX_A_CDC_RX0_RX_PATH_CFG0,
+=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
+=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_ENABLE);
+=09=09wcd_clsh_set_buck_mode(comp, mode);
+=09=09wcd_clsh_set_flyback_mode(comp, mode);
+=09=09wcd_clsh_flyback_ctrl(ctrl, mode, true);
+=09=09wcd_clsh_set_flyback_current(comp, mode);
+=09=09wcd_clsh_buck_ctrl(ctrl, mode, true);
+=09} else {
+=09=09snd_soc_component_update_bits(comp,
+=09=09=09=09=09WCD9XXX_A_CDC_RX0_RX_PATH_CFG0,
+=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_EN_MASK,
+=09=09=09=09=09WCD9XXX_A_CDC_RX_PATH_CLSH_DISABLE);
+=09=09wcd_enable_clsh_block(ctrl, false);
+=09=09wcd_clsh_buck_ctrl(ctrl, mode, false);
+=09=09wcd_clsh_flyback_ctrl(ctrl, mode, false);
+=09=09wcd_clsh_set_flyback_mode(comp, CLS_H_NORMAL);
+=09=09wcd_clsh_set_buck_mode(comp, CLS_H_NORMAL);
+=09}
+}
+
+static inline int _wcd_clsh_ctrl_set_state(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09   int req_state, bool is_enable,
+=09=09=09=09=09   int mode)
+{
+=09switch (req_state) {
+=09case WCD_CLSH_STATE_EAR:
+=09=09if (ctrl->codec_version >=3D WCD937X)
+=09=09=09wcd_clsh_v3_state_ear(ctrl, req_state, is_enable, mode);
+=09=09else
+=09=09=09wcd_clsh_state_ear(ctrl, req_state, is_enable, mode);
+=09=09break;
+=09case WCD_CLSH_STATE_HPHL:
+=09=09if (ctrl->codec_version >=3D WCD937X)
+=09=09=09wcd_clsh_v3_state_hph_l(ctrl, req_state, is_enable, mode);
+=09=09else
+=09=09=09wcd_clsh_state_hph_l(ctrl, req_state, is_enable, mode);
+=09=09break;
+=09case WCD_CLSH_STATE_HPHR:
+=09=09if (ctrl->codec_version >=3D WCD937X)
+=09=09=09wcd_clsh_v3_state_hph_r(ctrl, req_state, is_enable, mode);
+=09=09else
+=09=09=09wcd_clsh_state_hph_r(ctrl, req_state, is_enable, mode);
+=09=09break;
+=09case WCD_CLSH_STATE_LO:
+=09=09if (ctrl->codec_version < WCD937X)
+=09=09=09wcd_clsh_state_lo(ctrl, req_state, is_enable, mode);
+=09=09break;
+=09case WCD_CLSH_STATE_AUX:
+=09=09if (ctrl->codec_version >=3D WCD937X)
+=09=09=09wcd_clsh_v3_state_aux(ctrl, req_state, is_enable, mode);
+=09=09break;
+=09default:
+=09=09break;
+=09}
+
+=09return 0;
+}
+
+/*
+ * Function: wcd_clsh_is_state_valid
+ * Params: state
+ * Description:
+ * Provides information on valid states of Class H configuration
+ */
+static inline bool wcd_clsh_is_state_valid(int state)
+{
+=09switch (state) {
+=09case WCD_CLSH_STATE_IDLE:
+=09case WCD_CLSH_STATE_EAR:
+=09case WCD_CLSH_STATE_HPHL:
+=09case WCD_CLSH_STATE_HPHR:
+=09case WCD_CLSH_STATE_LO:
+=09case WCD_CLSH_STATE_AUX:
+=09=09return true;
+=09default:
+=09=09return false;
+=09};
+}
+
+/*
+ * Function: wcd_clsh_fsm
+ * Params: ctrl, req_state, req_type, clsh_event
+ * Description:
+ * This function handles PRE DAC and POST DAC conditions of different devi=
ces
+ * and updates class H configuration of different combination of devices
+ * based on validity of their states. ctrl will contain current
+ * class h state information
+ */
+static inline int wcd_clsh_ctrl_set_state(struct wcd_clsh_ctrl *ctrl,
+=09=09=09=09=09  enum wcd_clsh_event clsh_event,
+=09=09=09=09=09  int nstate,
+=09=09=09=09=09  enum wcd_clsh_mode mode)
+{
+=09struct snd_soc_component *comp =3D ctrl->comp;
+
+=09if (nstate =3D=3D ctrl->state)
+=09=09return 0;
+
+=09if (!wcd_clsh_is_state_valid(nstate)) {
+=09=09dev_err(comp->dev, "Class-H not a valid new state:\n");
+=09=09return -EINVAL;
+=09}
+
+=09switch (clsh_event) {
+=09case WCD_CLSH_EVENT_PRE_DAC:
+=09=09_wcd_clsh_ctrl_set_state(ctrl, nstate, CLSH_REQ_ENABLE, mode);
+=09=09break;
+=09case WCD_CLSH_EVENT_POST_PA:
+=09=09_wcd_clsh_ctrl_set_state(ctrl, nstate, CLSH_REQ_DISABLE, mode);
+=09=09break;
+=09}
+
+=09ctrl->state =3D nstate;
+=09ctrl->mode =3D mode;
+
+=09return 0;
+}
+
+static inline int wcd_clsh_ctrl_get_state(struct wcd_clsh_ctrl *ctrl)
+{
+=09return ctrl->state;
+}
+
+static inline struct wcd_clsh_ctrl *wcd_clsh_ctrl_alloc(struct snd_soc_com=
ponent *comp,
+=09=09=09=09=09=09=09int version)
+{
+=09struct wcd_clsh_ctrl *ctrl;
+
+=09ctrl =3D kzalloc(sizeof(*ctrl), GFP_KERNEL);
+=09if (!ctrl)
+=09=09return ERR_PTR(-ENOMEM);
+
+=09ctrl->state =3D WCD_CLSH_STATE_IDLE;
+=09ctrl->comp =3D comp;
+=09ctrl->codec_version =3D version;
+
+=09return ctrl;
+}
+
+static inline void wcd_clsh_ctrl_free(struct wcd_clsh_ctrl *ctrl)
+{
+=09kfree(ctrl);
+}

 #endif /* _WCD_CLSH_V2_H_ */
--
2.38.1


