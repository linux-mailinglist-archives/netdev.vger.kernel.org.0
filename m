Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2665741603B
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbhIWNsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239161AbhIWNsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:48:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3D460F4C;
        Thu, 23 Sep 2021 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632404795;
        bh=E3vKkaJAxKpAzbB/uHxsWlwQT6yjLMYYocu+uJNe8eU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uvc/4dn9QaO1J2W+ujw3ATFIHyIHpviQRwKm1x5/FK7cBYTLa2LRNgJoGbV2NJ+0U
         odbNeYkLT5C37wUuly/xhCbKWMcy1TkCd4Y1PSkxNoQqeGtzy0eaqUlZuJGK4tz3SF
         2trF5SS+ZWjnhCFdvs3k1h5w3691CfWzrIe8M/3fX9ah9woOiA4eVbntfjN6uJmZw1
         Ppk9RT1oSXuuRvyEoMqnDX5ljlUQ3bEXwOsgQnfAfTekmaTdEyoZieLGwsYsz9W9q1
         blmebA76dU5o1NZ0hBdCWYcXi2NajDVqde0/ACeBnQeLa+oLazWbCRU+4T/oTl0AaD
         Ek13FMjiiScgw==
Date:   Thu, 23 Sep 2021 06:46:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
Message-ID: <20210923064634.636ef48a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87mto41isy.fsf@toke.dk>
References: <87o88l3oc4.fsf@toke.dk>
        <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
        <87ilyt3i0y.fsf@toke.dk>
        <CAADnVQKi_u6yZnsxEagNTv-XWXtLPpXwURJH0FnGFRgt6weiww@mail.gmail.com>
        <87czp13718.fsf@toke.dk>
        <20210921155118.439c0aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87mto41isy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 22:01:17 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> >> Hmm, the assumption that XDP frames take up at most one page has been
> >> fundamental from the start of XDP. So what does linearise mean in this
> >> context? If we get a 9k packet, should we dynamically allocate a
> >> multi-page chunk of contiguous memory and copy the frame into that, or
> >> were you thinking something else? =20
> >
> > My $.02 would be to not care about redirect at all.
> >
> > It's not like the user experience with redirect is anywhere close=20
> > to amazing right now. Besides (with the exception of SW devices which
> > will likely gain mb support quickly) mixed-HW setups are very rare.
> > If the source of the redirect supports mb so will likely the target. =20
>=20
> It's not about device support it's about XDP program support: If I run
> an MB-aware XDP program on a physical interface and redirect the (MB)
> frame into a container, and there's an XDP program running inside that
> container that isn't MB-aware, bugs will ensue. Doesn't matter if the
> veth driver itself supports MB...

Ah, I see now.

> We could leave that as a "don't do that, then" kind of thing, but that
> was what we were proposing (as the "do nothing" option) and got some
> pushback on, hence why we're having this conversation :)

Let me make a general statement that we can't build large systems
without division of responsibilities. Device specific logic has to
be left to the driver. It's up to veth to apply its extra rules.

As Zvi said, tho, this can be left for later. IMHO initial patches can
drop all mb frames on redirect in the core, so we can make progress.
