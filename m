Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351235A1BB7
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbiHYVx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244030AbiHYVx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:53:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302182D1E2;
        Thu, 25 Aug 2022 14:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1cpnv7cRnMZ16t80+IgphUDcNNToBRnfujnI1hjI/5c=; b=483chnirogxayPXYL2kwLuxOa1
        mma4b+CW/hU5CXhabflX2kDXsg61q7VuC5K3h7AxEYEiuBxhI1DOJ9bC+9MiPK4ZK+x7ALGJLinoS
        e/mcSYS8DmuL9csHUhg1JI+GEZ3kEcp0sNHWnLxy58JeXaebuDsT7IFDCF0IEjxgG6y4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRKnJ-00Ebxa-Ds; Thu, 25 Aug 2022 23:53:45 +0200
Date:   Thu, 25 Aug 2022 23:53:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <YwfvaSFejdtPtZgK@lunn.ch>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825080549.9444-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define LAN8814_DCQ_CTRL				0xe6
> +#define LAN8814_DCQ_CTRL_READ_CAPTURE_			BIT(15)
> +#define LAN8814_DCQ_CTRL_CHANNEL_MASK			GENMASK(1, 0)
> +#define LAN8814_DCQ_SQI					0xe4
> +#define LAN8814_DCQ_SQI_MAX				7
> +#define LAN8814_DCQ_SQI_VAL_MASK			GENMASK(3, 1)
> +
>  static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
>  {
>  	int data;
> @@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int lan8814_get_sqi(struct phy_device *phydev)
> +{
> +	int rc, val;
> +
> +	val = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
> +	if (val < 0)
> +		return val;

I just took a quick look at the datasheet. It says:

All registers references in this section are in MMD Device Address 1

So you should be using phy_read_mmd(phydev, MDIO_MMD_PMAPMD, xxx) to
read/write these registers. The datasheet i have however is missing
the register map, so i've no idea if it is still 0xe6.

    Andrew
