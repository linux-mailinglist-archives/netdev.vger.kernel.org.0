Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898E9264E2A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgIJSs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIJQMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:12:43 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091E9C0617A4;
        Thu, 10 Sep 2020 09:12:11 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id ay8so6867323edb.8;
        Thu, 10 Sep 2020 09:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iHEiNns9AJJJA/02KK7+6yJWta817KQpnrL8Fa9M7hQ=;
        b=KP4HTV6GHScnKkv04a0hPlXNCr5yGvoNe4ei6r+RVK+wt5jh2eWXJvQkWy159LglyJ
         Dv0aaGi2HKlMjr19XzcQ+S5d0k5s2cnstFwMRjzGrlPA3CC22KqRd1RAywBoxy03FzDD
         E0WsynM6u2m4H3reTlk1TrhHkPZDRpjc4cWc+/su1xoqOZShYOk/BgDf/RmbRw0vgtLe
         aow+mvhFUyqlOpWlQ3kHoG38jTVuXH4yVec0N4+DkY7lTP+dGvCyheL2bSu/PH0TEvms
         832TmSMy7PR5E0rMQ2GnLRXnGpodktuzIJNs6I19gcRqWZIQTD3NZ0FcM164fHpXb3Nl
         ADTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iHEiNns9AJJJA/02KK7+6yJWta817KQpnrL8Fa9M7hQ=;
        b=DdVbOoTWfazgwa6R9dXom+FVCI2lsnb5nah2dfsbxINLXKcn7X3KPjNfvjr0hf360q
         Owj4mGLU+dUw2ujIGp0/Qb+a/+zxWSxcpMyYPyrO3tPKP+SjtjyD5y0stnQGgjTbLsuu
         Re7meWK5dvOxC5TQivr/Sp3nWcHvMFVvVrXAsgPomK1y6rOjvnQ9/8ztm/WO8vHk7H3l
         gTHS1Zx9I5KVFHnbz7/m0fPM/RDkkBqGaXiF3AEky6McGAHm+dX2k1DvdZ4D0PFrQWF0
         MzJsF0d7j5uJNca5jvmaEimUPzV4D7yUZfXdoWB7p/uDbjShHutIm5Q6yecAtJNCElwT
         DGOA==
X-Gm-Message-State: AOAM531aX6ootrzpaCosEIIRzv4JUJR22iloossnQyOJuFGQ2mU6K5W6
        BxLf3T19fOVjTV4WZLTFlRsa+vr+5F0=
X-Google-Smtp-Source: ABdhPJwnrQTW5R4Nr126vAtIANja2/fza5SZen2BTQIDm878p+ynSeBtNmpWRlMccBTsNhoIrLkpfg==
X-Received: by 2002:a50:da84:: with SMTP id q4mr6137780edj.238.1599754328294;
        Thu, 10 Sep 2020 09:12:08 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:12:07 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 09/15] habanalabs/gaudi: add CQ control operations
Date:   Thu, 10 Sep 2020 19:11:20 +0300
Message-Id: <20200910161126.30948-10-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add NIC Completion Queue (CQ) opcodes to NIC ioctl. The CQ is used by the
user-space process to get notification of a completed work.

A CQ entry (CQE) has three types: requester (sender), responder
(receiver) and error. Each type has unique fields as well as shared ones.

Currently only a single user CQ is supported but it may be extended in the
future, hence proper locking was added as well. In addition, an error
interrupt was added to identify CQ overrun.

The added opcodes are:
- Create CQ
- Destroy CQ
- Wait on CQ: sleeps until CQEs are available in the buffer.
- Poll CQ: check if there are available CQEs in the buffer. It is a
           non-blocking function.
- Update consumed CQEs: The user informs the driver regarding processed
                        CQEs so these can be overridden by the driver.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/common/device.c       |   6 +-
 drivers/misc/habanalabs/common/habanalabs.h   |   3 +
 .../misc/habanalabs/common/habanalabs_ioctl.c |  20 +-
 drivers/misc/habanalabs/gaudi/gaudi.c         |   1 +
 drivers/misc/habanalabs/gaudi/gaudiP.h        |   1 +
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 592 ++++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           |   8 +
 include/uapi/misc/habanalabs.h                | 111 ++++
 8 files changed, 739 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index aa7fa9e94651..57f5b945fa41 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -117,12 +117,13 @@ static int hl_device_release_ctrl(struct inode *inode, struct file *filp)
  * @*filp: pointer to file structure
  * @*vma: pointer to vm_area_struct of the process
  *
- * Called when process does an mmap on habanalabs device. Call the device's mmap
+ * Called when process does an mmap on habanalabs device. Call the relevant mmap
  * function at the end of the common code.
  */
 static int hl_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct hl_fpriv *hpriv = filp->private_data;
+	struct hl_device *hdev = hpriv->hdev;
 	unsigned long vm_pgoff;
 
 	vm_pgoff = vma->vm_pgoff;
