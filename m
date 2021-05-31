Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077F03969DF
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhEaW6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:58:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43158 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232412AbhEaW6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:58:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMporH002250;
        Mon, 31 May 2021 15:53:56 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnja4ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:53:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:53:54 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:53:50 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [RFC PATCH v7 04/27] nvme-tcp-offload: Add device scan implementation
Date:   Tue, 1 Jun 2021 01:51:59 +0300
Message-ID: <20210531225222.16992-5-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ASuiGwb6Vh3rXzJ7PfxbWX-P7lIpY--Q
X-Proofpoint-ORIG-GUID: ASuiGwb6Vh3rXzJ7PfxbWX-P7lIpY--Q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dean Balandin <dbalandin@marvell.com>

As part of create_ctrl(), it scans the registered devices and calls
the claim_dev op on each of them, to find the first devices that matches
the connection params. Once the correct devices is found (claim_dev
returns true), we raise the refcnt of that device and return that device
as the device to be used for ctrl currently being created.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/tcp-offload.c | 77 +++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index f7aa49f337dc..5ee3bbca8770 100644
--- a/drivers/nvme/host/tcp-offload.c
+++ b/drivers/nvme/host/tcp-offload.c
@@ -13,6 +13,11 @@
 static LIST_HEAD(nvme_tcp_ofld_devices);
 static DEFINE_MUTEX(nvme_tcp_ofld_devices_mutex);
 
+static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
+{
+	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
+}
+
 /**
  * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
  * function.
@@ -96,6 +101,77 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
 	/* Placeholder - complete request with/without error */
 }
 
+static struct nvme_tcp_ofld_dev *
+nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
+{
+	struct nvme_tcp_ofld_dev *dev;
+
+	mutex_lock(&nvme_tcp_ofld_devices_mutex);
+	list_for_each_entry(dev, &nvme_tcp_ofld_devices, entry) {
+		if (dev->ops->claim_dev(dev, ctrl))
+			goto out;
+	}
+
+	dev = NULL;
+out:
+	mutex_unlock(&nvme_tcp_ofld_devices_mutex);
+
+	return dev;
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
+	nctrl = &ctrl->nctrl;
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
+	/* Increase driver refcnt */
+	if (!try_module_get(dev->ops->module)) {
+		pr_err("try_module_get failed\n");
+		dev = NULL;
+		goto out_free_ctrl;
+	}
+
+	ctrl->dev = dev;
+
+	if (ctrl->dev->ops->max_hw_sectors)
+		nctrl->max_hw_sectors = ctrl->dev->ops->max_hw_sectors;
+	if (ctrl->dev->ops->max_segments)
+		nctrl->max_segments = ctrl->dev->ops->max_segments;
+
+	/* Init queues */
+
+	/* Call nvme_init_ctrl */
+
+	/* Setup ctrl */
+
+	return nctrl;
+
+out_free_ctrl:
+	kfree(ctrl);
+
+	return ERR_PTR(rc);
+}
+
 static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
 	.name		= "tcp_offload",
 	.module		= THIS_MODULE,
@@ -105,6 +181,7 @@ static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
 			  NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
 			  NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
 			  NVMF_OPT_TOS,
+	.create_ctrl	= nvme_tcp_ofld_create_ctrl,
 };
 
 static int __init nvme_tcp_ofld_init_module(void)
-- 
2.22.0

