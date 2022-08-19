Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5600E5993B3
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 05:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245206AbiHSDrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 23:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbiHSDrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 23:47:00 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4073CAC85;
        Thu, 18 Aug 2022 20:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660880818; x=1692416818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nW+dY49amouhSKzpEHngnFRlbzuI/sw1F1OJbAyXdYU=;
  b=DiRjfUcmCKnu3aZ0J0QXy1U33JnhHYml0q7bC3fZrj39iRT0zCgE4xVB
   R5qUNlVPpRVtLIzz2eOU1OM6pC7pS22K7w6Bw8SBHs5vl+Pu/iSnu4zIS
   4K9ulDB3kcxSS3ifzD/fJxUv9zMjzgJj4vq+pIWOQsc7m7mBxbL1HNhbN
   E=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="231420974"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 03:46:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 9A4511A1105;
        Fri, 19 Aug 2022 03:46:46 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 19 Aug 2022 03:46:46 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.201) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 19 Aug 2022 03:46:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf 1/4] bpf: Fix data-races around bpf_jit_enable.
Date:   Thu, 18 Aug 2022 20:46:35 -0700
Message-ID: <20220819034635.67875-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAADnVQJHdxu43rPgpfQ-ezR-Vt3xW2YP7SXUayfoEg+3BCps5w@mail.gmail.com>
References: <CAADnVQJHdxu43rPgpfQ-ezR-Vt3xW2YP7SXUayfoEg+3BCps5w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.201]
X-ClientProxiedBy: EX13D48UWB001.ant.amazon.com (10.43.163.80) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 20:27:49 -0700
> On Thu, Aug 18, 2022 at 6:15 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Date:   Thu, 18 Aug 2022 18:05:44 -0700
> > > On Thu, Aug 18, 2022 at 5:56 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > Date:   Thu, 18 Aug 2022 17:13:25 -0700
> > > > > On Thu, Aug 18, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > >
> > > > > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > > > Date:   Thu, 18 Aug 2022 15:49:46 -0700
> > > > > > > On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > > >
> > > > > > > > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > > > > > > > always a chance of data-race.  So, all readers and a writer need some
> > > > > > > > basic protection to avoid load/store-tearing.
> > > > > > > >
> > > > > > > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > > ---
> > > > > > > >  arch/arm/net/bpf_jit_32.c        | 2 +-
> > > > > > > >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> > > > > > > >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> > > > > > > >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> > > > > > > >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> > > > > > > >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> > > > > > > >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> > > > > > > >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> > > > > > > >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> > > > > > > >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> > > > > > > >  include/linux/filter.h           | 2 +-
> > > > > > > >  net/core/sysctl_net_core.c       | 4 ++--
> > > > > > > >  12 files changed, 19 insertions(+), 16 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > > > > > > > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > > > > > > > --- a/arch/arm/net/bpf_jit_32.c
> > > > > > > > +++ b/arch/arm/net/bpf_jit_32.c
> > > > > > > > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > > > > > > >         }
> > > > > > > >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> > > > > > > >
> > > > > > > > -       if (bpf_jit_enable > 1)
> > > > > > > > +       if (READ_ONCE(bpf_jit_enable) > 1)
> > > > > > >
> > > > > > > Nack.
> > > > > > > Even if the compiler decides to use single byte loads for some
> > > > > > > odd reason there is no issue here.
> > > > > >
> > > > > > I see, and same for 2nd/3rd patches, right?
> > > > > >
> > > > > > Then how about this part?
> > > > > > It's not data-race nor problematic in practice, but should the value be
> > > > > > consistent in the same function?
> > > > > > The 2nd/3rd patches also have this kind of part.
> > > > >
> > > > > The bof_jit_enable > 1 is unsupported and buggy.
> > > > > It will be removed eventually.
> > > >
> > > > Ok, then I'm fine with no change.
> > > >
> > > > >
> > > > > Why are you doing these changes if they're not fixing any bugs ?
> > > > > Just to shut up some race sanitizer?
> > > >
> > > > For data-race, it's one of reason.  I should have made sure the change fixes
> > > > an actual bug, my apologies.
> > > >
> > > > For two reads, I feel buggy that there's an inconsitent snapshot.
> > > > e.g.) in the 2nd patch, bpf_jit_harden == 0 in bpf_jit_blinding_enabled()
> > > > could return true.  Thinking the previous value was 1, it seems to be timing
> > > > issue, but not intuitive.
> > >
> > > it's also used in bpf_jit_kallsyms_enabled.
> > > So the patch 2 doesn't make anything 'intuitive'.
> >
> > Exactly...
> >
> > So finally, should I repost 4th patch or drop it?
> 
> This?
> -       if (atomic_long_add_return(size, &bpf_jit_current) > bpf_jit_limit) {
> +       if (atomic_long_add_return(size, &bpf_jit_current) >
> READ_ONCE(bpf_jit_limit)) {
> 
> same question. What does it fix?

Its size is long, and load tearing [0] could occur by compiler
optimisation.  So, concurrent writes & a teared-read could get
a bigger limit than intended.

        write 0xFFFFFFFF00000000
  teared-read 0xFFFFFFFF
        write 0x00000000FFFFFFFF
  teared-read 0xFFFFFFFFFFFFFFFF

[0]: https://lwn.net/Articles/793253/#Load%20Tearing
