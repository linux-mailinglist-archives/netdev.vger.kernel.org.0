Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0051E2217
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 14:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389209AbgEZMlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 08:41:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:60738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388497AbgEZMlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 08:41:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B997AAFCD;
        Tue, 26 May 2020 12:41:45 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CF2036032A; Tue, 26 May 2020 14:41:39 +0200 (CEST)
Date:   Tue, 26 May 2020 14:41:39 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200526124139.mvsn52cixu2t5ljz@lion.mk-sys.cz>
References: <20200526091025.25243-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526091025.25243-1-o.rempel@pengutronix.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 11:10:25AM +0200, Oleksij Rempel wrote:
> This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> auto-negotiation support, we needed to be able to configure the
> MASTER-SLAVE role of the port manually or from an application in user
> space.
> 
> The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> force MASTER or SLAVE role. See IEEE 802.3-2018:
> 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> 40.5.2 MASTER-SLAVE configuration resolution
> 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> 
> The MASTER-SLAVE role affects the clock configuration:
> 
> -------------------------------------------------------------------------------
> When the  PHY is configured as MASTER, the PMA Transmit function shall
> source TX_TCLK from a local clock source. When configured as SLAVE, the
> PMA Transmit function shall source TX_TCLK from the clock recovered from
> data stream provided by MASTER.
> 
> iMX6Q                     KSZ9031                XXX
> ------\                /-----------\        /------------\
>       |                |           |        |            |
>  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
>       |<--- 125 MHz ---+-<------/  |        | \          |
> ------/                \-----------/        \------------/
>                                                ^
>                                                 \-TX_TCLK
> 
> -------------------------------------------------------------------------------
> 
> Since some clock or link related issues are only reproducible in a
> specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> to provide generic (not 100BASE-T1 specific) interface to the user space
> for configuration flexibility and trouble shooting.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Please document the new command line argument in both "ethtool --help"
output and manual page.

I would also prefer updating the UAPI header copies in a separate commit
which would update all of them to a state of a specific kernel commit
(either 4.8-rc1 or current net-next); cherry picking specific changes
may lead to missing some parts. An easy way would be

  # switch to kernel repository and check out what you want to copy from
  make ... INSTALL_HDR_PATH=$somewhere headers_install
  # switch back to ethtool repository
  cd uapi
  find . -type f -exec cp -v ${somewhere}/include/{} {} \;

Also, as the kernel counterpart is only in net-next at the moment, this
should probably wait until after ethtool 5.7 release (perhaps it would
be helpful to have a "next" branch like iproute2). I'll submit my queued
patches for 5.7 later this week; should have done so long ago but
I hoped to have the netlink friendly test framework finished before I do
(test-features.c is tied to ioctl interface too tightly).

[...]
> @@ -827,6 +861,14 @@ static const struct lookup_entry_u32 duplex_values[] = {
>  	{}
>  };
>  
> +static const struct lookup_entry_u32 master_slave_values[] = {

This should be struct lookup_entry_u8, you are using it with
nl_parse_lookup_u8() to generate an NLA_U8 attribute.

Michal

> +	{ .arg = "master-preferred",	.val = PORT_MODE_CFG_MASTER_PREFERRED },
> +	{ .arg = "slave-preferred",	.val = PORT_MODE_CFG_SLAVE_PREFERRED },
> +	{ .arg = "master-force",	.val = PORT_MODE_CFG_MASTER_FORCE },
> +	{ .arg = "slave-force",		.val = PORT_MODE_CFG_SLAVE_FORCE },
> +	{}
> +};
> +
>  char wol_bit_chars[WOL_MODE_COUNT] = {
>  	[WAKE_PHY_BIT]		= 'p',
>  	[WAKE_UCAST_BIT]	= 'u',
> @@ -917,6 +959,14 @@ static const struct param_parser sset_params[] = {
>  		.handler_data	= duplex_values,
>  		.min_argc	= 1,
>  	},
> +	{
> +		.arg		= "master-slave",
> +		.group		= ETHTOOL_MSG_LINKMODES_SET,
> +		.type		= ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
> +		.handler	= nl_parse_lookup_u8,
> +		.handler_data	= master_slave_values,
> +		.min_argc	= 1,
> +	},
>  	{
>  		.arg		= "wol",
>  		.group		= ETHTOOL_MSG_WOL_SET,
