Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF14312692
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBGSOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:14:34 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2010 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229445AbhBGSOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:14:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117I6xsC031068;
        Sun, 7 Feb 2021 10:13:43 -0800
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrakm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:13:43 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:42 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:41 -0800
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 10:13:38 -0800
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <Erik.Smith@dell.com>,
        <Douglas.Farley@dell.com>, <smalin@marvell.com>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <pkushwaha@marvell.com>, <nassa@marvell.com>,
        <malin1024@gmail.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [RFC PATCH v3 03/11] nvme-tcp-offload: Add device scan implementation
Date:   Sun, 7 Feb 2021 20:13:16 +0200
Message-ID: <20210207181324.11429-4-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210207181324.11429-1-smalin@marvell.com>
References: <20210207181324.11429-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_08:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dean Balandin <dbalandin@marvell.com>

This patch implements the create_ctrl skeleton, specifcially to
demonstrate how the claim_dev op will be used.

The driver scans the registered devices and calls the claim_dev op on
each of them, to find the first devices that matches the connection
params. Once the correct devices is found (claim_dev returns true), we
raise the refcnt of that device and return that device as the device to
be used for ctrl currently being created.

Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/host/tcp-offload.c | 82 +++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index ee3800250e47..49e11638b4fd 100644
--- a/drivers/nvme/host/tcp-offload.c
+++ b/drivers/nvme/host/tcp-offload.c
@@ -13,6 +13,12 @@
 static LIST_HEAD(nvme_tcp_ofld_devices);
 static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
 
+static inline struct nvme_tcp_ofld_ctrl *
+to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
+{
+	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
+}
+
 /**
  * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
  * function.
@@ -96,6 +102,81 @@ nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
 	/* Placeholder - complete request with/without error */
 }
 
+struct nvme_tcp_ofld_dev *
+nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
+{
+	struct nvme_tcp_ofld_dev *dev;
+
+	down_read(&nvme_tcp_ofld_devices_rwsem);
+	list_for_each_entry(dev, &nvme_tcp_ofld_devices, entry) {
+		if (dev->ops->claim_dev(dev, &ctrl->conn_params)) {
+			/* Increase driver refcnt */
+			if (!try_module_get(dev->ops->module)) {
+				pr_err("try_module_get failed\n");
+				dev = NULL;
+			}
+
+			goto out;
+		}
+	}
+
+	dev = NULL;
+out:
+	up_read(&nvme_tcp_ofld_devices_rwsem);
+
+	return dev;
+}
+
+static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
+{
+	/* Placeholder - validates inputs and creates admin and IO queues */
+
+	return 0;
+}
+
+static struct nvme_ctrl *
+nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl;
+	struct nvme_tcp_ofld_dev *dev;
+	struct nvme_ctrl *nctrl;
+	int rc = 0;
+
+	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
+	if (!ctrl)
+		return ERR_PTR(-ENOMEM);
+
+	/* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received opts */
+
+	/* Find device that can reach the dest addr */
+	dev = nvme_tcp_ofld_lookup_dev(ctrl);
+	if (!dev) {
+		pr_info("no device found for addr %s:%s.\n",
+			opts->traddr, opts->trsvcid);
+		rc = -EINVAL;
+		goto out_free_ctrl;
+	}
+
+	ctrl->dev = dev;
+
+	/* Init queues */
+
+	/* Call nvme_init_ctrl */
+
+	rc = nvme_tcp_ofld_setup_ctrl(nctrl, true);
+	if (rc)
+		goto out_module_put;
+
+	return nctrl;
+
+out_module_put:
+	module_put(dev->ops->module);
+out_free_ctrl:
+	kfree(ctrl);
+
+	return ERR_PTR(rc);
+}
+
 static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
 	.name		= "tcp_offload",
 	.module		= THIS_MODULE,
@@ -105,6 +186,7 @@ static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
 			  NVMF_OPT_CTRL_LOSS_TMO | NVMF_OPT_RECONNECT_DELAY |
 			  NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
 			  NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS,
+	.create_ctrl	= nvme_tcp_ofld_create_ctrl,
 };
 
 static int __init nvme_tcp_ofld_init_module(void)
-- 
2.22.0

