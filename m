Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA53195F66
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgC0UB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:01:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgC0UB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 16:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Bz7tLvQ0GaGe2Raw/XStvgG+NjAwALbU/q0v1eXL+wo=; b=L1O9hvBWOrlb9E75zbxB3l+TNB
        vzM7Y2L9HkOTwrOGWehaG3VQrYiCWw3cW8BYDG7Gu7nX0USjrwckrPtGayNqt6fytMDB4aV1O4gD+
        DWQOFival1Xv0JKHN2GochowfttjL9hhsvT4elJKG+eqeOwYd9XqGs46G7PCymMgFeLE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHvAv-0004pL-Ik; Fri, 27 Mar 2020 21:01:53 +0100
Date:   Fri, 27 Mar 2020 21:01:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
Message-ID: <20200327200153.GR3819@lunn.ch>
References: <20200327195156.1728163-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327195156.1728163-1-daniel@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 08:51:56PM +0100, Daniel Mack wrote:
> On hardware with a speed-reduced link to the CPU port, forcing the MAC
> settings won't allow any packets to pass. The PHY will negotiate the
> maximum possible speed, so let's allow the MAC to work with whatever
> is available.

Hi Daniel

This will break board which rely on the CPU being forced to the
maximum speed, which has been the default since forever.

It sounds like you have the unusual situation of back to back PHYs?
And i assume the SoC PHY is limited to Fast Ethernet?

What i think you can do is have a phy-handle in the cpu node which
points to the PHY. That should then cause the PHY to be driven as a
normal PHY, and the result of auto neg passed to the MAC.

       Andrew

> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 2f993e673ec7..48808c4add4f 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2426,7 +2426,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	 * state to any particular values on physical ports, but force the CPU
>  	 * port and all DSA ports to their maximum bandwidth and full duplex.
>  	 */
> -	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +	if (dsa_is_dsa_port(ds, port))
>  		err = mv88e6xxx_port_setup_mac(chip, port, LINK_FORCED_UP,
>  					       SPEED_MAX, DUPLEX_FULL,
>  					       PAUSE_OFF,
> -- 
> 2.25.1
> 
