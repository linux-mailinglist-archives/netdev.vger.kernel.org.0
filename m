Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEF761796A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiKCJKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKCJKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:10:31 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEEFE7A;
        Thu,  3 Nov 2022 02:10:31 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N2ydr1x4hzmVPM;
        Thu,  3 Nov 2022 17:10:24 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 17:10:29 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 17:10:29 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mkubecek@suse.cz>, <chenzhongjin@huawei.com>
Subject: [PATCH net] xfrm: Fix ignored return value in xfrm6_init()
Date:   Thu, 3 Nov 2022 17:07:13 +0800
Message-ID: <20221103090713.188740-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IPv6 module initializing in xfrm6_init(), register_pernet_subsys()
is possible to fail but its return value is ignored.

If IPv6 initialization fails later and xfrm6_fini() is called,
removing uninitialized list in xfrm6_net_ops will cause null-ptr-deref:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 330 Comm: insmod
RIP: 0010:unregister_pernet_operations+0xc9/0x450
Call Trace:
 <TASK>
 unregister_pernet_subsys+0x31/0x3e
 xfrm6_fini+0x16/0x30 [ipv6]
 ip6_route_init+0xcd/0x128 [ipv6]
 inet6_init+0x29c/0x602 [ipv6]
 ...

Fix it by catching the error return value of register_pernet_subsys().

Fixes: 8d068875caca ("xfrm: make gc_thresh configurable in all namespaces")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/ipv6/xfrm6_policy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 4a4b0e49ec92..ea435eba3053 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -287,9 +287,13 @@ int __init xfrm6_init(void)
 	if (ret)
 		goto out_state;
 
-	register_pernet_subsys(&xfrm6_net_ops);
+	ret = register_pernet_subsys(&xfrm6_net_ops);
+	if (ret)
+		goto out_protocol;
 out:
 	return ret;
+out_protocol:
+	xfrm6_protocol_fini();
 out_state:
 	xfrm6_state_fini();
 out_policy:
-- 
2.17.1

