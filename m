Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774C23D4C69
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 08:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhGYFwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 01:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhGYFwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 01:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1501760F13;
        Sun, 25 Jul 2021 06:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627194784;
        bh=wlXW6USsZex8XdiwmwtjzhgxjC6oifv3Uj+wH6B39gM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmT3R1OgC+HAe1MwvwkIeU+qo8cAgYd34TMKQfMqAngmhTXkemgZvp9jthyRHAYdW
         goc+oAwqSYX3M5VX66MGJzFzocozaH6KO/0dBJ7/2rjefSU3adu+Vm3Wo0VY641aCI
         I6CYsDKQ3UQBvxMpgqGTb0RDyncXKcwXZPbNJJnk=
Date:   Sun, 25 Jul 2021 08:33:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hin-Tak Leung <htl10@users.sourceforge.net>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Larry Finger <larry.finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: rtl8187: replace udev with usb_get_dev()
Message-ID: <YP0FnUlHD4I7hWIi@kroah.com>
References: <20210724183457.GA470005@pc>
 <53895498.1259278.1627160074135@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53895498.1259278.1627160074135@mail.yahoo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 24, 2021 at 08:54:34PM +0000, Hin-Tak Leung wrote:
>  
> 
> On Saturday, 24 July 2021, 19:35:12 BST, Salah Triki <salah.triki@gmail.com> wrote:
> 
> 
> > Replace udev with usb_get_dev() in order to make code cleaner.
> 
> > Signed-off-by: Salah Triki <salah.triki@gmail.com>
> > ---
> > drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 4 +---
> > 1 file changed, 1 insertion(+), 3 deletions(-)
> 
> > diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> > index eb68b2d3caa1..30bb3c2b8407 100644
> > --- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> > +++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> > @@ -1455,9 +1455,7 @@ static int rtl8187_probe(struct usb_interface *intf,
> 
> >     SET_IEEE80211_DEV(dev, &intf->dev);
> >     usb_set_intfdata(intf, dev);
> > -    priv->udev = udev;
> > -
> > -    usb_get_dev(udev);
> > +    priv->udev = usb_get_dev(udev);
> 
> >     skb_queue_head_init(&priv->rx_queue);
> 
> > -- 
> > 2.25.1
> 
> It is not cleaner - the change is not functionally equivalent. Before the change, the reference count is increased after the assignment; and after the change, before the assignment. So my question is, does the reference count increasing a little earlier matters? What can go wrong between very short time where the reference count increases, and priv->udev not yet assigned? I think there might be a race condition where the probbe function is called very shortly twice.
> Especially if the time of running the reference count function is non-trivial.

Probe functions are called in order, this should not be an issue.

This patch changes nothing, I do not think it is needed at all.

thanks,

greg k-h
