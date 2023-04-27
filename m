Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD6A6F0311
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 11:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243365AbjD0JKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 05:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbjD0JKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 05:10:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DE1E50;
        Thu, 27 Apr 2023 02:10:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1prxdn-0001Ra-5S; Thu, 27 Apr 2023 11:10:15 +0200
Date:   Thu, 27 Apr 2023 11:10:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v5 1/7] bpf: add bpf_link support for
 BPF_NETFILTER programs
Message-ID: <20230427091015.GD3155@breakpoint.cc>
References: <20230421170300.24115-1-fw@strlen.de>
 <20230421170300.24115-2-fw@strlen.de>
 <CAEf4Bzby3gwHmvz1cjcNHKFPA1LQdTq85TpCmOg=GB6=bQwjOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzby3gwHmvz1cjcNHKFPA1LQdTq85TpCmOg=GB6=bQwjOQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > @@ -1560,6 +1562,12 @@ union bpf_attr {
> >                                  */
> >                                 __u64           cookie;
> >                         } tracing;
> > +                       struct {
> > +                               __u32           pf;
> > +                               __u32           hooknum;
> 
> catching up on stuff a bit...
> 
> enum nf_inet_hooks {
>         NF_INET_PRE_ROUTING,
>         NF_INET_LOCAL_IN,
>         NF_INET_FORWARD,
>         NF_INET_LOCAL_OUT,
>         NF_INET_POST_ROUTING,
>         NF_INET_NUMHOOKS,
>         NF_INET_INGRESS = NF_INET_NUMHOOKS,
> };
> 
> So it seems like this "hook number" is more like "hook type", is my
> understanding correct?

What is 'hook type'?

> If so, wouldn't it be cleaner and more uniform
> with, say, cgroup network hooks to provide hook type as
> expected_attach_type? It would also allow to have a nicer interface in
> libbpf, by specifying that as part of SEC():
> 
> SEC("netfilter/pre_routing"), SEC("netfilter/local_in"), etc...

I don't understand how that would help.
Attachment needs a priority and a family (ipv4, arp, etc.).

If we allow netdev type we'll also need an ifindex.
Daniel Xu work will need to pass extra arguments ("please enable ip
defrag").

> Also, it seems like you actually didn't wire NETFILTER link support in
> libbpf completely. See bpf_link_create under tools/lib/bpf/bpf.c, it
> has to handle this new type of link as well. Existing tests seem a bit
> bare-bones for SEC("netfilter"), would it be possible to add something
> that will demonstrate it a bit better and will be actually executed at
> runtime and validated?

I can have a look.
