Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408CAB683E
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbfIRQfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:35:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57564 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbfIRQfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 12:35:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGNYVA178534;
        Wed, 18 Sep 2019 16:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=NjiZCOg5xFo4Z5niVDbJDHIcUX3lm7EmZSt0FVk2UN4=;
 b=TLSqxsCQV4cK9e8hGbsLr0Nt1u+CPKN0Murs67RcrbtobtmvuF7K/rAkUW0YlFILD+91
 OJbBQlQKJ4eNb2gT7wKVr9qpkXqob/XEG0V2eWbwEssn81r2Epjyn8W7F7EmggwO/UlA
 87Q+h4eDFV8/3Cax0pphixSF99s0gQQm6pAKZ3GKBysFj8n9SOu9zpNSMxLN/8bKdKWv
 OQbJi8EbiS2cm/Ky6WZIlNhB9D6nG3HJBEvY/ESz5xH65iqFSE9+lvL54adC/fJasIPF
 ecJ2/jdg3M1UZGDeQD/dSO6QaFueYj2NbZHHatHvlqSkm97kfmcQroZa0MVXN4Hb6DuG uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v385e54nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:35:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGNLQr048332;
        Wed, 18 Sep 2019 16:35:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v37masp0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:35:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IGZK6D012500;
        Wed, 18 Sep 2019 16:35:20 GMT
Received: from x250.idc.oracle.com (/10.191.241.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 09:35:14 -0700
From:   Allen Pais <allen.pais@oracle.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kvalo@codeaurora.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] libertas: fix a potential NULL pointer dereference
Date:   Wed, 18 Sep 2019 22:05:00 +0530
Message-Id: <1568824500-4243-1-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

alloc_workqueue is not checked for errors and as a result,
a potential NULL dereference could occur.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
---
 drivers/net/wireless/marvell/libertas/if_sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index 242d884..30f1025 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -1179,6 +1179,10 @@ static int if_sdio_probe(struct sdio_func *func,
 
 	spin_lock_init(&card->lock);
 	card->workqueue = alloc_workqueue("libertas_sdio", WQ_MEM_RECLAIM, 0);
+	if (unlikely(!card->workqueue)) {
+		ret = -ENOMEM;
+		goto err_queue;
+	}
 	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
 	init_waitqueue_head(&card->pwron_waitq);
 
@@ -1230,6 +1234,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	lbs_remove_card(priv);
 free:
 	destroy_workqueue(card->workqueue);
+err_queue:
 	while (card->packets) {
 		packet = card->packets;
 		card->packets = card->packets->next;
-- 
1.9.1

