Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162AB5A9402
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiIAKOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiIAKOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:14:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E96C1321C2;
        Thu,  1 Sep 2022 03:14:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oThCz-0001ZC-AI; Thu, 01 Sep 2022 12:14:01 +0200
Date:   Thu, 1 Sep 2022 12:14:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <20220901101401.GC4334@breakpoint.cc>
References: <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc>
 <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc>
 <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 8/31/22 7:26 PM, Alexei Starovoitov wrote:
> > On Wed, Aug 31, 2022 at 8:53 AM Florian Westphal <fw@strlen.de> wrote:
> > As a minimum we shouldn't step on the same rakes.
> > xt_ebpf would be the same dead code as xt_bpf.
> 
> +1, and on top, the user experience will just be horrible. :(

Compared to what?

> > > If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
> > > as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
> > > but it will take significantly longer to get there.
> > > 
> > > It involves reviving
> > > https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/
> > 
> > I missed it earlier. What is the end goal ?
> > Optimize nft run-time with on the fly generation of bpf byte code ?
> 
> Or rather to provide a pendant to nft given existence of xt_bpf, and the
> latter will be removed at some point? (If so, can't we just deprecate the
> old xt_bpf?)

See my reply to Alexey, immediate goal was to get rid of the indirect
calls by providing a tailored/jitted equivalent of nf_hook_slow().

The next step could be to allow implementation of netfilter hooks
(i.e., kernel modules that call nf_register_net_hook()) in bpf
but AFAIU it requires addition of BPF_PROG_TYPE_NETFILTER etc.

After that, yes, one could think about how to jit nft_do_chain() and
all the rest of the nft machinery.
