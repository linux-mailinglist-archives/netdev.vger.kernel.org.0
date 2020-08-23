Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA4424ED11
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgHWLUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 07:20:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbgHWLUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 07:20:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07NBFOj8016839;
        Sun, 23 Aug 2020 04:20:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YST6hpJZdkwDoUkwKomPw2lVBV1k2gCDgUTZVf3+vCM=;
 b=QmmFFnqurC9Bg4bFi4GgJdLdjKykQU0ZtOw6xKtTc1F/ET7oc+xoJRk0LMSUwG+GCEql
 k8wv7eYs8GEYIrNJphfCf/pY4DYwmB8uN2EYRxtZTOl2T9wlZid3Mbjs2Rm4bPJAqD1O
 5HJrAN8pM1Ssb1+87KoV5lga07ju6mJrpynN97SdZddRWlP5CuukNm+7bRysZmwAkh4m
 ADCWkrUYzUlVvuUt0emU4B12Cd5buXlRZEk3fo3KBBeYICXsreb47jFVuMfkLgZ/dafE
 QrRxQ+MT9fMenZip7mdiEXRD8oMEo1fhpDeYbK3BaYGyoz3ADKj3HWfLjb1wv9R5h6hP eg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vmjw9f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 04:20:32 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 04:20:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 23 Aug 2020 04:20:31 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 262253F7043;
        Sun, 23 Aug 2020 04:20:27 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v7 net-next 10/10] qede: make driver reliable on unload after failures
Date:   Sun, 23 Aug 2020 14:19:34 +0300
Message-ID: <20200823111934.305-11-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200823111934.305-1-irusskikh@marvell.com>
References: <20200823111934.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-22_14:2020-08-21,2020-08-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case recovery was not successful, netdev still should be
present. But we should clear cdev if something bad happens
on recovery.

We also check cdev for null on dev close. That could be a case
if recovery was not successful.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 58e1a6e542eb..20d2296beb79 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1238,7 +1238,10 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 err4:
 	qede_rdma_dev_remove(edev, (mode == QEDE_PROBE_RECOVERY));
 err3:
-	free_netdev(edev->ndev);
+	if (mode != QEDE_PROBE_RECOVERY)
+		free_netdev(edev->ndev);
+	else
+		edev->cdev = NULL;
 err2:
 	qed_ops->common->slowpath_stop(cdev);
 err1:
@@ -2473,7 +2476,8 @@ static int qede_close(struct net_device *ndev)
 
 	qede_unload(edev, QEDE_UNLOAD_NORMAL, false);
 
-	edev->ops->common->update_drv_state(edev->cdev, false);
+	if (edev->cdev)
+		edev->ops->common->update_drv_state(edev->cdev, false);
 
 	return 0;
 }
-- 
2.17.1

