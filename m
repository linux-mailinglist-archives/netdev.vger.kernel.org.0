Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A3EB62D8
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 14:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfIRMLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 08:11:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2294 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727637AbfIRMLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 08:11:22 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B1F1F36D3DD6EFEAC91F;
        Wed, 18 Sep 2019 20:11:16 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 18 Sep 2019 20:11:07 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net] iwlwifi: add dependency of THERMAL with IWLMVM
Date:   Wed, 18 Sep 2019 20:28:15 +0800
Message-ID: <20190918122815.155657-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_IWLMVM=y, CONFIG_THERMAL=n, below error can be found:
drivers/net/wireless/intel/iwlwifi/mvm/fw.o: In function `iwl_mvm_up':
fw.c:(.text+0x2c26): undefined reference to `iwl_mvm_send_temp_report_ths_cmd'
make: *** [vmlinux] Error 1

After commit 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal
monitoring regardless of CONFIG_THERMAL"), iwl_mvm_up()
calls iwl_mvm_send_temp_report_ths_cmd(), but this function
is under CONFIG_THERMAL, which is depended on CONFIG_THERMAL.

Fixes: 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal monitoring regardless of CONFIG_THERMAL")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 7dbc0d3..801aa0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -65,6 +65,7 @@ config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
 	select WANT_DEV_COREDUMP
 	depends on MAC80211
+	depends on THERMAL
 	help
 	  This is the driver that supports the MVM firmware. The list
 	  of the devices that use this firmware is available here:
-- 
2.7.4

