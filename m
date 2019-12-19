Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DF212692E
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfLSSfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:35:22 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33570 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726840AbfLSSfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 13:35:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJIE0ha010179;
        Thu, 19 Dec 2019 10:35:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=qb4oRM6eP7Q/JXFDX1348pBBHwV04GzDdBKnsXARAeI=;
 b=Bb9/GXUh+zPM6Pkha+Hix1abkh54VVSzA/9J00zL7XT9N+x8tWLKn6JdeSUccvQvMF1C
 N4RMfHJQaTpmVt7yiXE5etbgrwVGPYB6azsUv6IUxNE4Xsc5vPq9nEBrqiOVhLTW0OiT
 6Jf01k2P7FpklnzAWFB/4GoRAkZOSjbrjyNGFkGunuodqud2QiVODNV5YypijybzKbbd
 qe848ox9GVbDdgtq8dqtUJxN/v/eOT5xKUOffOlpIlB+EpMXXsuPvFNEibNs/J4qkJOY
 xftqXgO4K5pF/KsoBWlYGbl8ldCsY/hsBYVe+Dkhn+uyKUXZOJW5ZRd0etUfm1xc+A9v ew== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wxneb49t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 10:35:20 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Dec
 2019 10:35:19 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Dec 2019 10:35:19 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 31C1A3F703F;
        Thu, 19 Dec 2019 10:35:19 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBJIZIUr007054;
        Thu, 19 Dec 2019 10:35:18 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBJIZIIC007053;
        Thu, 19 Dec 2019 10:35:18 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 1/1] qede: Disable hardware gro when xdp prog is installed
Date:   Thu, 19 Dec 2019 10:35:16 -0800
Message-ID: <20191219183516.7017-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 18c602dee472 ("qede: Use NETIF_F_GRO_HW.") introduced
a regression in driver that when xdp program is installed on
qede device, device's aggregation feature (hardware GRO) is not
getting disabled, which is unexpected with xdp.

Fixes: 18c602dee472 ("qede: Use NETIF_F_GRO_HW.")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index a220cc7c947a..ba53612ae0df 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1406,6 +1406,7 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 		rxq->rx_buf_seg_size = roundup_pow_of_two(size);
 	} else {
 		rxq->rx_buf_seg_size = PAGE_SIZE;
+		edev->ndev->features &= ~NETIF_F_GRO_HW;
 	}
 
 	/* Allocate the parallel driver ring for Rx buffers */
@@ -1450,6 +1451,7 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 		}
 	}
 
+	edev->gro_disable = !(edev->ndev->features & NETIF_F_GRO_HW);
 	if (!edev->gro_disable)
 		qede_set_tpa_param(rxq);
 err:
@@ -1702,8 +1704,6 @@ static void qede_init_fp(struct qede_dev *edev)
 		snprintf(fp->name, sizeof(fp->name), "%s-fp-%d",
 			 edev->ndev->name, queue_id);
 	}
-
-	edev->gro_disable = !(edev->ndev->features & NETIF_F_GRO_HW);
 }
 
 static int qede_set_real_num_queues(struct qede_dev *edev)
-- 
2.18.1

