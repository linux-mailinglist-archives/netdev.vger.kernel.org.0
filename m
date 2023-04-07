Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491696DA768
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240224AbjDGCGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbjDGCGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82632A271
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 19:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 049EB64E40
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E454DC433EF;
        Fri,  7 Apr 2023 02:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680833046;
        bh=9usQohFkd9F5QfpQSmluSLalAG2+8SjggC6jNsevlAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ohN+os2owNnAuMgsURS6YcENBwJ82OOI1qJPuWpMxMYt1Kmel35E5zHKGhQSliFJU
         2psWwYm4oKNQSShnahCap/BuX+qpUDlwSLgQtLJn5K4IslIKN4YPb3xNVSWOz+y6ZV
         7xpGkhjgrGQIoChRP8822OssaIbBtjg6/KcQ9Tczljj80e/WKtsUwPVwHfHYnYWXDH
         ohp91oCXtcxB0Psvdkzkl6GYaLwVjnEu9TeVql9Io/LF/WoDVLdxLnMJv4WIrzSmSe
         71Q7FD1u+qjcT5W9Dc54SMT4K0jNwjvRlM/tKZg5pLHxZgTu6UPKR1ZH1NpDWAUdL7
         TKJXJUZVaui+A==
Date:   Thu, 6 Apr 2023 19:04:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230406190404.14e38e67@kernel.org>
In-Reply-To: <20230404101225.1382059-1-o.rempel@pengutronix.de>
References: <20230404101225.1382059-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Apr 2023 12:12:25 +0200 Oleksij Rempel wrote:
> Allow flow control, speed, and duplex settings on the CPU port to be
> configurable. Previously, the speed and duplex relied on default switch
> values, which limited flexibility. Additionally, flow control was
> hardcoded and only functional in duplex mode. This update enhances the
> configurability of these parameters.

Anyone who knows DSA/phylink willing to venture a review tag? :)

> diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
> index ea05abfbd51d..9bb19764fa33 100644
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
> index d0e3f6e2db1d..8917f22f90d2 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1321,12 +1321,52 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
>  			if (remote & KSZ8_PORT_FIBER_MODE)
>  				p->fiber = 1;
>  		}
> -		if (p->fiber)
> -			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
> -				     PORT_FORCE_FLOW_CTRL, true);
> -		else
> -			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
> -				     PORT_FORCE_FLOW_CTRL, false);
> +	}
> +}
> +
> +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> +			      unsigned int mode, phy_interface_t interface,
> +			      struct phy_device *phydev, int speed, int duplex,
> +			      bool tx_pause, bool rx_pause)
> +{
> +	struct dsa_switch *ds = dev->ds;
> +	struct ksz_port *p;
> +	u8 ctrl = 0;
> +
> +	p = &dev->ports[port];
> +
> +	if (dsa_upstream_port(ds, port)) {
> +		u8 mask = SW_HALF_DUPLEX_FLOW_CTRL | SW_HALF_DUPLEX |
> +			SW_FLOW_CTRL | SW_10_MBIT;
> +
> +		if (duplex) {
> +			if (tx_pause && rx_pause)
> +				ctrl |= SW_FLOW_CTRL;
> +		} else {
> +			ctrl |= SW_HALF_DUPLEX;
> +			if (tx_pause && rx_pause)
> +				ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
> +		}
> +
> +		if (speed == SPEED_10)
> +			ctrl |= SW_10_MBIT;
> +
> +		ksz_rmw8(dev, REG_SW_CTRL_4, mask, ctrl);
> +
> +		p->phydev.speed = speed;
> +	} else {
> +		const u16 *regs = dev->info->regs;
> +
> +		if (duplex) {
> +			if (tx_pause && rx_pause)
> +				ctrl |= PORT_FORCE_FLOW_CTRL;
> +		} else {
> +			if (tx_pause && rx_pause)
> +				ctrl |= PORT_BACK_PRESSURE;
> +		}
> +
> +		ksz_rmw8(dev, regs[P_STP_CTRL], PORT_FORCE_FLOW_CTRL |
> +			 PORT_BACK_PRESSURE, ctrl);
>  	}
>  }
>  
> @@ -1380,8 +1420,6 @@ int ksz8_setup(struct dsa_switch *ds)
>  	 */
>  	ds->vlan_filtering_is_global = true;
>  
> -	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
> -
>  	/* Enable automatic fast aging when link changed detected. */
>  	ksz_cfg(dev, S_LINK_AGING_CTRL, SW_LINK_AUTO_AGING, true);
>  
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 5568d7b22135..93131347ad98 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -208,6 +208,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
>  	.mirror_add = ksz8_port_mirror_add,
>  	.mirror_del = ksz8_port_mirror_del,
>  	.get_caps = ksz8_get_caps,
> +	.phylink_mac_link_up = ksz8_phylink_mac_link_up,
>  	.config_cpu_port = ksz8_config_cpu_port,
>  	.enable_stp_addr = ksz8_enable_stp_addr,
>  	.reset = ksz8_reset_switch,

