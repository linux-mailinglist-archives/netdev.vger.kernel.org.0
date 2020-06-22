Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1820368D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgFVMQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgFVMQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:16:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00779C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 05:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z5KzTlzpHb2RnBQizjyuia1JeBYJC3uvtypd8lBydE8=; b=dBJUyaNn2ZV3vGy+SiMWUuk6x
        gJ7rpUBQLA6PlPhqASIuXq1g6ZEJ6NdldoLXIe00XzRgGmMSTfGzXibiZrwWqi/BaUyv2RNdfbun9
        qPKKwg5cN5XVSgl3K/DoCCXUsnxaezzYQbsPrkT7AsEt3m/oumAfPL4HKuzceIllOzi8nzvEZp1wp
        I/aUY+JhWcCelpLX5roVFJglesUEtBYrMi2OCkkMM94tvZMuiEvQXyolax582AiWhZTCH7PL1ReSN
        foeqSmJ/FWh98vcZTLFqr/hoET53LKpLnaeL7LazkHiGOA73SmrN4JcR5jAS4+M5ntYrPIHmPb1IL
        CzHWnKJIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58958)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnLMz-00006a-J9; Mon, 22 Jun 2020 13:16:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnLMv-0008Uk-TC; Mon, 22 Jun 2020 13:16:09 +0100
Date:   Mon, 22 Jun 2020 13:16:09 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
Message-ID: <20200622121609.GN1605@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-6-ioana.ciornei@nxp.com>
 <20200622102213.GD1551@shell.armlinux.org.uk>
 <20200622111057.GM1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622111057.GM1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 12:10:57PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Jun 22, 2020 at 11:22:13AM +0100, Russell King - ARM Linux admin wrote:
> > On Mon, Jun 22, 2020 at 01:54:47AM +0300, Ioana Ciornei wrote:
> > > In order to support split PCS using PHYLINK properly, we need to add a
> > > phylink_pcs_ops structure.
> > > 
> > > Note that a DSA driver that wants to use these needs to implement all 4
> > > of them: the DSA core checks the presence of these 4 function pointers
> > > in dsa_switch_ops and only then does it add a PCS to PHYLINK. This is
> > > done in order to preserve compatibility with drivers that have not yet
> > > been converted, or don't need, a split PCS setup.
> > > 
> > > Also, when pcs_get_state() and pcs_an_restart() are present, their mac
> > > counterparts (mac_pcs_get_state(), mac_an_restart()) will no longer get
> > > called, as can be seen in phylink.c.
> > 
> > I don't like this at all, it means we've got all this useless layering,
> > and that layering will force similar layering veneers into other parts
> > of the kernel (such as the DPAA2 MAC driver, when we eventually come to
> > re-use pcs-lynx there.)
> > 
> > I don't think we need that - I think we can get to a position where
> > pcs-lynx is called requesting that it bind to phylink as the PCS, and
> > it calls phylink_add_pcs() directly, which means we do not end up with
> > veneers in DSA nor in the DPAA2 MAC driver - they just need to call
> > the pcs-lynx initialisation function with the phylink instance for it
> > to attach to.
> > 
> > Yes, that requires phylink_add_pcs() to change slightly, and for there
> > to be a PCS private pointer, as I have previously stated.  At the
> > moment, changing that is really easy - the phylink PCS backend has no
> > in-tree users at the moment.  So there is no reason not to get this
> > correct right now.
> 
> How about something like this?  I don't want to embed a mdio_device
> inside struct phylink_pcs because that would not be appropriate for
> some potential users (e.g., Marvell 88E6xxx DSA drivers, Marvell
> NETA, PP2, etc.)

Just to be clear, I'm expecting discussion on this approach, rather
than a patch series appearing - I've already tweaked this patch
slightly, adding a "poll" option to cater for the "pcs_poll" facility
that was introduced into the phylink_config structure - which I think
makes more sense here, as it's all part of the PCS.

I'd like there to be some concensus _before_ I go through the users
I have in my tree converting them to this, rather than converting
them, and then having to convert them to something else.

So, if we can agree on what this should look like, then I feel it
would make the development process a lot easier for everyone
concerned.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
