Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEF0462902
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhK3AVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:21:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45380 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhK3AVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 19:21:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B115B81636
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 00:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C940AC53FAD;
        Tue, 30 Nov 2021 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638231497;
        bh=9uQJtbd2hWKEDQ2WU8D9iUhEGzqp+dDQf2Qf3jb42Ak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZvVgq6cIU+k5TeiFt23XLcKOp1hzTkMfAg/M0m+I/CW+BZBtX78FFTGzHDtt8orOG
         l0tql3g6obfN5CLxiO+EUNpaK5hslyPuEyz5SRJ1hUcvDCEnZNqCymssJngdfI1Zbc
         aMmb5EHAoMo0ApcmJUTOBm+uGQEPflcUsHkEpV2RGlJl/olIJUWtzVIX/sy5inlE8h
         wTsYgfirT0AazN3qR/KRyJp/9r+Vum3H4tV3Z7f9aNWLcR+jFcpgzhefqxN+4ZDEjE
         N5HGB8uH61RBKa89jMCL90jnS1OL4ALdEKN4Y5ET+/3iev1wuPDdd8fdzoSJhSuxdw
         39FMBI1dIlaxQ==
Date:   Tue, 30 Nov 2021 01:18:12 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if
 AN is bypassed
Message-ID: <20211130011812.08baccdc@thinkpad>
In-Reply-To: <YaVeyWsGd06eRUqv@shell.armlinux.org.uk>
References: <20211129195823.11766-1-kabel@kernel.org>
        <20211129195823.11766-7-kabel@kernel.org>
        <YaVeyWsGd06eRUqv@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 23:14:17 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Mon, Nov 29, 2021 at 08:58:23PM +0100, Marek Beh=C3=BAn wrote:
> >  static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
> > -					  u16 status, u16 lpa,
> > +					  u16 ctrl, u16 status, u16 lpa,
> >  					  struct phylink_link_state *state)
> >  {
> > +	state->link =3D !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> > +
> >  	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
> > -		state->link =3D !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> > +		state->an_complete =3D !!(ctrl & BMCR_ANENABLE); =20
>=20
> I think I'd much rather report the value of BMSR_ANEGCAPABLE - since
> an_complete controls the BMSR_ANEGCAPABLE bit in the emulated PHY
> that userspace sees. Otherwise, an_complete is not used.
>=20
> state->link is the key that phylink uses to know whether it can
> trust the status being reported.

Isn't BMSR_ANEGCAPABLE set to 1 even if aneg is disabled in BMCR?
I will test tomorrow.

The reason why I used BMCR_ANENABLE is that if we don't enable AN, the
PHY will report SPD_DPL_VALID if link is up. But clearly AN is not
completed in that case, because it was never enabled in the first place.

Marek
