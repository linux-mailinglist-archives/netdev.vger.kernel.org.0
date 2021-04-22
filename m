Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3136896A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbhDVXi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:38:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36764 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVXi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:38:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZitl-000Yov-LB; Fri, 23 Apr 2021 01:38:17 +0200
Date:   Fri, 23 Apr 2021 01:38:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <YIII6cl5X4UsvRq3@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void lan937x_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
> +			      u64 *dropped, u64 *cnt)
> +{
> +	addr = lan937x_mib_names[addr].index;
> +	lan937x_r_mib_cnt(dev, port, addr, cnt);
> +}
> +
> +static void lan937x_port_init_cnt(struct ksz_device *dev, int port)
> +{
> +	struct ksz_port_mib *mib = &dev->ports[port].mib;
> +
> +	/* flush all enabled port MIB counters */
> +	mutex_lock(&mib->cnt_mutex);
> +	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4,
> +			 MIB_COUNTER_FLUSH_FREEZE);
> +	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
> +	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
> +	mutex_unlock(&mib->cnt_mutex);
> +
> +	mib->cnt_ptr = 0;
> +	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));

This setting of cnt_ptr to zero and the memset() seem to be common to
all the drivers. Please add a cleanup patch which moves this into
ksz_init_mib_timer().

	Andrew
