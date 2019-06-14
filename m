Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3437E4513C
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFNBjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:39:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35609 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfFNBjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 21:39:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so292911plo.2;
        Thu, 13 Jun 2019 18:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z4W4rCSw31FjI0zyBz2ZeAwbEeEPrUxlNFEqNxXCPj4=;
        b=Y5T+vsvpTZmq0ibeqrmbwZYztXU93W61x3J1iSN3VLTeBC5+ShA+9XWHKTLSfsJ8Wn
         NmL2LVBnfOJ36qrnok3QyHyMqINudMqZfDdRCEpquD0XiQ+wCRuYIKcZtl/Q/lArFTVF
         pZFLV75RfFOQtbRCBJxFsA149nOrSkmyNXAyf3S8z73swUBApu27fGu0Gzsx9SF+IvV7
         ptOwsOh3CSWDxsRyWXGb5uMH2AkiggOuLjfVCeY5C611xqev565qiHzixxoCadDw66Na
         R7Ms33B+8BpkmBt3uDYW4XPkZ8NJmgjJnZU0Q2jnwuRnyNhaXL38FgdlH/GVM1ne6wxX
         sG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z4W4rCSw31FjI0zyBz2ZeAwbEeEPrUxlNFEqNxXCPj4=;
        b=nYzNdaGujyeKtCj53ZL9zcoHQ7S0B9tUWG0H578aWXTYTZPAkP/dU647EHFETEnfjz
         tefhJ779JCxJaaFAt1YeZgvVcrbbeLk2oAi8pPvvppLe/7/sqb53vywuo8AQAp29GCZV
         FiCrR1BcaS1WfOSIaMquu28itWwvysboSY9YG1HoQx0ohuB0TCPS+83Hvk9XVkH++0J1
         6y4oiVN9IuvuBae9L6M9OEn/fTKA1vmab153738Kaix3jqVU8ErL0oMDm4UWg9vKIcYR
         z1/Iw5jM9zopqeOOBdJsIUDzsX0ThNUJJV6V1prRVanZES1m8DRGNiAdghnvZwz9XrP8
         e1Sw==
X-Gm-Message-State: APjAAAVGewIO8D618wjh66hk+gsQltWlj0BlMs9ZATkuRuSseU24j/+f
        3aTPKOhfq3kISwvXu1xBjo8=
X-Google-Smtp-Source: APXvYqwI3aYZyyEaaDtfCkrPtrpKdwytf3GLklU9czd0qd0qhdsGmqfPnWKwCgZm7eI1cl4csk5Niw==
X-Received: by 2002:a17:902:d897:: with SMTP id b23mr1074156plz.214.1560476347751;
        Thu, 13 Jun 2019 18:39:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:e034])
        by smtp.gmail.com with ESMTPSA id b135sm889283pfb.44.2019.06.13.18.39.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 18:39:07 -0700 (PDT)
Date:   Thu, 13 Jun 2019 18:39:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Message-ID: <20190614013904.v2tpiunrjukzlxsu@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
 <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
 <20190614012248.ztruzocusb2vu7bl@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614012248.ztruzocusb2vu7bl@treble>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:22:48PM -0500, Josh Poimboeuf wrote:
> On Thu, Jun 13, 2019 at 02:58:09PM -0700, Alexei Starovoitov wrote:
> > On Thu, Jun 13, 2019 at 08:21:03AM -0500, Josh Poimboeuf wrote:
> > > The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
> > > thus prevents the FP unwinder from unwinding through JIT generated code.
> > > 
> > > RBP is currently used as the BPF stack frame pointer register.  The
> > > actual register used is opaque to the user, as long as it's a
> > > callee-saved register.  Change it to use R12 instead.
> > > 
> > > Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> > > Reported-by: Song Liu <songliubraving@fb.com>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > ---
> > >  arch/x86/net/bpf_jit_comp.c | 43 +++++++++++++++++++++----------------
> > >  1 file changed, 25 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > index e649f977f8e1..bb1968fea50a 100644
> > > --- a/arch/x86/net/bpf_jit_comp.c
> > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > @@ -100,9 +100,8 @@ static int bpf_size_to_x86_bytes(int bpf_size)
> > >  /*
> > >   * The following table maps BPF registers to x86-64 registers.
> > >   *
> > > - * x86-64 register R12 is unused, since if used as base address
> > > - * register in load/store instructions, it always needs an
> > > - * extra byte of encoding and is callee saved.
> > > + * RBP isn't used; it needs to be preserved to allow the unwinder to move
> > > + * through generated code stacks.
> > 
> > Extra register save/restore is kinda annoying just to fix ORC.
> 
> It's not just for the ORC unwinder.  It also fixes the frame pointer
> unwinder (see above commit msg).  And it's standard frame pointer
> practice to not clobber RBP.

not true.
generated JITed code has no issues with regular stack unwinder.
it breaks down under ORC only.

> > Also every stack access from bpf prog will be encoded via r12 and consume
> > extra byte of encoding. I really don't like this approach.
> 
> Do you have another callee-saved register you'd prefer to use as the
> stack pointer?

RBP must be used.

> > Can you teach ORC to understand JIT-ed frames instead?
> 
> We could, but it would add a lot more complexity than this.  And anyway,
> the frame pointer unwinder would still be broken.

I disagree. See above. Only ORC is broken. Hence ORC should be fixed.

