Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F8814EDEF
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 14:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgAaNvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 08:51:10 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37493 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbgAaNvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 08:51:09 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so2765290plz.4
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 05:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ukx4iY1w5PIZZr/tp1rLHRN10AfBkKKAjf4yqGYrtY8=;
        b=dAXYVa6EJQBNDIM862mcIFlNMlxPpo5BoK4J5Sfw8kAPjniNo+faC52w4kvzKpEApk
         bZnfSQQNCbIgvSdu1S72ypiGbhHmkLVkwFdUDaslLFAPv1nopZx3xmcqOmylQqH4u9Rz
         YjM0VFsxLMhHhi2jUrj1huVCTOggxCkmGoPhLczE+dSQMfrK7groSF8hWAtymAMVIwQM
         H2O+Cg+DvOdsEjuzk1UYN0PyFt7avjOBHK7RDOBjOu8Xkf3BVLU2FP8OOQqHhrdb8QC0
         xML+DlMJHCQqH0YrXOxPGofCutFHbfbmdaG455i0CtORX2Vz9aZDP90fwvZWjWUpD2S+
         637A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ukx4iY1w5PIZZr/tp1rLHRN10AfBkKKAjf4yqGYrtY8=;
        b=TDMyxJelGLXSC5fMS5EoHGaIcp1QKetQezCW+W0gj3FAjFAGIi6fNeLVskB5O4LSWP
         UGHlc+HLYZIdoRNLkmxtWywjbUEuK4xzRxUlzVsP0JsOUTq5WDP4WU7B3zjbPdKqk0+B
         5yJJR6XHZtRNsQ+dqGZ9oq2f6tQFQ+0M1mz9JgGOUBIJpZJMG1ICNvW7X4e8nhXy2+Dl
         mgKFAZR0FRML6Qm1W8YHm8h+ibvbiPnIhLfRcsQ+QvSgV0wRq0XVkdBMm7QYfNlgED2L
         6VSPgc3oudm3/Kz4N0MdghQ02lnpa6Ntscg8Y48nDopHmim+P7S5tLDvhlRCsbVF7ptx
         WbnA==
X-Gm-Message-State: APjAAAXktZxvLiIrgPJMVstJvmtMu2TE5yP5k+cHXgZS96dloKkyYZcB
        O0AFIXbcFNa9Jh0pNRvpZgRZ
X-Google-Smtp-Source: APXvYqyJKXTTJNCzMvJ7FOKLfbHcQ3ON9V1fZcXxkJY6/ejHzu55dWUzpDCK9gGhoNU6NK4PohaQEw==
X-Received: by 2002:a17:902:7b92:: with SMTP id w18mr10223904pll.72.1580478668364;
        Fri, 31 Jan 2020 05:51:08 -0800 (PST)
Received: from localhost.localdomain ([103.59.133.81])
        by smtp.googlemail.com with ESMTPSA id p3sm10625632pfg.184.2020.01.31.05.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 05:51:07 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org, arnd@arndb.de
Cc:     smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 14/16] net: qrtr: Add MHI transport layer
Date:   Fri, 31 Jan 2020 19:20:07 +0530
Message-Id: <20200131135009.31477-15-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131135009.31477-1-manivannan.sadhasivam@linaro.org>
References: <20200131135009.31477-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI is the transport layer used for communicating to the external modems.
Hence, this commit adds MHI transport layer support to QRTR for
transferring the QMI messages over IPC Router.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/Kconfig  |   7 ++
 net/qrtr/Makefile |   2 +
 net/qrtr/mhi.c    | 207 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 216 insertions(+)
 create mode 100644 net/qrtr/mhi.c

diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
index 63f89cc6e82c..8eb876471564 100644
--- a/net/qrtr/Kconfig
+++ b/net/qrtr/Kconfig
@@ -29,4 +29,11 @@ config QRTR_TUN
 	  implement endpoints of QRTR, for purpose of tunneling data to other
 	  hosts or testing purposes.
 
+config QRTR_MHI
+	tristate "MHI IPC Router channels"
+	depends on MHI_BUS
+	help
+	  Say Y here to support MHI based ipcrouter channels. MHI is the
+	  transport used for communicating to external modems.
+
 endif # QRTR
diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
index 1c6d6c120fb7..3dc0a7c9d455 100644
--- a/net/qrtr/Makefile
+++ b/net/qrtr/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
 qrtr-smd-y	:= smd.o
 obj-$(CONFIG_QRTR_TUN) += qrtr-tun.o
 qrtr-tun-y	:= tun.o
