Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57AE249C51
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHSLrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbgHSLqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 07:46:23 -0400
Received: from mail.kernel.org (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E29F20885;
        Wed, 19 Aug 2020 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597837581;
        bh=+NoH4YjX5TxAfeB92q3/7g03nc1yFW/oR0B99A6AIA8=;
        h=From:To:Cc:Subject:Date:From;
        b=Ic+Hs2SPR5TjgN0Q8ckou8MEnmbrDMOVcj2W8hjSCq0u38W2GCsoGl09f2uLpU9Al
         HIxIPeMTB6kZq5hWg169GVEsgyuyl159tEDpAj4/kGhH2B+yIwMzAR1ucVQJhR6B3l
         BerRTWVmuFQT7pZZG3nReu4CGsxfb6mXqVE8M/QU=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1k8MXq-00EuZw-R7; Wed, 19 Aug 2020 13:46:18 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Liwei Cai <cailiwei@hisilicon.com>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        devel@driverdev.osuosl.org, bpf@vger.kernel.org,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        linux-media@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        devicetree@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Liuyao An <anliuyao@huawei.com>,
        linaro-mm-sig@lists.linaro.org, Wei Xu <xuwei5@hisilicon.com>,
        Rongrong Zou <zourongrong@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>, netdev@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Chen Feng <puck.chen@hisilicon.com>
Subject: [PATCH 00/49] DRM driver for Hikey 970
Date:   Wed, 19 Aug 2020 13:45:28 +0200
Message-Id: <cover.1597833138.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series port the out-of-tree driver for Hikey 970 (which
should also support Hikey 960) from the official 96boards tree:

   https://github.com/96boards-hikey/linux/tree/hikey970-v4.9

Based on his history, this driver seems to be originally written
for Kernel 4.4, and was later ported to Kernel 4.9. The original
driver used to depend on ION (from Kernel 4.4) and had its own
implementation for FB dev API.

As I need to preserve the original history (with has patches from
both HiSilicon and from Linaro),  I'm starting from the original
patch applied there. The remaining patches are incremental,
and port this driver to work with upstream Kernel.

This driver doesn't depend on any firmware or on any special
userspace code. It works as-is with both X11 and Wayland.

Yet, I'm submitting it via staging due to the following reasons:

- It depends on the LDO3 power supply, which is provided by
  a regulator driver that it is currently on staging;
- Due to legal reasons, I need to preserve the authorship of
  each one responsbile for each patch. So, I need to start from
  the original patch from Kernel 4.4;
- There are still some problems I need to figure out how to solve:
   - The adv7535 can't get EDID data. Maybe it is a timing issue,
     but it requires more research to be sure about how to solve it;
   - The driver only accept resolutions on a defined list, as there's
     a known bug that this driver may have troubles with random
     resolutions. Probably due to a bug at the pixel clock settings;
   - Sometimes (at least with 1080p), it generates LDI underflow
     errors, which in turn causes the DRM to stop working. That
     happens for example when using gdm on Wayland and
     gnome on X11;
   - Probably related to the previous issue, when the monitor
     suspends due to DPMS, it doesn't return back to life.

So, IMO, the best is to keep it on staging for a while, until those
remaining bugs gets solved.

I added this series, together with the regulator driver and
a few other patches (including a hack to fix a Kernel 5.8 
regression at WiFi ) at:

	https://gitlab.freedesktop.org/mchehab_kernel/hikey-970/-/commits/master


Chen Feng (1):
  staging: hikey9xx: Add hisilicon DRM driver for hikey960/970

John Stultz (1):
  staging: hikey9xx/gpu: port it to work with Kernel v4.9

Liwei Cai (2):
  staging: hikey9xx/gpu: solve tearing issue of display
  staging: hikey9xx/gpu: resolve the performance issue by interrupt
    mechanism

Mauro Carvalho Chehab (38):
  staging: hikey9xx/gpu: get rid of adv7535 fork
  staging: hikey9xx/gpu: rename the Kirin9xx namespace
  staging: hikey9xx/gpu: get rid of kirin9xx_fbdev.c
  staging: hikey9xx/gpu: get rid of some ifdefs
  staging: hikey9xx/gpu: rename the config option for Kirin970
  staging: hikey9xx/gpu: change the includes to reflect upstream
  staging: hikey9xx/gpu: port driver to upstream kAPIs
  staging: hikey9xx/gpu: add a copy of set_reg() function there
  staging: hikey9xx/gpu: get rid of ION headers
  staging: hikey9xx/gpu: add support for using a reserved CMA memory
  staging: hikey9xx/gpu: cleanup encoder attach logic
  staging: hikey9xx/gpu: Change the logic which sets the burst mode
  staging: hikey9xx/gpu: fix the DRM setting logic
  staging: hikey9xx/gpu: do some code cleanups
  staging: hikey9xx/gpu: use default GEM_CMA fops
  staging: hikey9xx/gpu: place vblank enable/disable at the right place
  staging: hikey9xx/gpu: remove an uneeded hack
  staging: hikey9xx/gpu: add a possible implementation for
    atomic_disable
  staging: hikey9xx/gpu: register connector
  staging: hikey9xx/gpu: fix driver name
  staging: hikey9xx/gpu: get rid of iommu_format
  staging: hikey9xx/gpu: re-work the mode validation code
  staging: hikey9xx/gpu: add support for enable/disable ldo3 regulator
  staging: hikey9xx/gpu: add SPMI headers
  staging: hikey9xx/gpu: solve most coding style issues
  staging: hikey9xx/gpu: don't use iommu code
  staging: hikey9xx/gpu: add kirin9xx driver to the building system
  staging: hikey9xx/gpu: get rid of typedefs
  staging: hikey9xx/gpu: get rid of input/output macros
  staging: hikey9xx/gpu: get rid of some unused data
  staging: hikey9xx/gpu: place common definitions at kirin9xx_dpe.h
  staging: hikey9xx/gpu: get rid of DRM_HISI_KIRIN970
  dts: hisilicon: hi3670.dtsi: add I2C settings
  dts: hikey970-pinctrl.dtsi: add missing pinctrl settings
  dt: hisilicon: add support for the PMIC found on Hikey 970
  dts: add support for Hikey 970 DRM
  staging: hikey9xx/gpu: drop kirin9xx_pwm
  dt: display: Add binds for the DPE and DSI controller for Kirin
    960/970

Xiubin Zhang (7):
  staging: hikey9xx/gpu: add support to hikey970 HDMI and panel
  staging: hikey9xx/gpu: Solve SR Cannot Display Problems.
  staging: hikey9xx/gpu: Solve HDMI compatibility Problem.
  staging: hikey9xx/gpu: Support MIPI DSI 3 lanes for hikey970.
  staging: hikey9xx/gpu: Solve SR test reset problem for hikey970.
  staging: hikey9xx/gpu: add debug prints for this driver
  staging: hikey9xx/gpu: Add support 10.1 inch special HDMI displays.

 .../display/hisilicon,hi3660-dpe.yaml         |   99 +
 .../display/hisilicon,hi3660-dsi.yaml         |  102 +
 .../boot/dts/hisilicon/hi3670-hikey970.dts    |   56 +-
 arch/arm64/boot/dts/hisilicon/hi3670.dtsi     |   77 +
 .../boot/dts/hisilicon/hikey970-drm.dtsi      |   93 +
 .../boot/dts/hisilicon/hikey970-pinctrl.dtsi  |  548 +++-
 .../boot/dts/hisilicon/hikey970-pmic.dtsi     |  197 ++
 drivers/staging/hikey9xx/Kconfig              |    3 +
 drivers/staging/hikey9xx/Makefile             |    1 +
 drivers/staging/hikey9xx/gpu/Kconfig          |   22 +
 drivers/staging/hikey9xx/gpu/Makefile         |    9 +
 drivers/staging/hikey9xx/gpu/kirin960_defs.c  |  378 +++
 .../staging/hikey9xx/gpu/kirin960_dpe_reg.h   |  233 ++
 drivers/staging/hikey9xx/gpu/kirin970_defs.c  |  381 +++
 .../staging/hikey9xx/gpu/kirin970_dpe_reg.h   | 1188 ++++++++
 drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h   | 2437 +++++++++++++++++
 .../hikey9xx/gpu/kirin9xx_drm_dpe_utils.c     | 1178 ++++++++
 .../hikey9xx/gpu/kirin9xx_drm_dpe_utils.h     |  286 ++
 .../staging/hikey9xx/gpu/kirin9xx_drm_drv.c   |  368 +++
 .../staging/hikey9xx/gpu/kirin9xx_drm_drv.h   |   57 +
 .../staging/hikey9xx/gpu/kirin9xx_drm_dss.c   | 1063 +++++++
 .../hikey9xx/gpu/kirin9xx_drm_overlay_utils.c | 1005 +++++++
 .../hikey9xx/gpu/kirin9xx_dw_drm_dsi.c        | 2132 ++++++++++++++
 .../hikey9xx/gpu/kirin9xx_dw_dsi_reg.h        |  146 +
 .../staging/hikey9xx/gpu/kirin9xx_fb_panel.h  |  191 ++
 25 files changed, 12229 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/display/hisilicon,hi3660-dpe.yaml
 create mode 100644 Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.yaml
 create mode 100644 arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi
 create mode 100644 arch/arm64/boot/dts/hisilicon/hikey970-pmic.dtsi
 create mode 100644 drivers/staging/hikey9xx/gpu/Kconfig
 create mode 100644 drivers/staging/hikey9xx/gpu/Makefile
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin960_defs.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin960_dpe_reg.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin970_defs.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_drm_dss.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_dw_drm_dsi.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_dw_dsi_reg.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin9xx_fb_panel.h

-- 
2.26.2


