Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2BA508189
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 08:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359524AbiDTG7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 02:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241440AbiDTG7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 02:59:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7779134B9B;
        Tue, 19 Apr 2022 23:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D062BCE1C1C;
        Wed, 20 Apr 2022 06:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B485AC385A1;
        Wed, 20 Apr 2022 06:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650437821;
        bh=t9x0WM2LafrhwbGxL0wf+NquFGAns5D7Zd5KHvmWhHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hAqkDkxLpQyiDcCFkyue9iDqLO7r49XBS0T6NVG29IuUYw1Ob0We1AJAxuLOFv4e2
         hrkH8Pzn1n64ngDPt5E3cWySsOTtUcLvRb6SiyCKDgbyvGmSbrVTGUzLPNNWci4bpy
         A4pqyysiZDv4/zy+q1Deq8nTnMZwv7a5Mb2a3YqbX50cJ+YHChySXs+UaRqkjPUq2Z
         W6FpWiuc1Yh6o6763gLhVqPIDkzSXGY1JC5AXh4/TouvdUwbFImvVvvcyQ0RnkH3Js
         aeWz8Xc62MWra/zNchrKetbmNsQtzGAByVJzdw+RDtPVP3VGQq54rTXH5v6Lfhm0nP
         F6etUpUZeeXOA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nh4Gi-0005EX-TC; Wed, 20 Apr 2022 08:56:53 +0200
Date:   Wed, 20 Apr 2022 08:56:52 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Message-ID: <Yl+utFmKEgILDFr5@hovoldconsulting.com>
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
 <YlQbqnYP/jcYinvz@hovoldconsulting.com>
 <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
 <d851497f-7960-b606-2f87-eb9bff89c8ac@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d851497f-7960-b606-2f87-eb9bff89c8ac@suse.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:47:40PM +0200, Oliver Neukum wrote:
> On 14.04.22 17:01, Andy Shevchenko wrote:
> >
> > Good question. Isn't it the commit 2c9d6c2b871d ("usbnet: run unbind()
> > before unregister_netdev()") which changed the ordering of the
> > interface shutdown and basically makes this race happen? I don't see
> > how we can guarantee that IOCTL won't be called until we quiescence
> > the network device — my understanding that on device surprise removal
> True. The best we could do is introduce a mutex for ioctl() and
> disconnect(). That seems the least preferable solution to me.
> > we have to first shutdown what it created and then unbind the device.

