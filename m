Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655AE63974C
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiKZQwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiKZQwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:52:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240C417E0A;
        Sat, 26 Nov 2022 08:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=afYyqnESstPYF0qp8DiQpmjfKKmBgKX2qGLEWL9vw/8=; b=zdEytqfZTLJ4ycL/DZABrwe23e
        8z8uxB8pggswChhbz47AJg1vixjvQx0Ct54WwSzEu0ZOScALhrW8NxvIqNj5YX5a6qjMK6OUjDJek
        yjPByU76BjsfMgUxKBfnhry6aOrICOswz8qO/bdNxTk+XMESHimui67GhSA4dOuauW0g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oyyOv-003WSK-I0; Sat, 26 Nov 2022 17:51:37 +0100
Date:   Sat, 26 Nov 2022 17:51:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
Message-ID: <Y4JEGYMtIWX9clxo@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -2196,11 +2198,12 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
>  		ops = &es581_4_ops;
>  	}
>  
> -	es58x_dev = devm_kzalloc(dev, es58x_sizeof_es58x_device(param),
> -				 GFP_KERNEL);
> -	if (!es58x_dev)
> +	devlink = devlink_alloc(&es58x_dl_ops, es58x_sizeof_es58x_device(param),
> +				dev);
> +	if (!devlink)
>  		return ERR_PTR(-ENOMEM);
>  
> +	es58x_dev = devlink_priv(devlink);

That is 'interesting'. Makes me wonder about lifetimes of different
objects. Previously your es58x_dev structure would disappear when the
driver is released, or an explicit call to devm_kfree(). Now it
disappears when devlink_free() is called. Any danger of use after free
here?

USB devices always make me wonder about life times rules since they
are probably the mode dynamic sort of device the kernel has the
handle, them just abruptly disappearing.

>  	es58x_dev->param = param;
>  	es58x_dev->ops = ops;
>  	es58x_dev->dev = dev;
> @@ -2247,6 +2250,8 @@ static int es58x_probe(struct usb_interface *intf,
>  	if (ret)
>  		return ret;
>  
> +	devlink_register(priv_to_devlink(es58x_dev));
> +
>  	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
>  		ret = es58x_init_netdev(es58x_dev, ch_idx);
>  		if (ret) {
> @@ -2272,8 +2277,10 @@ static void es58x_disconnect(struct usb_interface *intf)
>  	dev_info(&intf->dev, "Disconnecting %s %s\n",
>  		 es58x_dev->udev->manufacturer, es58x_dev->udev->product);
>  
> +	devlink_unregister(priv_to_devlink(es58x_dev));
>  	es58x_free_netdevs(es58x_dev);
>  	es58x_free_urbs(es58x_dev);
> +	devlink_free(priv_to_devlink(es58x_dev));
>  	usb_set_intfdata(intf, NULL);

Should devlink_free() be after usb_set_inftdata()?

       Andrew
