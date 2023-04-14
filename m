Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8636E2123
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjDNKlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjDNKla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:41:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8143E1FE0;
        Fri, 14 Apr 2023 03:41:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pnGrp-0000ve-Em; Fri, 14 Apr 2023 12:41:21 +0200
Date:   Fri, 14 Apr 2023 12:41:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v2 5/6] tools: bpftool: print netfilter link info
Message-ID: <20230414104121.GB5889@breakpoint.cc>
References: <20230413133228.20790-1-fw@strlen.de>
 <20230413133228.20790-6-fw@strlen.de>
 <CACdoK4LRjNsDY6m2fvUGY_C9gMvUdX9QpEetr9RtGuR8xb8pmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACdoK4LRjNsDY6m2fvUGY_C9gMvUdX9QpEetr9RtGuR8xb8pmg@mail.gmail.com>
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
> On Thu, 13 Apr 2023 at 14:36, Florian Westphal <fw@strlen.de> wrote:
> >
> > Dump protocol family, hook and priority value:
> > $ bpftool link
> > 2: type 10  prog 20
> 
> Could you please update link_type_name in libbpf (libbpf.c) so that we
> display "netfilter" here instead of "type 10"?

Done.

> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 3823100b7934..c93febc4c75f 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -986,6 +986,7 @@ enum bpf_prog_type {
> >         BPF_PROG_TYPE_LSM,
> >         BPF_PROG_TYPE_SK_LOOKUP,
> >         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> > +       BPF_PROG_TYPE_NETFILTER,
> 
> If netfilter programs could be loaded with bpftool, we'd need to
> update bpftool's docs. But I don't think this is the case, right?

bpftool prog load nftest.o /sys/fs/bpf/nftest

will work, but the program isn't attached anywhere.

> don't currently have a way to pass the pf, hooknum, priority and flags
> necessary to load the program with "bpftool prog load" so it would
> fail?

I don't know how to make it work to actually attach it, because
the hook is unregistered when the link fd is closed.

So either bpftool would have to fork and auto-daemon (maybe
unexpected...) or wait/block until CTRL-C.

This also needs new libbpf api AFAICS because existing bpf_link
are specific to the program type, so I'd have to add something like:

struct bpf_link *
bpf_program__attach_netfilter(const struct bpf_program *prog,
			      const struct bpf_netfilter_opts *opts)

Advice welcome.

> Have you considered listing netfilter programs in the output of
> "bpftool net" as well? Given that they're related to networking, it
> would maybe make sense to have them listed alongside XDP, TC, and flow
> dissector programs?

I could print the same output that 'bpf link' already shows.

Not sure on the real distinction between those two here.

When should I use 'bpftool link' and when 'bpftool net', and what info
and features should either of these provide for netfilter programs?
