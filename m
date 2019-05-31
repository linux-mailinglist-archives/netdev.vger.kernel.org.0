Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF6C309F2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfEaIPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:64479 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfEaIPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:11 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/13] iavf: replace i40e variables with iavf
Date:   Fri, 31 May 2019 01:15:13 -0700
Message-Id: <20190531081518.16430-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Update the old variables and flags marked as i40e to match
the iavf name of the driver.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c |  80 +--
 drivers/net/ethernet/intel/iavf/iavf_adminq.h |  72 +-
 .../net/ethernet/intel/iavf/iavf_adminq_cmd.h | 656 +++++++++---------
 drivers/net/ethernet/intel/iavf/iavf_common.c | 182 ++---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  12 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  18 +-
 .../net/ethernet/intel/iavf/iavf_prototype.h  |  14 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  12 +-
 drivers/net/ethernet/intel/iavf/iavf_type.h   |   2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  16 +-
 10 files changed, 531 insertions(+), 533 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 59025172f3fa..56172e2974bb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -37,16 +37,16 @@ static enum iavf_status i40e_alloc_adminq_asq_ring(struct iavf_hw *hw)
 	enum iavf_status ret_code;
 
 	ret_code = iavf_allocate_dma_mem(hw, &hw->aq.asq.desc_buf,
-					 i40e_mem_atq_ring,
+					 iavf_mem_atq_ring,
 					 (hw->aq.num_asq_entries *
-					 sizeof(struct i40e_aq_desc)),
+					 sizeof(struct iavf_aq_desc)),
 					 IAVF_ADMINQ_DESC_ALIGNMENT);
 	if (ret_code)
 		return ret_code;
 
 	ret_code = iavf_allocate_virt_mem(hw, &hw->aq.asq.cmd_buf,
 					  (hw->aq.num_asq_entries *
-					  sizeof(struct i40e_asq_cmd_details)));
+					  sizeof(struct iavf_asq_cmd_details)));
 	if (ret_code) {
 		iavf_free_dma_mem(hw, &hw->aq.asq.desc_buf);
 		return ret_code;
@@ -64,9 +64,9 @@ static enum iavf_status i40e_alloc_adminq_arq_ring(struct iavf_hw *hw)
 	enum iavf_status ret_code;
 
 	ret_code = iavf_allocate_dma_mem(hw, &hw->aq.arq.desc_buf,
-					 i40e_mem_arq_ring,
+					 iavf_mem_arq_ring,
 					 (hw->aq.num_arq_entries *
-					 sizeof(struct i40e_aq_desc)),
+					 sizeof(struct iavf_aq_desc)),
 					 IAVF_ADMINQ_DESC_ALIGNMENT);
 
 	return ret_code;
@@ -102,7 +102,7 @@ static void i40e_free_adminq_arq(struct iavf_hw *hw)
  **/
 static enum iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
 {
-	struct i40e_aq_desc *desc;
+	struct iavf_aq_desc *desc;
 	struct iavf_dma_mem *bi;
 	enum iavf_status ret_code;
 	int i;
@@ -123,7 +123,7 @@ static enum iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
 	for (i = 0; i < hw->aq.num_arq_entries; i++) {
 		bi = &hw->aq.arq.r.arq_bi[i];
 		ret_code = iavf_allocate_dma_mem(hw, bi,
-						 i40e_mem_arq_buf,
+						 iavf_mem_arq_buf,
 						 hw->aq.arq_buf_size,
 						 IAVF_ADMINQ_DESC_ALIGNMENT);
 		if (ret_code)
@@ -132,9 +132,9 @@ static enum iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
 		/* now configure the descriptors for use */
 		desc = IAVF_ADMINQ_DESC(hw->aq.arq, i);
 
-		desc->flags = cpu_to_le16(I40E_AQ_FLAG_BUF);
-		if (hw->aq.arq_buf_size > I40E_AQ_LARGE_BUF)
-			desc->flags |= cpu_to_le16(I40E_AQ_FLAG_LB);
+		desc->flags = cpu_to_le16(IAVF_AQ_FLAG_BUF);
+		if (hw->aq.arq_buf_size > IAVF_AQ_LARGE_BUF)
+			desc->flags |= cpu_to_le16(IAVF_AQ_FLAG_LB);
 		desc->opcode = 0;
 		/* This is in accordance with Admin queue design, there is no
 		 * register for buffer size configuration
@@ -186,7 +186,7 @@ static enum iavf_status i40e_alloc_asq_bufs(struct iavf_hw *hw)
 	for (i = 0; i < hw->aq.num_asq_entries; i++) {
 		bi = &hw->aq.asq.r.asq_bi[i];
 		ret_code = iavf_allocate_dma_mem(hw, bi,
-						 i40e_mem_asq_buf,
+						 iavf_mem_asq_buf,
 						 hw->aq.asq_buf_size,
 						 IAVF_ADMINQ_DESC_ALIGNMENT);
 		if (ret_code)
@@ -522,7 +522,7 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
 	iavf_adminq_init_regs(hw);
 
 	/* setup ASQ command write back timeout */
-	hw->aq.asq_cmd_timeout = I40E_ASQ_CMD_TIMEOUT;
+	hw->aq.asq_cmd_timeout = IAVF_ASQ_CMD_TIMEOUT;
 
 	/* allocate the ASQ */
 	ret_code = i40e_init_asq(hw);
@@ -571,13 +571,13 @@ enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw)
 static u16 i40e_clean_asq(struct iavf_hw *hw)
 {
 	struct iavf_adminq_ring *asq = &hw->aq.asq;
-	struct i40e_asq_cmd_details *details;
+	struct iavf_asq_cmd_details *details;
 	u16 ntc = asq->next_to_clean;
-	struct i40e_aq_desc desc_cb;
-	struct i40e_aq_desc *desc;
+	struct iavf_aq_desc desc_cb;
+	struct iavf_aq_desc *desc;
 
 	desc = IAVF_ADMINQ_DESC(*asq, ntc);
-	details = I40E_ADMINQ_DETAILS(*asq, ntc);
+	details = IAVF_ADMINQ_DETAILS(*asq, ntc);
 	while (rd32(hw, hw->aq.asq.head) != ntc) {
 		iavf_debug(hw, IAVF_DEBUG_AQ_MESSAGE,
 			   "ntc %d head %d.\n", ntc, rd32(hw, hw->aq.asq.head));
@@ -588,14 +588,14 @@ static u16 i40e_clean_asq(struct iavf_hw *hw)
 			desc_cb = *desc;
 			cb_func(hw, &desc_cb);
 		}
-		memset((void *)desc, 0, sizeof(struct i40e_aq_desc));
+		memset((void *)desc, 0, sizeof(struct iavf_aq_desc));
 		memset((void *)details, 0,
-		       sizeof(struct i40e_asq_cmd_details));
+		       sizeof(struct iavf_asq_cmd_details));
 		ntc++;
 		if (ntc == asq->count)
 			ntc = 0;
 		desc = IAVF_ADMINQ_DESC(*asq, ntc);
-		details = I40E_ADMINQ_DETAILS(*asq, ntc);
+		details = IAVF_ADMINQ_DETAILS(*asq, ntc);
 	}
 
 	asq->next_to_clean = ntc;
@@ -630,14 +630,14 @@ bool iavf_asq_done(struct iavf_hw *hw)
  *  queue.  It runs the queue, cleans the queue, etc
  **/
 enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
-				       struct i40e_aq_desc *desc,
+				       struct iavf_aq_desc *desc,
 				       void *buff, /* can be NULL */
 				       u16  buff_size,
-				       struct i40e_asq_cmd_details *cmd_details)
+				       struct iavf_asq_cmd_details *cmd_details)
 {
 	struct iavf_dma_mem *dma_buff = NULL;
-	struct i40e_asq_cmd_details *details;
-	struct i40e_aq_desc *desc_on_ring;
+	struct iavf_asq_cmd_details *details;
+	struct iavf_aq_desc *desc_on_ring;
 	bool cmd_completed = false;
 	enum iavf_status status = 0;
 	u16  retval = 0;
@@ -652,7 +652,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 		goto asq_send_command_error;
 	}
 
-	hw->aq.asq_last_status = I40E_AQ_RC_OK;
+	hw->aq.asq_last_status = IAVF_AQ_RC_OK;
 
 	val = rd32(hw, hw->aq.asq.head);
 	if (val >= hw->aq.num_asq_entries) {
@@ -662,7 +662,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 		goto asq_send_command_error;
 	}
 
-	details = I40E_ADMINQ_DETAILS(hw->aq.asq, hw->aq.asq.next_to_use);
+	details = IAVF_ADMINQ_DETAILS(hw->aq.asq, hw->aq.asq.next_to_use);
 	if (cmd_details) {
 		*details = *cmd_details;
 
@@ -677,7 +677,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 				cpu_to_le32(lower_32_bits(details->cookie));
 		}
 	} else {
-		memset(details, 0, sizeof(struct i40e_asq_cmd_details));
+		memset(details, 0, sizeof(struct iavf_asq_cmd_details));
 	}
 
 	/* clear requested flags and then set additional flags if defined */
@@ -781,13 +781,13 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 			retval &= 0xff;
 		}
 		cmd_completed = true;
-		if ((enum i40e_admin_queue_err)retval == I40E_AQ_RC_OK)
+		if ((enum iavf_admin_queue_err)retval == IAVF_AQ_RC_OK)
 			status = 0;
-		else if ((enum i40e_admin_queue_err)retval == I40E_AQ_RC_EBUSY)
+		else if ((enum iavf_admin_queue_err)retval == IAVF_AQ_RC_EBUSY)
 			status = I40E_ERR_NOT_READY;
 		else
 			status = I40E_ERR_ADMIN_QUEUE_ERROR;
