Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91DA231D82
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgG2Lja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:39:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9664 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726751AbgG2Lj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:39:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TBZZwJ006392;
        Wed, 29 Jul 2020 04:39:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Nx8nKZu89waU4rT+tDYC04gPEC2tJADTthPAWhTxnRw=;
 b=Eood07sn+v8bayaejRqUVHx2JcZZ7O/iDGK+CP/JI3hzJXGfv/n3X+RIHrbPaVcswahZ
 8MhdyvI43kz1EEyTmZDvhAACc47rGAhMMkCW/o6oH0rUXETLYX8j+dG1VOKOsrCpGbpK
 XPpMzfilmq71GhKeg3VYZ/gqavuuuDpFrueb6o4uRGPWoai1UrYSUo3UpQMjh6QScAY0
 AoP7lcdnslGP/xYD2KYOFsAI37KXEr5xstVvGs/nF059KNo95tJjfd0XquRE306IvTEX
 1SgzErOx/0X41ys3ttGHZ327feSPwrb9E60g4pk9xcRYBtbin9zeQdEMe/O7j1L6pbxl /g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r0r7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 04:39:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 04:39:25 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 269283F703F;
        Wed, 29 Jul 2020 04:39:22 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 net-next 11/11] qede: make driver reliable on unload after failures
Date:   Wed, 29 Jul 2020 14:38:46 +0300
Message-ID: <20200729113846.1551-12-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729113846.1551-1-irusskikh@marvell.com>
References: <20200729113846.1551-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_04:2020-07-29,2020-07-29 signatures=0
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
index 937d8e69ad39..eeb4a7311633 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1239,7 +1239,10 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
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
@@ -2474,7 +2477,8 @@ static int qede_close(struct net_device *ndev)
 
 	qede_unload(edev, QEDE_UNLOAD_NORMAL, false);
 
-	edev->ops->common->update_drv_state(edev->cdev, false);
+	if (edev->cdev)
+		edev->ops->common->update_drv_state(edev->cdev, false);
 
 	return 0;
 }
-- 
2.17.1

