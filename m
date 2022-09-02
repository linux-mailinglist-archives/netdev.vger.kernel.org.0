Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8055AB7CC
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiIBRwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 13:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiIBRw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:52:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E36BA45F;
        Fri,  2 Sep 2022 10:52:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oUAq0-0003WX-SU; Fri, 02 Sep 2022 19:52:16 +0200
Date:   Fri, 2 Sep 2022 19:52:16 +0200
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
Message-ID: <20220902175216.GB4165@breakpoint.cc>
References: <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc>
 <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc>
 <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net>
 <20220901101401.GC4334@breakpoint.cc>
 <CAADnVQJUDcahx2R58zEPNi_uRdgUNtKKUTqndDY-NVd03pB_+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJUDcahx2R58zEPNi_uRdgUNtKKUTqndDY-NVd03pB_+Q@mail.gmail.com>
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
> > See my reply to Alexey, immediate goal was to get rid of the indirect
> > calls by providing a tailored/jitted equivalent of nf_hook_slow().
> >
> > The next step could be to allow implementation of netfilter hooks
> > (i.e., kernel modules that call nf_register_net_hook()) in bpf
> > but AFAIU it requires addition of BPF_PROG_TYPE_NETFILTER etc.
> 
> We were adding new prog and maps types in the past.
> Now new features are being added differently.
> All of the networking either works with sk_buff-s or xdp frames.
> We try hard not to add any new uapi helpers.
> Everything is moving to kfuncs.
> Other sub-systems should be able to use bpf without touching
> the bpf core. See hid-bpf as an example.
> It needs several verifier improvements, but doesn't need
> new prog types, helpers, etc.

I don't see how it can be done without a new prog type, the bpf progs
would need access to "nf_hook_state" struct, passed as argument
to nf_hook_slow() (and down to the individual xt_foo modules...).

We can't change the existing netfilter hook prototype to go by
sk_buff * as that doesn't have all information, most prominent are
the input and output net_device, but also okfn is needed for async
reinject (nf_queue), the hook location and so on.

> > After that, yes, one could think about how to jit nft_do_chain() and
> > all the rest of the nft machinery.
> 
> Sounds like a ton of work. All that just to accelerate nft a bit?
> I think there are more impactful projects to work on.
> For example, accelerating classic iptables with bpf would immediately
> help a bunch of users.

Maybe, but from the problem points and the required effort it doesn't matter
if the chosen target is iptables or nftables; as far as the time/effort
needed I'd say they are identical.

The hard issues that need to be solved first are the same; they reside
in the netfilter core and not in the specific interpreter (nft_do_chain
vs. ipt_do_table and friends).

nf_tables might be *slightly* easier once that point would be reached
because the core functionality is more integrated with nf_tables whereas
in iptables there is more copypastry (ipt_do_table, ip6t_do_table,
ebt_do_table, ...).