-		hw->aq.asq_last_status = (enum i40e_admin_queue_err)retval;
+		hw->aq.asq_last_status = (enum iavf_admin_queue_err)retval;
 	}
 
 	iavf_debug(hw, IAVF_DEBUG_AQ_MESSAGE,
@@ -824,12 +824,12 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
  *
  *  Fill the desc with default values
  **/
-void iavf_fill_default_direct_cmd_desc(struct i40e_aq_desc *desc, u16 opcode)
+void iavf_fill_default_direct_cmd_desc(struct iavf_aq_desc *desc, u16 opcode)
 {
 	/* zero out the desc */
-	memset((void *)desc, 0, sizeof(struct i40e_aq_desc));
+	memset((void *)desc, 0, sizeof(struct iavf_aq_desc));
 	desc->opcode = cpu_to_le16(opcode);
-	desc->flags = cpu_to_le16(I40E_AQ_FLAG_SI);
+	desc->flags = cpu_to_le16(IAVF_AQ_FLAG_SI);
 }
 
 /**
@@ -843,11 +843,11 @@ void iavf_fill_default_direct_cmd_desc(struct i40e_aq_desc *desc, u16 opcode)
  *  left to process through 'pending'
  **/
 enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
-					struct i40e_arq_event_info *e,
+					struct iavf_arq_event_info *e,
 					u16 *pending)
 {
 	u16 ntc = hw->aq.arq.next_to_clean;
-	struct i40e_aq_desc *desc;
+	struct iavf_aq_desc *desc;
 	enum iavf_status ret_code = 0;
 	struct iavf_dma_mem *bi;
 	u16 desc_idx;
@@ -881,9 +881,9 @@ enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
 	desc_idx = ntc;
 
 	hw->aq.arq_last_status =
-		(enum i40e_admin_queue_err)le16_to_cpu(desc->retval);
+		(enum iavf_admin_queue_err)le16_to_cpu(desc->retval);
 	flags = le16_to_cpu(desc->flags);
-	if (flags & I40E_AQ_FLAG_ERR) {
+	if (flags & IAVF_AQ_FLAG_ERR) {
 		ret_code = I40E_ERR_ADMIN_QUEUE_ERROR;
 		iavf_debug(hw,
 			   IAVF_DEBUG_AQ_MESSAGE,
@@ -907,11 +907,11 @@ enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
 	 * size
 	 */
 	bi = &hw->aq.arq.r.arq_bi[ntc];
-	memset((void *)desc, 0, sizeof(struct i40e_aq_desc));
+	memset((void *)desc, 0, sizeof(struct iavf_aq_desc));
 
-	desc->flags = cpu_to_le16(I40E_AQ_FLAG_BUF);
-	if (hw->aq.arq_buf_size > I40E_AQ_LARGE_BUF)
-		desc->flags |= cpu_to_le16(I40E_AQ_FLAG_LB);
+	desc->flags = cpu_to_le16(IAVF_AQ_FLAG_BUF);
+	if (hw->aq.arq_buf_size > IAVF_AQ_LARGE_BUF)
+		desc->flags |= cpu_to_le16(IAVF_AQ_FLAG_LB);
 	desc->datalen = cpu_to_le16((u16)bi->size);
 	desc->params.external.addr_high = cpu_to_le32(upper_32_bits(bi->pa));
 	desc->params.external.addr_low = cpu_to_le32(lower_32_bits(bi->pa));
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.h b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
index 7c06752c0fea..60a6a41d21a0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
@@ -9,7 +9,7 @@
 #include "iavf_adminq_cmd.h"
 
 #define IAVF_ADMINQ_DESC(R, i)   \
-	(&(((struct i40e_aq_desc *)((R).desc_buf.va))[i]))
+	(&(((struct iavf_aq_desc *)((R).desc_buf.va))[i]))
 
 #define IAVF_ADMINQ_DESC_ALIGNMENT 4096
 
@@ -39,22 +39,22 @@ struct iavf_adminq_ring {
 };
 
 /* ASQ transaction details */
-struct i40e_asq_cmd_details {
-	void *callback; /* cast from type I40E_ADMINQ_CALLBACK */
+struct iavf_asq_cmd_details {
+	void *callback; /* cast from type IAVF_ADMINQ_CALLBACK */
 	u64 cookie;
 	u16 flags_ena;
 	u16 flags_dis;
 	bool async;
 	bool postpone;
-	struct i40e_aq_desc *wb_desc;
+	struct iavf_aq_desc *wb_desc;
 };
 
-#define I40E_ADMINQ_DETAILS(R, i)   \
-	(&(((struct i40e_asq_cmd_details *)((R).cmd_buf.va))[i]))
+#define IAVF_ADMINQ_DETAILS(R, i)   \
+	(&(((struct iavf_asq_cmd_details *)((R).cmd_buf.va))[i]))
 
 /* ARQ event information */
-struct i40e_arq_event_info {
-	struct i40e_aq_desc desc;
+struct iavf_arq_event_info {
+	struct iavf_aq_desc desc;
 	u16 msg_len;
 	u16 buf_len;
 	u8 *msg_buf;
@@ -79,8 +79,8 @@ struct iavf_adminq_info {
 	struct mutex arq_mutex; /* Receive queue lock */
 
 	/* last status values on send and receive queues */
-	enum i40e_admin_queue_err asq_last_status;
-	enum i40e_admin_queue_err arq_last_status;
+	enum iavf_admin_queue_err asq_last_status;
+	enum iavf_admin_queue_err arq_last_status;
 };
 
 /**
@@ -91,29 +91,29 @@ struct iavf_adminq_info {
 static inline int i40e_aq_rc_to_posix(int aq_ret, int aq_rc)
 {
 	int aq_to_posix[] = {
-		0,           /* I40E_AQ_RC_OK */
-		-EPERM,      /* I40E_AQ_RC_EPERM */
-		-ENOENT,     /* I40E_AQ_RC_ENOENT */
-		-ESRCH,      /* I40E_AQ_RC_ESRCH */
-		-EINTR,      /* I40E_AQ_RC_EINTR */
-		-EIO,        /* I40E_AQ_RC_EIO */
-		-ENXIO,      /* I40E_AQ_RC_ENXIO */
-		-E2BIG,      /* I40E_AQ_RC_E2BIG */
-		-EAGAIN,     /* I40E_AQ_RC_EAGAIN */
-		-ENOMEM,     /* I40E_AQ_RC_ENOMEM */
-		-EACCES,     /* I40E_AQ_RC_EACCES */
-		-EFAULT,     /* I40E_AQ_RC_EFAULT */
-		-EBUSY,      /* I40E_AQ_RC_EBUSY */
-		-EEXIST,     /* I40E_AQ_RC_EEXIST */
-		-EINVAL,     /* I40E_AQ_RC_EINVAL */
-		-ENOTTY,     /* I40E_AQ_RC_ENOTTY */
-		-ENOSPC,     /* I40E_AQ_RC_ENOSPC */
-		-ENOSYS,     /* I40E_AQ_RC_ENOSYS */
-		-ERANGE,     /* I40E_AQ_RC_ERANGE */
-		-EPIPE,      /* I40E_AQ_RC_EFLUSHED */
-		-ESPIPE,     /* I40E_AQ_RC_BAD_ADDR */
-		-EROFS,      /* I40E_AQ_RC_EMODE */
-		-EFBIG,      /* I40E_AQ_RC_EFBIG */
+		0,           /* IAVF_AQ_RC_OK */
+		-EPERM,      /* IAVF_AQ_RC_EPERM */
+		-ENOENT,     /* IAVF_AQ_RC_ENOENT */
+		-ESRCH,      /* IAVF_AQ_RC_ESRCH */
+		-EINTR,      /* IAVF_AQ_RC_EINTR */
+		-EIO,        /* IAVF_AQ_RC_EIO */
+		-ENXIO,      /* IAVF_AQ_RC_ENXIO */
+		-E2BIG,      /* IAVF_AQ_RC_E2BIG */
+		-EAGAIN,     /* IAVF_AQ_RC_EAGAIN */
+		-ENOMEM,     /* IAVF_AQ_RC_ENOMEM */
+		-EACCES,     /* IAVF_AQ_RC_EACCES */
+		-EFAULT,     /* IAVF_AQ_RC_EFAULT */
+		-EBUSY,      /* IAVF_AQ_RC_EBUSY */
+		-EEXIST,     /* IAVF_AQ_RC_EEXIST */
+		-EINVAL,     /* IAVF_AQ_RC_EINVAL */
+		-ENOTTY,     /* IAVF_AQ_RC_ENOTTY */
+		-ENOSPC,     /* IAVF_AQ_RC_ENOSPC */
+		-ENOSYS,     /* IAVF_AQ_RC_ENOSYS */
+		-ERANGE,     /* IAVF_AQ_RC_ERANGE */
+		-EPIPE,      /* IAVF_AQ_RC_EFLUSHED */
+		-ESPIPE,     /* IAVF_AQ_RC_BAD_ADDR */
+		-EROFS,      /* IAVF_AQ_RC_EMODE */
+		-EFBIG,      /* IAVF_AQ_RC_EFBIG */
 	};
 
 	/* aq_rc is invalid if AQ timed out */
@@ -127,9 +127,9 @@ static inline int i40e_aq_rc_to_posix(int aq_ret, int aq_rc)
 }
 
 /* general information */
-#define I40E_AQ_LARGE_BUF	512
-#define I40E_ASQ_CMD_TIMEOUT	250000  /* usecs */
+#define IAVF_AQ_LARGE_BUF	512
+#define IAVF_ASQ_CMD_TIMEOUT	250000  /* usecs */
 
-void iavf_fill_default_direct_cmd_desc(struct i40e_aq_desc *desc, u16 opcode);
+void iavf_fill_default_direct_cmd_desc(struct iavf_aq_desc *desc, u16 opcode);
 
 #endif /* _IAVF_ADMINQ_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq_cmd.h b/drivers/net/ethernet/intel/iavf/iavf_adminq_cmd.h
index e5ae4a1c0cff..bc512308557b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq_cmd.h
@@ -1,29 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
-#ifndef _I40E_ADMINQ_CMD_H_
-#define _I40E_ADMINQ_CMD_H_
+#ifndef _IAVF_ADMINQ_CMD_H_
+#define _IAVF_ADMINQ_CMD_H_
 
-/* This header file defines the i40e Admin Queue commands and is shared between
- * i40e Firmware and Software.  Do not change the names in this file to IAVF
- * because this file should be diff-able against the i40e version, even
- * though many parts have been removed in this VF version.
+/* This header file defines the iavf Admin Queue commands and is shared between
+ * iavf Firmware and Software.
  *
  * This file needs to comply with the Linux Kernel coding style.
  */
 
-#define I40E_FW_API_VERSION_MAJOR	0x0001
-#define I40E_FW_API_VERSION_MINOR_X722	0x0005
-#define I40E_FW_API_VERSION_MINOR_X710	0x0008
+#define IAVF_FW_API_VERSION_MAJOR	0x0001
+#define IAVF_FW_API_VERSION_MINOR_X722	0x0005
+#define IAVF_FW_API_VERSION_MINOR_X710	0x0008
 
-#define I40E_FW_MINOR_VERSION(_h) ((_h)->mac.type == I40E_MAC_XL710 ? \
-					I40E_FW_API_VERSION_MINOR_X710 : \
-					I40E_FW_API_VERSION_MINOR_X722)
+#define IAVF_FW_MINOR_VERSION(_h) ((_h)->mac.type == IAVF_MAC_XL710 ? \
+					IAVF_FW_API_VERSION_MINOR_X710 : \
+					IAVF_FW_API_VERSION_MINOR_X722)
 
 /* API version 1.7 implements additional link and PHY-specific APIs  */
-#define I40E_MINOR_VER_GET_LINK_INFO_XL710 0x0007
+#define IAVF_MINOR_VER_GET_LINK_INFO_XL710 0x0007
 
-struct i40e_aq_desc {
+struct iavf_aq_desc {
 	__le16 flags;
 	__le16 opcode;
 	__le16 datalen;
@@ -53,234 +51,234 @@ struct i40e_aq_desc {
  */
 
 /* command flags and offsets*/
-#define I40E_AQ_FLAG_DD_SHIFT	0
-#define I40E_AQ_FLAG_CMP_SHIFT	1
-#define I40E_AQ_FLAG_ERR_SHIFT	2
-#define I40E_AQ_FLAG_VFE_SHIFT	3
-#define I40E_AQ_FLAG_LB_SHIFT	9
-#define I40E_AQ_FLAG_RD_SHIFT	10
-#define I40E_AQ_FLAG_VFC_SHIFT	11
-#define I40E_AQ_FLAG_BUF_SHIFT	12
-#define I40E_AQ_FLAG_SI_SHIFT	13
-#define I40E_AQ_FLAG_EI_SHIFT	14
-#define I40E_AQ_FLAG_FE_SHIFT	15
-
-#define I40E_AQ_FLAG_DD		BIT(I40E_AQ_FLAG_DD_SHIFT)  /* 0x1    */
-#define I40E_AQ_FLAG_CMP	BIT(I40E_AQ_FLAG_CMP_SHIFT) /* 0x2    */
-#define I40E_AQ_FLAG_ERR	BIT(I40E_AQ_FLAG_ERR_SHIFT) /* 0x4    */
-#define I40E_AQ_FLAG_VFE	BIT(I40E_AQ_FLAG_VFE_SHIFT) /* 0x8    */
-#define I40E_AQ_FLAG_LB		BIT(I40E_AQ_FLAG_LB_SHIFT)  /* 0x200  */
-#define I40E_AQ_FLAG_RD		BIT(I40E_AQ_FLAG_RD_SHIFT)  /* 0x400  */
-#define I40E_AQ_FLAG_VFC	BIT(I40E_AQ_FLAG_VFC_SHIFT) /* 0x800  */
-#define I40E_AQ_FLAG_BUF	BIT(I40E_AQ_FLAG_BUF_SHIFT) /* 0x1000 */
-#define I40E_AQ_FLAG_SI		BIT(I40E_AQ_FLAG_SI_SHIFT)  /* 0x2000 */
-#define I40E_AQ_FLAG_EI		BIT(I40E_AQ_FLAG_EI_SHIFT)  /* 0x4000 */
-#define I40E_AQ_FLAG_FE		BIT(I40E_AQ_FLAG_FE_SHIFT)  /* 0x8000 */
+#define IAVF_AQ_FLAG_DD_SHIFT	0
+#define IAVF_AQ_FLAG_CMP_SHIFT	1
+#define IAVF_AQ_FLAG_ERR_SHIFT	2
+#define IAVF_AQ_FLAG_VFE_SHIFT	3
+#define IAVF_AQ_FLAG_LB_SHIFT	9
+#define IAVF_AQ_FLAG_RD_SHIFT	10
+#define IAVF_AQ_FLAG_VFC_SHIFT	11
+#define IAVF_AQ_FLAG_BUF_SHIFT	12
+#define IAVF_AQ_FLAG_SI_SHIFT	13
+#define IAVF_AQ_FLAG_EI_SHIFT	14
+#define IAVF_AQ_FLAG_FE_SHIFT	15
+
+#define IAVF_AQ_FLAG_DD		BIT(IAVF_AQ_FLAG_DD_SHIFT)  /* 0x1    */
+#define IAVF_AQ_FLAG_CMP	BIT(IAVF_AQ_FLAG_CMP_SHIFT) /* 0x2    */
+#define IAVF_AQ_FLAG_ERR	BIT(IAVF_AQ_FLAG_ERR_SHIFT) /* 0x4    */
+#define IAVF_AQ_FLAG_VFE	BIT(IAVF_AQ_FLAG_VFE_SHIFT) /* 0x8    */
+#define IAVF_AQ_FLAG_LB		BIT(IAVF_AQ_FLAG_LB_SHIFT)  /* 0x200  */
+#define IAVF_AQ_FLAG_RD		BIT(IAVF_AQ_FLAG_RD_SHIFT)  /* 0x400  */
+#define IAVF_AQ_FLAG_VFC	BIT(IAVF_AQ_FLAG_VFC_SHIFT) /* 0x800  */
+#define IAVF_AQ_FLAG_BUF	BIT(IAVF_AQ_FLAG_BUF_SHIFT) /* 0x1000 */
+#define IAVF_AQ_FLAG_SI		BIT(IAVF_AQ_FLAG_SI_SHIFT)  /* 0x2000 */
+#define IAVF_AQ_FLAG_EI		BIT(IAVF_AQ_FLAG_EI_SHIFT)  /* 0x4000 */
+#define IAVF_AQ_FLAG_FE		BIT(IAVF_AQ_FLAG_FE_SHIFT)  /* 0x8000 */
 
 /* error codes */
-enum i40e_admin_queue_err {
-	I40E_AQ_RC_OK		= 0,  /* success */
-	I40E_AQ_RC_EPERM	= 1,  /* Operation not permitted */
-	I40E_AQ_RC_ENOENT	= 2,  /* No such element */
-	I40E_AQ_RC_ESRCH	= 3,  /* Bad opcode */
-	I40E_AQ_RC_EINTR	= 4,  /* operation interrupted */
-	I40E_AQ_RC_EIO		= 5,  /* I/O error */
-	I40E_AQ_RC_ENXIO	= 6,  /* No such resource */
-	I40E_AQ_RC_E2BIG	= 7,  /* Arg too long */
-	I40E_AQ_RC_EAGAIN	= 8,  /* Try again */
-	I40E_AQ_RC_ENOMEM	= 9,  /* Out of memory */
-	I40E_AQ_RC_EACCES	= 10, /* Permission denied */
-	I40E_AQ_RC_EFAULT	= 11, /* Bad address */
-	I40E_AQ_RC_EBUSY	= 12, /* Device or resource busy */
-	I40E_AQ_RC_EEXIST	= 13, /* object already exists */
-	I40E_AQ_RC_EINVAL	= 14, /* Invalid argument */
-	I40E_AQ_RC_ENOTTY	= 15, /* Not a typewriter */
-	I40E_AQ_RC_ENOSPC	= 16, /* No space left or alloc failure */
-	I40E_AQ_RC_ENOSYS	= 17, /* Function not implemented */
-	I40E_AQ_RC_ERANGE	= 18, /* Parameter out of range */
-	I40E_AQ_RC_EFLUSHED	= 19, /* Cmd flushed due to prev cmd error */
-	I40E_AQ_RC_BAD_ADDR	= 20, /* Descriptor contains a bad pointer */
-	I40E_AQ_RC_EMODE	= 21, /* Op not allowed in current dev mode */
-	I40E_AQ_RC_EFBIG	= 22, /* File too large */
+enum iavf_admin_queue_err {
+	IAVF_AQ_RC_OK		= 0,  /* success */
+	IAVF_AQ_RC_EPERM	= 1,  /* Operation not permitted */
+	IAVF_AQ_RC_ENOENT	= 2,  /* No such element */
+	IAVF_AQ_RC_ESRCH	= 3,  /* Bad opcode */
+	IAVF_AQ_RC_EINTR	= 4,  /* operation interrupted */
+	IAVF_AQ_RC_EIO		= 5,  /* I/O error */
+	IAVF_AQ_RC_ENXIO	= 6,  /* No such resource */
+	IAVF_AQ_RC_E2BIG	= 7,  /* Arg too long */
+	IAVF_AQ_RC_EAGAIN	= 8,  /* Try again */
+	IAVF_AQ_RC_ENOMEM	= 9,  /* Out of memory */
+	IAVF_AQ_RC_EACCES	= 10, /* Permission denied */
+	IAVF_AQ_RC_EFAULT	= 11, /* Bad address */
+	IAVF_AQ_RC_EBUSY	= 12, /* Device or resource busy */
+	IAVF_AQ_RC_EEXIST	= 13, /* object already exists */
+	IAVF_AQ_RC_EINVAL	= 14, /* Invalid argument */
+	IAVF_AQ_RC_ENOTTY	= 15, /* Not a typewriter */
+	IAVF_AQ_RC_ENOSPC	= 16, /* No space left or alloc failure */
+	IAVF_AQ_RC_ENOSYS	= 17, /* Function not implemented */
+	IAVF_AQ_RC_ERANGE	= 18, /* Parameter out of range */
+	IAVF_AQ_RC_EFLUSHED	= 19, /* Cmd flushed due to prev cmd error */
+	IAVF_AQ_RC_BAD_ADDR	= 20, /* Descriptor contains a bad pointer */
+	IAVF_AQ_RC_EMODE	= 21, /* Op not allowed in current dev mode */
+	IAVF_AQ_RC_EFBIG	= 22, /* File too large */
 };
 
 /* Admin Queue command opcodes */
-enum i40e_admin_queue_opc {
+enum iavf_admin_queue_opc {
 	/* aq commands */
-	i40e_aqc_opc_get_version	= 0x0001,
-	i40e_aqc_opc_driver_version	= 0x0002,
-	i40e_aqc_opc_queue_shutdown	= 0x0003,
-	i40e_aqc_opc_set_pf_context	= 0x0004,
+	iavf_aqc_opc_get_version	= 0x0001,
+	iavf_aqc_opc_driver_version	= 0x0002,
+	iavf_aqc_opc_queue_shutdown	= 0x0003,
+	iavf_aqc_opc_set_pf_context	= 0x0004,
 
 	/* resource ownership */
-	i40e_aqc_opc_request_resource	= 0x0008,
-	i40e_aqc_opc_release_resource	= 0x0009,
+	iavf_aqc_opc_request_resource	= 0x0008,
+	iavf_aqc_opc_release_resource	= 0x0009,
 
-	i40e_aqc_opc_list_func_capabilities	= 0x000A,
-	i40e_aqc_opc_list_dev_capabilities	= 0x000B,
+	iavf_aqc_opc_list_func_capabilities	= 0x000A,
+	iavf_aqc_opc_list_dev_capabilities	= 0x000B,
 
 	/* Proxy commands */
-	i40e_aqc_opc_set_proxy_config		= 0x0104,
-	i40e_aqc_opc_set_ns_proxy_table_entry	= 0x0105,
+	iavf_aqc_opc_set_proxy_config		= 0x0104,
+	iavf_aqc_opc_set_ns_proxy_table_entry	= 0x0105,
 
 	/* LAA */
-	i40e_aqc_opc_mac_address_read	= 0x0107,
-	i40e_aqc_opc_mac_address_write	= 0x0108,
+	iavf_aqc_opc_mac_address_read	= 0x0107,
+	iavf_aqc_opc_mac_address_write	= 0x0108,
 
 	/* PXE */
-	i40e_aqc_opc_clear_pxe_mode	= 0x0110,
+	iavf_aqc_opc_clear_pxe_mode	= 0x0110,
 
 	/* WoL commands */
-	i40e_aqc_opc_set_wol_filter	= 0x0120,
-	i40e_aqc_opc_get_wake_reason	= 0x0121,
+	iavf_aqc_opc_set_wol_filter	= 0x0120,
+	iavf_aqc_opc_get_wake_reason	= 0x0121,
 
 	/* internal switch commands */
-	i40e_aqc_opc_get_switch_config		= 0x0200,
-	i40e_aqc_opc_add_statistics		= 0x0201,
-	i40e_aqc_opc_remove_statistics		= 0x0202,
-	i40e_aqc_opc_set_port_parameters	= 0x0203,
-	i40e_aqc_opc_get_switch_resource_alloc	= 0x0204,
-	i40e_aqc_opc_set_switch_config		= 0x0205,
-	i40e_aqc_opc_rx_ctl_reg_read		= 0x0206,
-	i40e_aqc_opc_rx_ctl_reg_write		= 0x0207,
-
-	i40e_aqc_opc_add_vsi			= 0x0210,
-	i40e_aqc_opc_update_vsi_parameters	= 0x0211,
-	i40e_aqc_opc_get_vsi_parameters		= 0x0212,
-
-	i40e_aqc_opc_add_pv			= 0x0220,
-	i40e_aqc_opc_update_pv_parameters	= 0x0221,
-	i40e_aqc_opc_get_pv_parameters		= 0x0222,
-
-	i40e_aqc_opc_add_veb			= 0x0230,
-	i40e_aqc_opc_update_veb_parameters	= 0x0231,
-	i40e_aqc_opc_get_veb_parameters		= 0x0232,
-
-	i40e_aqc_opc_delete_element		= 0x0243,
-
-	i40e_aqc_opc_add_macvlan		= 0x0250,
-	i40e_aqc_opc_remove_macvlan		= 0x0251,
-	i40e_aqc_opc_add_vlan			= 0x0252,
-	i40e_aqc_opc_remove_vlan		= 0x0253,
-	i40e_aqc_opc_set_vsi_promiscuous_modes	= 0x0254,
-	i40e_aqc_opc_add_tag			= 0x0255,
-	i40e_aqc_opc_remove_tag			= 0x0256,
-	i40e_aqc_opc_add_multicast_etag		= 0x0257,
-	i40e_aqc_opc_remove_multicast_etag	= 0x0258,
-	i40e_aqc_opc_update_tag			= 0x0259,
-	i40e_aqc_opc_add_control_packet_filter	= 0x025A,
-	i40e_aqc_opc_remove_control_packet_filter	= 0x025B,
-	i40e_aqc_opc_add_cloud_filters		= 0x025C,
-	i40e_aqc_opc_remove_cloud_filters	= 0x025D,
-	i40e_aqc_opc_clear_wol_switch_filters	= 0x025E,
-
-	i40e_aqc_opc_add_mirror_rule	= 0x0260,
-	i40e_aqc_opc_delete_mirror_rule	= 0x0261,
+	iavf_aqc_opc_get_switch_config		= 0x0200,
+	iavf_aqc_opc_add_statistics		= 0x0201,
+	iavf_aqc_opc_remove_statistics		= 0x0202,
+	iavf_aqc_opc_set_port_parameters	= 0x0203,
+	iavf_aqc_opc_get_switch_resource_alloc	= 0x0204,
+	iavf_aqc_opc_set_switch_config		= 0x0205,
+	iavf_aqc_opc_rx_ctl_reg_read		= 0x0206,
+	iavf_aqc_opc_rx_ctl_reg_write		= 0x0207,
+
+	iavf_aqc_opc_add_vsi			= 0x0210,
+	iavf_aqc_opc_update_vsi_parameters	= 0x0211,
+	iavf_aqc_opc_get_vsi_parameters		= 0x0212,
+
+	iavf_aqc_opc_add_pv			= 0x0220,
+	iavf_aqc_opc_update_pv_parameters	= 0x0221,
+	iavf_aqc_opc_get_pv_parameters		= 0x0222,
+
+	iavf_aqc_opc_add_veb			= 0x0230,
+	iavf_aqc_opc_update_veb_parameters	= 0x0231,
+	iavf_aqc_opc_get_veb_parameters		= 0x0232,
+
+	iavf_aqc_opc_delete_element		= 0x0243,
+
+	iavf_aqc_opc_add_macvlan		= 0x0250,
+	iavf_aqc_opc_remove_macvlan		= 0x0251,
+	iavf_aqc_opc_add_vlan			= 0x0252,
+	iavf_aqc_opc_remove_vlan		= 0x0253,
+	iavf_aqc_opc_set_vsi_promiscuous_modes	= 0x0254,
+	iavf_aqc_opc_add_tag			= 0x0255,
+	iavf_aqc_opc_remove_tag			= 0x0256,
+	iavf_aqc_opc_add_multicast_etag		= 0x0257,
+	iavf_aqc_opc_remove_multicast_etag	= 0x0258,
+	iavf_aqc_opc_update_tag			= 0x0259,
+	iavf_aqc_opc_add_control_packet_filter	= 0x025A,
+	iavf_aqc_opc_remove_control_packet_filter	= 0x025B,
+	iavf_aqc_opc_add_cloud_filters		= 0x025C,
+	iavf_aqc_opc_remove_cloud_filters	= 0x025D,
+	iavf_aqc_opc_clear_wol_switch_filters	= 0x025E,
+
+	iavf_aqc_opc_add_mirror_rule	= 0x0260,
+	iavf_aqc_opc_delete_mirror_rule	= 0x0261,
 
 	/* Dynamic Device Personalization */
-	i40e_aqc_opc_write_personalization_profile	= 0x0270,
-	i40e_aqc_opc_get_personalization_profile_list	= 0x0271,
+	iavf_aqc_opc_write_personalization_profile	= 0x0270,
+	iavf_aqc_opc_get_personalization_profile_list	= 0x0271,
 
 	/* DCB commands */
-	i40e_aqc_opc_dcb_ignore_pfc	= 0x0301,
-	i40e_aqc_opc_dcb_updated	= 0x0302,
-	i40e_aqc_opc_set_dcb_parameters = 0x0303,
+	iavf_aqc_opc_dcb_ignore_pfc	= 0x0301,
+	iavf_aqc_opc_dcb_updated	= 0x0302,
+	iavf_aqc_opc_set_dcb_parameters = 0x0303,
 
 	/* TX scheduler */
-	i40e_aqc_opc_configure_vsi_bw_limit		= 0x0400,
-	i40e_aqc_opc_configure_vsi_ets_sla_bw_limit	= 0x0406,
-	i40e_aqc_opc_configure_vsi_tc_bw		= 0x0407,
-	i40e_aqc_opc_query_vsi_bw_config		= 0x0408,
-	i40e_aqc_opc_query_vsi_ets_sla_config		= 0x040A,
-	i40e_aqc_opc_configure_switching_comp_bw_limit	= 0x0410,
-
-	i40e_aqc_opc_enable_switching_comp_ets			= 0x0413,
-	i40e_aqc_opc_modify_switching_comp_ets			= 0x0414,
-	i40e_aqc_opc_disable_switching_comp_ets			= 0x0415,
-	i40e_aqc_opc_configure_switching_comp_ets_bw_limit	= 0x0416,
-	i40e_aqc_opc_configure_switching_comp_bw_config		= 0x0417,
-	i40e_aqc_opc_query_switching_comp_ets_config		= 0x0418,
-	i40e_aqc_opc_query_port_ets_config			= 0x0419,
-	i40e_aqc_opc_query_switching_comp_bw_config		= 0x041A,
-	i40e_aqc_opc_suspend_port_tx				= 0x041B,
-	i40e_aqc_opc_resume_port_tx				= 0x041C,
-	i40e_aqc_opc_configure_partition_bw			= 0x041D,
+	iavf_aqc_opc_configure_vsi_bw_limit		= 0x0400,
+	iavf_aqc_opc_configure_vsi_ets_sla_bw_limit	= 0x0406,
+	iavf_aqc_opc_configure_vsi_tc_bw		= 0x0407,
+	iavf_aqc_opc_query_vsi_bw_config		= 0x0408,
+	iavf_aqc_opc_query_vsi_ets_sla_config		= 0x040A,
+	iavf_aqc_opc_configure_switching_comp_bw_limit	= 0x0410,
+
+	iavf_aqc_opc_enable_switching_comp_ets			= 0x0413,
+	iavf_aqc_opc_modify_switching_comp_ets			= 0x0414,
+	iavf_aqc_opc_disable_switching_comp_ets			= 0x0415,
+	iavf_aqc_opc_configure_switching_comp_ets_bw_limit	= 0x0416,
+	iavf_aqc_opc_configure_switching_comp_bw_config		= 0x0417,
+	iavf_aqc_opc_query_switching_comp_ets_config		= 0x0418,
+	iavf_aqc_opc_query_port_ets_config			= 0x0419,
+	iavf_aqc_opc_query_switching_comp_bw_config		= 0x041A,
+	iavf_aqc_opc_suspend_port_tx				= 0x041B,
+	iavf_aqc_opc_resume_port_tx				= 0x041C,
+	iavf_aqc_opc_configure_partition_bw			= 0x041D,
 	/* hmc */
-	i40e_aqc_opc_query_hmc_resource_profile	= 0x0500,
-	i40e_aqc_opc_set_hmc_resource_profile	= 0x0501,
+	iavf_aqc_opc_query_hmc_resource_profile	= 0x0500,
+	iavf_aqc_opc_set_hmc_resource_profile	= 0x0501,
 
 	/* phy commands*/
-	i40e_aqc_opc_get_phy_abilities		= 0x0600,
-	i40e_aqc_opc_set_phy_config		= 0x0601,
-	i40e_aqc_opc_set_mac_config		= 0x0603,
-	i40e_aqc_opc_set_link_restart_an	= 0x0605,
-	i40e_aqc_opc_get_link_status		= 0x0607,
-	i40e_aqc_opc_set_phy_int_mask		= 0x0613,
-	i40e_aqc_opc_get_local_advt_reg		= 0x0614,
-	i40e_aqc_opc_set_local_advt_reg		= 0x0615,
-	i40e_aqc_opc_get_partner_advt		= 0x0616,
-	i40e_aqc_opc_set_lb_modes		= 0x0618,
-	i40e_aqc_opc_get_phy_wol_caps		= 0x0621,
-	i40e_aqc_opc_set_phy_debug		= 0x0622,
-	i40e_aqc_opc_upload_ext_phy_fm		= 0x0625,
-	i40e_aqc_opc_run_phy_activity		= 0x0626,
-	i40e_aqc_opc_set_phy_register		= 0x0628,
-	i40e_aqc_opc_get_phy_register		= 0x0629,
+	iavf_aqc_opc_get_phy_abilities		= 0x0600,
+	iavf_aqc_opc_set_phy_config		= 0x0601,
+	iavf_aqc_opc_set_mac_config		= 0x0603,
+	iavf_aqc_opc_set_link_restart_an	= 0x0605,
+	iavf_aqc_opc_get_link_status		= 0x0607,
+	iavf_aqc_opc_set_phy_int_mask		= 0x0613,
+	iavf_aqc_opc_get_local_advt_reg		= 0x0614,
+	iavf_aqc_opc_set_local_advt_reg		= 0x0615,
+	iavf_aqc_opc_get_partner_advt		= 0x0616,
+	iavf_aqc_opc_set_lb_modes		= 0x0618,
+	iavf_aqc_opc_get_phy_wol_caps		= 0x0621,
+	iavf_aqc_opc_set_phy_debug		= 0x0622,
+	iavf_aqc_opc_upload_ext_phy_fm		= 0x0625,
+	iavf_aqc_opc_run_phy_activity		= 0x0626,
+	iavf_aqc_opc_set_phy_register		= 0x0628,
+	iavf_aqc_opc_get_phy_register		= 0x0629,
 
 	/* NVM commands */
-	i40e_aqc_opc_nvm_read			= 0x0701,
-	i40e_aqc_opc_nvm_erase			= 0x0702,
-	i40e_aqc_opc_nvm_update			= 0x0703,
-	i40e_aqc_opc_nvm_config_read		= 0x0704,
-	i40e_aqc_opc_nvm_config_write		= 0x0705,
-	i40e_aqc_opc_oem_post_update		= 0x0720,
-	i40e_aqc_opc_thermal_sensor		= 0x0721,
+	iavf_aqc_opc_nvm_read			= 0x0701,
+	iavf_aqc_opc_nvm_erase			= 0x0702,
+	iavf_aqc_opc_nvm_update			= 0x0703,
+	iavf_aqc_opc_nvm_config_read		= 0x0704,
+	iavf_aqc_opc_nvm_config_write		= 0x0705,
+	iavf_aqc_opc_oem_post_update		= 0x0720,
+	iavf_aqc_opc_thermal_sensor		= 0x0721,
 
 	/* virtualization commands */
-	i40e_aqc_opc_send_msg_to_pf		= 0x0801,
-	i40e_aqc_opc_send_msg_to_vf		= 0x0802,
-	i40e_aqc_opc_send_msg_to_peer		= 0x0803,
+	iavf_aqc_opc_send_msg_to_pf		= 0x0801,
+	iavf_aqc_opc_send_msg_to_vf		= 0x0802,
+	iavf_aqc_opc_send_msg_to_peer		= 0x0803,
 
 	/* alternate structure */
-	i40e_aqc_opc_alternate_write		= 0x0900,
-	i40e_aqc_opc_alternate_write_indirect	= 0x0901,
-	i40e_aqc_opc_alternate_read		= 0x0902,
-	i40e_aqc_opc_alternate_read_indirect	= 0x0903,
-	i40e_aqc_opc_alternate_write_done	= 0x0904,
-	i40e_aqc_opc_alternate_set_mode		= 0x0905,
-	i40e_aqc_opc_alternate_clear_port	= 0x0906,
+	iavf_aqc_opc_alternate_write		= 0x0900,
+	iavf_aqc_opc_alternate_write_indirect	= 0x0901,
+	iavf_aqc_opc_alternate_read		= 0x0902,
+	iavf_aqc_opc_alternate_read_indirect	= 0x0903,
+	iavf_aqc_opc_alternate_write_done	= 0x0904,
+	iavf_aqc_opc_alternate_set_mode		= 0x0905,
+	iavf_aqc_opc_alternate_clear_port	= 0x0906,
 
 	/* LLDP commands */
-	i40e_aqc_opc_lldp_get_mib	= 0x0A00,
-	i40e_aqc_opc_lldp_update_mib	= 0x0A01,
-	i40e_aqc_opc_lldp_add_tlv	= 0x0A02,
-	i40e_aqc_opc_lldp_update_tlv	= 0x0A03,
-	i40e_aqc_opc_lldp_delete_tlv	= 0x0A04,
-	i40e_aqc_opc_lldp_stop		= 0x0A05,
-	i40e_aqc_opc_lldp_start		= 0x0A06,
+	iavf_aqc_opc_lldp_get_mib	= 0x0A00,
+	iavf_aqc_opc_lldp_update_mib	= 0x0A01,
+	iavf_aqc_opc_lldp_add_tlv	= 0x0A02,
+	iavf_aqc_opc_lldp_update_tlv	= 0x0A03,
+	iavf_aqc_opc_lldp_delete_tlv	= 0x0A04,
+	iavf_aqc_opc_lldp_stop		= 0x0A05,
+	iavf_aqc_opc_lldp_start		= 0x0A06,
 
 	/* Tunnel commands */
-	i40e_aqc_opc_add_udp_tunnel	= 0x0B00,
-	i40e_aqc_opc_del_udp_tunnel	= 0x0B01,
-	i40e_aqc_opc_set_rss_key	= 0x0B02,
-	i40e_aqc_opc_set_rss_lut	= 0x0B03,
-	i40e_aqc_opc_get_rss_key	= 0x0B04,
-	i40e_aqc_opc_get_rss_lut	= 0x0B05,
+	iavf_aqc_opc_add_udp_tunnel	= 0x0B00,
+	iavf_aqc_opc_del_udp_tunnel	= 0x0B01,
+	iavf_aqc_opc_set_rss_key	= 0x0B02,
+	iavf_aqc_opc_set_rss_lut	= 0x0B03,
+	iavf_aqc_opc_get_rss_key	= 0x0B04,
+	iavf_aqc_opc_get_rss_lut	= 0x0B05,
 
 	/* Async Events */
-	i40e_aqc_opc_event_lan_overflow		= 0x1001,
+	iavf_aqc_opc_event_lan_overflow		= 0x1001,
 
 	/* OEM commands */
-	i40e_aqc_opc_oem_parameter_change	= 0xFE00,
-	i40e_aqc_opc_oem_device_status_change	= 0xFE01,
-	i40e_aqc_opc_oem_ocsd_initialize	= 0xFE02,
-	i40e_aqc_opc_oem_ocbb_initialize	= 0xFE03,
+	iavf_aqc_opc_oem_parameter_change	= 0xFE00,
+	iavf_aqc_opc_oem_device_status_change	= 0xFE01,
+	iavf_aqc_opc_oem_ocsd_initialize	= 0xFE02,
+	iavf_aqc_opc_oem_ocbb_initialize	= 0xFE03,
 
 	/* debug commands */
-	i40e_aqc_opc_debug_read_reg		= 0xFF03,
-	i40e_aqc_opc_debug_write_reg		= 0xFF04,
-	i40e_aqc_opc_debug_modify_reg		= 0xFF07,
-	i40e_aqc_opc_debug_dump_internals	= 0xFF08,
+	iavf_aqc_opc_debug_read_reg		= 0xFF03,
+	iavf_aqc_opc_debug_write_reg		= 0xFF04,
+	iavf_aqc_opc_debug_modify_reg		= 0xFF07,
+	iavf_aqc_opc_debug_dump_internals	= 0xFF08,
 };
 
 /* command structures and indirect data structures */
@@ -301,131 +299,131 @@ enum i40e_admin_queue_opc {
  * structure is not of the correct size, otherwise it creates an enum that is
  * never used.
  */
-#define I40E_CHECK_STRUCT_LEN(n, X) enum i40e_static_assert_enum_##X \
-	{ i40e_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
+#define IAVF_CHECK_STRUCT_LEN(n, X) enum iavf_static_assert_enum_##X \
+	{ iavf_static_assert_##X = (n) / ((sizeof(struct X) == (n)) ? 1 : 0) }
 
 /* This macro is used extensively to ensure that command structures are 16
  * bytes in length as they have to map to the raw array of that size.
  */
-#define I40E_CHECK_CMD_LENGTH(X)	I40E_CHECK_STRUCT_LEN(16, X)
+#define IAVF_CHECK_CMD_LENGTH(X)	IAVF_CHECK_STRUCT_LEN(16, X)
 
 /* Queue Shutdown (direct 0x0003) */
-struct i40e_aqc_queue_shutdown {
+struct iavf_aqc_queue_shutdown {
 	__le32	driver_unloading;
-#define I40E_AQ_DRIVER_UNLOADING	0x1
+#define IAVF_AQ_DRIVER_UNLOADING	0x1
 	u8	reserved[12];
 };
 
-I40E_CHECK_CMD_LENGTH(i40e_aqc_queue_shutdown);
+IAVF_CHECK_CMD_LENGTH(iavf_aqc_queue_shutdown);
 
-struct i40e_aqc_vsi_properties_data {
+struct iavf_aqc_vsi_properties_data {
 	/* first 96 byte are written by SW */
 	__le16	valid_sections;
-#define I40E_AQ_VSI_PROP_SWITCH_VALID		0x0001
-#define I40E_AQ_VSI_PROP_SECURITY_VALID		0x0002
-#define I40E_AQ_VSI_PROP_VLAN_VALID		0x0004
-#define I40E_AQ_VSI_PROP_CAS_PV_VALID		0x0008
-#define I40E_AQ_VSI_PROP_INGRESS_UP_VALID	0x0010
-#define I40E_AQ_VSI_PROP_EGRESS_UP_VALID	0x0020
-#define I40E_AQ_VSI_PROP_QUEUE_MAP_VALID	0x0040
-#define I40E_AQ_VSI_PROP_QUEUE_OPT_VALID	0x0080
-#define I40E_AQ_VSI_PROP_OUTER_UP_VALID		0x0100
-#define I40E_AQ_VSI_PROP_SCHED_VALID		0x0200
+#define IAVF_AQ_VSI_PROP_SWITCH_VALID		0x0001
+#define IAVF_AQ_VSI_PROP_SECURITY_VALID		0x0002
+#define IAVF_AQ_VSI_PROP_VLAN_VALID		0x0004
+#define IAVF_AQ_VSI_PROP_CAS_PV_VALID		0x0008
+#define IAVF_AQ_VSI_PROP_INGRESS_UP_VALID	0x0010
+#define IAVF_AQ_VSI_PROP_EGRESS_UP_VALID	0x0020
+#define IAVF_AQ_VSI_PROP_QUEUE_MAP_VALID	0x0040
+#define IAVF_AQ_VSI_PROP_QUEUE_OPT_VALID	0x0080
+#define IAVF_AQ_VSI_PROP_OUTER_UP_VALID		0x0100
+#define IAVF_AQ_VSI_PROP_SCHED_VALID		0x0200
 	/* switch section */
 	__le16	switch_id; /* 12bit id combined with flags below */
-#define I40E_AQ_VSI_SW_ID_SHIFT		0x0000
-#define I40E_AQ_VSI_SW_ID_MASK		(0xFFF << I40E_AQ_VSI_SW_ID_SHIFT)
-#define I40E_AQ_VSI_SW_ID_FLAG_NOT_STAG	0x1000
-#define I40E_AQ_VSI_SW_ID_FLAG_ALLOW_LB	0x2000
-#define I40E_AQ_VSI_SW_ID_FLAG_LOCAL_LB	0x4000
+#define IAVF_AQ_VSI_SW_ID_SHIFT		0x0000
+#define IAVF_AQ_VSI_SW_ID_MASK		(0xFFF << IAVF_AQ_VSI_SW_ID_SHIFT)
+#define IAVF_AQ_VSI_SW_ID_FLAG_NOT_STAG	0x1000
+#define IAVF_AQ_VSI_SW_ID_FLAG_ALLOW_LB	0x2000
+#define IAVF_AQ_VSI_SW_ID_FLAG_LOCAL_LB	0x4000
 	u8	sw_reserved[2];
 	/* security section */
 	u8	sec_flags;
-#define I40E_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD	0x01
-#define I40E_AQ_VSI_SEC_FLAG_ENABLE_VLAN_CHK	0x02
-#define I40E_AQ_VSI_SEC_FLAG_ENABLE_MAC_CHK	0x04
+#define IAVF_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD	0x01
+#define IAVF_AQ_VSI_SEC_FLAG_ENABLE_VLAN_CHK	0x02
+#define IAVF_AQ_VSI_SEC_FLAG_ENABLE_MAC_CHK	0x04
 	u8	sec_reserved;
 	/* VLAN section */
 	__le16	pvid; /* VLANS include priority bits */
 	__le16	fcoe_pvid;
 	u8	port_vlan_flags;
-#define I40E_AQ_VSI_PVLAN_MODE_SHIFT	0x00
-#define I40E_AQ_VSI_PVLAN_MODE_MASK	(0x03 << \
-					 I40E_AQ_VSI_PVLAN_MODE_SHIFT)
-#define I40E_AQ_VSI_PVLAN_MODE_TAGGED	0x01
-#define I40E_AQ_VSI_PVLAN_MODE_UNTAGGED	0x02
-#define I40E_AQ_VSI_PVLAN_MODE_ALL	0x03
-#define I40E_AQ_VSI_PVLAN_INSERT_PVID	0x04
-#define I40E_AQ_VSI_PVLAN_EMOD_SHIFT	0x03
-#define I40E_AQ_VSI_PVLAN_EMOD_MASK	(0x3 << \
-					 I40E_AQ_VSI_PVLAN_EMOD_SHIFT)
-#define I40E_AQ_VSI_PVLAN_EMOD_STR_BOTH	0x0
-#define I40E_AQ_VSI_PVLAN_EMOD_STR_UP	0x08
-#define I40E_AQ_VSI_PVLAN_EMOD_STR	0x10
-#define I40E_AQ_VSI_PVLAN_EMOD_NOTHING	0x18
+#define IAVF_AQ_VSI_PVLAN_MODE_SHIFT	0x00
+#define IAVF_AQ_VSI_PVLAN_MODE_MASK	(0x03 << \
+					 IAVF_AQ_VSI_PVLAN_MODE_SHIFT)
+#define IAVF_AQ_VSI_PVLAN_MODE_TAGGED	0x01
+#define IAVF_AQ_VSI_PVLAN_MODE_UNTAGGED	0x02
+#define IAVF_AQ_VSI_PVLAN_MODE_ALL	0x03
+#define IAVF_AQ_VSI_PVLAN_INSERT_PVID	0x04
+#define IAVF_AQ_VSI_PVLAN_EMOD_SHIFT	0x03
+#define IAVF_AQ_VSI_PVLAN_EMOD_MASK	(0x3 << \
+					 IAVF_AQ_VSI_PVLAN_EMOD_SHIFT)
+#define IAVF_AQ_VSI_PVLAN_EMOD_STR_BOTH	0x0
+#define IAVF_AQ_VSI_PVLAN_EMOD_STR_UP	0x08
+#define IAVF_AQ_VSI_PVLAN_EMOD_STR	0x10
+#define IAVF_AQ_VSI_PVLAN_EMOD_NOTHING	0x18
 	u8	pvlan_reserved[3];
 	/* ingress egress up sections */
 	__le32	ingress_table; /* bitmap, 3 bits per up */
-#define I40E_AQ_VSI_UP_TABLE_UP0_SHIFT	0
-#define I40E_AQ_VSI_UP_TABLE_UP0_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP0_SHIFT)
-#define I40E_AQ_VSI_UP_TABLE_UP1_SHIFT	3
-#define I40E_AQ_VSI_UP_TABLE_UP1_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP1_SHIFT)
-#define I40E_AQ_VSI_UP_TABLE_UP2_SHIFT	6
-#define I40E_AQ_VSI_UP_TABLE_UP2_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP2_SHIFT)
-#define I40E_AQ_VSI_UP_TABLE_UP3_SHIFT	9
-#define I40E_AQ_VSI_UP_TABLE_UP3_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP3_SHIFT)
-#define I40E_AQ_VSI_UP_TABLE_UP4_SHIFT	12
-#define I40E_AQ_VSI_UP_TABLE_UP4_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP4_SHIFT)
-#define I40E_AQ_VSI_UP_TABLE_UP5_SHIFT	15
-#define I40E_AQ_VSI_UP_TABLE_UP5_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP5_SHIFT)
-#define I40E_AQ_VSI_UP_TABLE_UP6_SHIFT	18
-#define I40E_AQ_VSI_UP_TABLE_UP6_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP6_SHIFT)
-#define I40E_AQ_VSI_UP_TABLE_UP7_SHIFT	21
-#define I40E_AQ_VSI_UP_TABLE_UP7_MASK	(0x7 << \
-					 I40E_AQ_VSI_UP_TABLE_UP7_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP0_SHIFT	0
+#define IAVF_AQ_VSI_UP_TABLE_UP0_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP0_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP1_SHIFT	3
+#define IAVF_AQ_VSI_UP_TABLE_UP1_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP1_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP2_SHIFT	6
+#define IAVF_AQ_VSI_UP_TABLE_UP2_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP2_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP3_SHIFT	9
+#define IAVF_AQ_VSI_UP_TABLE_UP3_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP3_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP4_SHIFT	12
+#define IAVF_AQ_VSI_UP_TABLE_UP4_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP4_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP5_SHIFT	15
+#define IAVF_AQ_VSI_UP_TABLE_UP5_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP5_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP6_SHIFT	18
+#define IAVF_AQ_VSI_UP_TABLE_UP6_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP6_SHIFT)
+#define IAVF_AQ_VSI_UP_TABLE_UP7_SHIFT	21
+#define IAVF_AQ_VSI_UP_TABLE_UP7_MASK	(0x7 << \
+					 IAVF_AQ_VSI_UP_TABLE_UP7_SHIFT)
 	__le32	egress_table;   /* same defines as for ingress table */
 	/* cascaded PV section */
 	__le16	cas_pv_tag;
 	u8	cas_pv_flags;
-#define I40E_AQ_VSI_CAS_PV_TAGX_SHIFT		0x00
-#define I40E_AQ_VSI_CAS_PV_TAGX_MASK		(0x03 << \
-						 I40E_AQ_VSI_CAS_PV_TAGX_SHIFT)
-#define I40E_AQ_VSI_CAS_PV_TAGX_LEAVE		0x00
-#define I40E_AQ_VSI_CAS_PV_TAGX_REMOVE		0x01
-#define I40E_AQ_VSI_CAS_PV_TAGX_COPY		0x02
-#define I40E_AQ_VSI_CAS_PV_INSERT_TAG		0x10
-#define I40E_AQ_VSI_CAS_PV_ETAG_PRUNE		0x20
-#define I40E_AQ_VSI_CAS_PV_ACCEPT_HOST_TAG	0x40
+#define IAVF_AQ_VSI_CAS_PV_TAGX_SHIFT		0x00
+#define IAVF_AQ_VSI_CAS_PV_TAGX_MASK		(0x03 << \
+						 IAVF_AQ_VSI_CAS_PV_TAGX_SHIFT)
+#define IAVF_AQ_VSI_CAS_PV_TAGX_LEAVE		0x00
+#define IAVF_AQ_VSI_CAS_PV_TAGX_REMOVE		0x01
+#define IAVF_AQ_VSI_CAS_PV_TAGX_COPY		0x02
+#define IAVF_AQ_VSI_CAS_PV_INSERT_TAG		0x10
+#define IAVF_AQ_VSI_CAS_PV_ETAG_PRUNE		0x20
+#define IAVF_AQ_VSI_CAS_PV_ACCEPT_HOST_TAG	0x40
 	u8	cas_pv_reserved;
 	/* queue mapping section */
 	__le16	mapping_flags;
-#define I40E_AQ_VSI_QUE_MAP_CONTIG	0x0
-#define I40E_AQ_VSI_QUE_MAP_NONCONTIG	0x1
+#define IAVF_AQ_VSI_QUE_MAP_CONTIG	0x0
+#define IAVF_AQ_VSI_QUE_MAP_NONCONTIG	0x1
 	__le16	queue_mapping[16];
-#define I40E_AQ_VSI_QUEUE_SHIFT		0x0
-#define I40E_AQ_VSI_QUEUE_MASK		(0x7FF << I40E_AQ_VSI_QUEUE_SHIFT)
+#define IAVF_AQ_VSI_QUEUE_SHIFT		0x0
+#define IAVF_AQ_VSI_QUEUE_MASK		(0x7FF << IAVF_AQ_VSI_QUEUE_SHIFT)
 	__le16	tc_mapping[8];
-#define I40E_AQ_VSI_TC_QUE_OFFSET_SHIFT	0
-#define I40E_AQ_VSI_TC_QUE_OFFSET_MASK	(0x1FF << \
-					 I40E_AQ_VSI_TC_QUE_OFFSET_SHIFT)
-#define I40E_AQ_VSI_TC_QUE_NUMBER_SHIFT	9
-#define I40E_AQ_VSI_TC_QUE_NUMBER_MASK	(0x7 << \
-					 I40E_AQ_VSI_TC_QUE_NUMBER_SHIFT)
+#define IAVF_AQ_VSI_TC_QUE_OFFSET_SHIFT	0
+#define IAVF_AQ_VSI_TC_QUE_OFFSET_MASK	(0x1FF << \
+					 IAVF_AQ_VSI_TC_QUE_OFFSET_SHIFT)
+#define IAVF_AQ_VSI_TC_QUE_NUMBER_SHIFT	9
+#define IAVF_AQ_VSI_TC_QUE_NUMBER_MASK	(0x7 << \
+					 IAVF_AQ_VSI_TC_QUE_NUMBER_SHIFT)
 	/* queueing option section */
 	u8	queueing_opt_flags;
-#define I40E_AQ_VSI_QUE_OPT_MULTICAST_UDP_ENA	0x04
-#define I40E_AQ_VSI_QUE_OPT_UNICAST_UDP_ENA	0x08
-#define I40E_AQ_VSI_QUE_OPT_TCP_ENA	0x10
-#define I40E_AQ_VSI_QUE_OPT_FCOE_ENA	0x20
-#define I40E_AQ_VSI_QUE_OPT_RSS_LUT_PF	0x00
-#define I40E_AQ_VSI_QUE_OPT_RSS_LUT_VSI	0x40
+#define IAVF_AQ_VSI_QUE_OPT_MULTICAST_UDP_ENA	0x04
+#define IAVF_AQ_VSI_QUE_OPT_UNICAST_UDP_ENA	0x08
+#define IAVF_AQ_VSI_QUE_OPT_TCP_ENA	0x10
+#define IAVF_AQ_VSI_QUE_OPT_FCOE_ENA	0x20
+#define IAVF_AQ_VSI_QUE_OPT_RSS_LUT_PF	0x00
+#define IAVF_AQ_VSI_QUE_OPT_RSS_LUT_VSI	0x40
 	u8	queueing_opt_reserved[3];
 	/* scheduler section */
 	u8	up_enable_bits;
@@ -435,18 +433,18 @@ struct i40e_aqc_vsi_properties_data {
 	u8	cmd_reserved[8];
 	/* last 32 bytes are written by FW */
 	__le16	qs_handle[8];
-#define I40E_AQ_VSI_QS_HANDLE_INVALID	0xFFFF
+#define IAVF_AQ_VSI_QS_HANDLE_INVALID	0xFFFF
 	__le16	stat_counter_idx;
 	__le16	sched_id;
 	u8	resp_reserved[12];
 };
 
-I40E_CHECK_STRUCT_LEN(128, i40e_aqc_vsi_properties_data);
+IAVF_CHECK_STRUCT_LEN(128, iavf_aqc_vsi_properties_data);
 
 /* Get VEB Parameters (direct 0x0232)
- * uses i40e_aqc_switch_seid for the descriptor
+ * uses iavf_aqc_switch_seid for the descriptor
  */
-struct i40e_aqc_get_veb_parameters_completion {
+struct iavf_aqc_get_veb_parameters_completion {
 	__le16	seid;
 	__le16	switch_id;
 	__le16	veb_flags; /* only the first/last flags from 0x0230 is valid */
@@ -456,75 +454,75 @@ struct i40e_aqc_get_veb_parameters_completion {
 	u8	reserved[4];
 };
 
-I40E_CHECK_CMD_LENGTH(i40e_aqc_get_veb_parameters_completion);
-
-#define I40E_LINK_SPEED_100MB_SHIFT	0x1
-#define I40E_LINK_SPEED_1000MB_SHIFT	0x2
-#define I40E_LINK_SPEED_10GB_SHIFT	0x3
-#define I40E_LINK_SPEED_40GB_SHIFT	0x4
-#define I40E_LINK_SPEED_20GB_SHIFT	0x5
-#define I40E_LINK_SPEED_25GB_SHIFT	0x6
-
-enum i40e_aq_link_speed {
-	I40E_LINK_SPEED_UNKNOWN	= 0,
-	I40E_LINK_SPEED_100MB	= BIT(I40E_LINK_SPEED_100MB_SHIFT),
-	I40E_LINK_SPEED_1GB	= BIT(I40E_LINK_SPEED_1000MB_SHIFT),
-	I40E_LINK_SPEED_10GB	= BIT(I40E_LINK_SPEED_10GB_SHIFT),
-	I40E_LINK_SPEED_40GB	= BIT(I40E_LINK_SPEED_40GB_SHIFT),
-	I40E_LINK_SPEED_20GB	= BIT(I40E_LINK_SPEED_20GB_SHIFT),
-	I40E_LINK_SPEED_25GB	= BIT(I40E_LINK_SPEED_25GB_SHIFT),
+IAVF_CHECK_CMD_LENGTH(iavf_aqc_get_veb_parameters_completion);
+
+#define IAVF_LINK_SPEED_100MB_SHIFT	0x1
+#define IAVF_LINK_SPEED_1000MB_SHIFT	0x2
+#define IAVF_LINK_SPEED_10GB_SHIFT	0x3
+#define IAVF_LINK_SPEED_40GB_SHIFT	0x4
+#define IAVF_LINK_SPEED_20GB_SHIFT	0x5
+#define IAVF_LINK_SPEED_25GB_SHIFT	0x6
+
+enum iavf_aq_link_speed {
+	IAVF_LINK_SPEED_UNKNOWN	= 0,
+	IAVF_LINK_SPEED_100MB	= BIT(IAVF_LINK_SPEED_100MB_SHIFT),
+	IAVF_LINK_SPEED_1GB	= BIT(IAVF_LINK_SPEED_1000MB_SHIFT),
+	IAVF_LINK_SPEED_10GB	= BIT(IAVF_LINK_SPEED_10GB_SHIFT),
+	IAVF_LINK_SPEED_40GB	= BIT(IAVF_LINK_SPEED_40GB_SHIFT),
+	IAVF_LINK_SPEED_20GB	= BIT(IAVF_LINK_SPEED_20GB_SHIFT),
+	IAVF_LINK_SPEED_25GB	= BIT(IAVF_LINK_SPEED_25GB_SHIFT),
 };
 
 /* Send to PF command (indirect 0x0801) id is only used by PF
  * Send to VF command (indirect 0x0802) id is only used by PF
  * Send to Peer PF command (indirect 0x0803)
  */
-struct i40e_aqc_pf_vf_message {
+struct iavf_aqc_pf_vf_message {
 	__le32	id;
 	u8	reserved[4];
 	__le32	addr_high;
 	__le32	addr_low;
 };
 
-I40E_CHECK_CMD_LENGTH(i40e_aqc_pf_vf_message);
+IAVF_CHECK_CMD_LENGTH(iavf_aqc_pf_vf_message);
 
-struct i40e_aqc_get_set_rss_key {
-#define I40E_AQC_SET_RSS_KEY_VSI_VALID		BIT(15)
-#define I40E_AQC_SET_RSS_KEY_VSI_ID_SHIFT	0
-#define I40E_AQC_SET_RSS_KEY_VSI_ID_MASK	(0x3FF << \
-					I40E_AQC_SET_RSS_KEY_VSI_ID_SHIFT)
+struct iavf_aqc_get_set_rss_key {
+#define IAVF_AQC_SET_RSS_KEY_VSI_VALID		BIT(15)
+#define IAVF_AQC_SET_RSS_KEY_VSI_ID_SHIFT	0
+#define IAVF_AQC_SET_RSS_KEY_VSI_ID_MASK	(0x3FF << \
+					IAVF_AQC_SET_RSS_KEY_VSI_ID_SHIFT)
 	__le16	vsi_id;
 	u8	reserved[6];
 	__le32	addr_high;
 	__le32	addr_low;
 };
 
-I40E_CHECK_CMD_LENGTH(i40e_aqc_get_set_rss_key);
+IAVF_CHECK_CMD_LENGTH(iavf_aqc_get_set_rss_key);
 
-struct i40e_aqc_get_set_rss_key_data {
+struct iavf_aqc_get_set_rss_key_data {
 	u8 standard_rss_key[0x28];
 	u8 extended_hash_key[0xc];
 };
 
-I40E_CHECK_STRUCT_LEN(0x34, i40e_aqc_get_set_rss_key_data);
+IAVF_CHECK_STRUCT_LEN(0x34, iavf_aqc_get_set_rss_key_data);
 
-struct  i40e_aqc_get_set_rss_lut {
-#define I40E_AQC_SET_RSS_LUT_VSI_VALID		BIT(15)
-#define I40E_AQC_SET_RSS_LUT_VSI_ID_SHIFT	0
-#define I40E_AQC_SET_RSS_LUT_VSI_ID_MASK	(0x3FF << \
-					I40E_AQC_SET_RSS_LUT_VSI_ID_SHIFT)
+struct  iavf_aqc_get_set_rss_lut {
+#define IAVF_AQC_SET_RSS_LUT_VSI_VALID		BIT(15)
+#define IAVF_AQC_SET_RSS_LUT_VSI_ID_SHIFT	0
+#define IAVF_AQC_SET_RSS_LUT_VSI_ID_MASK	(0x3FF << \
+					IAVF_AQC_SET_RSS_LUT_VSI_ID_SHIFT)
 	__le16	vsi_id;
-#define I40E_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT	0
-#define I40E_AQC_SET_RSS_LUT_TABLE_TYPE_MASK \
-				BIT(I40E_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT)
+#define IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT	0
+#define IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_MASK \
+				BIT(IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT)
 
-#define I40E_AQC_SET_RSS_LUT_TABLE_TYPE_VSI	0
-#define I40E_AQC_SET_RSS_LUT_TABLE_TYPE_PF	1
+#define IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_VSI	0
+#define IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_PF	1
 	__le16	flags;
 	u8	reserved[4];
 	__le32	addr_high;
 	__le32	addr_low;
 };
 
-I40E_CHECK_CMD_LENGTH(i40e_aqc_get_set_rss_lut);
-#endif /* _I40E_ADMINQ_CMD_H_ */
+IAVF_CHECK_CMD_LENGTH(iavf_aqc_get_set_rss_lut);
+#endif /* _IAVF_ADMINQ_CMD_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 44cd15793bb5..137e06c0c4ee 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -44,55 +44,55 @@ enum iavf_status iavf_set_mac_type(struct iavf_hw *hw)
  * @hw: pointer to the HW structure
  * @aq_err: the AQ error code to convert
  **/
-const char *iavf_aq_str(struct iavf_hw *hw, enum i40e_admin_queue_err aq_err)
+const char *iavf_aq_str(struct iavf_hw *hw, enum iavf_admin_queue_err aq_err)
 {
 	switch (aq_err) {
-	case I40E_AQ_RC_OK:
+	case IAVF_AQ_RC_OK:
 		return "OK";
-	case I40E_AQ_RC_EPERM:
-		return "I40E_AQ_RC_EPERM";
-	case I40E_AQ_RC_ENOENT:
-		return "I40E_AQ_RC_ENOENT";
-	case I40E_AQ_RC_ESRCH:
-		return "I40E_AQ_RC_ESRCH";
-	case I40E_AQ_RC_EINTR:
-		return "I40E_AQ_RC_EINTR";
-	case I40E_AQ_RC_EIO:
-		return "I40E_AQ_RC_EIO";
-	case I40E_AQ_RC_ENXIO:
-		return "I40E_AQ_RC_ENXIO";
-	case I40E_AQ_RC_E2BIG:
-		return "I40E_AQ_RC_E2BIG";
-	case I40E_AQ_RC_EAGAIN:
-		return "I40E_AQ_RC_EAGAIN";
-	case I40E_AQ_RC_ENOMEM:
-		return "I40E_AQ_RC_ENOMEM";
-	case I40E_AQ_RC_EACCES:
-		return "I40E_AQ_RC_EACCES";
-	case I40E_AQ_RC_EFAULT:
-		return "I40E_AQ_RC_EFAULT";
-	case I40E_AQ_RC_EBUSY:
-		return "I40E_AQ_RC_EBUSY";
-	case I40E_AQ_RC_EEXIST:
-		return "I40E_AQ_RC_EEXIST";
-	case I40E_AQ_RC_EINVAL:
-		return "I40E_AQ_RC_EINVAL";
-	case I40E_AQ_RC_ENOTTY:
-		return "I40E_AQ_RC_ENOTTY";
-	case I40E_AQ_RC_ENOSPC:
-		return "I40E_AQ_RC_ENOSPC";
-	case I40E_AQ_RC_ENOSYS:
-		return "I40E_AQ_RC_ENOSYS";
-	case I40E_AQ_RC_ERANGE:
-		return "I40E_AQ_RC_ERANGE";
-	case I40E_AQ_RC_EFLUSHED:
-		return "I40E_AQ_RC_EFLUSHED";
-	case I40E_AQ_RC_BAD_ADDR:
-		return "I40E_AQ_RC_BAD_ADDR";
-	case I40E_AQ_RC_EMODE:
-		return "I40E_AQ_RC_EMODE";
-	case I40E_AQ_RC_EFBIG:
-		return "I40E_AQ_RC_EFBIG";
+	case IAVF_AQ_RC_EPERM:
+		return "IAVF_AQ_RC_EPERM";
+	case IAVF_AQ_RC_ENOENT:
+		return "IAVF_AQ_RC_ENOENT";
+	case IAVF_AQ_RC_ESRCH:
+		return "IAVF_AQ_RC_ESRCH";
+	case IAVF_AQ_RC_EINTR:
+		return "IAVF_AQ_RC_EINTR";
+	case IAVF_AQ_RC_EIO:
+		return "IAVF_AQ_RC_EIO";
+	case IAVF_AQ_RC_ENXIO:
+		return "IAVF_AQ_RC_ENXIO";
+	case IAVF_AQ_RC_E2BIG:
+		return "IAVF_AQ_RC_E2BIG";
+	case IAVF_AQ_RC_EAGAIN:
+		return "IAVF_AQ_RC_EAGAIN";
+	case IAVF_AQ_RC_ENOMEM:
+		return "IAVF_AQ_RC_ENOMEM";
+	case IAVF_AQ_RC_EACCES:
+		return "IAVF_AQ_RC_EACCES";
+	case IAVF_AQ_RC_EFAULT:
+		return "IAVF_AQ_RC_EFAULT";
+	case IAVF_AQ_RC_EBUSY:
+		return "IAVF_AQ_RC_EBUSY";
+	case IAVF_AQ_RC_EEXIST:
+		return "IAVF_AQ_RC_EEXIST";
+	case IAVF_AQ_RC_EINVAL:
+		return "IAVF_AQ_RC_EINVAL";
+	case IAVF_AQ_RC_ENOTTY:
+		return "IAVF_AQ_RC_ENOTTY";
+	case IAVF_AQ_RC_ENOSPC:
+		return "IAVF_AQ_RC_ENOSPC";
+	case IAVF_AQ_RC_ENOSYS:
+		return "IAVF_AQ_RC_ENOSYS";
+	case IAVF_AQ_RC_ERANGE:
+		return "IAVF_AQ_RC_ERANGE";
+	case IAVF_AQ_RC_EFLUSHED:
+		return "IAVF_AQ_RC_EFLUSHED";
+	case IAVF_AQ_RC_BAD_ADDR:
+		return "IAVF_AQ_RC_BAD_ADDR";
+	case IAVF_AQ_RC_EMODE:
+		return "IAVF_AQ_RC_EMODE";
+	case IAVF_AQ_RC_EFBIG:
+		return "IAVF_AQ_RC_EFBIG";
 	}
 
 	snprintf(hw->err_str, sizeof(hw->err_str), "%d", aq_err);
@@ -260,7 +260,7 @@ const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err)
 void iavf_debug_aq(struct iavf_hw *hw, enum iavf_debug_mask mask, void *desc,
 		   void *buffer, u16 buf_len)
 {
-	struct i40e_aq_desc *aq_desc = (struct i40e_aq_desc *)desc;
+	struct iavf_aq_desc *aq_desc = (struct iavf_aq_desc *)desc;
 	u8 *buf = (u8 *)buffer;
 
 	if ((!(mask & hw->debug_mask)) || !desc)
@@ -329,15 +329,15 @@ bool iavf_check_asq_alive(struct iavf_hw *hw)
  **/
 enum iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading)
 {
-	struct i40e_aq_desc desc;
-	struct i40e_aqc_queue_shutdown *cmd =
-		(struct i40e_aqc_queue_shutdown *)&desc.params.raw;
+	struct iavf_aq_desc desc;
+	struct iavf_aqc_queue_shutdown *cmd =
+		(struct iavf_aqc_queue_shutdown *)&desc.params.raw;
 	enum iavf_status status;
 
-	iavf_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_queue_shutdown);
+	iavf_fill_default_direct_cmd_desc(&desc, iavf_aqc_opc_queue_shutdown);
 
 	if (unloading)
-		cmd->driver_unloading = cpu_to_le32(I40E_AQ_DRIVER_UNLOADING);
+		cmd->driver_unloading = cpu_to_le32(IAVF_AQ_DRIVER_UNLOADING);
 	status = iavf_asq_send_command(hw, &desc, NULL, 0, NULL);
 
 	return status;
@@ -360,37 +360,37 @@ static enum iavf_status iavf_aq_get_set_rss_lut(struct iavf_hw *hw,
 						bool set)
 {
 	enum iavf_status status;
-	struct i40e_aq_desc desc;
-	struct i40e_aqc_get_set_rss_lut *cmd_resp =
-		   (struct i40e_aqc_get_set_rss_lut *)&desc.params.raw;
+	struct iavf_aq_desc desc;
+	struct iavf_aqc_get_set_rss_lut *cmd_resp =
+		   (struct iavf_aqc_get_set_rss_lut *)&desc.params.raw;
 
 	if (set)
 		iavf_fill_default_direct_cmd_desc(&desc,
-						  i40e_aqc_opc_set_rss_lut);
+						  iavf_aqc_opc_set_rss_lut);
 	else
 		iavf_fill_default_direct_cmd_desc(&desc,
-						  i40e_aqc_opc_get_rss_lut);
+						  iavf_aqc_opc_get_rss_lut);
 
 	/* Indirect command */
-	desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_BUF);
-	desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_RD);
+	desc.flags |= cpu_to_le16((u16)IAVF_AQ_FLAG_BUF);
+	desc.flags |= cpu_to_le16((u16)IAVF_AQ_FLAG_RD);
 
 	cmd_resp->vsi_id =
 			cpu_to_le16((u16)((vsi_id <<
-					  I40E_AQC_SET_RSS_LUT_VSI_ID_SHIFT) &
-					  I40E_AQC_SET_RSS_LUT_VSI_ID_MASK));
-	cmd_resp->vsi_id |= cpu_to_le16((u16)I40E_AQC_SET_RSS_LUT_VSI_VALID);
+					  IAVF_AQC_SET_RSS_LUT_VSI_ID_SHIFT) &
+					  IAVF_AQC_SET_RSS_LUT_VSI_ID_MASK));
+	cmd_resp->vsi_id |= cpu_to_le16((u16)IAVF_AQC_SET_RSS_LUT_VSI_VALID);
 
 	if (pf_lut)
 		cmd_resp->flags |= cpu_to_le16((u16)
-					((I40E_AQC_SET_RSS_LUT_TABLE_TYPE_PF <<
-					I40E_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT) &
-					I40E_AQC_SET_RSS_LUT_TABLE_TYPE_MASK));
+					((IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_PF <<
+					IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT) &
+					IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_MASK));
 	else
 		cmd_resp->flags |= cpu_to_le16((u16)
-					((I40E_AQC_SET_RSS_LUT_TABLE_TYPE_VSI <<
-					I40E_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT) &
-					I40E_AQC_SET_RSS_LUT_TABLE_TYPE_MASK));
+					((IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_VSI <<
+					IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_SHIFT) &
+					IAVF_AQC_SET_RSS_LUT_TABLE_TYPE_MASK));
 
 	status = iavf_asq_send_command(hw, &desc, lut, lut_size, NULL);
 
