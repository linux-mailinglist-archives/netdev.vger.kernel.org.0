Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE515DB54
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbgBNPp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:45:28 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729617AbgBNPp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:45:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EFhGor016708;
        Fri, 14 Feb 2020 07:45:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=AN6kLuWmvHkJcfS589A8BtGQp1nQ7P1VhYQLN5wYnCc=;
 b=MTH1ddOpauITo1q+n6MhEbYwOxER1b10wYZsdQOadEyvZtQ9vrjimFbCQRMsJt7MJCi0
 R3ktWWHFUg+Jt4UInLwtM0fzIckxIrOOjtNrNV0RD7E0qEd03RtdL2DcB+RuWvGevNPw
 Pp1N7dJVCNo78FtXAUDHnbMeEBuva6BisC8Nn+OATp1mymtza9wdXqmtT6RPz/N8UqRn
 0oT0BrQhoV1t2mHqKrTGqgmTZ+6nPxKsyaaB8/PrOXGk2/7SSrFuJ2+gHKgUnFY94Nmv
 FojVTEg7XrKZVf7iq5Mnk/SwE/vBph7/rvlDGyJ1AfqT13IqlzsayG19bcHo17AK/GOh zg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2nar3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:45:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:24 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:24 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:45:23 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 12C113F7040;
        Fri, 14 Feb 2020 07:45:21 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dbogdanov@marvell.com>, <pbelous@marvell.com>,
        <ndanilov@marvell.com>, <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 7/8] net: atlantic: possible fault in transition to hibernation
Date:   Fri, 14 Feb 2020 18:44:57 +0300
Message-ID: <06b9cfdc67a61c8f6b6b2aa6b9a0510513834b42.1580299250.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1580299250.git.irusskikh@marvell.com>
References: <cover.1580299250.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Belous <pbelous@marvell.com>

during hibernation freeze, aq_nic_stop could be invoked
on a stopped device. That may cause panic on access to
not yet allocated vector/ring structures.

Add a check to stop device if it is not yet stopped.

Similiarly after freeze in hibernation thaw, aq_nic_start
could be invoked on a not initialized net device.
Result will be the same.

Add a check to start device if it is initialized.
In our case, this is the same as started.

Fixes: 8aaa112a57c1 ("net: atlantic: refactoring pm logic")
Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c    | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 6b27af0db499..78b6f3248756 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -359,7 +359,8 @@ static int aq_suspend_common(struct device *dev, bool deep)
 	netif_device_detach(nic->ndev);
 	netif_tx_stop_all_queues(nic->ndev);
 
-	aq_nic_stop(nic);
+	if (netif_running(nic->ndev))
+		aq_nic_stop(nic);
 
 	if (deep) {
 		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
@@ -375,7 +376,7 @@ static int atl_resume_common(struct device *dev, bool deep)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct aq_nic_s *nic;
-	int ret;
+	int ret = 0;
 
 	nic = pci_get_drvdata(pdev);
 
@@ -390,9 +391,11 @@ static int atl_resume_common(struct device *dev, bool deep)
 			goto err_exit;
 	}
 
-	ret = aq_nic_start(nic);
-	if (ret)
-		goto err_exit;
+	if (netif_running(nic->ndev)) {
+		ret = aq_nic_start(nic);
+		if (ret)
+			goto err_exit;
+	}
 
 	netif_device_attach(nic->ndev);
 	netif_tx_start_all_queues(nic->ndev);
-- 
2.17.1

