Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD1550F2F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 06:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiFTESB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 00:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiFTESA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 00:18:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C52F39;
        Sun, 19 Jun 2022 21:17:57 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LRGXl29LLz1K9Sh;
        Mon, 20 Jun 2022 12:15:51 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 20 Jun 2022 12:17:54 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <kuba@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net/tls: fix tls_sk_proto_close executed repeatedly
Date:   Mon, 20 Jun 2022 12:35:08 +0800
Message-ID: <20220620043508.3455616-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After setting the sock ktls, update ctx->sk_proto to sock->sk_prot by
tls_update(), so now ctx->sk_proto->close is tls_sk_proto_close(). When
close the sock, tls_sk_proto_close() is called for sock->sk_prot->close
is tls_sk_proto_close(). But ctx->sk_proto->close() will be executed later
in tls_sk_proto_close(). Thus tls_sk_proto_close() executed repeatedly
occurred. That will trigger the following bug.

=================================================================
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
RIP: 0010:tls_sk_proto_close+0xd8/0xaf0 net/tls/tls_main.c:306
Call Trace:
 <TASK>
 tls_sk_proto_close+0x356/0xaf0 net/tls/tls_main.c:329
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365

Updating a proto which is same with sock->sk_prot is incorrect. Add proto
and sock->sk_prot equality check at the head of tls_update() to fix it.

Fixes: 95fa145479fb ("bpf: sockmap/tls, close can race with map free")
Reported-by: syzbot+29c3c12f3214b85ad081@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/tls/tls_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index da176411c1b5..46bd5f26338b 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -921,6 +921,9 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
+	if (sk->sk_prot == p)
+		return;
+
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
-- 
2.25.1

