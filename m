Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011382E76D7
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 08:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgL3HYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 02:24:09 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:52088 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbgL3HYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 02:24:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UKCfcPy_1609312996;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UKCfcPy_1609312996)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 30 Dec 2020 15:23:25 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com,
        sukadev@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] ibmvnic: fix: NULL pointer dereference.
Date:   Wed, 30 Dec 2020 15:23:14 +0800
Message-Id: <1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error is due to dereference a null pointer in function
reset_one_sub_crq_queue():

if (!scrq) {
    netdev_dbg(adapter->netdev,
               "Invalid scrq reset. irq (%d) or msgs(%p).\n",
		scrq->irq, scrq->msgs);
		return -EINVAL;
}

If the expression is true, scrq must be a null pointer and cannot
dereference.

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f302504..d7472be 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2981,9 +2981,7 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
 	int rc;
 
 	if (!scrq) {
-		netdev_dbg(adapter->netdev,
-			   "Invalid scrq reset. irq (%d) or msgs (%p).\n",
-			   scrq->irq, scrq->msgs);
+		netdev_dbg(adapter->netdev, "Invalid scrq reset.\n");
 		return -EINVAL;
 	}
 
-- 
1.8.3.1

