Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFB025B24B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgIBQ6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:58:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728392AbgIBQ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GttIl000466;
        Wed, 2 Sep 2020 09:58:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dBqJCrQHiey7Gct+vrlrUNh6V1GDqzv8arS2jMkbj3s=;
 b=RlChEADGVSj+/AXSG4Eft4NnyQArPz+ORiB6H95yjA9uqUdHuGVeHWdu+K+i7XK9eLtp
 cid6wXSPcQHAOO+G5WqjvbjzWDbQWKtNiK7JfKZO/fnAEhRGt2cIx+8EPxZ7DVtTT1tK
 nrCOGawrtbklQY7mlXsf+mf+GwOa5lIxiRcwvv+7pgHznlWpW/DotXkPNdCniLtJwIQh
 NC1uPDq/5E+F07GSgcLXmMGo0XIn2R9NMsFFd3vgH9TNonBSVwe+Zn18oK5m97OwokcO
 SM+omK4Ob4nqW3fSXL6W4ORKSWHIyDwLsBTT9mqOUVmCENNMZITrkCOOv8BIWI6VgWZb 7g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq7jes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:24 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 59BD23F703F;
        Wed,  2 Sep 2020 09:58:22 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 6/8] RDMA/qedr: Fix iWARP active mtu display
Date:   Wed, 2 Sep 2020 19:57:39 +0300
Message-ID: <20200902165741.8355-7-michal.kalderon@marvell.com>
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

Currently iWARP does not support mtu-change. Notify user when
MTU changes that reload of qedr is required for mtu to change.
Display the correct active mtu.

Fixes: f5b1b1775be6 ("RDMA/qedr: Add iWARP support in existing verbs")
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c  | 7 +++++++
 drivers/infiniband/hw/qedr/verbs.c | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 8e1365951fb6..1f32e8b8cc11 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -1026,6 +1026,13 @@ static void qedr_notify(struct qedr_dev *dev, enum qede_rdma_event event)
 	case QEDE_CHANGE_ADDR:
 		qedr_mac_address_change(dev);
 		break;
+	case QEDE_CHANGE_MTU:
+		if (rdma_protocol_iwarp(&dev->ibdev, 1))
+			if (dev->ndev->mtu != dev->iwarp_max_mtu)
+				DP_NOTICE(dev,
+					  "Mtu was changed from %d to %d. This will not take affect for iWARP until qedr is reloaded\n",
+					  dev->iwarp_max_mtu, dev->ndev->mtu);
+		break;
 	default:
 		pr_err("Event not supported\n");
 	}
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 62fe9fc40f42..4ec2d05f63d1 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -231,15 +231,16 @@ int qedr_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr *attr)
 		attr->phys_state = IB_PORT_PHYS_STATE_DISABLED;
 	}
 	attr->max_mtu = IB_MTU_4096;
-	attr->active_mtu = iboe_get_mtu(dev->ndev->mtu);
 	attr->lid = 0;
 	attr->lmc = 0;
 	attr->sm_lid = 0;
 	attr->sm_sl = 0;
 	attr->ip_gids = true;
 	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		attr->active_mtu = iboe_get_mtu(dev->iwarp_max_mtu);
 		attr->gid_tbl_len = 1;
 	} else {
+		attr->active_mtu = iboe_get_mtu(dev->ndev->mtu);
 		attr->gid_tbl_len = QEDR_MAX_SGID;
 		attr->pkey_tbl_len = QEDR_ROCE_PKEY_TABLE_LEN;
 	}
-- 
2.14.5

