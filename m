Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D1E35B72D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 00:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhDKWTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 18:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhDKWTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 18:19:32 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D432C061574;
        Sun, 11 Apr 2021 15:19:12 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FJR9T1VLqzQjmd;
        Mon, 12 Apr 2021 00:19:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1618179547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oqe5M6Iro6zII8HaBQ43GoiPIm2yY3vuj4/CnwECLSk=;
        b=XuAlef5UlxwsXF88k4y4+Y8qg2ZAdXz0nXcAbUJrB12sEaSU/nRvHCffVhjGGtHCh5wSzR
        RuqaHV0DD4Xz2D4TpoJy/gsSjhmJXIXp+/eisjG6L4NE5e8HfNuKTEZ8r3dJyNKA6cPHl9
        wVzSF3RYrFMJfERNaTHo+0BbBWC2NTdMGQ0RQi3abU707tgG7A5FmY3/w1sDmQY5BVJPtR
        Vbc0hKD+huVmkTfmcfRRgpToqInqOncFd/61PpsU3dxGyCgpX9JBw/rhpSSPw4U26Myrn9
        ZmlLqg7gbwK/0ILTCEyrgqxRRpjdPY7VgrELUT8RgeUnk4Y1nLlLlf2aP2geww==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id FNDPP85UGZAK; Mon, 12 Apr 2021 00:19:04 +0200 (CEST)
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch
References: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping
 the registers
