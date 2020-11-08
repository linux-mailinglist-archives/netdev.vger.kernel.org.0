Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8431F2AAE6B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 00:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgKHX7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 18:59:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgKHX7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 18:59:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kbuax-005zTZ-PD; Mon, 09 Nov 2020 00:59:39 +0100
Date:   Mon, 9 Nov 2020 00:59:39 +0100
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
Message-ID: <20201108235939.GC1417181@lunn.ch>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 08, 2020 at 07:23:55PM +0200, Vladimir Oltean wrote:
> On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
> > Can it be turned off for switches that support SA learning from CPU?
> 
> Is there a good reason I would add another property per switch and not
> just do it unconditionally?

Just throwing out ideas, i've no idea if they are relevant. I wonder
if we can get into issues with fast ageing with a topology change?  We
don't have too much control over the hardware. I think some devices
just flush everything, or maybe just one port. So we have different
life times for CPU port database entries and user port database
entries?

We might also run into bugs with flushing removing static database
entries which should not be. But that would be a bug. Also, dumping
the database might run into bugs since we have not had entries for the
CPU port before.

We also need to make sure the static entries get removed correctly
when a host moves. The mv88e6xxx will not replace a static entry with
a dynamically learned one. It will probably rise an ATU violation
interrupt that frames have come in the wrong port.

What about switches which do not implement port_fdb_add? Do these
patches at least do something sensible?

	Andrew

