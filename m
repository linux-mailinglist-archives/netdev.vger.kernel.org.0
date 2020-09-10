Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15B52648F1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgIJPkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 11:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731351AbgIJPiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:38:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3796920C09;
        Thu, 10 Sep 2020 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599752328;
        bh=NIWK7u0uf6CHYTlKQR3LLR6v8mRh7i5XJsVnx7bR05g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fI0DzYR7V1qdcE+68bhHsXGhaMppt47hcFZibA4Ea31eW4Chc4LGkkeZsdfYjk7mj
         A/iC7skJBk9UsrexsFLmk2oUMKgZ/ECI8hHNPHUmQGL6KRM3g7b3eckkVFQS5Vxhxb
         1w4bWPwQZSB+Yt0HF/uAxYg/FzMbARK1leJ/syFg=
Date:   Thu, 10 Sep 2020 08:38:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net-next 2/9] net: devlink: region: Pass the region
 ops to the snapshot function
Message-ID: <20200910083846.7910f538@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910150950.GC3354160@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
        <20200909235827.3335881-3-andrew@lunn.ch>
        <20200910073816.5b089bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200910150950.GC3354160@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 17:09:50 +0200 Andrew Lunn wrote:
> On Thu, Sep 10, 2020 at 07:38:16AM -0700, Jakub Kicinski wrote:
> > On Thu, 10 Sep 2020 01:58:20 +0200 Andrew Lunn wrote: =20
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/n=
et/ethernet/intel/ice/ice_devlink.c
> > > index 111d6bfe4222..eb189d2070ae 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> > > @@ -413,6 +413,7 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
> > >   * error code on failure.
> > >   */
> > >  static int ice_devlink_nvm_snapshot(struct devlink *devlink,
> > > +				    const struct devlink_region_ops *ops,
> > >  				    struct netlink_ext_ack *extack, u8 **data)
> > >  {
> > >  	struct ice_pf *pf =3D devlink_priv(devlink);
> > > @@ -468,6 +469,7 @@ static int ice_devlink_nvm_snapshot(struct devlin=
k *devlink,
> > >   */
> > >  static int
> > >  ice_devlink_devcaps_snapshot(struct devlink *devlink,
> > > +			     const struct devlink_region_ops *ops,
> > >  			     struct netlink_ext_ack *extack, u8 **data)
> > >  {
> > >  	struct ice_pf *pf =3D devlink_priv(devlink); =20
> >=20
> >=20
> > drivers/net/ethernet/intel/ice/ice_devlink.c:418: warning: Function par=
ameter or member 'ops' not described in 'ice_devlink_nvm_snapshot'
> > drivers/net/ethernet/intel/ice/ice_devlink.c:474: warning: Function par=
ameter or member 'ops' not described in 'ice_devlink_devcaps_snapshot' =20
>=20
> Thanks Jakub
>=20
> I did try a W=3D1 build, but there are so many warnings it is hard to
> pick out the new ones. I assume you have some sort of automation for
> this? Could you share it?

I knew you'd ask :)

The scripts are here: https://github.com/kuba-moo/nipa
but they run off a private patchwork instance, I was planning to make
it possible for it to consume a local mdir:

https://github.com/kuba-moo/nipa/blob/master/ingest_mdir.py

But that has probably bit rotted completely by now.

I submit my own patches to netdev and check if I broke anything later.

> How far are we from just enabling W=3D1 by default under drivers/net ?

I think pretty far :(

> What is the best way to do this in the Makefiles? I think
> drivers/net/phy is now W=3D1 clean, or very close. So it would be nice
> to enable that checking by default.

No idea =F0=9F=A4=94
