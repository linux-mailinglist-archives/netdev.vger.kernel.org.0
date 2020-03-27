Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6986A196058
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgC0VSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:18:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34952 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbgC0VSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IoeP7MWLd5/bj4YubJkkdXvmN1XeUQWrEd7RTQbLSn4=; b=DTVL+XjRPDhfdvy+pS/WFd0zcd
        3I1jfeTaWdp0SWn5nWTHLh1sZXwTVsPYOb6pR0GLnSZNYh/rn884DYzPVaqzYhQENyz3qik5pseBW
        qBzQCyGYkyrapNLGsIAzEVMyhfPJSqj9kkAt5quxuKhOALYKbCh1ev4K/wKE/gv4qDT8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHwMv-0005Mb-8g; Fri, 27 Mar 2020 22:18:21 +0100
Date:   Fri, 27 Mar 2020 22:18:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
Message-ID: <20200327211821.GT3819@lunn.ch>
References: <20200327195156.1728163-1-daniel@zonque.org>
 <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 09:48:56PM +0100, Daniel Mack wrote:
> Hi Andrew,
> 
> On 27/3/2020 9:01 pm, Andrew Lunn wrote:
> > On Fri, Mar 27, 2020 at 08:51:56PM +0100, Daniel Mack wrote:
> >> On hardware with a speed-reduced link to the CPU port, forcing the MAC
> >> settings won't allow any packets to pass. The PHY will negotiate the
> >> maximum possible speed, so let's allow the MAC to work with whatever
> >> is available.
> > 
> > This will break board which rely on the CPU being forced to the
> > maximum speed, which has been the default since forever.
> 
> Will it? Wouldn't the PHY negotiate the maximum speed, and the MAC would
> follow?

Most boards just connect the SoC MAC to the switch MAC. No PHY.

There is no need to have PHYs here, unless your switch is a long way
away from the SoC. It is just added extra expense for no reason.

> > It sounds like you have the unusual situation of back to back PHYs?
> > And i assume the SoC PHY is limited to Fast Ethernet?
> 
> Yes, exactly.

And i guess you are stuck with this design?

> > What i think you can do is have a phy-handle in the cpu node which
> > points to the PHY. That should then cause the PHY to be driven as a
> > normal PHY, and the result of auto neg passed to the MAC.
> 
> Yes, this is what I have. The maximum speed the is negotiable on that
> link is 100M, and the PHYs see each other just fine (according to the
> status registers of the external PHY). The problem is that the MAC
> inside the switch is forced to 1G, which doesn't match what the PHY
> negotiated.

So try a fixed link in the CPU node.

                                       port@6 {
                                                reg = <6>;
                                                label = "cpu";
                                                ethernet = <&fec1>;

                                                fixed-link {
                                                        speed = <100>;
                                                        full-duplex;
                                                };

This won't work with current net-next, which is broken at the
moment. But it might work with older kernels. I've not tried this when
there actually is a PHY. It is normally used when you need to slow the
port down from its default highest speed in the usual MAC-MAC
setting. In this case, the FEC is Fast Ethernet only, so we need the
Switch MAC to run at 100Mbps.

     Andrew
