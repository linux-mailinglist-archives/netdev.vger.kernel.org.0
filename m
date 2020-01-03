Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6F12F24E
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgACAmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:42:38 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34023 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:42:38 -0500
Received: by mail-ed1-f67.google.com with SMTP id l8so40501403edw.1
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 16:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPdOJY6R+0K1ialBgoqzVcETU1OoE6n4BVYm69KxK4w=;
        b=nGydx+HdueBP0vgEq5bkA1XpLjgTpTT8Go9v8U6Cg9N8CMAfZF7FHwOHi69wHdHij4
         o7UBz5AHI03Q21wYfgMrvklWHLNArZUU3JNl89yyxI4aznmDzHstQGkFrJjf5UzIRNSy
         ef4EJv5jfJY3g+4ud/bTzBW7xXp2wxwcIGxwMJT46pHEoYjFKVmbkQ9aKwki6I9QR+Up
         iQj0KNuc0BXQtQMlziiDvdwIfrtwgtNqwGYBYMyt8S2pQwwkghsGv/Rd+MqB+632fdTv
         pfrwYgPXm0vZQrH3LPxadoAB3VxpeMAMVkexgVpbEBxcY6cKTilU34JM38NxqVemkSmp
         05iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPdOJY6R+0K1ialBgoqzVcETU1OoE6n4BVYm69KxK4w=;
        b=QHYlZVT14J/zdlEsc9/Qjmgw+zsG0B6WfvDjeVZ3xvWEzuVq969QFvEQLpCo5YgXZS
         x1yv/rjWE1BRAvdHJ3ZShC4TnshOIBKXBB6ypu9U/pg7klxs4cD8f+ZNGOr/pU3hv5Is
         C0s/yX2AJSa52ihK6thfCJSRx3/a8Eb2BoFDF937T2hqrEjuPhArM2ZPC0pwXBXa4p1j
         Omt3MSrkIAycysstA+0k/7NiJ8b2T2/ulDV9sUk1alU5ELB1B0OVwENaFOkDZ10S4Kvd
         r1nTp8pDwsRiICVmhHEPcRh58nJYTwPr49SaSmOBUewjaHhdbm80xYCUaEm+l4hyRRuY
         kFpA==
X-Gm-Message-State: APjAAAXV/HR0+UlArzWgNMJ1Rc5FPvRe/SX1B4I3mc12LHL7vcvdakP9
        a0cNYqPGHf/RMyVYNv9VxkXMnHf1D6dknc2TU9x9UQ==
X-Google-Smtp-Source: APXvYqyVHkRmbPHGVczFBW0B9xAuQ2uzvl+01fvhX/rjZMpWuxyFPKL60NNbSaXgo/jTyZrGlgNDygU9jpk6XHQMb20=
X-Received: by 2002:a17:906:8511:: with SMTP id i17mr92147555ejx.267.1578012155837;
 Thu, 02 Jan 2020 16:42:35 -0800 (PST)
MIME-Version: 1.0
References: <1577400698-4836-1-git-send-email-tom@herbertland.com> <20200102.134138.1618913847173804689.davem@davemloft.net>
In-Reply-To: <20200102.134138.1618913847173804689.davem@davemloft.net>
From:   Tom Herbert <tom@herbertland.com>
Date:   Thu, 2 Jan 2020 16:42:24 -0800
Message-ID: <CALx6S37uWDOgWqx_8B0YunQZRGCyjeBY_TLczxmKZySDK4CteA@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 2, 2020 at 1:41 PM David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <tom@herbertland.com>
> Date: Thu, 26 Dec 2019 14:51:29 -0800
>
> > The fundamental rationale here is to make various TLVs, in particular
> > Hop-by-Hop and Destination options, usable, robust, scalable, and
> > extensible to support emerging functionality.
>
> So, patch #1 is fine and it seems to structure the code to more easily
> enable support for:
>
> https://tools.ietf.org/html/draft-ietf-6man-icmp-limits-07
>
> (I'll note in passing how frustrating it is that, based upon your
> handling of things in that past, I know that I have to go out and
> explicitly look for draft RFCs containing your name in order to figure
> out what your overall long term agenda actually is.  You should be
> stating these kinds of things in your commit messages)
>
> But as for the rest of the patch series, what are these "emerging
> functionalities" you are talking about?
>
> I've heard some noises about people wanting to do some kind of "kerberos
> for packets".  Or even just plain putting app + user ID information into
> options.
>
> Is that where this is going?  I have no idea, because you won't say.
>
Yes, there is some of that. Here are some of the use cases for HBH options:

PMTU option: draft-ietf-6man-mtu-option-01. There is a P4
implementation as well as Linux PoC for this that was demonstated
@IETF103 hackathon.
IOAM option: https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options-00.
There is also P4 implementation and Linux router support demonstrated
at IETF104 hackathon. INT is a related technology that would also use
this.
FAST option: https://datatracker.ietf.org/doc/draft-herbert-fast/. I
have PoC for this. There are some other protocol proposals in the is
are (I know Huawei has something to describe the QoS that should be
applied).

There are others including the whole space especially as a real
solution for host to networking signaling gets fleshed out. There's
also the whole world of segment routing options and where that's
going.

> And honestly, this stuff sounds so easy to misuse by governments and
> other entities.  It could also be used to allow ISPs to limit users
> in very undesirable and unfair ways.   And honestly, surveilance and
> limiting are the most likely uses for such a facility.  I can't see
> it legitimately being promoted as a "security" feature, really.
>
Yes, but the problem isn't unique to IPv6 options nor would abuse be
prevented by not implementing them in Linux. Router vendors will
happily provide the necessary support to allow abuse :-) AH is the
prescribed way to prevent this sort of abuse (aside from encrypting
everything that isn't necessary to route packets, but that's another
story). AH is fully supported by Linux, good luck finding a router
vendor that cares about it :-)

> I think the whole TX socket option can wait.
>
> And because of that the whole consolidation and cleanup of the option
> handling code is untenable, because without a use case all it does is
> make -stable backports insanely painful.

The problem with "wait and see" approach is that Linux is not the only
game in town. There are other players that are pursuing this area
(Cisco and Huawei in particular). They are able to implement protocols
more to appease their short term marketing requirements with little
regard for what is best for the community. This is why Linux is so
critical to networking, it is the only open forum where real scrutiny
is applied to how protocols are implemented. If the alternatives are
given free to lead then it's very likely we'll end up being stuck with
what they do and probably have to follow their lead regardless of how
miserable they make the protocols. We've already seen this in segment
routing, their attempts to kill IP fragmentation, and all the other
examples of protocol ossification that unnecessarily restrict what
hosts are allowed to send in the network and hence reduce the utility
and security we are able to offer the user.

The other data point I will offer is that the current Linux
implementation of IPv6 destination and hop-by-hop options in the
kernel is next to useless. Nobody is using the ones that have been
implemented, and adding support for a new is a major pain-- the
ability for modules to register support for an option seems like an
obvious feature to me. Similarly, the restriction that only admin can
set options is overly restrictive-- allowing to non-privileged users
to send options under tightly controlled constraints set by the admin
also seems reasonable to me.

Tom
