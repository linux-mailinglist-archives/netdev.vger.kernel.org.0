Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2552639B8A
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 16:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiK0PgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 10:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiK0PgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 10:36:18 -0500
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 06224DEB8
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 07:36:16 -0800 (PST)
Received: (qmail 294816 invoked by uid 1000); 27 Nov 2022 10:36:15 -0500
Date:   Sun, 27 Nov 2022 10:36:15 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
Message-ID: <Y4OD70GD4KnoRk0k@rowland.harvard.edu>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
 <Y4JEGYMtIWX9clxo@lunn.ch>
 <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 02:10:32PM +0900, Vincent MAILHOL wrote:
> > Should devlink_free() be after usb_set_inftdata()?
> 
> A look at
>   $ git grep -W "usb_set_intfdata(.*NULL)"
> 
> shows that the two patterns (freeing before or after
> usb_set_intfdata()) coexist.
> 
> You are raising an important question here. usb_set_intfdata() does
> not have documentation that freeing before it is risky. And the
> documentation of usb_driver::disconnect says that:
>   "@disconnect: Called when the interface is no longer accessible,
>    usually because its device has been (or is being) disconnected
>    or the driver module is being unloaded."
>   Ref: https://elixir.bootlin.com/linux/v6.1-rc6/source/include/linux/usb.h#L1130
> 
> So the interface no longer being accessible makes me assume that the
> order does not matter. If it indeed matters, then this is a foot gun
> and there is some clean-up work waiting for us on many drivers.
> 
> @Greg, any thoughts on whether or not the order of usb_set_intfdata()
> and resource freeing matters or not?

In fact, drivers don't have to call usb_set_intfdata(NULL) at all; the 
USB core does it for them after the ->disconnect() callback returns.

But if a driver does make the call, it should be careful to ensure that 
the call happens _after_ the driver is finished using the interface-data 
pointer.  For example, after all outstanding URBs have completed, if the
completion handlers will need to call usb_get_intfdata().

Remember, the interface-data pointer is owned by the driver.  Nothing 
else in the kernel uses it.  So the driver merely has to be careful not 
to clear the pointer while it is still using it.

Alan Stern
