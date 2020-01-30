Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E03114E5C4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgA3W7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:51511 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgA3W7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187780"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:21 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 05/15] ice: use __le16 types for explicitly Little Endian values
Date:   Thu, 30 Jan 2020 14:59:00 -0800
Message-Id: <20200130225913.1671982-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ice_read_sr_aq function returns words in the Little Endian format.
Remove the need for __force and typecasting by using a local variable in
the ice_read_sr_word_aq function.

Additionally clarify explicitly that the ice_read_sr_aq function takes
storage for __le16 values instead of using u16.

Being explicit about the endianness of this data helps when using tools
like sparse to catch endian-related issues.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 7525ac50742e..46db9bb0977f 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -80,13 +80,14 @@ ice_check_sr_access_params(struct ice_hw *hw, u32 offset, u16 words)
  * @hw: pointer to the HW structure
  * @offset: offset in words from module start
  * @words: number of words to read
- * @data: buffer for words reads from Shadow RAM
+ * @data: storage for the words read from Shadow RAM (Little Endian)
  * @last_command: tells the AdminQ that this is the last command
  *
- * Reads 16-bit word buffers from the Shadow RAM using the admin command.
+ * Reads 16-bit Little Endian word buffers from the Shadow RAM using the admin
+ * command.
  */
 static enum ice_status
-ice_read_sr_aq(struct ice_hw *hw, u32 offset, u16 words, u16 *data,
+ice_read_sr_aq(struct ice_hw *hw, u32 offset, u16 words, __le16 *data,
 	       bool last_command)
 {
 	enum ice_status status;
@@ -116,10 +117,11 @@ static enum ice_status
 ice_read_sr_word_aq(struct ice_hw *hw, u16 offset, u16 *data)
 {
 	enum ice_status status;
+	__le16 data_local;
 
-	status = ice_read_sr_aq(hw, offset, 1, data, true);
+	status = ice_read_sr_aq(hw, offset, 1, &data_local, true);
 	if (!status)
-		*data = le16_to_cpu(*(__force __le16 *)data);
+		*data = le16_to_cpu(data_local);
 
 	return status;
 }
-- 
2.25.0.rc1

