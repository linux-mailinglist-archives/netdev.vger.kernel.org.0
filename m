Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5882D198400
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgC3TNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgC3TNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:13:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60C2B2072E;
        Mon, 30 Mar 2020 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585595598;
        bh=k9g75cWLnq62Gi6U85TDorD1nKRBDEkWzmujdirngzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nqZ0yiMRdRrTlNQpXh7wJjt+p9rDdoS6bY/FuBsKXMJEn8VwISWxEU+5tdD21l7k6
         f8IejKIU4SvRmqfSkG//8icLwnzFSiiheyv367OzGhZ7XN0PPwNmQOoZsROocvgPoS
         hL7QhLB9PJaCBzNSd5hLIecDfAOr9JrpeRQMv07I=
Date:   Mon, 30 Mar 2020 12:13:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200330121315.38349e95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <53515939-00bb-174c-bc55-f90eaceac2a3@solarflare.com>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
        <87tv2e10ly.fsf@toke.dk>
        <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
        <87369wrcyv.fsf@toke.dk>
        <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
        <87pncznvjy.fsf@toke.dk>
        <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
        <87imiqm27d.fsf@toke.dk>
        <20200327230047.ois5esl35s63qorj@ast-mbp>
        <87lfnll0eh.fsf@toke.dk>
        <20200328022609.zfupojim7see5cqx@ast-mbp>
        <87eetcl1e3.fsf@toke.dk>
        <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
        <53515939-00bb-174c-bc55-f90eaceac2a3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 16:41:46 +0100 Edward Cree wrote:
> On 29/03/2020 21:23, Andrii Nakryiko wrote:
> > But you can't say the same about other XDP applications that do not
> > use libxdp. So will your library come with a huge warning =20
> What about a system-wide policy switch to decide whether replacing/
> =C2=A0removing an XDP program without EXPECTED_FD is allowed?=C2=A0 That =
way
> =C2=A0the sysadmin gets to choose whether it's the firewall or the packet
> =C2=A0analyser that breaks, rather than baking a policy into the design.
> Then libxdp just needs to say in the README "you might want to turn
> =C2=A0on this switch".=C2=A0 Or maybe it defaults to on, and the other pr=
ogram
> =C2=A0has to talk you into turning it off if it wants to be 'ill-behaved'.
> Either way, affected users will be driven to the kernel's
> =C2=A0documentation for the policy switch, where we can tell them whatever
> =C2=A0we think they need to know.

I had the same thought. But then again all samples specify IF_NOEXIST
AFAICS, and users will file bugs for replacing other apps. IMHO it's
kind of a responsibility of the distro to make sure that apps it packages
don't break each other.=20

The mechanism to be well behaved exists, it's the sad reality of
backward compatibility that we can't just make it enforced by default
(IF_NOEXIST vs ALLOW_REPLACE).

So adding a knob seems perfectly reasonable, but perhaps we should see
one or two examples of apps actually getting it wrong before adding a
knob?