Message-ID: <f18e493a-9091-e4d9-06cd-839cb7a3ca7a@hauke-m.de>
Date:   Mon, 12 Apr 2021 00:19:02 +0200
MIME-Version: 1.0
In-Reply-To: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.13 / 15.00 / 15.00
X-Rspamd-Queue-Id: C84DA1111
X-Rspamd-UID: 0202cd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/21 10:55 PM, Martin Blumenstingl wrote:
> Add support for .get_regs_len and .get_regs so it is easier to find out
> about the state of the ports on the GSWIP hardware. For this we
> specifically add the GSWIP_MAC_PSTATp(port) and GSWIP_MDIO_STATp(port)
> register #defines as these contain the current port status (as well as
> the result of the auto polling mechanism). Other global and per-port
> registers which are also considered useful are included as well.
> 
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>   drivers/net/dsa/lantiq_gswip.c | 83 ++++++++++++++++++++++++++++++++++
>   1 file changed, 83 insertions(+)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 314ae78bbdd6..d3cfc72644ff 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -90,6 +90,21 @@
>   					 GSWIP_MDIO_PHY_LINK_MASK | \
>   					 GSWIP_MDIO_PHY_SPEED_MASK | \
>   					 GSWIP_MDIO_PHY_FDUP_MASK)
> +#define GSWIP_MDIO_STATp(p)		(0x16 + (p))
> +#define  GSWIP_MDIO_STAT_RXACT		BIT(10)
> +#define  GSWIP_MDIO_STAT_TXACT		BIT(9)
> +#define  GSWIP_MDIO_STAT_CLK_STOP_CAPAB	BIT(8)
> +#define  GSWIP_MDIO_STAT_EEE_CAPABLE	BIT(7)
> +#define  GSWIP_MDIO_STAT_PACT		BIT(6)
> +#define  GSWIP_MDIO_STAT_LSTAT		BIT(5)
> +#define  GSWIP_MDIO_STAT_SPEED_M10	0x00
> +#define  GSWIP_MDIO_STAT_SPEED_M100	0x08
> +#define  GSWIP_MDIO_STAT_SPEED_1G	0x10
> +#define  GSWIP_MDIO_STAT_SPEED_RESERVED	0x18
> +#define  GSWIP_MDIO_STAT_SPEED_MASK	0x18
> +#define  GSWIP_MDIO_STAT_FDUP		BIT(2)
> +#define  GSWIP_MDIO_STAT_RXPAUEN	BIT(1)
> +#define  GSWIP_MDIO_STAT_TXPAUEN	BIT(0)
>   
>   /* GSWIP MII Registers */
>   #define GSWIP_MII_CFGp(p)		(0x2 * (p))
> @@ -195,6 +210,19 @@
>   #define GSWIP_PCE_DEFPVID(p)		(0x486 + ((p) * 0xA))
>   
>   #define GSWIP_MAC_FLEN			0x8C5
> +#define GSWIP_MAC_PSTATp(p)		(0x900 + ((p) * 0xC))
> +#define  GSWIP_MAC_PSTAT_PACT		BIT(11)
> +#define  GSWIP_MAC_PSTAT_GBIT		BIT(10)
> +#define  GSWIP_MAC_PSTAT_MBIT		BIT(9)
> +#define  GSWIP_MAC_PSTAT_FDUP		BIT(8)
> +#define  GSWIP_MAC_PSTAT_RXPAU		BIT(7)
> +#define  GSWIP_MAC_PSTAT_TXPAU		BIT(6)
> +#define  GSWIP_MAC_PSTAT_RXPAUEN	BIT(5)
> +#define  GSWIP_MAC_PSTAT_TXPAUEN	BIT(4)
> +#define  GSWIP_MAC_PSTAT_LSTAT		BIT(3)
> +#define  GSWIP_MAC_PSTAT_CRS		BIT(2)
> +#define  GSWIP_MAC_PSTAT_TXLPI		BIT(1)
> +#define  GSWIP_MAC_PSTAT_RXLPI		BIT(0)
>   #define GSWIP_MAC_CTRL_0p(p)		(0x903 + ((p) * 0xC))
>   #define  GSWIP_MAC_CTRL_0_PADEN		BIT(8)
>   #define  GSWIP_MAC_CTRL_0_FCS_EN	BIT(7)
> @@ -701,6 +729,57 @@ static void gswip_port_disable(struct dsa_switch *ds, int port)
>   			  GSWIP_SDMA_PCTRLp(port));
>   }
>   
> +static int gswip_get_regs_len(struct dsa_switch *ds, int port)
> +{
> +	return 17 * sizeof(u32);
> +}
> +
> +static void gswip_get_regs(struct dsa_switch *ds, int port,
> +			   struct ethtool_regs *regs, void *_p)
> +{
> +	struct gswip_priv *priv = ds->priv;
> +	u32 *p = _p;
> +
> +	regs->version = gswip_switch_r(priv, GSWIP_VERSION);

This is the bump format version not the HW version, see here:
https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/ethtool.h#L298

I would prefer to just return 1 here, for this format. When we add an 
extra register we would change this to 2 and so on.

These are not all registers of this switch, but for now this looks good.

> +
> +	memset(p, 0xff, 17 * sizeof(u32));
> +
> +	p[0] = gswip_mdio_r(priv, GSWIP_MDIO_GLOB);
> +	p[1] = gswip_mdio_r(priv, GSWIP_MDIO_CTRL);
> +	p[2] = gswip_mdio_r(priv, GSWIP_MDIO_MDC_CFG0);
> +	p[3] = gswip_mdio_r(priv, GSWIP_MDIO_MDC_CFG1);
> +
> +	if (!dsa_is_cpu_port(priv->ds, port)) {
> +		p[4] = gswip_mdio_r(priv, GSWIP_MDIO_PHYp(port));
> +		p[5] = gswip_mdio_r(priv, GSWIP_MDIO_STATp(port));
> +		p[6] = gswip_mii_r(priv, GSWIP_MII_CFGp(port));

Please add:
#define GSWIP_MDIO_EEEp(p)		(0x1C + (p))

> +	}
> +
> +	switch (port) {
> +	case 0:
> +		p[7] = gswip_mii_r(priv, GSWIP_MII_PCDU0);
> +		break;
> +	case 1:
> +		p[7] = gswip_mii_r(priv, GSWIP_MII_PCDU1);
> +		break;
> +	case 5:
> +		p[7] = gswip_mii_r(priv, GSWIP_MII_PCDU5);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	p[8] = gswip_switch_r(priv, GSWIP_PCE_PCTRL_0p(port));
> +	p[9] = gswip_switch_r(priv, GSWIP_PCE_VCTRL(port));
> +	p[10] = gswip_switch_r(priv, GSWIP_PCE_DEFPVID(port));
> +	p[11] = gswip_switch_r(priv, GSWIP_MAC_FLEN);
> +	p[12] = gswip_switch_r(priv, GSWIP_MAC_PSTATp(port));
> +	p[13] = gswip_switch_r(priv, GSWIP_MAC_CTRL_0p(port));
> +	p[14] = gswip_switch_r(priv, GSWIP_MAC_CTRL_2p(port));
> +	p[15] = gswip_switch_r(priv, GSWIP_FDMA_PCTRLp(port));
> +	p[16] = gswip_switch_r(priv, GSWIP_SDMA_PCTRLp(port));
> +}
> +
>   static int gswip_pce_load_microcode(struct gswip_priv *priv)
>   {
>   	int i;
> @@ -1795,6 +1874,8 @@ static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
>   	.setup			= gswip_setup,
>   	.port_enable		= gswip_port_enable,
>   	.port_disable		= gswip_port_disable,
> +	.get_regs_len		= gswip_get_regs_len,
> +	.get_regs		= gswip_get_regs,
>   	.port_bridge_join	= gswip_port_bridge_join,
>   	.port_bridge_leave	= gswip_port_bridge_leave,
>   	.port_fast_age		= gswip_port_fast_age,
> @@ -1819,6 +1900,8 @@ static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
>   	.setup			= gswip_setup,
>   	.port_enable		= gswip_port_enable,
>   	.port_disable		= gswip_port_disable,
> +	.get_regs_len		= gswip_get_regs_len,
> +	.get_regs		= gswip_get_regs,
>   	.port_bridge_join	= gswip_port_bridge_join,
>   	.port_bridge_leave	= gswip_port_bridge_leave,
>   	.port_fast_age		= gswip_port_fast_age,
> 

