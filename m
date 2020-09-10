Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C2D264975
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgIJQNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgIJQMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:12:43 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECA6C0617A2;
        Thu, 10 Sep 2020 09:12:08 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so9521690ejo.9;
        Thu, 10 Sep 2020 09:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dGO1uiHJWHh14cnKK8pko+2d0wnH48a+yqpz3KnCV+U=;
        b=DxzM4gvN03Ci9Zjjcf7o/OiF0LCrs46/b5AM4CijN1/kNKU2z6ou64w2T5/Tn89uZY
         9awexGkySAoGhuvn9apAbPer8XRnkPIx8rHvPYRRfQiuoQ5xm+gUU5XjJfuhIYrZKrex
         utpoidJOZqE6wCzaKrU5z/p8rv2HQLKgoAZ1VAhLtckvQXsOQWLMxfk35ZM9gyCv3QEF
         yQi32pPHFSIn1qn/vaw/eqUhTdIOr9uIOElK5zOlWW2RF/WBss9OED2EQ5nfD4lF9KCQ
         EPsZLTbGfA12Cw/7I7qrV5a7253HNftDCmEJgRci6qANEmaJHp+4APy3nkJA28LcMu0+
         64cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dGO1uiHJWHh14cnKK8pko+2d0wnH48a+yqpz3KnCV+U=;
        b=Xpoy7KByS3V7z940S8R8stBrdjlXIEk0pw2bSbVVM4h1LKoop3qo+S31hyB8GUSpxO
         S1caIdcRXTX9BPW2Av+shUl8IRTgiDOhtaO4t9tKr50p7Qt8i9c4Bg7+twZv7WPLDJmg
         kzDe8+rVUyqVQe8bt4L8BCz0osGguWKS17PhLz6jkajtj3MScj9ocdqN6AWL0dMVqGT4
         18CGnHKbxQYPJ2Q6axWmxHzKunqmqHlJiNb/udCuZi2oF3bDQCC4RO7NMk+BYOkTBM+1
         3XlH3deW7Wuf7VEkucDnDacJ86PVSEmCjvM0TstaeXUyawBMq5jd/BXeLEw0QqoIjt0I
         8mkQ==
X-Gm-Message-State: AOAM530/uBByGgUFFdZjUGjIZjGvIn2qAhMmqZNUhRbIg8M+JHzXySPA
        rzL6Fc1a9rWPPZ5+a3OQVtVyMAXmpEk=
X-Google-Smtp-Source: ABdhPJwG4Ylo7zyCY7s/PKoKr6Zp3ZOmXfumAwbxPji1U9I8nf6+vk8xCOJ1QhcAB9fJoxcUvtf9Jw==
X-Received: by 2002:a17:906:95cd:: with SMTP id n13mr9260954ejy.297.1599754326230;
        Thu, 10 Sep 2020 09:12:06 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:12:04 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 08/15] habanalabs/gaudi: add a new IOCTL for NIC control operations
Date:   Thu, 10 Sep 2020 19:11:19 +0300
Message-Id: <20200910161126.30948-9-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add Queue Pair (QP) opcodes to the NIC ioctl.

A QP represents a connection between two Gaudi ports. Each port currently
supports 1024 QPs where QP 0 is reserved for the driver for Ethernet.
User-space process needs to create a QP in order to communicate with other
Gaudis.

QP can have two contexts: requester (sender) and responder (receiver). Both
have unique parameters as well as shared ones.

The QP numbers are not recycled immediately but only after wraparound. This
to avoid cases where a QP was closed and reopened and got data of the
"old" QP.

The added opcodes are:

- Create a QP
- Set requester context
- Set responder context
- Destroy a QP

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/common/habanalabs.h   |   3 +
 .../misc/habanalabs/common/habanalabs_ioctl.c |  98 ++++-
 drivers/misc/habanalabs/gaudi/gaudi.c         |   1 +
 drivers/misc/habanalabs/gaudi/gaudiP.h        |   2 +
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 409 ++++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           |   9 +
 include/uapi/misc/habanalabs.h                | 129 +++++-
 7 files changed, 649 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 6bfef3da6e61..5c48d9855e2e 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -679,6 +679,7 @@ struct hl_info_mac_addr;
  *                    then the timeout is the default timeout for the specific
  *                    ASIC
  * @get_hw_state: retrieve the H/W state
