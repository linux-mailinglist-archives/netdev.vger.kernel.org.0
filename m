Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9786233ED8
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 07:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbgGaFyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 01:54:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50774 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731301AbgGaFyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 01:54:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V5sdpq008143;
        Thu, 30 Jul 2020 22:54:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=JGHjrhMBsHNhCBWrKZK++isMYyaed5rD4TMAhx+yJVc=;
 b=gBa3QLZy8vFfSWL5U9DZRITdUtafkNUuE1gkFfh9CbLHrupgSkiTMNFI7brAdeEDmT22
 SHPhyajY3qu+IuBN0TpMbf5nHtgFLSG6nXvM0qgJn7b+QhD/Va519ylOfRA5QZ9SAmFi
 Px0oyiAIDLI+fiHFnR5OkRCEaU2lb9FofEPLyyAI3pfay2ddAxGm70VmCGmplohO96kq
 Ao0lCfcFLlI7550UvCvnG4PhqC5DJaTUepFhYhommuuSYVAOkLB6rpdoJWjyuv5Mzi4+
 bdkJO/MMpB5DUMRqoerpU+9R7rjjMygOh3VGAOVucVM4TjdSpM/LmF29lwRuqEjHR7Wd uQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0t3juj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 22:54:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 22:54:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Jul 2020 22:54:40 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 2A63F3F703F;
        Thu, 30 Jul 2020 22:54:36 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Igor Russkikh <irusskikh@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v4 net-next 10/10] qede: make driver reliable on unload after failures
Date:   Fri, 31 Jul 2020 08:54:01 +0300
Message-ID: <20200731055401.940-11-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731055401.940-1-irusskikh@marvell.com>
References: <20200731055401.940-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_01:2020-07-30,2020-07-31 signatures=0
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
index 287e10effb49..01a7bff91d6c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1240,7 +1240,10 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
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
@@ -2475,7 +2478,8 @@ static int qede_close(struct net_device *ndev)
 
 	qede_unload(edev, QEDE_UNLOAD_NORMAL, false);
 
-	edev->ops->common->update_drv_state(edev->cdev, false);
+	if (edev->cdev)
+		edev->ops->common->update_drv_state(edev->cdev, false);
 
 	return 0;
 }
-- 
2.17.1

