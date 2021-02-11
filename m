Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80F5318FA1
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBKQNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhBKQKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:10:37 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564C5C061574;
        Thu, 11 Feb 2021 08:09:53 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id w20so4532544qta.0;
        Thu, 11 Feb 2021 08:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nYkfx6kQ9UjotrPeVcc6dCj9wqjxlvymee7hnOlUZc4=;
        b=LVPVjtQgeneusnFr+M9czDicODB7ZIFrKpMTHljq/lc7hUOyQL0+w0uTOocM+uDr6n
         tD/74boY67io539d5+uyKYY+fj+t0QDS5O7JsF6kMnqFZ/WJ/o25Eid7BGiwRvgIvk8u
         hE004LAgJJ7KP9zdeqI1HF63wvVlGp1ML7GxTUEVQzmvbj4buNdr2enfI8b+gSn7uygo
         XBGhyAyA/VEjDRWsnlyovv7o87+gzhQT4gz6CB5EaXJsDgLCy5sryboB+ieWHppu8Fan
         2beGzI6B4F+Go42Y+zQUM1PnAd0uEKVUtezK+pPWvPcYfj6SjvdBMM6OzOBLwi3hHgUh
         lLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nYkfx6kQ9UjotrPeVcc6dCj9wqjxlvymee7hnOlUZc4=;
        b=fvYo2yjNaie0KMTFmzEHUOui3EeR24D08rk0kNs1janN4lbVke4waxM7FX9A3IQIAK
         q8x+/a4UqdeayqdMWY9f3Kk3CRLWmPeRMDZC9FKQq71Wpo0EsPNxbAPosOMsU6D+gxFc
         r4MPVwWeavUGYCxqaCzmh4vO0cVYDbxP502qzoWjYFj8IvAYl/ZuCz2Tl2GOxoz/+3o9
         eoTLPIsE9TFMGpci9rx6w9EhjplSSCKUOnCFovThW86G4MmUOMC+oVyBjCMIcOOwnIv9
         VmsXvg7gIsTA89ywXHi6VgNldEv5cAN8TD1TaYbEmSCtoT8lUErLSKRb0lWjyRyLUgmy
         SawQ==
X-Gm-Message-State: AOAM531PULGXbt9AGVqyumS24G/Gchf4ZkIEfnXu8FaN2ssu/pS5lMeI
        RUoyuBiAAj+5qCMzbanvPbk=
X-Google-Smtp-Source: ABdhPJxmo/BeMr4MJyAWSiHztW3MAQ9KoIYjGqXNHnjcFfYgB4/zjZZ/XYKsG5cITco9hyjR02FbnA==
X-Received: by 2002:aed:2022:: with SMTP id 31mr8161328qta.85.1613059792402;
        Thu, 11 Feb 2021 08:09:52 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:d9d4:9919:4b2f:f800])
        by smtp.googlemail.com with ESMTPSA id p188sm4223296qkf.40.2021.02.11.08.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:09:52 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH] enetc: auto select PHYLIB and MDIO_DEVRES
Date:   Thu, 11 Feb 2021 11:09:30 -0500
Message-Id: <20210211160930.1231035-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FSL_ENETC_MDIO use symbols from PHYLIB and MDIO_DEVRES, however they are
not auto selected.

ERROR: modpost: "__mdiobus_register" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
ERROR: modpost: "mdiobus_unregister" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
ERROR: modpost: "devm_mdiobus_alloc_size" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!

auto select MDIO_DEVRES and PHYLIB when FSL_ENETC_MDIO is selected.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index d99ea0f4e4a6..2ec3f8065e6d 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -28,6 +28,8 @@ config FSL_ENETC_VF
 config FSL_ENETC_MDIO
 	tristate "ENETC MDIO driver"
 	depends on PCI
+	select MDIO_DEVRES
+	select PHYLIB
 	help
 	  This driver supports NXP ENETC Central MDIO controller as a PCIe
 	  physical function (PF) device.
-- 
2.25.1

