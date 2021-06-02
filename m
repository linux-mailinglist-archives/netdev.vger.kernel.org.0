Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A643992BE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFBSpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:45:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35186 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229610AbhFBSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:45:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152IeM6D000494;
        Wed, 2 Jun 2021 11:43:26 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xrcek-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 11:43:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 11:43:24 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Jun 2021 11:43:21 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <linux-nvme@lists.infradead.org>, <sagi@grimberg.me>, <hch@lst.de>,
        <axboe@fb.com>, <kbusch@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [PATCH 3/8] nvme-fabrics: Expose nvmf_check_required_opts() globally
Date:   Wed, 2 Jun 2021 21:42:41 +0300
Message-ID: <20210602184246.14184-4-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210602184246.14184-1-smalin@marvell.com>
References: <20210602184246.14184-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: pMZt_AvMPTA-EQzTvRC1eS9M_fk5R1rq
X-Proofpoint-GUID: pMZt_AvMPTA-EQzTvRC1eS9M_fk5R1rq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_10:2021-06-02,2021-06-02 signatures=0
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
index e8f6b8f9fd35..b4d5d46dae62 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -865,8 +865,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	return ret;
 }
 
-static int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
-		unsigned int required_opts)
+int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
+			     unsigned int required_opts)
 {
 	if ((opts->mask & required_opts) != required_opts) {
 		int i;
@@ -884,6 +884,7 @@ static int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
 
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

