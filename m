Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43383230603
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgG1I7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:59:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61620 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728512AbgG1I7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 04:59:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S8v2bq017029;
        Tue, 28 Jul 2020 01:59:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=0Hvfq+9ysqlF9Q27RyS9SPpnPnlNZKIlbDrwqcZajC0=;
 b=tTW8jCVtLNmiLUioSad/onIRFp+UpL0SId3lgE0FMLdgbelctLrcjesCvWYNBylT5Fyf
 NnmM8Zwjnw5ceQQX0FmYo5T8KkzqpvKuoZYNQwfbAZLgFwdtUblE65wFgecMBvrbvskQ
 5XWkC7RiJtUaLyBCr+WamAp3AFGcGzQGudzm7yRydQK5tFbN02Rs+BL3LqbioarUaOMA
 KvJFiCaL4msaLRVbt2+itu7Bg6RYBjdZd5XsK3pXhoLhWvfCsDu7vVJKibJdYvCAMbvi
 D0/cNkkSixSQbrYV5GOnveqZgyPk1k96dVdhrqkacgUQoj9z6XawRWPUGZfbKH8uU3SS Lg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32gm8njhkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 01:59:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 01:59:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Jul 2020 01:59:35 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 47C303F703F;
        Tue, 28 Jul 2020 01:59:33 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 11/11] qede: make driver reliable on unload after failures
Date:   Tue, 28 Jul 2020 11:58:59 +0300
Message-ID: <20200728085859.899-12-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728085859.899-1-irusskikh@marvell.com>
References: <20200728085859.899-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_01:2020-07-28,2020-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First, we check cdev for null on dev close. That could be a case
if recovery was not successful.

Next, we nullify cdev if something bad happens on recovery, to
not to access freed memory accidentially.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 937d8e69ad39..03b0c943b759 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1244,6 +1244,7 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 	qed_ops->common->slowpath_stop(cdev);
 err1:
 	qed_ops->common->remove(cdev);
+	edev->cdev = NULL;
 err0:
 	return rc;
 }
@@ -2474,7 +2475,8 @@ static int qede_close(struct net_device *ndev)
 
 	qede_unload(edev, QEDE_UNLOAD_NORMAL, false);
 
-	edev->ops->common->update_drv_state(edev->cdev, false);
+	if (edev->cdev)
+		edev->ops->common->update_drv_state(edev->cdev, false);
 
 	return 0;
 }
-- 
2.17.1

