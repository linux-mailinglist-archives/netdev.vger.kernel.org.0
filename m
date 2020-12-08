Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69582D2D2C
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgLHO0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:26:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgLHO0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 09:26:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmdvb-00Aqk4-Ky; Tue, 08 Dec 2020 15:25:19 +0100
Date:   Tue, 8 Dec 2020 15:25:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: don't set non-existing
 learn2all bit for 6220/6250
Message-ID: <20201208142519.GK2475764@lunn.ch>
References: <20201208090109.363-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208090109.363-1-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:01:09AM +0100, Rasmus Villemoes wrote:
> The 6220 and 6250 switches do not have a learn2all bit in global1, ATU
> control register; bit 3 is reserved.
> 
> On the switches that do have that bit, it is used to control whether
> learning frames are sent out the ports that have the message_port bit
> set. So rather than adding yet another chip method, use the existence
> of the ->port_setup_message_port method as a proxy for determining
> whether the learn2all bit exists (and should be set).
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
> 
> This doesn't fix anything from what I can tell, in particular not the
> VLAN problems I'm having, so just tagging for net-next. But I do think
> it's worth it on the general principle of not poking around in
> undocumented/reserved bits.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 25449f634889..0245f3dfc1cd 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1347,9 +1347,11 @@ static int mv88e6xxx_atu_setup(struct mv88e6xxx_chip *chip)
>  	if (err)
>  		return err;
>  
> -	err = mv88e6xxx_g1_atu_set_learn2all(chip, true);
> -	if (err)
> -		return err;
> +	if (chip->info->ops->port_setup_message_port) {
> +		err = mv88e6xxx_g1_atu_set_learn2all(chip, true);
> +		if (err)
> +			return err;
> +	}

Hi Rasmus

This needs a comment in the code explaining why this odd structure is
used.

	Andrew
