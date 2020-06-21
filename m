Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E846202BA6
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 18:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgFUQ5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 12:57:22 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:59311 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730411AbgFUQ5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 12:57:21 -0400
Received: from webmail.gandi.net (webmail21.sd4.0x35.net [10.200.201.21])
        (Authenticated sender: foss@0leil.net)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPA id 959C020003;
        Sun, 21 Jun 2020 16:57:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 21 Jun 2020 18:57:14 +0200
From:   Quentin Schulz <foss@0leil.net>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v3 5/8] net: phy: mscc: 1588 block initialization
In-Reply-To: <20200619122300.2510533-6-antoine.tenart@bootlin.com>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
 <20200619122300.2510533-6-antoine.tenart@bootlin.com>
Message-ID: <f7b8b3fe41ba9e395eb0bb6bee9a020c@0leil.net>
X-Sender: foss@0leil.net
User-Agent: Roundcube Webmail/1.3.8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

Feels weird to review my own patches a year later having written them,
almost nostalgic :)

The review is mostly nitpicks.

On 2020-06-19 14:22, Antoine Tenart wrote:
[...]
> @@ -373,6 +374,21 @@ struct vsc8531_private {
>  	unsigned long ingr_flows;
>  	unsigned long egr_flows;
>  #endif
> +
> +	bool input_clk_init;
> +	struct vsc85xx_ptp *ptp;
> +
> +	/* For multiple port PHYs; the MDIO address of the base PHY in the
> +	 * pair of two PHYs that share a 1588 engine. PHY0 and PHY2 are 
> coupled.
> +	 * PHY1 and PHY3 as well. PHY0 and PHY1 are base PHYs for their
> +	 * respective pair.
> +	 */
> +	unsigned int ts_base_addr;
> +	u8 ts_base_phy;
> +

I hate myself now for this bad naming. After reading the code, 
ts_base_addr is the address
of the base PHY (of a pair) on the MDIO bus and ts_base_phy is the 
"internal" (package)
address of the base PHy (of a pair). This is not very explicit.

Would ts_base_phy renamed into a ts_base_pkg_addr work better?

> +	/* ts_lock: used for per-PHY timestamping operations.
> +	 */

I don't remember exactly the comment best practices in net anymore, but 
one line
comment instead?

[...]

>  #endif /* _MSCC_PHY_H_ */
> diff --git a/drivers/net/phy/mscc/mscc_main.c 
> b/drivers/net/phy/mscc/mscc_main.c
> index 052a0def6e83..87ddae514627 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -1299,11 +1299,29 @@ static void vsc8584_get_base_addr(struct
> phy_device *phydev)
>  	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
>  	mutex_unlock(&phydev->mdio.bus->mdio_lock);
> 
> -	if (val & PHY_ADDR_REVERSED)
> +	/* In the package, there are two pairs of PHYs (PHY0 + PHY2 and
> +	 * PHY1 + PHY3). The first PHY of each pair (PHY0 and PHY1) is
> +	 * the base PHY for timestamping operations.
> +	 */
> +	if (val & PHY_ADDR_REVERSED) {
>  		vsc8531->base_addr = phydev->mdio.addr + addr;
> -	else
> +		vsc8531->ts_base_addr = phydev->mdio.addr;
> +		vsc8531->ts_base_phy = addr;
> +		if (addr > 1) {
> +			vsc8531->ts_base_addr += 2;
> +			vsc8531->ts_base_phy += 2;
> +		}
> +	} else {
>  		vsc8531->base_addr = phydev->mdio.addr - addr;
> 
> +		vsc8531->ts_base_addr = phydev->mdio.addr;
> +		vsc8531->ts_base_phy = addr;

The two lines above are identical in both conditions, what about moving
them just before the if (val & PHY_ADDR_REVERSED) line?

[...]

> +static const u32 vsc85xx_egr_latency[] = {
> +	/* Copper Egress */
> +	1272, /* 1000Mbps */
> +	12516, /* 100Mbps */
> +	125444, /* 10Mbps */
> +	/* Fiber Egress */
> +	1277, /* 1000Mbps */
> +	12537, /* 100Mbps */
> +	/* Copper Egress when MACsec ON */
> +	3496, /* 1000Mbps */
> +	34760, /* 100Mbps */
> +	347844, /* 10Mbps */
> +	/* Fiber Egress when MACsec ON */
> +	3502, /* 1000Mbps */
> +	34780, /* 100Mbps */
> +};
> +
> +static const u32 vsc85xx_ingr_latency[] = {
> +	/* Copper Ingress */
> +	208, /* 1000Mbps */
> +	304, /* 100Mbps */
> +	2023, /* 10Mbps */
> +	/* Fiber Ingress */
> +	98, /* 1000Mbps */
> +	197, /* 100Mbps */
> +	/* Copper Ingress when MACsec ON */
> +	2408, /* 1000Mbps */
> +	22300, /* 100Mbps */
> +	222009, /* 10Mbps */
> +	/* Fiber Ingress when MACsec ON */
> +	2299, /* 1000Mbps */
> +	22192, /* 100Mbps */
> +};
> +

Wouldn't it make more sense to separate the latencies into two different
arrays? One for non-MACsec and one with? No idx "hack" later in the 
function
that way.

> +static void vsc85xx_ts_set_latencies(struct phy_device *phydev)
> +{
> +	u32 val;
> +	u8 idx;
> +
> +	/* No need to set latencies of packets if the PHY is not connected */
> +	if (!phydev->link)
> +		return;
> +
> +	vsc85xx_ts_write_csr(phydev, PROCESSOR, 
> MSCC_PHY_PTP_EGR_STALL_LATENCY,
> +			     STALL_EGR_LATENCY(phydev->speed));
> +
> +	switch (phydev->speed) {
> +	case SPEED_100:
> +		idx = 1;
> +		break;
> +	case SPEED_1000:
> +		idx = 0;
> +		break;
> +	default:
> +		idx = 2;
> +		break;
> +	}
> +
> +	if (IS_ENABLED(CONFIG_MACSEC))
> +		idx += 5;

[...]

> +static int vsc85xx_eth1_conf(struct phy_device *phydev, enum ts_blk 
> blk,
> +			     bool enable)
> +{
> +	struct vsc8531_private *vsc8531 = phydev->priv;
> +	u32 val = ANA_ETH1_FLOW_ADDR_MATCH2_DEST;
> +
> +	if (vsc8531->ptp->rx_filter == HWTSTAMP_FILTER_PTP_V2_L2_EVENT) {
> +		/* PTP over Ethernet multicast address for SYNC and DELAY msg */
> +		u8 ptp_multicast[6] = {0x01, 0x1b, 0x19, 0x00, 0x00, 0x00};
> +

I think this is actually part of "the" standard:
https://en.wikipedia.org/wiki/Precision_Time_Protocol#Message_transport

So would it make sense to make it available to all drivers via one of 
the
include/linux/ptp_*.h?

[...]

> +static bool vsc8584_is_1588_input_clk_configured(struct phy_device 
> *phydev)
> +{
> +	struct vsc8531_private *vsc8531 = phydev->priv;
> +
> +	if (vsc8531->ts_base_addr != phydev->mdio.addr) {
> +		struct mdio_device *dev;
> +
> +		dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
> +		phydev = container_of(dev, struct phy_device, mdio);
> +		vsc8531 = phydev->priv;
> +	}
> +
> +	return vsc8531->input_clk_init;
> +}
> +
> +static void vsc8584_set_input_clk_configured(struct phy_device 
> *phydev)
> +{
> +	struct vsc8531_private *vsc8531 = phydev->priv;
> +
> +	if (vsc8531->ts_base_addr != phydev->mdio.addr) {
> +		struct mdio_device *dev;
> +
> +		dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
> +		phydev = container_of(dev, struct phy_device, mdio);
> +		vsc8531 = phydev->priv;
> +	}
> +
> +	vsc8531->input_clk_init = true;
> +}

Duplicated code here.
Maybe:

static struct vsc8531_private * vsc8584_get_ts_base_phydev(struct 
phy_device *phydev)
{
	struct vsc8531_private *vsc8531 = phydev->priv;
	if (vsc8531->ts_base_addr != phydev->mdio.addr) {
		struct mdio_device *dev;

		dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
		phydev = container_of(dev, struct phy_device, mdio);
		vsc8531 = phydev->priv;
	}
	return vsc8531;
}

?

[...]

> diff --git a/drivers/net/phy/mscc/mscc_ptp.h 
> b/drivers/net/phy/mscc/mscc_ptp.h
[...]
> +
> +struct vsc85xx_ptphdr {
> +	u8 tsmt; /* transportSpecific | messageType */
> +	u8 ver;  /* reserved0 | versionPTP */
> +	__be16 msglen;
> +	u8 domain;
> +	u8 rsrvd1;
> +	__be16 flags;
> +	__be64 correction;
> +	__be32 rsrvd2;
> +	__be64 clk_identity;
> +	__be16 src_port_id;
> +	__be16 seq_id;
> +	u8 ctrl;
> +	u8 log_interval;
> +} __attribute__((__packed__));
> +

AFAICT, this is also part of "the" standard:
http://wiki.hevs.ch/uit/index.php5/Standards/Ethernet_PTP/frames#PTP_Header
Would maybe be better to have it in one of the header files in include/?

Thanks,
Quentin