@@ -441,31 +441,31 @@ enum iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 vsi_id,
  **/
 static enum
 iavf_status iavf_aq_get_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
-				    struct i40e_aqc_get_set_rss_key_data *key,
+				    struct iavf_aqc_get_set_rss_key_data *key,
 				    bool set)
 {
 	enum iavf_status status;
-	struct i40e_aq_desc desc;
-	struct i40e_aqc_get_set_rss_key *cmd_resp =
-			(struct i40e_aqc_get_set_rss_key *)&desc.params.raw;
-	u16 key_size = sizeof(struct i40e_aqc_get_set_rss_key_data);
+	struct iavf_aq_desc desc;
+	struct iavf_aqc_get_set_rss_key *cmd_resp =
+			(struct iavf_aqc_get_set_rss_key *)&desc.params.raw;
+	u16 key_size = sizeof(struct iavf_aqc_get_set_rss_key_data);
 
 	if (set)
 		iavf_fill_default_direct_cmd_desc(&desc,
-						  i40e_aqc_opc_set_rss_key);
+						  iavf_aqc_opc_set_rss_key);
 	else
 		iavf_fill_default_direct_cmd_desc(&desc,
-						  i40e_aqc_opc_get_rss_key);
+						  iavf_aqc_opc_get_rss_key);
 
 	/* Indirect command */
