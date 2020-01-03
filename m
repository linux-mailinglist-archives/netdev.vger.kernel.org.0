Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0D12F2FF
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 03:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgACCio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 21:38:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46114 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgACCio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 21:38:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KOQGoT+7elFPjS+WGIQjBENv+ESK2nG+HAXN50zXc1Y=; b=Xb83O2zXgm49BB/gPXr4SfJ5aR
        /pPsAs6RTZzx/od+2C7Bl0YEjC9WIxHoFiRcCD3Z1aO4dLgxi8dQ0MyK30gvrkzgm+ktEmD4NqkXa
        YT9lWmxNrFqp5O/PDZKX19d7FOge871dlZ6YfTHSw/98DsprK9ajK6zHV8mDTgp7JwuU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inCrF-0007Qj-35; Fri, 03 Jan 2020 03:38:37 +0100
Date:   Fri, 3 Jan 2020 03:38:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [EXT] Re: [PATCH net] net: freescale: fec: Fix ethtool -d
 runtime PM
Message-ID: <20200103023837.GA28099@lunn.ch>
References: <20200102143334.27613-1-andrew@lunn.ch>
 <8658c955-eaac-f6d9-5fbe-b8542e26d141@gmail.com>
 <20200103010134.GC27690@lunn.ch>
 <VI1PR0402MB36006DE84ECA9E5EA742CAFCFF230@VI1PR0402MB3600.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB36006DE84ECA9E5EA742CAFCFF230@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 02:02:50AM +0000, Andy Duan wrote:
> From: Andrew Lunn <andrew@lunn.ch> Sent: Friday, January 3, 2020 9:02 AM
> > > This fix will do, but you should consider implementing
> > > ethtool_ops::begin and ethtool_ops::end to make sure this condition is
> > > resolved for all ethtool operations.
> > >
> > > For instance the following looks possibly problematic too:
> > > fec_enet_set_coalesce -> fec_enet_itr_coal_set
> > 
> > Hi Florian
> > 
> > I did a quick test of all the ethtool operations which the driver supports,
> > including setting coalescing. I did not exhaustively try all possible coalescing
> > settings, but the ones i did try did not provoke a data abort.
>

> The original design is that driver power off clocks when net interface is down,
> use ethtool to dump registers are not allowed. Only .get_regs/ .get/set_coalesce
> are allowed when the net interface is up by checking netif_running(ndev).

Hi Andy

The function fec_enet_get_regs() does not perform a
netif_running(ndev) check. So it seems like it was intended to work
with the interface down. It could be a difference between variants of
the FEC. I was seeing the data abort on the vf610. Maybe its clocks
are different to other FEC implementations?

I've no strong preference about seeing the registers when the
interface is down, or return maybe -ENETDOWN.  What i don't want is a
data abort, and locks left in a bad state.

    Andrew
