Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6364C1D92A4
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgESIzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:55:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:55954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgESIzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 04:55:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7CA58ACB8;
        Tue, 19 May 2020 08:55:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9E20360302; Tue, 19 May 2020 10:55:20 +0200 (CEST)
Date:   Tue, 19 May 2020 10:55:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v1 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200519085520.GB9046@lion.mk-sys.cz>
References: <20200519075200.24631-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519075200.24631-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 09:51:59AM +0200, Oleksij Rempel wrote:
> Signal Quality Index is a mandatory value required by "OPEN Alliance
> SIG" for the 100Base-T1 PHYs [1]. This indicator can be used for cable
> integrity diagnostic and investigating other noise sources and
> implement by at least two vendors: NXP[2] and TI[3].
> 
> [1] http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
> [2] https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
> [3] https://www.ti.com/product/DP83TC811R-Q1
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  Documentation/networking/ethtool-netlink.rst |  1 +
>  include/linux/phy.h                          |  1 +
>  include/uapi/linux/ethtool.h                 | 11 +++++++++
>  include/uapi/linux/ethtool_netlink.h         |  1 +
>  net/ethtool/common.c                         | 10 ++++++++
>  net/ethtool/common.h                         |  1 +
>  net/ethtool/linkstate.c                      | 25 +++++++++++++++++++-
>  7 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index eed46b6aa07df..4485e622182fc 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -457,6 +457,7 @@ Kernel response contents:
>    ====================================  ======  ==========================
>    ``ETHTOOL_A_LINKSTATE_HEADER``        nested  reply header
>    ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
> +  ``ETHTOOL_A_LINKSTATE_SQI``           u8      Current Signal Quality Index
>    ====================================  ======  ==========================
>  
>  For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns

IIRC you need to update table markers (the "===" lines) so that cell
text does not overflow. Did you check it with "make htmldocs"?

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 59344db43fcb1..b2fd230460d77 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -706,6 +706,7 @@ struct phy_driver {
>  			    struct ethtool_tunable *tuna,
>  			    const void *data);
>  	int (*set_loopback)(struct phy_device *dev, bool enable);
> +	int (*get_sqi)(struct phy_device *dev);
>  };
>  #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
>  				      struct phy_driver, mdiodrv)
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index f4662b3a9e1ef..e55caacd1886c 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1678,6 +1678,17 @@ static inline int ethtool_validate_duplex(__u8 duplex)
>  #define MASTER_SLAVE_STATE_SLAVE		3
>  #define MASTER_SLAVE_STATE_ERR			4
>  
> +#define SQI_STATE_UNSUPPORTED			0
> +#define SQI_STATE_0				1
> +#define SQI_STATE_1				2
> +#define SQI_STATE_2				3
> +#define SQI_STATE_3				4
> +#define SQI_STATE_4				5
> +#define SQI_STATE_5				6
> +#define SQI_STATE_6				7
> +#define SQI_STATE_7				8
> +#define SQI_STATE_8				9
> +
>  /* Which connector port. */
>  #define PORT_TP			0x00
>  #define PORT_AUI		0x01

The shift by one between actual SQI values and attribute values is IMHO
quite confusing for anyone looking at the messages. As the UNSUPPORTED
value is only internal (the attribute is omitted in reply message in
such case), perhaps we could use int for linkstate_reply_data::sqi and
e.g. -1 for "unsupported". Then we could use native 0-7 range
(SQI_STATE_8=9 is probably a mistake).

I'm also a bit worried about hardcoding the 0-7 value range. While I
understand that it's defined by standard for 100base-T1, we my want to
provide such information for other devices in the future. I tried to
search if there is something like that for 1000base-T1 and found this:

  http://www.sigent.cn/wp-content/uploads/2019/12/TE-1400_User-Manual_1000BASE-T1-EMC-Converter_v3.3.pdf

The screenshot on page 10 shows "SQI Value: 00015". It's probably not
standardized (yet?) but it seems to indicate we may expect other devices
providing SQI information with different value range.

Would it make sense to add ETHTOOL_A_LINKSTATE_SQI_MAX attribute telling
userspace what the range is?

[...]
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 423e640e3876d..f3c905e59124f 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -310,6 +310,16 @@ int __ethtool_get_link(struct net_device *dev)
>  	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
>  }
>  
> +int __ethtool_get_sqi(struct net_device *dev)
> +{
> +	struct phy_device *phydev = dev->phydev;
> +
> +	if (!phydev->drv->get_sqi)

You should check phydev for NULL first.

Michal

> +		return -EOPNOTSUPP;
> +
> +	return phydev->drv->get_sqi(phydev);
> +}
> +
>  int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
>  {
>  	u32 dev_size, current_max = 0;
