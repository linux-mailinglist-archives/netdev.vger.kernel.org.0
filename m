Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5287B6311AF
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbiKSXE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbiKSXE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:04:58 -0500
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2456C13DC1;
        Sat, 19 Nov 2022 15:04:56 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:04:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899092; x=1669158292;
        bh=ievoQBFWTfCyBGr8jW3lYbJQQvItYo3e13YnLNOYLHM=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=e9J7IW5S3DnhO59r0K0Emw2L2P685+iyrKvjbkKrMS/2hVMWSVut0lLR85o6K7/1Q
         MLZ6eDVmohh8v7RCfD4GwHTAyOUZQlc2QphVOWui+pU6MQW7Aq8iCyonR5/7z9JJR/
         iKA893NOj09UdoDSwEDZxFU4VaztPwqV0mgdaqzkG1akQk7iOXHnNsT2my4xKQbB/x
         9GPdJuBViZhix+PR4NpUZpXsOLBcezq6c2Z2jxPABku56M3fwka3yj/2vudGLTFlZY
         abmrXk16Qhrz50WVYjw3r453UIqHPJ/pkWBxE+3W46ENx62GqSWCo139KesL+NDB9E
         CrJ0cOSx2zjlw==
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
Subject: [PATCH 02/18] drm/bridge: imx: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-3-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

With CONFIG_DRM_IMX8QM_LDB=3Dm and CONFIG_DRM_IMX8QXP_LDB=3Dy (or vice
versa), imx-ldb-helper.o is linked to a module and also to vmlinux
even though the expected CFLAGS are different between builtins and
modules.

This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
Fixing mixed module-builtin objects").

Turn helpers in imx-ldb-helper.c into inline functions.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-and-tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/gpu/drm/bridge/imx/Makefile         |   4 +-
 drivers/gpu/drm/bridge/imx/imx-ldb-helper.c | 221 --------------------
 drivers/gpu/drm/bridge/imx/imx-ldb-helper.h | 213 +++++++++++++++++--
 3 files changed, 197 insertions(+), 241 deletions(-)
 delete mode 100644 drivers/gpu/drm/bridge/imx/imx-ldb-helper.c

diff --git a/drivers/gpu/drm/bridge/imx/Makefile b/drivers/gpu/drm/bridge/i=
mx/Makefile
index aa90ec8d5433..64b93009376a 100644
--- a/drivers/gpu/drm/bridge/imx/Makefile
+++ b/drivers/gpu/drm/bridge/imx/Makefile
@@ -1,7 +1,7 @@
-imx8qm-ldb-objs :=3D imx-ldb-helper.o imx8qm-ldb-drv.o
+imx8qm-ldb-objs :=3D imx8qm-ldb-drv.o
 obj-$(CONFIG_DRM_IMX8QM_LDB) +=3D imx8qm-ldb.o

-imx8qxp-ldb-objs :=3D imx-ldb-helper.o imx8qxp-ldb-drv.o
+imx8qxp-ldb-objs :=3D imx8qxp-ldb-drv.o
 obj-$(CONFIG_DRM_IMX8QXP_LDB) +=3D imx8qxp-ldb.o

 obj-$(CONFIG_DRM_IMX8QXP_PIXEL_COMBINER) +=3D imx8qxp-pixel-combiner.o
