Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1132826046B
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgIGSTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:19:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbgIGSTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 14:19:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFLjC-00DfCu-N3; Mon, 07 Sep 2020 20:18:54 +0200
Date:   Mon, 7 Sep 2020 20:18:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20200907181854.GD3254313@lunn.ch>
References: <20200825180134.GN2403519@lunn.ch>
 <CGME20200907173945eucas1p240c0d7ebff3010a3bf752eaf8e619eb1@eucas1p2.samsung.com>
 <dleftjwo15qyei.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dleftjwo15qyei.fsf%l.stelmach@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > On Tue, Aug 25, 2020 at 07:03:09PM +0200, Łukasz Stelmach wrote:
> >> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
> >
> > This is an odd filename. The ioctl code is wrong anyway, but there is
> > a lot more than ioctl in here. I suggest you give it a new name.
> >
> 
> Sure, any suggestions?

Sorry, i have forgotten what is actually contained. Does it even need
to be a separate file?

> >> +u8 ax88796c_check_power(struct ax88796c_device *ax_local)
> >
> > bool ?
> 
> OK.
> 
> It appears, however, that 0 means OK and 1 !OK. Do you think changing to
> TRUE and FALSE (or FALSE and TRUE) is required?

Or change the name, ax88796c_check_power_off()? I don't really care,
so long as it is logical and not surprising.

> >> +	AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
> >> +	if (!(ax_status.status & AX_STATUS_READY)) {
> >> +
> >> +		/* AX88796C in power saving mode */
> >> +		AX_WAKEUP(&ax_local->ax_spi);
> >> +
> >> +		/* Check status */
> >> +		start_time = jiffies;
> >> +		do {
> >> +			if (time_after(jiffies, start_time + HZ/2)) {
> >> +				netdev_err(ax_local->ndev,
> >> +					"timeout waiting for wakeup"
> >> +					" from power saving\n");
> >> +				break;
> >> +			}
> >> +
> >> +			AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
> >> +
> >> +		} while (!(ax_status.status & AX_STATUS_READY));
> >
> > include/linux/iopoll.h
> >
> 
> Done. The result seems only slightly more elegant since the generic
> read_poll_timeout() needs to be employed.

Often code like this has bugs in it, not correctly handling the
scheduler sleeping longer than expected. That is why i point people at
iopoll, no bugs, not elegance.

> The manufacturer says
> 
>     The AX88796C integrates on-chip Fast Ethernet MAC and PHY, […]
> 
> There is a single integrated PHY in this chip and no possiblity to
> connect external one. Do you think it makes sense in such case to
> introduce the additional layer of abstraction?

Yes it does, because it then uses all the standard phylib code to
drive the PHY which many people understand, is well tested, etc. It
will make the MAC driver smaller and probably less buggy.

> >> +static char *macaddr;
> >> +module_param(macaddr, charp, 0);
> >> +MODULE_PARM_DESC(macaddr, "MAC address");
> >
> > No Module parameters. You can get the MAC address from DT.
> 
> What about systems without DT? Not every bootloader is sophisicated
> enough to edit DT before starting kernel. AX88786C is a chip that can be
> used in a variety of systems and I'd like to avoid too strong
> assumptions.

There is also a standardised way to read it from ACPI. And you can set
it using ip link set. DaveM will likely NACK a module parameter.

> >> +MODULE_AUTHOR("ASIX");
> >
> > Do you expect ASIX to support this? 
> 
> No.
> 
> > You probably want to put your name here.
> 
> I don't want to be considered as the only author and as far as I can
> tell being mentioned as an author does not imply being a
> maintainer. Do you think two MODULE_AUTHOR()s be OK?

Can you have two? One with two names listed is O.K.

> >> +
> >> +	phy_status = AX_READ(&ax_local->ax_spi, P0_PSCR);
> >> +	if (phy_status & PSCR_PHYLINK) {
> >> +
> >> +		ax_local->w_state = ax_nop;
> >> +		time_to_chk = 0;
> >> +
> >> +	} else if (!(phy_status & PSCR_PHYCOFF)) {
> >> +		/* The ethernet cable has been plugged */
> >> +		if (ax_local->w_state == chk_cable) {
> >> +			if (netif_msg_timer(ax_local))
> >> +				netdev_info(ndev, "Cable connected\n");
> >> +
> >> +			ax_local->w_state = chk_link;
> >> +			ax_local->w_ticks = 0;
> >> +		} else {
> >> +			if (netif_msg_timer(ax_local))
> >> +				netdev_info(ndev, "Check media status\n");
> >> +
> >> +			if (++ax_local->w_ticks == AX88796C_WATCHDOG_RESTART) {
> >> +				if (netif_msg_timer(ax_local))
> >> +					netdev_info(ndev, "Restart autoneg\n");
> >> +				ax88796c_mdio_write(ndev,
> >> +					ax_local->mii.phy_id, MII_BMCR,
> >> +					(BMCR_SPEED100 | BMCR_ANENABLE |
> >> +					BMCR_ANRESTART));
> >> +
> >> +				if (netif_msg_hw(ax_local))
> >> +					ax88796c_dump_phy_regs(ax_local);
> >> +				ax_local->w_ticks = 0;
> >> +			}
> >> +		}
> >> +	} else {
> >> +		if (netif_msg_timer(ax_local))
> >> +			netdev_info(ndev, "Check cable status\n");
> >> +
> >> +		ax_local->w_state = chk_cable;
> >> +	}
> >> +
> >> +	ax88796c_set_power_saving(ax_local, ax_local->ps_level);
> >> +
> >> +	if (time_to_chk)
> >> +		mod_timer(&ax_local->watchdog, jiffies + time_to_chk);
> >> +}
> >
> > This is not the normal use of a watchdog in network drivers. The
> > normal case is the network stack as asked the driver to do something,
> > normally a TX, and the driver has not reported the action has
> > completed.  The state of the cable should not make any
> > difference. This does not actually appear to do anything useful, like
> > kick the hardware to bring it back to life.
> >
> 
> Maybe it's the naming that is a problem. Yes, it is not a watchdog, but
> rather a periodic housekeeping and it kicks hw if it can't negotiate
> the connection. The question is: should the settings be reset in such case.

Let see what is left once you convert to phylib.

> >> +	struct net_device *ndev = ax_local->ndev;
> >> +	int status;
> >> +
> >> +	do {
> >> +		if (!(ax_local->checksum & AX_RX_CHECKSUM))
> >> +			break;
> >> +
> >> +		/* checksum error bit is set */
> >> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
> >> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
> >> +			break;
> >> +
> >> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
> >> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP)) {
> >> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
> >> +		}
> >> +	} while (0);
> >
> >
> > ??
> >
> 
> if() break; Should I use goto?

Sorry, i was too ambiguous. Why:

do {
} while (0);

It is an odd construct.

   Andrew
