Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462FF315534
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhBIRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233232AbhBIRfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 12:35:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B3FE64E7E;
        Tue,  9 Feb 2021 17:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612892101;
        bh=2ry5h3lOxZL7tuhk5BAy7SlKInnx6xq7EGyfJE8uBhw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y2c001D3lFY7aEapySs7wZdWRJXLbC0iOoao4QpbUnioFVLTMlkatIN5VlbLxMAE6
         sS6FhUE4Ay2EfXroZM7+PPOM8/pefvZYA1X+1cDw0QmUulyRfMOobhPuFuy8xTWGb+
         1+y7lrNaHpxE4vc6juE5bJUzAs2lwLgKF/CgUzj6+8BNyb5DiwvS1rvKq2hAU4f1ZG
         X2Vf/yFc4rF2xOGWyOEdHjq3XVqk64IxdGyx1L02CdEfD49f3seqDFLtR3iJc9Qjas
         a1dCFk0wtc6ZFkCdOYlmp9u66ZJ4XsL5l1vSJ+sZyBflmMoHnQ3EfRByYagAV95JaB
         Vmvie4z8qiCXQ==
Date:   Tue, 9 Feb 2021 09:35:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Message-ID: <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YCKVAtu2Y8DAInI+@lunn.ch>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-6-vadym.kochan@plvision.eu>
        <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9b249oq.fsf@waldekranz.com>
        <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YCKVAtu2Y8DAInI+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 14:58:26 +0100 Andrew Lunn wrote:
> > At the same time some FW is necessary. Certain chip functions, are 
> > best driven by a micro-controller running a tight control loop.   
> 
> For a smart NIC, i could agree. But a switch? The data path is in
> hardware. The driver is all about configuring this hardware, and then
> it is idle. Polls the PHYs once a second, maybe gather statistics,
> allows the network stack to perform STP, but otherwise it does
> nothing.
> 
> So for me, i don't see that being a valid argument for this driver.
> 
> By putting their SDK inside the CPU on the switch, and adding an RPC
> interface, Marvell can quickly get some sort of support working in the
> Linux ecosystem. But this solution has all the problems of a binary
> blob in userspace.
> 
> I doubt there is going to be any community engagement with this
> driver. Marvell is going to have to add all the features. If a user
> wants a feature which is not currently supported, they have little
> chance of being able to add it themselves. There is no documentation
> of the RPC interface. So even if the firmware has support for more
> than what the Linux driver implements, only Marvell knows about it.
> 
> Products based around this driver are going to find it hard to
> differentiate on switch features. The switch can do what Marvell
> allows you to do. All differentiation is going to be limited to above
> that, the user interface.
> 
> For some market segments, that might be enough. You don't see
> community based patches adding new features to the Mellanex/nvidia
> hardware. But when you look at the DSA drivers, a lot of the features
> there are from the community. There is probably space for both.
> 
> Looking into my crystal ball, Marvell will probably have the base
> features of their switch implemented before Microchip does, simply
> because they are reusing code hidden away in the CPU. But then
> development will stagnate. Microchip will take a bit longer to get the
> base features implemented. But then because of the openness, users
> will start using the hardware in different ways, and implement
> features which are important to them. And contribute bug fixes. The
> driver will keep gaining new features and mature, and in the end, the
> device built from it will be a lot more divers and interesting.
> 
> What i'm not sure is how we as a community push back. Marvells whole
> strategy is black box. I doubt we can make them open up the firmware.
> Do we want to throw out the driver from the kernel? I don't think it
> is that bad. We can point out the problems with Marvell's model. We
> can put in review effort for Microchip, make their driver better. And
> we can encourage the 3rd and 4th vendors in the enterprise switch
> space to follow Microchips lead.

Sounds like we have 3 people who don't like FW-heavy designs dominating
the kernel - this conversation can only go one way. 

Marvell, Plvision anything to share? AFAIU the values of Linux kernel
are open source, healthy community, empowering users. With the SDK on
the embedded CPU your driver does not seem to tick any of these boxes.
