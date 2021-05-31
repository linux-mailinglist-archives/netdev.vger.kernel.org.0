Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B9C3969D5
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhEaWzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:55:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11690 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232349AbhEaWzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:55:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMorFg001343;
        Mon, 31 May 2021 15:53:55 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnja4mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:53:55 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:53:49 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:53:46 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [RFC PATCH v7 03/27] nvme-fabrics: Expose nvmf_check_required_opts() globally
Date:   Tue, 1 Jun 2021 01:51:58 +0300
Message-ID: <20210531225222.16992-4-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: oQnhHioqWLfsTCs2armNGikqPxBFrJNP
X-Proofpoint-ORIG-GUID: oQnhHioqWLfsTCs2armNGikqPxBFrJNP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/fabrics.c | 5 +++--
 drivers/nvme/host/fabrics.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 9d5cf3454399..f71f3c229c0a 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -868,8 +868,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	return ret;
 }
 
-static int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
-		unsigned int required_opts)
+int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
+			     unsigned int required_opts)
 {
 	if ((opts->mask & required_opts) != required_opts) {
 		int i;
@@ -887,6 +887,7 @@ static int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nvmf_check_required_opts);
 
 bool nvmf_ip_options_match(struct nvme_ctrl *ctrl,
 		struct nvmf_ctrl_options *opts)
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index 38ac7b757d78..15d9c15ef8a6 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -197,5 +197,7 @@ int nvmf_get_address(struct nvme_ctrl *ctrl, char *buf, int size);
 bool nvmf_should_reconnect(struct nvme_ctrl *ctrl);
 bool nvmf_ip_options_match(struct nvme_ctrl *ctrl,
 		struct nvmf_ctrl_options *opts);
+int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
+			     unsigned int required_opts);
 
 #endif /* _NVME_FABRICS_H */
-- 
2.22.0

