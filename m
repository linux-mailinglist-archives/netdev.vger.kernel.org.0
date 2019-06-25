Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4F75213F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 05:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfFYD0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 23:26:48 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:37641 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYD0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 23:26:48 -0400
Received: by mail-wm1-f51.google.com with SMTP id f17so1294551wme.2
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 20:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IXOHYZNLSJ4fFdgXsJtdI+sZzVfkIBxQhmyiN32ERes=;
        b=h78RoUNShCJm1d3kClIFH8eD1dm5k3dDXb3qwj8a61jhKIHL9VcMZHXf35iSh6OreT
         pILSkk7pV8gvv8EyS8MhNa5uSbtu02fQ+AscZ6KDL3tNBsuUlrF0cRzqjEIU4jdASurh
         iWicFqJCcwx+lLtVDAKIghJqu6Je79qCb3Fvgug3Ar+DZ6tfBQIAvwKA+0kyv55jj79x
         ASgsJSUlNfB2DOIDDlAAS5uLTUHQ5kaXpB2DmXuAgez7dnNYfyyXpkR391usa+iCXN29
         uIDxlQk7hTyxvn/whKk/mlSrfS/Q9wvtEZEvaW1+GbFMcBBxGBj+Kzm3k0OdNSHcH6Zs
         WNkA==
X-Gm-Message-State: APjAAAUPl/d2QoGNagy9t84jUapbczkUEwE/gJif55Jh1/fQhqN7T1FD
        cwW8HenkeFUOyaapQzfcv11sVu9Ya1Jo0AoEmwE=
X-Google-Smtp-Source: APXvYqyXWowJ2zGVRBzdPA8MJt2N8etF8Ze8LwItfxk3YFB5LIY7Qyr83M4Nu4vHLR7Frymq9t/zpKSoH6tzq8CQJ9k=
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr17052825wma.23.1561433205905;
 Mon, 24 Jun 2019 20:26:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com>
In-Reply-To: <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Mon, 24 Jun 2019 20:26:34 -0700
Message-ID: <CAOftzPj_+6hfrb-FwU+E2P83RLLp6dtv0nJizSG1Fw7+vCgYwA@mail.gmail.com>
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Joe Stringer <joe@wand.net.nz>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 7:47 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2019-06-21 1:58 p.m., Joe Stringer wrote:
> > Hi folks, picking this up again..
> [..]
> > During LSFMM, it seemed like no-one knew quite why the skb_orphan() is
> > necessary in that path in the current version of the code, and that we
> > may be able to remove it. Florian, I know you weren't in the room for
> > that discussion, so raising it again now with a stack trace, Do you
> > have some sense what's going on here and whether there's a path
> > towards removing it from this path or allowing the skb->sk to be
> > retained during ip_rcv() in some conditions?
>
>
> Sorry - I havent followed the discussion but saw your email over
> the weekend and wanted to be at work to refresh my memory on some
> code. For maybe 2-3 years we have deployed the tproxy
> equivalent as a tc action on ingress (with no netfilter dependency).
>
> And, of course, we had to work around that specific code you are
> referring to - we didnt remove it. The tc action code increments
> the sk refcount and sets the tc index. The net core doesnt orphan
> the skb if a speacial tc index value is set (see attached patch)
>
> I never bothered up streaming the patch because the hack is a bit
> embarrassing (but worked ;->); and never posted the action code
> either because i thought this was just us that had this requirement.
> I am glad other people see the need for this feature. Is there effort
> to make this _not_ depend on iptables/netfilter? I am guessing if you
> want to do this from ebpf (tc or xdp) that is a requirement.
> Our need was with tcp at the time; so left udp dependency on netfilter
> alone.

I haven't got as far as UDP yet, but I didn't see any need for a
dependency on netfilter.
