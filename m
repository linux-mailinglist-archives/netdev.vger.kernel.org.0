Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A51599265
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241108AbiHSBPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiHSBPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:15:38 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BDAC7F8F;
        Thu, 18 Aug 2022 18:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660871737; x=1692407737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9D/WE7CLtJkAAxbi1VWImc/EI203ld7eYwJygfODlbE=;
  b=Mh17gIyDdjhjmxqvor+R5qFFYI8vIPB+GI1OONf5jfMIlc1ekOTVmGxM
   zVo+QBq57F6E7NDp2IyXtl6FfiX7cIR3/8myEsP+RJYHXaDw+nT6GtPyg
   C38VsLqPAGGY/Jtc9M8oBWgYuAaAlqeUU4nDjFTfs6AtGioPpQYFynjhT
   0=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="120858632"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 01:15:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 4E5397E1290;
        Fri, 19 Aug 2022 01:15:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 19 Aug 2022 01:15:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 19 Aug 2022 01:15:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf 1/4] bpf: Fix data-races around bpf_jit_enable.
Date:   Thu, 18 Aug 2022 18:15:05 -0700
Message-ID: <20220819011505.58948-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAADnVQ+=F4tHsYi14+z+8WP+T3w9vBUpdUhgq4y9=c4X5NhN_g@mail.gmail.com>
References: <CAADnVQ+=F4tHsYi14+z+8WP+T3w9vBUpdUhgq4y9=c4X5NhN_g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D20UWA003.ant.amazon.com (10.43.160.97) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 18:05:44 -0700
> On Thu, Aug 18, 2022 at 5:56 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Date:   Thu, 18 Aug 2022 17:13:25 -0700
> > > On Thu, Aug 18, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > Date:   Thu, 18 Aug 2022 15:49:46 -0700
> > > > > On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > >
> > > > > > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > > > > > always a chance of data-race.  So, all readers and a writer need some
> > > > > > basic protection to avoid load/store-tearing.
> > > > > >
> > > > > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > ---
> > > > > >  arch/arm/net/bpf_jit_32.c        | 2 +-
> > > > > >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> > > > > >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> > > > > >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> > > > > >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> > > > > >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> > > > > >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> > > > > >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> > > > > >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> > > > > >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> > > > > >  include/linux/filter.h           | 2 +-
> > > > > >  net/core/sysctl_net_core.c       | 4 ++--
> > > > > >  12 files changed, 19 insertions(+), 16 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > > > > > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > > > > > --- a/arch/arm/net/bpf_jit_32.c
> > > > > > +++ b/arch/arm/net/bpf_jit_32.c
> > > > > > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > > > > >         }
> > > > > >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> > > > > >
> > > > > > -       if (bpf_jit_enable > 1)
> > > > > > +       if (READ_ONCE(bpf_jit_enable) > 1)
> > > > >
> > > > > Nack.
> > > > > Even if the compiler decides to use single byte loads for some
> > > > > odd reason there is no issue here.
> > > >
> > > > I see, and same for 2nd/3rd patches, right?
> > > >
> > > > Then how about this part?
> > > > It's not data-race nor problematic in practice, but should the value be
> > > > consistent in the same function?
> > > > The 2nd/3rd patches also have this kind of part.
> > >
> > > The bof_jit_enable > 1 is unsupported and buggy.
> > > It will be removed eventually.
> >
> > Ok, then I'm fine with no change.
> >
> > >
> > > Why are you doing these changes if they're not fixing any bugs ?
> > > Just to shut up some race sanitizer?
> >
> > For data-race, it's one of reason.  I should have made sure the change fixes
> > an actual bug, my apologies.
> >
> > For two reads, I feel buggy that there's an inconsitent snapshot.
> > e.g.) in the 2nd patch, bpf_jit_harden == 0 in bpf_jit_blinding_enabled()
> > could return true.  Thinking the previous value was 1, it seems to be timing
> > issue, but not intuitive.
> 
> it's also used in bpf_jit_kallsyms_enabled.
> So the patch 2 doesn't make anything 'intuitive'.

Exactly...

So finally, should I repost 4th patch or drop it?
