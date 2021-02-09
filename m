Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1386131558C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhBISAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233260AbhBIRtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 12:49:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E5C64DB3;
        Tue,  9 Feb 2021 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612892909;
        bh=0bwozM0+19GheowWSY/r03uwZDq+Knnhrmbub8g0N6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=byU4w/21yTB7r7ByiSRRVMOX6dtzSThCyfIvKLZdTFmiDNCtN+eBtznGboki9nzex
         qzRzeBhk7vuT8gDfqpjk36AuVKoifXMp7BXitegzmRmmWAggcN9VriCCCry++0W0TR
         B3trywkx4+IHo2O//uJJos+OdmC9wmqqdkCS0Fg6DDtRyBk4ZMevelWH1NzSftjdu6
         tOucl4W3TRK5oq0TxgO1OszwY2/3tPzwalLlhPIJnOS23DTyKZ3PHBZO9jtTAKgF4V
         MSh5sKURSWOrY8czE4fMIKEyDH3egYXEJ+dIyyWZVgx4RUqMR+HKrAX+MxsWCDNcmA
         PAU0FygKggQSw==
Date:   Tue, 9 Feb 2021 09:48:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Message-ID: <20210209094828.5635e2bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87pn194fp4.fsf@waldekranz.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-6-vadym.kochan@plvision.eu>
        <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9b249oq.fsf@waldekranz.com>
        <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87pn194fp4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 09 Feb 2021 12:56:55 +0100 Tobias Waldekranz wrote:
> > I ask myself that question pretty much every day. Sadly I have no clear
> > answer.  
> 
> Thank you for your candid answer, really appreciate it. I do not envy
> you one bit, making those decisions must be extremely hard.
> 
> > Silicon is cheap, you can embed a reasonable ARM or Risc-V core in the
> > chip for the area and power draw comparable to one high speed serdes
> > lane.
> >
> > The drivers landing in the kernel are increasingly meaningless. My day
> > job is working for a hyperscaler. Even though we have one of the most
> > capable kernel teams on the planet most of issues with HW we face
> > result in "something is wrong with the FW, let's call the vendor".  
> 
> Right, and being a hyperscaler probably at least gets you some attention
> when you call your vendor. My day job is working for a nanoscaler, so my
> experience is that we must be prepared to solve all issues in-house; if
> we get any help from the vendor that is just a bonus.
> 
> > And even when I say "drivers landing" it is an overstatement.
> > If you look at high speed anything these days the drivers cover
> > multiple generations of hardware, seems like ~5 years ago most
> > NIC vendors reached sufficient FW saturation to cover up differences
> > between HW generations.
> >
> > At the same time some FW is necessary. Certain chip functions, are 
> > best driven by a micro-controller running a tight control loop.   
> 
> I agree. But I still do not understand why vendors cling to the source
> of these like it was their wallet. That is the beauty of selling
> silicon; you can fully leverage OSS and still have a very straight
> forward business model.

Vendors want to be able to "add value", lock users in and sell support.
Users adding features themselves hurts their bottom line. Take a look
at income breakdown for publicly traded companies. There were also
rumors recently about certain huge silicon vendor revoking the SDK
license from a NOS company after that company got bought.

Business people make rational choices, trust me. It's on us to make
rational choices in the interest of the community (incl. our users).

> > The complexity of FW is a spectrum, from basic to Qualcomm. 
> > The problem is there is no way for us to know what FW is hiding
> > by just looking at the driver.
> >
> > Where do we draw the line?   
> 
> Yeah it is a very hard problem. In this particular case though, the
> vendor explicitly said that what they have done is compiled their
> existing SDK to run on the ASIC:
> 
> https://lore.kernel.org/netdev/BN6PR18MB1587EB225C6B80BF35A44EBFBA5A0@BN6PR18MB1587.namprd18.prod.outlook.com
> 
> So there is no reason that it could not be done as a proper driver.

I guess you meant "no _technical_ reason" ;)

> > Personally I'd really like to see us pushing back stronger.  
> 
> Hear, hear!
