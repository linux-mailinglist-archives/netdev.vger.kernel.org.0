Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0945622B988
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGWWcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgGWWcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:32:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11722C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:32:08 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b9so3333420plx.6
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ITH754qZqbedNV4/wZ4mpLi4ARIbviJuSmpRyy39b2w=;
        b=VuKSl1qaJel4kQuNy0YokRuv2mT0TdkJfzaaFhTx8aV895ht3EYWWi0AHAn+J6O5sD
         HYRs90I5kM9lbfN+JNHk+EBmHOjH0dULW1O4RKJyKcbaUuZ5KcJafaykG/9ugkiLFH2q
         pOho8KIOnd9vgQQbInbTWoy27vF6gfSrVoxUsrUpEOgG3cAXDENUxX1ETQb5yPreCfL/
         /L8kyJ+trQ04HQ5Bh1/mDqYg1ME3bx/R5NJVHaRqwE2ZZ6oVhyldJNtW+cBPYNdBCKpJ
         u9bEoOaP6UXP/YtZXHkuXEIVwnb0YmhEiykxUkZB/dkG+0Zv2fkkhjJxLn1G8Lvzy8Nt
         9fSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ITH754qZqbedNV4/wZ4mpLi4ARIbviJuSmpRyy39b2w=;
        b=A21MfEkf9Fj4GWEQuHkmiMzup3Xjr6j4SmVa0hZkXgwLp550g0GyrdpqncEV0QsRAf
         n0Z0ttp51PXGNECcaC3YzoJ2GJbqxJX2MhQA0eTRP43+FZseWEXzif+QD2N6aYk8qqIL
         oNF7z4nCmLvsVHitTQLfE5oEZ//W3NIMKEgLIpdn51ZXvCQHvauqYZIFXKwnKAkwLQb7
         Y8GUL+b4w8nuWEjs4DP7fsFSlN39dU6rLVbZRKypn6ty1uW6EpZtkIYkftTUJn/REFQp
         lp2xgXWsQs3cL24UJsrMxHfj+psT64lcoUpKL23CASQ11/buGmSAfdakl5a8beyG3NwV
         u73A==
X-Gm-Message-State: AOAM533Dx8iboMZO60I3pFUyP+y6WnpvNSfF+jykxeiadswugNW5DapE
        smoPNvQUQjBjIlB6oQhAa+X2ylM7
X-Google-Smtp-Source: ABdhPJwlJS7LwXXIMvthX5QV/3fif3ogscJlNKmY8ZWO9+8S9fXn7H/nhyA3/COcVdKXo02yOBTcSw==
X-Received: by 2002:a17:902:6b08:: with SMTP id o8mr5692773plk.104.1595543527478;
        Thu, 23 Jul 2020 15:32:07 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g19sm3972074pfb.152.2020.07.23.15.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 15:32:06 -0700 (PDT)
