Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB51C2099
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEAW34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAW3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:29:55 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51682C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:29:54 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b1so9167075qtt.1
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+DabZJOp6Cexn/f41XQR3htli+9HCS0l3bnKTJKvdHI=;
        b=tTyFKPN4+fZvg1Gxat7aaj0OCLqm/z99jcN5Y6U175jUvnrJJdfX7JnMJq90NJQAv2
         lEMS06FlESuU7DAQ0ena9XwlAcy4uKg3+w69iJd7wxL5PGBOR6T8a5+RuFdxfjlDm1aL
         KwC+BoFbLK3sVokYyX7m9UHtHHuCIfXMJIchknDLSaAfr7YVLGsCEzJrWwGpghzcLQkE
         2nbS6MH0tR/5xakjsOabiUtG72UWPBVOZnDjMrGrxiJ8azh8JqkhoNYY5uJGYuaaOPlv
         SBP9CL3N8PQFOjsCIMXUPgVyjv15Uxc+avtZpmM1tyCT0I5jWcnuj/bHqdl5hj/dvi1K
         6K3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+DabZJOp6Cexn/f41XQR3htli+9HCS0l3bnKTJKvdHI=;
        b=CA0OAOhdvRh4QU3SxI0n7E0KMdJchNkZnWzLaSJwIPsShSjWJAhgYMFpiVKh6CZ4e2
         Au++WQbwzHdeVju9D1pLXqaVENGyCK/FHpxuXldVE9ZSDcYwPfq8lT2viSVdlESuCzNh
         pwO+UI7g2cA/lxq2hjJ8IwdaFRldm9owWSn1IcWts72i2vkofUNY9b+dty9YO265aEpR
         LtzlJAN6N57OkT23iRWc3Swav8xxBkPOK3uiwA6iiU9nXJjfi4InpCZ92YAHjW0ox5SZ
         ww1FtSt4Af/Ft3cNbQhA5Be5zv+Ef5/etcZt8SypkHv+CQYEzgUcXDazakIBYllE7f8D
         KlIg==
X-Gm-Message-State: AGi0PuYF4zNAo/vp0U00/BRzgbjF9yFHPXrpUhkc+tIfsG/gJRpDtcMx
        /afbCXPKC3oPpylfNzZvfWbzEKZGWD6ioWeVphHEFA==
X-Google-Smtp-Source: APiQypIbmNOaH56AXqMNgiPNPimx01Gd3fwZc+/CfUcw5afQm1EFcFAx6tejRmhvo9GaXfu4MAyqz7oWA2T0tdcWOMI=
X-Received: by 2002:ac8:3102:: with SMTP id g2mr6072496qtb.349.1588372193216;
 Fri, 01 May 2020 15:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200430233152.199403-1-sdf@google.com> <20200501215202.GA72448@rdna-mbp.dhcp.thefacebook.com>
 <CAKH8qBtcC7PhWOYLZKP7WeGjP4fY0u_DRQcDi51JkY2otcRYiw@mail.gmail.com> <20200501221615.GA27307@rdna-mbp>
In-Reply-To: <20200501221615.GA27307@rdna-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 1 May 2020 15:29:42 -0700
Message-ID: <CAKH8qBtcrPFQ-SimQ2fANc517fMGBuEiQpoRkn03d35z40i2LA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct bpf_sock_addr
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 1, 2020 at 3:16 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> [Fri, 2020-05-01 15:07 -0700]:
> > On Fri, May 1, 2020 at 2:52 PM Andrey Ignatov <rdna@fb.com> wrote:
> > >
> > > Stanislav Fomichev <sdf@google.com> [Thu, 2020-04-30 16:32 -0700]:
> > > > Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
> > > > 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> > > > Let's generalize them and make them available for 'struct bpf_sock_addr'.
> > > > That way, in the future, we can allow those helpers in more places.
> > > >
> > > > As an example, let's expose those 'struct bpf_sock_addr' based helpers to
> > > > BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
> > > > connection is made.
> > > >
> > > > v3:
> > > > * Expose custom helpers for bpf_sock_addr context instead of doing
> > > >   generic bpf_sock argument (as suggested by Daniel). Even with
> > > >   try_socket_lock that doesn't sleep we have a problem where context sk
> > > >   is already locked and socket lock is non-nestable.
> > > >
> > > > v2:
> > > > * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> > > >
> > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > >
> > > ...
> > >
> > > >  SEC("cgroup/connect4")
> > > >  int connect_v4_prog(struct bpf_sock_addr *ctx)
> > > >  {
> > > > @@ -66,6 +108,10 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
> > > >
> > > >       bpf_sk_release(sk);
> > > >
> > > > +     /* Rewrite congestion control. */
> > > > +     if (ctx->type == SOCK_STREAM && set_cc(ctx))
> > > > +             return 0;
> > >
> > > Hi Stas,
> > >
> > > This new check breaks one of tests in test_sock_addr:
> > >
> > >         root@arch-fb-vm1:/home/rdna/bpf-next/tools/testing/selftests/bpf ./test_sock_addr.sh
> > >         ...
> > >         (test_sock_addr.c:1199: errno: Operation not permitted) Fail to connect to server
> > >         Test case: connect4: rewrite IP & TCP port .. [FAIL]
> > >         ...
> > >         Summary: 34 PASSED, 1 FAILED
> > >
> > > What the test does is it sets up TCPv4 server:
> > >
> > >         [pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 6
> > >         [pid   386] bind(6, {sa_family=AF_INET, sin_port=htons(4444), sin_addr=inet_addr("127.0.0.1")}, 128) = 0
> > >         [pid   386] listen(6, 128)              = 0
> > >
> > > Then tries to connect to a fake IPv4:port and this connect4 program
> > > should redirect it to that TCP server, but only if every field in
> > > context has expected value.
> > >
> > > But after that commit program started denying the connect:
> > >
> > >         [pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 7
> > >         [pid   386] connect(7, {sa_family=AF_INET, sin_port=htons(4040), sin_addr=inet_addr("192.168.1.254")}, 128) = -1 EPERM (Operation not permitted)
> > >         (test_sock_addr.c:1201: errno: Operation not permitted) Fail to connect to server
> > >         Test case: connect4: rewrite IP & TCP port .. [FAIL]
> > >
> > > I verified that commenting out this new `if` fixes the problem, but
> > > haven't spent time root-causing it. Could you please look at it?
> > Could you please confirm that you have CONFIG_TCP_CONG_DCTCP=y in your kernel
> > config? (I've added it to tools/testing/selftests/bpf/config)
> > The test is now flipping CC to dctcp and back to default cubic. It can
> > fail if dctcp is not compiled in.
>
> Right. Martin asked same question and indeed my testing VM didn't have
> dctcp enabled. With dctcp enabled it works fine.
>
> I'm totally fine to keep dctcp enabled in my config or start using
> tools/testing/selftests/bpf/config (I've always used my own config).
>
> Another options can be to switch from dctcp to more widely-used reno in
> the program (I tested, this works as well), or even check
> net/ipv4/tcp_available_congestion_control and use a pair of whatever cc
> available there, but up to you / BPF mainteiners really, as I said I'm
> personally fine to just enable dctcp.
Hm, good point, reno is always compiled in, I didn't think about it.
Let me prepare a patch to do s/dctcp/reno/ in that test, thanks!
