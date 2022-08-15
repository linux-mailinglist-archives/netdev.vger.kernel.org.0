Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C463F5930CE
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241425AbiHOObu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbiHOObh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:31:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC20248E1;
        Mon, 15 Aug 2022 07:31:36 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id uj29so13890168ejc.0;
        Mon, 15 Aug 2022 07:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=+zklOwu9dNLDjN4JxRAhUxyPGrF5B6h2RjVK+l4nYQs=;
        b=FyTJWpaCXkWxv7eSFwDJfLNfKHrOj62c/zwpcH/GXIMNRmqHP22DNjuu+B7Kk4ZrPm
         BeX5fYNQ2nxXL4EakDndNPjtbpNNsR4yvCrKoLyJk+EJq3oFYRX76vBwoI6biXiA7kKP
         UkbCZZDsnVtKOlxLBfbKA7kUdX7gr9N/BeTkn0ebtIEgw6tWxLIMhkR/tdj/K15MXYTf
         rLG//vqQz7GNBRm4CymBh/wwqPvuAXBuCcEMF67hYLwK3ck3a4ENOMPgplyC/Ni5uIYi
         R1Z2fcnf57gMKls0+E7f+wzYd00LK8CmWgYZIRXhz3DPC8kGtX02zZd1c0nTVuCadQKb
         3rNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=+zklOwu9dNLDjN4JxRAhUxyPGrF5B6h2RjVK+l4nYQs=;
        b=uISe+HmT+VSAWQqOt93aIO0jpQxPAm/0km1PWjY1J8TRRwGWDVv6qf2nMixA0lbgOj
         IWl5wXuOSNrCfV16I5/9DgEqBkl7+fyi79zgFNfN6xVlQBfSse7RWc685MD+qD1fCtZ4
         tSQAXjX2pm//w/cexxGEMf2Fwup2zqo/AMi4w+o6I3A9/bIX3VeD1WBIJHOeP7pB672d
         42KLTkMQfPGZdeNPE9CGlBdOHPk1bTpi1BC/O6E2H2f/hnj/C629r56At06zSZ7+kVRg
         L5UB2yJOATVbrNkuQLFVK2F9gh/V0uL6JZgYVi6vWdKqO/wmPZ60MFKNFBNb29wl75Km
         4/KA==
X-Gm-Message-State: ACgBeo2UraH829FhMwiDZlkOAeC+mFaij65AkAjaHW+w0RSY3wBGNpoT
        8iLpzOTA1qT7euapfrE6MQPAk9MYMl/bvV5AKUl/EqluPnw=
X-Google-Smtp-Source: AA6agR47f0DWm6ExenyWTqVs0udvS8ktm4MzMC3vhBxzdxm50O2zm2EtWf/o3NAq7CwQLJg/qzTSDO5PXrXqfrJjBkQ=
X-Received: by 2002:a17:906:ef90:b0:730:9cd8:56d7 with SMTP id
 ze16-20020a170906ef9000b007309cd856d7mr10105021ejb.94.1660573895009; Mon, 15
 Aug 2022 07:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20220815101303.79ace3f8@gandalf.local.home>
In-Reply-To: <20220815101303.79ace3f8@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 15 Aug 2022 07:31:23 -0700
Message-ID: <CAADnVQLhHm-gxJXTbWxJN0fFGW_dyVV+5D-JahVA1Wrj2cGu7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 7:13 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 11 Dec 2019 13:30:13 +0100
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The BPF dispatcher is a multi-way branch code generator, mainly
> > targeted for XDP programs. When an XDP program is executed via the
> > bpf_prog_run_xdp(), it is invoked via an indirect call. The indirect
> > call has a substantial performance impact, when retpolines are
> > enabled. The dispatcher transform indirect calls to direct calls, and
> > therefore avoids the retpoline. The dispatcher is generated using the
> > BPF JIT, and relies on text poking provided by bpf_arch_text_poke().
> >
> > The dispatcher hijacks a trampoline function it via the __fentry__ nop
>
> Why was the ftrace maintainers not Cc'd on this patch?  I would have NACK=
ED
> it. Hell, it wasn't even sent to LKML! This was BPF being sneaky in
> updating major infrastructure of the Linux kernel without letting the
> stakeholders of this change know about it.
>
> For some reason, the BPF folks think they own the entire kernel!
>
> When I heard that ftrace was broken by BPF I thought it was something
> unique they were doing, but unfortunately, I didn't investigate what they
> were doing at the time.

ftrace is still broken and refusing to accept the fact doesn't make it
non-broken.

> Then they started sending me patches to hide fentry locations from ftrace=
.
> And even telling me that fentry !=3D ftrace

It sounds that you've invented nop5 and kernel's ability
to replace nop5 with a jump or call.
ftrace should really stop trying to own all of the kernel text rewrites.
It's in the way. Like this case.

>    https://lore.kernel.org/all/CAADnVQJTT7h3MniVqdBEU=3DeLwvJhEKNLSjbUAK4=
sOrhN=3DzggCQ@mail.gmail.com/
>
> Even though fentry was created for ftrace
>
>    https://lore.kernel.org/lkml/1258720459.22249.1018.camel@gandalf.stny.=
rr.com/
>
> and all the work with fentry was for the ftrace infrastructure. Ftrace
> takes a lot of care for security and use cases for other users (like
> live kernel patching). But BPF has the NIH syndrome, and likes to own
> everything and recreate the wheel so that they have full control.
>
> > of the trampoline. One dispatcher instance currently supports up to 64
> > dispatch points. A user creates a dispatcher with its corresponding
> > trampoline with the DEFINE_BPF_DISPATCHER macro.
>
> Anyway, this patch just looks like a re-implementation of static_calls:

It was implemented long before static_calls made it to the kernel
and it's different. Please do your home work.
