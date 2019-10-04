Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44347CBFE7
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390190AbfJDP6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:58:50 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37254 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389794AbfJDP6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:58:50 -0400
Received: by mail-ot1-f65.google.com with SMTP id k32so5713369otc.4
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kii2t84FnpnUt+XgKeXePx9ynfaDpkgw73Li78q+P1g=;
        b=J3H7HHcpkA4nMMNjy8hzRpc9bYvv2Qp5Ao4uFjr6zVyKTGFd/1zIIzSsdUbnXKDejt
         PXOf+WJhfVQ1cEuHg4W+YdxfNnClR9ZEgbPbvO48b6CuWnyHM7jaVLqU9oDkGDmGbN7p
         Fg4sxQWdn5g606/E4II2GwxDufXL3ZnsGhL2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kii2t84FnpnUt+XgKeXePx9ynfaDpkgw73Li78q+P1g=;
        b=UZZEG84tlbuW7vBxWdtnZrk44cJMaKygN030WG3iETBu63MzHfpHRRDMVwNqzJ4jiQ
         ZBGhj8WX6fpArS94lCca7ZVzuc+yrhw82X+6JyyF8RCrGJV33ZJ9KgsAf6CSAED8bMGd
         hZEVJ/PXuzybUqMEnESWKZldrHnqn55OaZ2AWpGicMPWrJGr8nvrHtbFsIPAxbsbMvOk
         0I8tivDYU1NerqDM8iCzT6BZaIeyqheIi6l0JQp1v766fvstlgUEuY3ZC+zLMPB8kGgS
         zwy5s3injCP4/gL4S2BTISwvLrdmupOLc9lY+pBRlgMfJQYhxvZo3J6Dk4j/rUqTzrD1
         cjCQ==
X-Gm-Message-State: APjAAAXZLQNjU6+kABdTbfHJl+FyEbs3nPiYab5UqTrlaOnl6Z7p37+2
        7c47cmkm/qqZ0bsyVKRqfo2CsEjx0W8Jz05jQ8LiVw==
X-Google-Smtp-Source: APXvYqyKL1Kens97wBLPLsOvsJYc8PCr4lRbH4sMcBrXV994Y/EKtcQCA14vCjdq7k4WHKF1OgG7W4aVju1mSLnylQA=
X-Received: by 2002:a9d:7398:: with SMTP id j24mr10951958otk.289.1570204727971;
 Fri, 04 Oct 2019 08:58:47 -0700 (PDT)
MIME-Version: 1.0
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com> <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
 <87r23vq79z.fsf@toke.dk> <20191003105335.3cc65226@carbon> <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
 <87pnjdq4pi.fsf@toke.dk> <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
 <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
 <87tv8pnd9c.fsf@toke.dk> <68466316-c796-7808-6932-01d9d8c0a40b@solarflare.com>
In-Reply-To: <68466316-c796-7808-6932-01d9d8c0a40b@solarflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 4 Oct 2019 16:58:36 +0100
Message-ID: <CACAyw99oUfst5LDaPZmbKNfQtM2wF8fP0rz7qMk+Qn7SMaF_vw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
To:     Edward Cree <ecree@solarflare.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 at 11:34, Edward Cree <ecree@solarflare.com> wrote:
>
> Enforcement is easily dealt with: you just don't give people the caps/
>  perms to load XDP programs directly, so the only way they can do it is
>  via your loader (which you give them a socket or dbus or something to
>  talk to).

Writing this daemon is actually harder than it sounds. Loading eBPF
programs can become fairly complex, with eBPF
maps being shared between different programs. If you want to support
all use cases (which you kind of have to) then you'll end up writing an
RPC wrapper for libbpf, which sounds very painful to me.

So I think for this to work at all, loading has to happen in the user space
components. Only construction of the control flow should be centralised.
This has the knock on effect that these components need
CAP_NET_ADMIN, since too much of eBPF relies on having that
capability right now: various map types, safety features applied to non-root
eBPF, etc. Given time this will be fixed, and maybe these programs can then
just have CAP_BPF or whatever.

I chatted with my colleague Arthur, and we think this might work if all
programs are forced to comply with the xdpcap-style tail call map:
a prog array with MAX_XDP_ACTION slots, which each program
calls into via

  tail_call(map, action);
  return action; // to handle the empty slot case

You could then send (program fd, tail call map fd) along with a priority
of some sort via SCM_RIGHTS. The daemon can then update the tail
call maps as needed. The problem is that this only allows
for linear (not tree-like) control flow.

We'll try and hack up a POC to see if it works at all.

> In any case, it seems like XDP users in userspace still need to
>  communicate with each other in order to update the chain map (which
>  seems to rely on knowing where one's own program fits into it); you
>  suggest they might communicate through the chain map itself, and then
>  veer off into the weeds of finding race-free ways of doing that.  This
>  seems (to me) needlessly complex.

I agree.

> Incidentally, there's also a performance advantage to an eBPF dispatcher,
>  because it means the calls to the individual programs can be JITted and
>  therefore be direct, whereas an in-kernel data-driven dispatcher has to
>  use indirect calls (*waves at spectre*).

This is if we somehow got full blown calls between distinct eBPF programs?

> Maybe Lorenz could describe what he sees as the difficulties with the
>  centralised daemon approach.  In what ways is his current "xdpd"
>  solution unsatisfactory?

xdpd contains the logic to load and install all the different XDP programs
we have. If we want to change one of them we have to redeploy the whole
thing. Same if we want to add one. It also makes life-cycle management
harder than it should be. So our xdpd is not at all like the "loader"
you envision.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
