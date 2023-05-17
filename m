Return-Path: <netdev+bounces-3452-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC39A70731A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:35:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEE7A28179B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB18AD21;
	Wed, 17 May 2023 20:35:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF797136A
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:35:49 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05CD9C;
	Wed, 17 May 2023 13:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Ey8b2wCnPF7xdh+KB4nIGUzJfjRonObtGEtsoE4j8RY=; b=hEdIQoEqRA1lp9HnT03XaoaypF
	nz9WgYdhYbDQeavrHE5nt10SgOO4N3Nv9ZIVLFx7GvCepeprs+swsOGNPHsJg2VIcFWGhkeJ0TVin
	fR5XYxLHmmwzVwb/QgNeJoJZS2NvazKIwmKa/iBzxKRIyiRqCl5ThSUvgFERLrO3/PbM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzNrv-00DAca-I1; Wed, 17 May 2023 22:35:31 +0200
Date: Wed, 17 May 2023 22:35:31 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	kernel@pengutronix.de, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <da74fe43-6972-417e-981e-b7341945ae14@lunn.ch>
References: <20230517121034.3801640-1-o.rempel@pengutronix.de>
 <20230517121034.3801640-2-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517121034.3801640-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 02:10:33PM +0200, Oleksij Rempel wrote:
> Allow flow control, speed, and duplex settings on the CPU port to be
> configurable. Previously, the speed and duplex relied on default switch
> values, which limited flexibility. Additionally, flow control was
> hardcoded and only functional in duplex mode. This update enhances the
> configurability of these parameters.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8.h       |  4 +++
>  drivers/net/dsa/microchip/ksz8795.c    | 47 ++++++++++++++++++++++++--
>  drivers/net/dsa/microchip/ksz_common.c |  1 +
>  3 files changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
> index e68465fdf6b9..ec02baca726f 100644
> --- a/drivers/net/dsa/microchip/ksz8.h
> +++ b/drivers/net/dsa/microchip/ksz8.h
> @@ -58,5 +58,9 @@ int ksz8_switch_detect(struct ksz_device *dev);
>  int ksz8_switch_init(struct ksz_device *dev);
>  void ksz8_switch_exit(struct ksz_device *dev);
>  int ksz8_change_mtu(struct ksz_device *dev, int port, int mtu);
> +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> +			      unsigned int mode, phy_interface_t interface,
> +			      struct phy_device *phydev, int speed, int duplex,
> +			      bool tx_pause, bool rx_pause);
>  
>  #endif
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index f56fca1b1a22..75b98a5d53af 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1371,6 +1371,51 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
>  	}
>  }
>  
> +/**
> + * ksz8_upstram_link_up - Configures the CPU/upstream port of the switch.

Looks like a typ0: upstream

> +static void ksz8_upstram_link_up(struct ksz_device *dev, int port, int speed,
> +				 int duplex, bool tx_pause, bool rx_pause)
> +{
> +	u8 ctrl = 0;
> +
> +	if (duplex) {
> +		if (tx_pause || rx_pause)
> +			ctrl |= SW_FLOW_CTRL;
> +	} else {
> +		ctrl |= SW_HALF_DUPLEX;
> +		if (tx_pause || rx_pause)
> +			ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
> +	}
> +
> +	if (speed == SPEED_10)
> +		ctrl |= SW_10_MBIT;

Other speeds don't need to be handled? Maybe a comment why 10 is
special?

	Andrew

---
pw-bot: cr

