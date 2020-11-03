Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE82A4A64
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCPzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:55:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgKCPzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 10:55:17 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D12520786;
        Tue,  3 Nov 2020 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604418916;
        bh=3rVFLYcCPBUA/SjfYpwKg1vDKSgs6xZS6DJL07CJ63g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eTCSAAqdkoicNUm5W4LAxXyASpVGgE2GSH9JUYPgAVZ4XiP2xUj60TSwmPV/8Fosw
         vZxS8QLNUTGROM/j8QrXJFwYPjOsIPN5AuoK8EHGXY/J85B7Ll7xnXcZ0IDDIKdx1f
         t1NEAYMYpiEIAjYkh5jZ3cOcB4ScYvvb3HcqTzDM=
Date:   Tue, 3 Nov 2020 07:55:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <apais@linux.microsoft.com>
Cc:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net,
        m.grzeschik@pengutronix.de, paulus@samba.org, oliver@neukum.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        petkan@nucleusys.com, netdev@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [next-next v3 05/10] net: cdc_ncm: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20201103075515.7856d175@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <ed37373b-218c-600d-7837-efdd217fd799@linux.microsoft.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
        <20201006061159.292340-6-allen.lkml@gmail.com>
        <20201008165859.2e96ef7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ed37373b-218c-600d-7837-efdd217fd799@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 13:02:26 +0530 Allen Pais wrote:
> >   
> >> @@ -815,7 +815,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
> >>   
> >>   	hrtimer_init(&ctx->tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> >>   	ctx->tx_timer.function = &cdc_ncm_tx_timer_cb;
> >> -	tasklet_init(&ctx->bh, cdc_ncm_txpath_bh, (unsigned long)dev);
> >> +	tasklet_setup(&ctx->bh, cdc_ncm_txpath_bh);
> >>   	atomic_set(&ctx->stop, 0);
> >>   	spin_lock_init(&ctx->mtx);
> >>   
> >> @@ -1468,9 +1468,9 @@ static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *timer)
> >>   	return HRTIMER_NORESTART;
> >>   }
> >>   
> >> -static void cdc_ncm_txpath_bh(unsigned long param)
> >> +static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
> >>   {
> >> -	struct usbnet *dev = (struct usbnet *)param;
> >> +	struct usbnet *dev = from_tasklet(dev, t, bh);
> >>   	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
> >>   
> >>   	spin_lock_bh(&ctx->mtx);  
> > 
> > This one is wrong.
> > 
> > ctx is struct cdc_ncm_ctx, but you from_tasklet() struct usbdev.
> > They both happen to have a tasklet called bh in 'em.  
> 
>   from_tasklet() is struct usbnet. So it should pick the right bh isn't it?

Look at the tasklet_init / tasklet_setup line.

It used to pass dev as an argument. But the tasklet is in ctx.

Now there is no explicit param, do you gotta pick out of ctx.
