Return-Path: <netdev+bounces-11862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8B2734EE4
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8BF01C208D1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0BDBA51;
	Mon, 19 Jun 2023 08:58:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8EA79C4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:58:56 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72088D9;
	Mon, 19 Jun 2023 01:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687165136; x=1718701136;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BTctNJGtNKeC547EpUBouwSImLTyx71b0O6iSpMn8wQ=;
  b=J7H0Gx0dKggIsfcoKSYXW6EaJd9/x7jgu0YeEgIl/emAxB6j+cYWxDBs
   K4gCeJn3XCBfHBuFQhBVoAGlLtNgbeAW58AH7vah8pqwI3dVTBiSKIlAH
   5R87GtTR1PHwKbIrO0N3OMQpQnWAXARMwoNKo3aHdEXqQLsaHjPCiR5ZR
   OZjbIlwWY+n5BLfkUJIUVZz9cGP1NB5ZLuhMxIrpqOjXPKpdrtCBrh0oY
   /85YdjMucCJXMVJgW5vNyT3IP4pN1haB/ZCQ5fF/MMsAvnDI7ZXxLEWXg
   KEtzL9jGbjynOfcMpa1CNaJubUjQiXJUupTNOGibh/8Pl2Wvz8n06HRTc
   w==;
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="216633003"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jun 2023 01:58:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 19 Jun 2023 01:58:32 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 19 Jun 2023 01:58:32 -0700
Date: Mon, 19 Jun 2023 10:58:31 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <sebastian.tobuschat@nxp.com>
Subject: Re: [PATCH net-next v1 14/14] net: phy: nxp-c45-tja11xx: timestamp
 reading workaround for TJA1120
Message-ID: <20230619085831.dnzg2i5mqysc6r3r@soft-dev3-1>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-15-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-15-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/16/2023 16:53, Radu Pirea (NXP OSS) wrote:

Hi Radu,

> 
> On TJA1120 engineering samples, the new timestamp is stuck in the FIFO.
> If the MORE_TS bit is set and the VALID bit is not set, we know that we
> have a timestamp in the FIFO but not in the buffer.
> 
> To move the new timestamp in the buffer registers, the current
> timestamp(which is invalid) is unlocked by writing any of the buffer
> registers.

Shouldn't this be split and merged in patch 9 and patch 10?
As those two patches introduced this functions with issues.

> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/phy/nxp-c45-tja11xx.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
> index 0d22eb7534dc..3543c8fe099c 100644
> --- a/drivers/net/phy/nxp-c45-tja11xx.c
> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
> @@ -532,15 +532,30 @@ static bool nxp_c45_get_extts(struct nxp_c45_phy *priv,
>  static bool tja1120_get_extts(struct nxp_c45_phy *priv,
>                               struct timespec64 *extts)
>  {
> +       const struct nxp_c45_regmap *regmap = nxp_c45_get_regmap(priv->phydev);
> +       bool more_ts;
>         bool valid;
>         u16 reg;
> 
> +       reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
> +                          regmap->vend1_ext_trg_ctrl);
> +       more_ts = !!(reg & TJA1120_MORE_TS);
> +
>         reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
>                            TJA1120_VEND1_PTP_TRIG_DATA_S);
>         valid = !!(reg & TJA1120_TS_VALID);
>         if (valid)
>                 return nxp_c45_get_extts(priv, extts);
> 
> +       /* Bug workaround for TJA1120 enegineering samples: move the new
> +        * timestamp from the FIFO to the buffer.
> +        */
> +       if (more_ts) {
> +               phy_write_mmd(priv->phydev, MDIO_MMD_VEND1,
> +                             regmap->vend1_ext_trg_ctrl, RING_DONE);
> +               return nxp_c45_get_extts(priv, extts);
> +       }
> +
>         return valid;
>  }
> 
> @@ -588,15 +603,25 @@ static bool tja1120_get_hwtxts(struct nxp_c45_phy *priv,
>                                struct nxp_c45_hwts *hwts)
>  {
>         struct phy_device *phydev = priv->phydev;
> +       bool more_ts;
>         bool valid;
>         u16 reg;
> 
>         mutex_lock(&priv->ptp_lock);
> +       reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_END);
> +       more_ts = !!(reg & TJA1120_MORE_TS);
>         reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_DATA_S);
>         valid = !!(reg & TJA1120_TS_VALID);
> -       if (!valid)
> -               goto tja1120_get_hwtxts_out;
> -
> +       if (!valid) {
> +               if (!more_ts)
> +                       goto tja1120_get_hwtxts_out;
> +               /* Bug workaround for TJA1120 enegineering samples: move the
> +                * new timestamp from the FIFO to the buffer.
> +                */
> +               phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
> +                                  TJA1120_EGRESS_TS_END, TJA1120_TS_VALID);
> +               valid = true;
> +       }
>         nxp_c45_read_egress_ts(priv, hwts);
>         phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_DATA_S,
>                            TJA1120_TS_VALID);
> --
> 2.34.1
> 
> 

-- 
/Horatiu

