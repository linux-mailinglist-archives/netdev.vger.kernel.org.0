Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2C73939E3
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhE1ACN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:02:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233896AbhE1ACL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:02:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RNp1au024322;
        Thu, 27 May 2021 17:00:26 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38sxpmcyvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:00:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 17:00:24 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 27 May 2021 17:00:21 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>
Subject: [RFC PATCH v6 03/27] nvme-fabrics: Expose nvmf_check_required_opts() globally
Date:   Fri, 28 May 2021 02:58:38 +0300
Message-ID: <20210527235902.2185-4-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210527235902.2185-1-smalin@marvell.com>
References: <20210527235902.2185-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 8QcrLUzyWa_v-ip1-ecuNRrhjmuingJW
X-Proofpoint-GUID: 8QcrLUzyWa_v-ip1-ecuNRrhjmuingJW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_13:2021-05-27,2021-05-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

nvmf_check_required_opts() is used to check if user provided opts has
the required_opts or not. if not, it will log which options are not
provided.

It can be leveraged by nvme-tcp-offload to check if provided opts are
supported by this specific vendor driver or not.

So expose nvmf_check_required_opts() globally.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/host/fabrics.c | 5 +++--
 drivers/nvme/host/fabrics.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index e1e05aa2fada..ceb263eb50fb 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -860,8 +860,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	return ret;
 }
 
-static int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
-		unsigned int required_opts)
+int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
+			     unsigned int required_opts)
 {
 	if ((opts->mask & required_opts) != required_opts) {
 		int i;
@@ -879,6 +879,7 @@ static int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nvmf_check_required_opts);
 
 bool nvmf_ip_options_match(struct nvme_ctrl *ctrl,
 		struct nvmf_ctrl_options *opts)
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index ce7fe3a842b1..8399fcc063ef 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -193,5 +193,7 @@ int nvmf_get_address(struct nvme_ctrl *ctrl, char *buf, int size);
 bool nvmf_should_reconnect(struct nvme_ctrl *ctrl);
 bool nvmf_ip_options_match(struct nvme_ctrl *ctrl,
 		struct nvmf_ctrl_options *opts);
+int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
+			     unsigned int required_opts);
 
 #endif /* _NVME_FABRICS_H */
-- 
2.22.0

