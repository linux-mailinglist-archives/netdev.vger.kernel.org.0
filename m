Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544352AAEA7
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 02:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKIBGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 20:06:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727949AbgKIBGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 20:06:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kbvdV-005zoO-Cg; Mon, 09 Nov 2020 02:06:21 +0100
Date:   Mon, 9 Nov 2020 02:06:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201109010621.GE1417181@lunn.ch>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <20201108235939.GC1417181@lunn.ch>
 <20201109003028.melbgstk4pilxksl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109003028.melbgstk4pilxksl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > We also need to make sure the static entries get removed correctly
> > when a host moves. The mv88e6xxx will not replace a static entry with
> > a dynamically learned one. It will probably rise an ATU violation
> > interrupt that frames have come in the wrong port.
> 
> This is a good one. Currently every implementer of .port_fdb_add assumes
> a static entry is what we want, but that is not the case here. We want
> an entry that can expire or the switch can move it to a different port
> when there is evidence that it's wrong.

I doubt you will find any hardware that actually does this. I expect
there are static entries, and dynamic entries, and nothing
hybrid. After a move, we need to rely on a broadcast packet making its
way to the software bridge, which causes it to learn about the move,
and delete the static CPU entry from the hardware.

We can probably test this with having our wireless device move back
and forth a few times, so we can see the full cycle a few
times. Unfortunately, i don't have two boards with both a switch and
WiFi.

    Andrew
