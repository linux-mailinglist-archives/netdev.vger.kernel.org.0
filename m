Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138AD3974DD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhFAOEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:04:32 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3325 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbhFAOEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:04:31 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvYdp3brmz1BGgh;
        Tue,  1 Jun 2021 21:58:06 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:02:48 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 1 Jun
 2021 22:02:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] igb: Fix -Wunused-const-variable warning
Date:   Tue, 1 Jun 2021 22:02:38 +0800
Message-ID: <20210601140238.20712-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_IGB_HWMON is n, gcc warns:

drivers/net/ethernet/intel/igb/e1000_82575.c:2765:17:
 warning: ‘e1000_emc_therm_limit’ defined but not used [-Wunused-const-variable=]
 static const u8 e1000_emc_therm_limit[4] = {
                 ^~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/intel/igb/e1000_82575.c:2759:17:
 warning: ‘e1000_emc_temp_data’ defined but not used [-Wunused-const-variable=]
 static const u8 e1000_emc_temp_data[4] = {
                 ^~~~~~~~~~~~~~~~~~~

Move it into #ifdef block to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 50863fd87d53..cbe92fd23a70 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2756,6 +2756,7 @@ s32 igb_get_eee_status_i354(struct e1000_hw *hw, bool *status)
 	return ret_val;
 }
 
+#ifdef CONFIG_IGB_HWMON
 static const u8 e1000_emc_temp_data[4] = {
 	E1000_EMC_INTERNAL_DATA,
 	E1000_EMC_DIODE1_DATA,
@@ -2769,7 +2770,6 @@ static const u8 e1000_emc_therm_limit[4] = {
 	E1000_EMC_DIODE3_THERM_LIMIT
 };
 
-#ifdef CONFIG_IGB_HWMON
 /**
  *  igb_get_thermal_sensor_data_generic - Gathers thermal sensor data
  *  @hw: pointer to hardware structure
-- 
2.17.1

