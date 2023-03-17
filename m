Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7386BE4B8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjCQJCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbjCQJBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:01:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57EF5F6C5
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 02:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679043616; x=1710579616;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Bjj+/Bat4zbDauUwClBvI0c6p8g4k1wYXE/0ELyZFRI=;
  b=OGVljE8CXeTBogpKE4QAKeYYuUbqkOH5MLBqNHZQJsBNlhANc2tAF3xM
   76Wl4vDj3L97u2ll0XfFYIKTF2r7WeWIj+Sy0w5GV/DiiVkeOBFHM1yP3
   4NqhSKCt5gmUXY5mx3jZZkxE5R6gisEVnPB9VtvoW+jVc/BeQoK74D+KL
   vrIdbJfeuBwl9XR3GC4LpPYDd1fXZqr/FU0CGiqM2iPNDkEbHMUlEL181
   SDVKeO4yaF2To5vZPe079OcAGmBY6SXFYsqJKTHHsJ1J6ZIKoIunAzAJt
   OUkSPxj5q7s+KnYsbAt8ydtjByNqoAaoRxTyPwPWzhPzB2EHdupiNReYO
   g==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673938800"; 
   d="scan'208";a="205181102"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2023 01:59:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:59:45 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 01:59:43 -0700
Message-ID: <0f7be52d197fee7f643217341b057185b7e9f9d1.camel@microchip.com>
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: remove double-read of link
 state when using AN
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan McDowell <noodles@earth.li>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>
Date:   Fri, 17 Mar 2023 09:59:42 +0100
In-Reply-To: <ZBM/4H/BKZpjghB/@shell.armlinux.org.uk>
References: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
         <E1pcSOp-00DiAo-Su@rmk-PC.armlinux.org.uk>
         <918d1908c2771f4941c191b73c495e20d89a6a99.camel@microchip.com>
         <ZBM/4H/BKZpjghB/@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Thu, 2023-03-16 at 16:12 +0000, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Thu, Mar 16, 2023 at 10:44:48AM +0100, Steen Hegelund wrote:
> > Hi Russell,
> >=20
> >=20
> > On Wed, 2023-03-15 at 14:46 +0000, Russell King (Oracle) wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you kno=
w the
> > > content is safe
> > >=20
> > > Phylink does not want the current state of the link when reading the
> > > PCS link state - it wants the latched state. Don't double-read the
> > > MII status register. Phylink will re-read as necessary to capture
> > > transient link-down events as of dbae3388ea9c ("net: phylink: Force
> > > retrigger in case of latched link-fail indicator").
> > >=20
> > > The above referenced commit is a dependency for this change, and thus
> > > this change should not be backported to any kernel that does not
> > > contain the above referenced commit.
> > >=20
> > > Fixes: fcb26bd2b6ca ("net: phy: Add Synopsys DesignWare XPCS MDIO mod=
ule")
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > ---
> > > =C2=A0drivers/net/pcs/pcs-xpcs.c | 13 ++-----------
> > > =C2=A01 file changed, 2 insertions(+), 11 deletions(-)
> > >=20
> > > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > > index bc428a816719..04a685353041 100644
> > > --- a/drivers/net/pcs/pcs-xpcs.c
> > > +++ b/drivers/net/pcs/pcs-xpcs.c
> > > @@ -321,7 +321,7 @@ static int xpcs_read_fault_c73(struct dw_xpcs *xp=
cs,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> > > =C2=A0}
> > >=20
> > > -static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
> > > +static int xpcs_read_link_c73(struct dw_xpcs *xpcs)
> > > =C2=A0{
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool link =3D true;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> > > @@ -333,15 +333,6 @@ static int xpcs_read_link_c73(struct dw_xpcs *xp=
cs,
> > > bool an)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(ret & MDIO_STAT1_LST=
ATUS))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 link =3D false;
> > >=20
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (an) {
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ret =3D xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (ret < 0)
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return r=
et;
> > > -
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (!(ret & MDIO_STAT1_LSTATUS))
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 link =3D=
 false;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > > -
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return link;
> > > =C2=A0}
> > >=20
> > > @@ -935,7 +926,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpc=
s,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Link needs to be read f=
irst ... */
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state->link =3D xpcs_read_link_=
c73(xpcs, state->an_enabled) > 0 ? 1
> > > : 0;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state->link =3D xpcs_read_link_=
c73(xpcs) > 0 ? 1 : 0;
> >=20
> > Couldn't you just say:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state->link =3D xpcs_read_link_c73(xpcs)=
 > 0;
> >=20
> > That should be a boolean, right?
>=20
> That would be another change to the code - and consider how such a
> change would fit in this series given its description and also this
> patch.
>=20
> IMHO such a change should be a separate patch - and there's plenty
> of scope for cleanups like the one you suggest in this driver.
>=20
> Thanks.

OK - got that!


> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

BR
Steen
