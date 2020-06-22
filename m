Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770642035A3
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgFVLOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:14:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10688 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728070AbgFVLOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:14:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB4QxD006349;
        Mon, 22 Jun 2020 04:14:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=1jC8vw5IckmccgxfVcMnGInOWw5kRghaO0rPZUm9yp8=;
 b=Vv8/OVNSMtx0MqNSfDYmCWzyJT+MS44m/zsD0piGiJOVQ7ghhjo81UOkEh+IOVgO4lL1
 fQnazkhbpRYzxqhwRKxH2A+okdCfRkimhQh8O9gPUsyOx1mNm+Bgil3miXHeDChzuHBU
 cUxbDYjeU7Q4+v7zYtGIvpTnJiojvTY1Up9GHG+S8ajtbuA68V36M6rmhJahKEjR2AjN
 NBXt4Vojqh1o4LVauNcuLOSOKCXXmAuldgeP9QbfR7tYdx92Z102NcISxa6XmIstgkdW
 GArAiknJyq3kk/5c/dzpIJqIyhpgY+NnWyIX1H3yUB4maR0Ns0QVrEP4X6hU02oD1yPt HQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftpg5x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:35 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 531FD3F703F;
        Mon, 22 Jun 2020 04:14:31 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 3/9] net: qede: stop adding events on an already destroyed workqueue
Date:   Mon, 22 Jun 2020 14:14:07 +0300
Message-ID: <20200622111413.7006-4-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set rdma_wq pointer to NULL after destroying the workqueue and check
for it when adding new events to fix crashes on driver unload.

Fixes: cee9fbd8e2e9 ("qede: Add qedr framework")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 2d873ae8a234..668ccc9d49f8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -105,6 +105,7 @@ static void qede_rdma_destroy_wq(struct qede_dev *edev)
 
 	qede_rdma_cleanup_event(edev);
 	destroy_workqueue(edev->rdma_info.rdma_wq);
+	edev->rdma_info.rdma_wq = NULL;
 }
 
 int qede_rdma_dev_add(struct qede_dev *edev, bool recovery)
@@ -325,7 +326,7 @@ static void qede_rdma_add_event(struct qede_dev *edev,
 	if (edev->rdma_info.exp_recovery)
 		return;
 
-	if (!edev->rdma_info.qedr_dev)
+	if (!edev->rdma_info.qedr_dev || !edev->rdma_info.rdma_wq)
 		return;
 
 	/* We don't want the cleanup flow to start while we're allocating and
-- 
2.21.0

