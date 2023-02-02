Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D556882C9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjBBPhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjBBPhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:37:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BB980025;
        Thu,  2 Feb 2023 07:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6340CB82686;
        Thu,  2 Feb 2023 15:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC41C433EF;
        Thu,  2 Feb 2023 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675352143;
        bh=CUkACK2HdhrbT9JJSVOy6ZjSUjRIl9SuwgXFjsN3DTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFwcsxv21LoqcrgA6sf/+ExloW3CW4aRCPO6D6aJ1xMra9JYEoeRYwa7+ewVHKXxY
         QChxREN1BgXVrBXYIWdxUY1QDOn6WrJO+uwOR2HRI7j60NbqMpvJ9PCxq1aLdbIUPL
         rB75Z+WzqxpbvFFksuoTNl28vRJSujT7ECZFclGU=
Date:   Thu, 2 Feb 2023 16:35:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: etas_es58x: do not send disable channel command if
 device is unplugged
Message-ID: <Y9vYTPURT4hDSH4n@kroah.com>
References: <20230128133815.1796221-1-mailhol.vincent@wanadoo.fr>
 <20230202151622.sotqfwmgwwtgv4dl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202151622.sotqfwmgwwtgv4dl@pengutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 04:16:22PM +0100, Marc Kleine-Budde wrote:
> On 28.01.2023 22:38:15, Vincent Mailhol wrote:
> > When turning the network interface down, es58x_stop() is called and
> > will send a command to the ES58x device to disable the channel
> > c.f. es58x_ops::disable_channel().
> > 
> > However, if the device gets unplugged while the network interface is
> > still up, es58x_ops::disable_channel() will obviously fail to send the
> > URB command and the driver emits below error message:
> > 
> >   es58x_submit_urb: USB send urb failure: -ENODEV
> > 
> > Check the usb device state before sending the disable channel command
> > in order to silence above error message.
> > 
> > Update the documentation of es58x_stop() accordingly.
> > 
> > The check being added in es58x_stop() is:
> > 
> >   	if (es58x_dev->udev->state >= USB_STATE_UNAUTHENTICATED)
> > 
> > This is just the negation of the check done in usb_submit_urb()[1].
> > 
> > [1] usb_submit_urb(), verify usb device's state.
> > Link: https://elixir.bootlin.com/linux/v6.1/source/drivers/usb/core/urb.c#L384
> > 
> > Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> > As far as I know, there doesn't seem to be an helper function to check
> > udev->state values. If anyone is aware of such helper function, let me
> > know..
> 
> The constant USB_STATE_UNAUTHENTICATED is not used very often in the
> kernel. Maybe Greg can point out what is best to do here.

Don't do anything in the driver here, except maybe turn off that useless
"error message" in the urb submission function?  A USB driver shouldn't
be poking around in the state of the device at all, as it's about to go
away if it's been physically removed.

The urb submission will fail if the device is removed, handle the error
and move on, that's a totally normal situation as you say it happens a
lot :)

Don't spam error logs for common things please.

thanks,

greg k-h
