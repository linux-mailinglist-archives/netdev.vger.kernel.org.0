Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E828A46BDC
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfFNV1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:27:44 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46433 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNV1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 17:27:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id z15so2628725lfh.13;
        Fri, 14 Jun 2019 14:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hXEFS2n2BenNiS8o/HgLZ/cSdtim9gLmbaKcrbohmt0=;
        b=VelSsATDpC6oRP+ofTLsRbOEDPENrLAKSU+cqejoD8r87nuIw7FzMo/z0+7v1unUCR
         tvQgCTLFXQtjsMK3NEBKPyzzfNpH5R6TdGG1fk94tcbm0ARDN2VZiJj/A828dSmw5Xtk
         xhhEJHaDMwSVQ+0OKlHN2a+/v59Pd6qvDX8Zq1k/c24iMDmvOLmF/H5BhU/cpLN2Lxe/
         mJcoFkUa0WFWSLE3nL6uEdSxf4ncWI1urAbobup1YG/PKtRjTA9F+nYz2zkpOhSC3jY2
         X5CXxYePOP2WMMfz0WESDK10e+w7fEVv4vlhzDX/nPWn68fzk57JBy5m6VsAMNK4kozj
         r9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hXEFS2n2BenNiS8o/HgLZ/cSdtim9gLmbaKcrbohmt0=;
        b=AMwnXbj0ahiVOrzH1bueiQW1rz7WZ6/BAQun2M6arfxrWi7P+PPWqhXQVnJ1rkYRZK
         wM37QNLmIl/JTtsTwXDvqi5MZB+oh4WFmGo9BH9iwarDy4+BRIGLXkbeffvRgjEtxhm5
         sT4hZ84FpnYJdwi/SPboxwr2RUmpMRMYt7J8+ZaqgPKrRU0KliGg0jD27swvWa3voms5
         Cm8W+Yqh2dRTZrIWiRVRskJDv2kkYPGU4YXJVP+Lck0rWeWKnbl5CXV9ilB16U8Na1CB
         uTlkulIOxTivO4b2N7aq/mQyRolRa9+EuP+M9W9NtNsEJyziRHe+EXOabz8M4T15BUI2
         eKag==
X-Gm-Message-State: APjAAAUiIjaUau2TgXAFAjHhpkA+BXDGNtaF/+tnxygCea3GFe+DMIzD
        ey9ucPp/8BI/FDsasF/fHUGYtwytdDVL16hIupM=
X-Google-Smtp-Source: APXvYqzqPlY0pE2jaUkC6jYMj65kVioh7KwMCjP5u1JUkxbvnByqfBSXhHorBDPiIhDs/9eOdNi/Jb8UmzJAlssKTUQ=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr9302265lfh.15.1560547662196;
 Fri, 14 Jun 2019 14:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com> <20190614211916.jnxakyfwilcv6r57@treble>
In-Reply-To: <20190614211916.jnxakyfwilcv6r57@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 14:27:30 -0700
Message-ID: <CAADnVQJ0dmxYTnaQC1UiSo7MhcTy2KRWJWJKw4jyxFWby-JgRg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 02:05:56PM -0700, Alexei Starovoitov wrote:
> > Have you tested it ?
> > I really doubt, since in my test both CONFIG_UNWINDER_ORC and
> > CONFIG_UNWINDER_FRAME_POINTER failed to unwind through such odd frame.
>
> Hm, are you seeing selftest failures?  They seem to work for me.
>
> > Here is much simple patch that I mentioned in the email yesterday,
> > but you failed to listen instead of focusing on perceived 'code readability'.
> >
> > It makes one proper frame and both frame and orc unwinders are happy.
>
> I'm on my way out the door and I just skimmed it, but it looks fine.
>
> Some of the code and patch description look familiar, please be sure to
> give me proper credit.

credit means something positive.
your contribution to bpf jit fix was negative.
I'm going to rewrite the fix from relying on patch 3.
