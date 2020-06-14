Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8525C1F89CF
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 19:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFNRUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 13:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbgFNRUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 13:20:22 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081A7C05BD43;
        Sun, 14 Jun 2020 10:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XXdAxRlWJJhbMn3pgE+3Xhvkc6IvWZxD6awKfKfAO9I=; b=cObSm3wsTCY3i1axrs9XEwCog4
        bchJLL0Na5nIW0CEDBEF+HBL62Zca1KXECMO5/3kVo2qRhWYSIq9ebGfrPFSNomwvmvYL4NaP9c85
        Tpe3MUIP6WNhqY3o3htgQr+wd2XbJjOHUVZEfk3nf2iisDBazY07e1Pu4JfYu/UbFfStoxcHF1kra
        QWtOQgTn1TgfMm+SoWePhrri96e54IhQJUKoi5UiiCLiHU29sIk8aC8CyOEsMLaCSAAhW8Awr9WcP
        o4V8vee03n4lO9rc04hkLbL4HHL2GJNOEl7tX3tcJSfcfaX7X5MC4+bWFkotCCWE0xcQIfV2dPipo
        c8o3swkg==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jkWIk-0003MZ-0w; Sun, 14 Jun 2020 18:20:10 +0100
Date:   Sun, 14 Jun 2020 18:20:10 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v4 2/2] net: dsa: qca8k: Improve SGMII interface
 handling
Message-ID: <20200614172009.GA17897@earth.li>
References: <cover.1592047530.git.noodles@earth.li>
 <05dba86946541267e64438c2001aaeea16916391.1592047530.git.noodles@earth.li>
 <CA+h21hoCb4w2s=KHT_nemFsYn-W9BctB=ycfTUb5DPdiW=SLiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoCb4w2s=KHT_nemFsYn-W9BctB=ycfTUb5DPdiW=SLiA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 13, 2020 at 11:10:49PM +0300, Vladimir Oltean wrote:
> On Sat, 13 Jun 2020 at 14:32, Jonathan McDowell <noodles@earth.li> wrote:
> >
> > This patch improves the handling of the SGMII interface on the QCA8K
> > devices. Previously the driver did no configuration of the port, even if
> > it was selected. We now configure it up in the appropriate
> > PHY/MAC/Base-X mode depending on what phylink tells us we are connected
> > to and ensure it is enabled.
> >
> > Tested with a device where the CPU connection is RGMII (i.e. the common
> > current use case) + one where the CPU connection is SGMII. I don't have
> > any devices where the SGMII interface is brought out to something other
> > than the CPU.
> >
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > ---
> >  drivers/net/dsa/qca8k.c | 33 ++++++++++++++++++++++++++++++++-
> >  drivers/net/dsa/qca8k.h | 13 +++++++++++++
> >  2 files changed, 45 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index dadf9ab2c14a..da7d2b92ed3e 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -673,6 +673,9 @@ qca8k_setup(struct dsa_switch *ds)
> >         /* Flush the FDB table */
> >         qca8k_fdb_flush(priv);
> >
> > +       /* We don't have interrupts for link changes, so we need to poll */
> > +       priv->ds->pcs_poll = true;
> > +
> 
> You can access ds directly here.

Good point, thanks.

> >         return 0;
> >  }
> >
> > @@ -681,7 +684,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >                          const struct phylink_link_state *state)
> >  {
> >         struct qca8k_priv *priv = ds->priv;
> > -       u32 reg;
> > +       u32 reg, val;
> >
> >         switch (port) {
> >         case 0: /* 1st CPU port */
> > @@ -740,6 +743,34 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >         case PHY_INTERFACE_MODE_1000BASEX:
> >                 /* Enable SGMII on the port */
> >                 qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> > +
> > +               /* Enable/disable SerDes auto-negotiation as necessary */
> > +               val = qca8k_read(priv, QCA8K_REG_PWS);
> > +               if (phylink_autoneg_inband(mode))
> > +                       val &= ~QCA8K_PWS_SERDES_AEN_DIS;
> > +               else
> > +                       val |= QCA8K_PWS_SERDES_AEN_DIS;
> > +               qca8k_write(priv, QCA8K_REG_PWS, val);
> > +
> > +               /* Configure the SGMII parameters */
> > +               val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
> > +
> > +               val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> > +                       QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> > +
> > +               if (dsa_is_cpu_port(ds, port)) {

> I don't see any device tree in mainline for qca,qca8334 that uses
> SGMII on the CPU port, but there are some assumptions being made here,
> and there are also going to be some assumptions made in the MAC
> driver, and I just want to make sure that those assumptions are not
> going to be incompatible, so I would like you to make some
> clarifications.

FWIW I have a DTS for the MikroTik RB3011 that should hopefully make it
to 5.9 via the linux-msm tree, which has 2 qca,qca8337 devices, one
connected via rgmii, one connected via sgmii. Sadly not chained to each
other, instead connected to different CPU ethernet ports.

> So there's a single SGMII interface which can go to port 0 (the CPU
> port) or to port 6, right? The SGMII port can behave as an AN master
> or as an AN slave, depending on whether MODE_CTRL is 1 or 2, or can
> have a forced speed (if SERDES_AEN is disabled)?

Yes.

> We don't have a standard way to describe an SGMII AN master that is
> not a PHY in the device tree, because I don't think anybody needed to
> do that so far.
>
> Typically a MAC would describe the link towards the CPU port of the
> switch as a fixed-link. In that case, if the phy-mode is sgmii, it
> would disable in-band autoneg, because there's nothing really to
> negotiate (the link speed and duplex is fixed). For these, I think the
> expectation is that the switch does not enable in-band autoneg either,
> and has a fixed-link too. Per your configuration, you would disable
> SerDes AN, and you would configure the port as SGMII AN master (PHY),
> but that setting would be ignored because AN is disabled.

Right; this is the situation with my device. There's a fixed-link stanza
in the DT.

> In other configurations, the MAC might want to receive in-band status
> from the CPU port. In those cases, your answer to that problem seems
> to be to implement phylink ops on both drivers, and to set both to
> managed = "in-band-status" (MLO_AN_INBAND). This isn't a use case
> explicitly described by phylink (I would even go as far as saying that
> MLO_AN_INBAND means to be an SGMII AN slave), but it would work
> because of the check that we are a CPU port.

> As for the case of a cascaded qca8334-to-qca8334 setup, this would
> again work, because on one of the switches, dsa_is_cpu_port would be
> true and on the other one it would be false.

> So I'm not suggesting we should change anything, I just want to make
> sure I understand if this is the reason why you are configuring it
> like this.

My primary concern was not breaking any existing users; after a reset
the switch enabled AN on the SGMII port. I agree it's unlikely that this
would be the case, but I erred on the side of caution, while also trying
to handle what seem to be the sensible common cases.

J.

-- 
He's weird? It's ok, I'm fluent in weird.
