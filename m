Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016D722F7FC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgG0Snv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:43:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52650 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731554AbgG0Snu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:43:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIfGex025429;
        Mon, 27 Jul 2020 11:43:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=0Hvfq+9ysqlF9Q27RyS9SPpnPnlNZKIlbDrwqcZajC0=;
 b=xJ3Ape6pVOeWVOL4KiH8rQvhUldtdCAMDPxA65RTIXZPab3EOe1QRp4TR23F4VZ//9nX
 LskkToUClllcAzWHsF+QjAKRHltlksbd6V4TMppCTiB3v4pK8zfDWIL9OD1bR98O1jFe
 z7JrWM5m3BWctiEKFd+rT8EHTGC40CanvXzCK4k9kTNvZL1K9eh2ULk0LXlBQoSJ9ljM
 O++cU44aH9eDVre2FKIP33qczBWSeMAa9U3NBeg4hyY0/Dfxp15gDQonFUiDkAAHqY8n
 4nLNqG6w1LQ57O23/eSnPUZp0Q0dYGhH2zoAd3nGKn5X79ld8fXHYYAjF5LrZwwWwUEr qw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3qrm5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 11:43:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 11:43:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jul 2020 11:43:48 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id A06593F703F;
        Mon, 27 Jul 2020 11:43:45 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 11/11] qede: make driver reliable on unload after failures
Date:   Mon, 27 Jul 2020 21:43:10 +0300
Message-ID: <20200727184310.462-12-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727184310.462-1-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
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

