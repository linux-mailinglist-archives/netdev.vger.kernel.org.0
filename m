Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDED26312D1
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 08:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiKTH2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 02:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKTH2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 02:28:47 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D941409F;
        Sat, 19 Nov 2022 23:28:44 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NFMZ63RWSzmVbw;
        Sun, 20 Nov 2022 15:28:14 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 15:28:41 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net] ipv4: Fix error return code in fib_table_insert()
Date:   Sun, 20 Nov 2022 15:28:38 +0800
Message-ID: <20221120072838.2167047-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fib_table_insert(), if the alias was already inserted, but node not
exist, the error code should be set before return from error handling path.

Fixes: a6c76c17df02 ("ipv4: Notify route after insertion to the routing table")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/ipv4/fib_trie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 452ff177e4da..f26d5ac117d6 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1381,8 +1381,10 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 
 	/* The alias was already inserted, so the node must exist. */
 	l = l ? l : fib_find_node(t, &tp, key);
-	if (WARN_ON_ONCE(!l))
+	if (WARN_ON_ONCE(!l)) {
+		err = -ENOENT;
 		goto out_free_new_fa;
+	}
 
 	if (fib_find_alias(&l->leaf, new_fa->fa_slen, 0, 0, tb->tb_id, true) ==
 	    new_fa) {
-- 
2.25.1

