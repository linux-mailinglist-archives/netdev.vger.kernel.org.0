Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B10861E820
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 02:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiKGBHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 20:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiKGBHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 20:07:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33A5B87E;
        Sun,  6 Nov 2022 17:07:42 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5Cfp5x9QzpVsn;
        Mon,  7 Nov 2022 09:04:02 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 09:07:40 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ms@dev.tdt.de>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <xie.he.0141@gmail.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] net: lapbether: fix issue of invalid opcode in lapbeth_open()
Date:   Mon, 7 Nov 2022 09:14:45 +0800
Message-ID: <20221107011445.207372-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If lapb_register() failed when lapb device goes to up for the first time,
the NAPI is not disabled. As a result, the invalid opcode issue is
reported when the lapb device goes to up for the second time.

The stack info is as follows:
[ 1958.311422][T11356] kernel BUG at net/core/dev.c:6442!
[ 1958.312206][T11356] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[ 1958.315979][T11356] RIP: 0010:napi_enable+0x16a/0x1f0
[ 1958.332310][T11356] Call Trace:
[ 1958.332817][T11356]  <TASK>
[ 1958.336135][T11356]  lapbeth_open+0x18/0x90
[ 1958.337446][T11356]  __dev_open+0x258/0x490
[ 1958.341672][T11356]  __dev_change_flags+0x4d4/0x6a0
[ 1958.345325][T11356]  dev_change_flags+0x93/0x160
[ 1958.346027][T11356]  devinet_ioctl+0x1276/0x1bf0
[ 1958.346738][T11356]  inet_ioctl+0x1c8/0x2d0
[ 1958.349638][T11356]  sock_ioctl+0x5d1/0x750
[ 1958.356059][T11356]  __x64_sys_ioctl+0x3ec/0x1790
[ 1958.365594][T11356]  do_syscall_64+0x35/0x80
[ 1958.366239][T11356]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1958.377381][T11356]  </TASK>

Fixes: 514e1150da9c ("net: x25: Queue received packets in the drivers instead of per-CPU queues")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/wan/lapbether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 960f1393595c..c485b371e844 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -325,6 +325,7 @@ static int lapbeth_open(struct net_device *dev)
 
 	err = lapb_register(dev, &lapbeth_callbacks);
 	if (err != LAPB_OK) {
+		napi_disable(&lapbeth->napi);
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
 	}
-- 
2.17.1

