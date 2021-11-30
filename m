Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8360463B51
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbhK3QOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244330AbhK3QNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:13:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28530C0613F4
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E609CE1A5E
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 16:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68029C53FCF;
        Tue, 30 Nov 2021 16:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638288555;
        bh=WChpb23qJTVHyB+Cx21WlDaq4GMkoySudNwQYAXjUp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HMu9uPfTyhxTPK3Kms/AJ3iDtutkaJEyuT0cTUiSYCkpqr/zKb66dAwVONqKamaK6
         Pu2hoGwbPqxmwjTDr/slyBadhCJM2GnfLqJPliICmxXCbA2rt+ehldBO54cQEqvnzi
         684AhDd6C2fHIaMC7C5nbJXqTFRnFxDv4tvOnTUo3Ir+43G3AsaYrzxfTTpBzQ51zy
         OfIQ3HhmIvMzTyiz4kRR58DLNOViZcEyw3gMECwI2jEivWT0Y8TS8Rfq0xg9Ba4tuh
         46tFCKdkZmA9x+X8WBo46cKqdnEZKK2RWqsCMDMBE8wb+Or76AOQtOCh/c5T9x2FMk
         zCISEMocWQYfA==
Date:   Tue, 30 Nov 2021 17:09:11 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if
 AN is bypassed
Message-ID: <20211130170911.6355db44@thinkpad>
In-Reply-To: <20211130011812.08baccdc@thinkpad>
References: <20211129195823.11766-1-kabel@kernel.org>
        <20211129195823.11766-7-kabel@kernel.org>
        <YaVeyWsGd06eRUqv@shell.armlinux.org.uk>
        <20211130011812.08baccdc@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 01:18:12 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> On Mon, 29 Nov 2021 23:14:17 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
>=20
> > On Mon, Nov 29, 2021 at 08:58:23PM +0100, Marek Beh=C3=BAn wrote: =20
> > >  static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chi=
p,
> > > -					  u16 status, u16 lpa,
> > > +					  u16 ctrl, u16 status, u16 lpa,
> > >  					  struct phylink_link_state *state)
> > >  {
> > > +	state->link =3D !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> > > +
> > >  	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
> > > -		state->link =3D !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> > > +		state->an_complete =3D !!(ctrl & BMCR_ANENABLE);   =20
> >=20
> > I think I'd much rather report the value of BMSR_ANEGCAPABLE - since
> > an_complete controls the BMSR_ANEGCAPABLE bit in the emulated PHY
> > that userspace sees. Otherwise, an_complete is not used.
> >=20
> > state->link is the key that phylink uses to know whether it can
> > trust the status being reported. =20
>=20
> Isn't BMSR_ANEGCAPABLE set to 1 even if aneg is disabled in BMCR?
> I will test tomorrow.
>=20
> The reason why I used BMCR_ANENABLE is that if we don't enable AN, the
> PHY will report SPD_DPL_VALID if link is up. But clearly AN is not
> completed in that case, because it was never enabled in the first place.

Seems that BMSR_ANEGCAPABLE is set even if AN is disabled in BMCR.

If phylink_autoneg_inband() is not true mv88e6*_serdes_pcs_config(),
then we aren't enabling AN. But in this case SPD_DPL_VALID is always 1,
so if we use, as you say, an_complete=3DBMSR_ANEGCAPABLE in
mv88e6xxx_serdes_pcs_get_state(), we will always set an_complete=3Dtrue, ev=
en
if AN wasn't enabled.

I was under the impression that
  state->an_complete
should only be set to true if AN is enabled.

Marek