Subject: Re: PROBLEM: potential concurrency bug in rhashtable.h
To:     "Gong, Sishuai" <sishuai@purdue.edu>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sousa da Fonseca, Pedro Jose" <pfonseca@purdue.edu>
References: <5964B1AB-3A3D-482C-A13B-4528C015E1ED@purdue.edu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <22d7b981-c105-ebee-46e9-241797769e06@gmail.com>
Date:   Thu, 23 Jul 2020 15:32:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <5964B1AB-3A3D-482C-A13B-4528C015E1ED@purdue.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/20 1:14 PM, Gong, Sishuai wrote:
> Hi,
> 
> We found a concurrency bug in linux kernel 5.3.11. We were able to reproduce this bug in x86 when the kernel is compiled with non-standard GCC options and under specific thread interleavings. This bug causes a page fault that the kernel can’t handle due to an illegal memory access (“BUG: unable to handle page fault”). 
> 
> After some investigation, it seems the problem is caused by the use of the GCC extension for ternary operators (“Conditionals with Omitted Operands”) in the function __rht_ptr. 
> 
> The kernel seems to assume that the first operand is only evaluated once when the condition is true, but our experiments show that GCC actually evaluates twice the first operand causing two reads of the bkt variable (one to evaluate the condition and another to evaluate the implicit 2nd operand). Unfortunately under concurrency another thread can change the value of the variable in-between the two reads. 
> 
> In particular, if a) the condition evaluates to true during the first read, b) another thread changes the value that bkt is pointing to, which makes the condition false, c) the second (omitted) operand gets evaluated but is evaluated with a second read that returns a value inconsistent with the true condition.
> 
> Note that the GCC documentation mentions that the ternary operator with “Omitted Operands” should not cause side-effects to execute twice but there is no guarantee that non-volatile read memory operations are not executed twice, which we have also confirmed with GCC developers and you could find the information here. https://gcc.gnu.org/pipermail/gcc/2020-July/233018.html
>  
> ------------------------------------------ 
> Console output
> 
> [  109.796573] BUG: unable to handle page fault for address: ffffffe0
> [  110.250775] #PF: supervisor read access in kernel mode
> [  110.851490] #PF: error_code(0x0000) - not-present page
> [  111.575747] *pde = 02248067 *pte = 00000000
> [  112.170468] Oops: 0000 [#1] SMP
> [  113.137733] CPU: 1 PID: 1799 Comm: ski-executor Not tainted 5.3.11 #1
> [  113.936036] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  114.567487] EIP: memcmp+0x9/0x32
> [  115.636968] Code: 55 89 e5 57 56 8b 75 08 85 f6 74 11 bf 00 00 00 00 89 14 f8 89 4c f8 04 47 39 f7 75 f4 5e 5f 5d c3 55 89 e5 56 53 85 c9 74 22 <0f> b6 18 0f b6 32 29 f3 75 12 01 c1 40 42 39 c1 74 0a 0f b6 18 0f
> [  118.578949] EAX: ffffffe0 EBX: 00000000 ECX: 00000004 EDX: ce4b5f3c
> [  119.412369] ESI: c2076a9c EDI: ffffffe0 EBP: ce4b5f14 ESP: ce4b5f0c
> [  120.380135] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00000202
> [  121.241093] CR0: 80050033 CR2: ffffffe0 CR3: 0e272000 CR4: 00000690
> [  122.258051] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  123.705309] DR6: 00000000 DR7: 00000000
> [  124.875237] Call Trace:
> [  126.062462]  ipcget+0xfa/0x26c
> [  127.034312]  ksys_msgget+0x46/0x5d
> [  127.667337]  sys_msgget+0x13/0x15
> [  128.421597]  do_fast_syscall_32+0x99/0x285
> [  129.166383]  entry_SYSENTER_32+0x9f/0xf2
> [  130.204738] EIP: 0xb7fffaad
> [  130.823257] Code: 8b 5d 08 e8 19 00 00 00 89 d3 eb e5 8b 04 24 c3 8b 0c 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
> [  133.839387] EAX: ffffffda EBX: 798e2635 ECX: 00000000 EDX: 00000000
> [  134.921710] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: bffff81c
> [  136.039511] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
> [  137.326581] Modules linked in:
> [  138.350381] CR2: 00000000ffffffe0
> [  139.121664] ---[ end trace 5a43bf9a3ce51e57 ]---
> [  139.987631] EIP: memcmp+0x9/0x32
> [  140.203250] Code: 55 89 e5 57 56 8b 75 08 85 f6 74 11 bf 00 00 00 00 89 14 f8 89 4c f8 04 47 39 f7 75 f4 5e 5f 5d c3 55 89 e5 56 53 85 c9 74 22 <0f> b6 18 0f b6 32 29 f3 75 12 01 c1 40 42 39 c1 74 0a 0f b6 18 0f
> [  140.553281] EAX: ffffffe0 EBX: 00000000 ECX: 00000004 EDX: ce4b5f3c
> [  140.734438] ESI: c2076a9c EDI: ffffffe0 EBP: ce4b5f14 ESP: ce4b5f0c
> [  140.858536] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00000202
> [  140.959192] CR0: 80050033 CR2: ffffffe0 CR3: 0e272000 CR4: 00000690
> [  141.052654] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  141.177823] DR6: 00000000 DR7: 00000000
> 
> 
> ------------------------------------------ 
> Input and source code
> 
> This bug occurs when two syscalls, msget and msgctl, are invoked concurrently. Our analysis has located two lines of code, one of which will read a shared memory rhash_head __rcu object while the other writes to it. 
> 
> Writer:
> starting from include/linux/rhashtable.h:399
>     static inline void rht_assign_unlock(struct bucket_table *tbl,
>         struct rhash_lock_head **bkt,
>         struct rhash_head *obj)
>     {
>         struct rhash_head __rcu **p = (struct rhash_head __rcu **)bkt;
> 
>         if (rht_is_a_nulls(obj))
> --->       obj = NULL;
>         lock_map_release(&tbl->dep_map);
>         rcu_assign_pointer(*p, obj);
>         preempt_enable();
>         __release(bitlock);
>         local_bh_enable();
>     }
> 
> 
> Reader:
> starting at include/linux/rhashtable.h:352
>     static inline struct rhash_head rcu *rht_ptr(
>         struct rhash_lock_head const **bkt)
> {
>         return (struct rhash_head __rcu *)
>         ((unsigned long)*bkt & ~BIT(0) ?:
>         (unsigned long)RHT_NULLS_MARKER(bkt));
> }
> 
> return (struct rhash_head __rcu *)
> --->       ((unsigned long)*bkt & ~BIT(0) ?:
>         (unsigned long)RHT_NULLS_MARKER(bkt));
> 
> ------------------------------------------ 
> Thread interleaving
> 
> For presentation purposes, we convert the original code to explain the thread interleaving.
> 
> Original code:
> return (struct rhash_head __rcu *)
>        ((unsigned long)*bkt & ~BIT(0) ?:
>         (unsigned long)RHT_NULLS_MARKER(bkt));
> 
> Converted code:
> if ((unsigned long)*bkt & ~BIT(0)){
> return  (struct rhash_head __rcu *)(unsigned long)*bkt & ~BIT(0);
> }else{
> return  (struct rhash_head __rcu *)(unsigned long)RHT_NULLS_MARKER(bkt);
> }
> 
> Interleaving that triggers the bug:
> 
> CPU0 (msgctl) 			CPU1(msget)
> …
> if (rht_is_a_nulls(obj))
> 						…
> 						if ((unsigned long)*bkt & ~BIT(0)){
> 
> obj = NULL;
> 						return  (struct rhash_head __rcu *)(unsigned long)*bkt & ~BIT(0);
> 						…
> 						rhashtable_compare(…)
> 						…
> 						return memcmp(ptr + ht->p.key_offset, arg->key, ht->p.key_len);
> 						[from rhashtable_compare at include/linux/rhashtable.h: 584]
> 						[page fault]
> 
> ------------------------------------------ 
> Kernel configuration and compilation
> 
> We were only able to reproduce this bug when the kernel is compiled with “-O1 -fno-if-conversion -fno-if-conversion2 -fno-delayed-branch -fno-tree-fre -fno-tree-dominator-opts -fno-cprop-registers” instead of the default “-O2”. The compiler emits different instructions for the reader depending on the optimization level. In the buggy version, the writer has two read accesses to the bkt address but in the non-buggy version it only has one memory read operation.
> 
> It is unclear to us how this affects other architectures.
> 
> 
> static inline struct rhash_head __rcu *__rht_ptr(
>       struct rhash_lock_head *const *bkt)
>   {
>  return (struct rhash_head __rcu *)
>       c11a36d4:   8b 45 e4                mov    -0x1c(%ebp),%eax
>       c11a36d7:   83 c8 01                or     $0x1,%eax
>       c11a36da:   89 45 e0                mov    %eax,-0x20(%ebp)
>       c11a36dd:   89 75 d8                mov    %esi,-0x28(%ebp)
>       c11a36e0:   8b 45 e4                mov    -0x1c(%ebp),%eax
> ---> c11a36e3:   f7 00 fe ff ff ff       testl  $0xfffffffe,(%eax)
>       c11a36e9:   74 69                   je     c11a3754 <bpf_offload_find_netdev+0x107>
> ---> c11a36eb:   8b 00                   mov    (%eax),%eax
>       c11a36ed:   89 45 dc                mov    %eax,-0x24(%ebp)
>       c11a36f0:   83 e0 fe                and    $0xfffffffe,%eax
> 
> 
> static inline struct rhash_head __rcu *__rht_ptr(
>      struct rhash_lock_head *const *bkt)
>  {
>      return (struct rhash_head __rcu *)
>        c119b644:   8b 45 e4                mov    -0x1c(%ebp),%eax
>        c119b647:   83 c8 01                or     $0x1,%eax
>        c119b64a:   89 45 dc                mov    %eax,-0x24(%ebp)
>        c119b64d:   89 75 d8                mov    %esi,-0x28(%ebp)
>          ((unsigned long)*bkt & ~BIT(0) ?:
>        c119b650:   8b 45 e4                mov    -0x1c(%ebp),%eax
>   ---> c119b653:   8b 00                   mov    (%eax),%eax
>         c119b655:   89 45 e0                mov    %eax,-0x20(%ebp)
>       return (struct rhash_head __rcu *)
>        c119b658:   83 e0 fe                and    $0xfffffffe,%eax
>        c119b65b:   75 03                   jne    c119b660 <bpf_offload_find_netdev+0xa3>
>        c119b65d:   8b 45 dc                mov    -0x24(%ebp),%eax
> 
> 
> Thanks,
> Sishuai
> 

Thanks for the report/analysis. 

READ_ONCE() should help here, can you test/submit an official patch ?

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index d3432ee65de7684dbfb3cd6f04e207335db7f3bf..f9f88d67c8f7293b3aa9fdece5e70e51fa4859b5 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -353,7 +353,7 @@ static inline struct rhash_head __rcu *__rht_ptr(
        struct rhash_lock_head *const *bkt)
 {
        return (struct rhash_head __rcu *)
-               ((unsigned long)*bkt & ~BIT(0) ?:
+               ((unsigned long)READ_ONCE(*bkt) & ~BIT(0) ?:
                 (unsigned long)RHT_NULLS_MARKER(bkt));
 }
 

