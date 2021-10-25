Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B5A43A50F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhJYU5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhJYU46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DFB96105A;
        Mon, 25 Oct 2021 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195275;
        bh=s336xi6Us5FYig4i9oLgFMzbUSJkcpRYF6YqTpyQ2JE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0SIEvCv5CK9974qpn0570vXHJee1FSfa+SaYWqJZ0qkqOFFCHpxKSzh3AYZqzBgG
         JRSFcxpaclp4mkSuI3FZK33hdqgBuuAJG1l9YxzBwvTCGfuaLXkyPxy9XdmxFuQpSh
         J2Zb8Kawegf+ynhvGp0VnSQ1Y7uF45WlcVZz6tJt0cgPQDhbSzbBVW0n0pHipY389e
         oAkBgSc0RFqKvDfTKCK51h1OAYfKPMyc5INNUzmpOha57egTC9miGMi1L/kJjKwYtq
         4gWR0uqmP0P3cuvWWAVg9wdwY7KxhSotkkmL9qCdiRxj2O8W782LjCYpij0LyNF8mu
         9/c6ZtQ2jfdQQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/14] net/mlx5: Extend health buffer dump
Date:   Mon, 25 Oct 2021 13:54:22 -0700
Message-Id: <20211025205431.365080-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Enhance health buffer to include:
 - assert_var5: expose the 6'th assert variable.
 - time: error's time-stamp in seconds (epoch time).
 - rfr: Recovery Flow Requiered. When set, indicates that the error
        cannot be recovered without flow involving reset.
 - severity: error's severity value, ranging from emergency to debug.
Expose them in the health buffer dump (dmesg and devlink fw reporter).

Health buffer in dmesg:
mlx5_core 0000:08:00.0: print_health_info:425:(pid 912): Health issue observed, firmware internal error, severity(3) ERROR:
mlx5_core 0000:08:00.0: print_health_info:429:(pid 912): assert_var[0] 0x08040700
mlx5_core 0000:08:00.0: print_health_info:429:(pid 912): assert_var[1] 0x00000000
mlx5_core 0000:08:00.0: print_health_info:429:(pid 912): assert_var[2] 0x00000000
mlx5_core 0000:08:00.0: print_health_info:429:(pid 912): assert_var[3] 0x00000000
mlx5_core 0000:08:00.0: print_health_info:429:(pid 912): assert_var[4] 0x00000000
mlx5_core 0000:08:00.0: print_health_info:429:(pid 912): assert_var[5] 0x00000000
mlx5_core 0000:08:00.0: print_health_info:432:(pid 912): assert_exit_ptr 0x00aaf800
mlx5_core 0000:08:00.0: print_health_info:434:(pid 912): assert_callra 0x00aaf70c
mlx5_core 0000:08:00.0: print_health_info:436:(pid 912): fw_ver 16.32.492
mlx5_core 0000:08:00.0: print_health_info:437:(pid 912): time 1634819758
mlx5_core 0000:08:00.0: print_health_info:438:(pid 912): hw_id 0x0000020d
mlx5_core 0000:08:00.0: print_health_info:439:(pid 912): rfr 0
mlx5_core 0000:08:00.0: print_health_info:440:(pid 912): severity 3 (ERROR)
mlx5_core 0000:08:00.0: print_health_info:441:(pid 912): irisc_index 9
mlx5_core 0000:08:00.0: print_health_info:442:(pid 912): synd 0x1: firmware internal error
mlx5_core 0000:08:00.0: print_health_info:444:(pid 912): ext_synd 0x802b
mlx5_core 0000:08:00.0: print_health_info:445:(pid 912): raw fw_ver 0x102001ec

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 73 +++++++++++++++++--
 include/linux/mlx5/device.h                   | 14 ++--
 include/linux/mlx5/mlx5_ifc.h                 | 10 ++-
 3 files changed, 82 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 6a4dd7f78958..538ef392f54c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -36,6 +36,7 @@
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
 #include <linux/mlx5/driver.h>
