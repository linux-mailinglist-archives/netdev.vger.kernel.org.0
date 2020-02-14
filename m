Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194FC15DDDC
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbgBNQAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389141AbgBNQA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0738D24689;
        Fri, 14 Feb 2020 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696025;
        bh=yDTaCK/ytGY8aZ97lgRFlGc4UE+I2EUoD7z51dMYExw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4JaUh5QAx7LczYBLMKmXHXMNEhx2yO8qA6+Y86ca5FKz8lSm8qXjlrAWJGS/EynU
         SUhTl5h4ajdrYRx+C1rjQGA6XXd3JNiezEmBc3eQ+/64ySXyRI2ytAAAn2wkTmZT4F
         1sYZVzTP1U+N6ihOfyTh7gntD4BzUtr7nNqWejYM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Pasternak <vadimp@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 540/542] mlxsw: core: Add validation of hardware device types for MGPIR register
Date:   Fri, 14 Feb 2020 10:48:52 -0500
Message-Id: <20200214154854.6746-540-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 36844c855b896f90bab51ccecf72940eb7e3cfe1 ]

When reading the number of gearboxes from the hardware, the driver does
not validate the returned 'device type' field. The driver can therefore
wrongly assume that the queried devices are gearboxes.

On Spectrum-3 systems that support different types of devices, this can
prevent the driver from loading, as it will try to query the
temperature sensors from devices which it assumes are gearboxes and in
fact are not.

For example:
[  218.129230] mlxsw_minimal 2-0048: Reg cmd access status failed (status=7(bad parameter))
[  218.138282] mlxsw_minimal 2-0048: Reg cmd access failed (reg_id=900a(mtmp),type=write)
[  218.147131] mlxsw_minimal 2-0048: Failed to setup temp sensor number 256
[  218.534480] mlxsw_minimal 2-0048: Fail to register core bus
[  218.540714] mlxsw_minimal: probe of 2-0048 failed with error -5

Fix this by validating the 'device type' field.

Fixes: 2e265a8b6c094 ("mlxsw: core: Extend hwmon interface with inter-connect temperature attributes")
Fixes: f14f4e621b1b4 ("mlxsw: core: Extend thermal core with per inter-connect device thermal zones")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 8 ++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 9bf8da5f6dafc..3fe878d7c94cb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -573,6 +573,7 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 
 static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 {
+	enum mlxsw_reg_mgpir_device_type device_type;
 	int index, max_index, sensor_index;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
@@ -584,8 +585,9 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, NULL, NULL, NULL);
-	if (!gbox_num)
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, &device_type, NULL, NULL);
+	if (device_type != MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE ||
+	    !gbox_num)
 		return 0;
 
 	index = mlxsw_hwmon->module_sensor_max;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index c721b171bd8de..ce0a6837daa32 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -895,8 +895,10 @@ static int
 mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 			     struct mlxsw_thermal *thermal)
 {
+	enum mlxsw_reg_mgpir_device_type device_type;
 	struct mlxsw_thermal_module *gearbox_tz;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	u8 gbox_num;
 	int i;
 	int err;
 
@@ -908,11 +910,13 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, &thermal->tz_gearbox_num, NULL, NULL,
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, &device_type, NULL,
 			       NULL);
-	if (!thermal->tz_gearbox_num)
+	if (device_type != MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE ||
+	    !gbox_num)
 		return 0;
 
+	thermal->tz_gearbox_num = gbox_num;
 	thermal->tz_gearbox_arr = kcalloc(thermal->tz_gearbox_num,
 					  sizeof(*thermal->tz_gearbox_arr),
 					  GFP_KERNEL);
-- 
2.20.1