-	desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_BUF);
-	desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_RD);
+	desc.flags |= cpu_to_le16((u16)IAVF_AQ_FLAG_BUF);
+	desc.flags |= cpu_to_le16((u16)IAVF_AQ_FLAG_RD);
 
 	cmd_resp->vsi_id =
 			cpu_to_le16((u16)((vsi_id <<
-					  I40E_AQC_SET_RSS_KEY_VSI_ID_SHIFT) &
-					  I40E_AQC_SET_RSS_KEY_VSI_ID_MASK));
-	cmd_resp->vsi_id |= cpu_to_le16((u16)I40E_AQC_SET_RSS_KEY_VSI_VALID);
+					  IAVF_AQC_SET_RSS_KEY_VSI_ID_SHIFT) &
+					  IAVF_AQC_SET_RSS_KEY_VSI_ID_MASK));
+	cmd_resp->vsi_id |= cpu_to_le16((u16)IAVF_AQC_SET_RSS_KEY_VSI_VALID);
 
 	status = iavf_asq_send_command(hw, &desc, key, key_size, NULL);
 
@@ -480,7 +480,7 @@ iavf_status iavf_aq_get_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
  *
  **/
 enum iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 vsi_id,
-				     struct i40e_aqc_get_set_rss_key_data *key)
+				     struct iavf_aqc_get_set_rss_key_data *key)
 {
 	return iavf_aq_get_set_rss_key(hw, vsi_id, key, false);
 }
