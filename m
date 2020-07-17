Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F10224069
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgGQQQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgGQQQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:16:40 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51094C0619D2;
        Fri, 17 Jul 2020 09:16:40 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z24so13320403ljn.8;
        Fri, 17 Jul 2020 09:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxKAis2WioKBXKKeK4SA2CJEo+QXv294Y8+mlbplhxo=;
        b=o5zKtdLAYS6jENWeR1ZgqFO5+IPC37tE9/Oz+jgNcGVxbA2UPanTAYreYvpeU0Ofe7
         6ZDpyhppvGKmr5KtEdxQSEr7PJJf6EeATDNQSLWPpprD/oKVVtml2L4HqBm2ywcS3ULm
         pWoS3BHqyO3oQr77hYJ+8+vBOABVwzyyjsjPWdRFBJ2ty8tNkbGEETsa3QgH3KoH4GuK
         3C7x5UJ93UxYO453s9wFQ3wEsLwhwyQtWfMobYtyfuLFhv0l9knjIw5qp+VJiBwRkFoR
         WJKS0ISq6Y0CO9IXwlip4ff94mP6lvSFQM2jsShwvCNEJJlYBzQ/v6DbMIx2IH+4qKp1
         UuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxKAis2WioKBXKKeK4SA2CJEo+QXv294Y8+mlbplhxo=;
        b=ZijUi7C0NWI6fwtYi7YKnKgZttDZq7dDLrVm1TiWvUDebmNzEPdPXXqKSpnnUex8EZ
         fYf98zXa13cA+GJAIIGq5ILcXV4XLKoWZDGq5IXMj5hJ6rngkqCorOu85OCjH8L4/sYZ
         hgM8Pf61F/f8YywUXCcXVS9n+fIGU55LEpdhbccTWKgwQHQDAJ93LiCblws1F0rou+7j
         ERxeMWkn108VzHttG1zRz8jmMBSIjL+VMNxE8YP1gH7ih5pinu5ZLaJvuZwe3LWIOgkP
         hw0BospcvcFHm2+N1PKo+OSJb0oA1KckXcSX00IoVdMXQKBiMqafU8LSHE5rUzfuLibi
         VZ1Q==
X-Gm-Message-State: AOAM531OTU68bFujcXYRweuS6C1GoPq4HGCfIFDAir3Yi0zoFCY0hYKw
        bWYzPKfb52dDApa2ZWEKHONSZljaxxNS6wfeiOY=
X-Google-Smtp-Source: ABdhPJxSNjtFtM4VBKdh5m5KjX2GTtlcdnbEfePS1v/JUwWFQQCISjuc4aSgnYxa7yCFqwAm6Zra6pajWj//bYlzmxY=
X-Received: by 2002:a2e:90da:: with SMTP id o26mr4942332ljg.91.1595002598643;
 Fri, 17 Jul 2020 09:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-5-maciej.fijalkowski@intel.com> <932141f5-7abb-1c01-111d-a64baf187a40@iogearbox.net>
 <20200717021624.do6mrxxr37vc7ajd@ast-mbp.dhcp.thefacebook.com> <20200717105744.GB11239@ranger.igk.intel.com>
In-Reply-To: <20200717105744.GB11239@ranger.igk.intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Jul 2020 09:16:27 -0700
Message-ID: <CAADnVQLz0ojicbKS4LSjCCb5yaK9xKzB0MEJNYzb+Z6bVAFt4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and tailcall
 handling in JIT
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 4:02 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Jul 16, 2020 at 07:16:24PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jul 17, 2020 at 01:06:07AM +0200, Daniel Borkmann wrote:
> > > > +                         ret = bpf_arch_text_poke(poke->tailcall_bypass,
> > > > +                                                  BPF_MOD_JUMP,
> > > > +                                                  NULL, bypass_addr);
> > > > +                         BUG_ON(ret < 0 && ret != -EINVAL);
> > > > +                         /* let other CPUs finish the execution of program
> > > > +                          * so that it will not possible to expose them
> > > > +                          * to invalid nop, stack unwind, nop state
> > > > +                          */
> > > > +                         synchronize_rcu();
> > >
> > > Very heavyweight that we need to potentially call this /multiple/ times for just a
> > > /single/ map update under poke mutex even ... but agree it's needed here to avoid
> > > racing. :(
> >
> > Yeah. I wasn't clear with my suggestion earlier.
> > I meant to say that synchronize_rcu() can be done between two loops.
> > list_for_each_entry(elem, &aux->poke_progs, list)
> >    for (i = 0; i < elem->aux->size_poke_tab; i++)
> >         bpf_arch_text_poke(poke->tailcall_bypass, ...
> > synchronize_rcu();
> > list_for_each_entry(elem, &aux->poke_progs, list)
> >    for (i = 0; i < elem->aux->size_poke_tab; i++)
> >         bpf_arch_text_poke(poke->poke->tailcall_target, ...
> >
> > Not sure how much better it will be though.
> > text_poke is heavy.
> > I think it's heavier than synchronize_rcu().
> > Long term we can do batch of text_poke-s.
>
> Yeah since we introduce another poke target we could come up with
> preparing the vector of pokes as you're saying?

yes. eventually. Pls keep it simple for now.
The logic is already quite complex.
