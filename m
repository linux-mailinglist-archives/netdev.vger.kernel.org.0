Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FDA58F53D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 02:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiHKAan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 20:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKAam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 20:30:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5382466A70;
        Wed, 10 Aug 2022 17:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cVnlVnJwObO86ULdSvAwM695LLQEVtnRb++QK0jLVRA=; b=vt0L8vjYEJ9MWh3HBefr68tO81
        BEfNLfx963mhY0aqpHZnD9Bhl/KkdiiTMmf5tWA06mHQln6FyGgcg1ROqXVZO2J1VtesjykJIDU9j
        UNfZd4ya/x74mPo8i1zAHZUypQoVnwGqtQ+9HDm+jlD08etlCYI4CkQgWRE8txurb+ec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLw5k-00CyZr-5a; Thu, 11 Aug 2022 02:30:28 +0200
Date:   Thu, 11 Aug 2022 02:30:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kishon@ti.com,
        vigneshr@ti.com
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: davinci_mdio: Add
 workaround for errata i2329
Message-ID: <YvRNpAdG7/edUEc+@lunn.ch>
References: <20220810111345.31200-1-r-gunasekaran@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810111345.31200-1-r-gunasekaran@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int davinci_mdiobb_read(struct mii_bus *bus, int phy, int reg)
> +{
> +	int ret;
> +	struct mdiobb_ctrl *ctrl = bus->priv;
> +	struct davinci_mdio_data *data;
> +
> +	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
> +
> +	if (phy & ~PHY_REG_MASK || reg & ~PHY_ID_MASK)
> +		return -EINVAL;

You don't need this. Leave it up to the bit banging code to do the
validation. This also breaks C45, which the bit banging code can do,
and it looks like the hardware cannot.

> +
> +	ret = pm_runtime_resume_and_get(data->dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = mdiobb_read(bus, phy, reg);
> +
> +	pm_runtime_mark_last_busy(data->dev);
> +	pm_runtime_put_autosuspend(data->dev);

Once you take the validation out, this function then all becomes about
runtime power management. Should the bit banging core actually be
doing this? It seems like it is something which could be useful for
other devices.

struct mii_bus has a parent member. If set, you could apply these run
time PM functions to that. Please add a patch to modify the core bit
banging code, and then you should be able to remove these helpers.

>  static int davinci_mdio_probe(struct platform_device *pdev)
>  {
>  	struct mdio_platform_data *pdata = dev_get_platdata(&pdev->dev);
> @@ -340,12 +535,30 @@ static int davinci_mdio_probe(struct platform_device *pdev)
>  	struct phy_device *phy;
>  	int ret, addr;
>  	int autosuspend_delay_ms = -1;
> +	const struct soc_device_attribute *soc_match_data;

netdev uses reverse christmas tree. Variables should be sorted longest
first, shortest last.

       Andrew
