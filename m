Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEB32C180C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbgKWVzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:55:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbgKWVzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 16:55:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khJoD-008YLn-Sj; Mon, 23 Nov 2020 22:55:41 +0100
Date:   Mon, 23 Nov 2020 22:55:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201123215541.GB2036992@lunn.ch>
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com>
 <20201120193321.GP1853236@lunn.ch>
 <CAFSKS=P=epx3Sr3OzkCg9ycoftmXm__PaMee7HWbAGXYdqgbDw@mail.gmail.com>
 <20201120232439.GA1949248@lunn.ch>
 <CAFSKS=M-2rwM2UC58xf8n0ORuwxHq06BjLj7QP=JuU19-tCpGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=M-2rwM2UC58xf8n0ORuwxHq06BjLj7QP=JuU19-tCpGg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If it cannot send/receive BPDUs, it might get into an oscillating
> > state. They see each other via BPDUs, decide there is a loop, and
> > block a port. The BPDUs stop, they think the loop has been broken and
> > so unblock. They see each other via BPUS, decide there is a loop,...
> 
> Yeah, this is messed up. The switch doesn't seem to pass up BPDUs in
> either disabled or learning mode, only forward mode.
> Can I just replace .port_stp_state_set with .port_enable (setting
> switch port to forward mode) and .port_disable (setting switch port to
> disabled mode)? I don't see any other way around this. It looks like
> rtl8366rb.c also has no .port_stp_state_set.

Do you have access to a 'vendor crap driver'? Anything about STP in
it? Maybe you need to add special entries to its forwarding database
for the BPDU destination MAC address?

If you cannot get BPDUs to be passed, i think that means you cannot
offload bridging to the switch. So you also need to remove bridge join
and bridge leave. I've no idea if you can still do HSR under those
conditions!

	Andrew
