Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD943E5A5C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240907AbhHJMtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:49:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8391 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240877AbhHJMtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:49:23 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GkXjC0Ckjz828j;
        Tue, 10 Aug 2021 20:45:03 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 10 Aug 2021 20:48:59 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 10 Aug
 2021 20:48:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <richardcochran@gmail.com>, <davem@davemloft.net>
Subject: [PATCH -next] ptp: ocp: Fix missing pci_disable_device() on error in ptp_ocp_probe()
Date:   Tue, 10 Aug 2021 20:54:53 +0800
Message-ID: <20210810125453.2182835-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ptp_ocp_device_init() fails, pci_disable_device() need be
called, fix this by using pcim_enable_device().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/ptp/ptp_ocp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 92edf772feed..04cce8d3b1f6 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1429,7 +1429,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto out_free;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
 		goto out_unregister;
@@ -1476,7 +1476,6 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out:
 	ptp_ocp_detach(bp);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 out_unregister:
 	devlink_unregister(devlink);
@@ -1493,7 +1492,6 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(bp);
 
 	ptp_ocp_detach(bp);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 
 	devlink_unregister(devlink);
-- 
2.25.1

