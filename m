Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C98F50FE2E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345347AbiDZNEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345226AbiDZNEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:04:35 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104D11DA7D;
        Tue, 26 Apr 2022 06:01:25 -0700 (PDT)
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KnhlW5VlwzGp36;
        Tue, 26 Apr 2022 20:58:47 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 21:01:23 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 26 Apr
 2022 21:01:22 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <anna@kernel.org>,
        <chuck.lever@oracle.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghai38@huawei.com>
Subject: [PATCH net] SUNRPC: Fix local socket leak in xs_local_setup_socket()
Date:   Tue, 26 Apr 2022 21:20:11 +0800
Message-ID: <20220426132011.25418-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the connection to a local endpoint in xs_local_setup_socket() fails,
fput() is missing in the error path, which will result in a socket leak.
It can be reproduced in simple script below.

while true
do
        systemctl stop rpcbind.service
        systemctl stop rpc-statd.service
        systemctl stop nfs-server.service

        systemctl restart rpcbind.service
        systemctl restart rpc-statd.service
        systemctl restart nfs-server.service
done

When executing the script, you can observe that the
"cat /proc/net/unix | wc -l" count keeps growing.

Add the missing fput(), and restore transport to old socket.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/sunrpc/xprtsock.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 0f39e08ee580..7219c545385e 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1819,6 +1819,9 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt,
 									xprt);
+	struct socket *trans_sock = NULL;
+	struct sock *trans_inet = NULL;
+	int ret;
 
 	if (!transport->inet) {
 		struct sock *sk = sock->sk;
@@ -1835,6 +1838,9 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 
 		xprt_clear_connected(xprt);
 
+		trans_sock = transport->sock;
+		trans_inet = transport->inet;
+
 		/* Reset to new socket */
 		transport->sock = sock;
 		transport->inet = sk;
@@ -1844,7 +1850,14 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 
 	xs_stream_start_connect(transport);
 
-	return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
+	ret = kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
+	/* Restore to old socket */
+	if (ret && trans_inet) {
+		transport->sock = trans_sock;
+		transport->inet = trans_inet;
+	}
+
+	return ret;
 }
 
 /**
@@ -1887,7 +1900,7 @@ static int xs_local_setup_socket(struct sock_xprt *transport)
 		xprt->stat.connect_time += (long)jiffies -
 					   xprt->stat.connect_start;
 		xprt_set_connected(xprt);
-		break;
+		goto out;
 	case -ENOBUFS:
 		break;
 	case -ENOENT:
@@ -1904,6 +1917,9 @@ static int xs_local_setup_socket(struct sock_xprt *transport)
 				xprt->address_strings[RPC_DISPLAY_ADDR]);
 	}
 
+	transport->file = NULL;
+	fput(filp);
+
 out:
 	xprt_clear_connecting(xprt);
 	xprt_wake_pending_tasks(xprt, status);
-- 
2.17.1

