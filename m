Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D0343A510
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhJYU5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233005AbhJYU46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F158861090;
        Mon, 25 Oct 2021 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195276;
        bh=VEs9dGMTA2uxdS/x/v3//RiFdixoG55vj2MCEhk9arM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJGfvxEtVIRYAJuTm9wXzCe6PN6UFG86485DMKFMKPqorMSzYDvtDTgN8zpH7vYRX
         7+7Ut9jVRiOVVWdevX23Hm3HOo2IPQ6gSzsUNGe2zo3kROBY6+rrJJLOHa2/lvyvvj
         Um9dlyGjC+wcajT+5k+ftuBiLcgZ5EoPwqMzcp0hd4QvzbCx7c6Fpm2lSTuLIj6WC6
         5pic2eM1Xvkctb/ujjrGEb8q37FXgnx2YwtMryrGWny02mV21YS9MjCFDe9jY5gNsp
         N+62Dp7bdrVoI1UTOPrUgOzwLCR49TSa/LN12nzBeqajbGPOpBR/qNxq9suMtmG52r
         O8pYdqtuwv/Ag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/14] net/mlx5: Print health buffer by log level
Date:   Mon, 25 Oct 2021 13:54:23 -0700
Message-Id: <20211025205431.365080-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add log macro which gets log level as a parameter. Use the severity
read from the health buffer and the new log macro to log the health buffer
with severity as log level.  Prior to this patch, health buffer was
printed in error log level regardless of its severity. Now the user may
filter dmesg (--level) or change kernel log level to focus on different
severity levels of firmware errors.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  2 +
 .../net/ethernet/mellanox/mlx5/core/health.c  | 37 +++++++++----------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 24 ++++++++++++
 3 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 4b59cf2c599f..2ee74a49be9d 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -543,6 +543,8 @@ The CR-space dump uses vsc interface which is valid even if the FW command
 interface is not functional, which is the case in most FW fatal errors.
 The recover function runs recover flow which reloads the driver and triggers fw
 reset if needed.
+On firmware error, the health buffer is dumped into the dmesg. The log
+level is derived from the error's severity (given in health buffer).
 
 User commands examples:
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 538ef392f54c..c35a27255232 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -422,27 +422,26 @@ static void print_health_info(struct mlx5_core_dev *dev)
 
 	rfr_severity = ioread8(&h->rfr_severity);
 	severity  = mlx5_health_get_severity(rfr_severity);
-	mlx5_core_err(dev, "Health issue observed, %s, severity(%d) %s:\n",
-		      hsynd_str(ioread8(&h->synd)), severity, mlx5_loglevel_str(severity));
+	mlx5_log(dev, severity, "Health issue observed, %s, severity(%d) %s:\n",
+		 hsynd_str(ioread8(&h->synd)), severity, mlx5_loglevel_str(severity));
 
 	for (i = 0; i < ARRAY_SIZE(h->assert_var); i++)
-		mlx5_core_err(dev, "assert_var[%d] 0x%08x\n", i,
-			      ioread32be(h->assert_var + i));
-
-	mlx5_core_err(dev, "assert_exit_ptr 0x%08x\n",
-		      ioread32be(&h->assert_exit_ptr));
-	mlx5_core_err(dev, "assert_callra 0x%08x\n",
-		      ioread32be(&h->assert_callra));
-	mlx5_core_err(dev, "fw_ver %d.%d.%d", fw_rev_maj(dev), fw_rev_min(dev), fw_rev_sub(dev));
-	mlx5_core_err(dev, "time %u\n", ioread32be(&h->time));
-	mlx5_core_err(dev, "hw_id 0x%08x\n", ioread32be(&h->hw_id));
-	mlx5_core_err(dev, "rfr %d\n", mlx5_health_get_rfr(rfr_severity));
-	mlx5_core_err(dev, "severity %d (%s)\n", severity, mlx5_loglevel_str(severity));
-	mlx5_core_err(dev, "irisc_index %d\n", ioread8(&h->irisc_index));
-	mlx5_core_err(dev, "synd 0x%x: %s\n", ioread8(&h->synd),
-		      hsynd_str(ioread8(&h->synd)));
-	mlx5_core_err(dev, "ext_synd 0x%04x\n", ioread16be(&h->ext_synd));
-	mlx5_core_err(dev, "raw fw_ver 0x%08x\n", ioread32be(&h->fw_ver));
+		mlx5_log(dev, severity, "assert_var[%d] 0x%08x\n", i,
+			 ioread32be(h->assert_var + i));
+
+	mlx5_log(dev, severity, "assert_exit_ptr 0x%08x\n", ioread32be(&h->assert_exit_ptr));
+	mlx5_log(dev, severity, "assert_callra 0x%08x\n", ioread32be(&h->assert_callra));
+	mlx5_log(dev, severity, "fw_ver %d.%d.%d", fw_rev_maj(dev), fw_rev_min(dev),
+		 fw_rev_sub(dev));
+	mlx5_log(dev, severity, "time %u\n", ioread32be(&h->time));
+	mlx5_log(dev, severity, "hw_id 0x%08x\n", ioread32be(&h->hw_id));
+	mlx5_log(dev, severity, "rfr %d\n", mlx5_health_get_rfr(rfr_severity));
+	mlx5_log(dev, severity, "severity %d (%s)\n", severity, mlx5_loglevel_str(severity));
+	mlx5_log(dev, severity, "irisc_index %d\n", ioread8(&h->irisc_index));
+	mlx5_log(dev, severity, "synd 0x%x: %s\n", ioread8(&h->synd),
+		 hsynd_str(ioread8(&h->synd)));
+	mlx5_log(dev, severity, "ext_synd 0x%04x\n", ioread16be(&h->ext_synd));
+	mlx5_log(dev, severity, "raw fw_ver 0x%08x\n", ioread32be(&h->fw_ver));
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 230eab7e3bc9..bb677329ea08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -97,6 +97,30 @@ do {								\
 			     __func__, __LINE__, current->pid,	\
 			     ##__VA_ARGS__)
 
+static inline void mlx5_printk(struct mlx5_core_dev *dev, int level, const char *format, ...)
+{
+	struct device *device = dev->device;
+	struct va_format vaf;
+	va_list args;
+
+	if (WARN_ONCE(level < LOGLEVEL_EMERG || level > LOGLEVEL_DEBUG,
+		      "Level %d is out of range, set to default level\n", level))
+		level = LOGLEVEL_DEFAULT;
+
+	va_start(args, format);
+	vaf.fmt = format;
+	vaf.va = &args;
+
+	dev_printk_emit(level, device, "%s %s: %pV", dev_driver_string(device), dev_name(device),
+			&vaf);
+	va_end(args);
+}
+
+#define mlx5_log(__dev, level, format, ...)			\
+	mlx5_printk(__dev, level, "%s:%d:(pid %d): " format,	\
+		    __func__, __LINE__, current->pid,		\
+		    ##__VA_ARGS__)
+
 static inline struct device *mlx5_core_dma_dev(struct mlx5_core_dev *dev)
 {
 	return &dev->pdev->dev;
-- 
2.31.1

