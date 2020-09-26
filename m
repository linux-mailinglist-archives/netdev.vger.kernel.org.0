Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFCA279796
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 09:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgIZHmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 03:42:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48152 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgIZHmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 03:42:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q7ZsJC021155;
        Sat, 26 Sep 2020 00:42:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=YUJGO5GHoxmNr9HjqIEgOVl8QKpyRc1cuDOwxk2Dy6Q=;
 b=EVRVMNH5lc8O8pYJTS0QE4qWHzOSZV/QoHC4EXJIfslDM/Fia/lXI7pyqDw3Mi3CgoFz
 2OZrwCuM+3s59UtXVDaQPizj7v534WycvOTg0O7ck/24713XtpbF0rMyIkHSZ0quj9uE
 SJ/hKOPSRRy75beCsQz7WemZI0o8XqSlQUkiUYNrVK8Y2RpIVATLqC8m/28gxvet9UlH
 gICW6X0/u5CgJjXAXAuhiq+YrN86W9mI48X47XRd4RfoI1zrcC17qeTahaP/uymk0w5b
 ngbzuTkZxWqNXlqyc27WFuiKUYvuPVDcO+nkB08FEujQeFYre1b4CNop0ruv0DlQuOeO nA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgnyehv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 00:42:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 26 Sep
 2020 00:42:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 26 Sep 2020 00:42:10 -0700
Received: from cavium.com.marvell.com (unknown [10.29.8.35])
        by maili.marvell.com (Postfix) with ESMTP id F24F33F7043;
        Sat, 26 Sep 2020 00:42:07 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <jerinj@marvell.com>, <davem@davemloft.net>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net PATCH] octeontx2-pf: Fix the device state on error
Date:   Sat, 26 Sep 2020 12:36:22 +0530
Message-ID: <1601103982-1792-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Currently in otx2_open on failure of nix_lf_start
transmit queues are not stopped which are already
started in link_event. Since the tx queues are not
stopped network stack still try's to send the packets
leading to driver crash while access the device resources.

Fixes: 50fe6c02e
("octeontx2-pf: Register and handle link notifications")
 
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

