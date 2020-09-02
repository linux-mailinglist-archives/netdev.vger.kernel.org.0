Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2E25B241
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgIBQ6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:58:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60356 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727026AbgIBQ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GuSbX018301;
        Wed, 2 Sep 2020 09:58:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ej/DYrtyeDNsIDrFAOjQBAAdPJcyvkXSl7MI1SRU8+Y=;
 b=Lcl2w8jZiuEKBWCbV7OrfO1bairiuu9vWzMPfVq8Z+hCVSoI/z63zbzb0CGI8atE/kM4
 XAUOhPRuJ8ilS0meaBx1gTragosrxBBAEBDAPGNKIvMUzIzwRZX/aOVisztlNapIS7oK
 5GkLAOjqcJva1PgfRpPdnFqnVaG5SGkHFtQrAVBxugQ0oenTINonPcDQy3D7aR0sBb9j
 IcRBYczN/gRBdisxxJ6Uqh5oJwryo0fk01AGAuBDL13sOpGbd/qd8TrFW91k2lodXUvS
 bjW5Mh+8A5x1R9unX0LnRy/GmPdmAxECD2BgUxiLgLD5uCs1s4S4dDmOKWuePOoOzMt4 AQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqgbf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:11 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:10 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 0DD213F703F;
        Wed,  2 Sep 2020 09:58:07 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 1/8] RDMA/qedr: Fix qp structure memory leak
Date:   Wed, 2 Sep 2020 19:57:34 +0300
Message-ID: <20200902165741.8355-2-michal.kalderon@marvell.com>
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

The qedr_qp structure wasn't freed when the protocol was RoCE.
kmemleak output when running basic RoCE scenario.

unreferenced object 0xffff927ad7e22c00 (size 1024):
  comm "ib_send_bw", pid 7082, jiffies 4384133693 (age 274.698s)
  hex dump (first 32 bytes):
    00 b0 cd a2 79 92 ff ff 00 3f a1 a2 79 92 ff ff  ....y....?..y...
    00 ee 5c dd 80 92 ff ff 00 f6 5c dd 80 92 ff ff  ..\.......\.....
  backtrace:
    [<00000000b2ba0f35>] qedr_create_qp+0xb3/0x6c0 [qedr]
    [<00000000e85a43dd>] ib_uverbs_handler_UVERBS_METHOD_QP_CREATE+0x555/0xad0 [ib_uverbs]
    [<00000000fee4d029>] ib_uverbs_cmd_verbs+0xa5a/0xb80 [ib_uverbs]
    [<000000005d622660>] ib_uverbs_ioctl+0xa4/0x110 [ib_uverbs]
    [<00000000eb4cdc71>] ksys_ioctl+0x87/0xc0
    [<00000000abe6b23a>] __x64_sys_ioctl+0x16/0x20
    [<0000000046e7cef4>] do_syscall_64+0x4d/0x90
    [<00000000c6948f76>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1212767e23bb ("qedr: Add wrapping generic structure for qpidr and
adjust idr routines")
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index b49bef94637e..e35f2a20bfdf 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2752,6 +2752,8 @@ int qedr_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	if (rdma_protocol_iwarp(&dev->ibdev, 1))
 		qedr_iw_qp_rem_ref(&qp->ibqp);
+	else
+		kfree(qp);
 
 	return 0;
 }
-- 
2.14.5

