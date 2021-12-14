Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737DF473BAE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhLNDp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhLNDp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:45:56 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5B2C061574;
        Mon, 13 Dec 2021 19:45:56 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u17so12627332plg.9;
        Mon, 13 Dec 2021 19:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PgbHHtTdNIFPdqEnwjlkMucmLw256kG+mIvre/j94QU=;
        b=AL7d4Ydxk7bSZziu6LLpX29tzE/Esfr2Ipcu9G/solh2EaRQLZOSgi1d46/CQibMDO
         Hw6vO8zmBCtZh/tWRzvLj+kS8ynJiI9Uz/PykIK3frX6UJmnFNGXJLWoxe6LeuSL7/mK
         3VarUHZhfVvfppLrpPKttG9QuUhkWoJC+W118pLlXWjeoZMxHyNp7+kgDNlisZdEJerM
         ccPUpwBNNkLSmx+kHa9tYwgySyQzbMs8xObLxJPyuioI+TakEyKidyfggBSU6xS7lu0x
         gMqYRCM1nm9DyGToG9DLpg1wP/BcMh3EhsBPt+tK2R3fVEoPgeaB0Ll1kq37BLcox2w9
         U+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PgbHHtTdNIFPdqEnwjlkMucmLw256kG+mIvre/j94QU=;
        b=T7CIWnkHJPlYsulXhVlEOEcQ+2gBOyUyN1CjSRyQ1FwivCr85OV3Pjgws180+7a7se
         Nm8jf1B9dLv5vz3sNrkK26roWqdVtA4OtKZGuIoBzoMdCC+EDuSjbZnl5RUt8HNWRN2z
         +oFRPcF9yJidQq7KgYTORDrH4dQiWlYGXArMkSg5dUVQk8ZEPFFbRHe5IIry9MCnqUdK
         bcM5unwAAVm0iSStlGK+1swlqOFTLVPxAZGeyFz9PgN5cLGlzz3sNti5gL87AYJIepB3
         NGaFkz9w/pblBckyxvxlyJrA0rGulxMDlxy7INao5a4kZfnKTvXXd9PErG2ZQicQcvHv
         1Keg==
X-Gm-Message-State: AOAM530gHPf5m1rNVGgPTmG92LttorbVdKrM3gnC8av3Qgjs+wSjixJw
        jVuxRs6j+e/aHFI9xXVO28McOglM+34gSLQlL2g=
X-Google-Smtp-Source: ABdhPJyNqa2MXeHPyCpOARm+AntkZ98VFZZ015s5cSmRVS+C++5bGcyCrP/iR6DCQUUau0ZMBtTcNusEirljiyLrskA=
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr2789979pja.122.1639453555873;
 Mon, 13 Dec 2021 19:45:55 -0800 (PST)
MIME-Version: 1.0
References: <20211211184143.142003-1-toke@redhat.com> <20211211184143.142003-7-toke@redhat.com>
 <CAADnVQJYfyHs41H1x-1wR5WVSX+3ju69XMUQ4id5+1DLkTVDkg@mail.gmail.com>
 <87tufceaid.fsf@toke.dk> <CAADnVQJunh7KTKJe3F_tO0apqLHtOMFqGAB-V28ORh6o5JUTUQ@mail.gmail.com>
 <87fsqwyqdf.fsf@toke.dk>
In-Reply-To: <87fsqwyqdf.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Dec 2021 19:45:44 -0800
Message-ID: <CAADnVQKRAFCqUj9J8B5cM4u=wS-0Kh9YZYR=QqT6GiiX3ZXXDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 6/8] bpf: Add XDP_REDIRECT support to XDP for bpf_prog_run()
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

