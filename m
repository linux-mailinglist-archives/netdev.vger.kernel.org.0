Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB682250ACC
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHXVY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:24:56 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:56188 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgHXVY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 17:24:56 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id 5C13420024;
        Mon, 24 Aug 2020 23:24:30 +0200 (CEST)
Date:   Mon, 24 Aug 2020 23:24:29 +0200
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
Message-ID: <20200824212429.GA106550@ravnborg.org>
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
        a=kj9zAlcOel0A:10 a=BTeA3XvPAAAA:8 a=KKAkSRfTAAAA:8
        a=dfO-HtcW0KOu99fHjzcA:9 a=whV8WjJfvz2m6cgv:21 a=YRhTcNNlbVQiQlz6:21
        a=3cydBBslwyRf96m4:21 a=CjuIK1q_8ugA:10 a=tafbbOV3vt1XuEhzTjGK:22
        a=cvBusfyB2V15izCimMoJ:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro

> Before posting the big patch series again, let me send the new
> version folded into a single patch.

Review 2/N

The way output_poll_changed is used to set gpio_mux to select between
the panel and the HDMI looks strange. But I do not know if there is a
more correct way to do it. Other DRM people would need to help
here if there is a better way to do it.

I looked briefly af suspend/resume.
I think this would benefit from using drm_mode_config_helper_suspend()
and drm_mode_config_helper_resume() but I did not finalize the anlyzis.

Other than this only some small details in the following.

	Sam

>  kirin9xx_drm_drv.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.c
> new file mode 100644
> index 000000000000..61b65f8b1ace
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.c
> @@ -0,0 +1,277 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hisilicon Kirin SoCs drm master driver
> + *
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + * Author:
> + *	<cailiwei@hisilicon.com>
> + *	<zhengwanchun@hisilicon.com>
> + */
> +
> +#include <linux/of_platform.h>
> +#include <linux/component.h>
> +#include <linux/of_graph.h>
Sort includes

> +
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_helper.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_gem_framebuffer_helper.h>
> +#include <drm/drm_of.h>
> +#include <drm/drm_probe_helper.h>
> +#include <drm/drm_vblank.h>
> +#include <drm/drm_managed.h>
Sort includes

> +
> +#include "kirin9xx_dpe.h"
> +#include "kirin9xx_drm_drv.h"
> +
> +static int kirin_drm_kms_cleanup(struct drm_device *dev)
> +{
> +	struct kirin_drm_private *priv = to_drm_private(dev);
> +
> +	if (priv->fbdev)
> +		priv->fbdev = NULL;
> +
> +	drm_kms_helper_poll_fini(dev);
> +	kirin9xx_dss_drm_cleanup(dev);
> +
> +	return 0;
> +}
> +
> +static void kirin_fbdev_output_poll_changed(struct drm_device *dev)
> +{
> +	struct kirin_drm_private *priv = to_drm_private(dev);
> +
> +	dsi_set_output_client(dev);
> +
> +	drm_fb_helper_hotplug_event(priv->fbdev);
> +}
> +
> +static const struct drm_mode_config_funcs kirin_drm_mode_config_funcs = {
> +	.fb_create = drm_gem_fb_create,
> +	.output_poll_changed = kirin_fbdev_output_poll_changed,
> +	.atomic_check = drm_atomic_helper_check,
> +	.atomic_commit = drm_atomic_helper_commit,
> +};
> +
> +static int kirin_drm_kms_init(struct drm_device *dev)
> +{
> +	long kirin_type;
> +	int ret;
> +
> +	dev_set_drvdata(dev->dev, dev);
> +
> +	ret = drmm_mode_config_init(dev);
> +	if (ret)
> +		return ret;
> +
> +	dev->mode_config.min_width = 0;
> +	dev->mode_config.min_height = 0;
> +	dev->mode_config.max_width = 2048;
> +	dev->mode_config.max_height = 2048;
> +	dev->mode_config.preferred_depth = 32;
> +
> +	dev->mode_config.funcs = &kirin_drm_mode_config_funcs;
> +
> +	/* display controller init */
> +	kirin_type = (long)of_device_get_match_data(dev->dev);
> +	if (WARN_ON(!kirin_type))
> +		return -ENODEV;
> +
> +	ret = dss_drm_init(dev, kirin_type);
> +	if (ret)
> +		return ret;
> +
> +	/* bind and init sub drivers */
> +	ret = component_bind_all(dev->dev, dev);
> +	if (ret) {
> +		drm_err(dev, "failed to bind all component.\n");
> +		return ret;
> +	}
> +
> +	/* vblank init */
> +	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
> +	if (ret) {
> +		drm_err(dev, "failed to initialize vblank.\n");
> +		return ret;
> +	}
> +	/* with irq_enabled = true, we can use the vblank feature. */
> +	dev->irq_enabled = true;
> +
> +	/* reset all the states of crtc/plane/encoder/connector */
> +	drm_mode_config_reset(dev);
> +
> +	/* init kms poll for handling hpd */
> +	drm_kms_helper_poll_init(dev);
> +
> +	return 0;
> +}
> +
> +DEFINE_DRM_GEM_CMA_FOPS(kirin_drm_fops);
Move it to right above kirin_drm_driver where it is used

> +
> +static int kirin_drm_connectors_register(struct drm_device *dev)
> +{
> +	struct drm_connector_list_iter conn_iter;
> +	struct drm_connector *failed_connector;
> +	struct drm_connector *connector;
> +	int ret;
> +
> +	mutex_lock(&dev->mode_config.mutex);
> +	drm_connector_list_iter_begin(dev, &conn_iter);
> +	drm_for_each_connector_iter(connector, &conn_iter) {
> +		ret = drm_connector_register(connector);
> +		if (ret) {
> +			failed_connector = connector;
> +			goto err;
> +		}
> +	}
> +	mutex_unlock(&dev->mode_config.mutex);
> +
> +	return 0;
> +
> +err:
> +	drm_connector_list_iter_begin(dev, &conn_iter);
> +	drm_for_each_connector_iter(connector, &conn_iter) {
> +		if (failed_connector == connector)
> +			break;
> +		drm_connector_unregister(connector);
> +	}
> +	mutex_unlock(&dev->mode_config.mutex);
> +
> +	return ret;
> +}
> +
> +static struct drm_driver kirin_drm_driver = {
> +	.driver_features	= DRIVER_GEM | DRIVER_MODESET |
> +				  DRIVER_ATOMIC | DRIVER_RENDER,
> +
> +	.fops			= &kirin_drm_fops,
> +	.name			= "kirin9xx",
> +	.desc			= "Hisilicon Kirin9xx SoCs' DRM Driver",
> +	.date			= "20170309",
> +	.major			= 1,
> +	.minor			= 0,
> +
> +	DRM_GEM_CMA_VMAP_DRIVER_OPS
> +};
Looks good now.

