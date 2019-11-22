Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D5C10660D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfKVG2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727568AbfKVFuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D6E620731;
        Fri, 22 Nov 2019 05:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401815;
        bh=cPUc9BD9WzvMPqJG1za/uFkew6pNIQo4k/jUTu9jzNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ch71PrgV9+31tgrekd47gW/qjBjW1uL3/Uy9OGtl/d8IrMN3Lv/WhhuhdSbXS80ze
         /W8Pe7arZwOVO+hUVku0aiJPfJ9JMVJNZ9vdVB1f9SfDbN6AY1xafqdY0vfzvNySnn
         zkA4I04kD8p1GpttRTcsqCF/XrWBmrPj5y7X7HF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 059/219] iwlwifi: move iwl_nvm_check_version() into dvm
Date:   Fri, 22 Nov 2019 00:46:31 -0500
Message-Id: <20191122054911.1750-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 64866e5da1eabd0c52ff45029b245f5465920031 ]

This function is only half-used by mvm (i.e. only the nvm_version part
matters, since the calibration version is irrelevant), so it's
pointless to export it from iwlwifi.  If mvm uses this function, it
has the additional complexity of setting the calib version to a bogus
value on all cfg structs.

To avoid this, move the function to dvm and make a simple comparison
of the nvm_version in mvm instead.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 17 +++++++++++++++++
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.c | 19 -------------------
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.h |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  4 +++-
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 030482b357a3c..06dd4e81b7374 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1227,6 +1227,23 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
+static int iwl_nvm_check_version(struct iwl_nvm_data *data,
+				 struct iwl_trans *trans)
+{
+	if (data->nvm_version >= trans->cfg->nvm_ver ||
+	    data->calib_version >= trans->cfg->nvm_calib_ver) {
+		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+			       data->nvm_version, data->calib_version);
+		return 0;
+	}
+
+	IWL_ERR(trans,
+		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+		data->nvm_version, trans->cfg->nvm_ver,
+		data->calib_version,  trans->cfg->nvm_calib_ver);
+	return -EINVAL;
+}
+
 static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 						 const struct iwl_cfg *cfg,
 						 const struct iwl_fw *fw,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index a4c96215933ba..a59bab8345f4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -928,22 +928,3 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 	return NULL;
 }
 IWL_EXPORT_SYMBOL(iwl_parse_eeprom_data);
-
-/* helper functions */
-int iwl_nvm_check_version(struct iwl_nvm_data *data,
-			     struct iwl_trans *trans)
-{
-	if (data->nvm_version >= trans->cfg->nvm_ver ||
-	    data->calib_version >= trans->cfg->nvm_calib_ver) {
-		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
-			       data->nvm_version, data->calib_version);
-		return 0;
-	}
-
-	IWL_ERR(trans,
-		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
-		data->nvm_version, trans->cfg->nvm_ver,
-		data->calib_version,  trans->cfg->nvm_calib_ver);
-	return -EINVAL;
-}
-IWL_EXPORT_SYMBOL(iwl_nvm_check_version);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index 8be50ed12300f..c59dd47cf15d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -122,9 +124,6 @@ struct iwl_nvm_data *
 iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 		      const u8 *eeprom, size_t eeprom_size);
 
-int iwl_nvm_check_version(struct iwl_nvm_data *data,
-			  struct iwl_trans *trans);
-
 int iwl_init_sband_channels(struct iwl_nvm_data *data,
 			    struct ieee80211_supported_band *sband,
 			    int n_channels, enum nl80211_band band);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2eba6d6f367f8..9808d954dca29 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -547,7 +547,9 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	if (mvm->nvm_file_name)
 		iwl_mvm_load_nvm_to_nic(mvm);
 
-	WARN_ON(iwl_nvm_check_version(mvm->nvm_data, mvm->trans));
+	WARN_ONCE(mvm->nvm_data->nvm_version < mvm->trans->cfg->nvm_ver,
+		  "Too old NVM version (0x%0x, required = 0x%0x)",
+		  mvm->nvm_data->nvm_version, mvm->trans->cfg->nvm_ver);
 
 	/*
 	 * abort after reading the nvm in case RF Kill is on, we will complete
-- 
2.20.1

