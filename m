Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5826E486
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgIQSur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:50:47 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:44706 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgIQSug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:50:36 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08HIo0hI085450;
        Thu, 17 Sep 2020 13:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600368600;
        bh=GSyOHIEEOuX0hzpqE7QI6OG2FGREmdTA0Ssv8saQ4Us=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qOJfMxuDioJVBGdilJVzdj19+ikEtA4D7r8p9JwE4ZX945cVQLiClRWrAGiyEL00z
         3Kd53yJEct9m024Mvtvgqr+Tk54/M4scVWFDjrnIsykMNhKRN7VxDpdqmp3izu76Uv
         Y8GyiKPKITdjAK/KVICYHT2F08tUL8jz3Hio7f8E=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08HInxFW069130
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 13:49:59 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 17
 Sep 2020 13:49:59 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 17 Sep 2020 13:49:59 -0500
Received: from [10.250.32.129] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08HInxpC068422;
        Thu, 17 Sep 2020 13:49:59 -0500
Subject: Re: [PATCH net-next v4 5/5] ravb: Add support for explicit internal
 clock delay configuration
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200917135707.12563-1-geert+renesas@glider.be>
 <20200917135707.12563-6-geert+renesas@glider.be>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <29970fbf-9779-d182-5df9-4f563f377311@ti.com>
Date:   Thu, 17 Sep 2020 13:49:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200917135707.12563-6-geert+renesas@glider.be>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert

On 9/17/20 8:57 AM, Geert Uytterhoeven wrote:
> Some EtherAVB variants support internal clock delay configuration, which
> can add larger delays than the delays that are typically supported by
> the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
> properties).
>
> Historically, the EtherAVB driver configured these delays based on the
> "rgmii-*id" PHY mode.  This caused issues with PHY drivers that
> implement PHY internal delays properly[1].  Hence a backwards-compatible
> workaround was added by masking the PHY mode[2].
>
> Add proper support for explicit configuration of the MAC internal clock
> delays using the new "[rt]x-internal-delay-ps" properties.
> Fall back to the old handling if none of these properties is present.
>
> [1] Commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for
>      the KSZ9031 PHY")
> [2] Commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
>      delays twice").
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> v4:
>    - Add Reviewed-by,
>
> v3:
>    - No changes,
>
> v2:
>    - Add Reviewed-by,
>    - Split long line,
>    - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps",
>    - Use 1 instead of true when assigning to a single-bit bitfield.
> ---
>   drivers/net/ethernet/renesas/ravb.h      |  1 +
>   drivers/net/ethernet/renesas/ravb_main.c | 36 ++++++++++++++++++------
>   2 files changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index e5ca12ce93c730a9..7453b17a37a2c8d0 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1038,6 +1038,7 @@ struct ravb_private {
>   	unsigned wol_enabled:1;
>   	unsigned rxcidm:1;		/* RX Clock Internal Delay Mode */
>   	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
> +	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
>   	int num_tx_desc;		/* TX descriptors per packet */
>   };
>   
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 59dadd971345e0d1..aa120e3f1e4d4da5 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1034,11 +1034,8 @@ static int ravb_phy_init(struct net_device *ndev)
>   		pn = of_node_get(np);
>   	}
>   
> -	iface = priv->phy_interface;
> -	if (priv->chip_id != RCAR_GEN2 && phy_interface_mode_is_rgmii(iface)) {
> -		/* ravb_set_delay_mode() takes care of internal delay mode */
> -		iface = PHY_INTERFACE_MODE_RGMII;
> -	}
> +	iface = priv->rgmii_override ? PHY_INTERFACE_MODE_RGMII
> +				     : priv->phy_interface;
>   	phydev = of_phy_connect(ndev, pn, ravb_adjust_link, 0, iface);
>   	of_node_put(pn);
>   	if (!phydev) {
> @@ -1989,20 +1986,41 @@ static const struct soc_device_attribute ravb_delay_mode_quirk_match[] = {
>   };
>   
>   /* Set tx and rx clock internal delay modes */
> -static void ravb_parse_delay_mode(struct net_device *ndev)
> +static void ravb_parse_delay_mode(struct device_node *np, struct net_device *ndev)
>   {
>   	struct ravb_private *priv = netdev_priv(ndev);
> +	bool explicit_delay = false;
> +	u32 delay;
> +
> +	if (!of_property_read_u32(np, "rx-internal-delay-ps", &delay)) {
> +		/* Valid values are 0 and 1800, according to DT bindings */
> +		priv->rxcidm = !!delay;
> +		explicit_delay = true;
> +	}
> +	if (!of_property_read_u32(np, "tx-internal-delay-ps", &delay)) {
> +		/* Valid values are 0 and 2000, according to DT bindings */
> +		priv->txcidm = !!delay;
> +		explicit_delay = true;
> +	}
There are helper functions for this

s32 phy_get_internal_delay(struct phy_device *phydev, struct device 
*dev, const int *delay_values, int size, bool is_rx)


