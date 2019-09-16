Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AF1B3C2F
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388429AbfIPOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:09:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47028 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbfIPOJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:09:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so48402pgm.13
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 07:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cbarcenas.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=shRp86mXwZSxMyud0A2qw0MshSftrXwzui1eJeGPCpY=;
        b=egVLO8BZNejRSYlOhc0LIv+SQfOPKsF26L2d9T93k8RMBqHcVdtDiBuUZnrXOjTJdr
         YTNrstFe9o/Zpzwcz8Fmxvb+/HL6uc7zjWJ9JTxrxl1LbH+pUIrcEcu/4xcIoBh4gmy6
         nbGrUu0zKiD197jC8BnloaZczb1yVjOI/OnCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=shRp86mXwZSxMyud0A2qw0MshSftrXwzui1eJeGPCpY=;
        b=dopduH2tr37Vw49XRJaIN7XlImdKdfpZaLwAQmagb6fpITA1hiVT3YH0Fd+81f2etk
         6Cc8XfVf3LwbHoMApuwVKdTaqzUUyj8YXRT7gMQ7pJbERPffNwyqHKiWaGHuyWdRELy0
         Zg1DZV3kmmtdgnyhaD4YsvKHfCM0f9kVNRyakZ0t0PpouQRRyYDwdN7SryuVHcqYrgJ0
         0/0R4CEDdrhqha0/s/DD2//0Dlfli7aRDxM1oxVT5H8Lc6QqSqIv/h1C72rptFa16OD+
         +XLn+1TV02Foc22CLgzrB3fXt9WLbJH8phE0Ru8MLEMDXNSBAKu1RMZBFpXvJ4MsFDEz
         4zZw==
X-Gm-Message-State: APjAAAVZVNKOO4RX8Zp2CpxnpM/vLLtI0vLiRr6r4mFX5D5kxWXpzsVM
        tnsFCDiatuqsztdjjQ01YfzPtnE5HF4=
X-Google-Smtp-Source: APXvYqyKY0RaHTui4d2qXZu3jgKwMV9DxyVeYkMEX3oqNX06Z0BklF6HFiB+mWhk/psb4DHXolIy5A==
X-Received: by 2002:a65:628f:: with SMTP id f15mr12627794pgv.215.1568642949069;
        Mon, 16 Sep 2019 07:09:09 -0700 (PDT)
Received: from [10.0.83.33] (c-24-5-92-100.hsd1.ca.comcast.net. [24.5.92.100])
        by smtp.gmail.com with ESMTPSA id f12sm1979226pfn.73.2019.09.16.07.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2019 07:09:08 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: respect CAP_IPC_LOCK in RLIMIT_MEMLOCK check
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org
References: <20190911181816.89874-1-christian@cbarcenas.com>
 <678ba696-4b20-5f06-7c4f-ec68a9229620@iogearbox.net>
From:   Christian Barcenas <christian@cbarcenas.com>
Message-ID: <4f8b455e-aa11-1552-c7f1-06ff63d86542@cbarcenas.com>
Date:   Mon, 16 Sep 2019 07:09:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <678ba696-4b20-5f06-7c4f-ec68a9229620@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 9/11/19 8:18 PM, Christian Barcenas wrote:
>> A process can lock memory addresses into physical RAM explicitly
>> (via mlock, mlockall, shmctl, etc.) or implicitly (via VFIO,
>> perf ring-buffers, bpf maps, etc.), subject to RLIMIT_MEMLOCK limits.
>>
>> CAP_IPC_LOCK allows a process to exceed these limits, and throughout
>> the kernel this capability is checked before allowing/denying an attempt
>> to lock memory regions into RAM.
>>
>> Because bpf locks its programs and maps into RAM, it should respect
>> CAP_IPC_LOCK. Previously, bpf would return EPERM when RLIMIT_MEMLOCK was
>> exceeded by a privileged process, which is contrary to documented
>> RLIMIT_MEMLOCK+CAP_IPC_LOCK behavior.
> 
> Do you have a link/pointer where this is /clearly/ documented?

I admit that after submitting this patch, I did re-think the description 
and thought maybe I should have described the CAP_IPC_LOCK behavior as 
"expected" rather than "documented". :)

