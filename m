Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24B435D41D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344189AbhDLXqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237290AbhDLXqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 19:46:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CB6061278;
        Mon, 12 Apr 2021 23:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618271149;
        bh=QRIInDklK16Ym/43NY2Bvzrh8ZTmiRAiyJRfrUabGpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XFpiTYrmI2eNTJprFnnSFChlZDgqgDu1IHOvc7YS45+kb5dxAOGzw8PGt7y8GyQGD
         0HGvbNrRlZplIxqPYpzYT/XbQMEn4DUDzHgdVFeBPPDbDTMY3ps4ulDCzrdA9GBjHQ
         vOkKDZ2WJaaqK+RcE4GITJ3r2BGxab4E8Bqgj2N9UrefkFF+D1+W7pS4pGKeSzU+cT
         1kdtDxQgXqvdBRZkC3QWY5V8s0Jnk1yexmtnoqjGRl7LXGWQ8imR4I5HmEYYP3RsV5
         i6RO+ffz1CCjDL928gs7O3FKN8sk4MQndgoYNHWKFHL7ETVQJLlu7SU0jyFRp+H0Nu
         kZdFH/yWp38NA==
Date:   Tue, 13 Apr 2021 01:45:45 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz
 switches
Message-ID: <20210413014545.1bb4601e@thinkpad>
In-Reply-To: <20210412163829.kp7feb3yhzymukg2@pali>
References: <20210412121430.20898-1-pali@kernel.org>
        <YHRH2zWsYkv/yjYz@lunn.ch>
        <20210412133447.fyqkavrs5r5wbino@pali>
        <YHRcu+dNKE7xC8EG@lunn.ch>
        <20210412150152.pbz5zt7mu3aefbrx@pali>
        <YHRoEfGi3/l3K6iF@lunn.ch>
        <20210412155239.chgrne7uzvlrac2e@pali>
        <YHRxcyezvUij82bl@lunn.ch>
        <20210412163829.kp7feb3yhzymukg2@pali>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 18:38:29 +0200
Pali Roh=C3=A1r <pali@kernel.org> wrote:

> On Monday 12 April 2021 18:12:35 Andrew Lunn wrote:
> > On Mon, Apr 12, 2021 at 05:52:39PM +0200, Pali Roh=C3=A1r wrote: =20
> > > On Monday 12 April 2021 17:32:33 Andrew Lunn wrote: =20
> > > > > Anyway, now I'm looking at phy/marvell.c driver again and it supp=
orts
> > > > > only 88E6341 and 88E6390 families from whole 88E63xxx range.
> > > > >=20
> > > > > So do we need to define for now table for more than
> > > > > MV88E6XXX_FAMILY_6341 and MV88E6XXX_FAMILY_6390 entries? =20
> > > >=20
> > > > Probably not. I've no idea if the 6393 has an ID, so to be safe you
> > > > should add that. Assuming it has a family of its own. =20
> > >=20
> > > So what about just?
> > >=20
> > > 	if (reg =3D=3D MII_PHYSID2 && !(val & 0x3f0)) {
> > > 		if (chip->info->family =3D=3D MV88E6XXX_FAMILY_6341)
> > > 			val |=3D MV88E6XXX_PORT_SWITCH_ID_PROD_6341 >> 4;
> > > 		else if (chip->info->family =3D=3D MV88E6XXX_FAMILY_6390)
> > > 			val |=3D MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
> > > 	} =20
> >=20
> > As i said, i expect the 6393 also has no ID. And i recently found out
> > Marvell have some automotive switches, 88Q5xxx which are actually
> > based around the same IP and could be added to this driver. They also
> > might not have an ID. I suspect this list is going to get longer, so
> > having it table driven will make that simpler, less error prone.
> >=20
> >      Andrew =20
>=20
> Ok, I will use table but I fill it only with Topaz (6341) and Peridot
> (6390) which was there before as I do not have 6393 switch for testing.
>=20
> If you or anybody else has 6393 unit for testing, please extend then
> table.

6393 PHYs report PHY ID 0x002b0808, I.e. no model number.

I now realize that I did not implement this for 6393, these PHYs are
detected as
  mv88e6085 ... PHY [...] driver [Generic PHY] (irq=3DPOLL)

And it seems that this temperature sensor is different from 1510, 6341
and 6390 :) I will look into this and send a patch.

Marek
