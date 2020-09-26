Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784E0279C53
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIZUWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:22:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgIZUWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 16:22:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMGia-00GJOS-BI; Sat, 26 Sep 2020 22:22:52 +0200
Date:   Sat, 26 Sep 2020 22:22:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v3 net-next 03/15] net: dsa: tag_sja1105: request
 promiscuous mode for master
Message-ID: <20200926202252.GB3887691@lunn.ch>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
 <20200926193215.1405730-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926193215.1405730-4-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 10:32:03PM +0300, Vladimir Oltean wrote:
> Currently PTP is broken when ports are in standalone mode (the tagger
> keeps printing this message):
> 
> sja1105 spi0.1: Expected meta frame, is 01-80-c2-00-00-0e in the DSA master multicast filter?
> 
> Sure, one might say "simply add 01-80-c2-00-00-0e to the master's RX
> filter" but things become more complicated because:
> 
> - Actually all frames in the 01-80-c2-xx-xx-xx and 01-1b-19-xx-xx-xx
>   range are trapped to the CPU automatically
> - The switch mangles bytes 3 and 4 of the MAC address via the incl_srcpt
>   ("include source port [in the DMAC]") option, which is how source port
>   and switch id identification is done for link-local traffic on RX. But
>   this means that an address installed to the RX filter would, at the
>   end of the day, not correspond to the final address seen by the DSA
>   master.
> 
> Assume RX filtering lists on DSA masters are typically too small to
> include all necessary addresses for PTP to work properly on sja1105, and
> just request promiscuous mode unconditionally.
> 
> Just an example:
> Assuming the following addresses are trapped to the CPU:
> 01-80-c2-00-00-00 to 01-80-c2-00-00-ff
> 01-1b-19-00-00-00 to 01-1b-19-00-00-ff
> 
> These are 512 addresses.
> Now let's say this is a board with 3 switches, and 4 ports per switch.
> The 512 addresses become 6144 addresses that must be managed by the DSA
> master's RX filtering lists.
> 
> This may be refined in the future, but for now, it is simply not worth
> it to add the additional addresses to the master's RX filter, so simply
> request it to become promiscuous as soon as the driver probes.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
