Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F436E2635
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjDNOuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDNOuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:50:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F91CC1A;
        Fri, 14 Apr 2023 07:49:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pnKjv-0002Vs-P4; Fri, 14 Apr 2023 16:49:27 +0200
Date:   Fri, 14 Apr 2023 16:49:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v2 5/6] tools: bpftool: print netfilter link info
Message-ID: <20230414144927.GA5927@breakpoint.cc>
References: <20230413133228.20790-1-fw@strlen.de>
 <20230413133228.20790-6-fw@strlen.de>
 <CACdoK4LRjNsDY6m2fvUGY_C9gMvUdX9QpEetr9RtGuR8xb8pmg@mail.gmail.com>
 <20230414104121.GB5889@breakpoint.cc>
 <eeeaac99-9053-90c2-aa33-cc1ecb1ae9ca@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeeaac99-9053-90c2-aa33-cc1ecb1ae9ca@isovalent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet <quentin@isovalent.com> wrote:
> 2023-04-14 12:41 UTC+0200 ~ Florian Westphal <fw@strlen.de>
> > Quentin Monnet <quentin@isovalent.com> wrote:
> >> On Thu, 13 Apr 2023 at 14:36, Florian Westphal <fw@strlen.de> wrote:
> >>>
> >>> Dump protocol family, hook and priority value:
> >>> $ bpftool link
> >>> 2: type 10  prog 20
> >>
> >> Could you please update link_type_name in libbpf (libbpf.c) so that we
> >> display "netfilter" here instead of "type 10"?
> > 
> > Done.
> 
> Thanks!
> 
> I'm just thinking we could also maybe print something nicer for the pf
> and the hook, "NF_INET_LOCAL_IN" would be more user-friendly than "hook 1"?

Done.  I've also made the first patch more restrictive wrt. allowed
attachment points and priorities.

Better safe than sorry, we can be more liberal later if there are
use-cases.

v3 will be coming next week.

> > I don't know how to make it work to actually attach it, because
> > the hook is unregistered when the link fd is closed.
> > 
> > So either bpftool would have to fork and auto-daemon (maybe
> > unexpected...) or wait/block until CTRL-C.
> > 
> > This also needs new libbpf api AFAICS because existing bpf_link
> > are specific to the program type, so I'd have to add something like:
> > 
> > struct bpf_link *
> > bpf_program__attach_netfilter(const struct bpf_program *prog,
> > 			      const struct bpf_netfilter_opts *opts)
> > 
> > Advice welcome.
> 
> OK, yes we'd need something like this if we wanted to load and attach
> from bpftool. If you already have the tooling elsewhere, it's maybe not
> necessary to add it here. Depends if you want users to be able to attach
> netfilter programs with bpftool or even libbpf.

[..]

> I'd say let's keep this out of the current patchset anyway. If we have a
> use case for attaching via libbpf/bpftool we can do this as a follow-up.

Sounds good to me.

Quentin Deslandes or Daniel Xu might want/need libbpf support for their
projects.

> The way I see it, "bpftool net" should provide a more structured
> overview of the different programs affecting networking, in particular
> for JSON. The idea would be to display all BPF programs that can affect
> packet processing. See what we have for XDP for example:
> 
> 
>     # bpftool net -p
>     [{
>             "xdp": [{
>                     "devname": "eni88np1",
>                     "ifindex": 12,
>                     "multi_attachments": [{
>                             "mode": "driver",
>                             "id": 1238
>                         },{
>                             "mode": "offload",
>                             "id": 1239
>                         }
>                     ]
>                 }
>             ],
>             "tc": [{
>                     "devname": "eni88np1",
>                     "ifindex": 12,
>                     "kind": "clsact/ingress",
>                     "name": "sample_ret0.o:[.text]",
>                     "id": 1241
>                 },{
>                     "devname": "eni88np1",
>                     "ifindex": 12,
>                     "kind": "clsact/ingress",
>                     "name": "sample_ret0.o:[.text]",
>                     "id": 1240
>                 }
>             ],
>             "flow_dissector": [
>                 "id": 1434
>             ]
>         }
>     ]
> 
> This gives us all the info about XDP programs at once, grouped by device
> when relevant. By contrast, listing them in "bpftool link" would likely
> only show one at a time, in an uncorrelated manner. Similarly, we could
> have netfilter sorted by pf then hook in "bpftool net". If there's more
> relevant info that we get from program info and not from the netfilter
> link, this would also be a good place to have it (but not sure there's
> any info we're missing from "bpftool link"?).

Currently 'bpftool link' shows everything wrt. netfilter bpf programs.

> But given that the info will be close, or identical, if not for the JSON
> structure, I don't mean to impose this to you - it's also OK to just
> skip "bpftool net" for now if you prefer.

I'll probably make 'bpftool net' and 'bpftool link' print identical
netfilter output, I'll check this on Monday (to make sure the formatting
doesn't seem out of place).

Its kinda silly to not have anything netfilter related in 'bpftool
net', this thing isn't named 'linkfilter' after all 8-)
