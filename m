Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A4614542E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 13:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAVMDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 07:03:01 -0500
Received: from mail.katalix.com ([3.9.82.81]:38898 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgAVMDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 07:03:01 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2020 07:03:00 EST
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id D95098CBB2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 11:55:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579694148; bh=HJvdd13UiX10kc/SeynZGDbeKw5Xj3kKfUGTpj6C1ms=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SoubJYbrfywzV94Dj5+Utjo5UA4vI/jkuJEezC1yPu1l7pjvkJVLEcXnX4vpAsP+s
         EcVf6Vy2i2QBn1KFtm0TDfsjfao6h8opM9CAfF93UfCFhBI8P2U7CLscXR9EytYwE+
         +EZMRAX15q5zE43lMieDb/CllxynjTxrSXoAzsarolZ3j4CrBIHCxGJUR7vZqbNIcs
         lqZ42bdx9kPQbuhqZ5ukK3ayPMqKt6ES4jYSIqNsgdGnkB1ecVQCGthpJeAgJIg8SH
         zi9lsyRDlBpHakTG5IHUb3X2u7pVyegVkdr0z7lfjjOkRdktZCL003bQ8wp43aDIKy
         ghWsfVLc16iNg==
Received: by mail-oi1-f176.google.com with SMTP id i1so5786627oie.8
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:55:47 -0800 (PST)
X-Gm-Message-State: APjAAAV3Xp36dEG6brkSvPBr1LNGRsnxqFaGL7JOsm8HOKg0fe7BSNBw
        ywVa1f5EFys2XOCl75sQdpYE4j/6qlEbR/Re5h8=
X-Google-Smtp-Source: APXvYqzFdMcGF1uCghS9bnVRRW04o/0+g/u+sVlsX0xYHI2yl9B2gE8ElL7nDqMMs8Il2t1cDnTcmFi9GXr6k25R+9E=
X-Received: by 2002:aca:dfd5:: with SMTP id w204mr6600344oig.95.1579694146943;
 Wed, 22 Jan 2020 03:55:46 -0800 (PST)
MIME-Version: 1.0
References: <20200116123854.GA23974@linux.home> <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home> <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw> <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw> <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw> <20200121163531.GA6469@localhost.localdomain>
In-Reply-To: <20200121163531.GA6469@localhost.localdomain>
From:   James Chapman <jchapman@katalix.com>
Date:   Wed, 22 Jan 2020 11:55:35 +0000
X-Gmail-Original-Message-ID: <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
Message-ID: <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 at 16:35, Guillaume Nault <gnault@redhat.com> wrote:
>
> On Mon, Jan 20, 2020 at 03:09:46PM +0000, Tom Parkin wrote:
> > On  Sat, Jan 18, 2020 at 20:13:36 +0100, Guillaume Nault wrote:
> > > I've never seen that as a problem in practice since establishing more
> > > than one tunnel between two LCCE or LAC/LNS doesn't bring any
> > > advantage.
> >
> > I think the practical use depends a bit on context -- it might be
> > useful to e.g. segregate sessions with different QoS or security
> > requirements into different tunnels in order to make userspace
> > configuration management easier.
> >
> That could be useful for L2TPv2. But that's not going to be more
> limitted for L2TPv3 as the tunnel ID isn't visible on the wire.
>
> > > > Since we don't want to arbitrarily limit IP-encap tunnels to on per
> > > > pair of peers, it's not practical to stash tunnel context with the
> > > > socket in the IP-encap data path.
> > > >
> > > Even though l2tp_ip doesn't lookup the session in the context of the
> > > socket, it is limitted to one tunnel for a pair of peers, because it
> > > doesn't support SO_REUSEADDR and SO_REUSEPORT.
> >
> > This isn't the case.  It is indeed possible to create multiple IP-encap
> > tunnels between the same IP addresses.
> >
> > l2tp_ip takes tunnel ID into account in struct sockaddr_l2tpip when
> > binding and connecting sockets.
> >
> Yes, sorry. I didn't give this enough thinking and mixed the UDP and IP
> transport constraints.
>
> > I think if l2tp_ip were to support SO_REUSEADDR, it would be in the
> > context of struct sockaddr_l2tpip.  In which case reusing the address
> > wouldn't really make any sense.
> >
> Yes, I think we can just forget about it.
>
> > > Thinking more about the original issue, I think we could restrict the
> > > scope of session IDs to the 3-tuple (for IP encap) or 5-tuple (for UDP
> > > encap) of its parent tunnel. We could do that by adding the IP addresses,
> > > protocol and ports to the hash key in the netns session hash-table.
> > > This way:
> > >  * Sessions would be only accessible from the peer with whom we
> > >    established the tunnel.
> > >  * We could use multiple sockets bound and connected to the same
> > >    address pair, and lookup the right session no matter on which
> > >    socket L2TP messages are received.
> > >  * We would solve Ridge's problem because we could reuse session IDs
> > >    as long as the 3 or 5-tuple of the parent tunnel is different.
> > >
> > > That would be something for net-next though. For -net, we could get
> > > something like Ridge's patch, which is simpler, since we've never
> > > supported multiple tunnels per session anyway.
> >
> > Yes, I think this would be possible.  I've been thinking of similar
> > schemes.
> >
> > I'm struggling with it a bit though.  Wouldn't extending the hash key
> > like this get expensive, especially for IPv6 addresses?
> >
> From what I recall, L2TP performances are already quite low. That's
> certainly not a reason for making things worse, but I believe that
> computing a 3 or 5 tuple hash should be low overhead in comparison.
> But checking with real numbers would be interesting.
>
In my experience, poor L2TP data performance is usually the result of
MTU config issues causing IP fragmentation in the tunnel. L2TPv3
ethernet throughput is similar to ethernet bridge throughput in the
setups that I know of.

Like my colleague, Tom, I'm also struggling with this approach. I
can't see how replacing a lookup using a 32-bit hash key with one
using a 260-bit or more key (128+128+4 for two IPv[46] addresses and
the session ID) isn't going to hurt performance, let alone the
per-session memory footprint. In addition, it is changing the scope of
the session ID away from what is defined in the RFC.

I think Linux shouldn't diverge from the spirit of the L2TPv3 RFC
since the RFC is what implementors code against. Ridge's application
relies on duplicated L2TPv3 session IDs which are scoped by the UDP
5-tuple address. But equally, there may be existing applications out
there which rely on Linux performing L2TPv3 session lookup by session
ID alone, as per the RFC. For IP-encap, Linux already does this, but
not for UDP. What if we get a request to do so for UDP, for
RFC-compliance? It would be straightforward to do as long as the
session ID scope isn't restricted by the proposed patch. I'm not aware
that such an application exists, but my point is that the RFC is a key
document that implementors use when implementing applications so
diverging from it seems more likely to result in unforseen problems
later.

It's unfortunate that Linux previously unintentionally allowed L2TPv3
session ID clashes and an application is in the field that relies on
this behaviour. However, the change that fixed this (and introduced
the reported regression) was back in March 2017 and the problem is
only coming to light now. Of the options we have available, a knob to
re-enable the old behaviour may be the best compromise after all.

Could we ask Ridge to submit a new version of his patch which includes
a knob to enable it?
