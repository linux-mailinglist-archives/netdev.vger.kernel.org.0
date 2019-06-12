Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A71842AEB
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409364AbfFLP2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:28:36 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41568 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405706AbfFLP2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 11:28:35 -0400
Received: by mail-lj1-f195.google.com with SMTP id s21so15510787lji.8;
        Wed, 12 Jun 2019 08:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lE83NTf9X/7Vb/ZOH5MwEPJ0QlmnYMZKES+eKLXmm8I=;
        b=cEoh/L0zAMW2lxN+Wmeyfr6apLCU6nhExJD1WZD6qmEXJAsqncv03SMlyVyCJdYIgn
         dfL3TtOVHzFIowrMc/kZZWh+ZLjEANhZwxOGoAlF2l/DEdyFv12Xh/6xIX62s+3msK1v
         jDHd1aUCqvQVnLrfzO2ZnwvxYVME70IsWwWINofITljSM1iOCxTPBlqsoO7vCTeZUY8k
         ba1dEclkG3oH6b0D119SwQOG/vWU2uN/d0PvkZXqRMONCFnCondIjK83bAGfeWx1/aTN
         4BD6/A3obpxpGFfjU5sVAn7w7hV8u9+VjH4GXAkWPP8p34w8lBNfGoMlSp7dZcUwf+d8
         1K5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lE83NTf9X/7Vb/ZOH5MwEPJ0QlmnYMZKES+eKLXmm8I=;
        b=BsH90odEZ9eQrkJGOxWezaGi4yvRoDHyjQlZ71ntJ8DQVf/Ze5HrvhjU7iXy9nIQaG
         fWZwkRwuiH1euMLNyF0sVrxA64AJOLEzMrIoZKAXZmsYC2jmGcM8IlL5Iwz9KP8uk5zv
         1Iwd1EMOGqV8gxPRxrm+L+1P7cVmCKsAX8h+MIWPssIHffd+b88KytvhAYeECTMlFYD/
         7qJr04L1wEEcMTV7QJe+ZTDoYHlDjlAGjb9946y4MQ2gFRNecx/Gd38Cw4jINVa2PEJY
         ZCcIviFquy2ivtI5yBmRZCoDOzqIt8yVUwVaPDZvHVTWCkxJLawndvtFvEoCXIuEFxeK
         n80Q==
X-Gm-Message-State: APjAAAV9sEfwNCClmC1EvdEsC0nUXKizaVzPjsI7dhIaHFBDJj8BWqUY
        OyNVkaY1lc1MRVAkyheNGAxPAqFhsWP5wRi/kH0=
X-Google-Smtp-Source: APXvYqxqu2f8BbQkferyCUZWAsN2jTcxWIY0ZtOx6q9jp5Or/uNRemerK/cf4/MODs7G7e/0wRwhm/X2Tj/Yo8thHNs=
X-Received: by 2002:a2e:5b5b:: with SMTP id p88mr34791002ljb.192.1560353313688;
 Wed, 12 Jun 2019 08:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
 <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com>
 <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com>
In-Reply-To: <87r27y25c3.fsf@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jun 2019 08:28:22 -0700
Message-ID: <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 8:25 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
>
> Jiong Wang writes:
>
> > Alexei Starovoitov writes:
> >
> >> On Wed, Jun 12, 2019 at 4:32 AM Naveen N. Rao
> >> <naveen.n.rao@linux.vnet.ibm.com> wrote:
> >>>
> >>> Currently, for constant blinding, we re-allocate the bpf program to
> >>> account for its new size and adjust all branches to accommodate the
> >>> same, for each BPF instruction that needs constant blinding. This is
> >>> inefficient and can lead to soft lockup with sufficiently large
> >>> programs, such as the new verifier scalability test (ld_dw: xor
> >>> semi-random 64 bit imms, test 5 -- with net.core.bpf_jit_harden=2)
> >>
> >> Slowdown you see is due to patch_insn right?
> >> In such case I prefer to fix the scaling issue of patch_insn instead.
> >> This specific fix for blinding only is not addressing the core of the problem.
> >> Jiong,
> >> how is the progress on fixing patch_insn?
>
> And what I have done is I have digested your conversion with Edward, and is
> slightly incline to the BB based approach as it also exposes the inserted
> insn to later pass in a natural way, then was trying to find a way that
> could create BB info in little extra code based on current verifier code,
> for example as a side effect of check_subprogs which is doing two insn
> traversal already. (I had some such code before in the historical
> wip/bpf-loop-detection branch, but feel it might be still too heavy for
> just improving insn patching)

BB - basic block?
I'm not sure that was necessary.
The idea was that patching is adding stuff to linked list instead
and single pass at the end to linearize it.
