Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0007D459568
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 20:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbhKVTSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 14:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhKVTSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 14:18:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9470EC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 11:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X3OeF566y3m9Smi1CxM+sro2pR4hwHeMiF2bWsLsYig=; b=RDhAw415ITci6ZHPn6TLXvCbRb
        rwBW15ErzHzjRQbzfyvBbEHokeqFws1wWc6gCyw1uKlZxeMqrIheIi9Jx2EKEAAuAzUNEYoEafcuV
        WRI11AOEYaUHLyJJGJ2EnaYTovOK+/dz+FrBF+otHBsx20N516HGH/sozpr4NWne9Tt5bOKOj2Pb/
        KMf+HtWlZ44ZVqTac7PiEWgoYOdcAz8xSCOytocoeAvc81eRyT6OWP1uMpDGulEPtrVK9Y6XlJ1A1
        8C0nzfYFxhpcDYohcaqjmoMkZifKOHDHuu1FDfqbVgy88wf6+oPLhJwSS+QGEA7oenpyNsyhIl8BC
        waNxR2dA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55796)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpEmv-000736-7Y; Mon, 22 Nov 2021 19:15:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpEmk-0007wK-VJ; Mon, 22 Nov 2021 19:15:26 +0000
Date:   Mon, 22 Nov 2021 19:15:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>
Subject: Re: [net-next PATCH v6] net: macb: Fix several edge cases in validate
Message-ID: <YZvsTgN8Cx5c1Uta@shell.armlinux.org.uk>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
 <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
 <684f843f-e5a7-e894-d2cc-3a79a22faf36@seco.com>
 <YZRLQqLblRurUd4V@shell.armlinux.org.uk>
 <YZZymBHimAhx8lja@shell.armlinux.org.uk>
 <cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com>
 <YZfzSQBECA3Ew+IE@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZfzSQBECA3Ew+IE@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

Today's update...

On Fri, Nov 19, 2021 at 06:56:09PM +0000, Russell King (Oracle) wrote:
> > Say that you are a MAC with an integrated PCS (so you handle everything
> > in the MAC driver). You support GMII full and half duplex, but your PCS
> > only supports 1000BASE-X with full duplex. The naïve bitmap is
> > 
> > supported_interfaces = PHY_INTERFACE_GMII | PHY_INTERFACE_1000BASEX;
> > mac_capabilities = MAC_10 | MAC_100 | MAC_1000;
> > 
> > but this will report 1000BASE-X as supporting both full and half duplex.
> > So you still need a custom validate() in order to report the correct link
> > modes.
> 
> First, let me say that I've now been through all phylink users in the
> kernel, converting them, and there are seven cases where the generic
> helper can't be used. The validate() method isn't going away (at least
> not just yet) which allows unexpected situations to still be handled.
> The current state of this conversion is as follows.
> 
> In terms of network drivers:
> 
> mvneta and mvpp2: the generic helper is used but needs to be wrapped
>   since these specify that negotiation must not be disabled in
>   "1000BASE-X" mode, which includes the up-clocked 2500BASE-X.

Over the weekend, I've been able to eliminate these two with the
mac_select_pcs() method, and adding a pcs_validate() callback to the
PCS operations. The updated patches are in the net-queue branch.

> > > > Right now, "no pcs" is really not an option I'm afraid. The presence
> > > > of a PCS changes the phylink behaviour slightly . This is one of my
> > > > bug-bears. The evolution of phylink has meant that we need to keep
> > > > compatibility with how phylink used to work before we split the PCS
> > > > support - and we detect that by whether there is a PCS to determine
> > > > whether we need to operate with that compatibility. It probably was
> > > > a mistake to do that in hind sight.
> > 
> > Of course it's an option :)
> 
> I'm saying that with phylink as it is, phylink does _not_ support there
> being no PCS in a non-legacy driver, since the presence of a PCS is a
> flag that the driver is non-legacy. It changes the circumstances in
> which the mac_config() method is called.
> 
> If we want the PCS to become optional, then we need phylink to deal with
> detecting non-legacy drivers some other way (e.g. a legacy-mode flag in
> struct phylink_config), or we need to eliminate the legacy drivers by
> either converting them (which is always my preference) or deleting them.

... and over the weekend, I've implemented a flag "legacy_pre_march2020"
which is used to flag which drivers predate the changes to add PCS
support, allowing phylink to know whether they are legacy drivers or
not irrespective of whether they use a PCS.

So, I've updated the "mac_select_pcs" patch to allow NULL as a valid
return, and use error-pointers to indicate failure.

Then there's a following patch that adds a "pcs_validate" method which
gives the PCS an opportunity to have its say in the MAC validation
without the MAC having code to call the PCS - this change allowed mvneta
and mvpp2 to use phylink_generic_validate().

So, this is another step towards the end goal.

I'm planning to get lkp chew on the "legacy_pre_march2020" before I send
those out to netdev (which will be the next batch of patches), and then
will be the patches that add the ground work to allow DSA drivers to
become properly non-legacy.

Please have a look at my net-queue - are you happier with the
mac_select_pcs method now?

Once we've got this settled, and remaining drivers converted, my plan is
to kill off the old .validate method entirely. At that point,
"mac_capabilities" then becomes exactly that - the capabilities of the
MAC block irrespective of anything else.

Given bcm_sf2, I may need to add a method which allows the MAC to modify
those capabilities depending on the interface - bcm_sf2's pause frame
capabilities appear to be dependent on the interface mode. I'm tempted
to reverse the logic I have in bcm_sf2 in these patches - set
MAC_ASYM_PAUSE | MAC_SYM_PAUSE in mac_capabilities, and exclude them for
interface types that don't support pause frames.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
