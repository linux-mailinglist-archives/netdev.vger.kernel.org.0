Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5CA197D22
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgC3NkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:40:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38682 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbgC3NkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 09:40:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=esI+T1YQJsJ8w5e5CSejVdx1WSPIYFBDFnlxDbViqsw=; b=n+315R4WcJx43GfDzPBQ+mirJF
        edNSflCfArycqbGglFEaM7WKAnU3snS3MMx/yGYoI8wE3i9ux1/kHYHvfDJ2uUdZV87PX1FWYd6CD
        dDXvRhWnrLwoJX1fIRe0M7I/pz3VdTujymtJre/6GmIHQye++bF2P6PqGy7CJ8w0mnhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIueA-000501-0h; Mon, 30 Mar 2020 15:40:10 +0200
Date:   Mon, 30 Mar 2020 15:40:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
Message-ID: <20200330134010.GA23477@lunn.ch>
References: <20200327195156.1728163-1-daniel@zonque.org>
 <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
 <20200327211821.GT3819@lunn.ch>
 <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
 <20200327235220.GV3819@lunn.ch>
 <64462bcf-6c0c-af4f-19f4-d203daeabec3@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64462bcf-6c0c-af4f-19f4-d203daeabec3@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 11:29:27AM +0200, Daniel Mack wrote:
> On 3/28/20 12:52 AM, Andrew Lunn wrote:
> >> I tried this as well with v5.5, but that leads to the external phy not
> >> seeing a link at all. Will check again though.
> > 
> > Did you turn off auto-neg on the external PHY and use fixed 100Full?
> > Ethtool on the SoC interface should show you if the switch PHY is
> > advertising anything. I'm guessing it is not, and hence you need to
> > turn off auto neg on the external PHY.
> > 
> > Another option would be something like
> > 
> >                                         port@6 {
> >                                                 reg = <6>;
> >                                                 label = "cpu";
> >                                                 ethernet = <&fec1>;
> > 
> >                                                 phy-handle = <phy6>;
> >                                         };
> >                                 };
> > 
> >                                 mdio {
> >                                         #address-cells = <1>;
> >                                         #size-cells = <0>;
> >                                         phy6: ethernet-phy@6 {
> >                                                 reg = <6>;
> >                                                 interrupt-parent = <&switch0>;
> >                                                 interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
> >                                         };
> >                                 };
> > 
> > By explicitly saying there is a PHY for the CPU node, phylink might
> > drive it.

You want to debug this. Although what you have is unusual, yours is
not the only board. It is something we want to work. And ideally,
there should be something controlling the PHY.

      Andrew
