Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224511FCC04
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgFQLQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:16:02 -0400
Received: from mail.intenta.de ([178.249.25.132]:42855 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgFQLPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 07:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=9ms7Wgh1QZ7oVZDkbZOFznET7IscPNYrYLXyEq5EI0I=;
        b=reENZBcUqQ2gxFcRWzyrJehly+o2ry/h/0jmIPsqWArDkYukmdkzL2FWjRKXQmK6GhzwH1qCGBRZ8UTLw+a76xnzU1J33g8zwoSYDBUaJn0qrTVhx9AlRCY6dFbvXjazcINdnNpK6uMdV2dW7DWstHyO1wKsiwf6jOIhqsbeVx6+UsS8zuGNzxm/S03O7XmWS/vXmGWsildLxHtyLlKqGvZK1yNazW0Q8Ry7d/YTbXyCNxC7Izomu+zEQl3P5iyJkukmFyGgBPhQs8Aohfl0lRIqVIcxZQsjZgrwWgkUWdQ3PGVRYSaIVN30t41hptQK1qP1f4MnnA1ERnDVS8sdOQ==;
Date:   Wed, 17 Jun 2020 13:15:32 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617111532.GA28783@laureti-dev>
References: <20200616074955.GA9092@laureti-dev>
 <CA+h21hoTQzGwF5wYx3-0Fa_rUYWw+m2CVcBV8WUQ7OtK3DHpQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+h21hoTQzGwF5wYx3-0Fa_rUYWw+m2CVcBV8WUQ7OtK3DHpQA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Jun 17, 2020 at 11:57:23AM +0200, Vladimir Oltean wrote:
> On Tue, 16 Jun 2020 at 11:00, Helmut Grohne <helmut.grohne@intenta.de> wrote:
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -514,7 +514,7 @@ static void macb_validate(struct phylink_config *config,
> >             state->interface != PHY_INTERFACE_MODE_RMII &&
> >             state->interface != PHY_INTERFACE_MODE_GMII &&
> >             state->interface != PHY_INTERFACE_MODE_SGMII &&
> > -           !phy_interface_mode_is_rgmii(state->interface)) {
> > +           state->interface != PHY_INTERFACE_MODE_RGMII_ID) {
> 
> I don't think this change is correct though?
> What if there were PCB traces in place, for whatever reason? Then the
> driver would need to accept a phy with rgmii-txid, rgmii-rxid or
> rgmii.

I must confess that after rereading the discussion and the other
discussions at
https://patchwork.ozlabs.org/project/netdev/patch/20190410005700.31582-19-olteanv@gmail.com/
and
https://patchwork.ozlabs.org/project/netdev/patch/20190413012822.30931-21-olteanv@gmail.com/,
this is less and less clear to me.

I think we can agree that the current definition of phy-mode is
confusing when it comes to rgmii delays. The documentation doesn't even
mention the possibility of using serpentines.

Your interpretation seems to be that this value is solely meant for the
PHY to operate on and that the MAC should not act upon it (at least the
delay part). That interpetation is consistent with previous discussions
and mostly consistent with the documentation. The phy-mode property is
documented in ethernet-controller.yaml, which suggests that it should
apply to the MAC somehow.

Following this interpretation, I think it would be good to also document
it in ethernet-phy.yaml.

Thank you for the review. I agree that the hunk should be dropped.

However, in the fixed-link case (below) the interpretation regarding
serpentines seems to be well-defined: If serpentines are present, both
MACs should specify rgmii.

> >                 bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> >                 return;
> >         }
> > @@ -694,6 +694,13 @@ static int macb_phylink_connect(struct macb *bp)
> >         struct phy_device *phydev;
> >         int ret;
> >
> > +       if (of_phy_is_fixed_link(dn) &&
> > +           phy_interface_mode_is_rgmii(bp->phy_interface) &&
> > +           bp->phy_interface != PHY_INTERFACE_MODE_RGMII) {
> > +               netdev_err(dev, "RGMII delays are not supported\n");
> > +               return -EINVAL;
> > +       }
> > +
> 
> Have you checked that this doesn't break any existing in-tree users?

It seems like all the in-tree users of this driver that do specify a
phy-mode, specify rmii.

If possible breakage is to be minimized, I'd be happy with using
netdev_warn instead. The major benefit here is getting a clear
indication of why things don't work. My emphasis is on getting something
to dmesg, not to make things fail.

So what should we prefer here? Failure or warning?

In the long run, it would be nice to refactor the way to denote delays
in a way that is consistently defined for MAC to PHY and MAC to MAC
connections while accounting for serpentines.

Helmut
