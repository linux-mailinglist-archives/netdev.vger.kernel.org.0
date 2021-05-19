Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C2F388C74
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346237AbhESLQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:16:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32682 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238817AbhESLQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:16:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JB9dlc020130;
        Wed, 19 May 2021 04:14:37 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38mqc1hyqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:14:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 May
 2021 04:14:36 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 May 2021 04:14:32 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        "Arie Gershberg" <agershberg@marvell.com>
Subject: [RFC PATCH v5 02/27] nvme-fabrics: Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
Date:   Wed, 19 May 2021 14:13:15 +0300
Message-ID: <20210519111340.20613-3-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210519111340.20613-1-smalin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: S1ZRUWidp2tuYcyCoYN1v0pxDOdTNsk5
X-Proofpoint-ORIG-GUID: S1ZRUWidp2tuYcyCoYN1v0pxDOdTNsk5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arie Gershberg <agershberg@marvell.com>

Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
to header file, so it can be used by the different HW devices.

NVMeTCP offload devices might have different limitations of the
allowed options, for example, a device that does not support all the
queue types. With tcp and rdma, only the nvme-tcp and nvme-rdma layers
handle those attributes and the HW devices do not create any limitations
for the allowed options.

An alternative design could be to add separate fields in nvme_tcp_ofld_ops
such as max_hw_sectors and max_segments that we already have in this
series.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Arie Gershberg <agershberg@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/host/fabrics.c | 7 -------
 drivers/nvme/host/fabrics.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index a2bb7fc63a73..e1e05aa2fada 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -942,13 +942,6 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
 
-#define NVMF_REQUIRED_OPTS	(NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
-#define NVMF_ALLOWED_OPTS	(NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUEUES | \
-				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
-				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
-				 NVMF_OPT_DISABLE_SQFLOW |\
-				 NVMF_OPT_FAIL_FAST_TMO)
-
 static struct nvme_ctrl *
 nvmf_create_ctrl(struct device *dev, const char *buf)
 {
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index d7f7974dc208..ce7fe3a842b1 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -68,6 +68,13 @@ enum {
 	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
 };
 
+#define NVMF_REQUIRED_OPTS	(NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
+#define NVMF_ALLOWED_OPTS	(NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUEUES | \
+				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
+				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
+				 NVMF_OPT_DISABLE_SQFLOW |\
+				 NVMF_OPT_FAIL_FAST_TMO)
+
 /**
  * struct nvmf_ctrl_options - Used to hold the options specified
  *			      with the parsing opts enum.
-- 
2.22.0

