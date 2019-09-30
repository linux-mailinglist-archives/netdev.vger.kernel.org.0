Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090BBC251A
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbfI3Q07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:26:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40010 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732026AbfI3Q07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:26:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id y144so8302904qkb.7;
        Mon, 30 Sep 2019 09:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/82IvvXBPSeOUnTimHmLfeGbwanGgz3/wyw+4Uf2M84=;
        b=uqGeyEN6zHofbXJ+F2aQML/sUJMng3bDh0LgHmlYVarlITQIDmrr49+hhyivl6+V4D
         fnNL34+5RDkqtVVflQix1dDKlAmIKSueoCphWcqzId+iho/8jl0eEI8Z0DKhAGJatqvO
         QRUvD8C9BnAbI9aCOzdZ3Fcj+Ts5UKTmgb9v2I9Q6mOc7I9CPOKK4+kyDJs1VWXskPFw
         1NQUbxrgiY1vl+66bG/uHdMxkHuYCektE8JPqHiRnReh8G3umKfr0Zmo+BxeUTN79KZB
         XKqIY/nS3IXGdk+Hc0MtRMpyA2mO4bhm+prbjNnsXI5e9FrIBPGwMzn+40OUhiq5SiZJ
         9xNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/82IvvXBPSeOUnTimHmLfeGbwanGgz3/wyw+4Uf2M84=;
        b=M7I8SVR912SVlBDd4tXHzx2qRFOg++Ylteh7uPRPgpWkoVfkQOKHMxH3DN+rOKw0DT
         SPuX0zULRtMBiqbtwVH9HbDnAoRJZysuaHXdbC/aVzHaDAs7bAt7NYJkpTLx2ra8AXCh
         hO76lApset1BvHl2/Bjrwoq144Mz40vIiH4LHMbF+xbsf0OkHwwDg3XKAjPit2dZ1apg
         SMiGvucd8hahSBX2jABSJgasKq7NPin9yzf75rUW5w25N0xqL4eV3A5MRC9dZveJVXKG
         zxC/wK4plhCs8m/o9N2+vJ+VaTwzJki13pnNyOeF1tlHBm7jfkmDcROvmU7LmFDMpgA4
         F3SA==
X-Gm-Message-State: APjAAAUOozzjc7zGq+Iji0BCObvNP1n+az+OY/d58vNoy6Hx1Sa6sHJr
        2rQSA8topvuTgdlEbHAv4tBm0MJzXfE5fOGdn0c=
X-Google-Smtp-Source: APXvYqxBFGlwM2s42jIN6WX/UdqvVpfVpTmtQ/JfID2Hjq9Xv0OxQz2yq5VEvWwvDKlfChDUY17ZYd6RMk2jTZqLiGA=
X-Received: by 2002:a37:98f:: with SMTP id 137mr885008qkj.449.1569860818118;
 Mon, 30 Sep 2019 09:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190928063033.1674094-1-andriin@fb.com> <0b70df6a-28fd-e139-d72c-d4d88e9bc7b7@iogearbox.net>
In-Reply-To: <0b70df6a-28fd-e139-d72c-d4d88e9bc7b7@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Sep 2019 09:26:47 -0700
Message-ID: <CAEf4BzYgNE7pLRVQStQ_hmC-WQp5cFz4W2sLFfunow35=7PGNQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: count present CPUs, not theoretically possible
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 1:32 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 9/28/19 8:30 AM, Andrii Nakryiko wrote:
> > This patch switches libbpf_num_possible_cpus() from using possible CPU
> > set to present CPU set. This fixes issues with incorrect auto-sizing of
> > PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.
>
> Those issues should be described in more detail here in the changelog,
> otherwise noone knows what is meant exactly when glancing at the git log.

Sure, I can add more details.

>
> > On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
> > be a set of any representable (i.e., potentially possible) CPU, which is
> > normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
> > tested on, while there were just two CPU cores actually present).
> > /sys/devices/system/cpu/present, on the other hand, will only contain
> > CPUs that are physically present in the system (even if not online yet),
> > which is what we really want, especially when creating per-CPU maps or
> > perf events.
> >
> > On systems with HOTPLUG disabled, present and possible are identical, so
> > there is no change of behavior there.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/libbpf.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index e0276520171b..45351c074e45 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
> >
> >   int libbpf_num_possible_cpus(void)
> >   {
> > -     static const char *fcpu = "/sys/devices/system/cpu/possible";
> > +     static const char *fcpu = "/sys/devices/system/cpu/present";
>
> Problem is that this is going to break things *badly* for per-cpu maps as
> BPF_DECLARE_PERCPU() relies on possible CPUs, not present ones. And given
> present<=possible you'll end up corrupting user space when you do a lookup
> on the map since kernel side operates on possible as well.

Yeah, you are right. Ok, let me go back to my VM and repro original
issue I had and see what and why is causing that. I'll see maybe I
don't need this fix at all.

>
> >       int len = 0, n = 0, il = 0, ir = 0;
> >       unsigned int start = 0, end = 0;
> >       int tmp_cpus = 0;
> >
>
