Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6991A4A14
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 21:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgDJTAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 15:00:23 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44763 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgDJTAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 15:00:23 -0400
Received: by mail-qk1-f196.google.com with SMTP id j4so3100824qkc.11;
        Fri, 10 Apr 2020 12:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwBe7xi5mOInJFY4in1s3aWzNNuKPkpzEvwQ4F8Kvjc=;
        b=n5dCfyhpKk0P/D9Zaiw+CntSa6UxfBV10HE7qxCYPKpHh9t2c4/cxNt6Tlc9Agpqr0
         Ga8F579NiEu89XHBvRETDqO8ycDnpkMXjhGKrQ5Goq6zyPCxtUJ99dKlmWZq3AxuRV/Y
         kSBpxTAPv7iqxXKqPznhFP/p3i9A01kSk/iZlQNALVZxoX+L67S66D4+w+KqiLUkl7Qw
         QpRYZXXwPsI2Ff8bDpU1qrSf5vl+rD9MQNLUyFAroiYIZJL2mZW2pXvKFSLHUAJBMqJ6
         G49rKtDpZt4Ck/p3yoUT97NiiVkJ3vkwu0nj/1x5fYoGUkTfotyAAkpjuyMUJsRl+o2h
         gdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwBe7xi5mOInJFY4in1s3aWzNNuKPkpzEvwQ4F8Kvjc=;
        b=M+tzVFkGbpDXH7UUW0O0cDyNM8F7WU4hLEfJUHagqYPUoBkasUm72Ann7tJRdm2TAq
         4HJNOklpE+XAzVXLIb1E+9HgvCmiDqzYC5Y2tn9el3UMNvtxW2S3PfUMI8458tN9aQQI
         LpOqk85FNARuGVTvhnrf96UHN23H742H8Gdl8mQJP5l2Z4gwwPUC17LzSC0yg1k9QVzm
         B+soH2qt2IAwLCENTBFW7PRzF2TA30nbMaRr/Md9J3w5WeGz0o9Gm2sTbraWBAn9nLcJ
         HFWsJmsJU+V4xNZxjq0sUOSlJg2/rTr1X8Ens44J8ohDeTidZJunZhWRuwK3Q7kmjnq+
         ee4w==
X-Gm-Message-State: AGi0PuaTr2fYSDAkTMXSKncf/rNUZGPoyWCJuPhVk4fdEGKXfs5GR06L
        8ns/uaIXP1I+y3DNZfZ3rVG4LP/YEUQf9ww+/Yk=
X-Google-Smtp-Source: APiQypLLpQ1go2x3CZKQMLdXhXL51CJijVhUn2ynZwQqGXXbwWVBtB3g/qsaeXbF2BzOS6Xz+qhM2hMbcW0+peAcStU=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr5734565qka.449.1586545222282;
 Fri, 10 Apr 2020 12:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200410000425.2597887-1-andriin@fb.com> <CAG48ez1U70e8rU1NdTZ5ECS9kqSnQbpU5LBbk=iXmre+hGjuOQ@mail.gmail.com>
In-Reply-To: <CAG48ez1U70e8rU1NdTZ5ECS9kqSnQbpU5LBbk=iXmre+hGjuOQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 12:00:11 -0700
Message-ID: <CAEf4BzZk8SzGQ4srkf1dApEqt84_ktpVQG9sVBBkK3GZ=xQzEA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: prevent re-mmap()'ing BPF map as writable
 for initially r/o mapping
To:     Jann Horn <jannh@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 1:51 AM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Apr 10, 2020 at 2:04 AM Andrii Nakryiko <andriin@fb.com> wrote:
> > VM_MAYWRITE flag during initial memory mapping determines if already mmap()'ed
> > pages can be later remapped as writable ones through mprotect() call. To
> > prevent user application to rewrite contents of memory-mapped as read-only and
> > subsequently frozen BPF map, remove VM_MAYWRITE flag completely on initially
> > read-only mapping.
> >
> > Alternatively, we could treat any memory-mapping on unfrozen map as writable
> > and bump writecnt instead. But there is little legitimate reason to map
> > BPF map as read-only and then re-mmap() it as writable through mprotect(),
> > instead of just mmap()'ing it as read/write from the very beginning.
> >
> > Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> > Reported-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  kernel/bpf/syscall.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 64783da34202..f7f6db50a085 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -635,6 +635,10 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
> >         /* set default open/close callbacks */
> >         vma->vm_ops = &bpf_map_default_vmops;
> >         vma->vm_private_data = map;
> > +       vma->vm_flags &= ~VM_MAYEXEC;
> > +       if (!(vma->vm_flags & VM_WRITE))
> > +               /* disallow re-mapping with PROT_WRITE */
> > +               vma->vm_flags &= ~VM_MAYWRITE;
>
> The .open and .close handlers for the VMA are also wrong:

Yes, it has to check VM_MAYWRITE now, my bad, thanks for catching
this! Extended selftest to validate that scenario as well.

>
> /* called for any extra memory-mapped regions (except initial) */
> static void bpf_map_mmap_open(struct vm_area_struct *vma)
> {
>         struct bpf_map *map = vma->vm_file->private_data;
>
>         bpf_map_inc_with_uref(map);
>
>         if (vma->vm_flags & VM_WRITE) {
>                 mutex_lock(&map->freeze_mutex);
>                 map->writecnt++;
>                 mutex_unlock(&map->freeze_mutex);
>         }
> }
>
> /* called for all unmapped memory region (including initial) */
> static void bpf_map_mmap_close(struct vm_area_struct *vma)
> {
>         struct bpf_map *map = vma->vm_file->private_data;
>
>         if (vma->vm_flags & VM_WRITE) {
>                 mutex_lock(&map->freeze_mutex);
>                 map->writecnt--;
>                 mutex_unlock(&map->freeze_mutex);
>         }
>
>         bpf_map_put_with_uref(map);
> }
>
> static const struct vm_operations_struct bpf_map_default_vmops = {
>         .open           = bpf_map_mmap_open,
>         .close          = bpf_map_mmap_close,
> };
>
> You can use mprotect() to flip VM_WRITE off while a VMA exists, and
> then the writecnt won't go down when you close it. Or you could even
> get the writecnt to go negative if you map as writable, then
> mprotect() to readonly, then split the VMA a few times, mprotect the
> split VMAs to writable, and then unmap them.
>
> I think you'll want to also check for MAYWRITE here.
>
> Also, the bpf_map_inc_with_uref/bpf_map_put_with_uref here look
> superfluous - the VMA holds a reference to the file, and the file
> holds a reference to the map.

Hm.. So the file from which memory-mapping was created originally will
stay referenced by VMA subsystem until the last VMA segment is
unmmaped (and bpf_map_mmap_close is called for it), even if file
itself is closed from user-space? It makes sense, though I didn't
realize it at the time I was implementing this. I'll drop refcounting
then.
