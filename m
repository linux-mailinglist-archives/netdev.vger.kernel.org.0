Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06701447CA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfFMRBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:01:53 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38272 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729554AbfFLXZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TRyReCI1ZeePA/icNnPhOvHy30z5zcIQ4eMJuqV5Y3c=; b=oGxWdiauJRI9/slWVWnwf/k9o
        wnzKtSm7pz6zS2y3zFyBOrnUrhBCya5fGnKpFxfGoBy94fQBaeNyaLRY8d+meDaxqpkIO7Qmgz8LK
        CsNGKlQkWc17xzZbL/pa+BhiGvQX/Q6jkQdYFxAU85yLEU6m7c6YTfe34szwXUo6jQ1x+yGyvVWxL
        T6VPHxV9Jb0k0JU0UIxl2+KahRZjkFEKqwU8sSnKsM4PQlfRHtsVshlRwf7euYg8MFfL/QJ4pgMnK
        VsEffHH7xrIeVuJ4JqRJBpD9WrO0UbIbYtJz77cV74kV+u/uQt6O13FG2xIQqRewkMl9pN19ycWl4
        eatMURxTQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38640)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbCcs-0007hB-Vc; Thu, 13 Jun 2019 00:25:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbCcq-0000fu-MX; Thu, 13 Jun 2019 00:25:52 +0100
Date:   Thu, 13 Jun 2019 00:25:52 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: do not flood CPU with
 unknown multicast
Message-ID: <20190612232552.pzsp5rdadlaiht2n@shell.armlinux.org.uk>
References: <20190612223344.28781-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612223344.28781-1-vivien.didelot@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 06:33:44PM -0400, Vivien Didelot wrote:
> The DSA ports must flood unknown unicast and multicast, but the switch
> must not flood the CPU ports with unknown multicast, as this results
> in a lot of undesirable traffic that the network stack needs to filter
> in software.

What if you have configured IPv6 on the bridge device, and are expecting
the multicasted IPv6 frames for neighbour discovery to work?

> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index d8d1781810e2..e412ccabd104 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2111,15 +2111,13 @@ static int mv88e6xxx_setup_message_port(struct mv88e6xxx_chip *chip, int port)
>  static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
>  {
>  	struct dsa_switch *ds = chip->ds;
> -	bool flood;
> +	bool uc = dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port);
> +	bool mc = dsa_is_dsa_port(ds, port);
>  
> -	/* Upstream ports flood frames with unknown unicast or multicast DA */
> -	flood = dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port);
> -	if (chip->info->ops->port_set_egress_floods)
> -		return chip->info->ops->port_set_egress_floods(chip, port,
> -							       flood, flood);
> +	if (!chip->info->ops->port_set_egress_floods)
> +		return 0;
>  
> -	return 0;
> +	return chip->info->ops->port_set_egress_floods(chip, port, uc, mc);
>  }
>  
>  static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
> -- 
> 2.21.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
