Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B07666987
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 04:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbjALDRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 22:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbjALDRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 22:17:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C13DED5;
        Wed, 11 Jan 2023 19:17:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pFo5o-0008AG-45; Thu, 12 Jan 2023 04:17:28 +0100
Date:   Thu, 12 Jan 2023 04:17:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Deslandes <qde@naccy.de>
Cc:     Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Kernel Team <kernel-team@meta.com>
Subject: Re: [PATCH bpf-next v3 00/16] bpfilter
Message-ID: <20230112031728.GL27644@breakpoint.cc>
References: <20221224000402.476079-1-qde@naccy.de>
 <20230103114540.GB13151@breakpoint.cc>
 <8773f286-74ba-4efb-4a94-0c1f91d959bd@naccy.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8773f286-74ba-4efb-4a94-0c1f91d959bd@naccy.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Deslandes <qde@naccy.de> wrote:
> Le 03/01/2023 � 12:45, Florian Westphal a �crit�:
> > You can't make this atomic from userspace perspective, the
> > get/setsockopt API of iptables uses a read-modify-write model.
> 
> This refers to updating the programs from bpfilter's side. It won't
> be atomic from iptables point of view, but currently bpfilter will
> remove the program associated to a table, before installing the new
> one. This means packets received in between those operations are
> not filtered. I assume a better solution is possible.

Ah, I see, thanks.

> > Tentatively I'd try to extend libnftnl and generate bpf code there,
> > since its used by both iptables(-nft) and nftables we'd automatically
> > get support for both.
> 
> That's one of the option, this could also remain in the kernel
> tree or in a dedicated git repository. I don't know which one would
> be the best, I'm open to suggestions.

I can imagine that this will see a flurry of activity in the early
phase so I think a 'semi test repo' makes sense.

Provideded license allows this, useable bits and pieces can then
be grafted on to libnftnl (or iptables or whatever).

> > I was planning to look into "attach bpf progs to raw netfilter hooks"
> > in Q1 2023, once the initial nf-bpf-codegen is merged.
> 
> Is there any plan to support non raw hooks? That's mainly out
> of curiosity, I don't even know whether that would be a good thing
> or not.

Not sure what 'non raw hook' is.  Idea was to expose

1. protcocol family
2. hook number (prerouting, input etc)
3. priority

to userspace via bpf syscall/bpf link.

userspace would then provide the above info to kernel via
bpf(... BPF_LINK_CREATE )

which would then end up doing:
--------------
h.hook = nf_hook_run_bpf; // wrapper to call BPF_PROG_RUN
h.priv = prog; // the bpf program to run
h.pf = attr->netfilter.pf;
h.priority = attr->netfilter.priority;
h.hooknum = attr->netfilter.hooknum;

nf_register_net_hook(net, &h);
--------------

After that nf_hook_slow() calls the bpf program just like any
other of the netfilter hooks.

Does that make sense or did you have something else in mind?
