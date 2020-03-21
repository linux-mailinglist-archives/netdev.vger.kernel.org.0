Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD01D18DEA2
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgCUIKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:33281 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgCUIKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:35 -0400
IronPort-SDR: vElJrGKzaaZSDvYr5oCv67kXk20gjHC7Lq75cFKEZ4jdl/b9EzBcmsIASHdyF4W8DO7GcLj91w
 SijuCCYAxUpw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:30 -0700
IronPort-SDR: rzo5EIZn3MeMwXa63ZHXYJhDVN6nVSkX8n+LY2aVlUlJDw7yU4JIFIrSC69YDA/wbSA/uGU3aK
 jngK+pPdA3jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737949"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 1/9] ice: use __le16 types for explicitly Little Endian values
Date:   Sat, 21 Mar 2020 01:10:20 -0700
Message-Id: <20200321081028.2763550-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_read_sr_aq function returns words in the Little Endian format.
Remove the need for __force and typecasting by using a local variable in
the ice_read_sr_word_aq function.

Additionally clarify explicitly that the ice_read_sr_aq function takes
storage for __le16 values instead of using u16.

Being explicit about the endianness of this data helps when using tools
like sparse to catch endian-related issues.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index f6e25db22c23..5597ec50a662 100644
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
2.25.1

