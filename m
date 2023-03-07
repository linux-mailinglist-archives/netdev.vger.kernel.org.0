Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE3C6AF673
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjCGUMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjCGUME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:12:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBA29DE0D;
        Tue,  7 Mar 2023 12:11:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pZdfA-0003Ur-M0; Tue, 07 Mar 2023 21:11:56 +0100
Date:   Tue, 7 Mar 2023 21:11:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets
 in BPF
Message-ID: <20230307201156.GF13059@breakpoint.cc>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
 <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain>
 <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
 <20230228231716.a5uwc4tdo3kjlkg7@aviatrix-fedora.tail1b9c7.ts.net>
 <CAADnVQKK+a_0effQW5qBSq1AXoQOJg5-79q3d1NWJ2Vv8SHvOw@mail.gmail.com>
 <20230307194801.mopwvidrkrybm7h5@kashmir.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307194801.mopwvidrkrybm7h5@kashmir.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> From my reading (I'll run some tests later) it looks like netfilter
> will defrag all ipv4/ipv6 packets in any netns with conntrack enabled.
> It appears to do so in NF_INET_PRE_ROUTING.

Yes, and output.

> One thing we would need though are (probably kfunc) wrappers around
> nf_defrag_ipv4_enable() and nf_defrag_ipv6_enable() to ensure BPF progs
> are not transitively depending on defrag support from other netfilter
> modules.
>
> The exact mechanism would probably need some thinking, as the above
> functions kinda rely on module_init() and module_exit() semantics. We
> cannot make the prog bump the refcnt every time it runs -- it would
> overflow.  And it would be nice to automatically free the refcnt when
> prog is unloaded.

Probably add a flag attribute that is evaluated at BPF_LINK time, so
progs can say they need defrag enabled.  Same could be used to request
conntrack enablement.

Will need some glue on netfilter side to handle DEFRAG=m, but we already
have plenty of those.
