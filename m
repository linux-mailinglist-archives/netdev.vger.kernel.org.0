Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29E826AD4E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgIOTQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgIORLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:11:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55178C0611C3;
        Tue, 15 Sep 2020 10:10:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a17so4136726wrn.6;
        Tue, 15 Sep 2020 10:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0QueXKf/IO9uaNw7kMn/jqdcBW4+zWFs0Nowg9+PvFE=;
        b=PsZ7H899F33kvqsynIOt/EoYbXe5l+azExG3JIN4E+k1bOIVgFmbbqnJa2tzE5mDRo
         hz3nEDuFoV5hGFC9cK38q/nEB2h3YxQt/m37bReiQLlftU/HH/70CleHZQGUBoCg78XR
         OUi+n1AJYbMFYPCt2D7xtkE2n1D958D/jQ5zWsjWHHEj/GlNJ4+u7/679CoFCjCZOGEc
         npN5bZ7W2OMcbjwuI/wVdrKWX8YAuGhipFRJYr465HvE6shQq4j/8T9yTHakoVcQunob
         Onwlo/B4i2W/n5spJpXYOBtqKfb3enavUVFWIhx6TSUTKQPvQAXx4TR5Scg96ots12Dx
         OGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0QueXKf/IO9uaNw7kMn/jqdcBW4+zWFs0Nowg9+PvFE=;
        b=JsqA2bdkjVZNTzQQRVaQQrFmBwIVZWcgvwghxhLm4UYGyPfG0uC7T4Jtl7FyNTEl1+
         ELQNrTV5uM8VVP00YEvScUE3WUK6CtZT1fciKmdG6WmoEobKKxq627B0rDR2Oq8nKSKB
         ZNUkA4JU86j0BQ/xABpeg3i3TjmFZ0C/cSoss0xoVZx4Zx8Z6wNrSp7gWfZYQYoOsrgD
         Ph4xkqesOraje/M3+QaeakAYEh5mKZEA6DZT+Lopw67k6UYeiTQ0DHWl+IEyoSYGakjT
         ugYDEuxeYd9K9Qff+lWxtS0J2ZNeOxkqZS6QhTyfwCKdxGrEeZoGzyy2TPz+RA7OvVRl
         ITaw==
X-Gm-Message-State: AOAM530vsZJXkklikopVKm5fonTrgu2DdYzBZq56nRI0yHwM93kWOf6o
        V4oOLZyy+LMczMMIybBEibRtSb0M9siusg==
X-Google-Smtp-Source: ABdhPJwk3G3iKq8VT3qwtEG6z2HfLlwOwgr+wahhZACUPBPnaduOnf9ve9tLAzEO9yrp0mtffjVRdg==
X-Received: by 2002:adf:cd05:: with SMTP id w5mr22168734wrm.62.1600189854262;
        Tue, 15 Sep 2020 10:10:54 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id b194sm356558wmd.42.2020.09.15.10.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 10:10:53 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v3 10/14] habanalabs/gaudi: add WQ control operations
Date:   Tue, 15 Sep 2020 20:10:18 +0300
Message-Id: <20200915171022.10561-11-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add Work Queue (WQ) opcodes to NIC ioctl. A WQ contains entries (WQEs)
where each WQE represents a packet that should be sent or received.

Each WQ has two types: requester (sender) and responder (receiver).

The added opcodes are:
- Set WQ: set the WQ configuration in the HW. The user should provide the
          device virtual address of the WQ.
- Unset WQ: reset the WQ configuration in the HW.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 .../misc/habanalabs/common/habanalabs_ioctl.c |  10 +-
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 184 ++++++++++++++++++
 include/uapi/misc/habanalabs.h                |  33 ++++
 3 files changed, 225 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/common/habanalabs_ioctl.c b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
index 6ba1b9da0486..faf7eeb88b4f 100644
--- a/drivers/misc/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
@@ -24,7 +24,7 @@ static u32 hl_debug_struct_size[HL_DEBUG_OP_TIMESTAMP + 1] = {
 
 };
 
