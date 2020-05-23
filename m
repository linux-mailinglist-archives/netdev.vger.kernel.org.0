Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1B1DF43E
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387612AbgEWCv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387592AbgEWCvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:20 -0400
IronPort-SDR: oqvUMlt21l0oTpP92312DIgfH8ta4hwq0culyYCEKUxEwxDLpiS5mSHu7zID1wBk4EFfwW35vS
 MSaXYIS8Kk2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:14 -0700
IronPort-SDR: pVDaXE76/q72pK94jwR7JdE86rAkMn2kGqElRF4n3wD0LsD217CSmpZyiByHKqx82w3WNfNHE5
 wVaLJa0K0Alw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291139"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:14 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 17/17] e1000e: disable s0ix entry and exit flows for ME systems
Date:   Fri, 22 May 2020 19:51:09 -0700
Message-Id: <20200523025109.3313635-18-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

Since ME systems do not support SLP_S0 in S0ix state, and S0ix entry
and exit flows may cause errors on them it is best to avoid using
e1000e_s0ix_entry_flow and e1000e_s0ix_exit_flow functions.

This was done by creating a struct of all devices that comes with ME
and by checking if the current device has ME.

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 45 +++++++++++++++++++++-
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 66609cf689de..32f23a15ff64 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -107,6 +107,45 @@ static const struct e1000_reg_info e1000_reg_info_tbl[] = {
 	{0, NULL}
 };
 
+struct e1000e_me_supported {
+	u16 device_id;		/* supported device ID */
+};
+
+static const struct e1000e_me_supported me_supported[] = {
+	{E1000_DEV_ID_PCH_LPT_I217_LM},
+	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
+	{E1000_DEV_ID_PCH_I218_LM2},
+	{E1000_DEV_ID_PCH_I218_LM3},
+	{E1000_DEV_ID_PCH_SPT_I219_LM},
+	{E1000_DEV_ID_PCH_SPT_I219_LM2},
+	{E1000_DEV_ID_PCH_LBG_I219_LM3},
+	{E1000_DEV_ID_PCH_SPT_I219_LM4},
+	{E1000_DEV_ID_PCH_SPT_I219_LM5},
+	{E1000_DEV_ID_PCH_CNP_I219_LM6},
+	{E1000_DEV_ID_PCH_CNP_I219_LM7},
+	{E1000_DEV_ID_PCH_ICP_I219_LM8},
+	{E1000_DEV_ID_PCH_ICP_I219_LM9},
+	{E1000_DEV_ID_PCH_CMP_I219_LM10},
+	{E1000_DEV_ID_PCH_CMP_I219_LM11},
+	{E1000_DEV_ID_PCH_CMP_I219_LM12},
+	{E1000_DEV_ID_PCH_TGP_I219_LM13},
+	{E1000_DEV_ID_PCH_TGP_I219_LM14},
+	{E1000_DEV_ID_PCH_TGP_I219_LM15},
+	{0}
+};
+
+static bool e1000e_check_me(u16 device_id)
+{
+	struct e1000e_me_supported *id;
+
+	for (id = (struct e1000e_me_supported *)me_supported;
+	     id->device_id; id++)
+		if (device_id == id->device_id)
+			return true;
+
+	return false;
+}
+
 /**
  * __ew32_prepare - prepare to write to MAC CSR register on certain parts
  * @hw: pointer to the HW structure
@@ -6916,7 +6955,8 @@ static int e1000e_pm_suspend(struct device *dev)
 		e1000e_pm_thaw(dev);
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp)
+	if (hw->mac.type >= e1000_pch_cnp &&
+	    !e1000e_check_me(hw->adapter->pdev->device))
 		e1000e_s0ix_entry_flow(adapter);
 
 	return rc;
@@ -6931,7 +6971,8 @@ static int e1000e_pm_resume(struct device *dev)
 	int rc;
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp)
+	if (hw->mac.type >= e1000_pch_cnp &&
+	    !e1000e_check_me(hw->adapter->pdev->device))
 		e1000e_s0ix_exit_flow(adapter);
 
 	rc = __e1000_resume(pdev);
-- 
2.26.2

