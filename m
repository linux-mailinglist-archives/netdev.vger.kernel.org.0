Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60AA468B1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFNUQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:16:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:59939 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNUP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:55 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:55 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Doug Dziggel <douglas.a.dziggel@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/12] i40e: Improve AQ log granularity
Date:   Fri, 14 Jun 2019 13:16:04 -0700
Message-Id: <20190614201610.13566-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
References: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Dziggel <douglas.a.dziggel@intel.com>

This patch makes it possible to log only AQ descriptors, without the
entire AQ message buffers being dumped too. It should greatly reduce
kernel log size in cases where a full AQ dump is not needed.
Selection is made by setting flags in hw->debug_mask.

Additionally, some debug messages that preceded an AQ dump have been
moved to I40E_DEBUG_AQ_COMMAND class, which seems more appropriate.

Signed-off-by: Doug Dziggel <douglas.a.dziggel@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  8 ++--
 drivers/net/ethernet/intel/i40e/i40e_common.c | 40 ++++++++++---------
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 243dcd4bec19..814acbe79ffd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -675,7 +675,7 @@ static u16 i40e_clean_asq(struct i40e_hw *hw)
 	desc = I40E_ADMINQ_DESC(*asq, ntc);
 	details = I40E_ADMINQ_DETAILS(*asq, ntc);
 	while (rd32(hw, hw->aq.asq.head) != ntc) {
-		i40e_debug(hw, I40E_DEBUG_AQ_MESSAGE,
+		i40e_debug(hw, I40E_DEBUG_AQ_COMMAND,
 			   "ntc %d head %d.\n", ntc, rd32(hw, hw->aq.asq.head));
 
 		if (details->callback) {
@@ -835,7 +835,7 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 	}
 
 	/* bump the tail */
-	i40e_debug(hw, I40E_DEBUG_AQ_MESSAGE, "AQTX: desc and buffer:\n");
+	i40e_debug(hw, I40E_DEBUG_AQ_COMMAND, "AQTX: desc and buffer:\n");
 	i40e_debug_aq(hw, I40E_DEBUG_AQ_COMMAND, (void *)desc_on_ring,
 		      buff, buff_size);
 	(hw->aq.asq.next_to_use)++;
@@ -886,7 +886,7 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 		hw->aq.asq_last_status = (enum i40e_admin_queue_err)retval;
 	}
 
-	i40e_debug(hw, I40E_DEBUG_AQ_MESSAGE,
+	i40e_debug(hw, I40E_DEBUG_AQ_COMMAND,
 		   "AQTX: desc and buffer writeback:\n");
 	i40e_debug_aq(hw, I40E_DEBUG_AQ_COMMAND, (void *)desc, buff, buff_size);
 
@@ -995,7 +995,7 @@ i40e_status i40e_clean_arq_element(struct i40e_hw *hw,
 		memcpy(e->msg_buf, hw->aq.arq.r.arq_bi[desc_idx].va,
 		       e->msg_len);
 
-	i40e_debug(hw, I40E_DEBUG_AQ_MESSAGE, "AQRX: desc and buffer:\n");
+	i40e_debug(hw, I40E_DEBUG_AQ_COMMAND, "AQRX: desc and buffer:\n");
 	i40e_debug_aq(hw, I40E_DEBUG_AQ_COMMAND, (void *)desc, e->msg_buf,
 		      hw->aq.arq_buf_size);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index ecb1adaa54ec..641b500ad919 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -281,47 +281,49 @@ void i40e_debug_aq(struct i40e_hw *hw, enum i40e_debug_mask mask, void *desc,
 		   void *buffer, u16 buf_len)
 {
 	struct i40e_aq_desc *aq_desc = (struct i40e_aq_desc *)desc;
+	u32 effective_mask = hw->debug_mask & mask;
+	char prefix[27];
 	u16 len;
 	u8 *buf = (u8 *)buffer;
 
-	if ((!(mask & hw->debug_mask)) || (desc == NULL))
+	if (!effective_mask || !desc)
 		return;
 
 	len = le16_to_cpu(aq_desc->datalen);
 
-	i40e_debug(hw, mask,
+	i40e_debug(hw, mask & I40E_DEBUG_AQ_DESCRIPTOR,
 		   "AQ CMD: opcode 0x%04X, flags 0x%04X, datalen 0x%04X, retval 0x%04X\n",
 		   le16_to_cpu(aq_desc->opcode),
 		   le16_to_cpu(aq_desc->flags),
 		   le16_to_cpu(aq_desc->datalen),
 		   le16_to_cpu(aq_desc->retval));
-	i40e_debug(hw, mask, "\tcookie (h,l) 0x%08X 0x%08X\n",
+	i40e_debug(hw, mask & I40E_DEBUG_AQ_DESCRIPTOR,
+		   "\tcookie (h,l) 0x%08X 0x%08X\n",
 		   le32_to_cpu(aq_desc->cookie_high),
 		   le32_to_cpu(aq_desc->cookie_low));
-	i40e_debug(hw, mask, "\tparam (0,1)  0x%08X 0x%08X\n",
+	i40e_debug(hw, mask & I40E_DEBUG_AQ_DESCRIPTOR,
+		   "\tparam (0,1)  0x%08X 0x%08X\n",
 		   le32_to_cpu(aq_desc->params.internal.param0),
 		   le32_to_cpu(aq_desc->params.internal.param1));
-	i40e_debug(hw, mask, "\taddr (h,l)   0x%08X 0x%08X\n",
+	i40e_debug(hw, mask & I40E_DEBUG_AQ_DESCRIPTOR,
+		   "\taddr (h,l)   0x%08X 0x%08X\n",
 		   le32_to_cpu(aq_desc->params.external.addr_high),
 		   le32_to_cpu(aq_desc->params.external.addr_low));
 
-	if ((buffer != NULL) && (aq_desc->datalen != 0)) {
+	if (buffer && buf_len != 0 && len != 0 &&
+	    (effective_mask & I40E_DEBUG_AQ_DESC_BUFFER)) {
 		i40e_debug(hw, mask, "AQ CMD Buffer:\n");
 		if (buf_len < len)
 			len = buf_len;
-		/* write the full 16-byte chunks */
-		if (hw->debug_mask & mask) {
-			char prefix[27];
-
-			snprintf(prefix, sizeof(prefix),
-				 "i40e %02x:%02x.%x: \t0x",
-				 hw->bus.bus_id,
-				 hw->bus.device,
-				 hw->bus.func);
-
-			print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_OFFSET,
-				       16, 1, buf, len, false);
-		}
+
+		snprintf(prefix, sizeof(prefix),
+			 "i40e %02x:%02x.%x: \t0x",
+			 hw->bus.bus_id,
+			 hw->bus.device,
+			 hw->bus.func);
+
+		print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_OFFSET,
+			       16, 1, buf, len, false);
 	}
 }
 
-- 
2.21.0

