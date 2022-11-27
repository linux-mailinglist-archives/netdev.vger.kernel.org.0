Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A190363995B
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 06:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiK0FKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 00:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiK0FKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 00:10:45 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C9613F6F;
        Sat, 26 Nov 2022 21:10:44 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id a9so4092121pfr.0;
        Sat, 26 Nov 2022 21:10:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jX4FlIDKRZ6HtC7tR+0qLxHARsOw0Qkz+IpKaPjHkjU=;
        b=mNalp5d0XlgnowPUC0RWR8s3zax7wmDc3l9ttGYSVLZbbh7f1px7/vU4mY9XlWwx0t
         l6QkvMnEL+/X1btFNvQCztsXWE5pCWQrA79frkG7qUO0nOFIbU2ybCkcCGmgMkXpnUDo
         P/CKdre7nA0CS16+ESFGlqKSctZ3C3DyOTrnyht7j8fB8Q4gapjyEmFPSVV/1YvGEBP9
         cz55DOQtSHOIriVhXQrsQxrHNpoab/1nIeTSKCeEQtAq6zfCongG+DF8+LcMkrQET1FU
         STAWD7K4y9BJI3egnoRuxmZvH/5uW9keq55FPRwZFGmUKhrgUO78QCymqhVrVi67C/ZL
         XUeA==
X-Gm-Message-State: ANoB5pniHarzF5ogHzG7HV6SyOpj8EMgyYw3RHA+nsB7DHT7pCjzNnsv
        2vbRGMq8CKtKRuAAETCLYatXd1X4xkJAvdSewLp+gFJ66R9PuA==
X-Google-Smtp-Source: AA0mqf5KnMk1Qz/tCRijWthIIOCkvgh2jkfVvEXCtwLeke3lQqeSJPhiqSzMfqsRQPHHkUJbdcbVdv4tRT8lvEocB+Q=
X-Received: by 2002:a05:6a00:194a:b0:56b:a795:e99c with SMTP id
 s10-20020a056a00194a00b0056ba795e99cmr35289001pfk.14.1669525843741; Sat, 26
 Nov 2022 21:10:43 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
 <Y4JEGYMtIWX9clxo@lunn.ch>
In-Reply-To: <Y4JEGYMtIWX9clxo@lunn.ch>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 27 Nov 2022 14:10:32 +0900
Message-ID: <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 27 Nov. 2022 at 01:51, Andrew Lunn <andrew@lunn.ch> wrote:
> > @@ -2196,11 +2198,12 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
> >               ops = &es581_4_ops;
> >       }
> >
> > -     es58x_dev = devm_kzalloc(dev, es58x_sizeof_es58x_device(param),
> > -                              GFP_KERNEL);
> > -     if (!es58x_dev)
> > +     devlink = devlink_alloc(&es58x_dl_ops, es58x_sizeof_es58x_device(param),
> > +                             dev);
> > +     if (!devlink)
> >               return ERR_PTR(-ENOMEM);
> >
> > +     es58x_dev = devlink_priv(devlink);
>
> That is 'interesting'.

Another interesting thing I found is:
https://elixir.bootlin.com/linux/v6.1-rc6/source/drivers/net/ethernet/intel/ice/ice_devlink.c#L866

Because devlink does not have an equivalent to devm_kzalloc(), that
driver uses devm_add_action_or_reset() instead. But any other drivers
will call devlink_free() in their disconnect function. So here, I just
followed the trend.

> Makes me wonder about lifetimes of different
> objects. Previously your es58x_dev structure would disappear when the
> driver is released, or an explicit call to devm_kfree(). Now it
> disappears when devlink_free() is called.

Even before that, this driver used to release es58x_dev in its
disconnect() function. I changed it to use devm_kzalloc() last year
after discovering its existence.
  https://git.kernel.org/torvalds/linux/c/6bde4c7fd845

>Any danger of use after free here?

devlink_alloc() allocates one continuous block for both the devlink
and the device priv (struct es58x_dev here):
  https://elixir.bootlin.com/linux/v6.1-rc6/source/net/core/devlink.c#L9629

So calling devlink_free() also releases struct es58x_dev.

> USB devices always make me wonder about life times rules since they
> are probably the mode dynamic sort of device the kernel has the
> handle, them just abruptly disappearing.
>
> >       es58x_dev->param = param;
> >       es58x_dev->ops = ops;
> >       es58x_dev->dev = dev;
> > @@ -2247,6 +2250,8 @@ static int es58x_probe(struct usb_interface *intf,
> >       if (ret)
> >               return ret;
> >
> > +     devlink_register(priv_to_devlink(es58x_dev));
> > +
> >       for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
> >               ret = es58x_init_netdev(es58x_dev, ch_idx);
> >               if (ret) {
> > @@ -2272,8 +2277,10 @@ static void es58x_disconnect(struct usb_interface *intf)
> >       dev_info(&intf->dev, "Disconnecting %s %s\n",
> >                es58x_dev->udev->manufacturer, es58x_dev->udev->product);
> >
> > +     devlink_unregister(priv_to_devlink(es58x_dev));
> >       es58x_free_netdevs(es58x_dev);
> >       es58x_free_urbs(es58x_dev);
> > +     devlink_free(priv_to_devlink(es58x_dev));
> >       usb_set_intfdata(intf, NULL);
>
> Should devlink_free() be after usb_set_inftdata()?

A look at
  $ git grep -W "usb_set_intfdata(.*NULL)"

shows that the two patterns (freeing before or after
usb_set_intfdata()) coexist.

You are raising an important question here. usb_set_intfdata() does
not have documentation that freeing before it is risky. And the
documentation of usb_driver::disconnect says that:
  "@disconnect: Called when the interface is no longer accessible,
   usually because its device has been (or is being) disconnected
   or the driver module is being unloaded."
  Ref: https://elixir.bootlin.com/linux/v6.1-rc6/source/include/linux/usb.h#L1130

So the interface no longer being accessible makes me assume that the
order does not matter. If it indeed matters, then this is a foot gun
and there is some clean-up work waiting for us on many drivers.

@Greg, any thoughts on whether or not the order of usb_set_intfdata()
and resource freeing matters or not?


Yours sincerely,
Vincent Mailhol
