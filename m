Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C7560558B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJTCfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiJTCfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:35:08 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F2998364
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:34:58 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MtBS91ngjzpVYZ;
        Thu, 20 Oct 2022 10:31:37 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 10:34:21 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <shakeelb@google.com>, <roman.gushchin@linux.dev>,
        <hmukos@yandex-team.ru>, <memxor@gmail.com>,
        <vasily.averin@linux.dev>, <ebiederm@xmission.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed
Date:   Thu, 20 Oct 2022 10:42:13 +0800
Message-ID: <20221020024213.264324-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ops_init() interface is invoked to initialize the net, but
ops->init() fails, data is released. However, the ptr pointer in
net->gen is invalid. In this case, when nfqnl_nf_hook_drop() is invoked
to release the net, invalid address access occurs.

The process is as follows:
setup_net()
	ops_init()
		data = kzalloc(...)   ---> alloc "data"
		net_assign_generic()  ---> assign "date" to ptr in net->gen
		...
		ops->init()           ---> failed
		...
		kfree(data);          ---> ptr in net->gen is invalid
	...
	ops_exit_list()
		...
		nfqnl_nf_hook_drop()
			*q = nfnl_queue_pernet(net) ---> q is invalid

The following is the Call Trace information:
BUG: KASAN: use-after-free in nfqnl_nf_hook_drop+0x264/0x280
Read of size 8 at addr ffff88810396b240 by task ip/15855
Call Trace:
<TASK>
dump_stack_lvl+0x8e/0xd1
print_report+0x155/0x454
kasan_report+0xba/0x1f0
nfqnl_nf_hook_drop+0x264/0x280
nf_queue_nf_hook_drop+0x8b/0x1b0
__nf_unregister_net_hook+0x1ae/0x5a0
nf_unregister_net_hooks+0xde/0x130
ops_exit_list+0xb0/0x170
setup_net+0x7ac/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
</TASK>

Allocated by task 15855:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
__kasan_kmalloc+0xa1/0xb0
__kmalloc+0x49/0xb0
ops_init+0xe7/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 15855:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
kasan_save_free_info+0x2a/0x40
____kasan_slab_free+0x155/0x1b0
slab_free_freelist_hook+0x11b/0x220
__kmem_cache_free+0xa4/0x360
ops_init+0xb9/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: f875bae06533 ("net: Automatically allocate per namespace data.")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/core/net_namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 0ec2f5906a27..f64654df71a2 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -117,6 +117,7 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
 
 static int ops_init(const struct pernet_operations *ops, struct net *net)
 {
+	struct net_generic *ng;
 	int err = -ENOMEM;
 	void *data = NULL;
 
@@ -135,7 +136,13 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 	if (!err)
 		return 0;
 
+	if (ops->id && ops->size) {
 cleanup:
+		ng = rcu_dereference_protected(net->gen,
+					       lockdep_is_held(&pernet_ops_rwsem));
+		ng->ptr[*ops->id] = NULL;
+	}
+
 	kfree(data);
 
 out:
-- 
2.17.1

