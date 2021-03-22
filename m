Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F34344B51
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCVQ2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:28:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231882AbhCVQ2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:28:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lONPl-00CQnP-F3; Mon, 22 Mar 2021 17:28:25 +0100
Date:   Mon, 22 Mar 2021 17:28:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: Re: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Message-ID: <YFjFqaHxXiwcZpr2@lunn.ch>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
 <YEpMgK1MF6jFn2ZW@lunn.ch>
 <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YFO9ug0gZp8viEHn@lunn.ch>
 <CO6PR18MB3873543426EC122F1C53DC40B0659@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873543426EC122F1C53DC40B0659@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 03:59:43PM +0000, Stefan Chulski wrote:
> 
> > > 2. CM3 code has very small footprint requirement, we cannot 
> > > implement the complete Serdes and PHY infrastructure that kernel 
> > > provides as part of CM3 application. Therefore I would like to 
> > > continue relying on kernel configuration for that.
> > 
> > How can that work? How does Linux know when CM3 has up'ed the 
> > interface?
> 
> CM3 won't use this interface till ethtool priv flag was set, it can be done by communication over CM3 SRAM memory.
> 
> > How does CM3 know the status of the link?
> 
> CM3 has access to MAC registers and can read port status bit.
> 
> > How does CM3 set its
> > flow control depending on what auto-neg determines, etc?
> 
> Same as PPv2 Packet Processor RX and TX flow don't really care about auto-neg, flow control, etc.
> CM3 can ignore it, all this stuff handled in MAC layer. CM3 just polling RX descriptor ring and using TX ring for transmit. 
> 
> > 
> > > 3. In some cases we need to dynamically switch the port "user"
> > > between CM3 and kernel. So I would like to preserve this 
> > > functionality.
> > 
> > And how do you synchronize between Linux and CM3 so you know how is 
> > using it and who cannot use it?
> > 
> >       Andrew
> 
> I can add CM3 SRAM update into ethtool priv flag callback, so CM3 won't use port till it was reserved to CM3.

I really think you need to step back here and look at the bigger
picture. If linux should not use the interface, it should not
exist. If it does not exist, you cannot use ethtool on it.

What you might want to consider is adding remoteproc support between
Linux on the main processor and whatever you have on the CM3. You can
use RPMsg to send requests back and forth between Linux and the
CM3. It can request that the shared parts of the packet processor are
set up for it. Linux can tell it when the link comes up? It can
request how the PHY auto-neg should be configured.

	Andrew
