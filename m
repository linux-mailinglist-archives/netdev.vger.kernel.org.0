Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DA85233A0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243064AbiEKNEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243038AbiEKNEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:04:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A4D235151;
        Wed, 11 May 2022 06:04:12 -0700 (PDT)
Received: from kwepemi100016.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kyw816KR5zhZ2W;
        Wed, 11 May 2022 21:03:29 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi100016.china.huawei.com (7.221.188.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 21:04:09 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 11 May
 2022 21:04:08 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <bfields@fieldses.org>,
        <anna@kernel.org>, <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghai38@huawei.com>
Subject: [PATCH 1/3] Revert "SUNRPC: Ensure gss-proxy connects on setup"
Date:   Wed, 11 May 2022 21:22:30 +0800
Message-ID: <20220511132232.4030-2-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220511132232.4030-1-wanghai38@huawei.com>
References: <20220511132232.4030-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 892de36fd4a98fab3298d417c051d9099af5448d.

In fact, gss-proxy can't respond to rpc_ping() at setup time.
After the timeout, rpc_ping() will return -EIO instead of -EOPNOTSUPP.
The reverted patch can't ensure that gssp connects to the service
at setup time.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 include/linux/sunrpc/clnt.h          | 1 -
 net/sunrpc/auth_gss/gss_rpc_upcall.c | 2 +-
 net/sunrpc/clnt.c                    | 3 ---
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index db5149567305..267b7aeaf1a6 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -160,7 +160,6 @@ struct rpc_add_xprt_test {
 #define RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT	(1UL << 9)
 #define RPC_CLNT_CREATE_SOFTERR		(1UL << 10)
 #define RPC_CLNT_CREATE_REUSEPORT	(1UL << 11)
-#define RPC_CLNT_CREATE_IGNORE_NULL_UNAVAIL (1UL << 12)
 
 struct rpc_clnt *rpc_create(struct rpc_create_args *args);
 struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index 8ca1d809b78d..61c276bddaf2 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -97,7 +97,7 @@ static int gssp_rpc_create(struct net *net, struct rpc_clnt **_clnt)
 		 * timeout, which would result in reconnections being
 		 * done without the correct namespace:
 		 */
-		.flags		= RPC_CLNT_CREATE_IGNORE_NULL_UNAVAIL |
+		.flags		= RPC_CLNT_CREATE_NOPING |
 				  RPC_CLNT_CREATE_NO_IDLE_TIMEOUT
 	};
 	struct rpc_clnt *clnt;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 22c28cf43eba..98133aa54f19 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -479,9 +479,6 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 
 	if (!(args->flags & RPC_CLNT_CREATE_NOPING)) {
 		int err = rpc_ping(clnt);
-		if ((args->flags & RPC_CLNT_CREATE_IGNORE_NULL_UNAVAIL) &&
-		    err == -EOPNOTSUPP)
-			err = 0;
 		if (err != 0) {
 			rpc_shutdown_client(clnt);
 			return ERR_PTR(err);
-- 
2.17.1

