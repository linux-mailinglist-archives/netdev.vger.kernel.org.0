Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CDA2053E4
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbgFWNxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:53:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732741AbgFWNxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:53:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDfGge007439;
        Tue, 23 Jun 2020 06:53:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=+JTCFi4YJVIQ2krpzozX+/noGByhk0i8mEY0aKhBdO0=;
 b=iZw5XTNlTZ4bbDfa1bTVnC0IaYor1KeA7XqdmjAFJelzkgq0BznHDqDfQAxZ3v/c47tQ
 jsZTEEm2Y/uZYbmKPQyzbxJJ5Clpd5gnVa3RX192Rm6DTUIW1De1hMUnUb7TAN+1tG7f
 4z5et4JiNEt/6zWgTjYtZqXqlHUuUOIDYCvkcaFkk6dlt6urQQzKMjd5PORJvzqT4hLa
 /jdsEC3SZt88q86c65wyQdUN/WlQyn5tlI362eR8/OWF9qvjc4nXfCu7jN87cXiGh6k3
 m6+8EZeOSgOu7SaLK86b/pkItzFwXq7g2PHy0igFGPGlW3yiQrXhNhduEZpDo5W5Uyk+ JA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynwjfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:53:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 06:53:26 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 6DFB23F703F;
        Tue, 23 Jun 2020 06:53:22 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 3/9] net: qede: stop adding events on an already destroyed workqueue
Date:   Tue, 23 Jun 2020 16:51:31 +0300
Message-ID: <20200623135136.3185-4-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623135136.3185-1-alobakin@marvell.com>
References: <20200623135136.3185-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
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
2.25.1

