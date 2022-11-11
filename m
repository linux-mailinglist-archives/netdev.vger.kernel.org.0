Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF72625872
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbiKKKdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbiKKKdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:33:52 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B7FBCB2;
        Fri, 11 Nov 2022 02:33:51 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N7w2t5PdNzJnc5;
        Fri, 11 Nov 2022 18:30:46 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 18:33:49 +0800
Message-ID: <540df107-a364-0182-91ca-3b0967ac436b@huawei.com>
Date:   Fri, 11 Nov 2022 18:33:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] net: fix memory leak in security_sk_alloc()
To:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <paul@paul-moore.com>, <jmorris@namei.org>, <serge@hallyn.com>,
        <martin.lau@kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>
References: <1668160371-39153-1-git-send-email-wangyufen@huawei.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <1668160371-39153-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/11 17:52, Wang Yufen 写道:
> kmemleak reports this issue:
>
> unreferenced object 0xffff88810b7835c0 (size 32):
>    comm "test_progs", pid 270, jiffies 4294969007 (age 1621.315s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000376cdeab>] kmalloc_trace+0x27/0x110
>      [<000000003bcdb3b6>] selinux_sk_alloc_security+0x66/0x110
>      [<000000003959008f>] security_sk_alloc+0x47/0x80
>      [<00000000e7bc6668>] sk_prot_alloc+0xbd/0x1a0
>      [<0000000002d6343a>] sk_alloc+0x3b/0x940
>      [<000000009812a46d>] unix_create1+0x8f/0x3d0
>      [<000000005ed0976b>] unix_create+0xa1/0x150
>      [<0000000086a1d27f>] __sock_create+0x233/0x4a0
>      [<00000000cffe3a73>] __sys_socket_create.part.0+0xaa/0x110
>      [<0000000007c63f20>] __sys_socket+0x49/0xf0
>      [<00000000b08753c8>] __x64_sys_socket+0x42/0x50
>      [<00000000b56e26b3>] do_syscall_64+0x3b/0x90
>      [<000000009b4871b8>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The issue occurs in the following scenarios:
>
> unix_create1()
>    sk_alloc()
>      sk_prot_alloc()
>        security_sk_alloc()
>          call_int_hook()
>            hlist_for_each_entry()
>              entry1->hook.sk_alloc_security
>              <-- selinux_sk_alloc_security() succeeded,
>              <-- sk->security alloced here.
>              entry2->hook.sk_alloc_security
>              <-- bpf_lsm_sk_alloc_security() failed
>        goto out_free;
>          ...    <-- the sk->security not freed, memleak
>
> To fix, if security_sk_alloc() failed and sk->security not null,
> goto out_free_sec to reclaim resources.
>
> I'm not sure whether this fix makes sense, but if hook lists don't
> support this usage, might need to modify the
> "tools/testing/selftests/bpf/progs/lsm_cgroup.c" test case.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

The Fixes tag is incorrect, change to
Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")

> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> ---
>   net/core/sock.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index a3ba035..e457a9d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2030,8 +2030,11 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
>   		sk = kmalloc(prot->obj_size, priority);
>   
>   	if (sk != NULL) {

sk->sk_security is not initialized, add "sk->sk_security = NULL;" here.

> -		if (security_sk_alloc(sk, family, priority))
> +		if (security_sk_alloc(sk, family, priority)) {
> +			if (sk->sk_security)
> +				goto out_free_sec;
>   			goto out_free;
> +		}
>   
>   		if (!try_module_get(prot->owner))
>   			goto out_free_sec;
