Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2948C462A82
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 03:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhK3Cfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 21:35:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237559AbhK3Cfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 21:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vUFHwoBtOS6VZw8Tg61xsLT12K9iQ5jz7v/Dv9NP0jg=; b=uILZyEXasalRvxQPVTMLuFr8uC
        WNnaqkoMzXDZRXyEsO6Kpq3itXcJKpLrXulH/08FYLoGycoMlKRvHEynsaRSOqtZ/A5RVK2+qIP4/
        uwXc3nOZvpN6WiBNPWTEfo0IvU6tNITio2OMiukH/kFebBLZas83DvO2J+EB8249HdQc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrswE-00EzQQ-4N; Tue, 30 Nov 2021 03:32:10 +0100
Date:   Tue, 30 Nov 2021 03:32:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hector Martin <marcan@marcan.st>
Cc:     Tianhao Chai <cth451@gmail.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: Re: [PATCH] ethernet: aquantia: Try MAC address from device tree
Message-ID: <YaWNKiXwr/uHlNJD@lunn.ch>
References: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
 <YaOvShya4kP4SRk7@lunn.ch>
 <37679b8b-7a81-5605-23af-e442f9e91816@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37679b8b-7a81-5605-23af-e442f9e91816@marcan.st>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 02:08:28AM +0900, Hector Martin wrote:
> On 29/11/2021 01.33, Andrew Lunn wrote:
> > On Sat, Nov 27, 2021 at 08:37:33PM -0600, Tianhao Chai wrote:
> > > Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
> > > card, but instead need to obtain MAC addresses from the device tree. In
> > > this case the hardware will report an invalid MAC.
> > > 
> > > Currently atlantic driver does not query the DT for MAC address and will
> > > randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
> > > This patch causes the driver to perfer a valid MAC address from OF (if
> > > present) over HW self-reported MAC and only fall back to a random MAC
> > > address when neither of them is valid.
> > 
> > This is a change in behaviour, and could cause regressions. It would
> > be better to keep with the current flow. Call
> > aq_fw_ops->get_mac_permanent() first. If that does not give a valid
> > MAC address, then try DT, and lastly use a random MAC address.
> 
> On DT platforms, it is expected that the device tree MAC will override
> whatever the device thinks is its MAC address.

Can you point to any documentation of that expectation?

> I would not expect any other existing platform to have a MAC assigned to the
> device in this way using these cards; if any platforms do, chances are they
> intended it for it to be used and this patch will fix a current bug. If some
> platforms out there really have bogus MACs assigned in this way, that's a
> firmware bug, and we'd have to find out and add explicit, targeted
> workaround code. Are you aware of any such platforms? :)

I'm not aware of any, because i try to avoid making behaviour changes.

Anyway, lets go with this, and if stuff breaks we can always change
the order to what i suggested in order to unbreak stuff. I'm assuming
for Apple M1 Mac minis the order does not actually matter?

    Andrew
