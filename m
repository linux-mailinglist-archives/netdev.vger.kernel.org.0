Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A55DB78BB
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389905AbfISL4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:56:25 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:42663 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388771AbfISL4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:56:25 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MPrXf-1iW2n605kR-00MvcF; Thu, 19 Sep 2019 13:56:15 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix building without CONFIG_THERMAL
Date:   Thu, 19 Sep 2019 13:55:37 +0200
Message-Id: <20190919115612.1924937-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:SwXOiiSORYDXDfMCe6gQdCAdzGv8MKZxAwL4gFDJXNzLzWDJd6G
 nd7yqPX2JzfvLwnSU8PjMQsOE1gXih85tdA2ZiU/DtvFK1TFt1y9Ev15H195hBNiyGAh/LE
 fsKSn+7Y0/ckNVK8WMe6xO0utp37F59mwrmO+VTwAdaTvMlmg2pdGlDExgJ2H0VUo+0bJuT
 z7lj3k4LOws0CUSw9jVEg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xu/YVaCDX5s=:+COHs1HoImMhOZL9Giql69
 /lGJyi8Et1LJees5kkadiNbWUN4Gy9/VcYpjpSmRy/cbkQbySMO7FLfucQM9Wf/TJpEmAHoKL
 V230KV2tDAHnlj7SYqTtWvdK4BGwO+I5hCF+dy8fHsMfehBukV7iDyRCoBtJZS38cf733FZOf
 hNE9ASksiNl8fChFWxSuU5+xg0BNWyimC5kbTBxdxXqaOW2zRMPdmjUMXo4/Orw5KMRvWXo8k
 N9KdLCrA2mxm04sx0gi4L28+684nIXi2qBuSdsu7zlI/HQJM157/oslbRtLblRVkp2bSnEU//
 NDxleYG+onV2PjGm+ZMsvIO4biz+YgMoze55FBxyK1Oc9YuyFSE7kNFW8UPSL0IR9dfggd22F
 kGAVg90FxgzCtffShS4swVTaKKu/OjXwYpjBNRD8j9dj4j+suxae1Yy+m2TeX3bRaAnjnVfv9
 NnDApVtMO2fN+9CTin8Dh23Zu2zYzvopZEMCIyG6BxxgkPgczjKXEIXku9RCdad6m4IjVxCdm
 bbkXyNzI8POMhHxHKGBAK3DHF3RM3ypG5P1+pMvVqrzeUa1GAgqc7fVsBj3HCpA9v/eCJG/ZC
 KYv5eWqz7egk1giR8ORBiK7koXmzq7yxDA49qDJBCnyZdScNN+li0mxLOXQu1DoxaIuuiQXJ1
 M6kco3+wsq+0mX1TDMDfUX2/q88Y+9tKnOgwk0CHI9yRlOAqI8fKIKS/Iv0SLtEPOaPTRpWLH
 TBBUqVnUb7awDjt4r6W+M6cwYSVYMcPsWr5kHpl6+EYQezcr/oeVME5UMRIQPh3T6hjKzR1Jb
 vrvQwabwsH+qwkf0e6moXM8ye3y+unt+tKI09oFHDJNhNqFXd5mnS7u8a7d+o1hDc3j8HWvgY
 eePNO36zdg6pBqdJm4mA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iwl_mvm_send_temp_report_ths_cmd() function is now called without
CONFIG_THERMAL, but not defined:

ERROR: "iwl_mvm_send_temp_report_ths_cmd" [drivers/net/wireless/intel/iwlwifi/mvm/iwlmvm.ko] undefined!

Move that function out of the #ifdef as well and change it so
that empty data gets sent even if no thermal device was
registered.

Fixes: 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal monitoring regardless of CONFIG_THERMAL")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
No idea if this does what was intended in the commit that introduced
the link failure, please see for youself.
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 843d00bf2bd5..1b4139372e57 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -542,7 +542,6 @@ struct iwl_mvm_tt_mgmt {
 	bool throttle;
 };
 
-#ifdef CONFIG_THERMAL
 /**
  *struct iwl_mvm_thermal_device - thermal zone related data
  * @temp_trips: temperature thresholds for report
@@ -555,6 +554,7 @@ struct iwl_mvm_thermal_device {
 	struct thermal_zone_device *tzone;
 };
 
+#ifdef CONFIG_THERMAL
 /*
  * struct iwl_mvm_cooling_device
  * @cur_state: current state
@@ -1034,8 +1034,8 @@ struct iwl_mvm {
 
 	/* Thermal Throttling and CTkill */
 	struct iwl_mvm_tt_mgmt thermal_throttle;
-#ifdef CONFIG_THERMAL
 	struct iwl_mvm_thermal_device tz_device;
+#ifdef CONFIG_THERMAL
 	struct iwl_mvm_cooling_device cooling_dev;
 #endif
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 32a708301cfc..6d717bb65ab7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -549,7 +549,6 @@ int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 state)
 	return 0;
 }
 
-#ifdef CONFIG_THERMAL
 static int compare_temps(const void *a, const void *b)
 {
 	return ((s16)le16_to_cpu(*(__le16 *)a) -
@@ -564,7 +563,7 @@ int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm)
 	lockdep_assert_held(&mvm->mutex);
 
 	if (!mvm->tz_device.tzone)
-		return -EINVAL;
+		goto send;
 
 	/* The driver holds array of temperature trips that are unsorted
 	 * and uncompressed, the FW should get it compressed and sorted
@@ -607,6 +606,7 @@ int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm)
 	return ret;
 }
 
+#ifdef CONFIG_THERMAL
 static int iwl_mvm_tzone_get_temp(struct thermal_zone_device *device,
 				  int *temperature)
 {
-- 
2.20.0

