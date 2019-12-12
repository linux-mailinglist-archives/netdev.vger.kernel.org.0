Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547DF11D034
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfLLOtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 09:49:35 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10084 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729669AbfLLOtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 09:49:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCEgot6014579;
        Thu, 12 Dec 2019 06:49:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=esjUsElEsdSSAn7BQ88BtgQZa9fOxDz9xhGeaHy3xK0=;
 b=r5bLdtDrVCMUDPFiXELHiGkyCiwIgLS84ch1qyb2yYGAD6GrfhV3dEHMCUhj7uB3ksU+
 pOrTztWUKTYSGMSgLE0rTKeTiGJBG22a6PBE4h+oLV3lYEkqswEJ7/ojBPuln6CReLZw
 tqV4HBvtZLUJzD33Kc7L/pYno2GkPOegU3RpQNDxBF78WlXbFsvqHQbV36EkYZtiOUBs
 VzBi3FLJqfyc8Jzzgj18gNiyPYOyxeCoe5bbK1PXafRCrcDbHdLpM4EMr9Pa9LPnJK+Z
 +pN0uBkhxsjI2MuvdMm/nmMnqpNc01WYfMYW8Cf/nQeeM7UYzVEe4g02mT/90BfJT8AE ow== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wuegj9v0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 06:49:32 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Dec
 2019 06:49:31 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 12 Dec 2019 06:49:31 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 547CE3F703F;
        Thu, 12 Dec 2019 06:49:31 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBCEnVCb000546;
        Thu, 12 Dec 2019 06:49:31 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBCEnUbm000545;
        Thu, 12 Dec 2019 06:49:30 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 1/1] qede: Fix multicast mac configuration
Date:   Thu, 12 Dec 2019 06:49:28 -0800
Message-ID: <20191212144928.509-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_03:2019-12-12,2019-12-12 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver doesn't accommodate the configuration for max number
of multicast mac addresses, in such particular case it leaves
the device with improper/invalid multicast configuration state,
causing connectivity issues (in lacp bonding like scenarios).

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 9a6a9a008714..c8bdbf057d5a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1230,7 +1230,7 @@ qede_configure_mcast_filtering(struct net_device *ndev,
 	netif_addr_lock_bh(ndev);
 
 	mc_count = netdev_mc_count(ndev);
-	if (mc_count < 64) {
+	if (mc_count <= 64) {
 		netdev_for_each_mc_addr(ha, ndev) {
 			ether_addr_copy(temp, ha->addr);
 			temp += ETH_ALEN;
-- 
2.18.1

