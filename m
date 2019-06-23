Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904B84FC7F
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfFWPoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:44:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfFWPoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 11:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lUr3STG48bq2/oGCHEk8tfKF2iOd/RO7CFOc41KQBYk=; b=RtEKWmPEpwKzKzbGUwTgDhwMh8
        mE8kEZje6Tp0fgLWECH1R/YwDLijOLXnGtd4akGPV5iIBMYNEVwLZjs56vge5+VK+EFSDXJc47dQR
        jwiakgQ3X3ka7ECyeOp7FMXjj9RV2apMwHx7+TYxxyb4zlQsHkeUbRkJTrY9y5+xDHZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hf4f1-0008Mf-UM; Sun, 23 Jun 2019 17:44:07 +0200
Date:   Sun, 23 Jun 2019 17:44:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Vadim Pasternak <vadimp@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] mlxsw: core: Add support for negative
 temperature readout
Message-ID: <20190623154407.GE28942@lunn.ch>
References: <20190623125645.2663-1-idosch@idosch.org>
 <20190623125645.2663-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623125645.2663-4-idosch@idosch.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
> @@ -52,8 +52,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
>  			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
>  	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
>  	char mtmp_pl[MLXSW_REG_MTMP_LEN];
> -	unsigned int temp;
> -	int index;
> +	int temp, index;
>  	int err;
>  
>  	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
> @@ -65,7 +64,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
>  		return err;
>  	}
>  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
> -	return sprintf(buf, "%u\n", temp);
> +	return sprintf(buf, "%d\n", temp);
>  }

If you had used the hwmon core, rather than implementing it yourself,
you could of avoided this part of the bug.

>  static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
> @@ -215,8 +213,8 @@ static ssize_t mlxsw_hwmon_module_temp_show(struct device *dev,
>  			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
>  	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
>  	char mtmp_pl[MLXSW_REG_MTMP_LEN];
> -	unsigned int temp;
>  	u8 module;
> +	int temp;
>  	int err;
>  
>  	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;

I think you missed changing the %u to %d in this function.

> @@ -519,14 +519,14 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
>  		return 0;
>  	}
>  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
> -	*p_temp = (int) temp;
> +	*p_temp = temp;
>  
>  	if (!temp)
>  		return 0;
>  
>  	/* Update trip points. */
>  	err = mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
> -	if (!err)
> +	if (!err && temp > 0)
>  		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips, temp);

Why the > 0?

    Andrew
