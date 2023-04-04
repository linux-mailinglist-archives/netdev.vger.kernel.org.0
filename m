Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BA56D564D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 03:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbjDDBxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 21:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjDDBxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 21:53:08 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2067312F;
        Mon,  3 Apr 2023 18:53:04 -0700 (PDT)
Received: from dggpeml500019.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Pr9kM4SF3zkXtj;
        Tue,  4 Apr 2023 09:52:27 +0800 (CST)
Received: from dggphispra29317.huawei.com (10.244.145.77) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 4 Apr 2023 09:53:02 +0800
From:   Chenyuan Mi <michenyuan@huawei.com>
To:     <isdn@linux-pingi.de>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michenyuan@huawei.com>
Subject: Re: [PATCH v2 net-next] bluetooth: unregister correct BTPROTO for CMTP
Date:   Tue, 4 Apr 2023 09:52:58 +0800
Message-ID: <20230404015258.1345774-1-michenyuan@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.145.77]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On error unregister BTPROTO_CMTP to match the registration earlier in 
the same code-path. Without this change BTPROTO_HIDP is incorrectly 
unregistered.

This bug does not appear to cause serious security problem.

The function 'bt_sock_unregister' takes its parameter as an index and 
NULLs the corresponding element of 'bt_proto' which is an array of 
pointers. When 'bt_proto' dereferences each element, it would check 
whether the element is empty or not. Therefore, the problem of null 
pointer deference does not occur.

Found by inspection.

Fixes: 8c8de589cedd ("Bluetooth: Added /proc/net/cmtp via bt_procfs_init()")
Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
---
 net/bluetooth/cmtp/sock.c | 2 +-
 1 files changed, 1 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index 96d49d9fae96..cf4370055ce2 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
 	err = bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
 	if (err < 0) {
 		BT_ERR("Failed to create CMTP proc file");
-		bt_sock_unregister(BTPROTO_HIDP);
+		bt_sock_unregister(BTPROTO_CMTP);
 		goto error;
 	}
 
-- 
2.25.1

