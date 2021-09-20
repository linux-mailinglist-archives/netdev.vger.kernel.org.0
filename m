Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7917D411191
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbhITJH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:07:29 -0400
Received: from www.zeus03.de ([194.117.254.33]:54170 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236076AbhITJHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 05:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=8Ic7rPl8wS6tSUDgDBOpnPfgXT8
        diIPVuuJEV7+3x14=; b=y3zScd6qLqQkIP3VZO9fvHA8J6/TlWpstJuxEWG+2wh
        RSUW1mVxF26O2U33Dq6EbBJ3XmayRck4KWgT5z4BxcgklO7B+9wEmZO5zVAmdCUU
        eq691H+mkSBSVXJ5b+Z4iTQ6tBhA1RnGtNmi7NlL+YGjQ7U1KmJ/dc6bhwHIpZnk
        =
Received: (qmail 2412526 invoked from network); 20 Sep 2021 11:05:23 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 20 Sep 2021 11:05:23 +0200
X-UD-Smtp-Session: l3s3148p1@Lz7AlGnMBosgAwDPXwlxANIWpbLKE1Uh
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH 0/9] treewide: simplify getting .driver_data
Date:   Mon, 20 Sep 2021 11:05:12 +0200
Message-Id: <20210920090522.23784-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got tired of fixing this in Renesas drivers manually, so I took the big
hammer. Remove this cumbersome code pattern which got copy-pasted too much
already:

-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_keypad *keypad = platform_get_drvdata(pdev);
+	struct ep93xx_keypad *keypad = dev_get_drvdata(dev);

A branch, tested by buildbot, can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git coccinelle/get_drvdata

I am open for other comments, suggestions, too, of course.

Here is the cocci-script I created:

@@
struct device* d;
identifier pdev;
expression *ptr;
@@
(
-	struct platform_device *pdev = to_platform_device(d);
|
-	struct platform_device *pdev;
	...
-	pdev = to_platform_device(d);
)
	<... when != pdev
-	&pdev->dev
+	d
	...>

	ptr =
-	platform_get_drvdata(pdev)
+	dev_get_drvdata(d)

	<... when != pdev
-	&pdev->dev
+	d
	...>

Kind regards,

   Wolfram


Wolfram Sang (9):
  dmaengine: stm32-dmamux: simplify getting .driver_data
  firmware: meson: simplify getting .driver_data
  gpio: xilinx: simplify getting .driver_data
  drm/msm: simplify getting .driver_data
  drm/panfrost: simplify getting .driver_data
  iio: common: cros_ec_sensors: simplify getting .driver_data
  net: mdio: mdio-bcm-iproc: simplify getting .driver_data
  platform: chrome: cros_ec_sensorhub: simplify getting .driver_data
  remoteproc: omap_remoteproc: simplify getting .driver_data

 drivers/dma/stm32-dmamux.c                         | 14 +++++---------
 drivers/firmware/meson/meson_sm.c                  |  3 +--
 drivers/gpio/gpio-xilinx.c                         |  6 ++----
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            | 13 +++++--------
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |  6 ++----
 drivers/gpu/drm/msm/dp/dp_display.c                |  6 ++----
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  6 ++----
 drivers/gpu/drm/msm/msm_drv.c                      |  3 +--
 drivers/gpu/drm/panfrost/panfrost_device.c         |  6 ++----
 .../common/cros_ec_sensors/cros_ec_sensors_core.c  |  3 +--
 drivers/net/mdio/mdio-bcm-iproc.c                  |  3 +--
 drivers/platform/chrome/cros_ec_sensorhub.c        |  6 ++----
 drivers/remoteproc/omap_remoteproc.c               |  6 ++----
 13 files changed, 28 insertions(+), 53 deletions(-)

-- 
2.30.2

