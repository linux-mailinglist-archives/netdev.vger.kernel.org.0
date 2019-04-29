Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F594EABB
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbfD2TOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:61546 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbfD2TOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:14:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="341867037"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 12:14:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Maciej Paczkowski <maciej.paczkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/12] i40e: ShadowRAM checksum calculation change
Date:   Mon, 29 Apr 2019 12:16:21 -0700
Message-Id: <20190429191628.31212-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Paczkowski <maciej.paczkowski@intel.com>

Due to changes in FW the SW is required to perform double SR dump in
some cases.

Implementation adds two new steps to update nvm checksum function:
* recalculate checksum and check if checksum in NVM is correct
* if checksum in NVM is not correct then update it again

Signed-off-by: Maciej Paczkowski <maciej.paczkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_nvm.c | 29 +++++++++++++++++++---
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_nvm.c b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
index 0299e5bbb902..ee89779a9a6f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_nvm.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
@@ -574,13 +574,34 @@ static i40e_status i40e_calc_nvm_checksum(struct i40e_hw *hw,
 i40e_status i40e_update_nvm_checksum(struct i40e_hw *hw)
 {
 	i40e_status ret_code;
-	u16 checksum;
+	u16 checksum, checksum_sr;
 	__le16 le_sum;
 
 	ret_code = i40e_calc_nvm_checksum(hw, &checksum);
-	if (!ret_code) {
-		le_sum = cpu_to_le16(checksum);
-		ret_code = i40e_write_nvm_aq(hw, 0x00, I40E_SR_SW_CHECKSUM_WORD,
+	if (ret_code)
+		return ret_code;
+
+	le_sum = cpu_to_le16(checksum);
+	ret_code = i40e_write_nvm_aq(hw, 0x00, I40E_SR_SW_CHECKSUM_WORD,
+				     1, &le_sum, true);
+	if (ret_code)
+		return ret_code;
+
+	/* Due to changes in FW the SW is required to perform double SR-dump
+	 * in some cases. SR-dump is the process when internal shadow RAM is
+	 * dumped into flash bank. It is triggered by setting "last_command"
+	 * argument in i40e_write_nvm_aq function call.
+	 * Since FW 1.8 we need to calculate SR checksum again and update it
+	 * in flash if it is not equal to previously computed checksum.
+	 * This situation would occur only in FW >= 1.8
+	 */
+	ret_code = i40e_calc_nvm_checksum(hw, &checksum_sr);
+	if (ret_code)
+		return ret_code;
+	if (checksum_sr != checksum) {
+		le_sum = cpu_to_le16(checksum_sr);
+		ret_code = i40e_write_nvm_aq(hw, 0x00,
+					     I40E_SR_SW_CHECKSUM_WORD,
 					     1, &le_sum, true);
 	}
 
-- 
2.20.1

