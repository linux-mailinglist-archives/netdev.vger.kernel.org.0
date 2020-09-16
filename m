Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FAD26B927
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIPA6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIPA6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 20:58:15 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D56C06174A;
        Tue, 15 Sep 2020 17:58:13 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x20so375026ybs.8;
        Tue, 15 Sep 2020 17:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxMQEsMs2FwKSc+3vZ6gbovHW+L4nnRr+b5HtgVMNvY=;
        b=vN++gOoSpmPn56yM08AI9ZSNbAkCJTdYjznxDDC9AoGzNL7tyfvEkJN2SdcGUMZavB
         xCMCs4YOb0SeqGOm9O6VJp2B3iEw4XEdH5l3aoy+EodzJi7YyXUab7oCVbfECXQ8Vj32
         HbabnyGmoYHxFjFTDBmPoNWaCfh96+b7BI+y4vzBOWfTxbwt4Pe5auTl9g8OWhiZxuuy
         fLZRAlcMwsDE5UT/ShImEUNsPBIKNQq1e/2OnnAGTM/bvJiCxzb6xN6DrAUjh75QKi1L
         whuHDf1We4LPmtSWGwvZ2jbt1g7/c1127JRpBtq43huIF1mDOZQIc5/L8Yu12gsdN1Ve
         tNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxMQEsMs2FwKSc+3vZ6gbovHW+L4nnRr+b5HtgVMNvY=;
        b=OIwRjgTHNn4FBoBGEI95A8S1OHtm0hsTMV6+Vy3itwscbdHJV8KHe+Qz/GZaTuUI5R
         ILEBjGce5ur6XPBI3b9jlGj9PmEbDNfvgzNt0I/vcxeca66HdpoPqSyT/G85VPfWL+OC
         7rshOoM0l/BxJhKJRrRDjg96bk5KuPbyGEa0/hcDxEYax7vbcrRTymHa8KgMP4CECEhp
         QKwTkzHO5ypOfGYtHSnxU0mjm5gdK3IXbpAZe3zhzakgso9qCzZNPRGl6g9Eaq+et7E5
         ly4AjZmemVwRDMMTIhix3cgVt9QCoKEyu9JgLzFVFLbFvM3UnqXVQPU2n4KJ5C9KqEAi
         SgHw==
X-Gm-Message-State: AOAM531/AboTayi3CksrrDxfRobkOYOPbQcAqLayjpjMHA9US4uOT7+Q
        4FqDoR4sY2EmsQD9jnITlBoP0NyNWB3+5dgMYDw=
X-Google-Smtp-Source: ABdhPJxHugYy1Qoh7yRajhFjOvoqe0jydpB4rLs9SBNI2FeJAVeHpbKKcjLDG542Ps7R9nVAGkr3D6Puc8kTo9zo4fI=
X-Received: by 2002:a25:c049:: with SMTP id c70mr31929496ybf.403.1600217888395;
 Tue, 15 Sep 2020 17:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200916004401.146277-1-yhs@fb.com>
In-Reply-To: <20200916004401.146277-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Sep 2020 17:57:57 -0700
Message-ID: <CAEf4BzauFqMvUPTSN058L9ptzi8oMu31MRoVrgKfB8XPn6c2dg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix a rcu warning for bpffs map pretty-print
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 5:44 PM Yonghong Song <yhs@fb.com> wrote:
>
> Running selftest
>   ./btf_btf -p
> the kernel had the following warning:
>   [   51.528185] WARNING: CPU: 3 PID: 1756 at kernel/bpf/hashtab.c:717 htab_map_get_next_key+0x2eb/0x300
>   [   51.529217] Modules linked in:
>   [   51.529583] CPU: 3 PID: 1756 Comm: test_btf Not tainted 5.9.0-rc1+ #878
>   [   51.530346] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.el7.centos 04/01/2014
>   [   51.531410] RIP: 0010:htab_map_get_next_key+0x2eb/0x300
>   ...
>   [   51.542826] Call Trace:
>   [   51.543119]  map_seq_next+0x53/0x80
>   [   51.543528]  seq_read+0x263/0x400
>   [   51.543932]  vfs_read+0xad/0x1c0
>   [   51.544311]  ksys_read+0x5f/0xe0
>   [   51.544689]  do_syscall_64+0x33/0x40
>   [   51.545116]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> The related source code in kernel/bpf/hashtab.c:
>   709 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
>   710 {
>   711         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
>   712         struct hlist_nulls_head *head;
>   713         struct htab_elem *l, *next_l;
>   714         u32 hash, key_size;
>   715         int i = 0;
>   716
>   717         WARN_ON_ONCE(!rcu_read_lock_held());
>
> In kernel/bpf/inode.c, bpffs map pretty print calls map->ops->map_get_next_key()
> without holding a rcu_read_lock(), hence causing the above warning.
> To fix the issue, just surrounding map->ops->map_get_next_key() with rcu read lock.
>
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Fixes: a26ca7c982cb ("bpf: btf: Add pretty print support to the basic arraymap")
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index fb878ba3f22f..18f4969552ac 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -226,10 +226,12 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
>         else
>                 prev_key = key;
>
> +       rcu_read_lock();
>         if (map->ops->map_get_next_key(map, prev_key, key)) {
>                 map_iter(m)->done = true;
> -               return NULL;
> +               key = NULL;
>         }
> +       rcu_read_unlock();
>         return key;
>  }
>
> --
> 2.24.1
>