diff --git a/drivers/gpu/drm/bridge/imx/imx-ldb-helper.c b/drivers/gpu/drm/=
bridge/imx/imx-ldb-helper.c
deleted file mode 100644
index 7338b84bc83d..000000000000
--- a/drivers/gpu/drm/bridge/imx/imx-ldb-helper.c
+++ /dev/null
@@ -1,221 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (C) 2012 Sascha Hauer, Pengutronix
- * Copyright 2019,2020,2022 NXP
- */
-
-#include <linux/media-bus-format.h>
-#include <linux/mfd/syscon.h>
-#include <linux/of.h>
-#include <linux/regmap.h>
-
-#include <drm/drm_bridge.h>
-#include <drm/drm_of.h>
-#include <drm/drm_print.h>
-
-#include "imx-ldb-helper.h"
-
-bool ldb_channel_is_single_link(struct ldb_channel *ldb_ch)
-{
-=09return ldb_ch->link_type =3D=3D LDB_CH_SINGLE_LINK;
-}
-
-bool ldb_channel_is_split_link(struct ldb_channel *ldb_ch)
-{
-=09return ldb_ch->link_type =3D=3D LDB_CH_DUAL_LINK_EVEN_ODD_PIXELS ||
-=09       ldb_ch->link_type =3D=3D LDB_CH_DUAL_LINK_ODD_EVEN_PIXELS;
-}
-
-int ldb_bridge_atomic_check_helper(struct drm_bridge *bridge,
-=09=09=09=09   struct drm_bridge_state *bridge_state,
-=09=09=09=09   struct drm_crtc_state *crtc_state,
-=09=09=09=09   struct drm_connector_state *conn_state)
-{
-=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
-
-=09ldb_ch->in_bus_format =3D bridge_state->input_bus_cfg.format;
-=09ldb_ch->out_bus_format =3D bridge_state->output_bus_cfg.format;
-
-=09return 0;
-}
-
-void ldb_bridge_mode_set_helper(struct drm_bridge *bridge,
-=09=09=09=09const struct drm_display_mode *mode,
-=09=09=09=09const struct drm_display_mode *adjusted_mode)
-{
-=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
-=09struct ldb *ldb =3D ldb_ch->ldb;
-=09bool is_split =3D ldb_channel_is_split_link(ldb_ch);
-
-=09if (is_split)
-=09=09ldb->ldb_ctrl |=3D LDB_SPLIT_MODE_EN;
-
-=09switch (ldb_ch->out_bus_format) {
-=09case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG:
-=09=09break;
-=09case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG:
-=09=09if (ldb_ch->chno =3D=3D 0 || is_split)
-=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH0_24;
-=09=09if (ldb_ch->chno =3D=3D 1 || is_split)
-=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH1_24;
-=09=09break;
-=09case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA:
-=09=09if (ldb_ch->chno =3D=3D 0 || is_split)
-=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH0_24 |
-=09=09=09=09=09 LDB_BIT_MAP_CH0_JEIDA;
-=09=09if (ldb_ch->chno =3D=3D 1 || is_split)
-=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH1_24 |
-=09=09=09=09=09 LDB_BIT_MAP_CH1_JEIDA;
-=09=09break;
-=09}
-}
-
-void ldb_bridge_enable_helper(struct drm_bridge *bridge)
-{
-=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
-=09struct ldb *ldb =3D ldb_ch->ldb;
-
-=09/*
-=09 * Platform specific bridge drivers should set ldb_ctrl properly
-=09 * for the enablement, so just write the ctrl_reg here.
-=09 */
-=09regmap_write(ldb->regmap, ldb->ctrl_reg, ldb->ldb_ctrl);
-}
-
-void ldb_bridge_disable_helper(struct drm_bridge *bridge)
-{
-=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
-=09struct ldb *ldb =3D ldb_ch->ldb;
-=09bool is_split =3D ldb_channel_is_split_link(ldb_ch);
-
-=09if (ldb_ch->chno =3D=3D 0 || is_split)
-=09=09ldb->ldb_ctrl &=3D ~LDB_CH0_MODE_EN_MASK;
-=09if (ldb_ch->chno =3D=3D 1 || is_split)
-=09=09ldb->ldb_ctrl &=3D ~LDB_CH1_MODE_EN_MASK;
-
-=09regmap_write(ldb->regmap, ldb->ctrl_reg, ldb->ldb_ctrl);
-}
-
-int ldb_bridge_attach_helper(struct drm_bridge *bridge,
-=09=09=09     enum drm_bridge_attach_flags flags)
-{
-=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
-=09struct ldb *ldb =3D ldb_ch->ldb;
-
-=09if (!(flags & DRM_BRIDGE_ATTACH_NO_CONNECTOR)) {
-=09=09DRM_DEV_ERROR(ldb->dev,
-=09=09=09      "do not support creating a drm_connector\n");
-=09=09return -EINVAL;
-=09}
-
-=09if (!bridge->encoder) {
-=09=09DRM_DEV_ERROR(ldb->dev, "missing encoder\n");
-=09=09return -ENODEV;
-=09}
-
-=09return drm_bridge_attach(bridge->encoder,
-=09=09=09=09ldb_ch->next_bridge, bridge,
-=09=09=09=09DRM_BRIDGE_ATTACH_NO_CONNECTOR);
-}
-
-int ldb_init_helper(struct ldb *ldb)
-{
-=09struct device *dev =3D ldb->dev;
-=09struct device_node *np =3D dev->of_node;
-=09struct device_node *child;
-=09int ret;
-=09u32 i;
-
-=09ldb->regmap =3D syscon_node_to_regmap(np->parent);
-=09if (IS_ERR(ldb->regmap)) {
-=09=09ret =3D PTR_ERR(ldb->regmap);
-=09=09if (ret !=3D -EPROBE_DEFER)
-=09=09=09DRM_DEV_ERROR(dev, "failed to get regmap: %d\n", ret);
-=09=09return ret;
-=09}
-
-=09for_each_available_child_of_node(np, child) {
-=09=09struct ldb_channel *ldb_ch;
-
-=09=09ret =3D of_property_read_u32(child, "reg", &i);
-=09=09if (ret || i > MAX_LDB_CHAN_NUM - 1) {
-=09=09=09ret =3D -EINVAL;
-=09=09=09DRM_DEV_ERROR(dev,
-=09=09=09=09      "invalid channel node address: %u\n", i);
-=09=09=09of_node_put(child);
-=09=09=09return ret;
-=09=09}
-
-=09=09ldb_ch =3D ldb->channel[i];
-=09=09ldb_ch->ldb =3D ldb;
-=09=09ldb_ch->chno =3D i;
-=09=09ldb_ch->is_available =3D true;
-=09=09ldb_ch->np =3D child;
-
-=09=09ldb->available_ch_cnt++;
-=09}
-
-=09return 0;
-}
-
-int ldb_find_next_bridge_helper(struct ldb *ldb)
-{
-=09struct device *dev =3D ldb->dev;
-=09struct ldb_channel *ldb_ch;
-=09int ret, i;
-
-=09for (i =3D 0; i < MAX_LDB_CHAN_NUM; i++) {
-=09=09ldb_ch =3D ldb->channel[i];
-
-=09=09if (!ldb_ch->is_available)
-=09=09=09continue;
-
-=09=09ldb_ch->next_bridge =3D devm_drm_of_get_bridge(dev, ldb_ch->np,
-=09=09=09=09=09=09=09     1, 0);
-=09=09if (IS_ERR(ldb_ch->next_bridge)) {
-=09=09=09ret =3D PTR_ERR(ldb_ch->next_bridge);
-=09=09=09if (ret !=3D -EPROBE_DEFER)
-=09=09=09=09DRM_DEV_ERROR(dev,
-=09=09=09=09=09      "failed to get next bridge: %d\n",
-=09=09=09=09=09      ret);
-=09=09=09return ret;
-=09=09}
-=09}
-
-=09return 0;
-}
-
-void ldb_add_bridge_helper(struct ldb *ldb,
-=09=09=09   const struct drm_bridge_funcs *bridge_funcs)
-{
-=09struct ldb_channel *ldb_ch;
-=09int i;
-
-=09for (i =3D 0; i < MAX_LDB_CHAN_NUM; i++) {
-=09=09ldb_ch =3D ldb->channel[i];
-
-=09=09if (!ldb_ch->is_available)
-=09=09=09continue;
-
-=09=09ldb_ch->bridge.driver_private =3D ldb_ch;
-=09=09ldb_ch->bridge.funcs =3D bridge_funcs;
-=09=09ldb_ch->bridge.of_node =3D ldb_ch->np;
-
-=09=09drm_bridge_add(&ldb_ch->bridge);
-=09}
-}
-
-void ldb_remove_bridge_helper(struct ldb *ldb)
-{
-=09struct ldb_channel *ldb_ch;
-=09int i;
-
-=09for (i =3D 0; i < MAX_LDB_CHAN_NUM; i++) {
-=09=09ldb_ch =3D ldb->channel[i];
-
-=09=09if (!ldb_ch->is_available)
-=09=09=09continue;
-
-=09=09drm_bridge_remove(&ldb_ch->bridge);
-=09}
-}
diff --git a/drivers/gpu/drm/bridge/imx/imx-ldb-helper.h b/drivers/gpu/drm/=
bridge/imx/imx-ldb-helper.h
index a0a5cde27fbc..42e9b4aa8399 100644
--- a/drivers/gpu/drm/bridge/imx/imx-ldb-helper.h
+++ b/drivers/gpu/drm/bridge/imx/imx-ldb-helper.h
@@ -65,32 +65,209 @@ struct ldb {

 #define bridge_to_ldb_ch(b)=09container_of(b, struct ldb_channel, bridge)

-bool ldb_channel_is_single_link(struct ldb_channel *ldb_ch);
-bool ldb_channel_is_split_link(struct ldb_channel *ldb_ch);
+static inline bool ldb_channel_is_single_link(struct ldb_channel *ldb_ch)
+{
+=09return ldb_ch->link_type =3D=3D LDB_CH_SINGLE_LINK;
+}

-int ldb_bridge_atomic_check_helper(struct drm_bridge *bridge,
-=09=09=09=09   struct drm_bridge_state *bridge_state,
-=09=09=09=09   struct drm_crtc_state *crtc_state,
-=09=09=09=09   struct drm_connector_state *conn_state);
+static inline bool ldb_channel_is_split_link(struct ldb_channel *ldb_ch)
+{
+=09return ldb_ch->link_type =3D=3D LDB_CH_DUAL_LINK_EVEN_ODD_PIXELS ||
+=09       ldb_ch->link_type =3D=3D LDB_CH_DUAL_LINK_ODD_EVEN_PIXELS;
+}

-void ldb_bridge_mode_set_helper(struct drm_bridge *bridge,
-=09=09=09=09const struct drm_display_mode *mode,
-=09=09=09=09const struct drm_display_mode *adjusted_mode);
+static inline int ldb_bridge_atomic_check_helper(struct drm_bridge *bridge=
,
+=09=09=09=09=09=09 struct drm_bridge_state *bridge_state,
+=09=09=09=09=09=09 struct drm_crtc_state *crtc_state,
+=09=09=09=09=09=09 struct drm_connector_state *conn_state)
+{
+=09struct ldb_channel *ldb_ch =3D bridge->driver_private;

-void ldb_bridge_enable_helper(struct drm_bridge *bridge);
+=09ldb_ch->in_bus_format =3D bridge_state->input_bus_cfg.format;
+=09ldb_ch->out_bus_format =3D bridge_state->output_bus_cfg.format;

-void ldb_bridge_disable_helper(struct drm_bridge *bridge);
+=09return 0;
+}

-int ldb_bridge_attach_helper(struct drm_bridge *bridge,
-=09=09=09     enum drm_bridge_attach_flags flags);
+static inline void ldb_bridge_mode_set_helper(struct drm_bridge *bridge,
+=09=09=09=09=09      const struct drm_display_mode *mode,
+=09=09=09=09=09      const struct drm_display_mode *adjusted_mode)
+{
+=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
+=09struct ldb *ldb =3D ldb_ch->ldb;
+=09bool is_split =3D ldb_channel_is_split_link(ldb_ch);

-int ldb_init_helper(struct ldb *ldb);
+=09if (is_split)
+=09=09ldb->ldb_ctrl |=3D LDB_SPLIT_MODE_EN;

-int ldb_find_next_bridge_helper(struct ldb *ldb);
+=09switch (ldb_ch->out_bus_format) {
+=09case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG:
+=09=09break;
+=09case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG:
+=09=09if (ldb_ch->chno =3D=3D 0 || is_split)
+=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH0_24;
+=09=09if (ldb_ch->chno =3D=3D 1 || is_split)
+=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH1_24;
+=09=09break;
+=09case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA:
+=09=09if (ldb_ch->chno =3D=3D 0 || is_split)
+=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH0_24 |
+=09=09=09=09=09 LDB_BIT_MAP_CH0_JEIDA;
+=09=09if (ldb_ch->chno =3D=3D 1 || is_split)
+=09=09=09ldb->ldb_ctrl |=3D LDB_DATA_WIDTH_CH1_24 |
+=09=09=09=09=09 LDB_BIT_MAP_CH1_JEIDA;
+=09=09break;
+=09}
+}

-void ldb_add_bridge_helper(struct ldb *ldb,
-=09=09=09   const struct drm_bridge_funcs *bridge_funcs);
+static inline void ldb_bridge_enable_helper(struct drm_bridge *bridge)
+{
+=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
+=09struct ldb *ldb =3D ldb_ch->ldb;

-void ldb_remove_bridge_helper(struct ldb *ldb);
+=09/*
+=09 * Platform specific bridge drivers should set ldb_ctrl properly
+=09 * for the enablement, so just write the ctrl_reg here.
+=09 */
+=09regmap_write(ldb->regmap, ldb->ctrl_reg, ldb->ldb_ctrl);
+}
+
+static inline void ldb_bridge_disable_helper(struct drm_bridge *bridge)
+{
+=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
+=09struct ldb *ldb =3D ldb_ch->ldb;
+=09bool is_split =3D ldb_channel_is_split_link(ldb_ch);
+
+=09if (ldb_ch->chno =3D=3D 0 || is_split)
+=09=09ldb->ldb_ctrl &=3D ~LDB_CH0_MODE_EN_MASK;
+=09if (ldb_ch->chno =3D=3D 1 || is_split)
+=09=09ldb->ldb_ctrl &=3D ~LDB_CH1_MODE_EN_MASK;
+
+=09regmap_write(ldb->regmap, ldb->ctrl_reg, ldb->ldb_ctrl);
+}
+
+static inline int ldb_bridge_attach_helper(struct drm_bridge *bridge,
+=09=09=09=09=09   enum drm_bridge_attach_flags flags)
+{
+=09struct ldb_channel *ldb_ch =3D bridge->driver_private;
+=09struct ldb *ldb =3D ldb_ch->ldb;
+
+=09if (!(flags & DRM_BRIDGE_ATTACH_NO_CONNECTOR)) {
+=09=09DRM_DEV_ERROR(ldb->dev,
+=09=09=09      "do not support creating a drm_connector\n");
+=09=09return -EINVAL;
+=09}
+
+=09if (!bridge->encoder) {
+=09=09DRM_DEV_ERROR(ldb->dev, "missing encoder\n");
+=09=09return -ENODEV;
+=09}
+
+=09return drm_bridge_attach(bridge->encoder,
+=09=09=09=09ldb_ch->next_bridge, bridge,
+=09=09=09=09DRM_BRIDGE_ATTACH_NO_CONNECTOR);
+}
+
+static inline int ldb_init_helper(struct ldb *ldb)
+{
+=09struct device *dev =3D ldb->dev;
+=09struct device_node *np =3D dev->of_node;
+=09struct device_node *child;
+=09int ret;
+=09u32 i;
+
+=09ldb->regmap =3D syscon_node_to_regmap(np->parent);
+=09if (IS_ERR(ldb->regmap)) {
+=09=09ret =3D PTR_ERR(ldb->regmap);
+=09=09if (ret !=3D -EPROBE_DEFER)
+=09=09=09DRM_DEV_ERROR(dev, "failed to get regmap: %d\n", ret);
+=09=09return ret;
+=09}
+
+=09for_each_available_child_of_node(np, child) {
+=09=09struct ldb_channel *ldb_ch;
+
+=09=09ret =3D of_property_read_u32(child, "reg", &i);
+=09=09if (ret || i > MAX_LDB_CHAN_NUM - 1) {
+=09=09=09ret =3D -EINVAL;
+=09=09=09DRM_DEV_ERROR(dev,
+=09=09=09=09      "invalid channel node address: %u\n", i);
+=09=09=09of_node_put(child);
+=09=09=09return ret;
+=09=09}
+
+=09=09ldb_ch =3D ldb->channel[i];
+=09=09ldb_ch->ldb =3D ldb;
+=09=09ldb_ch->chno =3D i;
+=09=09ldb_ch->is_available =3D true;
+=09=09ldb_ch->np =3D child;
+
+=09=09ldb->available_ch_cnt++;
+=09}
+
+=09return 0;
+}
+
+static inline int ldb_find_next_bridge_helper(struct ldb *ldb)
+{
+=09struct device *dev =3D ldb->dev;
+=09struct ldb_channel *ldb_ch;
+=09int ret, i;
+
+=09for (i =3D 0; i < MAX_LDB_CHAN_NUM; i++) {
+=09=09ldb_ch =3D ldb->channel[i];
+
+=09=09if (!ldb_ch->is_available)
+=09=09=09continue;
+
+=09=09ldb_ch->next_bridge =3D devm_drm_of_get_bridge(dev, ldb_ch->np,
+=09=09=09=09=09=09=09     1, 0);
+=09=09if (IS_ERR(ldb_ch->next_bridge)) {
+=09=09=09ret =3D PTR_ERR(ldb_ch->next_bridge);
+=09=09=09if (ret !=3D -EPROBE_DEFER)
+=09=09=09=09DRM_DEV_ERROR(dev,
+=09=09=09=09=09      "failed to get next bridge: %d\n",
+=09=09=09=09=09      ret);
+=09=09=09return ret;
+=09=09}
+=09}
+
+=09return 0;
+}
+
+static inline void ldb_add_bridge_helper(struct ldb *ldb,
+=09=09=09=09=09 const struct drm_bridge_funcs *bridge_funcs)
+{
+=09struct ldb_channel *ldb_ch;
+=09int i;
+
+=09for (i =3D 0; i < MAX_LDB_CHAN_NUM; i++) {
+=09=09ldb_ch =3D ldb->channel[i];
+
+=09=09if (!ldb_ch->is_available)
+=09=09=09continue;
+
+=09=09ldb_ch->bridge.driver_private =3D ldb_ch;
+=09=09ldb_ch->bridge.funcs =3D bridge_funcs;
+=09=09ldb_ch->bridge.of_node =3D ldb_ch->np;
+
+=09=09drm_bridge_add(&ldb_ch->bridge);
+=09}
+}
+
+static inline void ldb_remove_bridge_helper(struct ldb *ldb)
+{
+=09struct ldb_channel *ldb_ch;
+=09int i;
+
+=09for (i =3D 0; i < MAX_LDB_CHAN_NUM; i++) {
+=09=09ldb_ch =3D ldb->channel[i];
+
+=09=09if (!ldb_ch->is_available)
+=09=09=09continue;
+
+=09=09drm_bridge_remove(&ldb_ch->bridge);
+=09}
+}

 #endif /* __IMX_LDB_HELPER__ */
--
2.38.1


