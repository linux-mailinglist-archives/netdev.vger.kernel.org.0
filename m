Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB92487BA9
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348658AbiAGR5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:57:44 -0500
Received: from mga18.intel.com ([134.134.136.126]:47970 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348653AbiAGR5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641578263; x=1673114263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/lZ9R4oI1H4lnzrqLGu8bbLIBQb29c6RtQw3KU5BjNA=;
  b=H10SMC8XCPHEkH5bmxL6b0IVOc+9piKKvOpaDhS9F83gwYqfKVmp7tfm
   OEhTBXmHT1GAU84//HeR7OQ368QS1/WULqT8CwNg/uLaKquj/GCImo29P
   9SeWyq+kopjTCZl6MxLm9xpOMnd9II4MFtXK0yV/kDDpq6YGjBcHQaqat
   URUOKoEpRLCFn2siAdvWqJPFX4wXvlZSVnqYgA9VwZHVZmLOR27BeF63C
   Xhpdd5u1T9K94L+LY1a0FPsrnEcxb54+pRQBDvquzQ/KKrPYB1V7OhqHb
   mOA+9RYjv8OETgxtlwixH67AfW80Y8m1Q5rdn/XlrwfZGhNCmoErusiju
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="229716405"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="229716405"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:57:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668831904"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2022 09:57:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next v2 2/6] i40e: Minimize amount of busy-waiting during AQ send
Date:   Fri,  7 Jan 2022 09:57:00 -0800
Message-Id: <20220107175704.438387-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
References: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

The i40e_asq_send_command will now use a non blocking usleep_range if
possible (non-atomic context), instead of busy-waiting udelay. The
usleep_range function uses hrtimers to provide better performance and
removes the negative impact of busy-waiting in time-critical
environments.

1. Rename i40e_asq_send_command to i40e_asq_send_command_atomic
   and add 5th parameter to inform if called from an atomic context.
   Call inside usleep_range (if non-atomic) or udelay (if atomic).

2. Change i40e_asq_send_command to invoke
   i40e_asq_send_command_atomic(..., false).

3. Change two functions:
    - i40e_aq_set_vsi_uc_promisc_on_vlan
    - i40e_aq_set_vsi_mc_promisc_on_vlan
   to explicitly use i40e_asq_send_command_atomic(..., true)
   instead of i40e_asq_send_command, as they use spinlocks and do some
   work in an atomic context.
   All other calls to i40e_asq_send_command remain unchanged.

Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c | 29 ++++++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_common.c |  6 ++--
 .../net/ethernet/intel/i40e/i40e_prototype.h  | 14 +++++----
 3 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 593912b17609..7abef88801fb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -769,21 +769,22 @@ static bool i40e_asq_done(struct i40e_hw *hw)
 }
 
 /**
- *  i40e_asq_send_command - send command to Admin Queue
+ *  i40e_asq_send_command_atomic - send command to Admin Queue
  *  @hw: pointer to the hw struct
  *  @desc: prefilled descriptor describing the command (non DMA mem)
  *  @buff: buffer to use for indirect commands
  *  @buff_size: size of buffer for indirect commands
  *  @cmd_details: pointer to command details structure
+ *  @is_atomic_context: is the function called in an atomic context?
  *
  *  This is the main send command driver routine for the Admin Queue send
  *  queue.  It runs the queue, cleans the queue, etc
  **/
-i40e_status i40e_asq_send_command(struct i40e_hw *hw,
-				struct i40e_aq_desc *desc,
-				void *buff, /* can be NULL */
-				u16  buff_size,
-				struct i40e_asq_cmd_details *cmd_details)
+i40e_status
+i40e_asq_send_command_atomic(struct i40e_hw *hw, struct i40e_aq_desc *desc,
+			     void *buff, /* can be NULL */ u16  buff_size,
+			     struct i40e_asq_cmd_details *cmd_details,
+			     bool is_atomic_context)
 {
 	i40e_status status = 0;
 	struct i40e_dma_mem *dma_buff = NULL;
@@ -910,7 +911,12 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 			 */
 			if (i40e_asq_done(hw))
 				break;
-			udelay(50);
+
+			if (is_atomic_context)
+				udelay(50);
+			else
+				usleep_range(40, 60);
+
 			total_delay += 50;
 		} while (total_delay < hw->aq.asq_cmd_timeout);
 	}
@@ -967,6 +973,15 @@ i40e_status i40e_asq_send_command(struct i40e_hw *hw,
 	return status;
 }
 
+i40e_status
+i40e_asq_send_command(struct i40e_hw *hw, struct i40e_aq_desc *desc,
+		      void *buff, /* can be NULL */ u16  buff_size,
+		      struct i40e_asq_cmd_details *cmd_details)
+{
+	return i40e_asq_send_command_atomic(hw, desc, buff, buff_size,
+					    cmd_details, false);
+}
+
 /**
  *  i40e_fill_default_direct_cmd_desc - AQ descriptor helper function
  *  @desc:     pointer to the temp descriptor (non DMA mem)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index b4d3fed0d2f2..f81a674c8d40 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -2073,7 +2073,8 @@ enum i40e_status_code i40e_aq_set_vsi_mc_promisc_on_vlan(struct i40e_hw *hw,
 	cmd->seid = cpu_to_le16(seid);
 	cmd->vlan_tag = cpu_to_le16(vid | I40E_AQC_SET_VSI_VLAN_VALID);
 
-	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, NULL, 0,
+					      cmd_details, true);
 
 	return status;
 }
@@ -2114,7 +2115,8 @@ enum i40e_status_code i40e_aq_set_vsi_uc_promisc_on_vlan(struct i40e_hw *hw,
 	cmd->seid = cpu_to_le16(seid);
 	cmd->vlan_tag = cpu_to_le16(vid | I40E_AQC_SET_VSI_VLAN_VALID);
 
-	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, NULL, 0,
+					      cmd_details, true);
 
 	return status;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index aaea297640e0..9241b6005ad3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -22,11 +22,15 @@ void i40e_adminq_init_ring_data(struct i40e_hw *hw);
 i40e_status i40e_clean_arq_element(struct i40e_hw *hw,
 					     struct i40e_arq_event_info *e,
 					     u16 *events_pending);
-i40e_status i40e_asq_send_command(struct i40e_hw *hw,
-				struct i40e_aq_desc *desc,
-				void *buff, /* can be NULL */
-				u16  buff_size,
-				struct i40e_asq_cmd_details *cmd_details);
+i40e_status
+i40e_asq_send_command(struct i40e_hw *hw, struct i40e_aq_desc *desc,
+		      void *buff, /* can be NULL */ u16  buff_size,
+		      struct i40e_asq_cmd_details *cmd_details);
+i40e_status
+i40e_asq_send_command_atomic(struct i40e_hw *hw, struct i40e_aq_desc *desc,
+			     void *buff, /* can be NULL */ u16  buff_size,
+			     struct i40e_asq_cmd_details *cmd_details,
+			     bool is_atomic_context);
 
 /* debug function for adminq */
 void i40e_debug_aq(struct i40e_hw *hw, enum i40e_debug_mask mask,
-- 
2.31.1