@@ -131,6 +132,9 @@ static int hl_mmap(struct file *filp, struct vm_area_struct *vma)
 	switch (vm_pgoff & HL_MMAP_TYPE_MASK) {
 	case HL_MMAP_TYPE_CB:
 		return hl_cb_mmap(hpriv, vma);
+
+	case HL_MMAP_TYPE_NIC_CQ:
+		return hdev->asic_funcs->nic_cq_mmap(hdev, vma);
 	}
 
 	return -EINVAL;
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 5c48d9855e2e..1f3735a64d88 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -32,6 +32,7 @@
 #define HL_MMAP_TYPE_SHIFT		(62 - PAGE_SHIFT)
 #define HL_MMAP_TYPE_MASK		(0x3ull << HL_MMAP_TYPE_SHIFT)
 #define HL_MMAP_TYPE_CB			(0x2ull << HL_MMAP_TYPE_SHIFT)
+#define HL_MMAP_TYPE_NIC_CQ		(0x1ull << HL_MMAP_TYPE_SHIFT)
 
 #define HL_MMAP_OFFSET_VALUE_MASK	(0x3FFFFFFFFFFFull >> PAGE_SHIFT)
 #define HL_MMAP_OFFSET_VALUE_GET(off)	(off & HL_MMAP_OFFSET_VALUE_MASK)
@@ -680,6 +681,7 @@ struct hl_info_mac_addr;
  *                    ASIC
  * @get_hw_state: retrieve the H/W state
  * @nic_control: Perform NIC related operations.
+ * @nic_cq_mmap: map the NIC CQ buffer.
  * @pci_bars_map: Map PCI BARs.
  * @init_iatu: Initialize the iATU unit inside the PCI controller.
  * @get_mac_addr: Get list of MAC addresses.
