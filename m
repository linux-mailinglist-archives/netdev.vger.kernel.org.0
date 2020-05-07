Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE051C8B6B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgEGMxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726627AbgEGMx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:53:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F942C05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 05:53:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b6so2008752plz.13
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 05:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dg37dPXwxVA1zqP4MAiCyHp11rv8jOO4t69xsBoKeZk=;
        b=CAMQ+RDTsVu9QOQHwz0iwiqjE2LmE5RoACvrmmOyZPYirvUaE9vyOHbEPd2SHakBL1
         z6w58itg6u+50ITk8EGaNNKSNx8IfXud9tyo1V+NQC0PCu34SAdLeY1f3jCSFCdNzTPa
         LjX+t1wNydfEzdpfesbVExdAILK1uz/U3LIEC5tt6y5T2vg6wKryY0Hre4lua6BET3RD
         NRTad+fmGO/i4qSzmct/pxWXJoFCLhgagVBIiOte9cgAHBjH2T11hBCyz3d5UAl0/wDJ
         K3UCVUsoNgOPds2xjGcxZ0r2UZ48lUQLqwgEJUeVI21BruAV8rQGI1lRf2o3NPVK6CYt
         /OBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dg37dPXwxVA1zqP4MAiCyHp11rv8jOO4t69xsBoKeZk=;
        b=osti6LEm95ZwRy2Kkv5mMrF1o9Zu8L1w1u3/lki1LhQW2QgmfD3gFSusyqj3SE2o3b
         RCoRL/qYJkufKSn0nc6Z9xPU6Ow0CY5Gtbel/9nG3w3jilbB6e/WrRsaQwCeIoLpHr50
         Cj15eptxfelurKgdNB4Ec6F8AQ07F/I2Isbtb0LtQ1w6sz54+Fl60xxfvSyys66G6awW
         TTl4iVNppIDDbLlbMt5QZnSlJ9xnfzs5woH9/a9pEBwB8ANJ0CyF6rX+FHYQG++z5Tz1
         kbPNvUvVzTONhzN61coWGsiPihK3cLVYBkC8PHLhH2GIGIAY/9ohg4ccGVXgyXpJ3chz
         6UEA==
X-Gm-Message-State: AGi0PuZPvlbWlrkpDgJ8Nbs/wVZJ2bALzMKdGALueSUZmIkiTsehWmrU
        yusw8r4v2gsNoAZ5pppJqTjZ
X-Google-Smtp-Source: APiQypLK4Hz2TvmbLEiseouyYNMziY1XV2DJnEfo3pKeXD8olMyB7RxQNcawUu3AKZ59FccD/mE/aQ==
X-Received: by 2002:a17:90a:2347:: with SMTP id f65mr15030520pje.165.1588856007677;
        Thu, 07 May 2020 05:53:27 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6093:7a3f:4ddc:efce:d298:c431])
        by smtp.gmail.com with ESMTPSA id q21sm4926190pfg.131.2020.05.07.05.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 05:53:27 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net
Cc:     kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clew@codeaurora.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 1/2] net: qrtr: Add MHI transport layer
Date:   Thu,  7 May 2020 18:23:05 +0530
Message-Id: <20200507125306.32157-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507125306.32157-1-manivannan.sadhasivam@linaro.org>
References: <20200507125306.32157-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI is the transport layer used for communicating to the external modems.
Hence, this commit adds MHI transport layer support to QRTR for
transferring the QMI messages over IPC Router.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/Kconfig  |   7 +++
 net/qrtr/Makefile |   2 +
 net/qrtr/mhi.c    | 127 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)
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
index 32d4e923925d..1b1411d158a7 100644
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
index 000000000000..ff0c41467fc1
--- /dev/null
+++ b/net/qrtr/mhi.c
@@ -0,0 +1,127 @@
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
+};
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
+	struct sk_buff *skb = mhi_res->buf_addr;
+
+	if (skb->sk)
+		sock_put(skb->sk);
+	consume_skb(skb);
+}
+
+/* Send data over MHI */
+static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
+{
+	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
+	int rc;
+
+	rc = skb_linearize(skb);
+	if (rc)
+		goto free_skb;
+
+	rc = mhi_queue_skb(qdev->mhi_dev, DMA_TO_DEVICE, skb, skb->len,
+			   MHI_EOT);
+	if (rc)
+		goto free_skb;
+
+	if (skb->sk)
+		sock_hold(skb->sk);
+
+	return rc;
+
+free_skb:
+	kfree_skb(skb);
+
+	return rc;
+}
+
+static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
+			       const struct mhi_device_id *id)
+{
+	struct qrtr_mhi_dev *qdev;
+	int rc;
+
+	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
+	if (!qdev)
+		return -ENOMEM;
+
+	qdev->mhi_dev = mhi_dev;
+	qdev->dev = &mhi_dev->dev;
+	qdev->ep.xmit = qcom_mhi_qrtr_send;
+
+	dev_set_drvdata(&mhi_dev->dev, qdev);
+	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
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
+	.id_table = qcom_mhi_qrtr_id_table,
+	.driver = {
+		.name = "qcom_mhi_qrtr",
+	},
+};
+
+module_mhi_driver(qcom_mhi_qrtr_driver);
+
+MODULE_AUTHOR("Chris Lew <clew@codeaurora.org>");
+MODULE_AUTHOR("Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>");
+MODULE_DESCRIPTION("Qualcomm IPC-Router MHI interface driver");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