@@ -494,7 +494,7 @@ enum iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 vsi_id,
  * set the RSS key per VSI
  **/
 enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
-				     struct i40e_aqc_get_set_rss_key_data *key)
+				     struct iavf_aqc_get_set_rss_key_data *key)
 {
 	return iavf_aq_get_set_rss_key(hw, vsi_id, key, true);
 }
@@ -881,21 +881,21 @@ enum iavf_status iavf_aq_send_msg_to_pf(struct iavf_hw *hw,
 					enum virtchnl_ops v_opcode,
 					enum iavf_status v_retval,
 					u8 *msg, u16 msglen,
-					struct i40e_asq_cmd_details *cmd_details)
+					struct iavf_asq_cmd_details *cmd_details)
 {
-	struct i40e_asq_cmd_details details;
-	struct i40e_aq_desc desc;
+	struct iavf_asq_cmd_details details;
+	struct iavf_aq_desc desc;
 	enum iavf_status status;
 
-	iavf_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_send_msg_to_pf);
-	desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_SI);
+	iavf_fill_default_direct_cmd_desc(&desc, iavf_aqc_opc_send_msg_to_pf);
+	desc.flags |= cpu_to_le16((u16)IAVF_AQ_FLAG_SI);
 	desc.cookie_high = cpu_to_le32(v_opcode);
 	desc.cookie_low = cpu_to_le32(v_retval);
 	if (msglen) {
-		desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF
-						| I40E_AQ_FLAG_RD));
-		if (msglen > I40E_AQ_LARGE_BUF)
-			desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
+		desc.flags |= cpu_to_le16((u16)(IAVF_AQ_FLAG_BUF
+						| IAVF_AQ_FLAG_RD));
+		if (msglen > IAVF_AQ_LARGE_BUF)
+			desc.flags |= cpu_to_le16((u16)IAVF_AQ_FLAG_LB);
 		desc.datalen = cpu_to_le16(msglen);
 	}
 	if (!cmd_details) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 9f87304109fe..5bdcd78f216d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -280,10 +280,10 @@ static int iavf_get_link_ksettings(struct net_device *netdev,
 	cmd->base.port = PORT_NONE;
 	/* Set speed and duplex */
 	switch (adapter->link_speed) {
-	case I40E_LINK_SPEED_40GB:
+	case IAVF_LINK_SPEED_40GB:
 		cmd->base.speed = SPEED_40000;
 		break;
-	case I40E_LINK_SPEED_25GB:
+	case IAVF_LINK_SPEED_25GB:
 #ifdef SPEED_25000
 		cmd->base.speed = SPEED_25000;
 #else
@@ -291,16 +291,16 @@ static int iavf_get_link_ksettings(struct net_device *netdev,
 			    "Speed is 25G, display not supported by this version of ethtool.\n");
 #endif
 		break;
-	case I40E_LINK_SPEED_20GB:
+	case IAVF_LINK_SPEED_20GB:
 		cmd->base.speed = SPEED_20000;
 		break;
-	case I40E_LINK_SPEED_10GB:
+	case IAVF_LINK_SPEED_10GB:
 		cmd->base.speed = SPEED_10000;
 		break;
-	case I40E_LINK_SPEED_1GB:
+	case IAVF_LINK_SPEED_1GB:
 		cmd->base.speed = SPEED_1000;
 		break;
-	case I40E_LINK_SPEED_100MB:
+	case IAVF_LINK_SPEED_100MB:
 		cmd->base.speed = SPEED_100;
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index ab4e3573f9db..d1f4a3329abb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1229,8 +1229,8 @@ static int iavf_set_interrupt_capability(struct iavf_adapter *adapter)
  **/
 static int iavf_config_rss_aq(struct iavf_adapter *adapter)
 {
-	struct i40e_aqc_get_set_rss_key_data *rss_key =
-		(struct i40e_aqc_get_set_rss_key_data *)adapter->rss_key;
+	struct iavf_aqc_get_set_rss_key_data *rss_key =
+		(struct iavf_aqc_get_set_rss_key_data *)adapter->rss_key;
 	struct iavf_hw *hw = &adapter->hw;
 	int ret = 0;
 
@@ -2022,7 +2022,7 @@ static void iavf_adminq_task(struct work_struct *work)
 	struct iavf_adapter *adapter =
 		container_of(work, struct iavf_adapter, adminq_task);
 	struct iavf_hw *hw = &adapter->hw;
-	struct i40e_arq_event_info event;
+	struct iavf_arq_event_info event;
 	enum virtchnl_ops v_op;
 	enum iavf_status ret, v_ret;
 	u32 val, oldval;
@@ -2241,22 +2241,22 @@ static int iavf_validate_tx_bandwidth(struct iavf_adapter *adapter,
 	int speed = 0, ret = 0;
 
 	switch (adapter->link_speed) {
-	case I40E_LINK_SPEED_40GB:
+	case IAVF_LINK_SPEED_40GB:
 		speed = 40000;
 		break;
-	case I40E_LINK_SPEED_25GB:
+	case IAVF_LINK_SPEED_25GB:
 		speed = 25000;
 		break;
-	case I40E_LINK_SPEED_20GB:
+	case IAVF_LINK_SPEED_20GB:
 		speed = 20000;
 		break;
-	case I40E_LINK_SPEED_10GB:
+	case IAVF_LINK_SPEED_10GB:
 		speed = 10000;
 		break;
-	case I40E_LINK_SPEED_1GB:
+	case IAVF_LINK_SPEED_1GB:
 		speed = 1000;
 		break;
-	case I40E_LINK_SPEED_100MB:
+	case IAVF_LINK_SPEED_100MB:
 		speed = 100;
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_prototype.h b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
index 0dea4419c01f..edebfbbcffdc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_prototype.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
@@ -20,13 +20,13 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw);
 enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw);
 void iavf_adminq_init_ring_data(struct iavf_hw *hw);
 enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
-					struct i40e_arq_event_info *e,
+					struct iavf_arq_event_info *e,
 					u16 *events_pending);
 enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
-				       struct i40e_aq_desc *desc,
+				       struct iavf_aq_desc *desc,
 				       void *buff, /* can be NULL */
 				       u16 buff_size,
-				       struct i40e_asq_cmd_details *cmd_details);
+				       struct iavf_asq_cmd_details *cmd_details);
 bool iavf_asq_done(struct iavf_hw *hw);
 
 /* debug function for adminq */