+ * @nic_control: Perform NIC related operations.
  * @pci_bars_map: Map PCI BARs.
  * @init_iatu: Initialize the iATU unit inside the PCI controller.
  * @get_mac_addr: Get list of MAC addresses.
@@ -783,6 +784,8 @@ struct hl_asic_funcs {
 	int (*send_cpu_message)(struct hl_device *hdev, u32 *msg,
 				u16 len, u32 timeout, long *result);
 	enum hl_device_hw_state (*get_hw_state)(struct hl_device *hdev);
+	int (*nic_control)(struct hl_device *hdev, u32 op, void *input,
+				void *output);
 	int (*pci_bars_map)(struct hl_device *hdev);
 	int (*init_iatu)(struct hl_device *hdev);
 	int (*get_mac_addr)(struct hl_device *hdev,
diff --git a/drivers/misc/habanalabs/common/habanalabs_ioctl.c b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
index 01425b821828..9924288aabae 100644
--- a/drivers/misc/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
@@ -24,6 +24,20 @@ static u32 hl_debug_struct_size[HL_DEBUG_OP_TIMESTAMP + 1] = {
 
 };
 
+static u32 hl_nic_input_size[HL_NIC_OP_DESTROY_CONN + 1] = {
+	[HL_NIC_OP_ALLOC_CONN] = sizeof(struct hl_nic_alloc_conn_in),
+	[HL_NIC_OP_SET_REQ_CONN_CTX] = sizeof(struct hl_nic_req_conn_ctx_in),
+	[HL_NIC_OP_SET_RES_CONN_CTX] = sizeof(struct hl_nic_res_conn_ctx_in),
+	[HL_NIC_OP_DESTROY_CONN] = sizeof(struct hl_nic_destroy_conn_in),
+};
+
+static u32 hl_nic_output_size[HL_NIC_OP_DESTROY_CONN + 1] = {
+	[HL_NIC_OP_ALLOC_CONN] = sizeof(struct hl_nic_alloc_conn_out),
+	[HL_NIC_OP_SET_REQ_CONN_CTX] = 0,
+	[HL_NIC_OP_SET_RES_CONN_CTX] = 0,
+	[HL_NIC_OP_DESTROY_CONN] = 0,
+};
+
 static int device_status_info(struct hl_device *hdev, struct hl_info_args *args)
 {
 	struct hl_info_device_status dev_stat = {0};
@@ -545,6 +559,87 @@ static int hl_debug_ioctl(struct hl_fpriv *hpriv, void *data)
 	return rc;
 }
 
+static int nic_control(struct hl_device *hdev, struct hl_nic_args *args)
+{
+	void *input = NULL, *output = NULL;
+	int rc;
+
+	if (args->input_ptr && args->input_size) {
+		input = kzalloc(hl_nic_input_size[args->op], GFP_KERNEL);
+		if (!input) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		if (copy_from_user(input, u64_to_user_ptr(args->input_ptr),
+					args->input_size)) {
+			rc = -EFAULT;
+			dev_err(hdev->dev, "failed to copy input NIC data\n");
+			goto out;
+		}
+	}
+
+	if (args->output_ptr && args->output_size) {
+		output = kzalloc(hl_nic_output_size[args->op], GFP_KERNEL);
+		if (!output) {
+			rc = -ENOMEM;
+			goto out;
+		}
+	}
+
+	rc = hdev->asic_funcs->nic_control(hdev, args->op, input, output);
+	if (rc)
+		dev_err_ratelimited(hdev->dev,
+				"NIC control operation %d failed %d\n",
+				args->op, rc);
+
+	if (output && copy_to_user((void __user *) (uintptr_t) args->output_ptr,
+					output, args->output_size)) {
+		dev_err(hdev->dev, "copy to user failed in nic ioctl\n");
+		rc = -EFAULT;
+		goto out;
+	}
+
+out:
+	kfree(output);
+	kfree(input);
+
+	return rc;
+}
+
+static int hl_nic_ioctl(struct hl_fpriv *hpriv, void *data)
+{
+	struct hl_nic_args *args = data;
+	struct hl_device *hdev = hpriv->hdev;
+	int rc;
+
+	if (hl_device_disabled_or_in_reset(hdev)) {
+		dev_warn_ratelimited(hdev->dev,
+			"Device is %s. Can't execute NIC IOCTL\n",
+			atomic_read(&hdev->in_reset) ? "in_reset" : "disabled");
+		return -EBUSY;
+	}
+
+	switch (args->op) {
+	case HL_NIC_OP_ALLOC_CONN:
+	case HL_NIC_OP_SET_REQ_CONN_CTX:
+	case HL_NIC_OP_SET_RES_CONN_CTX:
+	case HL_NIC_OP_DESTROY_CONN:
+		args->input_size =
+			min(args->input_size, hl_nic_input_size[args->op]);
+		args->output_size =
+			min(args->output_size, hl_nic_output_size[args->op]);
+		rc = nic_control(hdev, args);
+		break;
+	default:
+		dev_err(hdev->dev, "Invalid request %d\n", args->op);
+		rc = -ENOTTY;
+		break;
+	}
+
+	return rc;
+}
+
 #define HL_IOCTL_DEF(ioctl, _func) \
 	[_IOC_NR(ioctl)] = {.cmd = ioctl, .func = _func}
 
@@ -554,7 +649,8 @@ static const struct hl_ioctl_desc hl_ioctls[] = {
 	HL_IOCTL_DEF(HL_IOCTL_CS, hl_cs_ioctl),
 	HL_IOCTL_DEF(HL_IOCTL_WAIT_CS, hl_cs_wait_ioctl),
 	HL_IOCTL_DEF(HL_IOCTL_MEMORY, hl_mem_ioctl),
-	HL_IOCTL_DEF(HL_IOCTL_DEBUG, hl_debug_ioctl)
+	HL_IOCTL_DEF(HL_IOCTL_DEBUG, hl_debug_ioctl),
+	HL_IOCTL_DEF(HL_IOCTL_NIC, hl_nic_ioctl)
 };
 
 static const struct hl_ioctl_desc hl_ioctls_control[] = {
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 8ce20e0f8c59..33464bbad157 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -7468,6 +7468,7 @@ static const struct hl_asic_funcs gaudi_funcs = {
 	.get_eeprom_data = gaudi_get_eeprom_data,
 	.send_cpu_message = gaudi_send_cpu_message,
 	.get_hw_state = gaudi_get_hw_state,
+	.nic_control = gaudi_nic_control,
 	.pci_bars_map = gaudi_pci_bars_map,
 	.init_iatu = gaudi_init_iatu,
 	.get_mac_addr = gaudi_nic_get_mac_addr,
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index 17560510a05f..8a89da6b86a1 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -568,6 +568,8 @@ void gaudi_nic_stop(struct hl_device *hdev);
 void gaudi_nic_ports_reopen(struct hl_device *hdev);
 int gaudi_nic_get_mac_addr(struct hl_device *hdev,
 				struct hl_info_mac_addr *mac_addr);
+int gaudi_nic_control(struct hl_device *hdev, u32 op, void *input,
+			void *output);
 void gaudi_nic_ctx_fini(struct hl_ctx *ctx);
 irqreturn_t gaudi_nic_rx_irq_handler(int irq, void *arg);
 irqreturn_t gaudi_nic_cq_irq_handler(int irq, void *arg);
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index 491f426ab0bb..cbe625a9b6f3 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -58,6 +58,9 @@ enum link_status {
 #define MAC_CFG_XPCS91(addr, data)	\
 				mac_write(gaudi_nic, i, "xpcs91", addr, data)
 
+static struct hl_qp dummy_qp;
+static int qp_put(struct hl_qp *qp);
+
 static void qpc_cache_inv(struct gaudi_nic_device *gaudi_nic, bool is_req)
 {
 	struct hl_device *hdev = gaudi_nic->hdev;
@@ -2770,6 +2773,412 @@ int gaudi_nic_get_mac_addr(struct hl_device *hdev,
 out:
 	return 0;
 }
+
+static struct hl_qp *qp_get(struct hl_device *hdev,
+			struct gaudi_nic_device *gaudi_nic, u32 conn_id)
+{
+	struct hl_qp *qp;
+
+	mutex_lock(&gaudi_nic->idr_lock);
+	qp = idr_find(&gaudi_nic->qp_ids, conn_id);
+	if (!qp || qp == &dummy_qp) {
+		dev_err(hdev->dev,
+			"Failed to find matching QP for handle %d in port %d\n",
+			conn_id, gaudi_nic->port);
+		goto out;
+	}
+
+	kref_get(&qp->refcount);
+out:
+	mutex_unlock(&gaudi_nic->idr_lock);
+
+	return qp;
+}
+
+static void qp_do_release(struct hl_qp *qp)
+{
+	mutex_destroy(&qp->qpc_lock);
+	kfree(qp);
+}
+
+static void qp_release(struct kref *ref)
+{
+	struct hl_qp *qp = container_of(ref, struct hl_qp, refcount);
+	struct gaudi_nic_device *gaudi_nic = qp->gaudi_nic;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	void __iomem *base_bar_addr = hdev->pcie_bar[HBM_BAR_ID] -
+					gaudi->hbm_bar_cur_addr;
+	struct qpc_requester req_qpc = {};
+	struct qpc_responder res_qpc = {};
+	u64 req_qpc_addr, res_qpc_addr;
+	int i;
+
+	req_qpc_addr = REQ_QPC_ADDR(qp->port, qp->conn_id);
+	res_qpc_addr = RES_QPC_ADDR(qp->port, qp->conn_id);
+
+	REQ_QPC_SET_VALID(req_qpc, 0);
+	RES_QPC_SET_VALID(res_qpc, 0);
+
+	mutex_lock(&qp->qpc_lock);
+
+	if (qp->is_req)
+		for (i = 0 ; i < (sizeof(req_qpc) / sizeof(u64)) ; i++)
+			writeq(req_qpc.data[i], base_bar_addr +
+					(req_qpc_addr + i * 8));
+
+	if (qp->is_res)
+		for (i = 0 ; i < (sizeof(res_qpc) / sizeof(u64)) ; i++)
+			writeq(res_qpc.data[i], base_bar_addr +
+					(res_qpc_addr + i * 8));
+
+	/* Perform read to flush the writes of the connection context */
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	if (qp->is_req)
+		qpc_cache_inv(gaudi_nic, true);
+	if (qp->is_res)
+		qpc_cache_inv(gaudi_nic, false);
+
+	mutex_unlock(&qp->qpc_lock);
+
+	/*
+	 * No need in removing the QP ID from the IDR. This will be done once
+	 * the IDR gets full. We do this lazy cleanup because we don't want to
+	 * reuse a QP ID immediately after a QP was destroyed.
+	 */
+	qp_do_release(qp);
+}
+
+static int qp_put(struct hl_qp *qp)
+{
+	return kref_put(&qp->refcount, qp_release);
+}
+
+/* "gaudi_nic->idr_lock" should be taken from the caller function if needed */
+static void qps_clean_dummies(struct gaudi_nic_device *gaudi_nic)
+{
+	struct hl_qp *qp;
+	int qp_id;
+
+	idr_for_each_entry(&gaudi_nic->qp_ids, qp, qp_id)
+		if (qp == &dummy_qp)
+			idr_remove(&gaudi_nic->qp_ids, qp_id);
+}
+
+static int conn_ioctl_check(struct hl_device *hdev, u32 port, u32 conn_id)
+{
+	if (port >= NIC_NUMBER_OF_PORTS) {
+		dev_err(hdev->dev, "Invalid port %d\n", port);
+		return -EINVAL;
+	}
+
+	if (!(hdev->nic_ports_mask & BIT(port))) {
+		dev_err(hdev->dev, "Port %d is disabled\n", port);
+		return -ENODEV;
+	}
+
+	if (conn_id < HL_NIC_MIN_CONN_ID || conn_id > HL_NIC_MAX_CONN_ID) {
+		dev_err(hdev->dev, "Invalid connection ID %d for port %d\n",
+			conn_id, port);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int alloc_conn(struct hl_device *hdev, struct hl_nic_alloc_conn_in *in,
+			struct hl_nic_alloc_conn_out *out)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct hl_qp *qp;
+	int id, rc;
+
+	if (!in || !out) {
+		dev_err(hdev->dev,
+			"Missing parameters to allocate a NIC context\n");
+		return -EINVAL;
+	}
+
+	rc = conn_ioctl_check(hdev, in->port, HL_NIC_MIN_CONN_ID);
+	if (rc)
+		return rc;
+
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	if (!qp)
+		return -ENOMEM;
+
+	gaudi_nic = &gaudi->nic_devices[in->port];
+	mutex_init(&qp->qpc_lock);
+	kref_init(&qp->refcount);
+	qp->gaudi_nic = gaudi_nic;
+	qp->port = in->port;
+
+	/* TODO: handle local/remote keys */
+
+	mutex_lock(&gaudi_nic->idr_lock);
+	id = idr_alloc(&gaudi_nic->qp_ids, qp, HL_NIC_MIN_CONN_ID,
+			HL_NIC_MAX_CONN_ID + 1, GFP_KERNEL);
+
+	if (id < 0) {
+		/* Try again after removing the dummy ids */
+		qps_clean_dummies(gaudi_nic);
+		id = idr_alloc(&gaudi_nic->qp_ids, qp, HL_NIC_MIN_CONN_ID,
+				HL_NIC_MAX_CONN_ID + 1, GFP_KERNEL);
+	}
+
+	qp->conn_id = id;
+	mutex_unlock(&gaudi_nic->idr_lock);
+
+	if (id < 0) {
+		qp_do_release(qp);
+		return id;
+	}
+
+	dev_dbg(hdev->dev, "Allocating connection id %d in port %d",
+		id, qp->port);
+
+	out->conn_id = id;
+
+	return 0;
+}
+
+static int set_req_conn_ctx(struct hl_device *hdev,
+				struct hl_nic_req_conn_ctx_in *in)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct qpc_requester req_qpc = {};
+	struct hl_qp *qp;
+	u64 req_qpc_addr;
+	int i, rc;
+
+	if (!in) {
+		dev_err(hdev->dev,
+			"Missing parameters to set a requester context\n");
+		return -EINVAL;
+	}
+
+	if (in->burst_size == 0) {
+		dev_err(hdev->dev,
+			"Burst size can't be disabled in requester context\n");
+		return -EINVAL;
+	}
+
+	rc = conn_ioctl_check(hdev, in->port, in->conn_id);
+	if (rc)
+		return rc;
+
+	gaudi_nic = &gaudi->nic_devices[in->port];
+
+	qp = qp_get(hdev, gaudi_nic, in->conn_id);
+	if (!qp)
+		return -EINVAL;
+
+	req_qpc_addr = REQ_QPC_ADDR(in->port, in->conn_id);
+	REQ_QPC_SET_DST_QP(req_qpc, in->dst_conn_id);
+	REQ_QPC_SET_PORT(req_qpc, 0);
+	REQ_QPC_SET_PRIORITY(req_qpc, in->priority);
+	REQ_QPC_SET_RKEY(req_qpc, qp->remote_key);
+	REQ_QPC_SET_DST_IP(req_qpc, in->dst_ip_addr);
+	REQ_QPC_SET_SRC_IP(req_qpc, in->src_ip_addr);
+	REQ_QPC_SET_DST_MAC_31_0(req_qpc, *(u32 *) in->dst_mac_addr);
+	REQ_QPC_SET_DST_MAC_47_32(req_qpc, *(u16 *) (in->dst_mac_addr + 4));
+	REQ_QPC_SET_SQ_NUM(req_qpc, in->sq_number);
+	REQ_QPC_SET_TM_GRANULARITY(req_qpc, in->timer_granularity);
+	REQ_QPC_SET_SOB_EN(req_qpc, in->enable_sob);
+	REQ_QPC_SET_TRANSPORT_SERVICE(req_qpc, TS_RC);
+	REQ_QPC_SET_BURST_SIZE(req_qpc, in->burst_size);
+	REQ_QPC_SET_LAST_IDX(req_qpc, in->last_index);
+	REQ_QPC_SET_WQ_BASE_ADDR(req_qpc, in->conn_id);
+	REQ_QPC_SET_SWQ_GRANULARITY(req_qpc, in->swq_granularity);
+	REQ_QPC_SET_VALID(req_qpc, 1);
+
+	mutex_lock(&qp->qpc_lock);
+
+	for (i = 0 ; i < (sizeof(req_qpc) / sizeof(u64)) ; i++)
+		writeq(req_qpc.data[i], hdev->pcie_bar[HBM_BAR_ID] +
+			((req_qpc_addr + i * 8) - gaudi->hbm_bar_cur_addr));
+
+	/* Perform read to flush the writes of the connection context */
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	qp->is_req = true;
+	qpc_cache_inv(gaudi_nic, true);
+
+	mutex_unlock(&qp->qpc_lock);
+
+	qp_put(qp);
+
+	return 0;
+}
+
+static int set_res_conn_ctx(struct hl_device *hdev,
+				struct hl_nic_res_conn_ctx_in *in)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct qpc_responder res_qpc = {};
+	struct hl_qp *qp;
+	u64 res_qpc_addr;
+	int i, rc;
+
+	if (!in) {
+		dev_err(hdev->dev,
+			"Missing parameters to set a responder context\n");
+		return -EINVAL;
+	}
+
+	rc = conn_ioctl_check(hdev, in->port, in->conn_id);
+	if (rc)
+		return rc;
+
+	gaudi_nic = &gaudi->nic_devices[in->port];
+
+	qp = qp_get(hdev, gaudi_nic, in->conn_id);
+	if (!qp)
+		return -EINVAL;
+
+	res_qpc_addr = RES_QPC_ADDR(in->port, in->conn_id);
+	RES_QPC_SET_DST_QP(res_qpc, in->dst_conn_id);
+	RES_QPC_SET_PORT(res_qpc, 0);
+	RES_QPC_SET_PRIORITY(res_qpc, in->priority);
+	RES_QPC_SET_SQ_NUM(res_qpc, in->sq_number);
+	RES_QPC_SET_LKEY(res_qpc, qp->local_key);
+	RES_QPC_SET_DST_IP(res_qpc, in->dst_ip_addr);
+	RES_QPC_SET_SRC_IP(res_qpc, in->src_ip_addr);
+	RES_QPC_SET_DST_MAC_31_0(res_qpc, *(u32 *) in->dst_mac_addr);
+	RES_QPC_SET_DST_MAC_47_32(res_qpc, *(u16 *) (in->dst_mac_addr + 4));
+	RES_QPC_SET_TRANSPORT_SERVICE(res_qpc, TS_RC);
+	RES_QPC_SET_LOG_BUF_SIZE_MASK(res_qpc, 0);
+	RES_QPC_SET_SOB_EN(res_qpc, in->enable_sob);
+	RES_QPC_SET_VALID(res_qpc, 1);
+
+	mutex_lock(&qp->qpc_lock);
+
+	for (i = 0 ; i < (sizeof(res_qpc) / sizeof(u64)) ; i++)
+		writeq(res_qpc.data[i], hdev->pcie_bar[HBM_BAR_ID] +
+			((res_qpc_addr + i * 8) - gaudi->hbm_bar_cur_addr));
+
+	/* Perform read to flush the writes of the connection context */
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	qp->is_res = true;
+	qpc_cache_inv(gaudi_nic, false);
+
+	mutex_unlock(&qp->qpc_lock);
+
+	qp_put(qp);
+
+	return 0;
+}
+
+static int destroy_conn(struct hl_device *hdev,
+			struct hl_nic_destroy_conn_in *in)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct hl_qp *qp;
+	int rc;
+
+	if (!in) {
+		dev_err(hdev->dev,
+			"Missing parameters to destroy a NIC context\n");
+		return -EINVAL;
+	}
+
+	rc = conn_ioctl_check(hdev, in->port, in->conn_id);
+	if (rc)
+		return rc;
+
+	gaudi_nic = &gaudi->nic_devices[in->port];
+
+	/* The QP pointer is replaced with the dummy QP to prevent other threads
+	 * from using the QP. The ID is kept allocated at this stage so the QP
+	 * context can be safely modified. qp_put() is called right afterwards.
+	 */
+	mutex_lock(&gaudi_nic->idr_lock);
+	qp = idr_replace(&gaudi_nic->qp_ids, &dummy_qp, in->conn_id);
+	mutex_unlock(&gaudi_nic->idr_lock);
+
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+
+	qp_put(qp);
+
+	return 0;
+}
+
+int gaudi_nic_control(struct hl_device *hdev, u32 op, void *input, void *output)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	int rc;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_NIC_DRV))
+		return -EFAULT;
+
+	switch (op) {
+	case HL_NIC_OP_ALLOC_CONN:
+		rc = alloc_conn(hdev, input, output);
+		break;
+	case HL_NIC_OP_SET_REQ_CONN_CTX:
+		rc = set_req_conn_ctx(hdev, input);
+		break;
+	case HL_NIC_OP_SET_RES_CONN_CTX:
+		rc = set_res_conn_ctx(hdev, input);
+		break;
+	case HL_NIC_OP_DESTROY_CONN:
+		rc = destroy_conn(hdev, input);
+		break;
+	default:
+		dev_err(hdev->dev, "Invalid NIC control request %d\n", op);
+		return -ENOTTY;
+	}
+
+	return rc;
+}
+
+static void qps_destroy(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct hl_qp *qp;
+	int qp_id, i;
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		if (!(hdev->nic_ports_mask & BIT(i)))
+			continue;
+
+		gaudi_nic = &gaudi->nic_devices[i];
+
+		/*
+		 * No need to acquire "gaudi_nic->idr_lock", as qps_destroy() is
+		 * only called when a context is closed, and in Gaudi we have a
+		 * single context.
+		 */
+
+		qps_clean_dummies(gaudi_nic);
+
+		idr_for_each_entry(&gaudi_nic->qp_ids, qp, qp_id) {
+			idr_remove(&gaudi_nic->qp_ids, qp_id);
+			if (qp_put(qp) != 1)
+				dev_err(hdev->dev,
+					"QP %d of port %d is still alive\n",
+					qp->conn_id, qp->port);
+		}
+	}
+}
+
 void gaudi_nic_ctx_fini(struct hl_ctx *ctx)
 {
+	struct hl_device *hdev = ctx->hdev;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_NIC_DRV))
+		return;
+
+	qps_destroy(hdev);
+	/* wait for the NIC to digest the invalid QPs */
+	msleep(20);
 }
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index e49ee24cde50..151f886cd7c4 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5265,6 +5265,14 @@ static enum hl_device_hw_state goya_get_hw_state(struct hl_device *hdev)
 	return RREG32(mmHW_STATE);
 }
 
