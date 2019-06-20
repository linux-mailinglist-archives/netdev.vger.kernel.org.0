Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA844CF6C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732111AbfFTNr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:47:57 -0400
Received: from vps.xff.cz ([195.181.215.36]:36224 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732070AbfFTNrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 09:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1561038473; bh=huDbYqisR3sxN2nAvxyMjakfXzK8aN/kVX68o7cgDVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0XljY6H4sEaHNF4Iii6TXLcdRyF49kU4mwUvtAEpTdFnoOKDO0z4RIaOYns6TmF/
         rz5fAqfqKtS+B7VxPANrvsyiR4Yd+AMbcuENAgEBiEcH+BOvwLA+NO1MeBVxvKgfpF
         kACkzZGXY0T4EEcDvvdcdB09YzPQCY4mSF0awx4A=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     Ondrej Jirman <megous@megous.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v7 5/6] drm: sun4i: Add support for enabling DDC I2C bus to sun8i_dw_hdmi glue
Date:   Thu, 20 Jun 2019 15:47:47 +0200
Message-Id: <20190620134748.17866-6-megous@megous.com>
In-Reply-To: <20190620134748.17866-1-megous@megous.com>
References: <20190620134748.17866-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Orange Pi 3 board requires enabling a voltage shifting circuit via GPIO
for the DDC bus to be usable.

Add support for hdmi-connector node's optional ddc-en-gpios property to
support this use case.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 54 +++++++++++++++++++++++++--
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h |  2 +
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index 39d8509d96a0..6733bfc9c2d6 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -98,10 +98,34 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struct drm_device *drm,
 	return crtcs;
 }
 
+static int sun8i_dw_hdmi_find_connector_pdev(struct device *dev,
+					     struct platform_device **pdev_out)
+{
+	struct platform_device *pdev;
+	struct device_node *remote;
+
+	remote = of_graph_get_remote_node(dev->of_node, 1, -1);
+	if (!remote)
+		return -ENODEV;
+
+	if (!of_device_is_compatible(remote, "hdmi-connector")) {
+		of_node_put(remote);
+		return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(remote);
+	of_node_put(remote);
+	if (!pdev)
+		return -ENODEV;
+
+	*pdev_out = pdev;
+	return 0;
+}
+
 static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 			      void *data)
 {
-	struct platform_device *pdev = to_platform_device(dev);
+	struct platform_device *pdev = to_platform_device(dev), *connector_pdev;
 	struct dw_hdmi_plat_data *plat_data;
 	struct drm_device *drm = data;
 	struct device_node *phy_node;
@@ -151,16 +175,30 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 		return PTR_ERR(hdmi->regulator);
 	}
 
+	ret = sun8i_dw_hdmi_find_connector_pdev(dev, &connector_pdev);
+	if (!ret) {
+		hdmi->ddc_en = gpiod_get_optional(&connector_pdev->dev,
+						  "ddc-en", GPIOD_OUT_HIGH);
+		platform_device_put(connector_pdev);
+
+		if (IS_ERR(hdmi->ddc_en)) {
+			dev_err(dev, "Couldn't get ddc-en gpio\n");
+			return PTR_ERR(hdmi->ddc_en);
+		}
+	}
+
 	ret = regulator_enable(hdmi->regulator);
 	if (ret) {
 		dev_err(dev, "Failed to enable regulator\n");
-		return ret;
+		goto err_unref_ddc_en;
 	}
 
+	gpiod_set_value(hdmi->ddc_en, 1);
+
 	ret = reset_control_deassert(hdmi->rst_ctrl);
 	if (ret) {
 		dev_err(dev, "Could not deassert ctrl reset control\n");
-		goto err_disable_regulator;
+		goto err_disable_ddc_en;
 	}
 
 	ret = clk_prepare_enable(hdmi->clk_tmds);
@@ -213,8 +251,12 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 	clk_disable_unprepare(hdmi->clk_tmds);
 err_assert_ctrl_reset:
 	reset_control_assert(hdmi->rst_ctrl);
-err_disable_regulator:
+err_disable_ddc_en:
+	gpiod_set_value(hdmi->ddc_en, 0);
 	regulator_disable(hdmi->regulator);
+err_unref_ddc_en:
+	if (hdmi->ddc_en)
+		gpiod_put(hdmi->ddc_en);
 
 	return ret;
 }
@@ -228,7 +270,11 @@ static void sun8i_dw_hdmi_unbind(struct device *dev, struct device *master,
 	sun8i_hdmi_phy_remove(hdmi);
 	clk_disable_unprepare(hdmi->clk_tmds);
 	reset_control_assert(hdmi->rst_ctrl);
+	gpiod_set_value(hdmi->ddc_en, 0);
 	regulator_disable(hdmi->regulator);
+
+	if (hdmi->ddc_en)
+		gpiod_put(hdmi->ddc_en);
 }
 
 static const struct component_ops sun8i_dw_hdmi_ops = {
diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
index 720c5aa8adc1..d707c9171824 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
@@ -9,6 +9,7 @@
 #include <drm/bridge/dw_hdmi.h>
 #include <drm/drm_encoder.h>
 #include <linux/clk.h>
+#include <linux/gpio/consumer.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
@@ -190,6 +191,7 @@ struct sun8i_dw_hdmi {
 	struct regulator		*regulator;
 	const struct sun8i_dw_hdmi_quirks *quirks;
 	struct reset_control		*rst_ctrl;
+	struct gpio_desc		*ddc_en;
 };
 
 static inline struct sun8i_dw_hdmi *
-- 
2.22.0

