Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E94422DFB
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhJEQbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhJEQbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C36661373;
        Tue,  5 Oct 2021 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633451397;
        bh=uEh1yq16G+v3uUZgupZVNCdF6wqMQfhZztqBYvmwDYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MHm7KGyjB3OviUN2OPiJoPOT9+TSRLqTvYTJ0/PUT18XgLJLby/5PUbyWUcdrZNb+
         hn2Nd//TECq5gtWLx4G7KmBPMOEdgFxiobx3zuW59J47p3qwnCqvWuj2E12ladYXFh
         L7NFI1V0mGoAd89E3Gq4i9GWNXoEoRHJv8EBX+fMDguFAZ/FT+KJgwEWM7myG2jRO9
         ioqB8sGxbC1vWsITKFg0xB3ycsDNXg4vV/MIsE64XJuFDlP9Gio301QhA2zBo9mNwF
         lAN5KkD2WtSrNANREYfDgpFIlt2gD4UdIFgY8ZqemgPq0SY39MV9lbWG3OcEqrrg8Z
         7goi18LHmoORQ==
Date:   Tue, 5 Oct 2021 09:29:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] of: net: add a helper for loading
 netdev->dev_addr
Message-ID: <20211005092956.44eb4d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL_Jsq+HsW-dpUxC2Sz-FhgHgRonhanX2LgUVHiNZYfZS81iBQ@mail.gmail.com>
References: <20211005155321.2966828-1-kuba@kernel.org>
        <20211005155321.2966828-2-kuba@kernel.org>
        <CAL_Jsq+HsW-dpUxC2Sz-FhgHgRonhanX2LgUVHiNZYfZS81iBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 11:15:48 -0500 Rob Herring wrote:
> On Tue, Oct 5, 2021 at 10:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it got through appropriate helpers.
> >
> > There are roughly 40 places where netdev->dev_addr is passed
> > as the destination to a of_get_mac_address() call. Add a helper
> > which takes a dev pointer instead, so it can call an appropriate
> > helper.
> >
> > Note that of_get_mac_address() already assumes the address is
> > 6 bytes long (ETH_ALEN) so use eth_hw_addr_set().
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  drivers/of/of_net.c    | 25 +++++++++++++++++++++++++  
> 
> Can we move this file to drivers/net/ given it's always merged via the
> net tree? It's also the only thing left not part of the driver
> subsystems.

Hm, our driver core historically lives under net/core, not drivers/net,
how about drivers/of/of_net.c -> net/core/of_net.c ?