+#include <linux/kern_levels.h>
 #include "mlx5_core.h"
 #include "lib/eq.h"
 #include "lib/mlx5.h"
@@ -74,6 +75,11 @@ enum  {
 	MLX5_SENSOR_FW_SYND_RFR		= 5,
 };
 
+enum {
+	MLX5_SEVERITY_MASK		= 0x7,
+	MLX5_SEVERITY_VALID_MASK	= 0x8,
+};
+
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev)
 {
 	return (ioread32be(&dev->iseg->cmdq_addr_l_sz) >> 8) & 7;
@@ -98,12 +104,19 @@ static bool sensor_pci_not_working(struct mlx5_core_dev *dev)
 	return (ioread32be(&h->fw_ver) == 0xffffffff);
 }
 
+static int mlx5_health_get_rfr(u8 rfr_severity)
+{
+	return rfr_severity >> MLX5_RFR_BIT_OFFSET;
+}
+
 static bool sensor_fw_synd_rfr(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 	struct health_buffer __iomem *h = health->health;
-	u32 rfr = ioread32be(&h->rfr) >> MLX5_RFR_OFFSET;
 	u8 synd = ioread8(&h->synd);
+	u8 rfr;
+
+	rfr = mlx5_health_get_rfr(ioread8(&h->rfr_severity));
 
 	if (rfr && synd)
 		mlx5_core_dbg(dev, "FW requests reset, synd: %d\n", synd);
@@ -366,18 +379,52 @@ static const char *hsynd_str(u8 synd)
 	}
 }
 
+static const char *mlx5_loglevel_str(int level)
+{
+	switch (level) {
+	case LOGLEVEL_EMERG:
+		return "EMERGENCY";
+	case LOGLEVEL_ALERT:
+		return "ALERT";
+	case LOGLEVEL_CRIT:
+		return "CRITICAL";
+	case LOGLEVEL_ERR:
+		return "ERROR";
+	case LOGLEVEL_WARNING:
+		return "WARNING";
+	case LOGLEVEL_NOTICE:
+		return "NOTICE";
+	case LOGLEVEL_INFO:
+		return "INFO";
+	case LOGLEVEL_DEBUG:
+		return "DEBUG";
+	}
+	return "Unknown log level";
+}
+
+static int mlx5_health_get_severity(u8 rfr_severity)
+{
+	return rfr_severity & MLX5_SEVERITY_VALID_MASK ?
+	       rfr_severity & MLX5_SEVERITY_MASK : LOGLEVEL_ERR;
+}
+
 static void print_health_info(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 	struct health_buffer __iomem *h = health->health;
-	char fw_str[18];
-	u32 fw;
+	u8 rfr_severity;
+	int severity;
 	int i;
 
 	/* If the syndrome is 0, the device is OK and no need to print buffer */
 	if (!ioread8(&h->synd))
 		return;
 
+	rfr_severity = ioread8(&h->rfr_severity);
+	severity  = mlx5_health_get_severity(rfr_severity);
+	mlx5_core_err(dev, "Health issue observed, %s, severity(%d) %s:\n",
+		      hsynd_str(ioread8(&h->synd)), severity, mlx5_loglevel_str(severity));
+
 	for (i = 0; i < ARRAY_SIZE(h->assert_var); i++)
 		mlx5_core_err(dev, "assert_var[%d] 0x%08x\n", i,
 			      ioread32be(h->assert_var + i));
@@ -386,15 +433,16 @@ static void print_health_info(struct mlx5_core_dev *dev)
 		      ioread32be(&h->assert_exit_ptr));
 	mlx5_core_err(dev, "assert_callra 0x%08x\n",
 		      ioread32be(&h->assert_callra));
-	sprintf(fw_str, "%d.%d.%d", fw_rev_maj(dev), fw_rev_min(dev), fw_rev_sub(dev));
-	mlx5_core_err(dev, "fw_ver %s\n", fw_str);
+	mlx5_core_err(dev, "fw_ver %d.%d.%d", fw_rev_maj(dev), fw_rev_min(dev), fw_rev_sub(dev));
+	mlx5_core_err(dev, "time %u\n", ioread32be(&h->time));
 	mlx5_core_err(dev, "hw_id 0x%08x\n", ioread32be(&h->hw_id));
