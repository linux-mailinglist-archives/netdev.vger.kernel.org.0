Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99464E0B33
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732149AbfJVSHr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 14:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfJVSHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 14:07:46 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CCF317BDA1
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 18:07:45 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id p15so3548430lfc.20
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QMev1t8/rRusscmilkGORiYqeo2jydWjbzFjuHZcypw=;
        b=p+gyO1QUP2tlrwvlC5yKy+V9JyM9z3ka3fnHX7aDyGp8832RRb+fW9kLLWGkqre3be
         mwpaZYkf2CLsOdwyqKo3SA8kPZHU3Dn2rkMR1kljl3qrlQTyUZc6MaJcnzb6cGyZbqFs
         pLDVOqr19QCl7s9pe9e2imPeWlBYyzcQQLjOXUZC6X8/KARRv+ayfAF/l3GIvQeu0vY/
         aA9Zjg8mmd6yJqjV4CWdug0kDiqO8v65PoKqKgaPEwpPAev1VVu0xz12DUhD2VmuedhL
         xe+ANQludUENFAfwCREARfWAWNr11zFlwC6MsZTFSlZEjJlvOk4Fv590VCehZUkp0B2f
         pNyQ==
X-Gm-Message-State: APjAAAVS0HKnwzYjf+t3mUP0NQPQmI9s0jlrAyM6rVaLvBpSwBgDL5Da
        NTRQPCeaB2TKP4xUXcMxkL1mymvNMI2g5ssY7sNOd5nTy9Nbgq3Arwa8NTx5+1U+NuVo4GXJj0z
        fzlShfHUrzLJiB2yr
X-Received: by 2002:a19:6759:: with SMTP id e25mr18905128lfj.80.1571767664256;
        Tue, 22 Oct 2019 11:07:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzO0HxlanDX40SXZBPdlgeEJamp1nro6mu/mG7zvv+PQiAmPfdxyRtvndLzMeSJyvivAyIseg==
X-Received: by 2002:a19:6759:: with SMTP id e25mr18905109lfj.80.1571767663933;
        Tue, 22 Oct 2019 11:07:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a7sm4382907ljn.4.2019.10.22.11.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:07:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 62CD91804B1; Tue, 22 Oct 2019 20:07:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Edward Cree <ecree@solarflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF programs after each other
In-Reply-To: <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1> <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com> <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com> <87o8yqjqg0.fsf@toke.dk> <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com> <87v9srijxa.fsf@toke.dk> <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch> <87eezfi2og.fsf@toke.dk> <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com> <87r23egdua.fsf@toke.dk> <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com> <874l07fu61.fsf@toke.dk> <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Oct 2019 20:07:42 +0200
Message-ID: <87eez4odqp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree <ecree@solarflare.com> writes:

> On 17/10/2019 13:11, Toke Høiland-Jørgensen wrote:
>> I think there's a conceptual disconnect here in how we view what an XDP
>> program is. In my mind, an XDP program is a stand-alone entity tied to a
>> particular application; not a library function that can just be inserted
>> into another program.

> To me, an XDP (or any other eBPF) program is a function that is already
>  being 'inserted into another program', namely, the kernel.  It's a
>  function that's being wired up to a hook in the kernel.  Which isn't
>  so different to wiring it up to a hook in a function that's wired up to
>  a hook in the kernel (which is what my proposal effectively does).

Yes, see: Different mental models leading to different notions of what
is the natural way to do things :)

>> Setting aside that for a moment; the reason I don't think this belongs
>> in userspace is that putting it there would carry a complexity cost that
>> is higher than having it in the kernel.
> Complexity in the kernel is more expensive than in userland.  There are
>  several reasons for this, such as:
> * The kernel's reliability requirements are stricter — a daemon that
>   crashes can be restarted, a kernel that crashes ruins your day.
> * Userland has libraries available for many common tasks that can't be
>   used in the kernel.
> * Anything ABI-visible (which this would be) has to be kept forever even
>   if it turns out to be a Bad Idea™, because We Do Not Break
> Userspace™.

To me, the first and last of those are actually arguments for putting
this into the kernel (from the consuming application's PoV). Surely we
want something that's reliable and well-supported? ;)

> The last of these is the big one, and means that wherever possible the
> proper course is to prototype functionality in userspace, and then
> once the ABI is solid and known-useful, it can move to the kernel if
> there's an advantage to doing so

To me, the prototyping was the tail call-based stuff Facebook and
Cloudflare has been doing, and this is an attempt to synthesise that
into something that we can actually agree to support as part of the XDP
feature set.

>> - Add a new dependency to using XDP (now you not only need the kernel
>>   and libraries, you'll also need the daemon).
> You'll need *a* daemon. You won't be tied to a specific
> implementation.

But the point is that I *want* this to be a specific implementation; or
rather, a specific interface. I.e., I want this to be an interface that
people can rely on being available, rather than have a proliferation of
slightly different ways to achieve this that are subtly incompatible.

>>     - Keeping track of which XDP programs are loaded and attached to
>>       each interface
> There's already an API to query this.

There's an API, but the daemon still has to deal with it.

> You would probably want an atomic cmpxchg operation, so that you can
> detect if someone else is fiddling with XDP and scream noisy warnings.

Yup, probably going to do some sort of atomic program replace API in any
case :)

>>     - Some kind of interface with the verifier; if an app does
>>       xdpd_rpc_load(prog), how is the verifier result going to get back
>>       to the caller?
> The daemon will get the verifier log back when it tries to update the
> program; it might want to do a bit of translation before passing it
> on, but an RPC call can definitely return errors to the caller.

I wasn't implying that it was impossible to report errors over RPC.
I was saying that you "a bit of translation" is not as trivial as you
make it out to be...


> In the Ideal World of kernel dynamic linking, of course, each app prog
> gets submitted to the verifier by the app to create a floating function
> in the kernel that's not bound to any XDP hook (app gets its verifier
> responses at this point)

I believe this is what Alexei means by "indirect calls". That is
different, though, because it implies that each program lives as a
separate object in the kernel - and so it might actually work. What you
were talking about (until this paragraph) was something that was
entirely in userspace, and all the kernel sees is a blob of the eBPF
equivalent of `cat *.so > my_composite_prog.so`.

-Toke
