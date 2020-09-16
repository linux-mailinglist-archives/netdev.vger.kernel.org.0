Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A1E26B94D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 03:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIPBT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 21:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIPBT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 21:19:56 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBE8C06174A;
        Tue, 15 Sep 2020 18:19:55 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id z19so5144238lfr.4;
        Tue, 15 Sep 2020 18:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8QEJvUxPPsh4s/sOrzof5ua60IrtaiVNPX3ceX0sps=;
        b=SJ7g2ZaLX7/qBAUbA/+HVPay/HsPuHucJX2dHN7xEPe/R+y7YSAufjnw9FBFuMMozL
         5QY529t7/7hJPIpqBSu+hazAGSQanvjxfxGALvKcOZ4WCAO4ZI4xRHS+RFPVA23dHNv4
         HoYXiwWDT7bofhuuXNj8qrRcIhdrJ7uKlqCWzXW1KPdaZWpDubCuXXuDZt/J/KqU08Nt
         hnSdMQ8rYgIyyWrbQSrXL5TkdgCZwi+lBuK2CJOL5sKT+4jUdlmp+CDo73HTSbBK6+ZR
         G1+EzyDm4Oeo3bt/WiD4wP+fWRgLFDMf3x4sCTyGvZQMGG87SvoL+9j7o0LZiKIwCT6j
         Jt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8QEJvUxPPsh4s/sOrzof5ua60IrtaiVNPX3ceX0sps=;
        b=HBMeQdwuLTRQym49a0vqnNv/H2JTwITP/UFwfI0gd3ASEDKhA6jzllRRMtF8Dd81zJ
         9H14SyU8F2xGqnuxxUHSb4jN/PaIiIEHifxdmNiLoTbSBAmhqCDSHmRghUjTeZ9y+dR8
         rGe9v22AO1gVdK226dXrKxk6jI2br5f9SX6PZlBiNPKQ9lapTM6qiYUK1QySiJPf4nqn
         kJVixKRT11vIH2CIyarMPT+FjHYo0BDhGgnJ/zffCLrgyodn49SS/BVjB0bcgoCDDmb4
         dN4TAvMDotL82CImYBgZOa7SGfswk+Cb6+MWLZlQsbhEx+65m1YzbIDK50nlCGTmZu+P
         cXbA==
X-Gm-Message-State: AOAM533M7+5xtg4pKETYtWgd+UlZKzNcmqQOXNf2l4dXlKycQR03MRUM
        3W94sLeb/vjiOWHOAvtOlWneNRqe1ym+eE0wInXowtbl
X-Google-Smtp-Source: ABdhPJws0wkMNmMRBxCjfJCUJjQHVCGyKUjuahvsVRqimRDUZF9VHgA+4sjqNfTVqMk4IzZTidaJ9NsiDmnSHUtr4lE=
X-Received: by 2002:a19:8606:: with SMTP id i6mr6436705lfd.263.1600219194219;
 Tue, 15 Sep 2020 18:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200916004401.146277-1-yhs@fb.com> <CAEf4BzauFqMvUPTSN058L9ptzi8oMu31MRoVrgKfB8XPn6c2dg@mail.gmail.com>
In-Reply-To: <CAEf4BzauFqMvUPTSN058L9ptzi8oMu31MRoVrgKfB8XPn6c2dg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Sep 2020 18:19:42 -0700
Message-ID: <CAADnVQJ=xxKHU4-5NsGipaLns+WfQ8r4RonZo9XFXv50oM3b3Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix a rcu warning for bpffs map pretty-print
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
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

On Tue, Sep 15, 2020 at 5:58 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Sep 15, 2020 at 5:44 PM Yonghong Song <yhs@fb.com> wrote:
> >
> > Running selftest
> >   ./btf_btf -p
> > the kernel had the following warning:
> >   [   51.528185] WARNING: CPU: 3 PID: 1756 at kernel/bpf/hashtab.c:717 htab_map_get_next_key+0x2eb/0x300
> >   [   51.529217] Modules linked in:
> >   [   51.529583] CPU: 3 PID: 1756 Comm: test_btf Not tainted 5.9.0-rc1+ #878
> >   [   51.530346] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.el7.centos 04/01/2014
> >   [   51.531410] RIP: 0010:htab_map_get_next_key+0x2eb/0x300
> >   ...
> >   [   51.542826] Call Trace:
> >   [   51.543119]  map_seq_next+0x53/0x80
> >   [   51.543528]  seq_read+0x263/0x400
> >   [   51.543932]  vfs_read+0xad/0x1c0
> >   [   51.544311]  ksys_read+0x5f/0xe0
> >   [   51.544689]  do_syscall_64+0x33/0x40
> >   [   51.545116]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > The related source code in kernel/bpf/hashtab.c:
> >   709 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> >   710 {
> >   711         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> >   712         struct hlist_nulls_head *head;
> >   713         struct htab_elem *l, *next_l;
> >   714         u32 hash, key_size;
> >   715         int i = 0;
> >   716
> >   717         WARN_ON_ONCE(!rcu_read_lock_held());
> >
> > In kernel/bpf/inode.c, bpffs map pretty print calls map->ops->map_get_next_key()
> > without holding a rcu_read_lock(), hence causing the above warning.
> > To fix the issue, just surrounding map->ops->map_get_next_key() with rcu read lock.
> >
> > Reported-by: Alexei Starovoitov <ast@kernel.org>
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Fixes: a26ca7c982cb ("bpf: btf: Add pretty print support to the basic arraymap")
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
>
> LGTM.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks!
