Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C3BDE162
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfJUAKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:15 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37562 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:14 -0400
Received: by mail-lf1-f66.google.com with SMTP id g21so7462609lfh.4
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4IX5+POITfEW/GgAGOAhpjC4hfqZle1GS39hd34tABc=;
        b=c5DF7HgKK0qIVF5rMuCnstNYrUQyFDJudBcyRBvVxl/OVavercO78axLTa1y5E7PY9
         isDPTp7kArMWMMBYhe8CTWf2krU7hyabVdxzoFqaJLHxrT9CkqWNLB0zHnlRSaspxFtr
         hwWSEbd/UCBehQVJC4Z2taD1Ge3gBKGq2+QjiqvPWw73jRtgqA95n41bXU8KiS+1njfZ
         Rxubls2yDJAK07c3eZP8HnqSnuFvaUBVvFkE1l9cpddF7e7dtR+GPZxNb7S9WNj+eLqQ
         PfkH6ooG2nCzk8PUHBf0dI+NrzvcJ5cppY1PvtylUn9mhARuHLVXGAQeIAtFn53bin1L
         p3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4IX5+POITfEW/GgAGOAhpjC4hfqZle1GS39hd34tABc=;
        b=QRH92UmIPsIu60HBv30aSGuSX/BEdXbvfmrXeOOiJM/sPqZ91vdg42KlOBdM86VXy7
         VOGktgxaEPmN5xu/2vrwyaQQBYIIJH9KV9u04O0r4DY0LZCyn/lpqMysYTblnNTsHwYG
         cgfcwPWeaHVDJzsYcC61jrUjkSUzfmlBluDBaUnc5ZnmpWUe0HGDN6/bDsgpnsL/pl//
         JUQqSb7+o6NVjcBZPlp287qVftGdeGGA9Z8o9JiiDhrDBdZsBTB5Xh5+/GvwxSjI0luu
         N34RIDS9s8ypZwLlSyVrXGaPZhuJJPtnmZ9eO6e0V2Tc7GUCRz8GoekPJ9iKRd3rl+1H
         2CiA==
X-Gm-Message-State: APjAAAUN0TksI2CUNfP+e09T+nD7kunXfh4jJUTfl0nmEGtuWCkf9dkl
        a0R0UyoQQAeGLcgrPxPxgfz/uqqTWgE=
X-Google-Smtp-Source: APXvYqz9HJ80WQYPLkYek3sIL5YNIjyQQaSzoeE+c1J5uemYm5RUGucuFCVKYGeD3szlVxvSe/7htA==
X-Received: by 2002:a19:cc07:: with SMTP id c7mr13155282lfg.107.1571616611546;
        Sun, 20 Oct 2019 17:10:11 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:08 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/10] ptp: ixp46x: move next to ethernet driver
Date:   Mon, 21 Oct 2019 02:08:17 +0200
Message-Id: <20191021000824.531-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ixp46x ptp driver has a somewhat unusual setup, where the ptp
driver and the ethernet driver are in different directories but
access the same registers that are defined a platform specific
header file.

Moving everything into drivers/net/ makes it look more like most
other ptp drivers and allows compile-testing this driver on
other targets.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/Kconfig                | 14 ++++++++++++++
 drivers/net/ethernet/xscale/Makefile               |  3 ++-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |  3 ++-
 drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c  |  3 ++-
 .../net/ethernet/xscale/ptp_ixp46x.h               |  0
 drivers/ptp/Kconfig                                | 14 --------------
 drivers/ptp/Makefile                               |  1 -
 7 files changed, 20 insertions(+), 18 deletions(-)
 rename drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c (99%)
 rename arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h => drivers/net/ethernet/xscale/ptp_ixp46x.h (100%)

diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index cd0a8f46e7c6..98aa7b8ddb06 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -27,4 +27,18 @@ config IXP4XX_ETH
 	  Say Y here if you want to use built-in Ethernet ports
 	  on IXP4xx processor.
 
+config PTP_1588_CLOCK_IXP46X
+	tristate "Intel IXP46x as PTP clock"
+	depends on IXP4XX_ETH
+	depends on PTP_1588_CLOCK
+	default y
+	help
+	  This driver adds support for using the IXP46X as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets
+	  using the SO_TIMESTAMPING API.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp_ixp46x.
+
 endif # NET_VENDOR_XSCALE
diff --git a/drivers/net/ethernet/xscale/Makefile b/drivers/net/ethernet/xscale/Makefile
index 794a519d07b3..607f91b1e878 100644
--- a/drivers/net/ethernet/xscale/Makefile
+++ b/drivers/net/ethernet/xscale/Makefile
@@ -3,4 +3,5 @@
 # Makefile for the Intel XScale IXP device drivers.
 #
 
-obj-$(CONFIG_IXP4XX_ETH) += ixp4xx_eth.o
+obj-$(CONFIG_IXP4XX_ETH)		+= ixp4xx_eth.o
+obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 6fc04ffb22c2..0075ecdb21f4 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -33,10 +33,11 @@
 #include <linux/ptp_classify.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <mach/ixp46x_ts.h>
 #include <linux/soc/ixp4xx/npe.h>
 #include <linux/soc/ixp4xx/qmgr.h>
 
+#include "ixp46x_ts.h"
+
 #define DEBUG_DESC		0
 #define DEBUG_RX		0
 #define DEBUG_TX		0
diff --git a/drivers/ptp/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
similarity index 99%
rename from drivers/ptp/ptp_ixp46x.c
rename to drivers/net/ethernet/xscale/ptp_ixp46x.c
index 67028484e9a0..9ecc395239e9 100644
--- a/drivers/ptp/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -15,7 +15,8 @@
 #include <linux/module.h>
 
 #include <linux/ptp_clock_kernel.h>
-#include <mach/ixp46x_ts.h>
+
+#include "ixp46x_ts.h"
 
 #define DRIVER		"ptp_ixp46x"
 #define N_EXT_TS	2
diff --git a/arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h b/drivers/net/ethernet/xscale/ptp_ixp46x.h
similarity index 100%
rename from arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
rename to drivers/net/ethernet/xscale/ptp_ixp46x.h
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 960961fb0d7c..0209e0ef082d 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -56,20 +56,6 @@ config PTP_1588_CLOCK_QORIQ
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp-qoriq.
 
-config PTP_1588_CLOCK_IXP46X
-	tristate "Intel IXP46x as PTP clock"
-	depends on IXP4XX_ETH
-	depends on PTP_1588_CLOCK
-	default y
-	help
-	  This driver adds support for using the IXP46X as a PTP
-	  clock. This clock is only useful if your PTP programs are
-	  getting hardware time stamps on the PTP Ethernet packets
-	  using the SO_TIMESTAMPING API.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called ptp_ixp46x.
-
 comment "Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks."
 	depends on PHYLIB=n || NETWORK_PHY_TIMESTAMPING=n
 
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 677d1d178a3e..8ac3513f61c9 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -6,7 +6,6 @@
 ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
-obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
 obj-$(CONFIG_PTP_1588_CLOCK_PCH)	+= ptp_pch.o
 obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
 obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+= ptp-qoriq.o
-- 
2.21.0

