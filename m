Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD625B291
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 19:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgIBRBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 13:01:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51216 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728407AbgIBQ6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GuAws018075;
        Wed, 2 Sep 2020 09:58:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6Zx+OeOyUYXvglF9x2/0HoROGyggYDPPf5uEhEf1UC8=;
 b=j9JI1rmB7W9a2t58elpl878RnZc4mCbsJRyeaYvn+ukRFCy2+YLMG286PdWYJ2T4Y8En
 5f6yxxM7QpekJxD2eWI/UVbW12y8h1NH4T1YAAiQrozSKpyRIXc7a0a0y7AEx8TUQwJr
 OZOYz/siWP3mswVhctQS01YaBBWZZRgJ6xd6dPaavBvS0HBJpiReNj1kKPwyWNxv2skn
 X7pQsBeITeeg2XTo8GudtfDWN0uDgi8f4cXqjF4jWXvLgz262h2QCkPTufLG6w1JWPXJ
 xCxEsRCQzsNzoA322W484C3NW4FxH0WGVQvm0NuzHbEI5YDz+NlWl6PypfGFS81R4NZ4 4w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqgbgm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:27 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 3E87B3F7044;
        Wed,  2 Sep 2020 09:58:25 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 7/8] RDMA/qedr: Fix inline size returned for iWARP
Date:   Wed, 2 Sep 2020 19:57:40 +0300
Message-ID: <20200902165741.8355-8-michal.kalderon@marvell.com>
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

commit 59e8970b3798 ("RDMA/qedr: Return max inline data in QP query
result")
changed query_qp max_inline size to return the max roce inline size.
When iwarp was introduced, this should have been modified
to return the max inline size based on protocol.
This size is cached in the device attributes

Fixes: 69ad0e7fe845 ("RDMA/qedr: Add support for iWARP in user space")
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 4ec2d05f63d1..3b19afdf71b8 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2637,7 +2637,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	qp_attr->cap.max_recv_wr = qp->rq.max_wr;
 	qp_attr->cap.max_send_sge = qp->sq.max_sges;
 	qp_attr->cap.max_recv_sge = qp->rq.max_sges;
-	qp_attr->cap.max_inline_data = ROCE_REQ_MAX_INLINE_DATA_SIZE;
+	qp_attr->cap.max_inline_data = dev->attr.max_inline;
 	qp_init_attr->cap = qp_attr->cap;
 
 	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ROCE;
-- 
2.14.5

