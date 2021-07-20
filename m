Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D45B3CFB11
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbhGTNGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:06:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36074 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238633AbhGTNFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:05:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+TxmGM7oZN1JvErCcvoTJ49wLDlNOAh824/dQGvw4p8=; b=axRBuzbs65tgu6LobjXr9ktpVL
        2CZYoWTCgIDB0nllziru7nQNsMIrPANUYeADcaEr0cqMiyEY5kVBox1fQP/zsjTETF7gNz1X1h+x7
        r+iPC580gmKnm8mS7Xd9jyd42VbVRy9aqoJ2EAvpNCEf2QkuPgnAoQ0DSrxIHVmgWjTM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5q45-00E3c3-S6; Tue, 20 Jul 2021 15:45:41 +0200
Date:   Tue, 20 Jul 2021 15:45:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: check for address type in
 port_db_load_purge
Message-ID: <YPbThTUcE1QXnZJM@lunn.ch>
References: <20210720092426.1998666-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720092426.1998666-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 05:24:26PM +0800, DENG Qingfang wrote:
> The same state value of an ATU entry can mean different states,
> depending on the entry's address type.
> Check for its address type instead of state, to determine if its
> portvec should be overridden.

Please could you expand this description. It is not obvious to me this
change correct.

> 
> Fixes: f72f2fb8fb6b ("net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index beb41572d04e..dd4d7fa0da8e 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1741,7 +1741,7 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
>  		if (!entry.portvec)
>  			entry.state = 0;
>  	} else {
> -		if (state == MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC)
> +		if (is_unicast_ether_addr(addr))
>  			entry.portvec = BIT(port);
>  		else
>  			entry.portvec |= BIT(port);

I agree that MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC should only be used
with an address which is know to be unicast. If the address is
multicast, it means it should be considered as a management frame, and
given priority override.

But what exactly are we interested in here? The old code looked like
it wanted to match on static unicast entries. Your change will make it
match on static and dynamic unicast? Do we want dynamic as well? Why
is the fix not this?

> -		if (state == MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC)
> +		if (is_unicast_ether_addr(addr) && state == MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC)

which fixes the problem you describe in the commit message.

Thanks
	Andrew