+	mlx5_core_err(dev, "rfr %d\n", mlx5_health_get_rfr(rfr_severity));
+	mlx5_core_err(dev, "severity %d (%s)\n", severity, mlx5_loglevel_str(severity));
 	mlx5_core_err(dev, "irisc_index %d\n", ioread8(&h->irisc_index));
 	mlx5_core_err(dev, "synd 0x%x: %s\n", ioread8(&h->synd),
 		      hsynd_str(ioread8(&h->synd)));
 	mlx5_core_err(dev, "ext_synd 0x%04x\n", ioread16be(&h->ext_synd));
-	fw = ioread32be(&h->fw_ver);
-	mlx5_core_err(dev, "raw fw_ver 0x%08x\n", fw);
+	mlx5_core_err(dev, "raw fw_ver 0x%08x\n", ioread32be(&h->fw_ver));
 }
 
 static int
@@ -443,6 +491,7 @@ mlx5_fw_reporter_heath_buffer_data_put(struct mlx5_core_dev *dev,
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 	struct health_buffer __iomem *h = health->health;
+	u8 rfr_severity;
 	int err;
 	int i;
 
@@ -473,9 +522,19 @@ mlx5_fw_reporter_heath_buffer_data_put(struct mlx5_core_dev *dev,
 		return err;
 	err = devlink_fmsg_u32_pair_put(fmsg, "assert_callra",
 					ioread32be(&h->assert_callra));
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "time", ioread32be(&h->time));
 	if (err)
 		return err;
 	err = devlink_fmsg_u32_pair_put(fmsg, "hw_id", ioread32be(&h->hw_id));
+	if (err)
+		return err;
+	rfr_severity = ioread8(&h->rfr_severity);
+	err = devlink_fmsg_u8_pair_put(fmsg, "rfr", mlx5_health_get_rfr(rfr_severity));
+	if (err)
+		return err;
+	err = devlink_fmsg_u8_pair_put(fmsg, "severity", mlx5_health_get_severity(rfr_severity));
 	if (err)
 		return err;
 	err = devlink_fmsg_u8_pair_put(fmsg, "irisc_index",
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 347167c18802..f8a0bbb42c3b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -541,19 +541,21 @@ struct mlx5_cmd_layout {
 	u8		status_own;
 };
 
-enum mlx5_fatal_assert_bit_offsets {
-	MLX5_RFR_OFFSET = 31,
+enum mlx5_rfr_severity_bit_offsets {
+	MLX5_RFR_BIT_OFFSET = 0x7,
 };
 
 struct health_buffer {
-	__be32		assert_var[5];
-	__be32		rsvd0[3];
+	__be32		assert_var[6];
+	__be32		rsvd0[2];
 	__be32		assert_exit_ptr;
 	__be32		assert_callra;
-	__be32		rsvd1[2];
+	__be32		rsvd1[1];
+	__be32		time;
 	__be32		fw_ver;
 	__be32		hw_id;
-	__be32		rfr;
+	u8		rfr_severity;
+	u8		rsvd2[3];
 	u8		irisc_index;
 	u8		synd;
 	__be16		ext_synd;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 09e43019d877..6d292b5b8992 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4149,13 +4149,19 @@ struct mlx5_ifc_health_buffer_bits {
 
 	u8         assert_callra[0x20];
 
-	u8         reserved_at_140[0x40];
+	u8         reserved_at_140[0x20];
+
+	u8         time[0x20];
 
 	u8         fw_version[0x20];
 
 	u8         hw_id[0x20];
 
-	u8         reserved_at_1c0[0x20];
+	u8         rfr[0x1];
+	u8         reserved_at_1c1[0x3];
+	u8         valid[0x1];
+	u8         severity[0x3];
+	u8         reserved_at_1c8[0x18];
 
 	u8         irisc_index[0x8];
 	u8         synd[0x8];
-- 
2.31.1

