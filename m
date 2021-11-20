Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FD2457C60
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 08:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhKTIAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 03:00:05 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26343 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhKTH7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 02:59:52 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hx5Mp59jnzbhvB;
        Sat, 20 Nov 2021 15:51:50 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 20 Nov 2021 15:56:47 +0800
Received: from pekphispre01995.huawei.com (7.218.2.67) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 20 Nov 2021 15:56:46 +0800
From:   Daxing Guo <guodaxing@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <chenzhe@huawei.com>, <linux-s390@vger.kernel.org>,
        <greg@kroah.com>, "Guo DaXing" <guodaxing@huawei.com>
Subject: [PATCH] net/smc: loop in smc_listen
Date:   Sat, 20 Nov 2021 15:54:51 +0800
Message-ID: <20211120075451.16764-1-guodaxing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [7.218.2.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guo DaXing <guodaxing@huawei.com>

The kernel_listen function in smc_listen will fail when all the available
ports are occupied.  At this point smc->clcsock->sk->sk_data_ready has 
been changed to smc_clcsock_data_ready.  When we call smc_listen again, 
now both smc->clcsock->sk->sk_data_ready and smc->clcsk_data_ready point 
to the smc_clcsock_data_ready function.

The smc_clcsock_data_ready() function calls lsmc->clcsk_data_ready which 
now points to itself resulting in an infinite loop.

This patch restores smc->clcsock->sk->sk_data_ready with the old value.

Signed-off-by: Guo DaXing <guodaxing@huawei.com>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 59284da9116d..078f5edf6d4d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2120,8 +2120,10 @@ static int smc_listen(struct socket *sock, int backlog)
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	rc = kernel_listen(smc->clcsock, backlog);
-	if (rc)
+	if (rc) {
+		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
 		goto out;
+	}
 	sk->sk_max_ack_backlog = backlog;
 	sk->sk_ack_backlog = 0;
 	sk->sk_state = SMC_LISTEN;
-- 
2.20.1

