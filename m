Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352625AD374
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbiIENKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiIENKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:10:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4E52A407;
        Mon,  5 Sep 2022 06:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Fu50DvQD64GcZaasoWlVcAjCefH4D1LrLOwtDyAez/Q=; b=L9SQIGhN/rKJL5y6F081T+FRFR
        tZFGtzmZljoSdBOdBzE4VTSijswAbrPUc+kjQVHVEZeNLxikRVEopFCItZodCN5mpIPMpVo4X+QCo
        aduSyOC6hUyn+4/11jqDrRPeLLZ1mGX7mSsGXUxRfHSRqYhdS/wOfP0ox8pN60jEfURg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVBrP-00FeJC-6I; Mon, 05 Sep 2022 15:09:55 +0200
Date:   Mon, 5 Sep 2022 15:09:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <YxX1I6wBFjzID2Ls@lunn.ch>
References: <20220905101730.29951-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905101730.29951-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 03:47:30PM +0530, Divya Koppera wrote:
> Supports SQI(Signal Quality Index) for lan8814 phy, where
> it has SQI index of 0-7 values and this indicator can be used
> for cable integrity diagnostic and investigating other noise
> sources. It is not supported for 10Mbps speed
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
> v1 -> v2
> - Given SQI support for all pairs of wires in 1000/100 base-T phy's
>   uAPI may run through all instances in future. At present returning
>   only first instance as uAPI supports for only 1 pair.
> - SQI is not supported for 10Mbps speed, handled accordingly.

I would prefer you solve the problem of returning all pairs.

I'm not sure how useful the current implementation is, especially at
100Mbps, where pair 0 could actually be the transmit pair. Does it
give a sensible value in that case?

> +static int lan8814_get_sqi(struct phy_device *phydev)
> +{
> +	int ret, val, pair;
> +	int sqi_val[4];
> +
> +	if (phydev->speed == SPEED_10)
> +		return -EOPNOTSUPP;
> +
> +	for (pair = 0; pair < 4; pair++) {
> +		val = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
> +		if (val < 0)
> +			return val;
> +
> +		val &= ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
> +		val |= pair;
> +		val |= LAN8814_DCQ_CTRL_READ_CAPTURE_;
> +		ret = lanphy_write_page_reg(phydev, 1, LAN8814_DCQ_CTRL, val);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_SQI);
> +		if (ret < 0)
> +			return ret;
> +
> +		sqi_val[pair] = FIELD_GET(LAN8814_DCQ_SQI_VAL_MASK, ret);
> +	}
> +
> +	return *sqi_val;

How is this going to work in the future? sqi_val is on the stack. You
cannot return a pointer to it. So this function is going to need
modifications.

If you really want to prepare for a future implementation which could
return all four, i would probably make this a helper which takes a
pair number. And then have a function call it once for pair 0.

     Andrew
