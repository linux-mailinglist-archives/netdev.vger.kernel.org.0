Return-Path: <netdev+bounces-9911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC15972B26B
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4D0C1C209AE
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 15:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3209C121;
	Sun, 11 Jun 2023 15:17:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B770B33F1
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 15:17:14 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838E219A;
	Sun, 11 Jun 2023 08:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=EfX/L4Fy1RcnPk5WiE18CBTlWc+r/Yn54ffIp8up1lQ=; b=0+2m53I0Dpa9UbAQ3ro08HdbyJ
	w3wP+kv4elCcvsFslP1aswyo38nCIkUiozO71TcMnbDoIUt5OTtFRmPTALXQymVT3+bJLIAXH3jhr
	b0HaduN0C++CdXQWY1bUQ+5W6K2WbaNNkF3ACYWDoHU7OQ6sRT0rHDNHaPOrX+jeJFTo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q8MoK-00FVig-Js; Sun, 11 Jun 2023 17:16:56 +0200
Date: Sun, 11 Jun 2023 17:16:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	SkyLake Huang <SkyLake.Huang@mediatek.com>,
	Qingfang Deng <dqfext@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5] net: phy: add driver for MediaTek SoC
 built-in GE PHYs
Message-ID: <3c1aee38-3e8d-48ea-955b-995c9ec83cfb@lunn.ch>
References: <ZIULuiQrdgV9cZbJ@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIULuiQrdgV9cZbJ@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 12:48:10AM +0100, Daniel Golle wrote:
> Some of MediaTek's Filogic SoCs come with built-in gigabit Ethernet
> PHYs which require calibration data from the SoC's efuse.
> Despite the similar design the driver doesn't share any code with the
> existing mediatek-ge.c.
> Add support for such PHYs by introducing a new driver with basic
> support for MediaTek SoCs MT7981 and MT7988 built-in 1GE PHYs.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> +static void mt798x_phy_eee(struct phy_device *phydev)
> +{
> +	phy_modify_mmd(phydev, MDIO_MMD_VEND1,
> +		       MTK_PHY_RG_LPI_PCS_DSP_CTRL_REG120,
> +		       MTK_PHY_LPI_SIG_EN_LO_THRESH1000_MASK |
> +		       MTK_PHY_LPI_SIG_EN_HI_THRESH1000_MASK,
> +		       FIELD_PREP(MTK_PHY_LPI_SIG_EN_LO_THRESH1000_MASK, 0x0) |
> +		       FIELD_PREP(MTK_PHY_LPI_SIG_EN_HI_THRESH1000_MASK, 0x14));

Does this PHY have SmartEEE? Where the PHY itself does EEE without the
help of the MAC? At some point we would like to properly support that,
but first we need to sort out the mess MAC/PHY EEE is in.

    Andrew

