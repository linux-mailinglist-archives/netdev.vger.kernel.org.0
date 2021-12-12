Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A08B4717D4
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 03:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhLLCXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 21:23:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232495AbhLLCXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 21:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5yrMToKMdkkVY4CQzgz+QrmftWNp5HW8nmVmkKpF9O0=; b=I//tJ1t3tCSfFCDcZY3VLsjTd3
        kn9imk9KAK8crIJBLwKd21QkmHstp4Qz2IsIaOFemRYdgLTzlPjud6e+5rlz4QSCnf6xZM8u5IEuv
        5H/IIYBgixE+fZ6O3jPHRljm1mdZSIATbOutx/WL44IPY1LfYjtzg3njWS0a3NZqbmBo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mwEWZ-00GISJ-F1; Sun, 12 Dec 2021 03:23:39 +0100
Date:   Sun, 12 Dec 2021 03:23:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     JosephCHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3, 2/2] net: Add dm9051 driver
Message-ID: <YbVdK69SB0Ebt8C9@lunn.ch>
References: <20211210084021.13993-1-josright123@gmail.com>
 <20211210084021.13993-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210084021.13993-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* netdev_ops
> + */
> +static int dm9051_open(struct net_device *dev);
> +static int dm9051_stop(struct net_device *dev);
> +static netdev_tx_t dm9051_start_xmit(struct sk_buff *skb, struct net_device *dev);
> +static void dm9051_set_multicast_list_schedule(struct net_device *dev);
> +static int dm9051_set_mac_address(struct net_device *dev, void *p);

You should not need these. Move the code around so the functions come
before there first use.

> +/* carrier
> + */
> +#define	dm_carrier_init(db)			mii_check_link(&(db)->mii)
> +#define	dm_carrier_poll(db)			mii_check_link(&(db)->mii)

I requested you make use of phylib. Once you do, these will go away.

> +#define	dm_carrier_off(dev)			netif_carrier_off(dev)

No wrappers around standard functions. Also, once you use phylib, it
will take care of the carrier for you.

> +
> +/* xmit support
> + */
> +#define	dm_sk_buff_head_init(db)		skb_queue_head_init(&(db)->txq)
> +#define	dm_sk_buff_get(db)			skb_dequeue(&(db)->txq)
> +#define	dm_sk_buff_set(db, skb)			skb_queue_tail(&(db)->txq, skb)

These wrappers should also be removed.

> +/* spi transfers
> + */
> +#define ior					std_spi_read_reg			// read reg
> +#define iior					disp_spi_read_reg			// read disp
> +#define iow					std_spi_write_reg			// write reg
> +#define dm9inblk				std_read_rx_buf_ncpy			// read buff
> +#define dm9outblk				std_write_tx_buf			// write buf
> +
> +#define	ncr_reg_reset(db)			iow(db, DM9051_NCR, NCR_RST)		// reset
> +#define	mbd_reg_byte(db)			iow(db, DM9051_MBNDRY, MBNDRY_BYTE)	// MemBound
> +#define	fcr_reg_enable(db)			iow(db, DM9051_FCR, FCR_FLOW_ENABLE)	// FlowCtrl
> +#define	ppcr_reg_seeting(db)			iow(db, DM9051_PPCR, PPCR_PAUSE_COUNT)	// PauPktCn
> +#define	isr_reg_clear_to_stop_mrcmd(db)		iow(db, DM9051_ISR, 0xff)		// ClearISR
> +#define rcr_reg_stop(db)			iow(db, DM9051_RCR, RCR_RX_DISABLE)	// DisabRX
> +#define imr_reg_stop(db)			iow(db, DM9051_IMR, IMR_PAR)		// DisabAll
> +#define rcr_reg_start(db, rcr_all)		iow(db, DM9051_RCR, rcr_all)		// EnabRX
> +#define imr_reg_start(db, imr_all)		iow(db, DM9051_IMR, imr_all)		// Re-enab
> +#define	intcr_reg_setval(db)			iow(db, DM9051_INTCR, INTCR_POL_LOW)	// INTCR
> +#define	ledcr_reg_setting(db, lcr_all)		iow(db, DM9051_LMCR, lcr_all)		// LEDMode1

Please remove all these wrapper.

       Andrew
