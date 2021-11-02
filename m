Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0073442E8C
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhKBM64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:58:56 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:27098 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhKBM6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:58:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hk8wx56Swz1DJ42;
        Tue,  2 Nov 2021 20:54:09 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 20:56:13 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 2 Nov
 2021 20:56:12 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <ap420073@gmail.com>
Subject: [PATCH net-next] amt: fix error return code in amt_init()
Date:   Tue, 2 Nov 2021 21:03:53 +0800
Message-ID: <20211102130353.1666999-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return error code when alloc_workqueue()
fails in amt_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/amt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 60a7053a9cf7..d8c9ed9f8a81 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3259,8 +3259,10 @@ static int __init amt_init(void)
 		goto unregister_notifier;
 
 	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 1);
-	if (!amt_wq)
+	if (!amt_wq) {
+		err = -ENOMEM;
 		goto rtnl_unregister;
+	}
 
 	spin_lock_init(&source_gc_lock);
 	spin_lock_bh(&source_gc_lock);
-- 
2.25.1

