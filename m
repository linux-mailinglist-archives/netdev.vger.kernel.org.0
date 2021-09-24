Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E829417BEC
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 21:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348219AbhIXTuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 15:50:46 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:51282 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348213AbhIXTup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 15:50:45 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 0E4FA20A6EB4
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 08/18] ravb: Add mii_rgmii_selection to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-9-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <8b92e5f8-2f78-b64c-8356-1e43034ba622@omp.ru>
Date:   Fri, 24 Sep 2021 22:49:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-9-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:08 PM, Biju Das wrote:

> E-MAC on RZ/G2L supports MII/RGMII selection. Add a
> mii_rgmii_selection feature bit to struct ravb_hw_info
> to support this for RZ/G2L.
> Currently only selecting RGMII is supported.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 17 +++++++++++++++++
>  drivers/net/ethernet/renesas/ravb_main.c |  6 ++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index bce480fadb91..dfaf3121da44 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
[...]
> @@ -951,6 +953,20 @@ enum RAVB_QUEUE {
>  	RAVB_NC,	/* Network Control Queue */
>  };
>  
> +enum CXR31_BIT {
> +	CXR31_SEL_LINK0	= 0x00000001,
> +	CXR31_SEL_LINK1	= 0x00000008,
> +};
> +
> +enum CXR35_BIT {
> +	CXR35_SEL_MODIN	= 0x00000100,
> +};
> +
> +enum CSR0_BIT {
> +	CSR0_TPE	= 0x00000010,
> +	CSR0_RPE	= 0x00000020,
> +};

   I don't see those used? What is CSR0?

[...]
> @@ -1008,6 +1024,7 @@ struct ravb_hw_info {
>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
>  	unsigned multi_tsrq:1;		/* AVB-DMAC has MULTI TSRQ */
>  	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
> +	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii selection */

   Perhaps just 'mii_rgmii_sel'?

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 529364d8f7fb..5d18681582b9 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -1173,6 +1174,10 @@ static int ravb_phy_init(struct net_device *ndev)
>  		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
>  	}
>  
> +	if (info->mii_rgmii_selection &&
> +	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID)

   Not MII?

> +		ravb_write(ndev, ravb_read(ndev, CXR35) | CXR35_SEL_MODIN, CXR35);

   We have ravb_mnodify() for that...

> +
>  	/* 10BASE, Pause and Asym Pause is not supported */
>  	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
>  	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> @@ -2132,6 +2137,7 @@ static const struct ravb_hw_info rgeth_hw_info = {
>  	.aligned_tx = 1,
>  	.tx_counters = 1,
>  	.no_gptp = 1,
> +	.mii_rgmii_selection = 1,

   I don't see where we handle MII?

[...]

MBR, Sergey
