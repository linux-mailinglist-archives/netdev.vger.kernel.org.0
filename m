Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BED455DE1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhKROYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:24:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232554AbhKROYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:24:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D2B8610FB;
        Thu, 18 Nov 2021 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637245290;
        bh=fWB+uwrmZcbW6kM5Y415Yic83y10eXZ6Qv7v9+poSe0=;
        h=From:To:Cc:Subject:Date:From;
        b=j7+frcX8se6gNR5EoEgrgNfpS9egBAE9np97ul75Q9HNWcqr3Yeadz1B4qgpeMgo9
         Eqt6DOgHVFqdA77CGHEOW3vRtlxGgst94oWTv03nq85nfuK0+sbx4OI8zLreXIhBWm
         eo2ynjD94dxiC88outwfZ/TEBuaNOshAj02mGe9ZgRKWxJJ4XUaSCLqt/x0YkYSz0g
         nosDxzbHSKtzELI6GMmvJx9GIKBayxejrh+o6vcmPckAR3SWvJQYFq14fKy+N6tWNZ
         vxk381jVpNiEtw3qzh1LYvCZ04tlUj4F7+/ra0OZAkBTbL88He0OpG+e4KCpbzEeIr
         8IpZ73s+g1afw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Yaara Baruch <yaara.baruch@intel.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH] [v3] iwlwifi: pcie: fix constant-conversion warning
Date:   Thu, 18 Nov 2021 15:21:02 +0100
Message-Id: <20211118142124.526901-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 points out a potential issue with integer overflow when
the iwl_dev_info_table[] array is empty:

drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1344:42: error: implicit conversion from 'unsigned long' to 'int' changes value from 18446744073709551615 to -1 [-Werror,-Wconstant-conversion]
        for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
               ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~

This is still harmless, as the loop correctly terminates, but adding
an extra range check makes that obvious to both readers and to the
compiler.

Fixes: 3f7320428fa4 ("iwlwifi: pcie: simplify iwl_pci_find_dev_info()")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v3:
- make it actually work with gcc-11
- fix commit message s/clang/gcc-11/

Changes in v2:
- replace int cast with a range check
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index c574f041f096..395e328c6a07 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1339,9 +1339,13 @@ iwl_pci_find_dev_info(u16 device, u16 subsystem_device,
 		      u16 mac_type, u8 mac_step,
 		      u16 rf_type, u8 cdb, u8 rf_id, u8 no_160, u8 cores)
 {
+	int num_devices = ARRAY_SIZE(iwl_dev_info_table);
 	int i;
 
-	for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
+	if (!num_devices)
+		return NULL;
+
+	for (i = num_devices - 1; i >= 0; i--) {
 		const struct iwl_dev_info *dev_info = &iwl_dev_info_table[i];
 
 		if (dev_info->device != (u16)IWL_CFG_ANY &&
-- 
2.29.2

