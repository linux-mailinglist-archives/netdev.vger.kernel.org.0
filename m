Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F220D4CBFB2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiCCON1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiCCONZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:13:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED603206D;
        Thu,  3 Mar 2022 06:12:36 -0800 (PST)
Date:   Thu, 3 Mar 2022 15:12:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646316754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kM28Ed3sQRC3n6r/X153q0nmqLuk+lNgIXo03RuPFtU=;
        b=2eodbM+DUacNIcfi6r7IDwejEEQ2bEXBj8mWq+CBRazxwhbcIsIH7EeYXPJ5rCA6mvMCTf
        3GGTNE5SIc7xDIfplxU4qu8M8d1JMoKvxRfBIocCESUJzs8LGJIqIdyAXKBneaFTz5Prt6
        ePj+DpgM5nOqocQoUa7OxQC9tnKClPrfUPlaGM5wBotrJ0ATWdUZpk222idY8ExiITC90k
        1EVFggdAAvmPmDH/T8+E9g+HV3OXcvVIwzLLz9ap6ZsZKAaK9l14rLj4/qRWWn5PKm1w79
        MV+r8+pc1rXBIwvRIh2gpORb8MPqsTh95LHNpY75EczLBweUiNn7IUa/OIkblw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646316754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kM28Ed3sQRC3n6r/X153q0nmqLuk+lNgIXo03RuPFtU=;
        b=kjceKYxlZJVyI/gIO6gidBITF0FfybrqLTpobrQZh7a8lXYUzNvJanHyiD0sbx9ZG8nC7B
        /zATaTCiVdeY1/BA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <YiDM0WRlWuM2jjNJ@linutronix.de>
References: <YiC0BwndXiwxGDNz@linutronix.de>
 <875yovdtm4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <875yovdtm4.fsf@toke.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-03 14:59:47 [+0100], Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
>=20
> > Since the commit mentioned below __xdp_reg_mem_model() can return a NULL
> > pointer. This pointer is dereferenced in trace_mem_connect() which leads
> > to segfault. It can be reproduced with enabled trace events during ifup.
> >
> > Only assign the arguments in the trace-event macro if `xa' is set.
> > Otherwise set the parameters to 0.
> >
> > Fixes: 4a48ef70b93b8 ("xdp: Allow registering memory model without rxq =
reference")
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>=20
> Hmm, so before the commit you mention, the tracepoint wasn't triggered
> at all in the code path that now sets xdp_alloc is NULL. So I'm
> wondering if we should just do the same here? Is the trace event useful
> in all cases?

Correct. It says:
|              ip-1230    [003] .....     3.053473: mem_connect: mem_id=3D0=
 mem_type=3DPAGE_SHARED allocator=3D0000000000000000 ifindex=3D2

> Alternatively, if we keep it, I think the mem.id and mem.type should be
> available from rxq->mem, right?

Yes, if these are the same things. In my case they are also 0:

|              ip-1245    [000] .....     3.045684: mem_connect: mem_id=3D0=
 mem_type=3DPAGE_SHARED allocator=3D0000000000000000 ifindex=3D2
|        ifconfig-1332    [003] .....    21.030879: mem_connect: mem_id=3D0=
 mem_type=3DPAGE_SHARED allocator=3D0000000000000000 ifindex=3D3

So depends on what makes sense that tp can be skipped for xa =3D=3D NULL or
remain with
               __entry->mem_id         =3D rxq->mem.id;
               __entry->mem_type       =3D rxq->mem.type;
	       __entry->allocator      =3D xa ? xa->allocator : NULL;

if it makes sense.

> -Toke

Sebastian
