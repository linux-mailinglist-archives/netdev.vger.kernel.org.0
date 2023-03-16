Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3822B6BC57B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCPFIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjCPFIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:08:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C0266D14;
        Wed, 15 Mar 2023 22:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D413B81FAC;
        Thu, 16 Mar 2023 05:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AE5C433D2;
        Thu, 16 Mar 2023 05:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678943304;
        bh=5REtABbWHSQNbyY5JkFvJgrHIprf9ak3E6xCfCWBdXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZK7E7TzhOx4iMvpImcY0G0umrXMy/C3mxSOd9LFPdEZPhn+nWedtBr6P42+Z0aDis
         RccE6VXWFQKNNkFKxHAp0oS61LiIUwKIcKVAx+Gx/2DLKpedZaTQS7dwXn2Wydz9yi
         REGlvluijYRy4gxY+uPue/XBk4qogYGTZYyfcy5IMSw6jfnagGNIuudn/klLsj4WXw
         eyCX8rSRuq7UdAip3+SmqQpUNXCPz2XLjwecAUgL8rypQfk/aPpo6y4d6161tjcGRi
         GTtz5fNuxl7u5PV8jtgstu1rGK//7Hl9TtoZ0mR3N7aT6MDxedtOgr024f5s9qpDPT
         cP4kBqMhi17EA==
Date:   Wed, 15 Mar 2023 22:08:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Lundin <glance@acc.umu.se>
Subject: Re: [PATCHv4 net] net: asix: fix modprobe "sysfs: cannot create
 duplicate filename"
Message-ID: <20230315220822.6d8cf7ed@kernel.org>
In-Reply-To: <20230314055410.3329480-1-grundler@chromium.org>
References: <20230314055410.3329480-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 22:54:10 -0700 Grant Grundler wrote:
> @@ -690,6 +704,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
>  	if (!priv->phydev) {
>  		netdev_err(dev->net, "Could not find PHY\n");
> +		ax88772_mdio_unregister(priv);

this line needs to go now..

>  		return -ENODEV;

.. since if we return error here ..

>  	}
>  
> @@ -896,16 +911,23 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>  
>  	ret = ax88772_init_mdio(dev);
>  	if (ret)
> -		return ret;
> +		goto mdio_err;
>  
>  	ret = ax88772_phylink_setup(dev);
>  	if (ret)
> -		return ret;
> +		goto phylink_err;
>  
>  	ret = ax88772_init_phy(dev);

.. it will pop out here ..

>  	if (ret)
> -		phylink_destroy(priv->phylink);
> +		goto initphy_err;
>  
> +	return 0;
> +
> +initphy_err:
> +	phylink_destroy(priv->phylink);
> +phylink_err:
> +	ax88772_mdio_unregister(priv);

.. and then call ax88772_mdio_unregister() a second time.

> +mdio_err:
>  	return ret;
>  }
