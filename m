Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5365C5991FB
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbiHSA4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240388AbiHSA4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:56:05 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1550DD77C;
        Thu, 18 Aug 2022 17:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660870564; x=1692406564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zvdf/AaPo1uJQbH6I9Y2jGI4gALkFBEP/EUFW7kteUs=;
  b=pY+c+kjt3T7AW4OLVKcsO21EM7hQl5EqoTGG0whlbTyC0SUNMdutOAkR
   BGZyZ3If6M0M56xMEkhvVUP4CxkcqIE2qVk9QXMtmK/51UsrDsDT4z07/
   N/JssjgCzcHSIibsN81ihBf8e23TYQH0qKXIM/6jznx6nTourcNNz/OwU
   I=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="1045836994"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 00:55:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com (Postfix) with ESMTPS id C3722A34CA;
        Fri, 19 Aug 2022 00:55:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 19 Aug 2022 00:55:31 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 19 Aug 2022 00:55:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf 1/4] bpf: Fix data-races around bpf_jit_enable.
Date:   Thu, 18 Aug 2022 17:55:20 -0700
Message-ID: <20220819005520.57894-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAADnVQ+wKkiKo0L5HXiCeqxX+oqegiXBqc7fH+Yj2CG6_ymDKg@mail.gmail.com>
References: <CAADnVQ+wKkiKo0L5HXiCeqxX+oqegiXBqc7fH+Yj2CG6_ymDKg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D35UWC002.ant.amazon.com (10.43.162.218) To
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
Date:   Thu, 18 Aug 2022 17:13:25 -0700
> On Thu, Aug 18, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Date:   Thu, 18 Aug 2022 15:49:46 -0700
> > > On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > > > always a chance of data-race.  So, all readers and a writer need some
> > > > basic protection to avoid load/store-tearing.
> > > >
> > > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > >  arch/arm/net/bpf_jit_32.c        | 2 +-
> > > >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> > > >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> > > >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> > > >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> > > >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> > > >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> > > >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> > > >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> > > >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> > > >  include/linux/filter.h           | 2 +-
> > > >  net/core/sysctl_net_core.c       | 4 ++--
> > > >  12 files changed, 19 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > > > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > > > --- a/arch/arm/net/bpf_jit_32.c
> > > > +++ b/arch/arm/net/bpf_jit_32.c
> > > > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > > >         }
> > > >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> > > >
> > > > -       if (bpf_jit_enable > 1)
> > > > +       if (READ_ONCE(bpf_jit_enable) > 1)
> > >
> > > Nack.
> > > Even if the compiler decides to use single byte loads for some
> > > odd reason there is no issue here.
> >
> > I see, and same for 2nd/3rd patches, right?
> >
> > Then how about this part?
> > It's not data-race nor problematic in practice, but should the value be
> > consistent in the same function?
> > The 2nd/3rd patches also have this kind of part.
> 
> The bof_jit_enable > 1 is unsupported and buggy.
> It will be removed eventually.

Ok, then I'm fine with no change.

> 
> Why are you doing these changes if they're not fixing any bugs ?
> Just to shut up some race sanitizer?

For data-race, it's one of reason.  I should have made sure the change fixes
an actual bug, my apologies.

For two reads, I feel buggy that there's an inconsitent snapshot.
e.g.) in the 2nd patch, bpf_jit_harden == 0 in bpf_jit_blinding_enabled()
could return true.  Thinking the previous value was 1, it seems to be timing
issue, but not intuitive.
