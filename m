Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1199C1A43F7
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDJIvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 04:51:49 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44378 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgDJIvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 04:51:48 -0400
Received: by mail-lf1-f67.google.com with SMTP id 131so858007lfh.11
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 01:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uDKC4xTqwpSg5uq4JnNS6ajfpitITnn0k3YmWNOPTj8=;
        b=b15WidPDkTiKxGtIzFjzHd9kn2xEvCC475Uad+0V8W1uPdL70z27Z1Gi4xk+mqwq/9
         nHPdFkCI7pPWm9+UgezS4+gBxOaYj3cURaDUKjcJD4Pp4TYdfE3vzELmd+KnT0tWitFl
         peoTRjBe4Yt+bbx9RqWDLg4p/H5tWGOTebbWT6rnwudl/xhzGVYIFarV0dSJ+YI2lJHc
         3HGoxSjdHwNu90/GdU9vfMmR4vks56/NEzXSiYVf+HLi4udKiGe8lJzPfmaGqfIf79NA
         yQpZuoy2XyFF0nFxPipfitm0bQl3chbBK9XPiaKuFozB2WUs9RtRsBMZxO02Ms4T7eTD
         fYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uDKC4xTqwpSg5uq4JnNS6ajfpitITnn0k3YmWNOPTj8=;
        b=p27UGFHPQYJs9tgqHAjGnBm2QDr3XfjfHamEhXGk1bnyKP1s2KEnh7yp39zJ5CnCZc
         wwiycEPdf7naW+iQoss/NaKouXC5hliI1lmhoPdBlx9fClER+qJdzsFJqXcpim63mem7
         oL+VncDAhhk8S8stIu5JKJPC7upaRzVP9AtsaNisxfBeAL65Pf3MWjg96k0r1UC1ceX0
         lx6UoGQBfHY1l5UdEOuhtUrJTlP7xnmpIFAH1qpNQPzhoZ+o5nFzoF1I8Wej3juMU2am
         sNfANgWyB1HDcPMk7EvdAOuqnBvckkhbzIOxwolBW1n6RHp5hk005yyQIke3Yh2wRd0E
         Y2Gg==
X-Gm-Message-State: AGi0Puap2ZrDiPgv1eG469pmq7KlEWtZrlMnnoxA7v3ar5ZkJwu9kYK3
        KI7DJaVHZY0I7TpV5nf+odfuim5zOFYmkOTT3PG3fw==
X-Google-Smtp-Source: APiQypKoYyEII3eFAbfx91Lp5AE9FITsnozL5KV/06cRLmQWJhPWE+TdQUr2u2EXXKoB59pJd0tuUEU7maG7Mv1WYXg=
X-Received: by 2002:a19:6e47:: with SMTP id q7mr2044867lfk.164.1586508706855;
 Fri, 10 Apr 2020 01:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200410000425.2597887-1-andriin@fb.com>
In-Reply-To: <20200410000425.2597887-1-andriin@fb.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 10 Apr 2020 10:51:20 +0200
Message-ID: <CAG48ez1U70e8rU1NdTZ5ECS9kqSnQbpU5LBbk=iXmre+hGjuOQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: prevent re-mmap()'ing BPF map as writable
 for initially r/o mapping
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andrii.nakryiko@gmail.com, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 2:04 AM Andrii Nakryiko <andriin@fb.com> wrote:
> VM_MAYWRITE flag during initial memory mapping determines if already mmap()'ed
> pages can be later remapped as writable ones through mprotect() call. To
> prevent user application to rewrite contents of memory-mapped as read-only and
> subsequently frozen BPF map, remove VM_MAYWRITE flag completely on initially
> read-only mapping.
>
> Alternatively, we could treat any memory-mapping on unfrozen map as writable
> and bump writecnt instead. But there is little legitimate reason to map
> BPF map as read-only and then re-mmap() it as writable through mprotect(),
> instead of just mmap()'ing it as read/write from the very beginning.
>
> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/syscall.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 64783da34202..f7f6db50a085 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -635,6 +635,10 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
>         /* set default open/close callbacks */
>         vma->vm_ops = &bpf_map_default_vmops;
>         vma->vm_private_data = map;
> +       vma->vm_flags &= ~VM_MAYEXEC;
> +       if (!(vma->vm_flags & VM_WRITE))
> +               /* disallow re-mapping with PROT_WRITE */
> +               vma->vm_flags &= ~VM_MAYWRITE;

The .open and .close handlers for the VMA are also wrong:

/* called for any extra memory-mapped regions (except initial) */
static void bpf_map_mmap_open(struct vm_area_struct *vma)
{
        struct bpf_map *map = vma->vm_file->private_data;

        bpf_map_inc_with_uref(map);

        if (vma->vm_flags & VM_WRITE) {
                mutex_lock(&map->freeze_mutex);
                map->writecnt++;
                mutex_unlock(&map->freeze_mutex);
        }
}

/* called for all unmapped memory region (including initial) */
static void bpf_map_mmap_close(struct vm_area_struct *vma)
{
        struct bpf_map *map = vma->vm_file->private_data;

        if (vma->vm_flags & VM_WRITE) {
                mutex_lock(&map->freeze_mutex);
                map->writecnt--;
                mutex_unlock(&map->freeze_mutex);
        }

        bpf_map_put_with_uref(map);
}

static const struct vm_operations_struct bpf_map_default_vmops = {
        .open           = bpf_map_mmap_open,
        .close          = bpf_map_mmap_close,
};

You can use mprotect() to flip VM_WRITE off while a VMA exists, and
then the writecnt won't go down when you close it. Or you could even
get the writecnt to go negative if you map as writable, then
mprotect() to readonly, then split the VMA a few times, mprotect the
split VMAs to writable, and then unmap them.

I think you'll want to also check for MAYWRITE here.

Also, the bpf_map_inc_with_uref/bpf_map_put_with_uref here look
superfluous - the VMA holds a reference to the file, and the file
holds a reference to the map.
