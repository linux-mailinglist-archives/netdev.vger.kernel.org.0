Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D6661795C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKCJHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiKCJHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:07:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAC4D122;
        Thu,  3 Nov 2022 02:07:08 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N2yYy1DMqz15MKK;
        Thu,  3 Nov 2022 17:07:02 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 17:07:06 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 17:07:06 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lorenzo@google.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH net] net: ping6: Fix possible leaked pernet namespace in pingv6_init()
Date:   Thu, 3 Nov 2022 17:03:45 +0800
Message-ID: <20221103090345.187989-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IPv6 module initializing in pingv6_init(), inet6_register_protosw()
is possible to fail but returns without any error cleanup.

This leaves wild ops in namespace list and when another module tries to
add or delete pernet namespace it triggers page fault.
Although IPv6 cannot be unloaded now, this error should still be handled
to avoid kernel panic during IPv6 initialization.

BUG: unable to handle page fault for address: fffffbfff80bab69
CPU: 0 PID: 434 Comm: modprobe
RIP: 0010:unregister_pernet_operations+0xc9/0x450
Call Trace:
 <TASK>
 unregister_pernet_subsys+0x31/0x3e
 nf_tables_module_exit+0x44/0x6a [nf_tables]
 __do_sys_delete_module.constprop.0+0x34f/0x5b0
 ...

Fix it by adding error handling in pingv6_init(), and add a helper
function pingv6_ops_unset to avoid duplicate code.

Fixes: d862e5461423 ("net: ipv6: Implement /proc/net/icmp6.")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/ipv6/ping.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 86c26e48d065..5df688dd5208 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -277,10 +277,21 @@ static struct pernet_operations ping_v6_net_ops = {
 };
 #endif
 
+static void pingv6_ops_unset(void)
+{
+	pingv6_ops.ipv6_recv_error = dummy_ipv6_recv_error;
+	pingv6_ops.ip6_datagram_recv_common_ctl = dummy_ip6_datagram_recv_ctl;
+	pingv6_ops.ip6_datagram_recv_specific_ctl = dummy_ip6_datagram_recv_ctl;
+	pingv6_ops.icmpv6_err_convert = dummy_icmpv6_err_convert;
+	pingv6_ops.ipv6_icmp_error = dummy_ipv6_icmp_error;
+	pingv6_ops.ipv6_chk_addr = dummy_ipv6_chk_addr;
+}
+
 int __init pingv6_init(void)
 {
+	int ret;
 #ifdef CONFIG_PROC_FS
-	int ret = register_pernet_subsys(&ping_v6_net_ops);
+	ret = register_pernet_subsys(&ping_v6_net_ops);
 	if (ret)
 		return ret;
 #endif
@@ -291,7 +302,15 @@ int __init pingv6_init(void)
 	pingv6_ops.icmpv6_err_convert = icmpv6_err_convert;
 	pingv6_ops.ipv6_icmp_error = ipv6_icmp_error;
 	pingv6_ops.ipv6_chk_addr = ipv6_chk_addr;
-	return inet6_register_protosw(&pingv6_protosw);
+
+	ret = inet6_register_protosw(&pingv6_protosw);
+	if (ret) {
+		pingv6_ops_unset();
+#ifdef CONFIG_PROC_FS
+		unregister_pernet_subsys(&ping_v6_net_ops);
+#endif
+	}
+	return ret;
 }
 
 /* This never gets called because it's not possible to unload the ipv6 module,
@@ -299,12 +318,7 @@ int __init pingv6_init(void)
  */
 void pingv6_exit(void)
 {
-	pingv6_ops.ipv6_recv_error = dummy_ipv6_recv_error;
-	pingv6_ops.ip6_datagram_recv_common_ctl = dummy_ip6_datagram_recv_ctl;
-	pingv6_ops.ip6_datagram_recv_specific_ctl = dummy_ip6_datagram_recv_ctl;
-	pingv6_ops.icmpv6_err_convert = dummy_icmpv6_err_convert;
-	pingv6_ops.ipv6_icmp_error = dummy_ipv6_icmp_error;
-	pingv6_ops.ipv6_chk_addr = dummy_ipv6_chk_addr;
+	pingv6_ops_unset();
 #ifdef CONFIG_PROC_FS
 	unregister_pernet_subsys(&ping_v6_net_ops);
 #endif
-- 
2.17.1