+obj-$(CONFIG_QRTR_MHI) += qrtr-mhi.o
+qrtr-mhi-y	:= mhi.o
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
new file mode 100644
index 000000000000..c85041a22f85
--- /dev/null
+++ b/net/qrtr/mhi.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/mhi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+
+#include "qrtr.h"
+
+struct qrtr_mhi_dev {
+	struct qrtr_endpoint ep;
+	struct mhi_device *mhi_dev;
+	struct device *dev;
+	spinlock_t ul_lock;		/* lock to protect ul_pkts */
+	struct list_head ul_pkts;
+	atomic_t in_reset;
+};
+
+struct qrtr_mhi_pkt {
+	struct list_head node;
+	struct sk_buff *skb;
+	struct kref refcount;
+	struct completion done;
+};
+
+static void qrtr_mhi_pkt_release(struct kref *ref)
+{
+	struct qrtr_mhi_pkt *pkt = container_of(ref, struct qrtr_mhi_pkt,
+						refcount);
+	struct sock *sk = pkt->skb->sk;
+
+	consume_skb(pkt->skb);
+	if (sk)
+		sock_put(sk);
+
+	kfree(pkt);
+}
+
+/* From MHI to QRTR */
+static void qcom_mhi_qrtr_dl_callback(struct mhi_device *mhi_dev,
+				      struct mhi_result *mhi_res)
+{
+	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
+	int rc;
+
+	if (!qdev || mhi_res->transaction_status)
+		return;
+
+	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
+				mhi_res->bytes_xferd);
+	if (rc == -EINVAL)
+		dev_err(qdev->dev, "invalid ipcrouter packet\n");
+}
+
+/* From QRTR to MHI */
+static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
+				      struct mhi_result *mhi_res)
+{
+	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
+	struct qrtr_mhi_pkt *pkt;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qdev->ul_lock, flags);
+	pkt = list_first_entry(&qdev->ul_pkts, struct qrtr_mhi_pkt, node);
+	list_del(&pkt->node);
+	complete_all(&pkt->done);
+
+	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
+	spin_unlock_irqrestore(&qdev->ul_lock, flags);
+}
+
+static void qcom_mhi_qrtr_status_callback(struct mhi_device *mhi_dev,
+					  enum mhi_callback mhi_cb)
+{
+	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
+	struct qrtr_mhi_pkt *pkt;
+	unsigned long flags;
+
+	if (mhi_cb != MHI_CB_FATAL_ERROR)
+		return;
+
+	atomic_inc(&qdev->in_reset);
+	spin_lock_irqsave(&qdev->ul_lock, flags);
+	list_for_each_entry(pkt, &qdev->ul_pkts, node)
+		complete_all(&pkt->done);
+	spin_unlock_irqrestore(&qdev->ul_lock, flags);
+}
+
+/* Send data over MHI */
+static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
+{
+	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
+	struct qrtr_mhi_pkt *pkt;
+	int rc;
+
+	rc = skb_linearize(skb);
+	if (rc) {
+		kfree_skb(skb);
+		return rc;
+	}
+
+	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	init_completion(&pkt->done);
+	kref_init(&pkt->refcount);
+	kref_get(&pkt->refcount);
+	pkt->skb = skb;
+
+	spin_lock_bh(&qdev->ul_lock);
+	list_add_tail(&pkt->node, &qdev->ul_pkts);
+	rc = mhi_queue_transfer(qdev->mhi_dev, DMA_TO_DEVICE, skb, skb->len,
+				MHI_EOT);
+	if (rc) {
+		list_del(&pkt->node);
+		kfree_skb(skb);
+		kfree(pkt);
+		spin_unlock_bh(&qdev->ul_lock);
+		return rc;
+	}
+
+	spin_unlock_bh(&qdev->ul_lock);
+	if (skb->sk)
+		sock_hold(skb->sk);
+
+	rc = wait_for_completion_interruptible_timeout(&pkt->done, HZ * 5);
+	if (atomic_read(&qdev->in_reset))
+		rc = -ECONNRESET;
+	else if (rc == 0)
+		rc = -ETIMEDOUT;
+	else if (rc > 0)
+		rc = 0;
+
+	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
+
+	return rc;
+}
+
+static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
+			       const struct mhi_device_id *id)
+{
+	struct qrtr_mhi_dev *qdev;
+	u32 net_id;
+	int rc;
+
+	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
+	if (!qdev)
+		return -ENOMEM;
+
+	qdev->mhi_dev = mhi_dev;
+	qdev->dev = &mhi_dev->dev;
+	qdev->ep.xmit = qcom_mhi_qrtr_send;
+	atomic_set(&qdev->in_reset, 0);
+
+	net_id = QRTR_EP_NID_AUTO;
+
+	INIT_LIST_HEAD(&qdev->ul_pkts);
+	spin_lock_init(&qdev->ul_lock);
+
+	dev_set_drvdata(&mhi_dev->dev, qdev);
+	rc = qrtr_endpoint_register(&qdev->ep, net_id);
+	if (rc)
+		return rc;
+
+	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
+
+	return 0;
+}
+
+static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
+{
+	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
+
+	qrtr_endpoint_unregister(&qdev->ep);
+	dev_set_drvdata(&mhi_dev->dev, NULL);
+}
+
+static const struct mhi_device_id qcom_mhi_qrtr_id_table[] = {
+	{ .chan = "IPCR" },
+	{}
+};
+MODULE_DEVICE_TABLE(mhi, qcom_mhi_qrtr_id_table);
+
+static struct mhi_driver qcom_mhi_qrtr_driver = {
+	.probe = qcom_mhi_qrtr_probe,
+	.remove = qcom_mhi_qrtr_remove,
+	.dl_xfer_cb = qcom_mhi_qrtr_dl_callback,
+	.ul_xfer_cb = qcom_mhi_qrtr_ul_callback,
+	.status_cb = qcom_mhi_qrtr_status_callback,
+	.id_table = qcom_mhi_qrtr_id_table,
+	.driver = {
+		.name = "qcom_mhi_qrtr",
+	},
+};
+
+module_driver(qcom_mhi_qrtr_driver, mhi_driver_register,
+	      mhi_driver_unregister);
+
+MODULE_DESCRIPTION("Qualcomm IPC-Router MHI interface driver");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

