Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6728D612F53
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 04:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJaDeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 23:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJaDeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 23:34:16 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9E89596;
        Sun, 30 Oct 2022 20:34:12 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N0zCW5BjvzmVYJ;
        Mon, 31 Oct 2022 11:29:11 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 11:34:11 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 11:34:10 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mailhol.vincent@wanadoo.fr>,
        <chenzhongjin@huawei.com>
Subject: [PATCH] can: canxl: Fix unremoved canxl_packet in can_exit()
Date:   Mon, 31 Oct 2022 11:30:53 +0800
Message-ID: <20221031033053.37849-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In can_init(), dev_add_pack(&canxl_packet) is added but not removed in
can_exit(). It break the packet handler list and can make kernel panic
when can_init() for the second time.

> modprobe can && rmmod can
> rmmod xxx && modprobe can

BUG: unable to handle page fault for address: fffffbfff807d7f4
RIP: 0010:dev_add_pack+0x133/0x1f0
Call Trace:
 <TASK>
 can_init+0xaa/0x1000 [can]
 do_one_initcall+0xd3/0x4e0
 ...

Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/can/af_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 9503ab10f9b8..5e9e3e1e9825 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -902,6 +902,7 @@ static __init int can_init(void)
 static __exit void can_exit(void)
 {
 	/* protocol unregister */
+	dev_remove_pack(&canxl_packet);
 	dev_remove_pack(&canfd_packet);
 	dev_remove_pack(&can_packet);
 	sock_unregister(PF_CAN);
-- 
2.17.1

