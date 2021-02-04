Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BDA30FE40
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbhBDU2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:28:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240106AbhBDUYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:24:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612470155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ob/Q0z75fUha7sOp70sKDWv4y9mB1atawq7qE94MTs8=;
        b=YamBDRsT/DGgjlEEU2gnfEKXQzyjq08J65ne3Es0B6VqookBoqTg3USp2F42RXDrD1b9UY
        0CYLjCoZhmIEFZCVOYISKIpu7F5yoaWaCxZEjp3u3CaJhOFoDfuDawP9QR9evxoIX4nTGU
        l3lATF3zqFDywgPY4CSLTlKfgzNvsXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-A7ohRb1EOQ2tcgOjpeJI5w-1; Thu, 04 Feb 2021 15:22:31 -0500
X-MC-Unique: A7ohRb1EOQ2tcgOjpeJI5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E1A18030B5;
        Thu,  4 Feb 2021 20:22:27 +0000 (UTC)
Received: from treble (ovpn-114-156.rdu2.redhat.com [10.10.114.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A7DB722D9;
        Thu,  4 Feb 2021 20:22:14 +0000 (UTC)
Date:   Thu, 4 Feb 2021 14:22:10 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Robert Richter <rric@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: BUG: KASAN: stack-out-of-bounds in
 unwind_next_frame+0x1df5/0x2650
Message-ID: <20210204202210.4awpfn2ckdv7h5cf@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
 <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
 <20210203190518.nlwghesq75enas6n@treble>
 <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
 <20210203232735.nw73kugja56jp4ls@treble>
 <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
 <20210204001700.ry6dpqvavcswyvy7@treble>
 <CABWYdi2GsFW9ExXAQ55tvr+K86eY15T1XFoZDDBro9hJK5Gpqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABWYdi2GsFW9ExXAQ55tvr+K86eY15T1XFoZDDBro9hJK5Gpqg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 11:51:44AM -0800, Ivan Babrou wrote:
> >  .macro FUNC_SAVE
> >          #the number of pushes must equal STACK_OFFSET
> > +       push    %rbp
> > +       mov     %rsp, %rbp
> >          push    %r12
> >          push    %r13
> >          push    %r14
> > @@ -271,12 +273,14 @@ VARIABLE_OFFSET = 16*8
> >  .endm
> >
> >  .macro FUNC_RESTORE
> > +        add     $VARIABLE_OFFSET, %rsp
> >          mov     %r14, %rsp
> >
> >          pop     %r15
> >          pop     %r14
> >          pop     %r13
> >          pop     %r12
> > +       pop     %rbp
> >  .endm
> >
> >  # Encryption of a single block
> >
> 
> This patch seems to fix the following warning:
> 
> [  147.995699][    C0] WARNING: stack going in the wrong direction? at
> glue_xts_req_128bit+0x21f/0x6f0 [glue_helper]
> 
> Or at least I cannot see it anymore when combined with your other
> patch, not sure if it did the trick by itself.
> 
> This sounds like a good reason to send them both.

Ok, that's what I expected.

The other patch fixed the unwinder failure mode to be the above
(harmless) unwinder warning, instead of a disruptive KASAN failure.

This patch fixes the specific underlying crypto unwinding metadata
issue.

I'll definitely be sending both fixes.  The improved failure mode patch
will come first because it's more urgent and lower risk.

-- 
Josh

