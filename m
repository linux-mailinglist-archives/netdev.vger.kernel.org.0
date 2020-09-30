Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E16A27EF8B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbgI3QpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:45:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8938 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3QpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:45:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UGinfg015531;
        Wed, 30 Sep 2020 09:45:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=J9gCVqW81lqTPKdlXe35BLu675XBFk0djPqTpH4HB48=;
 b=A2XuEgTaA7HbVO/u05mvtCVfSCNQF8uUHqc5yHjoFSrrL9O2twuucJQs4/GwyRs1UreS
 Ef67QE9Inei73NpuuVQTdyodnsh3lnaN8DoHHO7FJkfT+9I61FJF5RDrNpFrs+BxdFeA
 AdpvCHSJu2Vt6BX2QI6OP5zkoSE/ADpanYjo6pI5chJDMomBA+QUZMQcqv9YNB7Qzpz2
 AgqiB6hf7lnAese3lF3KG051dSfOvXBsg84DWI8kIhZsyhFGC5+q2LQbdMV8Ee17Dgpg
 FBKZywcoUdR1+yZH8j2I6Lunfd4Rj64UIszZ3R1ALQcng3uSaYDTRej2zIK9c4ZfiHoW DQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55pb324-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 09:45:05 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 09:45:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 09:45:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Sep 2020 09:45:04 -0700
Received: from cavium.com.marvell.com (unknown [10.29.8.35])
        by maili.marvell.com (Postfix) with ESMTP id C21153F7043;
        Wed, 30 Sep 2020 09:45:01 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <davem@davemloft.net>, Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net PATCH v2 3/4] octeontx2-pf: Fix the device state on error
Date:   Wed, 30 Sep 2020 21:39:14 +0530
Message-ID: <1601482154-15005-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Currently in otx2_open on failure of nix_lf_start
transmit queues are not stopped which are already
started in link_event. Since the tx queues are not
stopped network stack still try's to send the packets
leading to driver crash while access the device resources.

Fixes: 50fe6c02e ("octeontx2-pf: Register and handle link notifications")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 75a8c40..5d620a3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1560,10 +1560,13 @@ int otx2_open(struct net_device *netdev)
 
 	err = otx2_rxtx_enable(pf, true);
 	if (err)
-		goto err_free_cints;
+		goto err_tx_stop_queues;
 
 	return 0;
 
+err_tx_stop_queues:
+	netif_tx_stop_all_queues(netdev);
+	netif_carrier_off(netdev);
 err_free_cints:
 	otx2_free_cints(pf, qidx);
 	vec = pci_irq_vector(pf->pdev,
-- 
2.7.4