> ... but my best guess is you are referring to `man 2 mlock`:
> 
>     Limits and permissions
> 
>         In Linux 2.6.8 and earlier, a process must be privileged 
> (CAP_IPC_LOCK)
>         in order to lock memory and the RLIMIT_MEMLOCK soft resource 
> limit defines
>         a limit on how much memory the process may lock.
> 
>         Since  Linux  2.6.9, no limits are placed on the amount of 
> memory that a
>         privileged process can lock and the RLIMIT_MEMLOCK soft resource 
> limit
>         instead defines a limit on how much memory an unprivileged 
> process may lock.

Yes; this is what I was referring to by "documented 
RLIMIT_MEMLOCK+CAP_IPC_LOCK behavior."

Unfortunately - AFAICT - this is the most explicit documentation about 
CAP_IPC_LOCK's permission set, but it is incomplete.

I believe it can be understood from other references to RLIMIT and 
CAP_IPC_LOCK throughout the kernel that "locking memory" refers not only 
to mlock/shmctl syscalls, but also to other code sites where /physical/ 
memory addresses are allocated for userspace.

After identifying RLIMIT_MEMLOCK checks with

     git grep -C3 '[^(get|set)]rlimit(RLIMIT_MEMLOCK'

we find that RLIMIT_MEMLOCK is bypassed - if CAP_IPC_LOCK is held - in 
many locations that have nothing to do with the mlock or shm family of 
syscalls. From what I can tell, every time RLIMIT_MEMLOCK is referenced 
there is a neighboring check to CAP_IPC_LOCK that bypasses the rlimit, 
or in some cases memory accounting entirely!

bpf() is currently the only exception to the above, ie. as far as I can 
tell it is the only code that enforces RLIMIT_MEMLOCK but does not honor 
CAP_IPC_LOCK.

Selected examples follow:

In net/core/skbuff.c:

     if (capable(CAP_IPC_LOCK) || !size)
             return 0;

     num_pg = (size >> PAGE_SHIFT) + 2;      /* worst case */
     max_pg = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
     user = mmp->user ? : current_user();

     do {
             old_pg = atomic_long_read(&user->locked_vm);
             new_pg = old_pg + num_pg;
             if (new_pg > max_pg)
                     return -ENOBUFS;
     } while (atomic_long_cmpxchg(&user->locked_vm, old_pg, new_pg) !=
              old_pg);

In net/xdp/xdp_umem.c:

     if (capable(CAP_IPC_LOCK))
             return 0;

     lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
     umem->user = get_uid(current_user());

     do {
             old_npgs = atomic_long_read(&umem->user->locked_vm);
             new_npgs = old_npgs + umem->npgs;
             if (new_npgs > lock_limit) {
                     free_uid(umem->user);
                     umem->user = NULL;
                     return -ENOBUFS;
             }
     } while (atomic_long_cmpxchg(&umem->user->locked_vm, old_npgs,
                                  new_npgs) != old_npgs);
     return 0;

In arch/x86/kvm/svm.c:

     lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
     if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
             pr_err("SEV: %lu locked pages exceed the lock limit of 
%lu.\n", locked, lock_limit);
             return NULL;
     }

In drivers/infiniband/core/umem.c (and other sites in Infiniband code):

     lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;

     new_pinned = atomic64_add_return(npages, &mm->pinned_vm);
     if (new_pinned > lock_limit && !capable(CAP_IPC_LOCK)) {
             atomic64_sub(npages, &mm->pinned_vm);
             ret = -ENOMEM;
             goto out;
     }

In drivers/vfio/vfio_iommu_type1.c, albeit in an indirect way:

     struct vfio_dma {
         bool                 lock_cap;       /* capable(CAP_IPC_LOCK) */
     };

     // ...

     for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
          pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
             // ...

             if (!rsvd && !vfio_find_vpfn(dma, iova)) {
                     if (!dma->lock_cap &&
                         current->mm->locked_vm + lock_acct + 1 > limit) {
                             put_pfn(pfn, dma->prot);
                             pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
                                     __func__, limit << PAGE_SHIFT);
                             ret = -ENOMEM;
                             goto unpin_out;
                     }
                     lock_acct++;
             }
     }

Best,
Christian
