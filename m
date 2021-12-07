Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8471546AF1C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbhLGA2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:28:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40142 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhLGA2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:28:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E03ACE1908;
        Tue,  7 Dec 2021 00:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F98C004DD;
        Tue,  7 Dec 2021 00:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638836711;
        bh=Us2tCmGaLxHQw8t1DDfGIs5xmpecOpuTJXD6aG+5wO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nr93gD0gddxgxQ4lzC7p/TEaNSWkxS5Uk7BWQIvPwtlurskGzaBEhU44BwKqu5emO
         rQ7aXHwuSkAJ7Rl10T/EHK7WWB2+W037b3bi7sMFDheRJwHTD1LrZEwqd6C9o+qtoJ
         lLtpxr2B77bkcG33fIdu8Y3B8o1N74lqZrdL7N/j7/az1bMzkj4FKN95SiQs3BZuH3
         UvruVUie85ETAbqTDy4TcEmQG2RizWhEYf6GgxWiX5mbanm3aBR7JQdghQ/tzXzSui
         9Qd4/nXAkPN6vSB+dDLosInph4bRAF1hhIW8h1gmLOp/L86q2EXTSFbJCzdF/yFTTa
         CID0ZBYEZviZA==
Date:   Mon, 6 Dec 2021 16:25:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ameer Hamza <amhamza.mgc@gmail.com>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: initialize return variable on
 declaration
Message-ID: <20211206162510.35b85e74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206232953.065c0dc9@thinkpad>
References: <20211206113219.17640-1-amhamza.mgc@gmail.com>
        <Ya4OP+jQYd/UwiQK@lunn.ch>
        <20211206232953.065c0dc9@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 23:29:53 +0100 Marek Beh=C3=BAn wrote:
> On Mon, 6 Dec 2021 14:21:03 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
>=20
> > On Mon, Dec 06, 2021 at 04:32:19PM +0500, Ameer Hamza wrote: =20
> > > Uninitialized err variable defined in mv88e6393x_serdes_power
> > > function may cause undefined behaviour if it is called from
> > > mv88e6xxx_serdes_power_down context.
> > >=20
> > > Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
> > >=20
> > > Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> > > ---
> > >  drivers/net/dsa/mv88e6xxx/serdes.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv8=
8e6xxx/serdes.c
> > > index 55273013bfb5..33727439724a 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> > > @@ -1507,7 +1507,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_ch=
ip *chip, int port, int lane,
> > >  			    bool on)
> > >  {
> > >  	u8 cmode =3D chip->ports[port].cmode;
> > > -	int err;
> > > +	int err =3D 0;
> > > =20
> > >  	if (port !=3D 0 && port !=3D 9 && port !=3D 10)
> > >  		return -EOPNOTSUPP;   =20
> >=20
> > Hi Marek
> >=20
> > This warning likely comes from cmode not being a SERDES mode, and that
> > is not handles in the switch statementing. Do we want an
> >=20
> > default:
> > 	err =3D EINVAL;
> >=20
> > ?
>=20
> currently all the .serdes_power() methods return 0 for non-serdes ports.
> This is because the way it is written, these methods are not called if
> there is not a serdes lane for a given port.
>=20
> For this issue with err variable undefined, to fix it we should simply
> set int err=3D0 at the beginning of mv88e6393x_serdes_power(), to make it
> behave like other serdes_power() methods do in serdes.c.

Any objections to using a default case in the switch statement, tho?
I agree with Andrew that default statement would make the reasoning
clearer than just setting the variable at the start of the function.