Yes, indeed, commit 2c9d6c2b871d ("usbnet: run unbind() before
unregister_netdev()") is fundamentally broken. You can't just start
freeing driver private data before deregistering the device.

> > If I understand the original issue correctly then the problem is in
> > usbnet->unbind and it should actually be split to two hooks, otherwise
> > it seems every possible IOCTL callback must have some kind of
> > reference counting and keep an eye on the surprise removal.
> >
> > Johan, can you correct me if my understanding is wrong?

That sounds correct. I only noticed that the proposed patch looked
insufficient at best and didn't really look into the backstory until
just now.

> It seems to me that fundamentally the order of actions to handle
> a hotunplug must mirror the order in a hotplug. We can add more hooks
> if that turns out to be necessary for some drivers, but the basic
> reverse mirrored order must be supported and I very much favor
> restoring it as default.

I agree, we need to strive to maintain symmetry. Anything else is likely
broken and at least makes things harder to reason about and maintenance
a pain.

> So I am afraid I have to ask again, whether anybody sees a fundamental
> issue with the attached patch, as opposed to it not being an elegant
> solution?
> It looks to me that we are in a fundamental disagreement on the correct
> order in this question and there is no productive way forward other than
> offering both ways.
> 
>     Regards
>         Oliver

> From 2e07ccbd1769889963d129ec474909bdcaa4c64a Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oneukum@suse.com>
> Date: Thu, 10 Mar 2022 13:18:38 +0100
> Subject: [PATCH] usbnet: split unbind callback
> 
> Some devices need to be informed of a disconnect before
> the generic layer is informed, others need their notification
> later to avoid race conditions. Hence we provide two callbacks.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/asix_devices.c | 8 ++++----
>  drivers/net/usb/smsc95xx.c     | 4 ++--
>  drivers/net/usb/usbnet.c       | 7 +++++--
>  include/linux/usb/usbnet.h     | 3 +++
>  4 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 6ea44e53713a..e6cfa9a39a87 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -808,7 +808,7 @@ static int ax88772_stop(struct usbnet *dev)
>  	return 0;
>  }
>  
> -static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
> +static void ax88772_disable(struct usbnet *dev, struct usb_interface *intf)
>  {
>  	struct asix_common_private *priv = dev->driver_priv;
>  
> @@ -1214,7 +1214,7 @@ static const struct driver_info hawking_uf200_info = {
>  static const struct driver_info ax88772_info = {
>  	.description = "ASIX AX88772 USB 2.0 Ethernet",
>  	.bind = ax88772_bind,
> -	.unbind = ax88772_unbind,
> +	.unbind = ax88772_disable,

These should all be

	.disable = ...

but you probably need to split the callback and keep unbind as well for
the actual clean up (freeing resources etc).

>  	.status = asix_status,
>  	.reset = ax88772_reset,
>  	.stop = ax88772_stop,
> @@ -1226,7 +1226,7 @@ static const struct driver_info ax88772_info = {
>  static const struct driver_info ax88772b_info = {
>  	.description = "ASIX AX88772B USB 2.0 Ethernet",
>  	.bind = ax88772_bind,
> -	.unbind = ax88772_unbind,
> +	.unbind = ax88772_disable,
>  	.status = asix_status,
>  	.reset = ax88772_reset,
>  	.stop = ax88772_stop,
> @@ -1262,7 +1262,7 @@ static const struct driver_info ax88178_info = {
>  static const struct driver_info hg20f9_info = {
>  	.description = "HG20F9 USB 2.0 Ethernet",
>  	.bind = ax88772_bind,
> -	.unbind = ax88772_unbind,
> +	.unbind = ax88772_disable,
>  	.status = asix_status,
>  	.reset = ax88772_reset,
>  	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 5567220e9d16..62db57021f5f 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1211,7 +1211,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
>  	return ret;
>  }
>  
> -static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
> +static void smsc95xx_disable(struct usbnet *dev, struct usb_interface *intf)
>  {
>  	struct smsc95xx_priv *pdata = dev->driver_priv;
>  
> @@ -1985,7 +1985,7 @@ static int smsc95xx_manage_power(struct usbnet *dev, int on)
>  static const struct driver_info smsc95xx_info = {
>  	.description	= "smsc95xx USB 2.0 Ethernet",
>  	.bind		= smsc95xx_bind,
> -	.unbind		= smsc95xx_unbind,
> +	.unbind		= smsc95xx_disable,
>  	.link_reset	= smsc95xx_link_reset,
>  	.reset		= smsc95xx_reset,
>  	.check_connect	= smsc95xx_start_phy,
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index b1f93810a6f3..5249a7d7efa5 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1641,8 +1641,8 @@ void usbnet_disconnect (struct usb_interface *intf)
>  		   xdev->bus->bus_name, xdev->devpath,
>  		   dev->driver_info->description);
>  
> -	if (dev->driver_info->unbind)
> -		dev->driver_info->unbind(dev, intf);
> +	if (dev->driver_info->disable)
> +		dev->driver_info->disable(dev, intf);
>  
>  	net = dev->net;
>  	unregister_netdev (net);
> @@ -1651,6 +1651,9 @@ void usbnet_disconnect (struct usb_interface *intf)
>  
>  	usb_scuttle_anchored_urbs(&dev->deferred);
>  
> +	if (dev->driver_info->unbind)
> +		dev->driver_info->unbind (dev, intf);
> +
>  	usb_kill_urb(dev->interrupt);

Don't you need to quiesce all I/O, including stopping the interrupt URB,
before unbind?

>  	usb_free_urb(dev->interrupt);
>  	kfree(dev->padding_pkt);
> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index 8336e86ce606..4d2407f1ae93 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -129,6 +129,9 @@ struct driver_info {
>  	/* cleanup device ... can sleep, but can't fail */
>  	void	(*unbind)(struct usbnet *, struct usb_interface *);
>  
> +	/* disable device ... can sleep, but can't fail */
> +	void	(*disable)(struct usbnet *, struct usb_interface *);
> +
>  	/* reset device ... can sleep */
>  	int	(*reset)(struct usbnet *);

Johan
