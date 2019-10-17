Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607B5DABC4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393153AbfJQMLz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Oct 2019 08:11:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393092AbfJQMLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 08:11:55 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92BAE85540
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 12:11:54 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id q3so485305lfc.5
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 05:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qWVnxBx/NDjHiIsDcbEQ8I6F1E9yiXUAtix+dsYJ9vQ=;
        b=GuRoAmZBPvEbmMRBAkhZuN+s5ArjPm4EFs+WywCrAPn+8QzIOA1qYO4yXnft+hqMf3
         6/eafD2ffWDBQh2cUt5BQgQM8ST4RfcFXwRFCWMczPbXUtbnv3+ss8FMl5keOB9I9Hue
         kpJLbK5dpnhwQjWCFq3FKYugNeS0dA70XNjS4Jc3+S9ajPnxMEv+SVpwNrQk9z7nhEWG
         D6tlSfzAbu7eZotsBuaer6kI3QHu5oVbBDw+OlFmHsnWIqXg8kJoXqEg8Qh6RCaAO2jr
         Fnl9ZxJMgvtKqNVV8z8MBOE6+T1FG+k3j8h8vYe+lSFymVoVfoYdXNwpCfP3yWXCydUz
         QZ9g==
X-Gm-Message-State: APjAAAX3O0zO4IiF8O8+/unxisILoZOL1SkWwkav/Q79cvAtdY+F4zFG
        UXJiFY0Ae2MW0TkCwP0pNnFW3qxfvq7sMg598HSdD0JJ3gd7LB4R6Wjxt3GjZ5OBnT8bqTC0SOv
        F4Op0lSQi2tQVAVnK
X-Received: by 2002:a2e:1214:: with SMTP id t20mr2272096lje.191.1571314313102;
        Thu, 17 Oct 2019 05:11:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx+my3Nib/6oOK5vNW1IqBq0xlgk7DXDnyzuAVeVSbLbqgnHX3s0o2KHVTCT8CLZe1nCH+ivg==
X-Received: by 2002:a2e:1214:: with SMTP id t20mr2272058lje.191.1571314312779;
        Thu, 17 Oct 2019 05:11:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id x187sm2161797lfa.64.2019.10.17.05.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 05:11:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AE0C41804C9; Thu, 17 Oct 2019 14:11:50 +0200 (CEST)
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
In-Reply-To: <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1> <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com> <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com> <87o8yqjqg0.fsf@toke.dk> <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com> <87v9srijxa.fsf@toke.dk> <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch> <87eezfi2og.fsf@toke.dk> <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com> <87r23egdua.fsf@toke.dk> <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Oct 2019 14:11:50 +0200
Message-ID: <874l07fu61.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree <ecree@solarflare.com> writes:

> On 15/10/2019 17:42, Toke Høiland-Jørgensen wrote:
>> Edward Cree <ecree@solarflare.com> writes:
>>> On 14/10/2019 19:48, Toke Høiland-Jørgensen wrote:
>>>> So that will end up with a single monolithic BPF program being loaded
>>>> (from the kernel PoV), right? That won't do; we want to be able to go
>>>> back to the component programs, and manipulate them as separate kernel
>>>> objects.
>>> Why's that? (Since it also applies to the static-linking PoC I'm
>>> putting together.) What do you gain by having the components be
>>> kernel-visible?
>> Because then userspace will have to keep state to be able to answer
>> questions like "show me the list of programs that are currently loaded
>> (and their call chain)", or do operations like "insert this program into
>> the call chain at position X".
> Userspace keeps state for stuff all the time.  We call them "daemons" ;)
> Now you might have arguments for why putting a given piece of state in
>  userspace is a bad idea — there's a reason why not everything is a
>  microkernel — but those arguments need to be made.
>
>> We already keep all this state in the kernel,
> The kernel keeps the state of "current (monolithic) BPF program loaded
>  (against each hook)".  Prior to this patch series, the kernel does
>  *not* keep any state on what that BPF program was made of (except in
>  the sense of BTF debuginfos, which a linker could combine appropriately).
>
> So if we _don't_ add your chained-programs functionality into the kernel,
>  and then _do_ implement userspace linking, then there isn't any
>  duplicated functionality or even duplicated state — the userland state
>  is "what are my components and what's the linker invocation that glues
>  them together", the kernel state is "here is one monolithic BPF blob,
>  along with a BTF blob to debug it".  The kernel knows nothing of the
>  former, and userspace doesn't store (but knows how to recreate) the
>  latter.

I think there's a conceptual disconnect here in how we view what an XDP
program is. In my mind, an XDP program is a stand-alone entity tied to a
particular application; not a library function that can just be inserted
into another program. Thus, what you're proposing sounds to me like the
equivalent of saying "we don't want to do process management in the
kernel; the init process should just link in all the programs userspace
wants to run". Which is technically possible; but that doesn't make it a
good idea.

Setting aside that for a moment; the reason I don't think this belongs
in userspace is that putting it there would carry a complexity cost that
is higher than having it in the kernel. Specifically, if we do implement
an 'xdpd' daemon to handle all this, that would mean that we:

- Introduce a new, separate code base that we'll have to write, support
  and manage updates to.

- Add a new dependency to using XDP (now you not only need the kernel
  and libraries, you'll also need the daemon).

- Have to duplicate or wrap functionality currently found in the kernel;
  at least:
  
    - Keeping track of which XDP programs are loaded and attached to
      each interface (as well as the "new state" of their attachment
      order).

    - Some kind of interface with the verifier; if an app does
      xdpd_rpc_load(prog), how is the verifier result going to get back
      to the caller?

- Have to deal with state synchronisation issues (how does xdpd handle
  kernel state changing from underneath it?).


While these are issues that are (probably) all solvable, I think the
cost of solving them is far higher than putting the support into the
kernel. Which is why I think kernel support is the best solution :)

-Toke
