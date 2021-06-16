Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94C13A966C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhFPJmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhFPJmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:42:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11677C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 02:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xeaQuGZxJj8mR5i/Hcz8vi+8KzvggIOfSY02wQBou8s=; b=tcxs6gNcO7HLEvfbO4hoD38hw
        q++tMKDM87/GvoaAX/YQdZgF1xiCCkwNUktmUnloMC1LAsA3UWq19f8qIxBA2ZSIhY1YA4YjGhCt5
        YAMQOkVFaJ5O8dmfMAfimAF2o9xldzr/tJ+Ra245KT/O/S4YeRpoMtTpREIU5+nC04HXaI2Buf2Rn
        Hksi+cChUwtwd3UQlX7VIOSI05uJWS0KFN+evazPlNWCVKpBttttNOhcMiRMlwqBEmtL3tXhlq8zK
        Hq4j47x70VXS1SIE5sTYLL6r5gXbIuK7mrNzToE43YSzLYgM+GkBURxQkl0v98kTwctF0agqu4iar
        qVYRDOYHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45056)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ltS1t-0006ze-Od; Wed, 16 Jun 2021 10:40:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ltS1s-0005uy-4u; Wed, 16 Jun 2021 10:40:12 +0100
Date:   Wed, 16 Jun 2021 10:40:12 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, calvin.johnson@oss.nxp.com,
        hkallweit1@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210616094012.GA22278@shell.armlinux.org.uk>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
 <YMjx6iBD88+xdODZ@lunn.ch>
 <20210615210907.GY22278@shell.armlinux.org.uk>
 <20210615212153.fvfenkyqabyqp7dk@skbuf>
 <YMkcQ6F2FXWvpeKu@lunn.ch>
 <20210616082052.s56l54vycxilv5is@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616082052.s56l54vycxilv5is@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 11:20:52AM +0300, Ioana Ciornei wrote:
> On Tue, Jun 15, 2021 at 11:31:47PM +0200, Andrew Lunn wrote:
> > > The fwnode_operations declared in drivers/acpi/property.c also suggest
> > > the ACPI fwnodes are not refcounted.
> > 
> > Is this because ACPI is not dynamic, unlike DT, where you can
> > add/remove overlays at runtime?
> > 
> 
> I am really not an expert here but the git history suggests so, yes.
> 
> Without the CONFIG_OF_DYNAMIC enabled, the fwnode_handle_get() call is
> actually a no-op even in the OF case.

More accurately, of_node_get() is a no-op if CONFIG_OF_DYNAMIC is
disabled, which in turn makes fwnode_handle_get() also a no-op.

I'm wondering whether we would need two helpers to assign these, or
just a single helper that takes a fwnode and assigns both pointers.
to_of_node() returns NULL if the fwnode is not a DT node, so would
be safe to use even with ACPI.

Then there's the cleanup side when the device is released. I haven't
yet found where we release the reference to the fwnode/of_node when
we release the phy_device. I would have expected it in
phy_device_release() but that does nothing. We could only add that
when we are certain that all users who assign the firmware node to
the phy device has properly refcounted it in the DT case.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
