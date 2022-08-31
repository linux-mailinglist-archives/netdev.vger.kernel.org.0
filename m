Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7565F5A88A9
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiHaV6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiHaV6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:58:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E805275C5;
        Wed, 31 Aug 2022 14:57:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTViL-0006Km-UW; Wed, 31 Aug 2022 23:57:37 +0200
Date:   Wed, 31 Aug 2022 23:57:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <20220831215737.GE15107@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc>
 <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc>
 <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > This helps gradually moving towards move epbf for those that
> > still heavily rely on the classic forwarding path.
> 
> No one is using it.
> If it was, we would have seen at least one bug report over
> all these years. We've seen none.

Err, it IS used, else I would not have sent this patch.

> very reasonable early on and turned out to be useless with
> zero users.
> BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
> are in this category.

I doubt it had 0 users.  Those users probably moved to something
better?

> As a minimum we shouldn't step on the same rakes.
> xt_ebpf would be the same dead code as xt_bpf.

Its just 160 LOC or so, I don't see it has a huge technical debt.

> > If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
> > as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
> > but it will take significantly longer to get there.
> >
> > It involves reviving
> > https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/
> 
> I missed it earlier. What is the end goal ?

Immediate goal: get rid of all indirect calls from NF_HOOK()
invocations. Its about 2% speedup in my tests (with connection
tracking+defrag enabled).

This series changes prototype of the callbacks to int foo(struct *),
so I think it would be possible to build on this and allow attaching raw
bpf progs/implement what is now a netfilter kernel module as a bpf
program.

I have not spent time on this so far though, so I don't know yet
how the "please attach prog id 12345 at FORWARD with prio 42" should
be done.

> Optimize nft run-time with on the fly generation of bpf byte code ?

This could be done too, so far this JITs nf_hook_slow() only.
The big question for nft run-time would be how and where to do the JIT
translation.

I think that "nft run time jit" would be step 3, after allowing
(re)implementation of netfilter modules via bpf programs.