@@ -786,6 +788,7 @@ struct hl_asic_funcs {
 	enum hl_device_hw_state (*get_hw_state)(struct hl_device *hdev);
 	int (*nic_control)(struct hl_device *hdev, u32 op, void *input,
 				void *output);
+	int (*nic_cq_mmap)(struct hl_device *hdev, struct vm_area_struct *vma);
 	int (*pci_bars_map)(struct hl_device *hdev);
 	int (*init_iatu)(struct hl_device *hdev);
 	int (*get_mac_addr)(struct hl_device *hdev,
diff --git a/drivers/misc/habanalabs/common/habanalabs_ioctl.c b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
index 9924288aabae..6947ef519872 100644
--- a/drivers/misc/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
@@ -24,18 +24,29 @@ static u32 hl_debug_struct_size[HL_DEBUG_OP_TIMESTAMP + 1] = {
 
 };
 
-static u32 hl_nic_input_size[HL_NIC_OP_DESTROY_CONN + 1] = {
+static u32 hl_nic_input_size[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES + 1] = {
 	[HL_NIC_OP_ALLOC_CONN] = sizeof(struct hl_nic_alloc_conn_in),
 	[HL_NIC_OP_SET_REQ_CONN_CTX] = sizeof(struct hl_nic_req_conn_ctx_in),
 	[HL_NIC_OP_SET_RES_CONN_CTX] = sizeof(struct hl_nic_res_conn_ctx_in),
 	[HL_NIC_OP_DESTROY_CONN] = sizeof(struct hl_nic_destroy_conn_in),
+	[HL_NIC_OP_CQ_CREATE] = sizeof(struct hl_nic_cq_create_in),
+	[HL_NIC_OP_CQ_DESTROY] = sizeof(struct hl_nic_cq_destroy_in),
+	[HL_NIC_OP_CQ_WAIT] = sizeof(struct hl_nic_cq_poll_wait_in),
+	[HL_NIC_OP_CQ_POLL] = sizeof(struct hl_nic_cq_poll_wait_in),
+	[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES] =
+			sizeof(struct hl_nic_cq_update_consumed_cqes_in),
 };
 
-static u32 hl_nic_output_size[HL_NIC_OP_DESTROY_CONN + 1] = {
+static u32 hl_nic_output_size[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES + 1] = {
 	[HL_NIC_OP_ALLOC_CONN] = sizeof(struct hl_nic_alloc_conn_out),
 	[HL_NIC_OP_SET_REQ_CONN_CTX] = 0,
 	[HL_NIC_OP_SET_RES_CONN_CTX] = 0,
 	[HL_NIC_OP_DESTROY_CONN] = 0,
+	[HL_NIC_OP_CQ_CREATE] = sizeof(struct hl_nic_cq_create_out),
+	[HL_NIC_OP_CQ_DESTROY] = 0,
+	[HL_NIC_OP_CQ_WAIT] = sizeof(struct hl_nic_cq_poll_wait_out),
+	[HL_NIC_OP_CQ_POLL] = sizeof(struct hl_nic_cq_poll_wait_out),
+	[HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES] = 0,
 };
 
 static int device_status_info(struct hl_device *hdev, struct hl_info_args *args)
@@ -625,6 +636,11 @@ static int hl_nic_ioctl(struct hl_fpriv *hpriv, void *data)
 	case HL_NIC_OP_SET_REQ_CONN_CTX:
 	case HL_NIC_OP_SET_RES_CONN_CTX:
 	case HL_NIC_OP_DESTROY_CONN:
+	case HL_NIC_OP_CQ_CREATE:
+	case HL_NIC_OP_CQ_DESTROY:
+	case HL_NIC_OP_CQ_WAIT:
+	case HL_NIC_OP_CQ_POLL:
+	case HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES:
 		args->input_size =
 			min(args->input_size, hl_nic_input_size[args->op]);
 		args->output_size =
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 33464bbad157..34b99bd94ef0 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -7469,6 +7469,7 @@ static const struct hl_asic_funcs gaudi_funcs = {
 	.send_cpu_message = gaudi_send_cpu_message,
 	.get_hw_state = gaudi_get_hw_state,
 	.nic_control = gaudi_nic_control,
+	.nic_cq_mmap = gaudi_nic_cq_mmap,
 	.pci_bars_map = gaudi_pci_bars_map,
 	.init_iatu = gaudi_init_iatu,
 	.get_mac_addr = gaudi_nic_get_mac_addr,
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index 8a89da6b86a1..ba3150c073ca 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -571,6 +571,7 @@ int gaudi_nic_get_mac_addr(struct hl_device *hdev,
 int gaudi_nic_control(struct hl_device *hdev, u32 op, void *input,
 			void *output);
 void gaudi_nic_ctx_fini(struct hl_ctx *ctx);
+int gaudi_nic_cq_mmap(struct hl_device *hdev, struct vm_area_struct *vma);
 irqreturn_t gaudi_nic_rx_irq_handler(int irq, void *arg);
 irqreturn_t gaudi_nic_cq_irq_handler(int irq, void *arg);
 netdev_tx_t gaudi_nic_handle_tx_pkt(struct gaudi_nic_device *gaudi_nic,
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index cbe625a9b6f3..0583b34a728f 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -1729,6 +1729,466 @@ void gaudi_nic_sw_fini(struct hl_device *hdev)
 		_gaudi_nic_sw_fini(&gaudi->nic_devices[i]);
 }
 
+/* this function is called from multiple threads */
+static void copy_cqe_to_main_queue(struct hl_device *hdev,
+					struct hl_nic_cqe *cqe)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	u32 pi;
+
+	spin_lock(&gaudi->nic_cq_lock);
+
+	pi = gaudi->nic_cq_user_pi++;
+	/* wraparound according to the user CQ length */
+	pi &= (gaudi->nic_cq_user_num_of_entries - 1);
+	memcpy(&gaudi->nic_cq_buf[pi], cqe, sizeof(*cqe));
+
+#if HL_NIC_DEBUG
+	if (cqe->type == HL_NIC_CQE_TYPE_RES) {
+		dev_dbg(hdev->dev,
+			"responder, msg_id: 0x%x, port: %d, was copied to pi %d\n",
+			cqe->responder.msg_id, cqe->port, pi);
+	} else {
+		dev_dbg(hdev->dev,
+			"requester, wqe_index: 0x%x, qp_number: %d, port: %d, was copied to pi %d\n",
+			cqe->requester.wqe_index,
+			cqe->qp_number, cqe->port, pi);
+	}
+#endif
+
+	/* copy the CQE before the counter update */
+	mb();
+
+	if (unlikely(!atomic_add_unless(&gaudi->nic_cq_user_new_cqes, 1,
+				gaudi->nic_cq_user_num_of_entries))) {
+		gaudi->nic_cq_status = HL_NIC_CQ_OVERFLOW;
+		dev_err(hdev->dev, "NIC CQ overflow, should recreate NIC CQ\n");
+	}
+
+	spin_unlock(&gaudi->nic_cq_lock);
+}
+
+static void cq_work(struct work_struct *work)
+{
+	struct gaudi_nic_device *gaudi_nic = container_of(work,
+							struct gaudi_nic_device,
+							cq_work.work);
+	struct hl_device *hdev = gaudi_nic->hdev;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct cqe *cq_arr = gaudi_nic->cq_mem_cpu, *cqe_hw;
+	struct hl_nic_cqe cqe_sw;
+	u32 ci = gaudi_nic->cq_ci, cqe_cnt = 0, port = gaudi_nic->port, delay;
+	bool stop_work = false;
+
+	while (1) {
+		if (unlikely(!gaudi->nic_cq_enable) ||
+			unlikely(gaudi->nic_cq_status != HL_NIC_CQ_SUCCESS)) {
+			stop_work = true;
+			break;
+		}
+
+		memset(&cqe_sw, 0, sizeof(cqe_sw));
+
+		/* wraparound according to our buffer length */
+		cqe_hw = &cq_arr[ci & (CQ_PORT_BUF_LEN - 1)];
+
+		if (!CQE_IS_VALID(cqe_hw))
+			break;
+		/* Make sure we read CQE contents after the valid bit check */
+		dma_rmb();
+
+		cqe_sw.port = port;
+
+		if (CQE_TYPE(cqe_hw)) {
+			cqe_sw.type = HL_NIC_CQE_TYPE_RES;
+			cqe_sw.responder.msg_id =
+					(CQE_RES_IMDT_31_22(cqe_hw) << 22) |
+						CQE_RES_IMDT_21_0(cqe_hw);
+
+			/*
+			 * the even port publishes its responder CQEs on the odd
+			 * port CQ. take the correct port in this case.
+			 */
+			if (!CQE_RES_NIC(cqe_hw))
+				cqe_sw.port--;
+		} else {
+			cqe_sw.requester.wqe_index = CQE_REQ_WQE_IDX(cqe_hw);
+			cqe_sw.qp_number = CQE_REQ_QPN(cqe_hw);
+		}
+
+		copy_cqe_to_main_queue(hdev, &cqe_sw);
+
+		CQE_SET_INVALID(cqe_hw);
+
+		/* the H/W CI does wraparound every 32 bit */
+		ci++;
+
+		cqe_cnt++;
+		if (unlikely(cqe_cnt > CQ_PORT_BUF_LEN)) {
+			dev_err(hdev->dev,
+				"handled too many CQEs (%d), port: %d\n",
+				cqe_cnt, port);
+			stop_work = true;
+			break;
+		}
+	}
+
+	/* no CQEs to handle */
+	if (cqe_cnt == 0)
+		goto out;
+
+#if HL_NIC_DEBUG
+	dev_dbg(hdev->dev, "update H/W CQ CI: %d, port: %d\n", ci, port);
+#endif
+
+	NIC_WREG32(mmNIC0_RXE0_CQ_CONSUMER_INDEX, ci);
+
+	/*
+	 * perform a read to flush the new CI value before checking for hidden
+	 * packets
+	 */
+	NIC_RREG32(mmNIC0_RXE0_CQ_CONSUMER_INDEX);
+
+	gaudi_nic->cq_ci = ci;
+
+	/* make sure we wake up the waiter after the CI update */
+	mb();
+
+	/* signal the completion queue that there are available CQEs */
+	complete(&gaudi->nic_cq_comp);
+
+	if (unlikely(stop_work))
+		goto out;
+
+out:
+	if (likely(cqe_cnt)) {
+		gaudi_nic->last_cqe_cnt = cqe_cnt;
+		delay = gaudi_nic->cq_delay;
+	} else {
+		ktime_t later;
+
+		/*
+		 * take base TS on the first polling invocation where no CQEs
+		 * were processed
+		 */
+		if (gaudi_nic->last_cqe_cnt) {
+			gaudi_nic->last_cqe_cnt = 0;
+			gaudi_nic->last_cqe_ts = ktime_get();
+		}
+
+		/* extend the delay if no CQEs were processed for 1 sec */
+		later = ktime_add_ms(gaudi_nic->last_cqe_ts, 1 * MSEC_PER_SEC);
+		if (ktime_compare(ktime_get(), later) > 0)
+			delay = gaudi_nic->cq_delay_idle;
+		else
+			delay = gaudi_nic->cq_delay;
+	}
+
+	queue_delayed_work(gaudi_nic->cq_wq, &gaudi_nic->cq_work, delay);
+}
+
+static int cq_update_consumed_cqes(struct hl_device *hdev,
+				struct hl_nic_cq_update_consumed_cqes_in *in)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	u32 num_of_cqes;
+	int rc = 0;
+
+	if (!in) {
+		dev_err(hdev->dev,
+			"Missing parameters to update consumed CQEs\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&gaudi->nic_cq_user_lock);
+
+	if (!gaudi->nic_cq_enable) {
+		dev_err(hdev->dev,
+			"NIC CQ is not enabled, can't update user CI\n");
+		rc = -EFAULT;
+		goto out;
+	}
+
+	num_of_cqes = in->cq_num_of_consumed_entries;
+
+	if (atomic_read(&gaudi->nic_cq_user_new_cqes) < num_of_cqes) {
+		dev_err(hdev->dev,
+			"nunmber of consumed CQEs is too big %d/%d\n",
+			num_of_cqes, atomic_read(&gaudi->nic_cq_user_new_cqes));
+		rc = -EINVAL;
+		goto out;
+	}
+
+	gaudi->nic_cq_user_ci = (gaudi->nic_cq_user_ci + num_of_cqes) &
+				(gaudi->nic_cq_user_num_of_entries - 1);
+
+	atomic_sub(num_of_cqes, &gaudi->nic_cq_user_new_cqes);
+
+#if HL_NIC_DEBUG
+	dev_dbg(hdev->dev, "consumed %d CQEs\n", num_of_cqes);
+	dev_dbg(hdev->dev, "user CQ CI: %d\n", gaudi->nic_cq_user_ci);
+#endif
+out:
+	mutex_unlock(&gaudi->nic_cq_user_lock);
+
+	return rc;
+}
+
+static int cq_poll_wait(struct hl_device *hdev,
+			struct hl_nic_cq_poll_wait_in *in,
+			struct hl_nic_cq_poll_wait_out *out,
+			bool do_wait)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	char *op_str = do_wait ? "wait" : "poll";
+	u32 num_of_cqes;
+	bool has_work = false;
+	long rc_wait;
+	int rc = 0;
+
+	if (!in || !out) {
+		dev_err(hdev->dev, "Missing parameters to poll/wait on CQ\n");
+		return -EINVAL;
+	}
+
+	/* allow only one thread to wait */
+	mutex_lock(&gaudi->nic_cq_user_lock);
+
+	if (!gaudi->nic_cq_enable) {
+		dev_err(hdev->dev, "NIC CQ is not enabled, can't %s\n", op_str);
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (gaudi->nic_cq_status != HL_NIC_CQ_SUCCESS) {
+		dev_err(hdev->dev, "NIC CQ is not operational, can't %s\n",
+			op_str);
+		rc = -EFAULT;
+		goto out;
+	}
+
+#if HL_NIC_DEBUG
+	dev_dbg(hdev->dev, "ci: %d, wait: %d\n",
+		gaudi->nic_cq_user_ci, do_wait);
+#endif
+
+	if (do_wait) {
+		while (1) {
+			rc_wait = wait_for_completion_interruptible_timeout(
+					&gaudi->nic_cq_comp,
+					usecs_to_jiffies(in->timeout_us));
+
+			if (rc_wait == -ERESTARTSYS) {
+				dev_info(hdev->dev,
+						"stopping CQ %s due to signal\n",
+						op_str);
+				/* ERESTARTSYS is not returned to the user */
+				rc = -EINTR;
+				break;
+			}
+
+			if (!rc_wait) {
+				gaudi->nic_cq_status = HL_NIC_CQ_TIMEOUT;
+				break;
+			}
+
+			if (!gaudi->nic_cq_enable) {
+				dev_info(hdev->dev,
+						"stopping CQ %s upon request\n",
+						op_str);
+				rc = -EBUSY;
+				break;
+			}
+
+			if (gaudi->nic_cq_status != HL_NIC_CQ_SUCCESS)
+				break;
+
+			/*
+			 * A waiter can read 0 here.
+			 * Consider the following scenario:
+			 * 1. complete() is called twice for two CQEs.
+			 * 2. The first waiter grabs the two CQEs.
+			 * 3. The second waiter wakes up immediately and has no
+			 *    CQES to handle.
+			 */
+			num_of_cqes = atomic_read(&gaudi->nic_cq_user_new_cqes);
+			if (num_of_cqes) {
+				has_work = true;
+				break;
+			}
+		}
+	} else {
+		has_work = try_wait_for_completion(&gaudi->nic_cq_comp);
+		if (has_work)
+			num_of_cqes = atomic_read(&gaudi->nic_cq_user_new_cqes);
+	}
+
+	if (rc)
+		goto out;
+
+	if (has_work) {
+		out->pi = gaudi->nic_cq_user_ci;
+		out->num_of_cqes = num_of_cqes;
+#if HL_NIC_DEBUG
+		dev_dbg(hdev->dev, "pulled %d CQEs\n", num_of_cqes);
+		dev_dbg(hdev->dev, "user CQ CI: %d\n", gaudi->nic_cq_user_ci);
+#endif
+	} else {
+		out->num_of_cqes = 0;
+	}
+
+	out->status = gaudi->nic_cq_status;
+
+	/* timeout is not a real error, CQ should stay operational */
+	if (gaudi->nic_cq_status == HL_NIC_CQ_TIMEOUT)
+		gaudi->nic_cq_status = HL_NIC_CQ_SUCCESS;
+out:
+	mutex_unlock(&gaudi->nic_cq_user_lock);
+
+	return rc;
+}
+
+static int cq_create(struct hl_device *hdev, struct hl_nic_cq_create_in *in,
+			struct hl_nic_cq_create_out *out)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct cqe *cq_arr;
+	int rc = 0, i, j;
+
+	if (!in || !out) {
+		dev_err(hdev->dev, "Missing parameters to create CQ\n");
+		return -EINVAL;
+	}
+
+	if (in->cq_num_of_entries < CQ_USER_MIN_ENTRIES) {
+		dev_err(hdev->dev, "NIC CQ buffer length must be at least %d entries\n",
+			CQ_USER_MIN_ENTRIES);
+		return -EINVAL;
+	}
+
+	if (!is_power_of_2(in->cq_num_of_entries)) {
+		dev_err(hdev->dev,
+			"NIC CQ buffer length must be at power of 2\n");
+		return -EINVAL;
+	}
+
+	if (in->cq_num_of_entries > CQ_USER_MAX_ENTRIES) {
+		dev_err(hdev->dev,
+			"NIC CQ buffer length must not be more than 0x%lx entries\n",
+			CQ_USER_MAX_ENTRIES);
+		return -EINVAL;
+	}
+
+	mutex_lock(&gaudi->nic_cq_user_lock);
+
+	if (gaudi->nic_cq_enable) {
+		dev_err(hdev->dev, "NIC CQ was already created\n");
+		rc = -EFAULT;
+		goto out;
+	}
+
+	gaudi->nic_cq_user_num_of_entries = in->cq_num_of_entries;
+	gaudi->nic_cq_buf = vmalloc_user(gaudi->nic_cq_user_num_of_entries *
+					sizeof(struct hl_nic_cqe));
+	if (!gaudi->nic_cq_buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	init_completion(&gaudi->nic_cq_comp);
+	memset(gaudi->nic_cq_buf, 0,
+		gaudi->nic_cq_user_num_of_entries * sizeof(struct hl_nic_cqe));
+
+	spin_lock_init(&gaudi->nic_cq_lock);
+	gaudi->nic_cq_user_ci = 0;
+	gaudi->nic_cq_user_pi = 0;
+	atomic_set(&gaudi->nic_cq_user_new_cqes, 0);
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		if (!(hdev->nic_ports_mask & BIT(i)) ||
+			!gaudi->nic_devices[i].port_open)
+			continue;
+
+		gaudi_nic = &gaudi->nic_devices[i];
+		gaudi_nic->cq_ci = gaudi_nic->last_cqe_cnt = 0;
+
+		NIC_WREG32(mmNIC0_RXE0_CQ_PRODUCER_INDEX, 0);
+		NIC_WREG32(mmNIC0_RXE0_CQ_CONSUMER_INDEX, 0);
+		NIC_WREG32(mmNIC0_RXE0_CQ_WRITE_INDEX, 0);
+
+		cq_arr = gaudi_nic->cq_mem_cpu;
+		for (j = 0 ; j < CQ_PORT_BUF_LEN ; j++)
+			CQE_SET_INVALID(&cq_arr[j]);
+
+	}
+
+	out->handle = HL_MMAP_TYPE_NIC_CQ << PAGE_SHIFT;
+	gaudi->nic_cq_status = HL_NIC_CQ_SUCCESS;
+	gaudi->nic_cq_enable = true;
+out:
+	mutex_unlock(&gaudi->nic_cq_user_lock);
+
+	return rc;
+}
+
+static void cq_stop(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+
+	if (!gaudi->nic_cq_enable)
+		return;
+
+	/* if the CQ wait IOCTL is in progress, wake it up to return to US */
+	gaudi->nic_cq_enable = false;
+	/* make sure we disable the CQ before waking up the waiter */
+	mb();
+	complete(&gaudi->nic_cq_comp);
+
+	/* let the CQ wait IOCTL do cleanup gracefully */
+	msleep(100);
+}
+
+static int cq_destroy(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	int rc = 0;
+
+	mutex_lock(&gaudi->nic_cq_user_lock);
+
+	if (!gaudi->nic_cq_enable)
+		goto out;
+
+	if (gaudi->nic_cq_mmap) {
+		dev_err(hdev->dev, "NIC CQ is still mapped, can't destroy\n");
+		rc = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * mark the CQ as disabled while holding the NIC QP error lock to avoid
+	 * from pushing QP error entries to a CQ under destruction
+	 */
+	mutex_lock(&gaudi->nic_qp_err_lock);
+	gaudi->nic_cq_enable = false;
+	mutex_unlock(&gaudi->nic_qp_err_lock);
+
+	/* make sure we disable the CQ before draining the polling threads */
+	mb();
+
+	/*
+	 * Wait for the polling threads to digest the new CQ state. This in
+	 * order to free the user buffer after they stopped processing CQEs and
+	 * copy them to the buffer.
+	 */
+	msleep(100);
+
+	vfree(gaudi->nic_cq_buf);
+out:
+	mutex_unlock(&gaudi->nic_cq_user_lock);
+
+	return rc;
+}
 
 /* used for physically contiguous memory only */
 static int map_nic_mem(struct hl_device *hdev, u64 va, dma_addr_t pa, u32 size)
@@ -1928,6 +2388,8 @@ static int port_open(struct gaudi_nic_device *gaudi_nic)
 		goto cq_unmap;
 	}
 
+	INIT_DELAYED_WORK(&gaudi_nic->cq_work, cq_work);
+
 	if ((hdev->pdev) && (gaudi->multi_msi_mode)) {
 		rx_irq = pci_irq_vector(hdev->pdev, RX_MSI_IDX + port);
 
@@ -1970,6 +2432,9 @@ static int port_open(struct gaudi_nic_device *gaudi_nic)
 		napi_enable(&gaudi_nic->napi);
 	}
 
+	queue_delayed_work(gaudi_nic->cq_wq, &gaudi_nic->cq_work,
+				gaudi_nic->cq_delay_idle);
+
 	if (gaudi->nic_phy_config_fw && !gaudi_nic->mac_loopback) {
 		INIT_DELAYED_WORK(&gaudi_nic->link_status_work,
 					check_link_status);
@@ -2070,6 +2535,8 @@ static void port_close(struct gaudi_nic_device *gaudi_nic)
 
 	netif_carrier_off(gaudi_nic->ndev);
 
+	cancel_delayed_work_sync(&gaudi_nic->cq_work);
+
 	flush_workqueue(gaudi_nic->cq_wq);
 	destroy_workqueue(gaudi_nic->cq_wq);
 
@@ -2330,6 +2797,31 @@ static void port_unregister(struct gaudi_nic_device *gaudi_nic)
 
 irqreturn_t gaudi_nic_cq_irq_handler(int irq, void *arg)
 {
+	struct hl_device *hdev = arg;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	int i;
+
+	/* one IRQ for all ports, need to iterate and read the cause */
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		if (!(hdev->nic_ports_mask & BIT(i)))
+			continue;
+
+		gaudi_nic = &gaudi->nic_devices[i];
+
+		if (disabled_or_in_reset(gaudi_nic))
+			continue;
+
+		if (NIC_RREG32(mmNIC0_RXE0_MSI_CAUSE) & 2) {
+			dev_crit(hdev->dev, "NIC CQ overrun, port %d\n",
+					gaudi_nic->port);
+			NIC_WREG32(mmNIC0_RXE0_MSI_CAUSE, 0);
+			NIC_WREG32(mmNIC0_RXE0_CQ_MSI_CAUSE_CLR, 0xFFFF);
+			/* flush the cause clear */
+			NIC_RREG32(mmNIC0_RXE0_CQ_MSI_CAUSE_CLR);
+		}
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -2609,6 +3101,8 @@ int gaudi_nic_hard_reset_prepare(struct hl_device *hdev)
 			(gaudi->nic_in_reset))
 		return 0;
 
+	cq_stop(hdev);
+
 	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
 		if (!(hdev->nic_ports_mask & BIT(i)))
 			continue;
@@ -3131,6 +3625,21 @@ int gaudi_nic_control(struct hl_device *hdev, u32 op, void *input, void *output)
 	case HL_NIC_OP_DESTROY_CONN:
 		rc = destroy_conn(hdev, input);
 		break;
+	case HL_NIC_OP_CQ_CREATE:
+		rc = cq_create(hdev, input, output);
+		break;
+	case HL_NIC_OP_CQ_DESTROY:
+		rc = cq_destroy(hdev);
+		break;
+	case HL_NIC_OP_CQ_WAIT:
+		rc = cq_poll_wait(hdev, input, output, true);
+		break;
+	case HL_NIC_OP_CQ_POLL:
+		rc = cq_poll_wait(hdev, input, output, false);
+		break;
+	case HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES:
+		rc = cq_update_consumed_cqes(hdev, input);
+		break;
 	default:
 		dev_err(hdev->dev, "Invalid NIC control request %d\n", op);
 		return -ENOTTY;
@@ -3181,4 +3690,87 @@ void gaudi_nic_ctx_fini(struct hl_ctx *ctx)
 	qps_destroy(hdev);
 	/* wait for the NIC to digest the invalid QPs */
 	msleep(20);
+	cq_destroy(hdev);
+}
+
+static void nic_cq_vm_close(struct vm_area_struct *vma)
+{
+	struct hl_device *hdev = (struct hl_device *) vma->vm_private_data;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	long new_mmap_size;
+
+	new_mmap_size = gaudi->nic_cq_mmap_size - (vma->vm_end - vma->vm_start);
+
+	dev_dbg(hdev->dev, "munmap NIC CQEs buffer, new_mmap_size: %ld\n",
+		new_mmap_size);
+
+	if (new_mmap_size > 0) {
+		gaudi->nic_cq_mmap_size = new_mmap_size;
+		return;
+	}
+
+	vma->vm_private_data = NULL;
+	gaudi->nic_cq_mmap = false;
+}
+
+static const struct vm_operations_struct nic_cq_vm_ops = {
+	.close = nic_cq_vm_close
+};
+
+int gaudi_nic_cq_mmap(struct hl_device *hdev, struct vm_area_struct *vma)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	u32 size;
+	int rc;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_NIC_DRV))
+		return -EFAULT;
+
+	mutex_lock(&gaudi->nic_cq_user_lock);
+
+	if (!gaudi->nic_cq_enable) {
+		dev_err(hdev->dev, "NIC CQ is disabled, can't mmap\n");
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (gaudi->nic_cq_mmap) {
+		dev_err(hdev->dev, "NIC CQ is already mmapped, can't mmap\n");
+		rc = -EFAULT;
+		goto out;
+	}
+
+	size = gaudi->nic_cq_user_num_of_entries * sizeof(struct hl_nic_cqe);
+
+	dev_dbg(hdev->dev, "mmap NIC CQ buffer, size: 0x%x\n", size);
+
+	/* Validation check */
+	if ((vma->vm_end - vma->vm_start) != ALIGN(size, PAGE_SIZE)) {
+		dev_err(hdev->dev,
+			"NIC mmap failed, mmap size 0x%lx != 0x%x CQ buffer size\n",
+			vma->vm_end - vma->vm_start, size);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	vma->vm_ops = &nic_cq_vm_ops;
+	vma->vm_private_data = hdev;
+
+	dev_dbg(hdev->dev, "mapping NIC CQ buffer\n");
+
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP | VM_DONTCOPY |
+			VM_NORESERVE;
+
+	rc = remap_vmalloc_range(vma, gaudi->nic_cq_buf, 0);
+	if (rc) {
+		dev_err(hdev->dev, "failed to map the NIC CQ buffer\n");
+		goto out;
+	}
+
+	gaudi->nic_cq_mmap_size = size;
+	gaudi->nic_cq_mmap = true;
+out:
+	mutex_unlock(&gaudi->nic_cq_user_lock);
+
+	return rc;
 }
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 151f886cd7c4..6e98c830f6a2 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5273,6 +5273,13 @@ static int goya_nic_control(struct hl_device *hdev, u32 op, void *input,
 	return -ENXIO;
 }
 
+static int goya_nic_mmap(struct hl_device *hdev, struct vm_area_struct *vma)
+{
+	dev_err_ratelimited(hdev->dev,
+			"NIC mmap operations cannot be performed on Goya\n");
+	return -ENXIO;
+}
+
 static int goya_get_mac_addr(struct hl_device *hdev,
 			struct hl_info_mac_addr *mac_addr)
 {
@@ -5399,6 +5406,7 @@ static const struct hl_asic_funcs goya_funcs = {
 	.send_cpu_message = goya_send_cpu_message,
 	.get_hw_state = goya_get_hw_state,
 	.nic_control = goya_nic_control,
+	.nic_cq_mmap = goya_nic_mmap,
 	.pci_bars_map = goya_pci_bars_map,
 	.init_iatu = goya_init_iatu,
 	.get_mac_addr = goya_get_mac_addr,
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index 227bc7c98e08..840f31a18209 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -848,6 +848,46 @@ struct hl_debug_args {
 #define HL_NIC_MIN_CONN_ID	1
 #define HL_NIC_MAX_CONN_ID	1023
 
+/* Requester */
+#define HL_NIC_CQE_TYPE_REQ	0
+/* Responder */
+#define HL_NIC_CQE_TYPE_RES	1
+
+/**
+ * struct hl_nic_cqe: NIC CQ entry. This structure is shared between the driver
+ *                    and the user application. It represents each entry of the
+ *                    NIC CQ buffer.
+ * @requester.wqe_index: work queue index - for requester only.
+ * @responder.msg_id: message ID to notify which receive action was completed -
+ *                    for responder only.
+ * @qp_err.syndrome: error syndrome of the QP error - for QP error only.
+ * @port: NIC port index of the related CQ.
+ * @qp_number: QP number - for requester or QP error only.
+ * @type: type of the CQE - requester or responder.
+ * @is_err: true for QP error entry, false otherwise.
+ */
+struct hl_nic_cqe {
+	union {
+		struct {
+			__u32 wqe_index;
+		} requester;
+
+		struct {
+			__u32 msg_id;
+		} responder;
+
+		struct {
+			__u32 syndrome;
+		} qp_err;
+	};
+
+	__u32 port;
+	__u32 qp_number;
+	__u8 type;
+	__u8 is_err;
+	__u8 pad[2];
+};
+
 struct hl_nic_alloc_conn_in {
 	/* NIC port ID */
 	__u32 port;
@@ -934,6 +974,53 @@ struct hl_nic_destroy_conn_in {
 	__u32 conn_id;
 };
 
+struct hl_nic_cq_create_in {
+	/* Number of entries in the CQ buffer */
+	__u32 cq_num_of_entries;
+	__u32 pad;
+};
+
+struct hl_nic_cq_create_out {
+	/* Handle of the CQ buffer */
+	__u64 handle;
+};
+
+struct hl_nic_cq_destroy_in {
+	/* Handle of the CQ buffer */
+	__u64 handle;
+};
+
+struct hl_nic_cq_update_consumed_cqes_in {
+	/* Handle of the CQ buffer */
+	__u64 handle;
+	/* Number of consumed CQEs */
+	__u32 cq_num_of_consumed_entries;
+	__u32 pad;
+};
+
+struct hl_nic_cq_poll_wait_in {
+	/* Handle of the CQ buffer */
+	__u64 handle;
+	/* Absolute timeout to wait in microseconds */
+	__u64 timeout_us;
+};
+
+enum hl_nic_cq_status {
+	HL_NIC_CQ_SUCCESS,
+	HL_NIC_CQ_TIMEOUT,
+	HL_NIC_CQ_OVERFLOW
+};
+
+struct hl_nic_cq_poll_wait_out {
+	/* CQE producer index - first CQE to consume */
+	__u32 pi;
+	/* Number of CQEs to consume, starting from pi */
+	__u32 num_of_cqes;
+	/* Return status */
+	__u32 status;
+	__u32 pad;
+};
+
 /* Opcode to allocate connection ID */
 #define HL_NIC_OP_ALLOC_CONN			0
 /* Opcode to set up a requester connection context */
@@ -942,6 +1029,16 @@ struct hl_nic_destroy_conn_in {
 #define HL_NIC_OP_SET_RES_CONN_CTX		2
 /* Opcode to destroy a connection */
 #define HL_NIC_OP_DESTROY_CONN			3
+/* Opcode to create a CQ */
+#define HL_NIC_OP_CQ_CREATE			4
+/* Opcode to destroy a CQ */
+#define HL_NIC_OP_CQ_DESTROY			5
+/* Opcode to wait on CQ */
+#define HL_NIC_OP_CQ_WAIT			6
+/* Opcode to poll on CQ */
+#define HL_NIC_OP_CQ_POLL			7
+/* Opcode to update the number of consumed CQ entries */
+#define HL_NIC_OP_CQ_UPDATE_CONSUMED_CQES	8
 
 struct hl_nic_args {
 	/* Pointer to user input structure (relevant to specific opcodes) */
@@ -1123,10 +1220,24 @@ struct hl_nic_args {
  * - Set up a requester connection context
  * - Set up a responder connection context
  * - Destroy a connection
+ * - Create a completion queue
+ * - Destroy a completion queue
+ * - Wait on completion queue
+ * - Poll a completion queue
+ * - Update consumed completion queue entries
  *
  * For all operations, the user should provide a pointer to an input structure
  * with the context parameters. Some of the operations also require a pointer to
  * an output structure for result/status.
+ * The CQ create operation returns a handle which the user-space process needs
+ * to use to mmap the CQ buffer in order to access the CQ entries.
+ * This handle should be provided when destroying the CQ.
+ * The poll/wait CQ operations return the number of available CQ entries of type
+ * struct hl_nic_cqe.
+ * Since the CQ is a cyclic buffer, the user-space process needs to inform the
+ * driver regarding how many of the available CQEs were actually
+ * processed/consumed. Only then the driver will override them with newer
+ * entries.
  *
  */
 #define HL_IOCTL_NIC	_IOWR('H', 0x07, struct hl_nic_args)
-- 
2.17.1

