Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7832853A2
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgJFVJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgJFVJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:09:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE63C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 14:09:08 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b26so65146pff.3
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 14:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5M7hUEDshIFirfAPYm0WKdrK7If631/5774AkoWqUzk=;
        b=vhW5hhXkhuyvZrIKkEAeB6VGl2jNbpT73TdTpzv7Blp57GYT6xuBcTDRT0cf58lgdj
         cQPROwfOa7PyTZ1avku1IRIQQgdgB4KaF8EZtl4eBBcb7IZiyiQZBDxMM6v/+OYgwskf
         OQ/AltZ9F/SO4pjSZW+loOlePq97ptgpNTykrVlxN68ui2aVruFHrDg0UI0a1U3/z9Ed
         akgBv4WWdu5bItPtpgaiUlWwqWOizCzdptQn4wbNTUjMSVKAIZLX3gasXDJUfxng/EAZ
         fJfMOrltMwu1pg8xWZtZFHRWKxVm7lJgDDoVa9XiI2jldboYmFqP6h/SpGWsw9tvLw57
         SwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5M7hUEDshIFirfAPYm0WKdrK7If631/5774AkoWqUzk=;
        b=Yl1/+pqhnXumojpZe7hOScOs4iWrHBpjzyvvR3gOsmA383kFNGeMtjNES/soFADQPE
         9yfEg6GOdZsALas+9dbC09Q4qXfYgfVKv0poR+HyAwOwBnBSanKTK+BCaAqQmfmj/ow8
         AeVrAZI4SLpCHTQ+zIROGKWdwvMaW4nOxXnMPr/e/e7fg+U+WwPH2RkHNNWeBMe5R2yH
         /W6EP0B/PzqqSUZDYpdN3Xc2LOB+tvQkevnniiA25BMeR91F9w+XuNXbQG9I03oZAeAh
         qfwKEK2hrrrbpEiAFLgCvali2q2cPQ46uv/DIMDm9IMScRFhh3cZbFG69QZ7esCo+dOn
         UslA==
X-Gm-Message-State: AOAM533vuNmL1XgiWOjiNkCe4rGabbiMAH+vrhgxtzMimhfSQAecK0BL
        R/AqjEwP4Pu6/qQW+lh62hE=
X-Google-Smtp-Source: ABdhPJz1Tm5d47xbigVn4KWFSu9km6GK4AiYcWVuVEVmrNiWFrlU55CR0I5xPPOXOksBwYunPJeP5g==
X-Received: by 2002:aa7:918b:0:b029:152:1b08:e119 with SMTP id x11-20020aa7918b0000b02901521b08e119mr6139659pfa.2.1602018547720;
        Tue, 06 Oct 2020 14:09:07 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y8sm95314pfg.104.2020.10.06.14.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 14:09:06 -0700 (PDT)
Subject: Re: [PATCH] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable()
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
References: <20201006202029.254212-1-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <110b63bb-9096-7ce0-530f-45dffed09077@gmail.com>
Date:   Tue, 6 Oct 2020 14:09:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006202029.254212-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/6/2020 1:20 PM, Marek Vasut wrote:
> The phy_reset_after_clk_enable() is always called with ndev->phydev,
> however that pointer may be NULL even though the PHY device instance
> already exists and is sufficient to perform the PHY reset.
> 
> If the PHY still is not bound to the MAC, but there is OF PHY node
> and a matching PHY device instance already, use the OF PHY node to
> obtain the PHY device instance, and then use that PHY device instance
> when triggering the PHY reset.
> 
> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Richard Leitner <richard.leitner@skidata.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> ---
>   drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++++--
>   1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 2d5433301843..5a4b20941aeb 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1912,6 +1912,24 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>   	return ret;
>   }
>   
> +static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
> +{
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	struct phy_device *phy_dev = ndev->phydev;
> +
> +	/*
> +	 * If the PHY still is not bound to the MAC, but there is
> +	 * OF PHY node and a matching PHY device instance already,
> +	 * use the OF PHY node to obtain the PHY device instance,
> +	 * and then use that PHY device instance when triggering
> +	 * the PHY reset.
> +	 */
> +	if (!phy_dev && fep->phy_node)
> +		phy_dev = of_phy_find_device(fep->phy_node);

Don't you need to put the phy_dev reference at some point?
-- 
Florian
