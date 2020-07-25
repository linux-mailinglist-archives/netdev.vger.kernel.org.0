Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C837622D8F4
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 19:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGYRgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 13:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgGYRgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 13:36:00 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B04C08C5C0;
        Sat, 25 Jul 2020 10:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HowW+Suxtz81TGSiwDpCJ7aR4PS/v+JI8UnNpehKgCE=; b=oOORTrLpzGR+70FTjP4Dkq+xaI
        Xs0eT0sxpQtOKCzXpGTjR9dJ3uJgMeXl/JrQd5R49//pxd35nUX5TQoSQmzZFfQsZZrC0dYdCfsJx
        CzspIbVu2x0+Mk/Ha9V9Oq3M0SAT4SqMqmBLZefEWxz4zWwKp3kmmg7oUSWVdNxCp6uGGZ5tT9DjS
        M+zkf1WNIL22p/zkIJgQ/GHJdTVqoljqFF5H3VA9KmX8vmcGR4kFA3gA5lziS+oSEe9+MFMpmrO/+
        iyQAyKo0SgS6WtlWbbzyP8xYjpW75u0dDSmNkdSp2A2izmdmoJKgz19wGETqFvKxSmD4RvMH5qeTJ
        wqrJwTiA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jzO5P-0003kw-Bu; Sat, 25 Jul 2020 18:35:51 +0100
Date:   Sat, 25 Jul 2020 18:35:51 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200725173551.GN23489@earth.li>
References: <20200721171624.GK23489@earth.li>
 <1bf941f5-fdb3-3d9b-627a-a0464787b0ab@gmail.com>
 <20200722193850.GM23489@earth.li>
 <77c136d0-c183-ebb5-5954-647e08c8ec18@gmail.com>
 <20200722225847.ssuxebcwr3fr5fh7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722225847.ssuxebcwr3fr5fh7@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 01:58:47AM +0300, Vladimir Oltean wrote:
> On Wed, Jul 22, 2020 at 03:36:38PM -0700, Florian Fainelli wrote:
> > On 7/22/20 12:38 PM, Jonathan McDowell wrote:
> > > On Tue, Jul 21, 2020 at 10:26:07AM -0700, Florian Fainelli wrote:
> > >> On 7/21/20 10:16 AM, Jonathan McDowell wrote:
> > >>> This adds full 802.1q VLAN support to the qca8k, allowing the use of
> > >>> vlan_filtering and more complicated bridging setups than allowed by
> > >>> basic port VLAN support.
> > >>>
> > >>> Tested with a number of untagged ports with separate VLANs and then a
> > >>> trunk port with all the VLANs tagged on it.
> > >>
> > >> This looks good to me at first glance, at least not seeing obvious
> > >> issue, however below are a few questions:
> > > 
> > > Thanks for the comments.
> > > 
> > >> - vid == 0 appears to be unsupported according to your port_vlan_prepare
> > >> callback, is this really the case, or is it more a case of VID 0 should
> > >> be pvid untagged, which is what dsa_slave_vlan_rx_add_vid() would
> > >> attempt to program
> > > 
> > > I don't quite follow you here. VID 0 doesn't appear to be supported by
> > > the hardware (and several other DSA drivers don't seem to like it
> > > either), hence the check; I'm not clear if there's something alternate I
> > > should be doing in that case instead?
> > 
> > Is it really that the hardware does not support it, or is it that it was
> > not tried or poorly handled before? If the switch supports programming
> > the VID 0 entry as PVID egress untagged, which is what
> > dsa_slave_vlan_rx_add_vid() requests, then this is great, because you
> > have almost nothing to do.
> > 
> > If not, what you are doing is definitively okay, because you have a
> > port_bridge_join that ensures that the port matrix gets configured
> > correctly for bridging, if that was not supported we would be in trouble.
> 
> Things added by dsa_slave_vlan_rx_add_vid() are definitely not "pvid
> untagged", they are installed with flags=0 which means "non-pvid,
> egress-tagged", aka a simple vlan with tagged ingress and egress.
> 
> The case of VLAN 0 is special because according to 802.1Q it is "not a
> VLAN", but simply a way to transmit the other stuff in a VLAN header,
> namely a class of service (VLAN PCP). The VLAN ID should not be used for
> segregation of forwarding domains, should not be assigned as port-based
> VLAN to untagged traffic (from what I recall from the 802.1Q standard)
> and should always be sent as egress-tagged.
...
> So maybe it's worth checking what is your switch's behavior with regard
> to VLAN 0. If it already does what's supposed to, then you might just as
> well stop fighting the system and silently accept the configuration
> while not doing anything.  As Russell implied, the bridge can't add a
> VLAN of 0. It is just the 8021q module that does it.  The fact that we
> have the same callbacks being used for both in DSA is merely an artefact
> of implementation.

Ok, thanks for the clarification, that helps a lot.

I've done some experimentation injecting packets on untagged ports with
VLAN 0 headers. It looks like it's doing the right thing; the intact
VLAN 0 / classification comes through to the CPU port, and the packet is
also correctly sent out tagged with the correct VLAN (from the untagged
port configuration) on a trunk port. So I think I can just silently drop
the request for VLAN 0 configuration rather than returning an error.

> > >> - since we have a qca8k_port_bridge_join() callback which programs the
> > >> port lookup control register, putting all ports by default in VID==1
> > >> does not break per-port isolation between non-bridged and bridged ports,
> > >> right?
> > > 
> > > VLAN_MODE_NONE (set when we don't have VLAN filtering enabled)
> > > configures us for port filtering, ignoring the VLAN info, so I think
> > > we're good here.
> > 
> > OK, good, so just to be sure, there is no cross talk between non-bridged
> > ports and bridged ports even when VLAN filtering is not enabled on the
> > bridge, right?

Yup. When VLAN filtering is off off we only allow ports to talk to each
other that we get bridge_join calls for (that's the way the device is
currently supported by the kernel).

J.

-- 
/-\                             |  Be Ye Not Lost Among Precepts of
|@/  Debian GNU/Linux Developer |                Order
\-                              |
