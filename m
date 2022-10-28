Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88B2610BF5
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJ1ING (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ1INE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:13:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4B718DD78;
        Fri, 28 Oct 2022 01:13:00 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MzFb54yzbzFq4p;
        Fri, 28 Oct 2022 16:10:09 +0800 (CST)
Received: from [10.174.178.197] (10.174.178.197) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 16:12:57 +0800
Message-ID: <41fa7ae0-d09a-659b-82ea-28036c02beee@huawei.com>
Date:   Fri, 28 Oct 2022 16:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH -next] selftests/bpf: fix alignment problem in
 bpf_prog_test_run_skb()
From:   zhongbaisong <zhongbaisong@huawei.com>
To:     <elver@google.com>, <glider@google.com>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <wangkefeng.wang@huawei.com>,
        <linux-kernel@vger.kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <mark.rutland@arm.com>, <dvyukov@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kasan-dev@googlegroups.com>, Linux MM <linux-mm@kvack.org>
References: <a3552059-89d4-1866-a141-6de9454f8116@huawei.com>
Organization: huawei
In-Reply-To: <a3552059-89d4-1866-a141-6de9454f8116@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.197]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, Pls drop this.

On 2022/10/28 15:01, zhongbaisong wrote:
> We observed a crash "KFENCE: use-after-free in __skb_clone" during fuzzing.
> It's a frequent occurrance in aarch64 and the codepath is always the 
> same,but cannot be reproduced in x86_64.
> The config and reproducer are in the attachement.
> Detailed crash information is as follows.
> 
> -----------------------------------------
>   BUG: KFENCE: use-after-free read in __skb_clone+0x214/0x280
> 
>   Use-after-free read at 0xffff00022250306f (in kfence-#250):
>    __skb_clone+0x214/0x280
>    skb_clone+0xb4/0x180
>    bpf_clone_redirect+0x60/0x190
>    bpf_prog_207b739f41707f89+0x88/0xb8
>    bpf_test_run+0x2dc/0x4fc
>    bpf_prog_test_run_skb+0x4ac/0x7d0
>    __sys_bpf+0x700/0x1020
>    __arm64_sys_bpf+0x4c/0x60
>    invoke_syscall+0x64/0x190
>    el0_svc_common.constprop.0+0x88/0x200
>    do_el0_svc+0x3c/0x50
>    el0_svc+0x68/0xd0
>    el0t_64_sync_handler+0xb4/0x130
>    el0t_64_sync+0x16c/0x170
> 
>   kfence-#250: 0xffff000222503000-0xffff00022250318e, size=399, 
> cache=kmalloc-512
> 
>   allocated by task 2970 on cpu 0 at 65.981345s:
>    bpf_test_init.isra.0+0x68/0x100
>    bpf_prog_test_run_skb+0x114/0x7d0
>    __sys_bpf+0x700/0x1020
>    __arm64_sys_bpf+0x4c/0x60
>    invoke_syscall+0x64/0x190
>    el0_svc_common.constprop.0+0x88/0x200
>    do_el0_svc+0x3c/0x50
>    el0_svc+0x68/0xd0
>    el0t_64_sync_handler+0xb4/0x130
>    el0t_64_sync+0x16c/0x170
> 
>   CPU: 0 PID: 2970 Comm: syz Tainted: G    B   W 6.1.0-rc2-next-20221025 
> #140
>   Hardware name: linux,dummy-virt (DT)
>   pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>   pc : __skb_clone+0x214/0x280
>   lr : __skb_clone+0x208/0x280
>   sp : ffff80000fc37630
>   x29: ffff80000fc37630 x28: ffff80000fc37bd0 x27: ffff80000fc37720
>   x26: ffff000222503000 x25: 000000000000028f x24: ffff0000d0898d5c
>   x23: ffff0000d08997c0 x22: ffff0000d089977e x21: ffff00022250304f
>   x20: ffff0000d0899700 x19: ffff0000d0898c80 x18: 0000000000000000
>   x17: ffff800008379bbc x16: ffff800008378ee0 x15: ffff800008379bbc
>   x14: ffff800008378ee0 x13: 0040004effff0008 x12: ffff6000444a060f
>   x11: 1fffe000444a060e x10: ffff6000444a060e x9 : dfff800000000000
>   x8 : ffff000222503072 x7 : 00009fffbbb5f9f3 x6 : 0000000000000002
>   x5 : ffff00022250306f x4 : ffff6000444a060f x3 : ffff8000096fb2a8
>   x2 : 0000000000000001 x1 : ffff00022250306f x0 : 0000000000000001
>   Call trace:
>    __skb_clone+0x214/0x280
>    skb_clone+0xb4/0x180
>    bpf_clone_redirect+0x60/0x190
>    bpf_prog_207b739f41707f89+0x88/0xb8
>    bpf_test_run+0x2dc/0x4fc
>    bpf_prog_test_run_skb+0x4ac/0x7d0
>    __sys_bpf+0x700/0x1020
>    __arm64_sys_bpf+0x4c/0x60
>    invoke_syscall+0x64/0x190
>    el0_svc_common.constprop.0+0x88/0x200
>    do_el0_svc+0x3c/0x50
>    el0_svc+0x68/0xd0
>    el0t_64_sync_handler+0xb4/0x130
>    el0t_64_sync+0x16c/0x170
> 
> 
>  From the crash info, I found the problem happend at 
> atomic_inc(&(skb_shinfo(skb)->dataref)) in __skb_clone().
> 
>      static struct sk_buff *__skb_clone(struct sk_buff *n, struct 
> sk_buff *skb)
>      {
>          ...
>          refcount_set(&n->users, 1);
> 
>  >       atomic_inc(&(skb_shinfo(skb)->dataref));
>          skb->cloned = 1;
> 
>          return n;
>      #undef C
>      }
> 
> 
> when KENCE UAF happend, the address of skb_shinfo(skb) always end with 
> 0xf，like
> 0xffff0002224f104f, 0xffff0002224f304f, etc.
> 
> But when KFENCE is not working, the address of skb_shinfo(skb) always 
> end with 0xc0, like
> 0xffff0000d7e908c0, 0xffff0000d682f4c0, ect.
> 
> So, I guess the problem is related to kfence memory address alignment in 
> aarch64.
> In bpf_prog_test_run_skb(), I try to let the 'size' align with 
> SMP_CACHE_BYTES to fix that.
> 
> After that, the KENCE user-after-free disappeared.
> 
> Fixes: be3d72a2896c ("bpf: move user_size out of bpf_test_init")
> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> ---
>   net/bpf/test_run.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..3414aa2930d4 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -1096,6 +1096,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, 
> const union bpf_attr *kattr,
>      if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
>          return -EINVAL;
> 
> +   size = SKB_DATA_ALIGN(size);
> +
>      data = bpf_test_init(kattr, kattr->test.data_size_in,
>                   size, NET_SKB_PAD + NET_IP_ALIGN,
>                   SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
> -- 
> 2.25.1
> 
> .
> 
> 
> 
