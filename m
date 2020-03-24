Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330AD190592
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCXGLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 02:11:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41499 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgCXGLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 02:11:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id b1so8498565pgm.8
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 23:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ze2ItdsI6wPt5v1O8KEFX204MaoLii8v3eVvbrQAdcg=;
        b=dsNFxkTXE8D/BQHaXdFb+SWKr0yvc0saXT0cLxFGUJfHrxFer5CneCCXWrdYodwoJZ
         qNOyZGnC3HV/pBPsLXarnAUjxzBdkQeBAei3oktwF32vejHHTG73NCSO062SBt2KIR/O
         24roE0QIokr6KkYstMNlulQiYQV3nqsSCyAwhywSOYjq6XZTKxHv44nwe2TtLn7IZQsT
         +6kAEwVh+ZUtogvvrn62Au6gM7qIVuHE87h9x3MiynuEcseO6Y24qOfMLYXkw5YHHjcr
         +SrttKtV8uGHv7HG+x3CBmribMx2YQvKpbXi2lwey8NEB2C1IJKVVQbuuWNpGKRWu1oG
         jQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ze2ItdsI6wPt5v1O8KEFX204MaoLii8v3eVvbrQAdcg=;
        b=qv5CYEvg/TqqMnn2yi4KWyiXNaEFfxVHZOlB95+cOS2v2AayKhfgZWJylZ1i7BeUJQ
         I1YbAanDiwx9XalTCX6FlwIuPmEOkJjxSdolePLc8Z/9RWMKIWnSWuKt+ucHqJ8FQTNW
         iZlbqOqBAUBysXBOO4XePrhgBJUg+/a57ZJezaFuSkPhkQ7l2eE7CYP7OZ9t2K3kRvCC
         RI08TeZhzhGxq9EdH18jAR+v6nOIX+cr81Zam8gji1elXKU74sE8mPmCJv9eXrm3TTPH
         H49z5CRfMYSBFVQzIoS/CCw+3MfUK0wUKNBhZPvzgrBvZQZc40P3rwL3lesZwB9+sNm5
         WNJQ==
X-Gm-Message-State: ANhLgQ2SapUHsOKh2zZCw0lY8/zbSeEZFqPazb/oFDk/6HL+WSC7+GPu
        73t1xvETVlKU2peTLRHhDaS9
X-Google-Smtp-Source: ADFU+vs3EbahL/k9ZQfYLcHPyNuXXaKepXG1+OjDqsxyu1WMz23vGBXvGVFx4jefmct9P3m8cmOb6Q==
X-Received: by 2002:aa7:83ce:: with SMTP id j14mr14610372pfn.310.1585030294445;
        Mon, 23 Mar 2020 23:11:34 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:59b:91e:2dd6:dffe:3569:b473])
        by smtp.gmail.com with ESMTPSA id d3sm1198230pjc.42.2020.03.23.23.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 23:11:33 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org, davem@davemloft.net
Cc:     smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH v3 6/7] net: qrtr: Add MHI transport layer
Date:   Tue, 24 Mar 2020 11:40:49 +0530
Message-Id: <20200324061050.14845-7-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324061050.14845-1-manivannan.sadhasivam@linaro.org>
References: <20200324061050.14845-1-manivannan.sadhasivam@linaro.org>
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
 net/qrtr/mhi.c    | 208 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+)
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
index 000000000000..90af208f34c1
--- /dev/null
+++ b/net/qrtr/mhi.c
@@ -0,0 +1,208 @@
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
+	rc = mhi_queue_skb(qdev->mhi_dev, DMA_TO_DEVICE, skb, skb->len,
+			   MHI_EOT);
+	if (rc) {
+		list_del(&pkt->node);
+		/* Reference count needs to be dropped 2 times */
+		kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
+		kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
+		kfree_skb(skb);
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
+module_mhi_driver(qcom_mhi_qrtr_driver);
+
+MODULE_DESCRIPTION("Qualcomm IPC-Router MHI interface driver");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

