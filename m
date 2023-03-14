Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42946B96E1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjCNNyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjCNNxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:53:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D77AFBA2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bT4k9qsG6+FCIYpUk0NWmZqk6hZPvzSVggqHGxbRIFw=; b=waK5M153mlcCob4e1tZxpzb6is
        bcUCEFimiCuMXgoKwMzOYYpRcYGxc+ePHXf4UhFCrZPOXZYzBHkybgP9jphInfSbjEd49ZK8pSttW
        hgq0jP2N2HdsMyLOYzZLwEgh7BdvYz5uDbfBacZFZD1HwaP6Cha3VaEoLnmfjQZ9squc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pc53J-007ICE-K5; Tue, 14 Mar 2023 14:50:57 +0100
Date:   Tue, 14 Mar 2023 14:50:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, rtanwar@maxlinear.com,
        mohammad.athari.ismail@intel.com, edumazet@google.com,
        michael@walle.cc, pabeni@redhat.com
Subject: Re: [PATCH net-next v4] net: phy: mxl-gpy: enhance delay time
 required by loopback disable function
Message-ID: <67a3a8f3-5bee-4379-890a-6c8e8be391a8@lunn.ch>
References: <20230314093648.44510-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314093648.44510-1-lxu@maxlinear.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* It takes 3 seconds to fully switch out of loopback mode before
> +	 * it can safely re-enter loopback mode. Record the time when
> +	 * loopback is disabled. Check and wait if necessary before loopback
> +	 * is enabled.
> +	 */

Is there are restriction about entering loopback mode within the first
3 seconds after power on? 

> +	bool lb_dis_chk;
> +	u64 lb_dis_to;
>  };
>  
>  static const struct {
> @@ -769,18 +777,34 @@ static void gpy_get_wol(struct phy_device *phydev,
>  
>  static int gpy_loopback(struct phy_device *phydev, bool enable)
>  {
> +	struct gpy_priv *priv = phydev->priv;
> +	u16 set = 0;
>  	int ret;
>  
> -	ret = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> -			 enable ? BMCR_LOOPBACK : 0);
> -	if (!ret) {
> -		/* It takes some time for PHY device to switch
> -		 * into/out-of loopback mode.
> +	if (enable) {
> +		/* wait until 3 seconds from last disable */
> +		if (priv->lb_dis_chk && time_is_after_jiffies64(priv->lb_dis_to))
> +			msleep(jiffies64_to_msecs(priv->lb_dis_to - get_jiffies_64()));
> +
> +		priv->lb_dis_chk = false;
> +		set = BMCR_LOOPBACK;

Maybe this can be simplified by setting priv->lb_dis_to =
get_jiffies_64() + HZ * 3 in _probe(). Then you don't need
priv->lb_dis_chk.

	Andrew