+static int goya_nic_control(struct hl_device *hdev, u32 op, void *input,
+			void *output)
+{
+	dev_err_ratelimited(hdev->dev,
+				"NIC operations cannot be performed on Goya\n");
+	return -ENXIO;
+}
+
 static int goya_get_mac_addr(struct hl_device *hdev,
 			struct hl_info_mac_addr *mac_addr)
 {
@@ -5390,6 +5398,7 @@ static const struct hl_asic_funcs goya_funcs = {
 	.get_eeprom_data = goya_get_eeprom_data,
 	.send_cpu_message = goya_send_cpu_message,
 	.get_hw_state = goya_get_hw_state,
+	.nic_control = goya_nic_control,
 	.pci_bars_map = goya_pci_bars_map,
 	.init_iatu = goya_init_iatu,
 	.get_mac_addr = goya_get_mac_addr,
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index cd600a52f40a..227bc7c98e08 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -848,6 +848,116 @@ struct hl_debug_args {
 #define HL_NIC_MIN_CONN_ID	1
 #define HL_NIC_MAX_CONN_ID	1023
 
+struct hl_nic_alloc_conn_in {
+	/* NIC port ID */
+	__u32 port;
+	__u32 pad;
+};
+
+struct hl_nic_alloc_conn_out {
+	/* Connection ID */
+	__u32 conn_id;
+	__u32 pad;
+};
+
+struct hl_nic_req_conn_ctx_in {
+	/* Source IP address */
+	__u32 src_ip_addr;
+	/* Destination IP address */
+	__u32 dst_ip_addr;
+	/* Destination connection ID */
+	__u32 dst_conn_id;
+	/* Burst size [1..(2^22)-1 or 0 to disable] */
+	__u32 burst_size;
+	/* Index of last entry [2..(2^22)-1] */
+	__u32 last_index;
+	/* NIC port ID */
+	__u32 port;
+	/* Connection ID */
+	__u32 conn_id;
+	/* Destination MAC address */
+	__u8 dst_mac_addr[ETH_ALEN];
+	/* SQ number */
+	__u8 sq_number;
+	/* Connection priority [0..3] */
+	__u8 priority;
+	/* Enable/disable SOB */
+	__u8 enable_sob;
+	/* Timer granularity [0..127]*/
+	__u8 timer_granularity;
+	/* SWQ granularity [0 for 64B or 1 for 32B] */
+	__u8 swq_granularity;
+	/* Work queue type [1..3] */
+	__u8 wq_type;
+	/* Version type in remote side [0..1] */
+	__u8 version;
+	/* Completion queue number */
+	__u8 cq_number;
+	/* Remote Work queue log size [2^QPC] Rendezvous */
+	__u8 wq_remote_log_size;
+	__u8 pad;
+};
+
+struct hl_nic_res_conn_ctx_in {
+	/* Source IP address */
+	__u32 src_ip_addr;
+	/* Destination IP address */
+	__u32 dst_ip_addr;
+	/* Destination connection ID */
+	__u32 dst_conn_id;
+	/* NIC port ID */
+	__u32 port;
+	/* Connection ID */
+	__u32 conn_id;
+	/* Destination MAC address */
+	__u8 dst_mac_addr[ETH_ALEN];
+	/* Connection priority [0..3] */
+	__u8 priority;
+	/* SQ number */
+	__u8 sq_number;
+	/* Enable/disable SOB */
+	__u8 enable_sob;
+	/* Work queue granularity */
+	__u8 wq_peer_granularity;
+	/* Completion queue number */
+	__u8 cq_number;
+	/* Version type in remote side [0..1] */
+	__u8 version;
+	/* Connection peer */
+	__u32 conn_peer;
+};
+
+struct hl_nic_destroy_conn_in {
+	/* NIC port ID */
+	__u32 port;
+	/* Connection ID */
+	__u32 conn_id;
+};
+
+/* Opcode to allocate connection ID */
+#define HL_NIC_OP_ALLOC_CONN			0
+/* Opcode to set up a requester connection context */
+#define HL_NIC_OP_SET_REQ_CONN_CTX		1
+/* Opcode to set up a responder connection context */
+#define HL_NIC_OP_SET_RES_CONN_CTX		2
+/* Opcode to destroy a connection */
+#define HL_NIC_OP_DESTROY_CONN			3
+
+struct hl_nic_args {
+	/* Pointer to user input structure (relevant to specific opcodes) */
+	__u64 input_ptr;
+	/* Pointer to user output structure (relevant to specific opcodes) */
+	__u64 output_ptr;
+	/* Size of user input structure */
+	__u32 input_size;
+	/* Size of user output structure */
+	__u32 output_size;
+	/* Context ID - Currently not in use */
+	__u32 ctx_id;
+	/* HL_NIC_OP_* */
+	__u32 op;
+};
+
 /*
  * Various information operations such as:
  * - H/W IP information
@@ -1004,7 +1114,24 @@ struct hl_debug_args {
 #define HL_IOCTL_DEBUG		\
 		_IOWR('H', 0x06, struct hl_debug_args)
 
+/*
+ * NIC
+ *
+ * This IOCTL allows the user to manage and configure the device's NIC ports.
+ * The following operations are available:
+ * - Allocate connection ID
+ * - Set up a requester connection context
+ * - Set up a responder connection context
+ * - Destroy a connection
+ *
+ * For all operations, the user should provide a pointer to an input structure
+ * with the context parameters. Some of the operations also require a pointer to
+ * an output structure for result/status.
+ *
+ */
+#define HL_IOCTL_NIC	_IOWR('H', 0x07, struct hl_nic_args)
+
 #define HL_COMMAND_START	0x01
-#define HL_COMMAND_END		0x07
+#define HL_COMMAND_END		0x08
 
 #endif /* HABANALABS_H_ */
-- 
2.17.1

