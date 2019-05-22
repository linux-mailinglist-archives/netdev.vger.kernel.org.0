Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE325B6A
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 02:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfEVA63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 20:58:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42645 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfEVA63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 20:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uH7z7SdNeyDoUf5r859hF8EPzjC5LH/pj2/RE9xsuW4=; b=rsV8Zr0cStPXks7/iFjwDPyLzm
        9c9e9ctybxet2iqxwcYEfRbQnTOk7XWtymsH7PKGSjgAH/32jZh5ypkzbrxea4viukvSU6OlXGq3b
        LbdbN5aGkvT5yX5X83iSOHv3/1gV+C+buzRYJtWNz/giaXlqqD3whL+mKvK+tEhduprk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTFaJ-0008Qv-Jx; Wed, 22 May 2019 02:58:23 +0200
Date:   Wed, 22 May 2019 02:58:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 2/6] net: Introduce a new MII time stamping
 interface.
Message-ID: <20190522005823.GD6577@lunn.ch>
References: <20190521224723.6116-3-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521224723.6116-3-richardcochran@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
> +static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
>  {
> -	struct dp83640_private *dp83640 = phydev->priv;
> +	struct dp83640_private *dp83640 =
> +		container_of(mii_ts, struct dp83640_private, mii_ts);
>  	struct hwtstamp_config cfg;
>  	u16 txcfg0, rxcfg0;

Hi Richard

David might complain about reverse christmas tree. Maybe define a
macro, to_dp83640() which takes mii_ts?

> +/**
> + * struct mii_timestamper - Callback interface to MII time stamping devices.
> + *
> + * @rxtstamp:	Requests a Rx timestamp for 'skb'.  If the skb is accepted,
> + *		the MII time stamping device promises to deliver it using
> + *		netif_rx() as soon as a timestamp becomes available. One of
> + *		the PTP_CLASS_ values is passed in 'type'.  The function
> + *		must return true if the skb is accepted for delivery.
> + *
> + * @txtstamp:	Requests a Tx timestamp for 'skb'.  The MII time stamping
> + *		device promises to deliver it using skb_complete_tx_timestamp()
> + *		as soon as a timestamp becomes available. One of the PTP_CLASS_
> + *		values is passed in 'type'.
> + *
> + * @hwtstamp:	Handles SIOCSHWTSTAMP ioctl for hardware time stamping.
> + * @link_state:	Allows the device to respond to changes in the link state.
> + * @ts_info:	Handles ethtool queries for hardware time stamping.
> + *
> + * Drivers for PHY time stamping devices should embed their
> + * mii_timestamper within a private structure, obtaining a reference
> + * to it using container_of().
> + */

I wonder if it is worth mentioning that link_state() is called with
the phy lock held, but none of the others are?

Otherwise this looks good.

	  Andrew
