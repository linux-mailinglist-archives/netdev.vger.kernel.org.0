Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C506C27D44A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgI2RSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:18:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2RSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:18:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNJGZ-00GmUT-Oe; Tue, 29 Sep 2020 19:18:15 +0200
Date:   Tue, 29 Sep 2020 19:18:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 3/3] net: atlantic: implement media detect
 feature via phy tunables
Message-ID: <20200929171815.GD3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929161307.542-4-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929161307.542-4-irusskikh@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -923,6 +923,12 @@ static int aq_ethtool_get_phy_tunable(struct net_device *ndev,
>  	struct aq_nic_s *aq_nic = netdev_priv(ndev);
>  
>  	switch (tuna->id) {
> +	case ETHTOOL_PHY_EDPD: {
> +		u16 *val = data;
> +
> +		*val = (u16)aq_nic->aq_nic_cfg.is_media_detect;
> +		break;
> +	}
>  	case ETHTOOL_PHY_DOWNSHIFT: {
>  		u8 *val = data;
>  
> @@ -943,6 +949,14 @@ static int aq_ethtool_set_phy_tunable(struct net_device *ndev,
>  	struct aq_nic_s *aq_nic = netdev_priv(ndev);
>  
>  	switch (tuna->id) {
> +	case ETHTOOL_PHY_EDPD: {
> +		const u16 *val = data;
> +
> +		/* msecs plays no role - configuration is always fixed in PHY */
> +		aq_nic->aq_nic_cfg.is_media_detect = *val ? 1 : 0;

This is the wrong usage of the API:

include/uapi/linux/ethtool.h:

* The interval units for TX wake-up are in milliseconds, since this should
 * cover a reasonable range of intervals:
 *  - from 1 millisecond, which does not sound like much of a power-saver
 *  - to ~65 seconds which is quite a lot to wait for a link to come up when
 *    plugging a cable
 */

I guess your PHY is not hard coded to 1 millisecond? Please return the
real value. And the set call should really only allow 0, or the value
the PHY is using.

    Andrew