On Mon, Dec 13, 2021 at 4:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Mon, Dec 13, 2021 at 8:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> >> >> +
> >> >> +static void bpf_test_run_xdp_teardown(struct bpf_test_timer *t)
> >> >> +{
> >> >> +       struct xdp_mem_info mem =3D {
> >> >> +               .id =3D t->xdp.pp->xdp_mem_id,
> >> >> +               .type =3D MEM_TYPE_PAGE_POOL,
> >> >> +       };
> >> >
> >> > pls add a new line.
> >> >
> >> >> +       xdp_unreg_mem_model(&mem);
> >> >> +}
> >> >> +
> >> >> +static bool ctx_was_changed(struct xdp_page_head *head)
> >> >> +{
> >> >> +       return (head->orig_ctx.data !=3D head->ctx.data ||
> >> >> +               head->orig_ctx.data_meta !=3D head->ctx.data_meta |=
|
> >> >> +               head->orig_ctx.data_end !=3D head->ctx.data_end);
> >> >
> >> > redundant ()
> >> >
> >> >>         bpf_test_timer_enter(&t);
> >> >>         old_ctx =3D bpf_set_run_ctx(&run_ctx.run_ctx);
> >> >>         do {
> >> >>                 run_ctx.prog_item =3D &item;
> >> >> -               if (xdp)
> >> >> +               if (xdp && xdp_redirect) {
> >> >> +                       ret =3D bpf_test_run_xdp_redirect(&t, prog,=
 ctx);
> >> >> +                       if (unlikely(ret < 0))
> >> >> +                               break;
> >> >> +                       *retval =3D ret;
> >> >> +               } else if (xdp) {
> >> >>                         *retval =3D bpf_prog_run_xdp(prog, ctx);
> >> >
> >> > Can we do this unconditionally without introducing a new uapi flag?
> >> > I mean "return bpf_redirect()" was a nop under test_run.
> >> > What kind of tests might break if it stops being a nop?
> >>
> >> Well, I view the existing mode of bpf_prog_test_run() with XDP as a wa=
y
> >> to write XDP unit tests: it allows you to submit a packet, run your XD=
P
> >> program on it, and check that it returned the right value and did the
> >> right modifications. This means if you XDP program does 'return
> >> bpf_redirect()', userspace will still get the XDP_REDIRECT value and s=
o
> >> it can check correctness of your XDP program.
> >>
> >> With this flag the behaviour changes quite drastically, in that it wil=
l
> >> actually put packets on the wire instead of getting back the program
> >> return. So I think it makes more sense to make it a separate opt-in
> >> mode; the old behaviour can still be useful for checking XDP program
> >> behaviour.
> >
> > Ok that all makes sense.
>
> Great!
>
> > How about using prog_run to feed the data into proper netdev?
> > XDP prog may or may not attach to it (this detail is tbd) and
> > prog_run would use prog_fd and ifindex to trigger RX (yes, receive)
> > in that netdev. XDP prog will execute and will be able to perform
> > all actions (not only XDP_REDIRECT).
> > XDP_PASS would pass the packet to the stack, etc.
>
> Hmm, that's certainly an interesting idea! I don't think we can actually
> run the XDP hook on the netdev itself (since that is deep in the
> driver), but we can emulate it: we just need to do what this version of
> the patch is doing, but add handling of the other return codes.
>
> XDP_PASS could be supported by basically copying what cpumap is doing
> (turn the frames into skbs and call netif_receive_skb_list()), but
> XDP_TX would have to be implemented via ndo_xdp_xmit(), so it becomes
> equivalent to a REDIRECT back to the same interface. That's probably OK,
> though, right?

Yep. Something like this.
imo the individual BPF_F_TEST_XDP_DO_REDIRECT knob doesn't look right.
It's tweaking the prog run from no side effects execution model
to partial side effects.
If we want to run xdp prog with side effects it probably should
behave like normal execution on the netdev when it receives the packet.
We might not even need to create a new netdev for that.
I can imagine a bpf_prog_run operating on eth0 with a packet prepared
by the user space.
Like injecting a packet right into the driver and xdp part of it.
If prog says XDP_PASS the packet will go up the stack like normal.
So this mechanism could be used to inject packets into the stack.
Obviously buffer management is an issue in the traditional NIC
when a packet doesn't come from the wire.
Also doing this in every driver would be a pain.
So we need some common infra to inject the user packet into a netdev
like it was received by this netdev. It could be a change for tuntap
or for veth or not related to netdev at all.
After XDP_PASS it doesn't need to be fast. skb will get allocated
and the stack might see it as it arrived from ifindex=3DN regardless
of the HW of that netdev.
XDP_TX would xmit right out of that ifindex=3Dnetdev.
and XDP_REDIRECT would redirect to a different netdev.
At the end there will be less special cases and page_pool tweaks.
Thought the patches 1-5 look fine, it still feels a bit custom
just for this particular BPF_F_TEST_XDP_DO_REDIRECT use case.
With more generic bpf_run_prog(xdp_prog_fd, ifindex_of_netdev)
it might reduce custom handling.
