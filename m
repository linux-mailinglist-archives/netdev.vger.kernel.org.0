Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0150A35E1AD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbhDMOg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:36:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48464 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhDMOg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:36:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWK9c-00GU8B-0B; Tue, 13 Apr 2021 16:36:36 +0200
Date:   Tue, 13 Apr 2021 16:36:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Subject: Re: [PATCH net-next 1/5] net: phy: marvell: refactor HWMON OOP style
Message-ID: <YHWsc3H8RzmdfvuR@lunn.ch>
References: <20210413075538.30175-1-kabel@kernel.org>
 <20210413075538.30175-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413075538.30175-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int marvell_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> +			      u32 attr, int channel, long *temp)
>  {
>  	struct phy_device *phydev = dev_get_drvdata(dev);
> -	int err;
> +	const struct marvell_hwmon_ops *ops = to_marvell_hwmon_ops(phydev);
> +	int err = -EOPNOTSUPP;
>  
>  	switch (attr) {
>  	case hwmon_temp_input:
> -		err = m88e6390_get_temp(phydev, temp);
> +		if (ops->get_temp)
> +			err = ops->get_temp(phydev, temp);
> +		break;
> +	case hwmon_temp_crit:
> +		if (ops->get_temp_critical)
> +			err = ops->get_temp_critical(phydev, temp);
> +		break;
> +	case hwmon_temp_max_alarm:
> +		if (ops->get_temp_alarm)
> +			err = ops->get_temp_alarm(phydev, temp);
>  		break;
>  	default:
> -		return -EOPNOTSUPP;
> +		fallthrough;
> +	}

Does the default clause actually service any purpose?

And it is not falling through, it is falling out :-)

    Andrew
