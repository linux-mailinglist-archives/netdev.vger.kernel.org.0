Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575315233A7
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbiEKNE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243058AbiEKNEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:04:16 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8878233A6A;
        Wed, 11 May 2022 06:04:13 -0700 (PDT)
Received: from kwepemi100014.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Kyw3H1n2DzCsbX;
        Wed, 11 May 2022 20:59:23 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi100014.china.huawei.com (7.221.188.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 21:04:10 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 11 May
 2022 21:04:09 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <bfields@fieldses.org>,
        <anna@kernel.org>, <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghai38@huawei.com>
Subject: [PATCH 3/3] SUNRPC: Fix local socket leak in xs_setup_local()
Date:   Wed, 11 May 2022 21:22:32 +0800
Message-ID: <20220511132232.4030-4-wanghai38@huawei.com>
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

Add mechanism in xs_setup_local() to safely tear xprt down and
solve the socket leak problem.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/sunrpc/xprtsock.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 25b8a8ead56b..7b9a62750571 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1264,6 +1264,18 @@ static void xs_xprt_free(struct rpc_xprt *xprt)
 	xprt_free(xprt);
 }
 
+/**
+ * xs_destroy_xprt - close xprt socket and destroy it.
+ */
+static void xs_destroy_xprt(struct work_struct *work)
+{
+	struct rpc_xprt *xprt =
+		container_of(work, struct rpc_xprt, task_cleanup);
+
+	xs_close(xprt);
+	xs_xprt_free(xprt);
+}
+
 /**
  * xs_destroy - prepare to shutdown a transport
  * @xprt: doomed transport
@@ -2891,7 +2903,9 @@ static struct rpc_xprt *xs_setup_local(struct xprt_create *args)
 		return xprt;
 	ret = ERR_PTR(-EINVAL);
 out_err:
-	xs_xprt_free(xprt);
+
+	INIT_WORK(&xprt->task_cleanup, xs_destroy_xprt);
+	schedule_work(&xprt->task_cleanup);
 	return ret;
 }
 
-- 
2.17.1

