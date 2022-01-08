Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9812488598
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 20:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiAHT2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 14:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiAHT2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 14:28:34 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B12C06173F;
        Sat,  8 Jan 2022 11:28:34 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id i6so8572300pla.0;
        Sat, 08 Jan 2022 11:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l1N6J2q16R2Dgwnkwx/AFiEvAxs8xocbwNzeRHsXtEI=;
        b=RvYoS4RRd5JXK53ixPWtDqURqAoxN5TAHKNoNodQcceAaYs5gO9KGjOvQDJrxQWc0g
         9IQYxxy+IE5ilOV43lY502sda2orsAjEAuUqqUxD3HS6K8wlQ6V5GIfZunrkM7DZst3s
         IeNOhbZtxhfn+x60I/Xlz4liEszEXkrBs9mkFEggPU8vk4HqM0G4BCyl6RMxs3wUhhiz
         GG3OFniA3yLuKOrmQGmf+aH1+9m1THzPyQokWCdA5u/ZchmHvNQRnfLSO0GyWi+zufc8
         BppEUfH2YfoQ4Wl6sG+p/NBHkb53TkiR9dK+uLVY4kyhAuRLoIPI7nFn9BsNjaGwYDko
         IIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l1N6J2q16R2Dgwnkwx/AFiEvAxs8xocbwNzeRHsXtEI=;
        b=NjU5di9ruoUjJchz3t/nA0PcR1g/Wa8N51C+U7B+0OcASUcTxUpP6NYy6oCBRGRha5
         RkjztebrCBDNQj36CKFFxutHcEcdh9/KRxrBLnZYKFzRRDOxsboLwWJMxXNvcYMgQ/EY
         7cYMOPDGWU+CDIhC0UyiOC+JbCz8RQXFeE2sIQnv/70HL0TQ9CF71iJo5CZ4FK2kbd91
         Il44IxksJwu55sgpyrK2wQi6UR3cBxxpQVli+zgivqqutuWwonPgP4EZJ59sl7AutBLN
         BFNeo/V4EAGu/z+34Rx6wTyFkhPVwelx8ldc42DWad+wHMZgOLoMHQPYck5p3ZEXRjif
         OV2w==
X-Gm-Message-State: AOAM533ZJPOpPTHkXnYtOOKerOFYf1bT2sBq2lhpvP1TuLcWmQE+ioYK
        HsSxAg0mzOV2AhUSMxxzD1eUbbiXpn6TTJoETBs=
X-Google-Smtp-Source: ABdhPJxamgqOBvVoOMotUlXFK/7JDHs1GNv/Os7k/ncI5o2oJMpoLyCKNVWQXhD3DAzrNsaBGbyEn2r94QFlRyx77ik=
X-Received: by 2002:a17:90a:b003:: with SMTP id x3mr5383100pjq.122.1641670113876;
 Sat, 08 Jan 2022 11:28:33 -0800 (PST)
MIME-Version: 1.0
References: <20220107215438.321922-1-toke@redhat.com> <20220107215438.321922-2-toke@redhat.com>
 <CAADnVQ+uftgnRQa5nvG4FTJga_=_FMAGxuiPB3O=AFKfEdOg=A@mail.gmail.com> <87pmp28iwe.fsf@toke.dk>
In-Reply-To: <87pmp28iwe.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 8 Jan 2022 11:28:22 -0800
Message-ID: <CAADnVQLWjbm03-3NHYyEx98tWRN68LSaOd3R9fjJoHY5cYoEJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 1/3] bpf: Add "live packet" mode for XDP in bpf_prog_run()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 8, 2022 at 5:19 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Sure, can do. Doesn't look like BPF_PROG_RUN is documented in there at
> all, so guess I can start such a document :)

prog_run was simple enough.
This live packet mode is a different level of complexity.
Just look at the length of this thread.
We keep finding implementation details that will be relevant
to anyone trying to use this interface.
They all will become part of uapi.

> > Another question comes to mind:
> > What happens when a program modifies the packet?
> > Does it mean that the 2nd frame will see the modified data?
> > It will not, right?
> > It's the page pool size of packets that will be inited the same way
> > at the beginning. Which is NAPI_POLL_WEIGHT * 2 =3D=3D 128 packets.
> > Why this number?
>
> Yes, you're right: the next run won't see the modified packet data. The
> 128 pages is because we run the program loop in batches of 64 (like NAPI
> does, the fact that TEST_XDP_BATCH and NAPI_POLL_WEIGHT are the same is
> not a coincidence).
>
> We need 2x because we want enough pages so we can keep running without
> allocating more, and the first batch can still be in flight on a
> different CPU while we're processing batch 2.
>
> I experimented with different values, and 128 was the minimum size that
> didn't have a significant negative impact on performance, and above that
> saw diminishing returns.

I guess it's ok-ish to get stuck with 128.
It will be uapi that we cannot change though.
Are you comfortable with that?

> > Should it be configurable?
> > Then the user can say: init N packets with this one pattern
> > and the program will know that exactly N invocation will be
> > with the same data, but N+1 it will see the 1st packet again
> > that potentially was modified by the program.
> > Is it accurate?
>
> I thought about making it configurable, but the trouble is that it's not
> quite as straight-forward as the first N packets being "pristine": it
> depends on what happens to the packet afterwards:
>
> On XDP_DROP, the page will be recycled immediately, whereas on
> XDP_{TX,REDIRECT} it will go through the egress driver after sitting in
> the bulk queue for a little while, so you can get reordering compared to
> the original execution order.
>
> On XDP_PASS the kernel will release the page entirely from the pool when
> building an skb, so you'll never see that particular page again (and
> eventually page_pool will allocate a new batch that will be
> re-initialised to the original value).

That all makes sense. Thanks for explaining.
Please document it and update the selftest.
Looks like XDP_DROP is not tested.
Single packet TX and REDIRECT is imo too weak to give
confidence that the mechanism will not explode with millions of packets.

> If we do want to support a "pristine data" mode, I think the least
> cumbersome way would be to add a flag that would make the kernel
> re-initialise the packet data before every program invocation. The
> reason I didn't do this was because I didn't have a use case for it. The
> traffic generator use case only rewrites a tiny bit of the packet
> header, and it's just as easy to just keep rewriting it without assuming
> a particular previous value. And there's also the possibility of just
> calling bpf_prog_run() multiple times from userspace with a lower number
> of repetitions...
>
> I'm not opposed to adding such a flag if you think it would be useful,
> though. WDYT?

reinit doesn't feel necessary.
How one would use this interface to send N different packets?
The api provides an interface for only one.
It will be copied 128 times, but the prog_run call with repeat=3D1
will invoke bpf prog only once, right?
So technically doing N prog_run commands with different data
and repeat=3D1 will achieve the result, right?
But it's not efficient, since 128 pages and 128 copies will be
performed each time.
May be there is a use case for configurable page_pool size?
