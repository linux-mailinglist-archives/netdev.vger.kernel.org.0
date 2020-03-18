Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FE41893DE
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCRCD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:03:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37970 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgCRCD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 22:03:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id t13so1506940wmi.3;
        Tue, 17 Mar 2020 19:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FABasMwMskF7foIZI74WnbbUanagtErXSwxfbZA1fzE=;
        b=ug4fGgOg5X8gtg6iHr63X5hKzVmpphbqE+gf7qUbPloiEreLQE/cIy64WDkNT5OdyM
         kt8W/Swfnq8S60xkLuJWfdPoOEjfOZ/TBWtos3ZS423a3A3lkXFGXuiynHVKFd9wtqGA
         RCZZPJDjln7okgrleBJuG8Ex79qEq+OFAXrWYt5FaWf3JY5ms4duqQ9qfK685vnYu6rG
         puAvxbUsZjFrqSWLWb6sXMrcACDdkRXQozoNhwOWLJ1EPYdmDbDYmlnqBoPIpPFxvhnj
         FoyAFebEQYtPktOuPeZEEjrIxnaCcb/Nw+PkkSqBcQQmmP9miGoFQynUxyI4vL6XZ5GF
         Vi6Q==
X-Gm-Message-State: ANhLgQ3AmQcZGZ9EWlT95s3Ha20t+AUS6wTeWHyikid7oHM8zLTXs2dJ
        PKDiMQ92hKtcB/49EPIBqYXfgESN3VSAHuaKl00=
X-Google-Smtp-Source: ADFU+vsw82WXRu0BqjkZhF7t+00pdye6vztVtWOdcHEdze2KolKLSoWmR0SfOIvjUW7sIp/JtISdahlGzpzoDpiaQOs=
X-Received: by 2002:a7b:cb50:: with SMTP id v16mr2074239wmj.74.1584497037073;
 Tue, 17 Mar 2020 19:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp> <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
 <CACAyw9_zt-wetBiFWXtpQOOv79QCFR12dA9jx1UDEya=0_poyQ@mail.gmail.com> <CAOftzPjeO4QJJnOBHjhzDmJRwqRztYaHLuKEOB_7a4KwDxgAHw@mail.gmail.com>
In-Reply-To: <CAOftzPjeO4QJJnOBHjhzDmJRwqRztYaHLuKEOB_7a4KwDxgAHw@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Tue, 17 Mar 2020 19:03:45 -0700
Message-ID: <CAOftzPj+H1fep3D2E=zZr_ys=cdwT9Ci7=evHQirzc8C6toqfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Martin KaFai Lau <kafai@fb.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 6:10 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> On Tue, Mar 17, 2020 at 3:10 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Tue, 17 Mar 2020 at 03:06, Joe Stringer <joe@wand.net.nz> wrote:
> > >
> > > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > > > >
> > > > > This helper requires the BPF program to discover the socket via a call
> > > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > > > helper takes its own reference to the socket in addition to any existing
> > > > > reference that may or may not currently be obtained for the duration of
> > > > > BPF processing. For the destination socket to receive the traffic, the
> > > > > traffic must be routed towards that socket via local route, the socket
> > > > I also missed where is the local route check in the patch.
> > > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> > >
> > > This is a requirement for traffic redirection, it's not enforced by
> > > the patch. If the operator does not configure routing for the relevant
> > > traffic to ensure that the traffic is delivered locally, then after
> > > the eBPF program terminates, it will pass up through ip_rcv() and
> > > friends and be subject to the whims of the routing table. (or
> > > alternatively if the BPF program redirects somewhere else then this
> > > reference will be dropped).
> >
> > Can you elaborate what "an appropriate routing configuration" would be?
> > I'm not well versed with how routing works, sorry.
>
> [...]
>
> > Do you think being subject to the routing table is desirable, or is it an
> > implementation trade-off?
>
> I think it's an implementation trade-off.

Perhaps it's worth expanding on this a bit more. There's always the
tradeoff of solving your specific problem vs. introducing
functionality that will integrate with the rest of the stack. In some
sense, I would like a notion here of "shortcut this traffic directly
to the socket", it will solve my problem but it's quite specific to
that so there's not much room for sharing the usage. It could still be
very useful to some use cases, but alternatives may support use cases
you hadn't thought of in the first place. Maybe there's a more
incremental path to achieving my goal through an implementation like
this.

The current design of bpf_sk_assign() in this series defers to the
stack a bit more than alternatives may do (thinking eg a socket
redirect function "bpf_sk_redirect()"). It says "this is best-effort";
if you wanted to, you could still override this functionality with
iptables tproxy rules. You could choose to route the traffic
differently (although through the exploration with Martin above for
now this will have fairly limited options unless we make additional
changes..). Glancing through the existing eBPF API, you could assign
the socket to the skb then subsequently use things like
bpf_get_socket_cookie() to fetch the cookie out. For all I know,
someone will come up with some nifty future idea that makes use of the
idea "we associate the socket with the skb" to solve a use case I
haven't thought of, and that could exist either within the bpf@tc hook
or after.
