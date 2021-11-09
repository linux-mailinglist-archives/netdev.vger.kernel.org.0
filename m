Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E753744B071
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhKIPfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:35:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhKIPfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 10:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gc/ud1DvYL5gIxV7YHBk4aq5ZHgPt+idI1bn/7jShjI=; b=L888NJE7qilE2+fC99dGVwEPNT
        fttKbINgOIy30FQChempp1MA75PdDyhR9TjJQd7a0kWuEHX4vOdx3iBvDdftHCYPJg/mWLD7UA5V8
        kbk8UE0VzPiMMpsagNXRFYbqnbMLDrneLKH5KQQqWoCKpPEOF0rZtmlSdnddRm6dNs8o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkT6v-00D0Ji-8K; Tue, 09 Nov 2021 16:32:33 +0100
Date:   Tue, 9 Nov 2021 16:32:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYqUkfepXZzGpR3w@lunn.ch>
References: <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
 <YYkjBdu64r2JF1bR@lunn.ch>
 <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
 <YYk5s5fDuub7eBqu@lunn.ch>
 <585e234fdb74499caafee3b43b5e5ab4@sphcmbx02.sunplus.com.tw>
 <YYlfRB7updHplnLE@lunn.ch>
 <941aabfafa674999b2c0f4fc88025518@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <941aabfafa674999b2c0f4fc88025518@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't know how to implement STP in L2 switch like SP7021.

That is the nice thing about using Linux. It already knows how to
implement STP. The bridge will do it for you. You just need to add the
callbacks in the driver which are needed. Please take a look at other
switchdev drivers.

> If this is acceptable, I'd like to have Ethernet of SP7021 have two operation 
> modes:
>  - Dual NIC mode
>  - Single NIC with 2-port frame-flooding hub mode

No, sorry. Do it correctly, or do not do it. Please start with a clean
driver doing Dual NIC mode. You can add L2 support later, once you
have done the research to understand switchdev, etc.

> RMII pins of PHY ports of SP7021 are multiplexable. I'd like to switch RMII 
> pins of the second PHY for other use if single NIC mode is used.
> In fact, some SP7021 boards have dual Ethernet and some have only one
> Ethernet. We really need the two operation modes.

Only using a subset of ports in a switch is common. The common binding
for DSA switches is described in:

Documentation/devicetree/bindings/net/dsa/dsa.yaml and for example
Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml is
a memory mapped switch. Notice the reg numbers:

           ethernet-ports {
                #address-cells = <1>;
                #size-cells = <0>;

                port@0 {
                    reg = <0>;
                    label = "cpu";
                    ethernet = <&gmac0>;
                };

                port@2 {
                    reg = <2>;
                    label = "lan0";
                    phy-handle = <&phy1>;
                };

reg = <1> is missing in this example. Port 1 of the switch is not
used. You can do the same with a 2 port switch, when you don't want to
make use of a port. Just don't list it in DT.

> After looking up some data, I find RMC means reserved multi-cast.
> RMC packets means packets with DA = 0x0180c2000000, 0x0180c2000002 ~ 0x0180c200000f,
> except the PAUSE packet (DA = 0x0180c2000001)

Ah, good. BPDUs use 01:80:C2:00:00:00. So they will be passed when the
port is in blocking mode. PTP uses 01:80:C2:00:00:0E. So the hardware
designers appear to of designed a proper L2 switch with everything you
need for a managed switch. What is missing is software. The more i
learn about this hardware, the more i've convinced you need to write
proper Linux support for it, not your mode hacks.

    Andrew
