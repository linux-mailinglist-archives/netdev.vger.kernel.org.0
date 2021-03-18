Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF1533FCD7
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 02:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCRBvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 21:51:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230498AbhCRBup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 21:50:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMho9-00BZSm-C3; Thu, 18 Mar 2021 02:50:41 +0100
Date:   Thu, 18 Mar 2021 02:50:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Offload bridge
 broadcast flooding flag
Message-ID: <YFKx8faByAd2cUiH@lunn.ch>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-6-tobias@waldekranz.com>
 <20210316093948.zbhouadshgedktcb@skbuf>
 <87pmzynib9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmzynib9.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 12:14:18PM +0100, Tobias Waldekranz wrote:
> On Tue, Mar 16, 2021 at 11:39, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Mar 15, 2021 at 10:14:00PM +0100, Tobias Waldekranz wrote:
> >> These switches have two modes of classifying broadcast:
> >> 
> >> 1. Broadcast is multicast.
> >> 2. Broadcast is its own unique thing that is always flooded
> >>    everywhere.
> >> 
> >> This driver uses the first option, making sure to load the broadcast
> >> address into all active databases. Because of this, we can support
> >> per-port broadcast flooding by (1) making sure to only set the subset
> >> of ports that have it enabled whenever joining a new bridge or VLAN,
> >> and (2) by updating all active databases whenever the setting is
> >> changed on a port.
> >> 
> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> ---
> >>  drivers/net/dsa/mv88e6xxx/chip.c | 68 +++++++++++++++++++++++++++++++-
> >>  1 file changed, 67 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> >> index 48e65f22641e..e6987c501fb7 100644
> >> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> >> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> >> @@ -1950,6 +1950,18 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
> >>  	int err;
> >>  
> >>  	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> >> +		struct dsa_port *dp = dsa_to_port(chip->ds, port);
> >> +
> >> +		if (dsa_is_unused_port(chip->ds, port))
> >> +			continue;
> >> +
> >> +		if (dsa_is_user_port(chip->ds, port) && dp->bridge_dev &&
> >> +		    !br_port_flag_is_set(dp->slave, BR_BCAST_FLOOD))
> >
> > What if dp->slave is not the bridge port, but a LAG? br_port_flag_is_set
> > will return false.
> 
> Good point. I see two ways forward:
> 
> - My first idea was to cache a vector per switch that would act as the
>   template when creating a new entry. This avoids having the driver
>   layer knowing about stacked netdevs etc. But I think that Andrew is
>   generally opposed to caching?

Hi Tobias

What i'm mostly against is dynamic memory allocation. If you can
allocate the space for this vector during probe, i have no problems
with that.

     Andrew
