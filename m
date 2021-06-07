Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA1B39DCEB
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFGMvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:51:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhFGMvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 08:51:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eBPqfa/JpLvYxpSvRFZHUQbIzjJk5kfAOuunDaotAwk=; b=VUMyCE2Yq9YOb5B1HfPNE+IOMc
        tUb+b3Gr/7+rMkPcjuM3Fs+Nkp1JtpCM/JnADzUkWSL/G+SB3t2EWMX2WG94T4CMXuQh8Ucror+NF
        Ia3KTKY5fCUxUmLXZB6BQzCteo7/CwkWykrT2qr1xVKGJuiY6kJZnGLFvnxwnyQwl//w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lqEhO-008AwQ-R2; Mon, 07 Jun 2021 14:49:46 +0200
Date:   Mon, 7 Jun 2021 14:49:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Koba Ko' <koba.ko@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] r8169: introduce polling method for link change
Message-ID: <YL4V6jak3TYxDPg8@lunn.ch>
References: <20210603025414.226526-1-koba.ko@canonical.com>
 <3d2e7a11-92ad-db06-177b-c6602ef1acd4@gmail.com>
 <CAJB-X+V4vpLoNt2C_i=3mS4UtFnDdro5+hgaFXHWxcvobO=pzg@mail.gmail.com>
 <f969a075-25a1-84ba-daad-b4ed0e7f75f5@gmail.com>
 <CAJB-X+U5VEeSNS4sF0DBxc-p0nxA6QLVVrORHsscZuY37rGJ7w@mail.gmail.com>
 <bfc68450-422d-1968-1316-64f7eaa7cbe9@gmail.com>
 <CAJB-X+UDRK5-fKEGc+PS+_02HePmb34Pw_+tMyNr_iGGeE+jbQ@mail.gmail.com>
 <16f24c21776a4772ac41e6d3e0a9150c@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16f24c21776a4772ac41e6d3e0a9150c@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 12:32:29PM +0000, David Laight wrote:
> From: Koba Ko
> > Sent: 07 June 2021 05:35
> ...
> > After consulting with REALTEK, I can identify RTL8106e by PCI_VENDOR
> > REALTEK, DEVICE 0x8136, Revision 0x7.
> > I would like to make PHY_POLL as default for RTL8106E on V2.
> > because there's no side effects besides the cpu usage rate would be a
> > little higher,
> > How do you think?
> 
> If reading the PHY registers involves a software bit-bang
> of an MII register (rather than, say, a sleep for interrupt
> while the MAC unit does the bit-bang) then you can clobber
> interrupt latency because of all the time spent spinning.

That is not what PHY IRQ/POLL means in the PHY subsystem.

Many PHYs don't actually have there interrupt output connected to a
GPIO. This is partially because 803.2 C22 and C45 standards don't
define interrupts. Each vendor which supports interrupts uses
proprietary registers. So by default, the PHY subsystem will poll the
status of the PHY once per second to see if the link has changed
state. If the combination of PHY hardware, board hardware and PHY
driver does have interrupts, the PHY subsystem will not poll, but wait
for an interrupt, and then check the status of the link.

As for MII bus masters, i only know of one which is interrupt driven,
rather than polled IO, for completion. The hardware is clocking out 64
bits at 2.5MHz. So it is done rather quickly. I profiled that one
using interrupts, and the overhead of dealing with the interrupt is
bigger than polling.

    Andrew
