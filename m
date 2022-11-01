Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759C161503C
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 18:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiKARMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiKARMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 13:12:40 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C217015FFC;
        Tue,  1 Nov 2022 10:12:39 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1opuNr-000GcT-0q; Tue, 01 Nov 2022 17:45:03 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1opuNq-000Osb-Ig; Tue, 01 Nov 2022 17:45:02 +0100
Subject: Re: [PATCH -next] bpf, test_run: fix alignment problem in
 bpf_prog_test_run_skb()
To:     Baisong Zhong <zhongbaisong@huawei.com>, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, song@kernel.org,
        yhs@fb.com, haoluo@google.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20221101040440.3637007-1-zhongbaisong@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eca17bfb-c75f-5db1-f194-5b00c2a0c6f2@iogearbox.net>
Date:   Tue, 1 Nov 2022 17:45:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20221101040440.3637007-1-zhongbaisong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26706/Tue Nov  1 08:52:34 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ +kfence folks ]

On 11/1/22 5:04 AM, Baisong Zhong wrote:
> Recently, we got a syzkaller problem because of aarch64
> alignment fault if KFENCE enabled.
> 
> When the size from user bpf program is an odd number, like
> 399, 407, etc, it will cause skb shard info's alignment access,
> as seen below:
> 
> BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
> 
> Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
>   __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
>   arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
>   arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inline]
>   atomic_inc include/asm-generic/atomic-instrumented.h:241 [inline]
>   __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
>   skb_clone+0xf4/0x214 net/core/skbuff.c:1481
>   ____bpf_clone_redirect net/core/filter.c:2433 [inline]
>   bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
>   bpf_prog_d3839dd9068ceb51+0x80/0x330
>   bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
>   bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
>   bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
>   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
>   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
>   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
> 
> kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=407, cache=kmalloc-512
> 
> allocated by task 15074 on cpu 0 at 1342.585390s:
>   kmalloc include/linux/slab.h:568 [inline]
>   kzalloc include/linux/slab.h:675 [inline]
>   bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
>   bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
>   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
>   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
>   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
>   __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381
> 
> To fix the problem, we round up allocations with kmalloc_size_roundup()
> so that build_skb()'s use of kize() is always alignment and no special
> handling of the memory is needed by KFENCE.
> 
> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> ---
>   net/bpf/test_run.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..058b67108873 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -774,6 +774,7 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
>   	if (user_size > size)
>   		return ERR_PTR(-EMSGSIZE);
>   
> +	size = kmalloc_size_roundup(size);
>   	data = kzalloc(size + headroom + tailroom, GFP_USER);

The fact that you need to do this roundup on call sites feels broken, no?
Was there some discussion / consensus that now all k*alloc() call sites
would need to be fixed up? Couldn't this be done transparently in k*alloc()
when KFENCE is enabled? I presume there may be lots of other such occasions
in the kernel where similar issue triggers, fixing up all call-sites feels
like ton of churn compared to api-internal, generic fix.

>   	if (!data)
>   		return ERR_PTR(-ENOMEM);
> 

Thanks,
Daniel
