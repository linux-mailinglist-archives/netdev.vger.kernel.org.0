Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4ABD2ECD9F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 11:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbhAGKQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 05:16:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbhAGKQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 05:16:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 107AEXhH011439;
        Thu, 7 Jan 2021 02:15:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=8XkpVUGNJnLte6APyGiHdCIL1BuiuZ5TOnsYfPRWigc=;
 b=VxUEJI3pt3ipC333IMYdCB/zELOy0byCt6xiiXDqwEwpHLCJ+UZI3UD1pByiJcp8sFXe
 e+4x2CxJ59AosCyJPNakAsc+NoTlzi268xCPz1CN4qssWMNclEpG8kO6TUlF71dFvWQP
 KuOBRtE64hGhPCYoOExJAvlSVSrYzJUB+GF6dxmLRWYU61EGae7BnJcSTwcV29N9dnqk
 sDcMIzENKZeYsH8WDEy0gBZq4dZnCL1jOvQ2WCZmnYOXgHU/5MurYTfe4jEVWltu7d12
 KNfw67queaMEzoEJbSYlzfbjLe6PUu6hIyEuE60V4QZRf44VE2+TKKRPlKFquA/IAh96 bw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35wy5a07qd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 02:15:51 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jan
 2021 02:15:47 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jan
 2021 02:15:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Jan 2021 02:15:46 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B4FD93F703F;
        Thu,  7 Jan 2021 02:15:46 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 107AFkA9006781;
        Thu, 7 Jan 2021 02:15:46 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 107AFkLn006771;
        Thu, 7 Jan 2021 02:15:46 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <irusskikh@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>
Subject: [PATCH net 1/1] netxen_nic: fix MSI/MSI-x interrupts
Date:   Thu, 7 Jan 2021 02:15:20 -0800
Message-ID: <20210107101520.6735-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_05:2021-01-07,2021-01-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For all PCI functions on the netxen_nic adapter, interrupt
mode (INTx or MSI) configuration is dependent on what has
been configured by the PCI function zero in the shared
interrupt register, as these adapters do not support mixed
mode interrupts among the functions of a given adapter.

Logic for setting MSI/MSI-x interrupt mode in the shared interrupt
register based on PCI function id zero check is not appropriate for
all family of netxen adapters, as for some of the netxen family
adapters PCI function zero is not really meant to be probed/loaded
in the host but rather just act as a management function on the device,
which caused all the other PCI functions on the adapter to always use
legacy interrupt (INTx) mode instead of choosing MSI/MSI-x interrupt mode.

This patch replaces that check with port number so that for all
type of adapters driver attempts for MSI/MSI-x interrupt modes.

Fixes: b37eb210c076 ("netxen_nic: Avoid mixed mode interrupts")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index f218477..d258e0c 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -564,11 +564,6 @@ static int netxen_set_features(struct net_device *dev,
 	.ndo_set_features = netxen_set_features,
 };
 
-static inline bool netxen_function_zero(struct pci_dev *pdev)
-{
-	return (PCI_FUNC(pdev->devfn) == 0) ? true : false;
-}
-
 static inline void netxen_set_interrupt_mode(struct netxen_adapter *adapter,
 					     u32 mode)
 {
@@ -664,7 +659,7 @@ static int netxen_setup_intr(struct netxen_adapter *adapter)
 	netxen_initialize_interrupt_registers(adapter);
 	netxen_set_msix_bit(pdev, 0);
 
-	if (netxen_function_zero(pdev)) {
+	if (adapter->portnum == 0) {
 		if (!netxen_setup_msi_interrupts(adapter, num_msix))
 			netxen_set_interrupt_mode(adapter, NETXEN_MSI_MODE);
 		else
-- 
1.8.3.1

