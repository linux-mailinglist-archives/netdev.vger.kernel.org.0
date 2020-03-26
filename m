Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8237E193EF4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgCZMfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:35:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54929 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbgCZMfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585226120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9ZFM2rDTCimQ0JQaXvASkvUq3yLujeUr1YmlyXwd37M=;
        b=YLv/c+14YT0uhcq0/6hMM9is+Iw4JJcv0YvJYuPSoj2rhBFPUICtRuPZ8yzqBnW9QSUVAN
        a9odBAOGRgBWloNm927WqqYHZHXwqHwSyLGrtbjOSacERv582lmoAEoghjUNukiyOJXYb3
        MyyJTYer1lzHO1D+/hBDM080kIr9HbA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-gaaShBYsMWScrCHncfCEaQ-1; Thu, 26 Mar 2020 08:35:18 -0400
X-MC-Unique: gaaShBYsMWScrCHncfCEaQ-1
Received: by mail-lf1-f72.google.com with SMTP id j13so2178006lfg.19
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9ZFM2rDTCimQ0JQaXvASkvUq3yLujeUr1YmlyXwd37M=;
        b=ScmRLjnrf9xtU5PBUt5h5Scf143oliZCPYnuuzhvr9jGExarvSEWgpDWkVqA4JFUzi
         vHLyxOxdb94HcmEfDiuHbYQ9czDlP24yW9gei3zW9HLlF/mhP8+KGHOBeZT9PXtpnA2V
         go1g87UXiakaqQ+PX/iYkStnf96qOU/vu9O7nyL4QXCrOcFLu9l+By16n9qyMqGU197V
         d0KNVT8LEQHB7FwkH0J/zptzRqbG91CVi6uQVdy0WqBTMIn+89Kg0DIVgi4eikj0JfQ6
         TjsjEm01Ip/BsjJlFTqrRmv1EBJJFpEocPQpu2A3hVZMlzOuQaq+86w0hlxHHz7a7mQr
         H9aQ==
X-Gm-Message-State: ANhLgQ1tY3sTCPux3nJv2scEX58kKzwiYHg+Tya5L8vHWe/kbsVfcGLD
        uoNnL8eiooxZ0803rM4p9mJwGozJruSa+DtauvP6dfHyvUaxVrVCZGj71bm9UDyeMU7RKm8bvHV
        WNHAGkYME2dv+LdZq
X-Received: by 2002:a19:a40f:: with SMTP id q15mr5531939lfc.104.1585226117184;
        Thu, 26 Mar 2020 05:35:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuMCk5knpuZL3stSBKP9NCtux2i5UUrfDDqAb7fOmI0S9Wv8fHsMIoGuCXdqzpyUZZtBMgwLA==
X-Received: by 2002:a19:a40f:: with SMTP id q15mr5531926lfc.104.1585226116862;
        Thu, 26 Mar 2020 05:35:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b23sm1394311lfi.55.2020.03.26.05.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 05:35:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 94ED018158B; Thu, 26 Mar 2020 13:35:13 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN> <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch> <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 26 Mar 2020 13:35:13 +0100
Message-ID: <87pncznvjy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> Now for XDP. It has same flawed model. And even if it seems to you
> that it's not a big issue, and even if Jakub thinks we are trying to
> solve non-existing problem, it is a real problem and a real concern
> from people that have to support XDP in production with many
> well-meaning developers developing BPF applications independently.
> Copying what you wrote in another thread:
>
>> Setting aside the question of which is the best abstraction to represent
>> an attachment, it seems to me that the actual behavioural problem (XDP
>> programs being overridden by mistake) would be solvable by this patch,
>> assuming well-behaved userspace applications.
>
> ... this is a horrible and unrealistic assumption that we just cannot
> make and accept. However well-behaved userspace applications are, they
> are written by people that make mistakes. And rather than blissfully
> expect that everything will be fine, we want to have enforcements in
> place that will prevent some buggy application to wreck havoc in
> production.

Look, I'm not trying to tell you how to managed your internal systems.
I'm just objecting to your assertion that your deployment model is the
only one that can possibly work, and the refusal to consider other
alternatives that comes with it.

>> You're saying that like we didn't already have the netlink API. We
>> essentially already have (the equivalent of) LINK_CREATE and LINK_QUERY,
>> this is just adding LINK_UPDATE. It's a straight-forward fix of an
>> existing API; essentially you're saying we should keep the old API in a
>> crippled state in order to promote your (proposed) new API.
>
> This is the fundamental disagreement that we seem to have. XDP's BPF
> program attachment is not in any way equivalent to bpf_link. So no,
> netlink API currently doesn't have anything that's close to bpf_link.
> Let me try to summarize what bpf_link is and what are its fundamental
> properties regardless of type of BPF programs.

First of all, thank you for this summary; that is very useful!

