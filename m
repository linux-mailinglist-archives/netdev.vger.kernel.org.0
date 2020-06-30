Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EF120FC57
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgF3S4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgF3S4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:56:53 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CFFC061755;
        Tue, 30 Jun 2020 11:56:53 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id d27so16449896qtg.4;
        Tue, 30 Jun 2020 11:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sUF9Il/pSDyAZQVgl1Ud+wt1XwsXNcGx+wtvr8PJZjg=;
        b=nvigHTtKlNw4oZi7/n8smKEHlBfgqb+WZHJf39U5hjIGVcfM9OLcstboBbsJMc8oVH
         cU4PKnn4NdTbPvUIDdY2t7SnOAsIrrt2g/HUqoH1NiQmaQe7GH2wLGWVD63KoI/B9G1A
         FbLLxWPxdy+8LNqnofu+5fkxDqlRWnDzK+ziykwPvQQvC49K/3Mr/he40U9WTvrdBHrk
         XRRnM8H/1NWQ/PGzWhlCGYyxT1iCx9T0yhkUc3Q4d46ONbGB3oF7dmFV4W7QKU3XKV5R
         ihFF9pmalt0PLk1apP6w9vWBP/kW0BjVUt2+QsCp7vU59LCuMc8Iyl4zgLdX2uahPjT+
         2nQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUF9Il/pSDyAZQVgl1Ud+wt1XwsXNcGx+wtvr8PJZjg=;
        b=hb2lXpWSAKZLzdMwIEc/rKnBtLiwNb2tcnteEYI9S2ZVCitLENaGwpEZbLccNZzEyS
         Ve/DTnvrqLrZMPPM4KAtucVSvd1P9Mf1cNVZFDNC2O0ycojqUYgU3yr5yKyazSKH20YF
         aLFPsTB+gewb3OKG01itqvl/oxvuIdejMmDfQzQHt8O5Y4DYOn0ZQBMf8Jt5cEuRAMdH
         hrDCVTebgCslhCmSdoHrYZkWDZOPqvqAUkWzi02nW0pMxyf13JkR1KEZpp740TGvcpb1
         Al5wXJX5VNDqF8IG+v7Ydo5FmSheD38ZUw/i0c9O8fEKZrA9cB7wvkiYxDQuw25pG+GC
         Bzjg==
X-Gm-Message-State: AOAM533LIRIF0AMIW1JV7Gukl3TlJxi03PhQDauHtpm6ceZiIAdzwwXb
        cSgg5ZxbvWWDZIkG+T+DJ8Gp5j28+fNbinm4vYQ=
X-Google-Smtp-Source: ABdhPJwjx5ivE1Zad1jKqmtm24kdtGn6jOIclWUVzrv3C5fO4j58Tq8K7frWKgEccj3QvAKw7JGoHMMiEvJsA/NZIe8=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr21476724qtj.93.1593543412321;
 Tue, 30 Jun 2020 11:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200630164541.1329993-1-jakub@cloudflare.com>
In-Reply-To: <20200630164541.1329993-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 11:56:41 -0700
Message-ID: <CAEf4BzYZ0CM0F+xZD8pB1nw+BNfw9bbQqjWA57jhAe_OKJ+gvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, netns: Fix use-after-free in pernet
 pre_exit callback
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 11:33 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Iterating over BPF links attached to network namespace in pre_exit hook is
> not safe, even if there is just one. Once link gets auto-detached, that is
> its back-pointer to net object is set to NULL, the link can be released and
> freed without waiting on netns_bpf_mutex, effectively causing the list
> element we are operating on to be freed.
>
> This leads to use-after-free when trying to access the next element on the
> list, as reported by KASAN. Bug can be triggered by destroying a network
> namespace, while also releasing a link attached to this network namespace.
>
> | ==================================================================
> | BUG: KASAN: use-after-free in netns_bpf_pernet_pre_exit+0xd9/0x130
> | Read of size 8 at addr ffff888119e0d778 by task kworker/u8:2/177
> |
> | CPU: 3 PID: 177 Comm: kworker/u8:2 Not tainted 5.8.0-rc1-00197-ga0c04c9d1008-dirty #776
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: netns cleanup_net
> | Call Trace:
> |  dump_stack+0x9e/0xe0
> |  print_address_description.constprop.0+0x3a/0x60
> |  ? netns_bpf_pernet_pre_exit+0xd9/0x130
> |  kasan_report.cold+0x1f/0x40
> |  ? netns_bpf_pernet_pre_exit+0xd9/0x130
> |  netns_bpf_pernet_pre_exit+0xd9/0x130
> |  cleanup_net+0x30b/0x5b0
> |  ? unregister_pernet_device+0x50/0x50
> |  ? rcu_read_lock_bh_held+0xb0/0xb0
> |  ? _raw_spin_unlock_irq+0x24/0x50
> |  process_one_work+0x4d1/0xa10
> |  ? lock_release+0x3e0/0x3e0
> |  ? pwq_dec_nr_in_flight+0x110/0x110
> |  ? rwlock_bug.part.0+0x60/0x60
> |  worker_thread+0x7a/0x5c0
> |  ? process_one_work+0xa10/0xa10
> |  kthread+0x1e3/0x240
> |  ? kthread_create_on_node+0xd0/0xd0
> |  ret_from_fork+0x1f/0x30
> |
> | Allocated by task 280:
> |  save_stack+0x1b/0x40
> |  __kasan_kmalloc.constprop.0+0xc2/0xd0
> |  netns_bpf_link_create+0xfe/0x650
> |  __do_sys_bpf+0x153a/0x2a50
> |  do_syscall_64+0x59/0x300
> |  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> |
> | Freed by task 198:
> |  save_stack+0x1b/0x40
> |  __kasan_slab_free+0x12f/0x180
> |  kfree+0xed/0x350
> |  process_one_work+0x4d1/0xa10
> |  worker_thread+0x7a/0x5c0
> |  kthread+0x1e3/0x240
> |  ret_from_fork+0x1f/0x30
> |
> | The buggy address belongs to the object at ffff888119e0d700
> |  which belongs to the cache kmalloc-192 of size 192
> | The buggy address is located 120 bytes inside of
> |  192-byte region [ffff888119e0d700, ffff888119e0d7c0)
> | The buggy address belongs to the page:
> | page:ffffea0004678340 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
> | flags: 0x2fffe0000000200(slab)
> | raw: 02fffe0000000200 ffffea00045ba8c0 0000000600000006 ffff88811a80ea80
> | raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> | page dumped because: kasan: bad access detected
> |
> | Memory state around the buggy address:
> |  ffff888119e0d600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> |  ffff888119e0d680: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> | >ffff888119e0d700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> |                                                                 ^
> |  ffff888119e0d780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> |  ffff888119e0d800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> | ==================================================================
>
> Remove the "fast-path" for releasing a link that got auto-detached by a
> dying network namespace to fix it. This way as long as link is on the list
> and netns_bpf mutex is held, we have a guarantee that link memory can be
> accessed.
>
> An alternative way to fix this issue would be to safely iterate over the
> list of links and ensure there is no access to link object after detaching
> it. But, at the moment, optimizing synchronization overhead on link release
> without a workload in mind seems like an overkill.
>
> Fixes: 7233adc8b69b ("bpf, netns: Keep a list of attached bpf_link's")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Heh, that's a tricky one. Yeah, I agree, the fast path isn't important
and doing everything strictly under lock is better.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/net_namespace.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>

[...]
