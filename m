Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04FF3A1C66
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhFIR66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:58:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50616 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhFIR66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:58:58 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lr2Rl-0002p7-NS; Wed, 09 Jun 2021 17:56:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mykola Kostenok <c_mykolak@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] mlxsw: thermal: Fix null dereference of NULL temperature parameter
Date:   Wed,  9 Jun 2021 18:56:57 +0100
Message-Id: <20210609175657.299112-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to mlxsw_thermal_module_temp_and_thresholds_get passes a NULL
pointer for the temperature and this can be dereferenced in this function
if the mlxsw_reg_query call fails.  The simplist fix is to pass the
address of dummy temperature variable instead of a NULL pointer.

Addresses-Coverity: ("Explicit null dereferenced")
Fixes: 72a64c2fe9d8 ("mlxsw: thermal: Read module temperature thresholds using MTMP register")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index d54b67d0bda7..0998dcc9cac0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -743,7 +743,7 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 			  struct mlxsw_thermal *thermal, u8 module)
 {
 	struct mlxsw_thermal_module *module_tz;
-	int crit_temp, emerg_temp;
+	int dummy_temp, crit_temp, emerg_temp;
 	u16 sensor_index;
 
 	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + module;
@@ -758,7 +758,7 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 	/* Initialize all trip point. */
 	mlxsw_thermal_module_trips_reset(module_tz);
 	/* Read module temperature and thresholds. */
-	mlxsw_thermal_module_temp_and_thresholds_get(core, sensor_index, NULL,
+	mlxsw_thermal_module_temp_and_thresholds_get(core, sensor_index, &dummy_temp,
 						     &crit_temp, &emerg_temp);
 	/* Update trip point according to the module data. */
 	return mlxsw_thermal_module_trips_update(dev, core, module_tz,
-- 
2.31.1

