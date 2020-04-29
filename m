Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B909E1BE84E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgD2URS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2URQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:16 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3402C03C1AE;
        Wed, 29 Apr 2020 13:17:15 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x18so4129119wrq.2;
        Wed, 29 Apr 2020 13:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cq2CMCfNFIo7pBX1TF7b/dKJdrRkh6g3At8GmpCqDn4=;
        b=tqN2p6cbLg38vJgSeASbAQo1ovE3VIDD2t6o+S/8v2Lg93Hj7R1SKjQY/BzKe6J993
         NeQdaiwezZodZrXhrRQUyCAblQK4cEY4lihoGyIkxM3x+XHfvlCMWfvJ4MeHjxuIV/Vk
         5QLthzNaA/zn+hDa8T2iIllR1IDkd5wEjhPPu05sOHFBwtbWd5dwlGQpNBDcms5I6+cU
         XZJR1oo9AKQ3xWOi21Jp2EFNjMCSUotqDSq9j8kxEyDdSr/4vlN/EWuc8901AvJDobln
         Ho/dLv8zBDCb+Jw+HU6qBl7nbc0eg36OUpCKAUz4UdtRpxQFDO7maikXG1YkZZfRI3K/
         DwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cq2CMCfNFIo7pBX1TF7b/dKJdrRkh6g3At8GmpCqDn4=;
        b=SEB+oBZaVq8W+kVmJjhiYwWoByw9AsUL3GI0FpJZMY26pUaZ8IRo8Y9Wu4n/0NNHKH
         Rgk6EoO6VmL3M7bd2VQJ1m1+i4UkUowUJNXP6bQlCdtOG70e1NkZrxAqqrwfbMuR2jdX
         vls+Gm1/OvYYR2YUFgdruk46nnAMTDnvVV2YLXQp3lMIoQFOvlHR20J0C+ndIudAM9Nj
         CFpe8Iq8+4tebgicOxFg3+aJu7N4KBeVB8MC5Gc085W3yHG+D2LCYLEZitRLDPi3Kkxn
         1r0t5ytFjLnOj16/+JS2kxFiOxlt2VR5oAxr//1mPbB29NAOAG29a3pf3gzWA0Hsvyck
         7Fuw==
X-Gm-Message-State: AGi0Pub3BYt1e8kb01e+GjfZlsnsbsYsXqdL3sJjwY/cOB0rJ0+Gy697
        2QmRIpnVERdQ93NHrTSM9HE=
X-Google-Smtp-Source: APiQypKKrc+VsYDd27uw8w+8me5jo1cYxiOApSLcXUWgmctOf6zkILYraWmMsPldaTWfAC2eBy2dKQ==
X-Received: by 2002:a5d:4cd0:: with SMTP id c16mr38575871wrt.98.1588191434647;
        Wed, 29 Apr 2020 13:17:14 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:14 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 03/11] net: stmmac: dwmac-meson8b: use FIELD_PREP instead of open-coding it
Date:   Wed, 29 Apr 2020 22:16:36 +0200
Message-Id: <20200429201644.1144546-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use FIELD_PREP() to shift a value to the correct offset based on a
bitmask instead of open-coding the logic.
No functional changes.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index a3934ca6a043..c9ec0cb68082 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2016 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/device.h>
@@ -32,7 +33,6 @@
 #define PRG_ETH0_CLK_M250_SEL_SHIFT	4
 #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
 
-#define PRG_ETH0_TXDLY_SHIFT		5
 #define PRG_ETH0_TXDLY_MASK		GENMASK(6, 5)
 
 /* divider for the result of m250_sel */
@@ -262,7 +262,8 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 					PRG_ETH0_INVERTED_RMII_CLK, 0);
 
 		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0, PRG_ETH0_TXDLY_MASK,
-					tx_dly_val << PRG_ETH0_TXDLY_SHIFT);
+					FIELD_PREP(PRG_ETH0_TXDLY_MASK,
+						   tx_dly_val));
 
 		/* Configure the 125MHz RGMII TX clock, the IP block changes
 		 * the output automatically (= without us having to configure
-- 
2.26.2

