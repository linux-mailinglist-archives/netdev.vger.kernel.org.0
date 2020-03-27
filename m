Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26425195D17
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgC0RoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:44:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35108 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbgC0RoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 13:44:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id d5so12486489wrn.2;
        Fri, 27 Mar 2020 10:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OtrLhEEuBQztk/nWFtGztbhVqTqnMNrAnlarWEAa1lA=;
        b=RoZImjXiH1zSvKpuEOer3TSDOAX5VfnddkmbsQrPsHKhaXQEJCoBh8JBLVXQDrg5uw
         zjvJH7qMN/gp9iFgBE/9C5Ah7mtYsAm4c7eA36thBlXLtL1pjBA/dbdHsyPknetgjaGC
         sREMl++IQYAi165WnHIPzZa3UPKHP/ZroA9NWnEJTwevPqbBjuKnzWT1XMOtgqgPJMGA
         vi57ugr3qvFO5fzN0QQcmiJ0Oqv5IwgLRW5XD8q88DsDp5kzeRYytVwZopojZE2Qk3fn
         ZykvJiFUy45psUZPN0U8ZfbG0BXegXWBtokccYuV/R/Yvr8ospHqE/M/QVEycYTr3iCr
         jQXw==
X-Gm-Message-State: ANhLgQ2Bch2Q40O5KLrsKycEXe6HpG71Pek66kd9HO0hUZ2v0ntrg3wf
        TJedkhZWFxe3WmSoIpw3PBtrYzNfl/DOsLwNmGQ=
X-Google-Smtp-Source: ADFU+vulBXbiytEStvxainF3jjJtOL/qEbP2CTLlh0qQU7WSzzuXKbJuIvoFIhE5xTMaxlmP3QWXyNsOumvqlxUwoP8=
X-Received: by 2002:adf:f0c5:: with SMTP id x5mr512289wro.415.1585331045556;
 Fri, 27 Mar 2020 10:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200327042556.11560-1-joe@wand.net.nz> <9ee7da2e-3675-9bd2-e317-c86cfa284e85@mojatatu.com>
In-Reply-To: <9ee7da2e-3675-9bd2-e317-c86cfa284e85@mojatatu.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 27 Mar 2020 10:43:38 -0700
Message-ID: <CAOftzPjWtL5a5j3GAJW5SOhWS1Jx43XWSwb7ksTaXC5-sAaw2w@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Roman Mashak <mrv@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 7:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-03-27 12:25 a.m., Joe Stringer wrote:
> > Introduce a new helper that allows assigning a previously-found socket
> > to the skb as the packet is received towards the stack, to cause the
> > stack to guide the packet towards that socket subject to local routing
> > configuration. The intention is to support TProxy use cases more
> > directly from eBPF programs attached at TC ingress, to simplify and
> > streamline Linux stack configuration in scale environments with Cilium.
> >
> > Normally in ip{,6}_rcv_core(), the skb will be orphaned, dropping any
> > existing socket reference associated with the skb. Existing tproxy
> > implementations in netfilter get around this restriction by running the
> > tproxy logic after ip_rcv_core() in the PREROUTING table. However, this
> > is not an option for TC-based logic (including eBPF programs attached at
> > TC ingress).
> >
> > This series introduces the BPF helper bpf_sk_assign() to associate the
> > socket with the skb on the ingress path as the packet is passed up the
> > stack. The initial patch in the series simply takes a reference on the
> > socket to ensure safety, but later patches relax this for listen
> > sockets.
> >
> > To ensure delivery to the relevant socket, we still consult the routing
> > table, for full examples of how to configure see the tests in patch #5;
> > the simplest form of the route would look like this:
> >
> >    $ ip route add local default dev lo
> >
>
> Trying to understand so if we can port our tc action (and upstream),
> we would need to replicate:
>
>   bpf_sk_assign() - invoked everytime we succeed finding the sk
>   bpf_sk_release() - invoked everytime we are done processing the sk

The skb->destructor = sock_pfree() is the balanced other half of
bpf_sk_assign(), so you shouldn't need to explicitly call
bpf_sk_release() to handle the refcounting of the assigned socket.

The `bpf_sk_release()` pairs with BPF socket lookup, so if you already
have other socket lookup code handling the core tproxy logic (looking
up established, then looking up listen sockets with different tuple)
then you're presumably already handling that to avoid leaking
references.

I think that looking at the test_sk_assign.c BPF program in patch 4/5
should give you a good sense for what you'd need in the TC action
logic.
