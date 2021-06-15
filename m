Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1592C3A8976
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFOT2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhFOT2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 15:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4BB0610EA;
        Tue, 15 Jun 2021 19:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623785165;
        bh=+/JWziYOg7suuIG+GgEa5rY6/b0tRbnG+yTdjnmhZSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ozSp9Pcy7kuKnTCcJ7m1vgZ/WDZLm2UTaISg8X0CN02sDy+N6PGoolhwrnxOtJdcc
         V+/cDjvBMtHnTtX28JmS0Uzjny0O7NoH5NQet7ucSaNdS+NTaa7rlXu6HP58ku1A97
         Gc+kur2MvpWYKn2gpSY+CmvTl++pN9lZ3ugJP84kFzj4jURxf7jqkrlCnmZaJvDu0a
         6nAJbSM2PsalWxVZrMwH4AZASPqhq7dFXvLB8HwnPWx+89z777sr9p1bBOIfdSAvH8
         9KAvHrDv/d7rYJX5+VXZS/xuXYvMLFnXIKtVx/XZVdb7uYtt80DgzEFUPzGEZXBC2z
         J2+86J4D7GWhg==
Date:   Tue, 15 Jun 2021 12:26:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Message-ID: <20210615122604.1d68b37c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <871r93w8l9.fsf@miraculix.mork.no>
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
        <8735tky064.fsf@miraculix.mork.no>
        <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
        <877divwije.fsf@miraculix.mork.no>
        <CAKfDRXivs063y2sq0p8C1s1ayyt3b5DgxKH6smcvXucrGq=KHA@mail.gmail.com>
        <CAKfDRXhraBRXwaDb6T3XMtGpwK=X2hd8+ONWLSmJhQjGurBMmw@mail.gmail.com>
        <871r93w8l9.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 15:39:14 +0200 Bj=C3=B8rn Mork wrote:
> >> I think this would be a really nice solution. The same (at least
> >> FLAG_MULTI_PACKET + usbnet_skb_return) could be applied to pass
> >> through as well, giving us consistent handling of aggregated packets.
> >> While we might not save a huge number of lines, I believe the
> >> resulting code will be easier to understand. =20
> >
> > Apologies for the noise. When I check the code again, I see that as
> > long as FLAG_MULTI_PACKET is set, then we end up with usbnet freeing
> > the skb (we will always jump to done in rx_process()). So for the
> > pass-through case, I believe your initial suggestion of having
> > rx_fixup return 1 is the way to go. =20
>=20
> Yes, if we are to use FLAG_MULTI_PACKET then we must call
> usbnet_skb_return() for all the non-muxed cases.  There is no clean way
> to enable FLAG_MULTI_PACKET on-demand.

Tricky piece of code. Perhaps we could add another return code=20
to the rx_fixup call? Seems that we expect 0 or 1 today, maybe we=20
can make 2 mean "data was copied out", and use that for the qmimux=20
case?

> I am fine with either solution.  Whatever Jakub wants :-)

Well, turns out I was looking at the wrong netif_rx() so take
what I say with a grain of salt ;)
