Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F25931AD
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiHOPTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiHOPTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:19:30 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C49220C3;
        Mon, 15 Aug 2022 08:19:29 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w19so14065259ejc.7;
        Mon, 15 Aug 2022 08:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=quyHYjy4bkln+hQsxsIlzPTV0qV4jQuOaju4TNLraao=;
        b=qnkuhgk4wziUIB1xBPm1JWk0+VhjaLzWSBKtuJ/VZ854qpAkmFK8rCWj8BoJWIC2bD
         NI/hjBI55/xBbWSfl3QbLRGq9lvOjp9XkqWQYIUQ15/9zSq6IW9Jj5uVcqZtcAVMQCPZ
         9ugcdN1VrTaUscoxZ0r+76YbTZu6MWPHMzNM6sLqNqyfhDT2eQNeL7OIJZ9xO4W0b8lc
         kVjzEP33me9hz8skLqxzJD2waxg3gRijh2QTLa8IL5/AaKuM/ZKEZams8pv/CBQUv3iU
         HxahFbJ0OM4yT48vpU682uR40o7RqsJMd8339KbLqaLynGCsksC7208+kmWKKrnpC36L
         GKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=quyHYjy4bkln+hQsxsIlzPTV0qV4jQuOaju4TNLraao=;
        b=FuGBQ67BA5X8Zt9Vr+p275W7Ee3vb7/0cWyvnhivynD1zEKZz+SekGGwXnNgyURRD8
         OPShcHSoQo8xMAkJ9mtOFqYZRewifhvrZ+AQ6JUBK5pMHhh9s7cFEqeIEcNQSRTNHKBd
         XhpeenUzkuZea9wl639aw1WUR/Kw00liQIwRUsoICEgSu8Gb4DuiO48pjUh/RoxHVBcX
         3TIni/3jDESKCQ0y5jda2heF7FmnDw/Y8mltQn/41FpfJkT2ywzo1FXo6Ye7G9Yxa4YS
         ANH8eayLBW8Qh9j8RKt/eBwed/oAmg/Yxz78GpLH5C9zD8wfFDsbNXkIusk2wY/Y9YAv
         T5Kw==
X-Gm-Message-State: ACgBeo3CmfQhATimlb+qye2HYKegK4UAUPgUONyUnNeFKztSjKd0Z1AA
        QWrBSpb9lP0QRmwmJU1bfFZOZ0DsWOf0jKRwnXE=
X-Google-Smtp-Source: AA6agR5Ranprqiie8B2FN0iy2MWlrP7DRZQsn5EjMXK03x97vxXNisp6EEWEvjkjZspof+/0oZdf0gDXO5mDdtOLgd0=
X-Received: by 2002:a17:907:272a:b0:731:4699:b375 with SMTP id
 d10-20020a170907272a00b007314699b375mr10790832ejl.633.1660576767512; Mon, 15
 Aug 2022 08:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20220815101303.79ace3f8@gandalf.local.home> <CAADnVQLhHm-gxJXTbWxJN0fFGW_dyVV+5D-JahVA1Wrj2cGu7g@mail.gmail.com>
 <20220815111658.58d75672@gandalf.local.home>
In-Reply-To: <20220815111658.58d75672@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 15 Aug 2022 08:19:16 -0700
Message-ID: <CAADnVQKijkstBqV_JhQSaBXZ+65coY+8=UGw8tPi8-boXV=AOQ@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 8:16 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 15 Aug 2022 07:31:23 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > When I heard that ftrace was broken by BPF I thought it was something
> > > unique they were doing, but unfortunately, I didn't investigate what they
> > > were doing at the time.
> >
> > ftrace is still broken and refusing to accept the fact doesn't make it
> > non-broken.
>
> I extended Jiri's patch to make it work again.
>
> >
> > > Then they started sending me patches to hide fentry locations from ftrace.
> > > And even telling me that fentry != ftrace
> >
> > It sounds that you've invented nop5 and kernel's ability
> > to replace nop5 with a jump or call.
>
> Actually I did invent it.
>
>    https://lore.kernel.org/lkml/20080210072109.GR4100@elte.hu/
>
>
> I'm the one that introduced the code to convert mcount into the 5 byte nop,
> and did the research and development to make it work at run time. I had one
> hiccup along the way that caused the e1000e network card breakage.
>
> The "daemon" approach was horrible, and then I created the recordmcount.pl
> perl script to accomplish the same thing at compile time.
>
> > ftrace should really stop trying to own all of the kernel text rewrites.
> > It's in the way. Like this case.
>
> It's not trying to own all modifications (static_calls is not ftrace). But
> the code at the start of functions with fentry does belong to it.
>
> >
> > >    https://lore.kernel.org/all/CAADnVQJTT7h3MniVqdBEU=eLwvJhEKNLSjbUAK4sOrhN=zggCQ@mail.gmail.com/
> > >
> > > Even though fentry was created for ftrace
> > >
> > >    https://lore.kernel.org/lkml/1258720459.22249.1018.camel@gandalf.stny.rr.com/
> > >
> > > and all the work with fentry was for the ftrace infrastructure. Ftrace
> > > takes a lot of care for security and use cases for other users (like
> > > live kernel patching). But BPF has the NIH syndrome, and likes to own
> > > everything and recreate the wheel so that they have full control.
> > >
> > > > of the trampoline. One dispatcher instance currently supports up to 64
> > > > dispatch points. A user creates a dispatcher with its corresponding
> > > > trampoline with the DEFINE_BPF_DISPATCHER macro.
> > >
> > > Anyway, this patch just looks like a re-implementation of static_calls:
> >
> > It was implemented long before static_calls made it to the kernel
> > and it's different. Please do your home work.
>
> Long before? This code made it into the kernel in Dec 2019. Yes static calls
> finally made it into the kernel in 2020, but it was first introduced in
> October 2018:
>
>   https://lore.kernel.org/all/20181006015110.653946300@goodmis.org/
>
> If you had Cc'd us on this patch, we could have collaborated and come up
> with something that would have worked for you.
>
> It took time to get in because we don't just push our features in, we make
> sure that they are generic and work for others, and is secure and robust.
>
> I sent a proof of concept, Josh took over, Linus had issues, and finally
> Peter pushed it through the gate. It's a long process, but we don't break
> others code while doing it!

Replied in the other thread. Let's stick to one thread please.
