Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C8A4DE53C
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 03:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbiCSC6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 22:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiCSC6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 22:58:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629392A4F80;
        Fri, 18 Mar 2022 19:57:01 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KL58y07J3zfYlq;
        Sat, 19 Mar 2022 10:55:30 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 10:56:59 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 1/2] net/tls: remove unnecessary jump instructions in do_tls_setsockopt_conf()
Date:   Sat, 19 Mar 2022 11:14:33 +0800
Message-ID: <8a10937af81c14a942a99f1e683e2f42cf6ceee3.1647658604.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647658604.git.william.xuanziyang@huawei.com>
References: <cover.1647658604.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid using "goto" jump instruction unconditionally when we
can return directly. Remove unnecessary jump instructions in
do_tls_setsockopt_conf().

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/tls/tls_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 6bc2879ba637..7b2b0e7ffee4 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -553,10 +553,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	int rc = 0;
 	int conf;
 
-	if (sockptr_is_null(optval) || (optlen < sizeof(*crypto_info))) {
-		rc = -EINVAL;
-		goto out;
-	}
+	if (sockptr_is_null(optval) || (optlen < sizeof(*crypto_info)))
+		return -EINVAL;
 
 	if (tx) {
 		crypto_info = &ctx->crypto_send.info;
@@ -567,10 +565,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	}
 
 	/* Currently we don't support set crypto info more than one time */
-	if (TLS_CRYPTO_INFO_READY(crypto_info)) {
-		rc = -EBUSY;
-		goto out;
-	}
+	if (TLS_CRYPTO_INFO_READY(crypto_info))
+		return -EBUSY;
 
 	rc = copy_from_sockptr(crypto_info, optval, sizeof(*crypto_info));
 	if (rc) {
@@ -672,11 +668,10 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 		ctx->sk_write_space = sk->sk_write_space;
 		sk->sk_write_space = tls_write_space;
 	}
-	goto out;
+	return 0;
 
 err_crypto_info:
 	memzero_explicit(crypto_info, sizeof(union tls_crypto_context));
-out:
 	return rc;
 }
 
-- 
2.25.1