-static u32 hl_nic_input_size[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES + 1] = {
+static u32 hl_nic_input_size[HL_NIC_OP_USER_WQ_UNSET + 1] = {
 	[HL_NIC_OP_ALLOC_CONN] = sizeof(struct hl_nic_alloc_conn_in),
 	[HL_NIC_OP_SET_REQ_CONN_CTX] = sizeof(struct hl_nic_req_conn_ctx_in),
 	[HL_NIC_OP_SET_RES_CONN_CTX] = sizeof(struct hl_nic_res_conn_ctx_in),
@@ -35,9 +35,11 @@ static u32 hl_nic_input_size[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES + 1] = {
 	[HL_NIC_OP_CQ_POLL] = sizeof(struct hl_nic_cq_poll_wait_in),
 	[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES] =
 			sizeof(struct hl_nic_cq_update_consumed_cqes_in),
+	[HL_NIC_OP_USER_WQ_SET] = sizeof(struct hl_nic_user_wq_arr_set_in),
+	[HL_NIC_OP_USER_WQ_UNSET] = sizeof(struct hl_nic_user_wq_arr_unset_in)
 };
 
-static u32 hl_nic_output_size[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES + 1] = {
+static u32 hl_nic_output_size[HL_NIC_OP_USER_WQ_UNSET + 1] = {
 	[HL_NIC_OP_ALLOC_CONN] = sizeof(struct hl_nic_alloc_conn_out),
 	[HL_NIC_OP_SET_REQ_CONN_CTX] = 0,
 	[HL_NIC_OP_SET_RES_CONN_CTX] = 0,
@@ -47,6 +49,8 @@ static u32 hl_nic_output_size[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES + 1] = {
 	[HL_NIC_OP_CQ_WAIT] = sizeof(struct hl_nic_cq_poll_wait_out),
 	[HL_NIC_OP_CQ_POLL] = sizeof(struct hl_nic_cq_poll_wait_out),
 	[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES] = 0,
+	[HL_NIC_OP_USER_WQ_SET] = 0,
+	[HL_NIC_OP_USER_WQ_UNSET] = 0
 };
 
 static int device_status_info(struct hl_device *hdev, struct hl_info_args *args)
@@ -641,6 +645,8 @@ static int hl_nic_ioctl(struct hl_fpriv *hpriv, void *data)
 	case HL_NIC_OP_CQ_WAIT:
 	case HL_NIC_OP_CQ_POLL:
 	case HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES:
+	case HL_NIC_OP_USER_WQ_SET:
+	case HL_NIC_OP_USER_WQ_UNSET:
 		args->input_size =
 			min(args->input_size, hl_nic_input_size[args->op]);
 		args->output_size =
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index 999e9ded22fb..37f25247f751 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -3302,6 +3302,170 @@ int gaudi_nic_get_mac_addr(struct hl_device *hdev,
 	return 0;
 }
 
+static int wq_port_check(struct hl_device *hdev, u32 port)
+{
+	if (port >= NIC_NUMBER_OF_ENGINES) {
+		dev_err(hdev->dev, "Invalid port %d\n", port);
+		return -EINVAL;
+	}
+
+	if (!(hdev->nic_ports_mask & BIT(port))) {
+		dev_err(hdev->dev, "Port %d is disabled\n", port);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int user_wq_arr_set(struct hl_device *hdev,
+				struct hl_nic_user_wq_arr_set_in *in)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	u64 wq_base_addr, num_of_wq_entries_log;
+	struct gaudi_nic_device *gaudi_nic;
+	u32 port, type;
+	int rc;
+
+	if (!in) {
+		dev_err(hdev->dev, "missing parameters, can't set user WQ\n");
+		return -EINVAL;
+	}
+
+	type = in->type;
+	if (type != HL_NIC_USER_WQ_SEND && type != HL_NIC_USER_WQ_RECV) {
+		dev_err(hdev->dev, "invalid type %d, can't set user WQ\n",
+			type);
+		return -EINVAL;
+	}
+
+	port = in->port;
+
+	rc = wq_port_check(hdev, port);
+	if (rc)
+		return rc;
+
+	gaudi_nic = &gaudi->nic_devices[port];
+
+	if (in->num_of_wqs == 0) {
+		dev_err(hdev->dev,
+			"number of WQs must be bigger than zero, port: %d\n",
+			port);
+		return -EINVAL;
+	}
+
+	/* H/W limitation */
+	if (in->num_of_wqs > NIC_HW_MAX_QP_NUM) {
+		dev_err(hdev->dev,
+			"number of WQs (0x%x) can't be bigger than 0x%x, port: %d\n",
+			in->num_of_wqs, NIC_HW_MAX_QP_NUM, port);
+		return -EINVAL;
+	}
+
+	if (!is_power_of_2(in->num_of_wq_entries)) {
+		dev_err(hdev->dev,
+			"number of entries (0x%x) must be a power of 2, port: %d\n",
+			in->num_of_wq_entries, port);
+		return -EINVAL;
+	}
+
+	/* H/W cache line constraint */
+	if (in->num_of_wq_entries < 4) {
+		dev_err(hdev->dev,
+			"number of entries (0x%x) must be at least 4, port: %d\n",
+			in->num_of_wq_entries, port);
+		return -EINVAL;
+	}
+
+	/* H/W limitation */
+	if (in->num_of_wq_entries > USER_WQES_MAX_NUM) {
+		dev_err(hdev->dev,
+			"number of entries (0x%x) can't be bigger than 0x%x, port: %d\n",
+			in->num_of_wq_entries, USER_WQES_MAX_NUM, port);
+		return -EINVAL;
+	}
+
+	if (!IS_ALIGNED(in->addr, DEVICE_CACHE_LINE_SIZE)) {
+		dev_err(hdev->dev,
+			"WQ VA (0x%llx) must be aligned to cache line size (0x%x), port: %d\n",
+			in->addr, DEVICE_CACHE_LINE_SIZE, port);
+		return -EINVAL;
+	}
+
+	wq_base_addr = in->addr;
+	num_of_wq_entries_log = ilog2(in->num_of_wq_entries);
+
+	mutex_lock(&gaudi_nic->user_wq_lock);
+
+	if (type == HL_NIC_USER_WQ_SEND) {
+		NIC_WREG32(mmNIC0_TXE0_SQ_BASE_ADDRESS_49_32_0,
+				(wq_base_addr >> 32) & 0x3FFFFF);
+		NIC_WREG32(mmNIC0_TXE0_SQ_BASE_ADDRESS_31_0_0,
+				wq_base_addr & 0xFFFFFFFF);
+		NIC_WREG32(mmNIC0_TXE0_LOG_MAX_WQ_SIZE_0,
+				num_of_wq_entries_log - 2);
+	} else {
+		NIC_WREG32(mmNIC0_RXE0_WIN0_WQ_BASE_LO,
+				wq_base_addr & 0xFFFFFFFF);
+		NIC_WREG32(mmNIC0_RXE0_WIN0_WQ_BASE_HI,
+			((wq_base_addr >> 32) & 0xFFFFFFFF) |
+			((num_of_wq_entries_log - 4) << 24));
+	}
+
+	mutex_unlock(&gaudi_nic->user_wq_lock);
+
+	return 0;
+}
+
+static void _user_wq_arr_unset(struct hl_device *hdev, u32 port, u32 type)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+
+	gaudi_nic = &gaudi->nic_devices[port];
+
+	mutex_lock(&gaudi_nic->user_wq_lock);
+
+	if (type == HL_NIC_USER_WQ_SEND) {
+		NIC_WREG32(mmNIC0_TXE0_SQ_BASE_ADDRESS_49_32_0, 0);
+		NIC_WREG32(mmNIC0_TXE0_SQ_BASE_ADDRESS_31_0_0, 0);
+		NIC_WREG32(mmNIC0_TXE0_LOG_MAX_WQ_SIZE_0, 0);
+	} else {
+		NIC_WREG32(mmNIC0_RXE0_WIN0_WQ_BASE_LO, 0);
+		NIC_WREG32(mmNIC0_RXE0_WIN0_WQ_BASE_HI, 0);
+	}
+
+	mutex_unlock(&gaudi_nic->user_wq_lock);
+}
+
+static int user_wq_arr_unset(struct hl_device *hdev,
+				struct hl_nic_user_wq_arr_unset_in *in)
+{
+	u32 port, type;
+	int rc;
+
+	if (!in) {
+		dev_err(hdev->dev, "missing parameters, can't unset user WQ\n");
+		return -EINVAL;
+	}
+
+	type = in->type;
+	if (type != HL_NIC_USER_WQ_SEND && type != HL_NIC_USER_WQ_RECV) {
+		dev_err(hdev->dev, "invalid type %d, can't unset user WQ\n",
+			type);
+		return -EINVAL;
+	}
+
+	port = in->port;
+
+	rc = wq_port_check(hdev, port);
+	if (rc)
+		return rc;
+
+	_user_wq_arr_unset(hdev, port, type);
+
+	return 0;
+}
+
 static struct hl_qp *qp_get(struct hl_device *hdev,
 			struct gaudi_nic_device *gaudi_nic, u32 conn_id)
 {
@@ -3670,6 +3834,12 @@ int gaudi_nic_control(struct hl_device *hdev, u32 op, void *input, void *output)
 	case HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES:
 		rc = cq_update_consumed_cqes(hdev, input);
 		break;
+	case HL_NIC_OP_USER_WQ_SET:
+		rc = user_wq_arr_set(hdev, input);
+		break;
+	case HL_NIC_OP_USER_WQ_UNSET:
+		rc = user_wq_arr_unset(hdev, input);
+		break;
 	default:
 		dev_err(hdev->dev, "Invalid NIC control request %d\n", op);
 		return -ENOTTY;
@@ -3709,6 +3879,19 @@ static void qps_destroy(struct hl_device *hdev)
 	}
 }
 
+static void wq_arrs_destroy(struct hl_device *hdev)
+{
+	int i;
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		if (!(hdev->nic_ports_mask & BIT(i)))
+			continue;
+
+		_user_wq_arr_unset(hdev, i, HL_NIC_USER_WQ_SEND);
+		_user_wq_arr_unset(hdev, i, HL_NIC_USER_WQ_RECV);
+	}
+}
+
 void gaudi_nic_ctx_fini(struct hl_ctx *ctx)
 {
 	struct gaudi_device *gaudi = ctx->hdev->asic_specific;
@@ -3721,6 +3904,7 @@ void gaudi_nic_ctx_fini(struct hl_ctx *ctx)
 	/* wait for the NIC to digest the invalid QPs */
 	msleep(20);
 	cq_destroy(hdev);
+	wq_arrs_destroy(hdev);
 }
 
 static void nic_cq_vm_close(struct vm_area_struct *vma)
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index 83a707c207f7..7fa23b06249e 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -1025,6 +1025,31 @@ struct hl_nic_cq_poll_wait_out {
 	__u32 pad;
 };
 
+/* Send user WQ array type */
+#define HL_NIC_USER_WQ_SEND	0
+/* Receive user WQ array type */
+#define HL_NIC_USER_WQ_RECV	1
+
+struct hl_nic_user_wq_arr_set_in {
+	/* WQ array address */
+	__u64 addr;
+	/* NIC port ID */
+	__u32 port;
+	/* Number of user WQs */
+	__u32 num_of_wqs;
+	/* Number of entries per user WQ */
+	__u32 num_of_wq_entries;
+	/* Type of user WQ array */
+	__u32 type;
+};
+
+struct hl_nic_user_wq_arr_unset_in {
+	/* NIC port ID */
+	__u32 port;
+	/* Type of user WQ array */
+	__u32 type;
+};
+
 /* Opcode to allocate connection ID */
 #define HL_NIC_OP_ALLOC_CONN			0
 /* Opcode to set up a requester connection context */
@@ -1043,6 +1068,10 @@ struct hl_nic_cq_poll_wait_out {
 #define HL_NIC_OP_CQ_POLL			7
 /* Opcode to update the number of consumed CQ entries */
 #define HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES	8
+/* Opcode to set a user WQ array */
+#define HL_NIC_OP_USER_WQ_SET			9
+/* Opcode to unset a user WQ array */
+#define HL_NIC_OP_USER_WQ_UNSET			10
 
 struct hl_nic_args {
 	/* Pointer to user input structure (relevant to specific opcodes) */
@@ -1238,6 +1267,8 @@ struct hl_nic_args {
  * - Wait on completion queue
  * - Poll a completion queue
  * - Update consumed completion queue entries
+ * - Set a work queue
+ * - Unset a work queue
  *
  * For all operations, the user should provide a pointer to an input structure
  * with the context parameters. Some of the operations also require a pointer to
@@ -1251,6 +1282,8 @@ struct hl_nic_args {
  * driver regarding how many of the available CQEs were actually
  * processed/consumed. Only then the driver will override them with newer
  * entries.
+ * The set WQ operation should provide the device virtual address of the WQ with
+ * a matching size for the number of WQs and entries per WQ.
  *
  */
 #define HL_IOCTL_NIC	_IOWR('H', 0x07, struct hl_nic_args)
-- 
2.17.1

