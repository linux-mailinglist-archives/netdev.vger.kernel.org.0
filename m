Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031B155A4A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFYVxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:53:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59250 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYVxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=deOVYdFFYkcHu9wZG5qa/qLbz0oqLBMHZXk/udGRPFs=; b=Mptb2CI+u4aX2PweVUjMKHnxn
        IazRltUCx73c5lY8KG8H8Qt15Kyw9vaCKMaxUWp4b/CRN5GaDswnZizCdlQh9PhwARzY/PVmSvb6P
        p9B4sFczvUXDxRfTfgNCY8XYnxA+uPcCJCmon96RZvOxaL+NzjDCQgo8oskF3wWWloM3U1rQngEjG
        OOsSJMRJRfiZOqPqsp0fbkHY6cPS2lU5XehpsqmsrpQmaSoYA1KWSzQZqktiBXs1+k8EoSXjzkNib
        3Db8EoDreYq55rvxo23X7JodVR/D29B/54aiUVvUO91C1nxrA3rIcqIJPgcpTrxYNDv/4XCJxdz0e
        /BwA9Lklg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59016)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hftNd-0000iZ-Ck; Tue, 25 Jun 2019 22:53:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hftNZ-0007ZT-G1; Tue, 25 Jun 2019 22:53:29 +0100
Date:   Tue, 25 Jun 2019 22:53:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190625215329.5ubixxiwprnubwmv@shell.armlinux.org.uk>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <6f80325d-4b42-6174-e050-48626f7a3662@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f80325d-4b42-6174-e050-48626f7a3662@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:24:01PM +0300, Vladimir Oltean wrote:
> Hi Russell,
> 
> On 6/24/19 6:39 PM, Russell King - ARM Linux admin wrote:
> > This should be removed - state->link is not for use in mac_config.
> > Even in fixed mode, the link can be brought up/down by means of a
> > gpio, and this should be dealt with via the mac_link_* functions.
> > 
> 
> What do you mean exactly that state->link is not for use, is that true in
> general?

Yes.  mac_config() should not touch it; it is not always in a defined
state.  For example, if you set modes via ethtool (the
ethtool_ksettings_set API) then state->link will probably contain
zero irrespective of the true link state.

It exists in this structure because it was convenient to just use one
structure to store all the link information in various parts of the
code, and when requesting the negotiated in-band MAC configuration.

I've come to the conclusion that that decision was a mistake, based
on patches such as the above mistakenly thinking that everything in
the state structure is fair game.  I've since updated the docs to
explicitly spell it out, but I'm also looking at the feasibility of
changing the mac_config() interface entirely - splitting it into two
(mac_config_fixed() and mac_config_inband()) and passing only the
appropriate parameters to each.

However, having looked at that, I think such a change will make some
MAC drivers quite a bit more complicated - having all the config
steps in one method appears to make the configuration of MAC drivers
easier (eg, mvneta, mvpp2.)

> In drivers/net/dsa/sja1105/sja1105_main.c, if I remove the "if
> (!state->link)" guard, I see PHYLINK calls with a SPEED_UNKNOWN argument for
> ports that are BR_STATE_DISABLED. Is that normal?

This looks like another driver which has been converted to phylink
without my review; I certainly wasn't aware of it.  It gets a few
things wrong, such as:

1) not checking state->interface in the validate callback - so it
   is basically saying that it can support any PHY interface mode
   that the kernel happens to support.

2) if phylink is configured to use in-band, then state->speed is
   undefined; this driver will fail.  (If folk don't want to support
   that, we ought to have a way to tell phylink to reject anything
   that attempts to set it to in-band mode!)

3) it doesn't implement phylink_mac_link_state DSA ops, so it doesn't
   support SGMII or 802.3z phy interface modes (see 1).

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
