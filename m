Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDAA6256E8
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiKKJcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiKKJcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:32:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59666473;
        Fri, 11 Nov 2022 01:32:43 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7tgb4gD1zbnbs;
        Fri, 11 Nov 2022 17:28:59 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 17:32:41 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <paul@paul-moore.com>, <jmorris@namei.org>, <serge@hallyn.com>,
        <martin.lau@kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH] net: fix memory leak in security_sk_alloc()
Date:   Fri, 11 Nov 2022 17:52:51 +0800
Message-ID: <1668160371-39153-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak reports this issue:

unreferenced object 0xffff88810b7835c0 (size 32):
  comm "test_progs", pid 270, jiffies 4294969007 (age 1621.315s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000376cdeab>] kmalloc_trace+0x27/0x110
    [<000000003bcdb3b6>] selinux_sk_alloc_security+0x66/0x110
    [<000000003959008f>] security_sk_alloc+0x47/0x80
    [<00000000e7bc6668>] sk_prot_alloc+0xbd/0x1a0
    [<0000000002d6343a>] sk_alloc+0x3b/0x940
    [<000000009812a46d>] unix_create1+0x8f/0x3d0
    [<000000005ed0976b>] unix_create+0xa1/0x150
    [<0000000086a1d27f>] __sock_create+0x233/0x4a0
    [<00000000cffe3a73>] __sys_socket_create.part.0+0xaa/0x110
    [<0000000007c63f20>] __sys_socket+0x49/0xf0
    [<00000000b08753c8>] __x64_sys_socket+0x42/0x50
    [<00000000b56e26b3>] do_syscall_64+0x3b/0x90
    [<000000009b4871b8>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The issue occurs in the following scenarios:

unix_create1()
  sk_alloc()
    sk_prot_alloc()
      security_sk_alloc()
        call_int_hook()
          hlist_for_each_entry()
            entry1->hook.sk_alloc_security
            <-- selinux_sk_alloc_security() succeeded,
            <-- sk->security alloced here.
            entry2->hook.sk_alloc_security
            <-- bpf_lsm_sk_alloc_security() failed
      goto out_free;
        ...    <-- the sk->security not freed, memleak

To fix, if security_sk_alloc() failed and sk->security not null,
goto out_free_sec to reclaim resources.

I'm not sure whether this fix makes sense, but if hook lists don't
support this usage, might need to modify the
"tools/testing/selftests/bpf/progs/lsm_cgroup.c" test case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Cc: Stanislav Fomichev <sdf@google.com>
---
 net/core/sock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index a3ba035..e457a9d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2030,8 +2030,11 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 		sk = kmalloc(prot->obj_size, priority);
 
 	if (sk != NULL) {
-		if (security_sk_alloc(sk, family, priority))
+		if (security_sk_alloc(sk, family, priority)) {
+			if (sk->sk_security)
+				goto out_free_sec;
 			goto out_free;
+		}
 
 		if (!try_module_get(prot->owner))
 			goto out_free_sec;
-- 
1.8.3.1

