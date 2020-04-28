Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5656C1BC5C5
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgD1QvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728084AbgD1QvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 12:51:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 061782063A;
        Tue, 28 Apr 2020 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588092675;
        bh=cCOShKnX5B31AyA1VLPovw9iLNENGMRCSJb2mrr8fmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=waoVgonU8lNeCP7PYzIIJF828jP6+YIe3Z69H57vLs97ElJsaFWzkCki8x5FDvbJZ
         06wdSdHXzefR0TLwFCH90U44V/ystm945uhr4nw/lUwWnqoicsMxBMO5yJvXBs2/4v
         n5xmRcKKEGdC2Az2L5gWG3n0e8/RahBVL8DCkuzg=
Date:   Tue, 28 Apr 2020 09:51:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200428095113.330e83aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87tv14vu2k.fsf@toke.dk>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
        <20200427204208.2501-1-Jason@zx2c4.com>
        <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <877dy0y6le.fsf@toke.dk>
        <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87tv14vu2k.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 11:27:31 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > I wonder, maybe our documentation is not clear. IOW we were saying that
> > XDP is a faster cls_bpf, which leaves out the part that XDP only makes
> > sense for HW/virt devices. =20
>=20
> I'm not sure it's just because people think it's faster. There's also a
> semantic difference; if you just want to do ingress filtering, simply
> sticking an XDP program on the interface is a natural fit.

I'm afraid if we take that stand we're going to struggle to deliver.=20
I'd personally prefer to keep XDP simple and focused.

> Whereas figuring out the tc semantics for ingress is non-trivial.

You mean adding an ingress qdisc and installing a filter?
If it is perhaps we could alleviate that with better user space tooling?

> And also reusability of XDP programs from the native hook is an important
> consideration, I believe. Which is also why I think the pseudo-MAC
> header approach is the right fix for L3 devices :)

Yes, valid point, I've never tried it myself, but I believe the C-level
portability shouldn't be too hard? At least the context members are
named the same. And there isn't that much XDP can do..

Perhaps the portability is something we should keep in mind going
forward. Just in case.

> > Kinda same story as XDP egress, folks may be asking for it but that
> > doesn't mean it makes sense. =20
>=20
> Well I do also happen to think that XDP egress is a good idea ;)

I was planning not to get involved in that conversation any more,
let's move on :P

> > Perhaps the original reporter realized this and that's why they
> > disappeared?
> >
> > My understanding is that XDP generic is aimed at testing and stop gap
> > for drivers which don't implement native. Defining behavior based on
> > XDP generic's needs seems a little backwards, and risky. =20
>=20
> That I can agree with - generic XDP should follow the semantics of
> native XDP, not the other way around. But that's what we're doing here
> (with the pseudo-MAC header approach), isn't it? Whereas if we were
> saying "just write your XDP programs to assume only L3 packets" we would
> be creating a new semantic for generic XDP...

But you do see the problem this creates on redirect already, right?
Do we want to support all that? Add an if in the redirect fast path?
There will _never_ be native XDP for WireGuard, it just doesn't make
sense.=20

Generic XDP is not a hook in its own right, frame is already firmly
inside the stack, XDP is on the perimeter.
