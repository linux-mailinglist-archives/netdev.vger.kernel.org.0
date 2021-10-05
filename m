Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95274222A6
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhJEJuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJEJuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 05:50:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FB6C06161C;
        Tue,  5 Oct 2021 02:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HIo2aCXY4RPVQU/Hm5Gq2nvMpxEwV3G/HpRH5pcWZsw=; b=DpEcNNx2E0xJDw7NvmJ/OWgyPG
        /uRe1Cg741kuptggFNyO55EaIohJO7+3l+pwqDeyLtWSQ4kCeemFe4dlhwSGErenebiovozoEVN3k
        XqQW0OLG/fZIN8kqmnO8l6QOEZNJOgJcjGzOECSQBJbtx2ZzUTQoZ71mS3hGdNRGzr67cplpTbBgq
        qKU9nSDelAYUm62EgYFytltMIJBOfwcfGp84/flNol3aucUa2189ComRBHikmW+RxOLW2eeOinCN5
        LXI2IM/wV+5jxjfqbZjWGEbCNW+jQ1WFqZSh38s/sJXMsR3one4KMbVcU9KnqYWBBLWstlLr5FX+i
        GdFjwZVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54946)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXh3U-00005s-3G; Tue, 05 Oct 2021 10:48:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXh3T-0008Mw-12; Tue, 05 Oct 2021 10:48:11 +0100
Date:   Tue, 5 Oct 2021 10:48:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Saravana Kannan <saravanak@google.com>
Subject: Re: [RFC net-next PATCH 05/16] net: phylink: Automatically attach
 PCS devices
Message-ID: <YVwfWiMOQH0U5bay@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-6-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-6-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:16PM -0400, Sean Anderson wrote:
> This adds support for automatically attaching PCS devices when creating
> a phylink. To do this, drivers must first register with
> phylink_register_pcs. After that, new phylinks will attach the PCS
> device specified by the "pcs" property.
> 
> At the moment there is no support for specifying the interface used to
> talk to the PCS. The MAC driver is expected to know how to talk to the
> PCS. This is not a change, but it is perhaps an area for improvement.
> 
> I believe this is mostly correct with regard to registering/
> unregistering. However I am not too familiar with the guts of Linux's
> device subsystem. It is possible (likely, even) that the current system
> is insufficient to prevent removing PCS devices which are still in-use.
> I would really appreciate any feedback, or suggestions of subsystems to
> use as reference. In particular: do I need to manually create device
> links? Should I instead add an entry to of_supplier_bindings? Do I need
> a call to try_module_get?

I think this is an area that needs to be thought about carefully.
Things are not trivial here.

The first mistake I see below is the use of device links. pl->dev is
the "struct device" embedded within "struct net_device". This doesn't
have a driver associated with it, and so using device links is likely
ineffectual.

Even with the right device, I think careful thought is needed - we have
network drivers where one "struct device" contains multiple network
interfaces. Should the removal of a PCS from one network interface take
out all of them?

Alternatively, could we instead use phylink to "unplug" the PCS and
mark the link down - would that be a better approach than trying to
use device links?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
