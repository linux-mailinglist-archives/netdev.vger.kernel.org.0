Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDD2165AE7
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgBTKA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:00:26 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54218 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgBTKAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:00:22 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so670080pjc.3
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 02:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JcAoPiKM9Q2Ld6e3l3XnfEAo/r6es8deaGEWWBZP3xY=;
        b=JsLXXU41fFM9v/N7RLJXlYod7HcMesRcTdG0JRKAqHbMFQDgmEI2tNcIhyZrrKuH7W
         vgrEOSoo3pH3xYs18q+naP7kIPUs862rqgV1Y6gv2l8xN5TsysEotuGDKO22MapZBY1h
         m8XMPmgUx7T33EJaJS82M/oIuE9qGBko71HatfK5AzyaRHlEUm2ZXvR0JUoKVflq6zOm
         BnWe0lFP/R0xCzkW+SOEFIQ7T1S8GEJyQZ6WF8nooc7uRJRqoOHL63l3pQY71j7d+YxJ
         +pHZGO+18xhQ7Twlwa2Ub0kf+TkXzvQJCHgllYp7jAfpEcfpSogOn+GBe/4XM+pZjoQ+
         11UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JcAoPiKM9Q2Ld6e3l3XnfEAo/r6es8deaGEWWBZP3xY=;
        b=Apd5K6JEnJuezj86uBRi9j5mBSufiDWHtqboYHWHeDzJ55x3Wow4FtT/ID1581yIKx
         AAFKOxcnDrdqN9KlFkheD/yPMc+TqqTw+cfKFPRoq3OZg9XLIErqs3I1DVrT8733TlZX
         sv+Ir7nqr5eeHyKCuVgt/PvKxEN9axbBxuJtTJwac9JJraUiY80HoLYccatJ5cco+kUL
         T6Vf0qlX4/9Lc+NuOhiY/DgM19bgNtmRUCvASkM2VgCju+QvN3/2p9+gCrCioRp1GY8I
         6yOWcR2CjAj44wFk1sLC/nGcRqS2hWhZ0GkU7Du3fNHAf2n4qoYiDeUtb7QlqFcC00Az
         68Eg==
X-Gm-Message-State: APjAAAWSQTgivXs9gwaFYeBaVjQoqHqgcgPCeJ+T1DQnnMW2uqj6AvMi
        sjrEzA+foKXG0Mz8H3nP7INiD8GWz2mX
X-Google-Smtp-Source: APXvYqy2yQs1kbqiXi5gXHHAmrsH8FXJwf/eSy8xQ7wl6sen4Nax7ZtnuuSBrgd9HLQRq8hRJT1cxg==
X-Received: by 2002:a17:90a:cc02:: with SMTP id b2mr2520142pju.137.1582192820686;
        Thu, 20 Feb 2020 02:00:20 -0800 (PST)
Received: from localhost.localdomain ([2409:4072:315:9501:edda:4222:88ae:442f])
        by smtp.gmail.com with ESMTPSA id b3sm2678644pjo.30.2020.02.20.02.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 02:00:20 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org, arnd@arndb.de
Cc:     smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v3 14/16] net: qrtr: Add MHI transport layer
Date:   Thu, 20 Feb 2020 15:28:52 +0530
Message-Id: <20200220095854.4804-15-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200220095854.4804-1-manivannan.sadhasivam@linaro.org>
References: <20200220095854.4804-1-manivannan.sadhasivam@linaro.org>
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
 net/qrtr/mhi.c    | 209 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+)
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
index 000000000000..fcfba3673d59
--- /dev/null
+++ b/net/qrtr/mhi.c
@@ -0,0 +1,209 @@
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
+module_driver(qcom_mhi_qrtr_driver, mhi_driver_register,
+	      mhi_driver_unregister);
+
+MODULE_DESCRIPTION("Qualcomm IPC-Router MHI interface driver");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