> +
> +
> +static int compare_of(struct device *dev, void *data)
> +{
> +	return dev->of_node == data;
> +}
> +
> +static int kirin_drm_bind(struct device *dev)
> +{
> +	struct kirin_drm_private *priv;
> +	struct drm_device *drm;
> +	int ret;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	drm = &priv->drm;
> +
> +	ret = devm_drm_dev_init(dev, drm, &kirin_drm_driver);
> +	if (ret) {
> +		kfree(priv);
> +		return ret;
> +	}
> +	drmm_add_final_kfree(drm, priv);
> +
> +	ret = kirin_drm_kms_init(drm);
> +	if (ret)
> +		return ret;
> +
> +	ret = drm_dev_register(drm, 0);
> +	if (ret)
> +		return ret;
> +
> +	drm_fbdev_generic_setup(drm, 0);
Should be last - after connector register.

> +
> +	/* connectors should be registered after drm device register */
> +	ret = kirin_drm_connectors_register(drm);
> +	if (ret)
> +		goto err_drm_dev_unregister;
I am rather sure registering connectors are already taken care of by
drm_dev_register(). 
The driver set DRIVER_MODESET so drm_modeset_register_all() is called
which again registers all connectors.

> +
> +	return 0;
> +
> +err_drm_dev_unregister:
> +	drm_dev_unregister(drm);
> +	kirin_drm_kms_cleanup(drm);

> +	drm_dev_put(drm);
Not needed when using drmm_* and embedded drm_device
> +
> +	return ret;
> +}
> +
> +static void kirin_drm_unbind(struct device *dev)
> +{
> +	struct drm_device *drm_dev = dev_get_drvdata(dev);
> +
> +	drm_dev_unregister(drm_dev);
> +	drm_atomic_helper_shutdown(drm_dev);
> +	kirin_drm_kms_cleanup(drm_dev);

> +	drm_dev_put(drm_dev);
Not needed when using drmm_* and embedded drm_device

> +}
> +
> +static const struct component_master_ops kirin_drm_ops = {
> +	.bind = kirin_drm_bind,
> +	.unbind = kirin_drm_unbind,
> +};
> +
> +static int kirin_drm_platform_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct component_match *match = NULL;
> +	struct device_node *remote;
> +
> +	remote = of_graph_get_remote_node(np, 0, 0);
> +	if (!remote)
> +		return -ENODEV;
> +
> +	drm_of_component_match_add(dev, &match, compare_of, remote);
> +	of_node_put(remote);
> +
> +	return component_master_add_with_match(dev, &kirin_drm_ops, match);
> +}
> +
> +static int kirin_drm_platform_remove(struct platform_device *pdev)
> +{
> +	component_master_del(&pdev->dev, &kirin_drm_ops);
> +	return 0;
> +}
> +
> +static const struct of_device_id kirin_drm_dt_ids[] = {
> +	{ .compatible = "hisilicon,hi3660-dpe",
> +	  .data = (void *)FB_ACCEL_HI366x,
> +	},
> +	{ .compatible = "hisilicon,kirin970-dpe",
> +	  .data = (void *)FB_ACCEL_KIRIN970,
> +	},
> +	{ /* end node */ },
> +};
> +MODULE_DEVICE_TABLE(of, kirin_drm_dt_ids);
> +
> +static struct platform_driver kirin_drm_platform_driver = {
> +	.probe = kirin_drm_platform_probe,
> +	.remove = kirin_drm_platform_remove,
> +	.suspend = kirin9xx_dss_drm_suspend,
> +	.resume = kirin9xx_dss_drm_resume,
> +	.driver = {
> +		.name = "kirin9xx-drm",
> +		.of_match_table = kirin_drm_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(kirin_drm_platform_driver);
> +
> +MODULE_AUTHOR("cailiwei <cailiwei@hisilicon.com>");
> +MODULE_AUTHOR("zhengwanchun <zhengwanchun@hisilicon.com>");
> +MODULE_DESCRIPTION("hisilicon Kirin SoCs' DRM master driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.h b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.h
> new file mode 100644
> index 000000000000..9bfcb35d6fa5
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#ifndef __KIRIN_DRM_DRV_H__
> +#define __KIRIN_DRM_DRV_H__
> +
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fb_helper.h>
> +#include <drm/drm_print.h>
> +
> +#include <linux/iommu.h>
> +
> +#define MAX_CRTC	2
> +
> +struct kirin_drm_private {
> +	struct drm_device drm;
Hmm, hare we have drm_device embedded - so some comments from previous
review can be ignored - ups.

> +	struct drm_fb_helper *fbdev;
Never assigned - can be deleted.
kirin_fbdev_output_poll_changed() needs to be re-visited as it assumes
fbdev is assigned.

> +	struct drm_crtc *crtc[MAX_CRTC];
> +};
> +
> +struct kirin_fbdev {
> +	struct drm_fb_helper fb_helper;
> +	struct drm_framebuffer *fb;
> +};
struct kirin_fbdev is unused - delete.

> +
> +/* provided by kirin9xx_drm_dss.c */
> +void kirin9xx_dss_drm_cleanup(struct drm_device *dev);
> +int kirin9xx_dss_drm_suspend(struct platform_device *pdev, pm_message_t state);
> +int kirin9xx_dss_drm_resume(struct platform_device *pdev);
> +int dss_drm_init(struct drm_device *dev, u32 g_dss_version_tag);
> +
> +void dsi_set_output_client(struct drm_device *dev);
> +
> +#define to_drm_private(d) container_of(d, struct kirin_drm_private, drm)
> +
> +#endif /* __KIRIN_DRM_DRV_H__ */
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dss.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dss.c
> new file mode 100644
> index 000000000000..ff93df229868
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dss.c
> @@ -0,0 +1,979 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hisilicon Hi6220 SoC ADE(Advanced Display Engine)'s crtc&plane driver
> + *
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + *
> + * Author:
> + *	Xinliang Liu <z.liuxinliang@hisilicon.com>
> + *	Xinliang Liu <xinliang.liu@linaro.org>
> + *	Xinwei Kong <kong.kongxinwei@hisilicon.com>
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <video/display_timing.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +#include <linux/of_address.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
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
> +#include <drm/drm_vblank.h>
> +#include <drm/drm_modeset_helper_vtables.h>
> +
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_dpe.h"
> +
> +int hdmi_pxl_ppll7_init(struct dss_hw_ctx *ctx, u64 pixel_clock)
> +{
> +	u64 vco_min_freq_output = KIRIN970_VCO_MIN_FREQ_OUTPUT;
> +	u64 refdiv, fbdiv, frac, postdiv1 = 0, postdiv2 = 0;
> +	u64 dss_pxl0_clk = 7 * 144000000UL;
> +	u64 sys_clock_fref = KIRIN970_SYS_19M2;
> +	u64 ppll7_freq_divider;
> +	u64 vco_freq_output;
> +	u64 frac_range = 0x1000000; /* 2^24 */
> +	u64 pixel_clock_ori;
> +	u64 pixel_clock_cur;
> +	u32 ppll7ctrl0;
> +	u32 ppll7ctrl1;
> +	u32 ppll7ctrl0_val;
> +	u32 ppll7ctrl1_val;
> +	int ceil_temp;
> +	int i, ret;
> +	const int freq_divider_list[22] = {
> +		1,  2,  3,  4,  5,  6,  7,  8,
> +		9, 10, 12, 14, 15, 16, 20, 21,
> +		24, 25, 30, 36, 42, 49
> +	};
> +	const int postdiv1_list[22] = {
> +		1, 2, 3, 4, 5, 6, 7, 4, 3, 5,
> +		4, 7, 5, 4, 5, 7, 6, 5, 6, 6,
> +		7, 7
> +	};
> +	const int postdiv2_list[22] = {
> +		1, 1, 1, 1, 1, 1, 1, 2, 3, 2,
> +		3, 2, 3, 4, 4, 3, 4, 5, 5, 6,
> +		6, 7
> +	};
> +
> +	if (!pixel_clock) {
> +		drm_err(ctx->dev, "Pixel clock can't be zero!\n");
> +		return -EINVAL;
> +	}
> +
> +	pixel_clock_ori = pixel_clock;
> +	pixel_clock_cur = pixel_clock_ori;
> +
> +	if (pixel_clock_ori <= 255000000) {
> +		pixel_clock_cur *= 7;
> +		dss_pxl0_clk /= 7;
> +	} else if (pixel_clock_ori <= 415000000) {
> +		pixel_clock_cur *= 5;
> +		dss_pxl0_clk /= 5;
> +	} else if (pixel_clock_ori <= 594000000) {
> +		pixel_clock_cur *= 3;
> +		dss_pxl0_clk /= 3;
> +	} else {
> +		drm_err(ctx->dev, "Clock not supported!\n");
> +		return -EINVAL;
> +	}
> +
> +	pixel_clock_cur = pixel_clock_cur / 1000;
> +	if (!pixel_clock_cur) {
> +		drm_err(ctx->dev, "pixel_clock_cur can't be zero!\n");
> +		return -EINVAL;
> +	}
> +
> +	ceil_temp = DIV_ROUND_UP(vco_min_freq_output, pixel_clock_cur);
> +
> +	ppll7_freq_divider = (u64)ceil_temp;
> +
> +	for (i = 0; i < ARRAY_SIZE(freq_divider_list); i++) {
> +		if (freq_divider_list[i] >= ppll7_freq_divider) {
> +			ppll7_freq_divider = freq_divider_list[i];
> +			postdiv1 = postdiv1_list[i];
> +			postdiv2 = postdiv2_list[i];
> +			break;
> +		}
> +	}
> +
> +	if (i == ARRAY_SIZE(freq_divider_list)) {
> +		drm_err(ctx->dev, "Can't find a valid setting for PLL7!\n");
> +		return -EINVAL;
> +	}
> +
> +	vco_freq_output = ppll7_freq_divider * pixel_clock_cur;
> +	if (!vco_freq_output) {
> +		drm_err(ctx->dev, "Can't find a valid setting for VCO_FREQ!\n");
> +		return -EINVAL;
> +	}
> +
> +	ceil_temp = DIV_ROUND_UP(400000, vco_freq_output);
> +
> +	refdiv = ((vco_freq_output * ceil_temp) >= 494000) ? 1 : 2;
> +	fbdiv = (vco_freq_output * ceil_temp) * refdiv / sys_clock_fref;
> +
> +	frac = (u64)(ceil_temp * vco_freq_output - sys_clock_fref / refdiv * fbdiv) * refdiv * frac_range;
> +	frac = (u64)frac / sys_clock_fref;
> +
> +	ppll7ctrl0 = readl(ctx->pmctrl_base + MIDIA_PPLL7_CTRL0);
> +	ppll7ctrl0 &= ~MIDIA_PPLL7_FREQ_DEVIDER_MASK;
> +
> +	ppll7ctrl0_val = 0x0;
> +	ppll7ctrl0_val |= (u32)(postdiv2 << 23 | postdiv1 << 20 | fbdiv << 8 | refdiv << 2);
> +	ppll7ctrl0_val &= MIDIA_PPLL7_FREQ_DEVIDER_MASK;
> +	ppll7ctrl0 |= ppll7ctrl0_val;
> +
> +	writel(ppll7ctrl0, ctx->pmctrl_base + MIDIA_PPLL7_CTRL0);
> +
> +	ppll7ctrl1 = readl(ctx->pmctrl_base + MIDIA_PPLL7_CTRL1);
> +	ppll7ctrl1 &= ~MIDIA_PPLL7_FRAC_MODE_MASK;
> +
> +	ppll7ctrl1_val = 0x0;
> +	ppll7ctrl1_val |= (u32)(1 << 25 | 0 << 24 | frac);
> +	ppll7ctrl1_val &= MIDIA_PPLL7_FRAC_MODE_MASK;
> +	ppll7ctrl1 |= ppll7ctrl1_val;
> +
> +	writel(ppll7ctrl1, ctx->pmctrl_base + MIDIA_PPLL7_CTRL1);
> +
> +	drm_dbg(ctx->dev, "PLL7 set to (0x%0x, 0x%0x)\n",
> +		ppll7ctrl0, ppll7ctrl1);
> +
> +	ret = clk_set_rate(ctx->dss_pxl0_clk, dss_pxl0_clk);
> +	if (ret < 0)
> +		drm_err(ctx->dev, "%s: clk_set_rate(dss_pxl0_clk, %llu) failed: %d!\n",
> +			  __func__, dss_pxl0_clk, ret);
> +	else
> +		drm_dbg(ctx->dev, "dss_pxl0_clk:[%llu]->[%lu].\n",
> +			dss_pxl0_clk, clk_get_rate(ctx->dss_pxl0_clk));
> +
> +	return ret;
> +}
> +
> +static u64 dss_calculate_clock(struct dss_crtc *acrtc,
> +			       const struct drm_display_mode *mode)
> +{
> +	u64 clk_Hz;
> +
> +	if (acrtc->ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		if (mode->clock == 148500)
> +			clk_Hz = 144000 * 1000UL;
> +		else if (mode->clock == 83496)
> +			clk_Hz = 84000 * 1000UL;
> +		else if (mode->clock == 74440)
> +			clk_Hz = 72000 * 1000UL;
> +		else if (mode->clock == 74250)
> +			clk_Hz = 72000 * 1000UL;
> +		else
> +			clk_Hz = mode->clock * 1000UL;
> +
> +		/* Adjust pixel clock for compatibility with 10.1 inch special displays. */
> +		if (mode->clock == 148500 && mode->width_mm == 532 && mode->height_mm == 299)
> +			clk_Hz = 152000 * 1000UL;
> +	} else {
> +		if (mode->clock == 148500)
> +			clk_Hz = 144000 * 1000UL;
> +		else if (mode->clock == 83496)
> +			clk_Hz = 80000 * 1000UL;
> +		else if (mode->clock == 74440)
> +			clk_Hz = 72000 * 1000UL;
> +		else if (mode->clock == 74250)
> +			clk_Hz = 72000 * 1000UL;
> +		else
> +			clk_Hz = mode->clock * 1000UL;
> +	}
> +
> +	return clk_Hz;
> +}
> +
> +static void dss_ldi_set_mode(struct dss_crtc *acrtc)
> +{
> +	struct drm_display_mode *adj_mode = &acrtc->base.state->adjusted_mode;
> +	struct drm_display_mode *mode = &acrtc->base.state->mode;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	u32 clock = mode->clock;
> +	u64 clk_Hz;
> +	int ret;
> +
> +	clk_Hz = dss_calculate_clock(acrtc, mode);
> +
> +	drm_dbg(ctx->dev, "Requested clock %u kHz, setting to %llu kHz\n",
> +		clock, clk_Hz / 1000);
> +
> +	if (acrtc->ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ret = hdmi_pxl_ppll7_init(ctx, clk_Hz);
> +	} else {
> +		ret = clk_set_rate(ctx->dss_pxl0_clk, clk_Hz);
> +		if (!ret) {
> +			clk_Hz = clk_get_rate(ctx->dss_pxl0_clk);
> +			drm_dbg(ctx->dev, "dss_pxl0_clk:[%llu]->[%lu].\n",
> +				clk_Hz, clk_get_rate(ctx->dss_pxl0_clk));
> +		}
> +	}
> +
> +	if (ret)
> +		drm_err(ctx->dev, "failed to set pixel clock\n");
> +	else
> +		adj_mode->clock = clk_Hz / 1000;
> +
> +	dpe_init(acrtc);
> +}
> +
> +static int dss_power_up(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	int ret = 0;
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		dpe_common_clk_enable(ctx);
> +		dpe_inner_clk_enable(ctx);
> +		dpe_set_clk_rate(ctx);
> +	} else {
> +		ret = clk_prepare_enable(ctx->dss_pxl0_clk);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				"failed to enable dss_pxl0_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_pri_clk);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				"failed to enable dss_pri_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_pclk_dss_clk);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				"failed to enable dss_pclk_dss_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_axi_clk);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				"failed to enable dss_axi_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_mmbuf_clk);
> +		if (ret) {
> +			drm_err(ctx->dev,
> +				"failed to enable dss_mmbuf_clk (%d)\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	dss_inner_clk_common_enable(ctx);
> +	dss_inner_clk_pdp_enable(ctx);
> +
> +	dpe_interrupt_mask(acrtc);
> +	dpe_interrupt_clear(acrtc);
> +	dpe_irq_enable(acrtc);
> +	dpe_interrupt_unmask(acrtc);
> +
> +	ctx->power_on = true;
> +
> +	return ret;
> +}
> +
> +static void dss_power_down(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	dpe_interrupt_mask(acrtc);
> +	dpe_irq_disable(acrtc);
> +	dpe_deinit(acrtc);
> +
> +	dpe_check_itf_status(acrtc);
> +	dss_inner_clk_pdp_disable(ctx);
> +
> +	dpe_inner_clk_disable(ctx);
> +	dpe_common_clk_disable(ctx);
> +
> +	ctx->power_on = false;
> +}
> +
> +static int dss_enable_vblank(struct drm_crtc *crtc)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	drm_dbg(ctx->dev, "%s\n", __func__);
> +	if (!ctx->power_on) {
> +		drm_dbg(ctx->dev, "Enabling vblank\n");
> +		(void)dss_power_up(acrtc);
> +	}
> +
> +	return 0;
> +}
enable_vblank is supposed to enable interrupts, not a general power up.
Power up should be done by another helper.

> +
> +static void dss_disable_vblank(struct drm_crtc *crtc)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	drm_dbg(ctx->dev, "%s\n", __func__);
> +	if (!ctx->power_on) {
> +		drm_err(ctx->dev, "power is down! vblank disable fail\n");
> +		return;
> +	}
> +}
Same here, just disable vblank

> +
> +static irqreturn_t dss_irq_handler(int irq, void *data)
> +{
> +	struct dss_crtc *acrtc = data;
> +	struct drm_crtc *crtc = &acrtc->base;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	void __iomem *dss_base = ctx->base;
> +
> +	u32 isr_s1 = 0;
> +	u32 isr_s2 = 0;
> +	u32 mask = 0;
> +
> +	isr_s1 = readl(dss_base + GLB_CPU_PDP_INTS);
> +	isr_s2 = readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS);
> +
> +	writel(isr_s2, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS);
> +	writel(isr_s1, dss_base + GLB_CPU_PDP_INTS);
> +
> +	isr_s1 &= ~(readl(dss_base + GLB_CPU_PDP_INT_MSK));
> +	isr_s2 &= ~(readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK));
> +
> +	if (isr_s2 & BIT_VSYNC) {
> +		ctx->vsync_timestamp = ktime_get();
> +		drm_crtc_handle_vblank(crtc);
> +	}
> +
> +	if (isr_s2 & BIT_LDI_UNFLOW) {
> +		mask = readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +		mask |= BIT_LDI_UNFLOW;
> +		writel(mask, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +
> +		drm_err(ctx->dev, "ldi underflow!\n");
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static bool dss_crtc_mode_fixup(struct drm_crtc *crtc,
> +				const struct drm_display_mode *mode,
> +				struct drm_display_mode *adj_mode)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	u64 clk_Hz;
> +
> +	/* Check if clock is too high */
> +	if (mode->clock > 594000)
> +		return false;
> +	/*
> +	 * FIXME: the code should, instead, do some calculus instead of
> +	 * hardcoding the modes. Clearly, there's something missing at
> +	 * dss_calculate_clock()
> +	 */
> +
> +	/*
> +	 * HACK: reports at Hikey 970 mailing lists with the downstream
> +	 * Official Linaro 4.9 driver seem to indicate that some monitor
> +	 * modes aren't properly set. There, this hack was added.
> +	 *
> +	 * On my monitors, this wasn't needed, but better to keep this
> +	 * code here, together with this notice, just in case.
> +	 */
> +	if ((mode->hdisplay    == 1920 && mode->vdisplay == 1080 && mode->clock == 148500)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock == 148352)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock ==  80192)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock ==  74250)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock ==  61855)
> +	    || (mode->hdisplay == 1680 && mode->vdisplay == 1050 && mode->clock == 147116)
> +	    || (mode->hdisplay == 1680 && mode->vdisplay == 1050 && mode->clock == 146250)
> +	    || (mode->hdisplay == 1680 && mode->vdisplay == 1050 && mode->clock == 144589)
> +	    || (mode->hdisplay == 1600 && mode->vdisplay == 1200 && mode->clock == 160961)
> +	    || (mode->hdisplay == 1600 && mode->vdisplay == 900  && mode->clock == 118963)
> +	    || (mode->hdisplay == 1440 && mode->vdisplay == 900  && mode->clock == 126991)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 1024 && mode->clock == 128946)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 1024 && mode->clock ==  98619)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 960  && mode->clock == 102081)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 800  && mode->clock ==  83496)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 720  && mode->clock ==  74440)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 720  && mode->clock ==  74250)
> +	    || (mode->hdisplay == 1024 && mode->vdisplay == 768  && mode->clock ==  78800)
> +	    || (mode->hdisplay == 1024 && mode->vdisplay == 768  && mode->clock ==  75000)
> +	    || (mode->hdisplay == 1024 && mode->vdisplay == 768  && mode->clock ==  81833)
> +	    || (mode->hdisplay == 800  && mode->vdisplay == 600  && mode->clock ==  48907)
> +	    || (mode->hdisplay == 800  && mode->vdisplay == 600  && mode->clock ==  40000)
> +	    || (mode->hdisplay == 800  && mode->vdisplay == 480  && mode->clock ==  32000)
> +	   ) {
> +		clk_Hz = dss_calculate_clock(acrtc, mode);
> +
> +		/*
> +		 * On Kirin970, PXL0 clock is set to a const value,
> +		 * independently of the pixel clock.
> +		 */
> +		if (acrtc->ctx->g_dss_version_tag != FB_ACCEL_KIRIN970)
> +			clk_Hz = clk_round_rate(ctx->dss_pxl0_clk, mode->clock * 1000);
> +
> +		adj_mode->clock = clk_Hz / 1000;
> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void dss_crtc_enable(struct drm_crtc *crtc,
> +			    struct drm_crtc_state *old_state)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	int ret;
> +
> +	if (acrtc->enable)
> +		return;
> +
> +	if (!ctx->power_on) {
> +		ret = dss_power_up(acrtc);
> +		if (ret)
> +			return;
> +	}
> +
> +	acrtc->enable = true;
> +	drm_crtc_vblank_on(crtc);
> +}
> +
> +static void dss_crtc_disable(struct drm_crtc *crtc,
> +			     struct drm_crtc_state *old_state)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +
> +	if (!acrtc->enable)
> +		return;
> +
> +	dss_power_down(acrtc);
> +	acrtc->enable = false;
> +	drm_crtc_vblank_off(crtc);
> +}
> +
> +static void dss_crtc_mode_set_nofb(struct drm_crtc *crtc)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	if (!ctx->power_on)
> +		(void)dss_power_up(acrtc);
> +	dss_ldi_set_mode(acrtc);
> +}
> +
> +static void dss_crtc_atomic_begin(struct drm_crtc *crtc,
> +				  struct drm_crtc_state *old_state)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	if (!ctx->power_on)
> +		(void)dss_power_up(acrtc);
> +}
> +
> +static void dss_crtc_atomic_flush(struct drm_crtc *crtc,
> +				  struct drm_crtc_state *old_state)
> +
> +{
> +	struct drm_pending_vblank_event *event = crtc->state->event;
> +
> +	if (event) {
> +		crtc->state->event = NULL;
> +
> +		spin_lock_irq(&crtc->dev->event_lock);
> +		if (drm_crtc_vblank_get(crtc) == 0)
> +			drm_crtc_arm_vblank_event(crtc, event);
> +		else
> +			drm_crtc_send_vblank_event(crtc, event);
> +		spin_unlock_irq(&crtc->dev->event_lock);
> +	}
> +}
> +
> +static const struct drm_crtc_helper_funcs dss_crtc_helper_funcs = {
> +	.mode_fixup	= dss_crtc_mode_fixup,
> +	.atomic_enable	= dss_crtc_enable,
> +	.atomic_disable	= dss_crtc_disable,
> +	.mode_set_nofb	= dss_crtc_mode_set_nofb,
> +	.atomic_begin	= dss_crtc_atomic_begin,
> +	.atomic_flush	= dss_crtc_atomic_flush,
> +};
> +
> +static const struct drm_crtc_funcs dss_crtc_funcs = {
> +	.destroy	= drm_crtc_cleanup,
> +	.set_config	= drm_atomic_helper_set_config,
> +	.page_flip	= drm_atomic_helper_page_flip,
> +	.reset		= drm_atomic_helper_crtc_reset,
> +	.atomic_duplicate_state	= drm_atomic_helper_crtc_duplicate_state,
> +	.atomic_destroy_state	= drm_atomic_helper_crtc_destroy_state,
> +	.enable_vblank = dss_enable_vblank,
> +	.disable_vblank = dss_disable_vblank,
> +};
> +
> +static int dss_crtc_init(struct drm_device *dev, struct drm_crtc *crtc,
> +			 struct drm_plane *plane)
> +{
> +	struct kirin_drm_private *priv = to_drm_private(dev);
> +	struct device_node *port;
> +	int ret;
> +
> +	/* set crtc port so that
> +	 * drm_of_find_possible_crtcs call works
> +	 */
> +	port = of_get_child_by_name(dev->dev->of_node, "port");
> +	if (!port) {
> +		drm_err(dev, "no port node found in %s\n",
> +			dev->dev->of_node->full_name);
> +		return -EINVAL;
> +	}
> +	of_node_put(port);
> +	crtc->port = port;
> +
> +	ret = drm_crtc_init_with_planes(dev, crtc, plane, NULL,
> +					&dss_crtc_funcs, NULL);
> +	if (ret) {
> +		drm_err(dev, "failed to init crtc.\n");
> +		return ret;
> +	}
> +
> +	drm_crtc_helper_add(crtc, &dss_crtc_helper_funcs);
> +	priv->crtc[drm_crtc_index(crtc)] = crtc;
> +
> +	return 0;
> +}
> +
> +static int dss_plane_atomic_check(struct drm_plane *plane,
> +				  struct drm_plane_state *state)
> +{
> +	struct drm_framebuffer *fb = state->fb;
> +	struct drm_crtc *crtc = state->crtc;
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	struct drm_crtc_state *crtc_state;
> +	u32 src_x = state->src_x >> 16;
> +	u32 src_y = state->src_y >> 16;
> +	u32 src_w = state->src_w >> 16;
> +	u32 src_h = state->src_h >> 16;
> +	int crtc_x = state->crtc_x;
> +	int crtc_y = state->crtc_y;
> +	u32 crtc_w = state->crtc_w;
> +	u32 crtc_h = state->crtc_h;
> +	u32 fmt;
> +
> +	if (!crtc || !fb)
> +		return 0;
> +
> +	fmt = dpe_get_format(ctx, fb->format->format);
> +	if (fmt == HISI_FB_PIXEL_FORMAT_UNSUPPORT)
> +		return -EINVAL;
> +
> +	crtc_state = drm_atomic_get_crtc_state(state->state, crtc);
> +	if (IS_ERR(crtc_state))
> +		return PTR_ERR(crtc_state);
> +
> +	if (src_w != crtc_w || src_h != crtc_h) {
> +		drm_err(ctx->dev, "Scale not support!!!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (src_x + src_w > fb->width ||
> +	    src_y + src_h > fb->height)
> +		return -EINVAL;
> +
> +	if (crtc_x < 0 || crtc_y < 0)
> +		return -EINVAL;
> +
> +	if (crtc_x + crtc_w > crtc_state->adjusted_mode.hdisplay ||
> +	    crtc_y + crtc_h > crtc_state->adjusted_mode.vdisplay)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void dss_plane_atomic_update(struct drm_plane *plane,
> +				    struct drm_plane_state *old_state)
> +{
> +	struct drm_plane_state *state = plane->state;
> +
> +	if (!state->fb) {
> +		state->visible = false;
> +		return;
> +	}
> +
> +	hisi_fb_pan_display(plane);
> +}
> +
> +static void dss_plane_atomic_disable(struct drm_plane *plane,
> +				     struct drm_plane_state *old_state)
> +{
> +	/* FIXME: Maybe this? */
> +#if 0
> +	struct dss_plane *aplane = to_dss_plane(plane);
> +	struct dss_crtc *acrtc = aplane->acrtc;
> +
> +	disable_ldi(acrtc);
> +	hisifb_mctl_sw_clr(acrtc);
> +#endif
> +}
> +
> +static const struct drm_plane_helper_funcs dss_plane_helper_funcs = {
> +	.atomic_check = dss_plane_atomic_check,
> +	.atomic_update = dss_plane_atomic_update,
> +	.atomic_disable = dss_plane_atomic_disable,
> +};
> +
> +static struct drm_plane_funcs dss_plane_funcs = {
> +	.update_plane	= drm_atomic_helper_update_plane,
> +	.disable_plane	= drm_atomic_helper_disable_plane,
> +	.destroy = drm_plane_cleanup,
> +	.reset = drm_atomic_helper_plane_reset,
> +	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
> +	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
> +};
> +
> +static int dss_plane_init(struct drm_device *dev, struct dss_plane *aplane,
> +			  enum drm_plane_type type)
> +{
> +	const u32 *fmts;
> +	u32 fmts_cnt;
> +	int ret = 0;
> +
> +	/* get properties */
> +	fmts_cnt = hisi_dss_get_channel_formats(dev, aplane->ch, &fmts);
> +	if (ret)
> +		return ret;
> +
> +	ret = drm_universal_plane_init(dev, &aplane->base, 1, &dss_plane_funcs,
> +				       fmts, fmts_cnt, NULL,
> +				       type, NULL);
> +	if (ret) {
> +		drm_err(dev, "fail to init plane, ch=%d\n", aplane->ch);
> +		return ret;
> +	}
> +
> +	drm_plane_helper_add(&aplane->base, &dss_plane_helper_funcs);
> +
> +	return 0;
> +}
> +
> +static int dss_enable_iommu(struct platform_device *pdev, struct dss_hw_ctx *ctx)
> +{
> +#if 0
> +/*
> + * FIXME:
> + *
> + * Right now, the IOMMU support is actually disabled. See the caller of
> + * hisi_dss_smmu_config(). Yet, if we end enabling it, this should be
> + * ported to use io-pgtable directly.
> + */
> +	struct device *dev = NULL;
> +
> +	dev = &pdev->dev;
> +
> +	/* create iommu domain */
> +	ctx->mmu_domain = iommu_domain_alloc(dev->bus);
> +	if (!ctx->mmu_domain) {
> +		drm_err(ctx->dev, "iommu_domain_alloc failed!\n");
> +		return -EINVAL;
> +	}
> +
> +	iommu_attach_device(ctx->mmu_domain, dev);
> +#endif
> +	return 0;
> +}
> +
> +static int dss_dts_parse(struct platform_device *pdev, struct dss_hw_ctx *ctx)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = NULL;
> +	const char *compatible;
> +	int ret = 0;
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		compatible = "hisilicon,kirin970-dpe";
> +	else
> +		compatible = "hisilicon,hi3660-dpe";
> +
> +	np = of_find_compatible_node(NULL, NULL, compatible);
> +	if (!np) {
> +		drm_err(ctx->dev, "NOT FOUND device node %s!\n", compatible);
> +		return -ENXIO;
> +	}
> +
> +	/* Initialize version-specific data */
> +	if (ctx->g_dss_version_tag == FB_ACCEL_HI366x)
> +		kirin960_dpe_defs(ctx);
> +	else
> +		kirin970_dpe_defs(ctx);
> +
> +	ctx->base = of_iomap(np, 0);
> +	if (!(ctx->base)) {
> +		drm_err(ctx->dev, "failed to get dss base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	ctx->peri_crg_base  = of_iomap(np, 1);
> +	if (!(ctx->peri_crg_base)) {
> +		drm_err(ctx->dev, "failed to get dss peri_crg_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	ctx->sctrl_base  = of_iomap(np, 2);
> +	if (!(ctx->sctrl_base)) {
> +		drm_err(ctx->dev, "failed to get dss sctrl_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->pctrl_base = of_iomap(np, 3);
> +		if (!(ctx->pctrl_base)) {
> +			drm_err(ctx->dev,
> +				"failed to get dss pctrl_base resource.\n");
> +			return -ENXIO;
> +		}
> +	} else {
> +		ctx->pmc_base = of_iomap(np, 3);
> +		if (!(ctx->pmc_base)) {
> +			drm_err(ctx->dev,
> +				"failed to get dss pmc_base resource.\n");
> +			return -ENXIO;
> +		}
> +	}
> +
> +	ctx->noc_dss_base = of_iomap(np, 4);
> +	if (!(ctx->noc_dss_base)) {
> +		drm_err(ctx->dev, "failed to get noc_dss_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->pmctrl_base = of_iomap(np, 5);
> +		if (!(ctx->pmctrl_base)) {
> +			drm_err(ctx->dev,
> +				"failed to get dss pmctrl_base resource.\n");
> +			return -ENXIO;
> +		}
> +
> +		ctx->media_crg_base = of_iomap(np, 6);
> +		if (!(ctx->media_crg_base)) {
> +			drm_err(ctx->dev,
> +				"failed to get dss media_crg_base resource.\n");
> +			return -ENXIO;
> +		}
> +	}
> +
> +	/* get irq no */
> +	ctx->irq = irq_of_parse_and_map(np, 0);
> +	if (ctx->irq <= 0) {
> +		drm_err(ctx->dev, "failed to get irq_pdp resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	drm_dbg(ctx->dev, "dss irq = %d.\n", ctx->irq);
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->dpe_regulator = devm_regulator_get(dev, REGULATOR_PDP_NAME);
> +		if (!ctx->dpe_regulator) {
> +			drm_err(ctx->dev,
> +				"failed to get dpe_regulator resource! ret=%d.\n",
> +				ret);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	ctx->dss_mmbuf_clk = devm_clk_get(dev, "clk_dss_axi_mm");
> +	ret = PTR_ERR_OR_ZERO(ctx->dss_mmbuf_clk);
> +	if (ret == -EPROBE_DEFER) {
> +		return ret;
> +	} else if (ret) {
> +		drm_err(ctx->dev, "failed to parse dss_mmbuf_clk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ctx->dss_axi_clk = devm_clk_get(dev, "aclk_dss");
> +	ret = PTR_ERR_OR_ZERO(ctx->dss_axi_clk);
> +	if (ret == -EPROBE_DEFER) {
> +		return ret;
> +	} else if (ret) {
> +		drm_err(ctx->dev, "failed to parse dss_axi_clk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ctx->dss_pclk_dss_clk = devm_clk_get(dev, "pclk_dss");
> +	ret = PTR_ERR_OR_ZERO(ctx->dss_pclk_dss_clk);
> +	if (ret == -EPROBE_DEFER) {
> +		return ret;
> +	} else if (ret) {
> +		drm_err(ctx->dev,
> +			"failed to parse dss_pclk_dss_clk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ctx->dss_pri_clk = devm_clk_get(dev, "clk_edc0");
> +	ret = PTR_ERR_OR_ZERO(ctx->dss_pri_clk);
> +	if (ret == -EPROBE_DEFER) {
> +		return ret;
> +	} else if (ret) {
> +		drm_err(ctx->dev, "failed to parse dss_pri_clk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (ctx->g_dss_version_tag != FB_ACCEL_KIRIN970) {
> +		ret = clk_set_rate(ctx->dss_pri_clk, DEFAULT_DSS_CORE_CLK_07V_RATE);
> +		if (ret < 0) {
> +			drm_err(ctx->dev, "dss_pri_clk clk_set_rate(%lu) failed, error=%d!\n",
> +				DEFAULT_DSS_CORE_CLK_07V_RATE, ret);
> +			return -EINVAL;
> +		}
> +
> +		drm_dbg(ctx->dev, "dss_pri_clk:[%lu]->[%llu].\n",
> +			DEFAULT_DSS_CORE_CLK_07V_RATE, (uint64_t)clk_get_rate(ctx->dss_pri_clk));
> +	}
> +
> +	ctx->dss_pxl0_clk = devm_clk_get(dev, "clk_ldi0");
> +	ret = PTR_ERR_OR_ZERO(ctx->dss_pri_clk);
> +	if (ret == -EPROBE_DEFER) {
> +		return ret;
> +	} else if (ret) {
> +		drm_err(ctx->dev, "failed to parse dss_pxl0_clk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (ctx->g_dss_version_tag != FB_ACCEL_KIRIN970) {
> +		ret = clk_set_rate(ctx->dss_pxl0_clk, DSS_MAX_PXL0_CLK_144M);
> +		if (ret < 0) {
> +			drm_err(ctx->dev,
> +				"dss_pxl0_clk clk_set_rate(%lu) failed, error=%d!\n",
> +				DSS_MAX_PXL0_CLK_144M, ret);
> +			return -EINVAL;
> +		}
> +
> +		drm_dbg(ctx->dev, "dss_pxl0_clk:[%lu]->[%llu].\n",
> +			DSS_MAX_PXL0_CLK_144M,
> +			(uint64_t)clk_get_rate(ctx->dss_pxl0_clk));
> +	}
> +
> +	/* enable IOMMU */
> +	dss_enable_iommu(pdev, ctx);
> +
> +	return 0;
> +}
> +
> +int dss_drm_init(struct drm_device *dev, u32 g_dss_version_tag)
> +{
> +	struct platform_device *pdev = to_platform_device(dev->dev);
> +	struct dss_data *dss;
> +	struct dss_hw_ctx *ctx;
> +	struct dss_crtc *acrtc;
> +	struct dss_plane *aplane;
> +	enum drm_plane_type type;
> +	int ret;
> +	int i;
> +
> +	dss = devm_kzalloc(dev->dev, sizeof(*dss), GFP_KERNEL);
> +	if (!dss) {
> +		drm_err(dev, "failed to alloc dss_data\n");
> +		return -ENOMEM;
> +	}
> +	platform_set_drvdata(pdev, dss);
> +
> +	ctx = &dss->ctx;
> +	ctx->dev = dev;
> +	ctx->g_dss_version_tag = g_dss_version_tag;
> +
> +	acrtc = &dss->acrtc;
> +	acrtc->ctx = ctx;
> +	acrtc->out_format = LCD_RGB888;
> +	acrtc->bgr_fmt = LCD_RGB;
> +
> +	ret = dss_dts_parse(pdev, ctx);
> +	if (ret)
> +		return ret;
> +
> +	ctx->vactive0_end_flag = 0;
> +	init_waitqueue_head(&ctx->vactive0_end_wq);
> +
> +	/*
> +	 * plane init
> +	 * TODO: Now only support primary plane, overlay planes
> +	 * need to do.
TODO rather unclear..

> +	 */
> +	for (i = 0; i < DSS_CH_NUM; i++) {
> +		aplane = &dss->aplane[i];
> +		aplane->ch = i;
> +		/* aplane->ctx = ctx; */
> +		aplane->acrtc = acrtc;
> +		type = i == PRIMARY_CH ? DRM_PLANE_TYPE_PRIMARY :
> +			DRM_PLANE_TYPE_OVERLAY;
> +
> +		ret = dss_plane_init(dev, aplane, type);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* crtc init */
> +	ret = dss_crtc_init(dev, &acrtc->base, &dss->aplane[PRIMARY_CH].base);
> +	if (ret)
> +		return ret;
> +
> +	/* vblank irq init */
> +	ret = devm_request_irq(dev->dev, ctx->irq, dss_irq_handler,
> +			       IRQF_SHARED, dev->driver->name, acrtc);
> +	if (ret) {
> +		drm_err(dev, "fail to  devm_request_irq, ret=%d!", ret);
> +		return ret;
> +	}
> +
> +	disable_irq(ctx->irq);
> +
> +	return 0;
> +}
> +
> +void kirin9xx_dss_drm_cleanup(struct drm_device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev->dev);
> +	struct dss_data *dss = platform_get_drvdata(pdev);
> +	struct drm_crtc *crtc = &dss->acrtc.base;
> +
> +	drm_crtc_cleanup(crtc);
> +}
> +
> +int kirin9xx_dss_drm_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct dss_data *dss = platform_get_drvdata(pdev);
> +	struct drm_crtc *crtc = &dss->acrtc.base;
> +
> +	dss_crtc_disable(crtc, NULL);
> +
> +	return 0;
> +}
> +
> +int kirin9xx_dss_drm_resume(struct platform_device *pdev)
> +{
> +	struct dss_data *dss = platform_get_drvdata(pdev);
> +	struct drm_crtc *crtc = &dss->acrtc.base;
> +
> +	dss_crtc_mode_set_nofb(crtc);
> +	dss_crtc_enable(crtc, NULL);
> +
> +	return 0;
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
> new file mode 100644
> index 000000000000..c3e9fc95ad39
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
> @@ -0,0 +1,761 @@
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
> +#include "kirin9xx_dpe.h"
Excessive includes?

> +
> +static const int mid_array[DSS_CHN_MAX_DEFINE] = {
> +	0xb, 0xa, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x2, 0x1, 0x3, 0x0
> +};
> +
> +struct dpe_format {
> +	u32 pixel_format;
> +	enum dpe_fb_format dpe_format;
> +};
> +
> +/*
> + * FIXME: this driver was supposed to support 16 bpp with:
> + *
> + *       { DRM_FORMAT_RGB565, DPE_RGB_565 },
> + *       { DRM_FORMAT_BGR565, DPE_BGR_565 }
> + *
> + * However, those seem to be setting an YUYV mode.
> + * Using DRM_FORMAT_YUYV/DRM_FORMAT_UYVY doesn't currently work with X11,
> + * perhaps due to fb emulation. So, for now, let's just drop 16 bpp.
> + */
> +
> +static const struct dpe_format dpe_formats[] = {
> +	/* 24 bpp */
> +	{ DRM_FORMAT_XRGB8888, DPE_BGRX_8888 },
> +	{ DRM_FORMAT_XBGR8888, DPE_RGBX_8888 },
> +	/* 32 bpp */
> +	{ DRM_FORMAT_RGBA8888, DPE_RGBA_8888 },
> +	{ DRM_FORMAT_BGRA8888, DPE_BGRA_8888 },
> +	{ DRM_FORMAT_ARGB8888, DPE_RGBA_8888 },
> +	{ DRM_FORMAT_ABGR8888, DPE_BGRA_8888 },
> +};
> +
> +static const u32 dpe_channel_formats[] = {
> +	DRM_FORMAT_YUYV,
> +	DRM_FORMAT_UYVY,
> +	DRM_FORMAT_XRGB8888,
> +	DRM_FORMAT_XBGR8888,
> +	DRM_FORMAT_RGBA8888,
> +	DRM_FORMAT_BGRA8888,
> +	DRM_FORMAT_ARGB8888,
> +	DRM_FORMAT_ABGR8888,
> +};
> +
> +static u32 dpe_pixel_dma_format_map[] = {
> +	DMA_PIXEL_FORMAT_RGB_565,
> +	DMA_PIXEL_FORMAT_XRGB_4444,
> +	DMA_PIXEL_FORMAT_ARGB_4444,
> +	DMA_PIXEL_FORMAT_XRGB_5551,
> +	DMA_PIXEL_FORMAT_ARGB_5551,
> +	DMA_PIXEL_FORMAT_XRGB_8888,
> +	DMA_PIXEL_FORMAT_ARGB_8888,
> +	DMA_PIXEL_FORMAT_RGB_565,
> +	DMA_PIXEL_FORMAT_XRGB_4444,
> +	DMA_PIXEL_FORMAT_ARGB_4444,
> +	DMA_PIXEL_FORMAT_XRGB_5551,
> +	DMA_PIXEL_FORMAT_ARGB_5551,
> +	DMA_PIXEL_FORMAT_XRGB_8888,
> +	DMA_PIXEL_FORMAT_ARGB_8888,
> +	DMA_PIXEL_FORMAT_YUYV_422,
> +	DMA_PIXEL_FORMAT_YUV_422_SP_HP,
> +	DMA_PIXEL_FORMAT_YUV_422_SP_HP,
> +	DMA_PIXEL_FORMAT_YUV_420_SP_HP,
> +	DMA_PIXEL_FORMAT_YUV_420_SP_HP,
> +	DMA_PIXEL_FORMAT_YUV_422_P_HP,
> +	DMA_PIXEL_FORMAT_YUV_422_P_HP,
> +	DMA_PIXEL_FORMAT_YUV_420_P_HP,
> +	DMA_PIXEL_FORMAT_YUV_420_P_HP,
> +	DMA_PIXEL_FORMAT_YUYV_422,
> +	DMA_PIXEL_FORMAT_YUYV_422,
> +	DMA_PIXEL_FORMAT_YUYV_422,
> +	DMA_PIXEL_FORMAT_YUYV_422,
> +};
> +
> +static u32 dpe_pixel_dfc_format_map[] = {
> +	DFC_PIXEL_FORMAT_RGB_565,
> +	DFC_PIXEL_FORMAT_XBGR_4444,
> +	DFC_PIXEL_FORMAT_ABGR_4444,
> +	DFC_PIXEL_FORMAT_XBGR_5551,
> +	DFC_PIXEL_FORMAT_ABGR_5551,
> +	DFC_PIXEL_FORMAT_XBGR_8888,
> +	DFC_PIXEL_FORMAT_ABGR_8888,
> +	DFC_PIXEL_FORMAT_BGR_565,
> +	DFC_PIXEL_FORMAT_XRGB_4444,
> +	DFC_PIXEL_FORMAT_ARGB_4444,
> +	DFC_PIXEL_FORMAT_XRGB_5551,
> +	DFC_PIXEL_FORMAT_ARGB_5551,
> +	DFC_PIXEL_FORMAT_XRGB_8888,
> +	DFC_PIXEL_FORMAT_ARGB_8888,
> +	DFC_PIXEL_FORMAT_YUYV422,
> +	DFC_PIXEL_FORMAT_YUYV422,
> +	DFC_PIXEL_FORMAT_YVYU422,
> +	DFC_PIXEL_FORMAT_YUYV422,
> +	DFC_PIXEL_FORMAT_YVYU422,
> +	DFC_PIXEL_FORMAT_YUYV422,
> +	DFC_PIXEL_FORMAT_YVYU422,
> +	DFC_PIXEL_FORMAT_YUYV422,
> +	DFC_PIXEL_FORMAT_YVYU422,
> +	DFC_PIXEL_FORMAT_YUYV422,
> +	DFC_PIXEL_FORMAT_UYVY422,
> +	DFC_PIXEL_FORMAT_YVYU422,
> +	DFC_PIXEL_FORMAT_VYUY422,
> +};
> +
> +u32 dpe_get_format(struct dss_hw_ctx *ctx, u32 pixel_format)
> +{
> +	int i;
> +	const struct dpe_format *fmt = dpe_formats;
> +	u32 size = ARRAY_SIZE(dpe_formats);
> +
> +
> +	for (i = 0; i < size; i++) {
> +		if (fmt[i].pixel_format == pixel_format) {
> +			drm_info(ctx->dev, "requested fourcc %x, dpe format %d",
> +				 pixel_format, fmt[i].dpe_format);
> +			return fmt[i].dpe_format;
> +		}
> +	}
> +
> +	drm_err(ctx->dev, "Not found pixel format! fourcc = %x\n",
> +		pixel_format);
> +
> +	return HISI_FB_PIXEL_FORMAT_UNSUPPORT;
> +}
> +
> +u32 hisi_dss_get_channel_formats(struct drm_device *dev, u8 ch, const u32 **formats)
> +{
> +	*formats = dpe_channel_formats;
> +	return ARRAY_SIZE(dpe_channel_formats);
> +}
> +
> +static int hisi_dss_aif_ch_config(struct dss_hw_ctx *ctx, int chn_idx)
> +{
> +	void __iomem *aif0_ch_base;
> +	int mid = 0;
> +
> +	mid = mid_array[chn_idx];
> +	aif0_ch_base = ctx->base + ctx->g_dss_module_base[chn_idx][MODULE_AIF0_CHN];
> +
> +	set_reg(aif0_ch_base, 0x0, 1, 0);
> +	set_reg(aif0_ch_base, (uint32_t)mid, 4, 4);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_smmu_config(struct dss_hw_ctx *ctx, int chn_idx, bool mmu_enable)
> +{
> +	void __iomem *smmu_base;
> +	u32 idx = 0, i = 0;
> +
> +	smmu_base = ctx->base + ctx->smmu_offset;
> +
> +	for (i = 0; i < ctx->g_dss_chn_sid_num[chn_idx]; i++) {
> +		idx = ctx->g_dss_smmu_smrx_idx[chn_idx] + i;
> +		if (!mmu_enable) {
> +			set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 1, 32, 0);
> +		} else {
> +			/* set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 0x70, 32, 0); */
> +			set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 0x1C, 32, 0);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_mif_config(struct dss_hw_ctx *ctx, int chn_idx, bool mmu_enable)
> +{
> +	void __iomem *mif_base;
> +	void __iomem *mif_ch_base;
> +
> +	mif_base = ctx->base + DSS_MIF_OFFSET;
> +	mif_ch_base = ctx->base +
> +		ctx->g_dss_module_base[chn_idx][MODULE_MIF_CHN];
> +
> +	if (!mmu_enable)
> +		set_reg(mif_ch_base + MIF_CTRL1, 0x1, 1, 5);
> +	else
> +		set_reg(mif_ch_base + MIF_CTRL1, 0x00080000, 32, 0);
> +
> +	return 0;
> +}
> +
> +int hisi_dss_mctl_mutex_lock(struct dss_hw_ctx *ctx)
static?

> +{
> +	void __iomem *mctl_base;
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +
> +	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x1, 1, 0);
> +
> +	return 0;
> +}
> +
> +int hisi_dss_mctl_mutex_unlock(struct dss_hw_ctx *ctx)
static?

> +{
> +	void __iomem *mctl_base;
> +
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +
> +	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x0, 1, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_mctl_ov_config(struct dss_hw_ctx *ctx, int chn_idx)
> +{
> +	void __iomem *mctl_base;
> +	u32 mctl_rch_offset = 0;
> +
> +	mctl_rch_offset = (uint32_t)(MCTL_CTL_MUTEX_RCH0 + chn_idx * 0x4);
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +
> +	set_reg(mctl_base + MCTL_CTL_EN, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_TOP, 0x2, 32, 0); /* auto mode */
> +	set_reg(mctl_base + MCTL_CTL_DBG, 0xB13A00, 32, 0);
> +
> +	set_reg(mctl_base + mctl_rch_offset, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 2, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_DBUF, 0x1, 2, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_OV, 1 << DSS_OVL0, 4, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_mctl_sys_config(struct dss_hw_ctx *ctx, int chn_idx)
> +{
> +	void __iomem *mctl_sys_base;
> +
> +	u32 layer_idx = 0;
> +	u32 mctl_rch_ov_oen_offset = 0;
> +	u32 mctl_rch_flush_en_offset = 0;
> +
> +
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +	mctl_rch_ov_oen_offset = MCTL_RCH0_OV_OEN + chn_idx * 0x4;
> +	mctl_rch_flush_en_offset = MCTL_RCH0_FLUSH_EN + chn_idx * 0x4;
> +
> +	set_reg(mctl_sys_base + mctl_rch_ov_oen_offset,
> +		((1 << (layer_idx + 1)) | (0x100 << DSS_OVL0)), 32, 0);
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0xe, 4, 0);
> +	else
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0x8, 4, 0);
> +
> +	set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, chn_idx, 4, (layer_idx + 1) * 4);
> +
> +	set_reg(mctl_sys_base + MCTL_OV0_FLUSH_EN, 0xd, 4, 0);
> +	set_reg(mctl_sys_base + mctl_rch_flush_en_offset, 0x1, 32, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_rdma_config(struct dss_hw_ctx *ctx,
> +				const struct dss_rect_ltrb *rect,
> +				u32 display_addr, u32 hal_format,
> +				u32 bpp, int chn_idx, bool afbcd,
> +				bool mmu_enable)
> +{
> +	void __iomem *rdma_base;
> +
> +	u32 aligned_pixel = 0;
> +	u32 rdma_oft_x0 = 0;
> +	u32 rdma_oft_y0 = 0;
> +	u32 rdma_oft_x1 = 0;
> +	u32 rdma_oft_y1 = 0;
> +	u32 rdma_stride = 0;
> +	u32 rdma_format = 0;
> +	u32 stretch_size_vrt = 0;
> +
> +	u32 stride_align = 0;
> +	u32 mm_base_0 = 0;
> +	u32 mm_base_1 = 0;
> +
> +	u32 afbcd_header_addr = 0;
> +	u32 afbcd_header_stride = 0;
> +	u32 afbcd_payload_addr = 0;
> +	u32 afbcd_payload_stride = 0;
> +
> +	rdma_base = ctx->base +
> +		ctx->g_dss_module_base[chn_idx][MODULE_DMA];
> +
> +	aligned_pixel = DMA_ALIGN_BYTES / bpp;
> +	rdma_oft_x0 = rect->left / aligned_pixel;
> +	rdma_oft_y0 = rect->top;
> +	rdma_oft_x1 = rect->right / aligned_pixel;
> +	rdma_oft_y1 = rect->bottom;
> +
> +	rdma_format = dpe_pixel_dma_format_map[hal_format];
> +
> +	if (afbcd) {
> +		mm_base_0 = 0;
> +		mm_base_1 = mm_base_0 + rect->right * bpp * MMBUF_LINE_NUM;
> +		mm_base_0 = ALIGN(mm_base_0, MMBUF_ADDR_ALIGN);
> +		mm_base_1 = ALIGN(mm_base_1, MMBUF_ADDR_ALIGN);
> +
> +		if ((((rect->right - rect->left) + 1) & (ctx->afbc_header_addr_align - 1)) ||
> +		    (((rect->bottom - rect->top) + 1) & (AFBC_BLOCK_ALIGN - 1))) {
> +			drm_err(ctx->dev,
> +				"img width(%d) is not %d bytes aligned, or img height (%d) is not %d bytes aligned!\n",
> +				((rect->right - rect->left) + 1),
> +				ctx->afbc_header_addr_align,
> +				((rect->bottom - rect->top) + 1),
> +				AFBC_BLOCK_ALIGN);
> +		}
> +
> +		if ((mm_base_0 & (MMBUF_ADDR_ALIGN - 1)) || (mm_base_1 & (MMBUF_ADDR_ALIGN - 1))) {
> +			drm_err(ctx->dev,
> +				"mm_base_0(0x%x) is not %d bytes aligned, or mm_base_1(0x%x) is not %d bytes aligned!\n",
> +				mm_base_0, MMBUF_ADDR_ALIGN,
> +				mm_base_1, MMBUF_ADDR_ALIGN);
> +		}
> +		/* header */
> +		afbcd_header_stride = (((rect->right - rect->left) + 1) / AFBC_BLOCK_ALIGN) * AFBC_HEADER_STRIDE_BLOCK;
> +		afbcd_header_addr = (uint32_t)(unsigned long)display_addr;
> +
> +		/* payload */
> +		if (bpp == 4)
> +			stride_align = AFBC_PAYLOAD_STRIDE_ALIGN_32;
> +		else if (bpp == 2)
> +			stride_align = AFBC_PAYLOAD_STRIDE_ALIGN_16;
> +		else
> +			drm_err(ctx->dev,"bpp(%d) not supported!\n", bpp);
> +
> +		afbcd_payload_stride = (((rect->right - rect->left) + 1) / AFBC_BLOCK_ALIGN) * stride_align;
> +
> +		afbcd_payload_addr = afbcd_header_addr + ALIGN(16 * (((rect->right - rect->left) + 1) / 16) *
> +				(((rect->bottom - rect->top) + 1) / 16), 1024);
> +		afbcd_payload_addr = afbcd_payload_addr +
> +			(rect->top / AFBC_BLOCK_ALIGN) * afbcd_payload_stride +
> +			(rect->left / AFBC_BLOCK_ALIGN) * stride_align;
> +
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(rdma_base + DMA_OFT_X0, rdma_oft_x0, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y0, rdma_oft_y0, 16, 0);
> +		set_reg(rdma_base + DMA_OFT_X1, rdma_oft_x1, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y1, rdma_oft_y1, 16, 0);
> +		set_reg(rdma_base + DMA_STRETCH_SIZE_VRT, (rect->bottom - rect->top), 13, 0);
> +		set_reg(rdma_base + DMA_CTRL, rdma_format, 5, 3);
> +		set_reg(rdma_base + DMA_CTRL, (mmu_enable ? 0x1 : 0x0), 1, 8);
> +
> +		set_reg(rdma_base + AFBCD_HREG_PIC_WIDTH, (rect->right - rect->left), 16, 0);
> +		set_reg(rdma_base + AFBCD_HREG_PIC_HEIGHT, (rect->bottom - rect->top), 16, 0);
> +		set_reg(rdma_base + AFBCD_CTL, AFBC_HALF_BLOCK_UPPER_LOWER_ALL, 2, 6);
> +		set_reg(rdma_base + AFBCD_HREG_HDR_PTR_LO, afbcd_header_addr, 32, 0);
> +		set_reg(rdma_base + AFBCD_INPUT_HEADER_STRIDE, afbcd_header_stride, 14, 0);
> +		set_reg(rdma_base + AFBCD_PAYLOAD_STRIDE, afbcd_payload_stride, 20, 0);
> +		set_reg(rdma_base + AFBCD_MM_BASE_0, mm_base_0, 32, 0);
> +		set_reg(rdma_base + AFBCD_HREG_FORMAT, 0x1, 1, 21);
> +		set_reg(rdma_base + AFBCD_SCRAMBLE_MODE, 0x0, 32, 0);
> +		set_reg(rdma_base + AFBCD_AFBCD_PAYLOAD_POINTER, afbcd_payload_addr, 32, 0);
> +		set_reg(rdma_base + AFBCD_HEIGHT_BF_STR, (rect->bottom - rect->top), 16, 0);
> +
> +		set_reg(rdma_base + CH_CTL, 0xf005, 32, 0);
> +	} else {
> +		stretch_size_vrt = rdma_oft_y1 - rdma_oft_y0;
> +		rdma_stride = ((rect->right - rect->left) + 1) * bpp / DMA_ALIGN_BYTES;
> +
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x0, 32, 0);
> +
> +		set_reg(rdma_base + DMA_OFT_X0, rdma_oft_x0, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y0, rdma_oft_y0, 16, 0);
> +		set_reg(rdma_base + DMA_OFT_X1, rdma_oft_x1, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y1, rdma_oft_y1, 16, 0);
> +		set_reg(rdma_base + DMA_CTRL, rdma_format, 5, 3);
> +		set_reg(rdma_base + DMA_CTRL, (mmu_enable ? 0x1 : 0x0), 1, 8);
> +		set_reg(rdma_base + DMA_CTRL, 0x130, 32, 0);
> +		set_reg(rdma_base + DMA_STRETCH_SIZE_VRT, stretch_size_vrt, 32, 0);
> +		set_reg(rdma_base + DMA_DATA_ADDR0, display_addr, 32, 0);
> +		set_reg(rdma_base + DMA_STRIDE0, rdma_stride, 13, 0);
> +
> +		set_reg(rdma_base + CH_CTL, 0x1, 1, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_rdfc_config(struct dss_hw_ctx *ctx,
> +				const struct dss_rect_ltrb *rect,
> +				u32 hal_format, u32 bpp, int chn_idx)
> +{
> +	void __iomem *rdfc_base;
> +
> +	u32 dfc_pix_in_num = 0;
> +	u32 size_hrz = 0;
> +	u32 size_vrt = 0;
> +	u32 dfc_fmt = 0;
> +
> +	rdfc_base = ctx->base +
> +		ctx->g_dss_module_base[chn_idx][MODULE_DFC];
> +
> +	dfc_pix_in_num = (bpp <= 2) ? 0x1 : 0x0;
> +	size_hrz = rect->right - rect->left;
> +	size_vrt = rect->bottom - rect->top;
> +
> +	dfc_fmt = dpe_pixel_dfc_format_map[hal_format];
> +
> +	set_reg(rdfc_base + DFC_DISP_SIZE, (size_vrt | (size_hrz << 16)),
> +		29, 0);
> +	set_reg(rdfc_base + DFC_PIX_IN_NUM, dfc_pix_in_num, 1, 0);
> +	set_reg(rdfc_base + DFC_DISP_FMT, dfc_fmt, 5, 1);
> +	set_reg(rdfc_base + DFC_CTL_CLIP_EN, 0x1, 1, 0);
> +	set_reg(rdfc_base + DFC_ICG_MODULE, 0x1, 1, 0);
> +
> +	return 0;
> +}
> +
> +int hisi_dss_ovl_base_config(struct dss_hw_ctx *ctx, u32 xres, u32 yres)
> +{
> +	void __iomem *mctl_sys_base;
> +	void __iomem *mctl_base;
> +	void __iomem *ovl0_base;
> +
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +	ovl0_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_OVL_BASE];
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +
> +		set_reg(ovl0_base + OV_BG_COLOR_RGB, 0x00000000, 32, 0);
> +		set_reg(ovl0_base + OV_BG_COLOR_A, 0x00000000, 32, 0);
> +		set_reg(ovl0_base + OV_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OV_DST_ENDPOS, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_GCFG, 0x10001, 32, 0);
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0xE, 4, 0);
> +	} else {
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) | ((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_BG_COLOR, 0xFF000000, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_ENDPOS, (xres - 1) | ((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_GCFG, 0x10001, 32, 0);
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0x8, 4, 0);
> +	}
> +
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_DBUF, 0x1, 2, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_OV, 1 << DSS_OVL0, 4, 0);
> +	set_reg(mctl_sys_base + MCTL_OV0_FLUSH_EN, 0xd, 4, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_ovl_config(struct dss_hw_ctx *ctx,
> +			       const struct dss_rect_ltrb *rect, u32 xres, u32 yres)
> +{
> +	void __iomem *ovl0_base;
> +
> +	ovl0_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_OVL_BASE];
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_BG_COLOR_RGB, 0x3FF00000, 32, 0);
> +		set_reg(ovl0_base + OV_BG_COLOR_A, 0x3ff, 32, 0);
> +
> +		set_reg(ovl0_base + OV_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OV_DST_ENDPOS, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_GCFG, 0x10001, 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_POS, (rect->left) |
> +			((rect->top) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_SIZE, (rect->right) |
> +			((rect->bottom) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_ALPHA_MODE, 0x1004000, 32, 0); /* NEED CHECK? */
> +		set_reg(ovl0_base + OV_LAYER0_ALPHA_A, 0x3ff03ff, 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_CFG, 0x1, 1, 0);
> +	} else {
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_BG_COLOR, 0xFFFF0000, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_ENDPOS, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_GCFG, 0x10001, 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_POS, (rect->left) |
> +			((rect->top) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_SIZE, (rect->right) |
> +			((rect->bottom) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_ALPHA, 0x00ff40ff, 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_CFG, 0x1, 1, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static void hisi_dss_qos_on(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *noc_dss_base;
> +
> +	noc_dss_base = ctx->noc_dss_base;
> +
> +	writel(0x2, noc_dss_base + 0xc);
> +	writel(0x2, noc_dss_base + 0x8c);
> +	writel(0x2, noc_dss_base + 0x10c);
> +	writel(0x2, noc_dss_base + 0x18c);
> +}
> +
> +static void hisi_dss_mif_on(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *dss_base;
> +	char __iomem *mif_base;
> +
> +	dss_base = ctx->base;
> +	mif_base = ctx->base + DSS_MIF_OFFSET;
> +
> +	set_reg(mif_base + MIF_ENABLE, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH0_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH1_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH2_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH3_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH4_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH5_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH6_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH7_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH8_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH9_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +
> +	set_reg(dss_base + MIF_CH10_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH11_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +}
> +
> +void hisi_dss_smmu_on(struct dss_hw_ctx *ctx)
static?

> +{
> +#if 0
> +/*
> + * FIXME:
> + *
> + * Right now, the IOMMU support is actually disabled. See the caller of
> + * hisi_dss_smmu_config(). Yet, if we end enabling it, this should be
> + * ported to use io-pgtable directly.
> + */
> +	void __iomem *smmu_base;
> +	struct iommu_domain_data *domain_data = NULL;
> +	u32 phy_pgd_base = 0;
> +	u64 fama_phy_pgd_base;
> +
> +	smmu_base = ctx->base + ctx->smmu_offset;
> +
> +	set_reg(smmu_base + SMMU_SCR, 0x0, 1, 0);  /* global bypass cancel */
> +	set_reg(smmu_base + SMMU_SCR, 0x1, 8, 20); /* ptw_mid */
> +	set_reg(smmu_base + SMMU_SCR, 0xf, 4, 16); /* pwt_pf */
> +	set_reg(smmu_base + SMMU_SCR, 0x7, 3, 3);  /* interrupt cachel1 cach3l2 en */
> +	set_reg(smmu_base + SMMU_LP_CTRL, 0x1, 1, 0);  /* auto_clk_gt_en */
> +
> +	/* Long Descriptor */
> +	set_reg(smmu_base + SMMU_CB_TTBCR, 0x1, 1, 0);
> +
> +	set_reg(smmu_base + SMMU_ERR_RDADDR, 0x7FF00000, 32, 0);
> +	set_reg(smmu_base + SMMU_ERR_WRADDR, 0x7FFF0000, 32, 0);
> +
> +	/* disable cmdlist, dbg, reload */
> +	set_reg(smmu_base + SMMU_RLD_EN0_NS, DSS_SMMU_RLD_EN0_DEFAULT_VAL, 32, 0);
> +	set_reg(smmu_base + SMMU_RLD_EN1_NS, DSS_SMMU_RLD_EN1_DEFAULT_VAL, 32, 0);
> +
> +	/* cmdlist stream bypass */
> +	set_reg(smmu_base + SMMU_SMRx_NS + 36 * 0x4, 0x1, 32, 0); /* debug stream id */
> +	set_reg(smmu_base + SMMU_SMRx_NS + 37 * 0x4, 0x1, 32, 0); /* cmd unsec stream id */
> +	set_reg(smmu_base + SMMU_SMRx_NS + 38 * 0x4, 0x1, 32, 0); /* cmd sec stream id */
> +
> +	/* TTBR0 */
> +	domain_data = (struct iommu_domain_data *)(ctx->mmu_domain->priv);
> +	fama_phy_pgd_base = domain_data->phy_pgd_base;
> +	phy_pgd_base = (uint32_t)(domain_data->phy_pgd_base);
> +	drm_dbg(ctx->dev,
> +		"fama_phy_pgd_base = %llu, phy_pgd_base =0x%x\n",
> +		fama_phy_pgd_base, phy_pgd_base);
> +	set_reg(smmu_base + SMMU_CB_TTBR0, phy_pgd_base, 32, 0);
> +#endif
> +}
> +
> +void hisifb_dss_on(struct dss_hw_ctx *ctx)
> +{
> +	/* dss qos on */
> +	hisi_dss_qos_on(ctx);
> +	/* mif on */
> +	hisi_dss_mif_on(ctx);
> +	/* smmu on */
> +	hisi_dss_smmu_on(ctx);
> +}
> +
> +void hisi_dss_mctl_on(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *mctl_base = NULL;
> +	char __iomem *mctl_sys_base = NULL;
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_MCTL0][MODULE_MCTL_BASE];
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +
> +	set_reg(mctl_base + MCTL_CTL_EN, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_DBG, 0xB13A00, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_TOP, 0x2, 32, 0);
> +}
> +
> +void hisi_dss_unflow_handler(struct dss_hw_ctx *ctx, bool unmask)
static?
> +{
> +	void __iomem *dss_base;
> +	u32 tmp = 0;
> +
> +	dss_base = ctx->base;
> +
> +	tmp = readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +	if (unmask)
> +		tmp &= ~BIT_LDI_UNFLOW;
> +	else
> +		tmp |= BIT_LDI_UNFLOW;
> +
> +	writel(tmp, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +}
> +
> +void hisifb_mctl_sw_clr(struct dss_crtc *acrtc)
> +{
> +	char __iomem *mctl_base = NULL;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	int mctl_status;
> +	int delay_count = 0;
> +	bool is_timeout;
> +
> +	mctl_base = ctx->base +
> +		    ctx->g_dss_module_ovl_base[DSS_MCTL0][MODULE_MCTL_BASE];
> +
> +	if (mctl_base)
> +		set_reg(mctl_base + MCTL_CTL_CLEAR, 0x1, 1, 0);
> +
> +	while (1) {
> +		mctl_status = readl(mctl_base + MCTL_CTL_STATUS);
> +		if (((mctl_status & 0x10) == 0) || (delay_count > 500)) {
> +			is_timeout = (delay_count > 100) ? true : false;
> +			delay_count = 0;
> +			break;
> +		}
> +
> +		udelay(1);
> +		++delay_count;
> +	}
> +
> +	if (is_timeout)
> +		drm_err(ctx->dev, "mctl_status =0x%x !\n", mctl_status);
> +
> +	enable_ldi(acrtc);
> +	DRM_INFO("-.\n");
> +}
> +
> +void hisi_fb_pan_display(struct drm_plane *plane)
> +{
> +	struct drm_plane_state *state = plane->state;
> +	struct drm_framebuffer *fb = state->fb;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	struct dss_plane *aplane = to_dss_plane(plane);
> +	struct dss_crtc *acrtc = aplane->acrtc;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	struct drm_gem_cma_object *obj = drm_fb_cma_get_gem_obj(state->fb, 0);
> +
> +	bool afbcd = false;
> +	bool mmu_enable = false;
> +	struct dss_rect_ltrb rect;
> +	u32 bpp;
> +	u32 stride;
> +	u32 display_addr = 0;
> +	u32 hal_fmt;
> +	int chn_idx = DSS_RCHN_D2;
> +
> +	int crtc_x = state->crtc_x;
> +	int crtc_y = state->crtc_y;
> +	unsigned int crtc_w = state->crtc_w;
> +	unsigned int crtc_h = state->crtc_h;
> +	u32 src_x = state->src_x >> 16;
> +	u32 src_y = state->src_y >> 16;
> +	u32 src_w = state->src_w >> 16;
> +	u32 src_h = state->src_h >> 16;
> +
> +	u32 hfp, hbp, hsw, vfp, vbp, vsw;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	bpp = fb->format->cpp[0];
> +	stride = fb->pitches[0];
> +
> +	display_addr = (u32)obj->paddr + src_y * stride;
> +
> +	rect.left = 0;
> +	rect.right = src_w - 1;
> +	rect.top = 0;
> +	rect.bottom = src_h - 1;
> +	hal_fmt = dpe_get_format(ctx, fb->format->format);
> +
> +	drm_dbg(ctx->dev,
> +		"channel%d: src:(%d,%d, %dx%d) crtc:(%d,%d, %dx%d), rect(%d,%d,%d,%d),fb:%dx%d, pixel_format=%d, stride=%d, paddr=0x%x, bpp=%d.\n",
> +			 chn_idx, src_x, src_y, src_w, src_h,
> +			 crtc_x, crtc_y, crtc_w, crtc_h,
> +			 rect.left, rect.top, rect.right, rect.bottom,
> +			 fb->width, fb->height, hal_fmt,
> +			 stride, display_addr, bpp);
> +
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	hsw = mode->hsync_end - mode->hsync_start;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	vsw = mode->vsync_end - mode->vsync_start;
The above varaibles are assinged but not used - delete them?

> +
> +	hisi_dss_mctl_mutex_lock(ctx);
> +	hisi_dss_aif_ch_config(ctx, chn_idx);
> +	hisi_dss_mif_config(ctx, chn_idx, mmu_enable);
> +	hisi_dss_smmu_config(ctx, chn_idx, mmu_enable);
> +
> +	hisi_dss_rdma_config(ctx, &rect, display_addr, hal_fmt, bpp, chn_idx, afbcd, mmu_enable);
> +	hisi_dss_rdfc_config(ctx, &rect, hal_fmt, bpp, chn_idx);
> +	hisi_dss_ovl_config(ctx, &rect, mode->hdisplay, mode->vdisplay);
> +
> +	hisi_dss_mctl_ov_config(ctx, chn_idx);
> +	hisi_dss_mctl_sys_config(ctx, chn_idx);
> +	hisi_dss_mctl_mutex_unlock(ctx);
> +	hisi_dss_unflow_handler(ctx, true);
> +
> +	enable_ldi(acrtc);
> +}
