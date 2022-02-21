Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5BE4BE0E9
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358420AbiBUM6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:58:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiBUM6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:58:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEBF1EAD4;
        Mon, 21 Feb 2022 04:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ml2gqauoTFG3Smq6lcK3ePS4/koYLjxr1U+WiMKY3+Q=; b=ya3MgtNtZC7scN7QPF0NlWuMzE
        wcAkZ9rzRI+5L2HcZ+n6cz1hTvP7m1DiLcHktw1rZ/AH2Wat58o4b3Y8W5iTvm24KjKsVcbHJyaqP
        hQ4Te6cyjVjdv/tq+kuVIuL7tSRzOLyJukSn81B2XXBXhGBYx9Z8v0KJltr6M4Y0EscA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nM7hN-007JrM-Dr; Mon, 21 Feb 2022 13:21:49 +0100
Date:   Mon, 21 Feb 2022 13:21:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mauri Sandberg <maukka@ext.kapsi.fi>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: mv643xx_eth: handle EPROBE_DEFER
Message-ID: <YhOD3eCm8mYHJ1HF@lunn.ch>
References: <20220221062441.2685-1-maukka@ext.kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221062441.2685-1-maukka@ext.kapsi.fi>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 08:24:41AM +0200, Mauri Sandberg wrote:
> Obtaining MAC address may be deferred in cases when the MAC is stored
> in NVMEM block and it may now be ready upon the first retrieval attempt
> returing EPROBE_DEFER. Handle it here and leave logic otherwise as it
> was.
> 
> Signed-off-by: Mauri Sandberg <maukka@ext.kapsi.fi>
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 105247582684..0694f53981f2 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -2740,7 +2740,10 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
>  		return -EINVAL;
>  	}
>  
> -	of_get_mac_address(pnp, ppd.mac_addr);
> +	ret = of_get_mac_address(pnp, ppd.mac_addr);
> +
> +	if (ret == -EPROBE_DEFER)
> +		return ret;

Hi Mauri

There appears to be a follow on issue. There can be multiple ports. So
it could be the first port does not use a MAC address from the NVMEM,
but the second one does. The first time in
mv643xx_eth_shared_of_add_port() is successful and a platform device
is added. The second port can then fail with -EPROBE_DEFER. That
causes the probe to fail, but the platform device will not be
removed. The next time the driver is probed, it will add a second
platform device for the first port, causing bad things to happen.

Please can you add code to remove the platform device when the probe
fails.

	Andrew