> 1. bpf_link represents a connection (pairing?) of BPF program and some
> BPF hook it is attached to. BPF hook could be perf event, cgroup,
> netdev, etc. It's a completely independent object in itself, along the
> bpf_map and bpf_prog, which has its own lifetime and kernel
> representation. To user-space application it is returned as an
> installed FD, similar to loaded BPF program and BPF map. It is
> important that it's not just a BPF program, because BPF program can be
> attached to multiple BPF hooks (e.g., same XDP program can be attached
> to multiple interface; same kprobe handler can be installed multiple
> times), which means that having BPF program FD isn't enough to
> uniquely represent that one specific BPF program attachment and detach
> it or query it. Having kernel object for this allows to encapsulate
> all these various details of what is attached were and present to
> user-space a single handle (FD) to work with.

For XDP there is already a unique handle, it's just implicit: Each
netdev can have exactly one XDP program loaded. So I don't really see
how bpf_link adds anything, other than another API for the same thing?

> 2. Due to having FD associated with bpf_link, it's not possible to
> talk about "owning" bpf_link. If application created link and never
> shared its FD with any other application, it is the sole owner of it.
> But it also means that you can share it, if you need it. Now, once
> application closes FD or app crashes and kernel automatically closes
> that FD, bpf_link refcount is decremented. If it was the last or only
> FD, it will trigger automatica detachment and clean up of that
> particular BPF program attachment. Note, not a clean up of BPF
> program, which can still be attached somewhere else: only that
> particular attachment.

This behaviour is actually one of my reservations against bpf_link for
XDP: I think that automatically detaching XDP programs when the FD is
closed is very much the wrong behaviour. An XDP program processes
packets, and when loading one I very much expect it to keep doing that
until I explicitly tell it to stop.

> 3. This derives from the concept of ownership of bpf_link. Once
> bpf_link is attached, no other application that doesn't own that
> bpf_link can replace, detach or modify the link. For some cases it
> doesn't matter. E.g., for tracing, all attachment to the same fentry
> trampoline are completely independent. But for other cases this is
> crucial property. E.g., when you attach BPF program in an exclusive
> (single) mode, it means that particular cgroup and any of its children
> cgroups can have any more BPF programs attached. This is important for
> container management systems to enforce invariants and correct
> functioning of the system. Right now it's very easy to violate that -
> you just go and attach your own BPF program, and previous BPF program
> gets automatically detached without original application that put it
> there knowing about this. Chaos ensues after that and real people have
> to deal with this. Which is why existing
> BPF_PROG_ATTACH/BPF_PROG_DETACH API is inadequate and we are adding
> bpf_link support.

I can totally see how having an option to enforce a policy such as
locking out others from installing cgroup BPF programs is useful. But
such an option is just that: policy. So building this policy in as a
fundamental property of the API seems like a bad idea; that is
effectively enforcing policy in the kernel, isn't it?

> Those same folks have similar concern with XDP. In the world where
> container management installs "root" XDP program which other user
> applications can plug into (libxdp use case, right?), it's crucial to
> ensure that this root XDP program is not accidentally overwritten by
> some well-meaning, but not overly cautious developer experimenting in
> his own container with XDP programs. This is where bpf_link ownership
> plays a huge role. Tupperware agent (FB's container management agent)
> would install root XDP program and will hold onto this bpf_link
> without sharing it with other applications. That will guarantee that
> the system will be stable and can't be compromised.

See this is where we get into "deployment-model specific territory". I
mean, sure, in the "central management daemon" model, it makes sense
that no other applications can replace the XDP program. But, erm, we
already have a mechanism to ensure that: Just don't grant those
applications CAP_NET_ADMIN? So again, bpf_link doesn't really seem to
add anything other than a different way to do the same thing?

Additionally, in the case where there is *not* a central management
daemon (i.e., what I'm implementing with libxdp), this would be the flow
implemented by the library without bpf_link:

1. Query kernel for current BPF prog loaded on $IFACE
2. Sanity-check that this program is a dispatcher program installed by
   libxdp
3. Create a new dispatcher program with whatever changes we want to do
   (such as adding another component program).
4. Atomically replace the old program with the new one using the netlink
   API in this patch series.

Whereas with bpf_link, it would be:

1. Find the pinned bpf_link for $IFACE (e.g., load from
   /sys/fs/bpf/iface-links/$IFNAME).
2. Query kernel for current BPF prog linked to $LINK
3. Sanity-check that this program is a dispatcher program installed by
   libxdp
4. Create a new dispatcher program with whatever changes we want to do
   (such as adding another component program).
5. Atomically replace the old program with the new one using the
   LINK_UPDATE bpf() API.


So all this does is add an additional step, and another dependency on
bpffs. And crucially, I really don't see how the "bpf_link is the only
thing that is not fundamentally broken" argument holds up.

-Toke

