Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8FD25B242
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgIBQ60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:58:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23498 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726623AbgIBQ6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GuiEL018400;
        Wed, 2 Sep 2020 09:58:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TS8o89UofKf/EN5ITmilRWgETyrlVkEIotOt4/Oyhpg=;
 b=Warno8wpVJyu5ImdVTubuL2K29uxrYhN+gCdiKL8HMsYjWxdNTbyGHGdsNmgyK3Ro+zl
 zHn9jIRNwPhKfoA4izkwNLDcfeMNKGIF3luURvNFfCyDRAhVQTOuy9jGzP4ZEiRoroa/
 5mQ86KpXb9lMuXF+9HbfUUIdLqTGaGMbYwK7T8ihasg3lYyVmuHWlu0WrBkAU4CSsNDU
 2kKvzqCIcyjXd5RRPmx1Op6Sy8HrZTaK4eq9pzOk8HZeQGmm3VWp5N9V+YqTFTYll59H
 siXlVV1RVqHvpR5y37zv32a6w/W2T7rJ5ewhXubvfumtChw62rm+zmeTBEK3d2CEeSw9 LA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqgbff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:13 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id DA54A3F703F;
        Wed,  2 Sep 2020 09:58:10 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 2/8] RDMA/qedr: Fix doorbell setting
Date:   Wed, 2 Sep 2020 19:57:35 +0300
Message-ID: <20200902165741.8355-3-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200902165741.8355-1-michal.kalderon@marvell.com>
References: <20200902165741.8355-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_11:2020-09-02,2020-09-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the doorbell setting so that the maximum value between
the last and current value is set. This is to avoid doorbells
being lost.

Fixes: a7efd7773e31 ("qedr: Add support for PD,PKEY and CQ verbs")
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index e35f2a20bfdf..62fe9fc40f42 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -999,7 +999,7 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		/* Generate doorbell address. */
 		cq->db.data.icid = cq->icid;
 		cq->db_addr = dev->db_addr + db_offset;
-		cq->db.data.params = DB_AGG_CMD_SET <<
+		cq->db.data.params = DB_AGG_CMD_MAX <<
 		    RDMA_PWM_VAL32_DATA_AGG_CMD_SHIFT;
 
 		/* point to the very last element, passing it we will toggle */
-- 
2.14.5

