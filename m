Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87A4DD64
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 00:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfFTWUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 18:20:55 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:40489 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfFTWUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 18:20:55 -0400
Received: by mail-wm1-f48.google.com with SMTP id v19so4616546wmj.5;
        Thu, 20 Jun 2019 15:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BOTfc6xkfy+nNPUxl8bRZyQtwbGj0bqWA6aMY4K9+Xw=;
        b=Nf8TGbn6OVR9OJQqaA6T/0PXzq2RPCPkn1fva+MA7oxnSx+KTmRTXl8d5kzPdi8a+B
         XZuzniMHYPndxcJcmk/gcXmboiD32wuLr3B3jmZUN2q8gRje38CZ/Gt1aiqYpRGymPc4
         IEnWHEXo0srkWR04AinMct6y3q07fOEiEAku765lbvrAObIkBYZKjFNOo2jcvrXSYs5O
         +BQTS9wUMPAmJxslf+QfaBorqEYgQ+0YRN2w4HYz6DdyHHsdHH/TQXItdJ6O3ElcCwDJ
         xgj7Fa/WlqS9iJwv4fgF39gMvy9v44BWXKg4wzReoKhyI36xuJfghyb+LMASe6Dz6icc
         ZqfA==
X-Gm-Message-State: APjAAAVKw3EJoEVlSik8zdO5CMzyXqRzOFd07peL2z2dRJ7AVglfV51w
        AQljRcAKWwr9m2CT0C0wply0H5meRHzqkJ1o2gqxkQ==
X-Google-Smtp-Source: APXvYqytc7FGhIZ6v3mBOczs3HALl8ai/g2Gp77r/f6kV/1CIAj6C5Rr99Y6H0inh2JQhiHJSN0Ctef0UavM0E8p7h0=
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr998424wma.23.1561069252885;
 Thu, 20 Jun 2019 15:20:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190618130050.8344-1-jakub@cloudflare.com> <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
 <87sgs6ey43.fsf@cloudflare.com>
In-Reply-To: <87sgs6ey43.fsf@cloudflare.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 20 Jun 2019 15:20:41 -0700
Message-ID: <CAOftzPj6NWyWnz4JL-mXBaQUKAvQDtKJTrjZmrN4W5rqoy-W0A@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 2:14 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Hey Florian,
>
> Thanks for taking a look at it.
>
> On Tue, Jun 18, 2019 at 03:52 PM CEST, Florian Westphal wrote:
> > Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>  - XDP programs using bpf_sk_lookup helpers, like load balancers, can't
> >>    find the listening socket to check for SYN cookies with TPROXY redirect.
> >
> > Sorry for the question, but where is the problem?
> > (i.e., is it with TPROXY or bpf side)?
>
> The way I see it is that the problem is that we have mappings for
> steering traffic into sockets split between two places: (1) the socket
> lookup tables, and (2) the TPROXY rules.
>
> BPF programs that need to check if there is a socket the packet is
> destined for have access to the socket lookup tables, via the mentioned
> bpf_sk_lookup helper, but are unaware of TPROXY redirects.
>
> For TCP we're able to look up from BPF if there are any established,
> request, and "normal" listening sockets. The listening sockets that
> receive connections via TPROXY are invisible to BPF progs.
>
> Why are we interested in finding all listening sockets? To check if any
> of them had SYN queue overflow recently and if we should honor SYN
> cookies.

Why are they invisible? Can't you look them up with bpf_skc_lookup_tcp()?
