Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CB2388FDA
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353851AbhESOIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:08:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3034 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353786AbhESOI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:08:28 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlZN8750XzQpB3;
        Wed, 19 May 2021 22:03:36 +0800 (CST)
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 22:07:07 +0800
Received: from localhost.localdomain (10.175.102.38) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 22:07:06 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: qrtr: ns: Fix error return code in qrtr_ns_init()
Date:   Wed, 19 May 2021 14:16:21 +0000
Message-ID: <20210519141621.3044684-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/qrtr/ns.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 8d00dfe8139e..1990d496fcfc 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -775,8 +775,10 @@ int qrtr_ns_init(void)
 	}
 
 	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
-	if (!qrtr_ns.workqueue)
+	if (!qrtr_ns.workqueue) {
+		ret = -ENOMEM;
 		goto err_sock;
+	}
 
 	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
 