@@ -37,7 +37,7 @@ void iavf_idle_aq(struct iavf_hw *hw);
 void iavf_resume_aq(struct iavf_hw *hw);
 bool iavf_check_asq_alive(struct iavf_hw *hw);
 enum iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading);
-const char *iavf_aq_str(struct iavf_hw *hw, enum i40e_admin_queue_err aq_err);
+const char *iavf_aq_str(struct iavf_hw *hw, enum iavf_admin_queue_err aq_err);
 const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err);
 
 enum iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 seid,
@@ -45,9 +45,9 @@ enum iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 seid,
 enum iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 seid,
 				     bool pf_lut, u8 *lut, u16 lut_size);
 enum iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 seid,
-				     struct i40e_aqc_get_set_rss_key_data *key);
+				     struct iavf_aqc_get_set_rss_key_data *key);
 enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 seid,
-				     struct i40e_aqc_get_set_rss_key_data *key);
+				     struct iavf_aqc_get_set_rss_key_data *key);
 
 enum iavf_status iavf_set_mac_type(struct iavf_hw *hw);
 
@@ -65,5 +65,5 @@ enum iavf_status iavf_aq_send_msg_to_pf(struct iavf_hw *hw,
 					enum virtchnl_ops v_opcode,
 					enum iavf_status v_retval,
 					u8 *msg, u16 msglen,
-					struct i40e_asq_cmd_details *cmd_details);
+					struct iavf_asq_cmd_details *cmd_details);
 #endif /* _IAVF_PROTOTYPE_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 06d1509d57f7..6d43cbe29c49 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -379,19 +379,19 @@ static inline unsigned int iavf_itr_divisor(struct iavf_q_vector *q_vector)
 	unsigned int divisor;
 
 	switch (q_vector->adapter->link_speed) {
-	case I40E_LINK_SPEED_40GB:
+	case IAVF_LINK_SPEED_40GB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 1024;
 		break;
-	case I40E_LINK_SPEED_25GB:
-	case I40E_LINK_SPEED_20GB:
+	case IAVF_LINK_SPEED_25GB:
+	case IAVF_LINK_SPEED_20GB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 512;
 		break;
 	default:
-	case I40E_LINK_SPEED_10GB:
+	case IAVF_LINK_SPEED_10GB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 256;
 		break;
-	case I40E_LINK_SPEED_1GB:
-	case I40E_LINK_SPEED_100MB:
+	case IAVF_LINK_SPEED_1GB:
+	case IAVF_LINK_SPEED_100MB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 32;
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_type.h b/drivers/net/ethernet/intel/iavf/iavf_type.h
index 58b3efd1ed04..4bc05d2837d7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_type.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_type.h
@@ -21,7 +21,7 @@
 
 /* forward declaration */
 struct iavf_hw;
-typedef void (*I40E_ADMINQ_CALLBACK)(struct iavf_hw *, struct i40e_aq_desc *);
+typedef void (*I40E_ADMINQ_CALLBACK)(struct iavf_hw *, struct iavf_aq_desc *);
 
 /* Data type manipulation macros. */
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 95457869f249..47df277e12d7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -67,7 +67,7 @@ int iavf_verify_api_ver(struct iavf_adapter *adapter)
 {
 	struct virtchnl_version_info *pf_vvi;
 	struct iavf_hw *hw = &adapter->hw;
-	struct i40e_arq_event_info event;
+	struct iavf_arq_event_info event;
 	enum virtchnl_ops op;
 	enum iavf_status err;
 
@@ -189,7 +189,7 @@ static void iavf_validate_num_queues(struct iavf_adapter *adapter)
 int iavf_get_vf_config(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	struct i40e_arq_event_info event;
+	struct iavf_arq_event_info event;
 	enum virtchnl_ops op;
 	enum iavf_status err;
 	u16 len;
@@ -938,22 +938,22 @@ static void iavf_print_link_message(struct iavf_adapter *adapter)
 	}
 
 	switch (adapter->link_speed) {
-	case I40E_LINK_SPEED_40GB:
+	case IAVF_LINK_SPEED_40GB:
 		speed = "40 G";
 		break;
-	case I40E_LINK_SPEED_25GB:
+	case IAVF_LINK_SPEED_25GB:
 		speed = "25 G";
 		break;
-	case I40E_LINK_SPEED_20GB:
+	case IAVF_LINK_SPEED_20GB:
 		speed = "20 G";
 		break;
-	case I40E_LINK_SPEED_10GB:
+	case IAVF_LINK_SPEED_10GB:
 		speed = "10 G";
 		break;
-	case I40E_LINK_SPEED_1GB:
+	case IAVF_LINK_SPEED_1GB:
 		speed = "1000 M";
 		break;
-	case I40E_LINK_SPEED_100MB:
+	case IAVF_LINK_SPEED_100MB:
 		speed = "100 M";
 		break;
 	default:
-- 
2.21.0

