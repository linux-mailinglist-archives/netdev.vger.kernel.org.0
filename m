Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB105264E24
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIJSti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgIJQMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:12:43 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B637C0617A5;
        Thu, 10 Sep 2020 09:12:13 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr14so9582472ejb.1;
        Thu, 10 Sep 2020 09:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FmRNviOqVjipr1RSFbFj9F4fck0imv/S9yq0q4MvYNw=;
        b=nhdODC0lwutumCJQaz5Q0Sj8BoPpgkuidxMaVrmrAHtlAGyw1ooXAjYcP1YRnR5noG
         FRIHaQ5gpC1/TUnvTba/d4lElUdAUdvGpgdfPeFXSu1Ovx5oq/i8EltKDDZay9sjQpg0
         LQqN7/1jLU/kheQ/t1Pk/QLlRQJiKo0lv7Zqf8y2anTfcckGtZ5sXHdK18iIMAn1Ytpj
         byeUzizwhk8G2le8Kxgiox9uNi7Xg/Hs5epdoxlMQAkQt87RI1bVU1Q8Za46jLungfwG
         bFSK4wD3PNMvKkMuLsSgmjw2zEcRoPP8l8rFfbLZJ0ysHRWOlI2pzLvjkAqMdP7EO65t
         YruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FmRNviOqVjipr1RSFbFj9F4fck0imv/S9yq0q4MvYNw=;
        b=KLK8R0Fy1prFS2disvqaShmmiF91pphlDZ8kU4K0L9XzM2+WcQUyNY3jxOplG7JiRP
         CfE6rClrxk0rzRYf7GjGXQficjbOddQuBtFm+mYBu4T9NuXSDi3YX+YPhjk37pHpSmyf
         PCFLf+ypKRo23EJrHp57YFOudwVJFcqkDCTK7biG2XRCTkGgrGZg7oXAV032NljdA3b/
         oqZ0YJy4oEX8eLnq0GpCuQSsnem8xMaHVRv8D6s7nK8nHFzJ3u0tlxJ4YXtsgX2BKFku
         7vakMqF9vhKly+KoOXTqPTSFTELHT0wVGf1X92IQ0Vsm6qtbDZq9JcGJibwsF7IcEazn
         RW8Q==
X-Gm-Message-State: AOAM530hQDQ/gvPev2lURvfP6ypj8dSUgGo2NPPPxv36/332HeKeHV+Y
        ybPyyHO7N4OF2VRuet64mkD79nOu8pw=
X-Google-Smtp-Source: ABdhPJxLl5jOQEPA9v/mWViM544T331uIjHx8Qc41Drk24es1pbVh/Dsfu6WOCB6ATh28v6FyDasNQ==
X-Received: by 2002:a17:906:454a:: with SMTP id s10mr9451404ejq.138.1599754331211;
        Thu, 10 Sep 2020 09:12:11 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:12:10 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 10/15] habanalabs/gaudi: add WQ control operations
Date:   Thu, 10 Sep 2020 19:11:21 +0300
Message-Id: <20200910161126.30948-11-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
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
index 6947ef519872..ad6dab5344f9 100644
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
index 0583b34a728f..8f6585c700cf 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -3268,6 +3268,170 @@ int gaudi_nic_get_mac_addr(struct hl_device *hdev,
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
+	struct gaudi_nic_device *gaudi_nic;
+	u64 wq_base_addr, num_of_wq_entries_log;
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
@@ -3640,6 +3804,12 @@ int gaudi_nic_control(struct hl_device *hdev, u32 op, void *input, void *output)
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
@@ -3679,6 +3849,19 @@ static void qps_destroy(struct hl_device *hdev)
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
 	struct hl_device *hdev = ctx->hdev;
@@ -3691,6 +3874,7 @@ void gaudi_nic_ctx_fini(struct hl_ctx *ctx)
 	/* wait for the NIC to digest the invalid QPs */
 	msleep(20);
 	cq_destroy(hdev);
+	wq_arrs_destroy(hdev);
 }
 
 static void nic_cq_vm_close(struct vm_area_struct *vma)
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index 840f31a18209..5678fda2fddc 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -1021,6 +1021,31 @@ struct hl_nic_cq_poll_wait_out {
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
@@ -1039,6 +1064,10 @@ struct hl_nic_cq_poll_wait_out {
 #define HL_NIC_OP_CQ_POLL			7
 /* Opcode to update the number of consumed CQ entries */
 #define HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES	8
+/* Opcode to set a user WQ array */
+#define HL_NIC_OP_USER_WQ_SET			9
+/* Opcode to unset a user WQ array */
+#define HL_NIC_OP_USER_WQ_UNSET			10
 
 struct hl_nic_args {
 	/* Pointer to user input structure (relevant to specific opcodes) */
@@ -1225,6 +1254,8 @@ struct hl_nic_args {
  * - Wait on completion queue
  * - Poll a completion queue
  * - Update consumed completion queue entries
+ * - Set a work queue
+ * - Unset a work queue
  *
  * For all operations, the user should provide a pointer to an input structure
  * with the context parameters. Some of the operations also require a pointer to
@@ -1238,6 +1269,8 @@ struct hl_nic_args {
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

