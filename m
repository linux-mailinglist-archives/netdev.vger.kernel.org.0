Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C63599392
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 05:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343730AbiHSD2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 23:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242854AbiHSD2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 23:28:05 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C1ADF670;
        Thu, 18 Aug 2022 20:28:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z2so4167097edc.1;
        Thu, 18 Aug 2022 20:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8w5bqlC3miD54xl7iIppmNvMNfH+gfPS/APFsClxGI4=;
        b=BXZhoMWABR10zM5dMuzBWS9jy+BagrqtuZcrIZfcvPOkTgr/1SVCVmcneMMvfVMAZp
         Zp+pgaA0gMe+o3/R4++06Zp2Vp2dTgEeQON8irSTvzl9THVYbLDxtZYf+mfHmfUV+7+i
         Wv5nyWhulYK81wf+EgHZZYPAseyMtbgQjypCTP6fOeQT8plkR/SH2mAEJA9teQj7b4QF
         xzzuQVsHTf50VTkBRTHeUt5TJfHB/ayB9Ft1TrRzNAUkc0b18K2gUsxkX8xrMIVSF6Lz
         jry1uz9DtxbzmhM1xmBIGrE+0scpqRqQQOjkMDq84+uvQlAwCOY0De7s6gTAFcqS/AHr
         ZbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8w5bqlC3miD54xl7iIppmNvMNfH+gfPS/APFsClxGI4=;
        b=Y0VhH+BKEO1Qc/0Ga8gzpcG5B+nWmrzwSFgguKN8VKzVC7GFzBeuRpBVMFuHGQ49F2
         Vitm1lyIAaaa7dZNvD1J+/6u6Y1Bbo3MR9s4Sq7omvnL22a2svFFbDvxjxv+gUQ42ljP
         CksfDoDBGxGg6loUXZ5KaxcxPTfN9LRn0wHHJlc31i9+FiMtT7oXL/qL8UrQlrVd9EI+
         i0cTGmxEwB81zNXbxb9rLrr4SZUgCx2qajwcTsMKIlKIhYrS0ZihYcQ32n18dEFlrdyl
         5kTeJ1hAgqpwdABEcHXMQy3xK0yX2yUJTvnrK8QxBls2WZYiqkckPNJpM5mEh+aDz38M
         su1w==
X-Gm-Message-State: ACgBeo1UTtZmBk+yco3ylmknTSVOQ5MTFc3CbTpvd+1SzgUjKPstnt+J
        tkO5evzxlIhaEQARdU3q+J3Myzd9NENc4pmkS2k=
X-Google-Smtp-Source: AA6agR4dAtDJOw92vSQYVpMjYwr8TMYbTOldEgt50fGra7cZA0Hr/OWW7A0Tdf4K6JAj7jtNSdsqzivF+dUMGmf5lF8=
X-Received: by 2002:a05:6402:298c:b0:446:a97:1800 with SMTP id
 eq12-20020a056402298c00b004460a971800mr4517542edb.421.1660879681417; Thu, 18
 Aug 2022 20:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+=F4tHsYi14+z+8WP+T3w9vBUpdUhgq4y9=c4X5NhN_g@mail.gmail.com>
 <20220819011505.58948-1-kuniyu@amazon.com>
In-Reply-To: <20220819011505.58948-1-kuniyu@amazon.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 20:27:49 -0700
Message-ID: <CAADnVQJHdxu43rPgpfQ-ezR-Vt3xW2YP7SXUayfoEg+3BCps5w@mail.gmail.com>
Subject: Re: [PATCH v1 bpf 1/4] bpf: Fix data-races around bpf_jit_enable.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 6:15 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date:   Thu, 18 Aug 2022 18:05:44 -0700
> > On Thu, Aug 18, 2022 at 5:56 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > Date:   Thu, 18 Aug 2022 17:13:25 -0700
> > > > On Thu, Aug 18, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > > Date:   Thu, 18 Aug 2022 15:49:46 -0700
> > > > > > On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > >
> > > > > > > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > > > > > > always a chance of data-race.  So, all readers and a writer need some
> > > > > > > basic protection to avoid load/store-tearing.
> > > > > > >
> > > > > > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > ---
> > > > > > >  arch/arm/net/bpf_jit_32.c        | 2 +-
> > > > > > >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> > > > > > >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> > > > > > >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> > > > > > >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> > > > > > >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> > > > > > >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> > > > > > >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> > > > > > >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> > > > > > >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> > > > > > >  include/linux/filter.h           | 2 +-
> > > > > > >  net/core/sysctl_net_core.c       | 4 ++--
> > > > > > >  12 files changed, 19 insertions(+), 16 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > > > > > > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > > > > > > --- a/arch/arm/net/bpf_jit_32.c
> > > > > > > +++ b/arch/arm/net/bpf_jit_32.c
> > > > > > > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > > > > > >         }
> > > > > > >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> > > > > > >
> > > > > > > -       if (bpf_jit_enable > 1)
> > > > > > > +       if (READ_ONCE(bpf_jit_enable) > 1)
> > > > > >
> > > > > > Nack.
> > > > > > Even if the compiler decides to use single byte loads for some
> > > > > > odd reason there is no issue here.
> > > > >
> > > > > I see, and same for 2nd/3rd patches, right?
> > > > >
> > > > > Then how about this part?
> > > > > It's not data-race nor problematic in practice, but should the value be
> > > > > consistent in the same function?
> > > > > The 2nd/3rd patches also have this kind of part.
> > > >
> > > > The bof_jit_enable > 1 is unsupported and buggy.
> > > > It will be removed eventually.
> > >
> > > Ok, then I'm fine with no change.
> > >
> > > >
> > > > Why are you doing these changes if they're not fixing any bugs ?
> > > > Just to shut up some race sanitizer?
> > >
> > > For data-race, it's one of reason.  I should have made sure the change fixes
> > > an actual bug, my apologies.
> > >
> > > For two reads, I feel buggy that there's an inconsitent snapshot.
> > > e.g.) in the 2nd patch, bpf_jit_harden == 0 in bpf_jit_blinding_enabled()
> > > could return true.  Thinking the previous value was 1, it seems to be timing
> > > issue, but not intuitive.
> >
> > it's also used in bpf_jit_kallsyms_enabled.
> > So the patch 2 doesn't make anything 'intuitive'.
>
> Exactly...
>
> So finally, should I repost 4th patch or drop it?

This?
-       if (atomic_long_add_return(size, &bpf_jit_current) > bpf_jit_limit) {
+       if (atomic_long_add_return(size, &bpf_jit_current) >
READ_ONCE(bpf_jit_limit)) {

same question. What does it fix?
