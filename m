Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77F330F974
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbhBDRUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:20:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238363AbhBDRTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 12:19:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l7iGz-004DvX-5q; Thu, 04 Feb 2021 18:18:29 +0100
Date:   Thu, 4 Feb 2021 18:18:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: call teardown method on probe failure
Message-ID: <YBwsZTOSLX5BUkaN@lunn.ch>
References: <20210204163351.2929670-1-vladimir.oltean@nxp.com>
 <YBwoKiRlOmi3my5G@lunn.ch>
 <20210204170614.zutxxuufsx53lcgg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204170614.zutxxuufsx53lcgg@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 05:06:15PM +0000, Vladimir Oltean wrote:
> On Thu, Feb 04, 2021 at 06:00:26PM +0100, Andrew Lunn wrote:
> > On Thu, Feb 04, 2021 at 06:33:51PM +0200, Vladimir Oltean wrote:
> > > Since teardown is supposed to undo the effects of the setup method, it
> > > should be called in the error path for dsa_switch_setup, not just in
> > > dsa_switch_teardown.
> > 
> > I disagree with this. If setup failed, it should of cleaned itself up.
> > That is the generally accepted way of doing things. If a function is
> > going to exit with an error, it should first undo whatever it did
> > before exiting.
> > 
> > You are adding extra semantics to the teardown op. It can no longer
> > assume setup was successful. So it needs to be very careful about what
> > it tears down, it cannot assume everything has been setup. I doubt the
> > existing implementations actually do that.
> 
> I'm sorry, I don't understand.
> I write a driver, I implement .setup(). I allocate some memory, I expect
> that I can deallocate it in .teardown().
> Now dsa_switch_setup comes, calls my .setup() which succedes. But then
> mdiobus_register(ds->slave_mii_bus) which comes right after .setup()
> fails. Are you saying we shouldn't call the driver's .teardown()?
> Why not?

Hi Vladimir

Ah, sorry. Read you commit message wrongly. I though you were calling
teardown if setup failed. But that is not what the patch does. It
calls it if things after setup fail.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
