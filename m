Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4288E3B53F7
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 17:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhF0POy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 11:14:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhF0POy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 11:14:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cAgU1LZJU+4bPdsqzJiE890ojfilFw9fy3C817Mu+YU=; b=bXcZr+kjWWH5ZC4J6IT/wnLa/E
        vNy6qdtU32EFUVAbBEx9WG38rOg4LHXwUDz/TpSvC/actqUzP6Y6/qwKIvcWTMAmbc6SiQ9wxXOkY
        TaElx9ZUN40jLkEFR7ZI4Ft9Kglz5PMsjwTdYR/CSSrXosSNJ77NtRiOw1jbBjtGXoxs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lxWSQ-00BKPd-Dz; Sun, 27 Jun 2021 17:12:26 +0200
Date:   Sun, 27 Jun 2021 17:12:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <YNiVWhoqyHSVa+K4@lunn.ch>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
 <YNTfMzKn2SN28Icq@shredder>
 <YNTqofVlJTgsvDqH@lunn.ch>
 <YNhT6aAFUwOF8qrL@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNhT6aAFUwOF8qrL@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 27, 2021 at 01:33:13PM +0300, Ido Schimmel wrote:
> On Thu, Jun 24, 2021 at 10:27:13PM +0200, Andrew Lunn wrote:
> > > I fail to understand this logic. I would understand pushing
> > > functionality into the kernel in order to create an abstraction for user
> > > space over different hardware interfaces from different vendors. This is
> > > not the case here. Nothing is vendor specific. Not to the host vendor
> > > nor to the module vendor.
> > 
> > Hi Ido
> 
> Hi Andrew,
> 
> > 
> > My worry is, we are opening up an ideal vector for user space drivers
> > for SFPs. And worse still, closed source user space drivers. We have
> > had great success with switchdev, over a hundred supported switches,
> > partially because we have always pushed back against kAPIs which allow
> > user space driver, closed binary blobs etc.
> 
> I don't think it's a correct comparison. Switch ASICs don't have a
> standardized interface towards the host. It is therefore essential that
> the kernel will abstract these differences to user space.
> 
> > 
> > We have the choice here. We can add a write method to the kAPI, add
> > open source code to Ethtool using that API, and just accept people are
> > going to abuse the API for all sorts of horrible things in user space.
> > Or we can add more restrictive kAPIs, put more code in the kernel, and
> > probably limit user space doing horrible things. Maybe as a side
> > effect, SFP vendors contribute some open source code, rather than
> > binary blobs?
> 
> I didn't see any code or binary blobs from SFP vendors and I'm not sure
> how they can provide these either. Their goal is - I believe - to sell
> as much modules as possible to what the standard calls "systems
> manufactures" / "system integrators". Therefore, they cannot make any
> assumptions about the I2C connectivity (whether to the ASIC or the CPU),
> the operating system running on the host and the user interface (ioctl /
> netlink etc).
> 
> Given all these moving parts, I don't see how they can provide any
> tooling. It is in their best interest to simply follow the standard and
> make the tooling a problem of the "systems manufactures" / "system
> integrators". In fact, the user who requested this functionality claims:
> "the cable vendors don't develop the tools to burn the FW since the
> vendors claim that the CMIS is supported". The user also confirmed that
> another provider "is able to burn the FW for the cables from different
> vendors".

Hi Ido

This API is not just about CMIS, it covers any I2C connected SFP
device. I'm more involved in the lower end, 1G, 2.5G and 10G. Devices
in this category seem to be very bad a following the standards. GPON
is especially bad, and GPON manufactures don't seem to care their
devices don't follow the standard, they assume the Customer Premises
Equipment is going to run software to work around whatever issues
their specific GPON has, maybe they provide driver code? The API you
are adding would be ideal for putting that driver in user space, as a
binary blob. That is going to make it harder for us to open up the
many millions of CPE used in FTTH. And there are people attempting to
do that.

If devices following CMIS really are closely following the standard
that is great. We should provide tooling to do firmware upgrade. But
at the same time, we don't want to aid those who go against the
standards and do their own thing. And it sounds like in the CMIS
world, we might have the power to encourage vendors to follow CMIS,
"Look, firmware upgrade just works for the competitors devices, why
should i use your device when it does not work?"

I just want to make sure we are considering the full range of devices
this new API will cover. From little ARM systems with 1G copper and
FTTH fibre ports through to big TOR systems with large number of 100G
ports.  If CMIS is well support by vendors, putting the code into the
kernel, as a loadable module, might be the better solution for the
whole range of devices the kernel needs to support.

      Andrew
