Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9C015EB0A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392015AbgBNRSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391733AbgBNQLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C78B246A0;
        Fri, 14 Feb 2020 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696672;
        bh=QhfUCZL8nu16Ecebx/J93uNXs5f9BdBGnXmkpIxjlMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wv2rGBL6O6lXLISAV+wDSadacVne9bO1FZdoTSRPDl18VzQ0YrziVyLuyHctzCoXl
         D+rQROSmuqyxPki8+KKxgV5kwPVghyPxUaMHURYJRiZPgMY5NH9eYAvSs92A5pYSGE
         6MWFWUmSPz6oy5eBOXoQfvypEeREs5gjCedBSCoA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 442/459] iwlwifi: mvm: Fix thermal zone registration
Date:   Fri, 14 Feb 2020 11:01:32 -0500
Message-Id: <20200214160149.11681-442-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit baa6cf8450b72dcab11f37c47efce7c5b9b8ad0f ]

Use a unique name when registering a thermal zone. Otherwise, with
multiple NICS, we hit the following warning during the unregistration.

WARNING: CPU: 2 PID: 3525 at fs/sysfs/group.c:255
 RIP: 0010:sysfs_remove_group+0x80/0x90
 Call Trace:
  dpm_sysfs_remove+0x57/0x60
  device_del+0x5a/0x350
  ? sscanf+0x4e/0x70
  device_unregister+0x1a/0x60
  hwmon_device_unregister+0x4a/0xa0
  thermal_remove_hwmon_sysfs+0x175/0x1d0
  thermal_zone_device_unregister+0x188/0x1e0
  iwl_mvm_thermal_exit+0xe7/0x100 [iwlmvm]
  iwl_op_mode_mvm_stop+0x27/0x180 [iwlmvm]
  _iwl_op_mode_stop.isra.3+0x2b/0x50 [iwlwifi]
  iwl_opmode_deregister+0x90/0xa0 [iwlwifi]
  __exit_compat+0x10/0x2c7 [iwlmvm]
  __x64_sys_delete_module+0x13f/0x270
  do_syscall_64+0x5a/0x110
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index f0c539b37ea70..a630e4edd9b4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -731,7 +731,8 @@ static  struct thermal_zone_device_ops tzone_ops = {
 static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
 {
 	int i;
-	char name[] = "iwlwifi";
+	char name[16];
+	static atomic_t counter = ATOMIC_INIT(0);
 
 	if (!iwl_mvm_is_tt_in_fw(mvm)) {
 		mvm->tz_device.tzone = NULL;
@@ -741,6 +742,7 @@ static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
 
 	BUILD_BUG_ON(ARRAY_SIZE(name) >= THERMAL_NAME_LENGTH);
 
+	sprintf(name, "iwlwifi_%u", atomic_inc_return(&counter) & 0xFF);
 	mvm->tz_device.tzone = thermal_zone_device_register(name,
 							IWL_MAX_DTS_TRIPS,
 							IWL_WRITABLE_TRIPS_MSK,
-- 
2.20.1

