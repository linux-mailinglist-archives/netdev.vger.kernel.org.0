Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88D660082C
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiJQHzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiJQHzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:55:40 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808A35B05C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:55:39 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MrTh04WrPz1P76G;
        Mon, 17 Oct 2022 15:50:56 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 15:55:31 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed
Date:   Mon, 17 Oct 2022 16:03:31 +0800
Message-ID: <20221017080331.16878-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the initialization fails in calling addrconf_init_net(), devconf_all is
the pointer that has been released. Then ip6mr_sk_done() is called to
release the net, accessing devconf->mc_forwarding directly causes invalid
pointer access.

The process is as follows:
setup_net()
	ops_init()
		addrconf_init_net()
		all = kmemdup(...)           ---> alloc "all"
		...
		net->ipv6.devconf_all = all;
		__addrconf_sysctl_register() ---> failed
		...
		kfree(all);                  ---> ipv6.devconf_all invalid
		...
	ops_exit_list()
		...
		ip6mr_sk_done()
			devconf = net->ipv6.devconf_all;
			//devconf is invalid pointer
			if (!devconf || !atomic_read(&devconf->mc_forwarding))

The following is the Call Trace information:
BUG: KASAN: use-after-free in ip6mr_sk_done+0x112/0x3a0
Read of size 4 at addr ffff888075508e88 by task ip/14554
Call Trace:
<TASK>
dump_stack_lvl+0x8e/0xd1
print_report+0x155/0x454
kasan_report+0xba/0x1f0
kasan_check_range+0x35/0x1b0
ip6mr_sk_done+0x112/0x3a0
rawv6_close+0x48/0x70
inet_release+0x109/0x230
inet6_release+0x4c/0x70
sock_release+0x87/0x1b0
igmp6_net_exit+0x6b/0x170
ops_exit_list+0xb0/0x170
setup_net+0x7ac/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f7963322547

</TASK>
Allocated by task 14554:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
__kasan_kmalloc+0xa1/0xb0
__kmalloc_node_track_caller+0x4a/0xb0
kmemdup+0x28/0x60
addrconf_init_net+0x1be/0x840
ops_init+0xa5/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 14554:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
kasan_save_free_info+0x2a/0x40
____kasan_slab_free+0x155/0x1b0
slab_free_freelist_hook+0x11b/0x220
__kmem_cache_free+0xa4/0x360
addrconf_init_net+0x623/0x840
ops_init+0xa5/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 7d9b1b578d67 ("ip6mr: fix use-after-free in ip6mr_sk_done()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 417834b7169d..9c3f5202a97b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7214,9 +7214,11 @@ static int __net_init addrconf_init_net(struct net *net)
 	__addrconf_sysctl_unregister(net, all, NETCONFA_IFINDEX_ALL);
 err_reg_all:
 	kfree(dflt);
+	net->ipv6.devconf_dflt = NULL;
 #endif
 err_alloc_dflt:
 	kfree(all);
+	net->ipv6.devconf_all = NULL;
 err_alloc_all:
 	kfree(net->ipv6.inet6_addr_lst);
 err_alloc_addr:
-- 
2.17.1

