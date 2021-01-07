Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468EA2ECA66
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 07:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbhAGGMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 01:12:30 -0500
Received: from mga05.intel.com ([192.55.52.43]:34347 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbhAGGM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 01:12:29 -0500
IronPort-SDR: t66r1lp2ykV+d1atMbAvk682IFeog/SJS++WDcdLYzok3eqoR7pGyC8boTdGbdocVcm20Hu2x6
 0Uq+KQpi1uvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="262152099"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="262152099"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 22:12:04 -0800
IronPort-SDR: QrqdGTZ8HC2309dBRob1WqwA6cOawP4RyUXIpHnBxbDwXcfiH1AHKju+a+B6c1d6ocraD4lfJe
 9D2IG6HkaWfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="462932422"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jan 2021 22:12:01 -0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     andrew@lunn.ch, arnd@arndb.de, lee.jones@linaro.org,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, yilun.xu@intel.com,
        hao.wu@intel.com, matthew.gerlach@intel.com,
        russell.h.weight@intel.com
Subject: [RESEND PATCH 1/2] mfd: intel-m10-bmc: specify the retimer sub devices
Date:   Thu,  7 Jan 2021 14:07:07 +0800
Message-Id: <1609999628-12748-2-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
References: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch specifies the 2 retimer sub devices and their resources in the
parent driver's mfd_cell. It also adds the register definition of the
retimer sub devices.

There are 2 ethernet retimer chips (C827) connected to the Intel MAX 10
BMC. They are managed by the BMC firmware, and host could query them via
retimer interfaces (shared registers) on the BMC. The 2 retimers have
identical register interfaces in different register addresses or fields,
so it is better we define 2 retimer devices and handle them with the same
driver.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 drivers/mfd/intel-m10-bmc.c       | 19 ++++++++++++++++++-
 include/linux/mfd/intel-m10-bmc.h |  7 +++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/intel-m10-bmc.c b/drivers/mfd/intel-m10-bmc.c
index b84579b..e0a99a0 100644
--- a/drivers/mfd/intel-m10-bmc.c
+++ b/drivers/mfd/intel-m10-bmc.c
@@ -17,9 +17,26 @@ enum m10bmc_type {
 	M10_N3000,
 };
 
+static struct resource retimer0_resources[] = {
+	{M10BMC_PKVL_A_VER, M10BMC_PKVL_A_VER, "version", IORESOURCE_REG, },
+};
+
+static struct resource retimer1_resources[] = {
+	{M10BMC_PKVL_B_VER, M10BMC_PKVL_B_VER, "version", IORESOURCE_REG, },
+};
+
 static struct mfd_cell m10bmc_pacn3000_subdevs[] = {
 	{ .name = "n3000bmc-hwmon" },
-	{ .name = "n3000bmc-retimer" },
+	{
+		.name = "n3000bmc-retimer",
+		.num_resources = ARRAY_SIZE(retimer0_resources),
+		.resources = retimer0_resources,
+	},
+	{
+		.name = "n3000bmc-retimer",
+		.num_resources = ARRAY_SIZE(retimer1_resources),
+		.resources = retimer1_resources,
+	},
 	{ .name = "n3000bmc-secure" },
 };
 
diff --git a/include/linux/mfd/intel-m10-bmc.h b/include/linux/mfd/intel-m10-bmc.h
index c8ef2f1..d6216f9 100644
--- a/include/linux/mfd/intel-m10-bmc.h
+++ b/include/linux/mfd/intel-m10-bmc.h
@@ -21,6 +21,13 @@
 #define M10BMC_VER_PCB_INFO_MSK		GENMASK(31, 24)
 #define M10BMC_VER_LEGACY_INVALID	0xffffffff
 
+/* Retimer related registers, in system register region */
+#define M10BMC_PKVL_LSTATUS		0x164
+#define M10BMC_PKVL_A_VER		0x254
+#define M10BMC_PKVL_B_VER		0x258
+#define M10BMC_PKVL_SERDES_VER		GENMASK(15, 0)
+#define M10BMC_PKVL_SBUS_VER		GENMASK(31, 16)
+
 /**
  * struct intel_m10bmc - Intel MAX 10 BMC parent driver data structure
  * @dev: this device
-- 
2.7.4

