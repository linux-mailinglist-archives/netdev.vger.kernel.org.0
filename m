Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF4039438F
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbhE1Nvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 09:51:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhE1Nvq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 09:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Enj7fzG2s3mxlNczWZOqN/yxsGH0zcgsb4CsKkOLdU8=; b=P3
        aaifHT9vpk8jlC0Hi1TO3dl68JJqnoiPnIdRRDE3CTB6h53KzLXkqNGNRIZL7ko0kohb1GsSE2sb3
        t8vUCzhZBD0RVnOzAzM3Twa9JH+PNpxk84Ygxv4yiyQXDYtux5r63k7vFb4TsYGLW/o/WWMiAEMET
        s/ZDBMAmUPDtmmE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmcsK-006kNF-S8; Fri, 28 May 2021 15:50:08 +0200
Date:   Fri, 28 May 2021 15:50:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v1 4/5] leds: trigger: netdev: support HW offloading
Message-ID: <YLD1ELr5csaat6Uk@lunn.ch>
References: <20210526180020.13557-1-kabel@kernel.org>
 <20210526180020.13557-5-kabel@kernel.org>
 <YK/PbY/a0plxvzh+@lunn.ch>
 <20210528084556.69bbba1a@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210528084556.69bbba1a@dellmb>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 08:45:56AM +0200, Marek Behún wrote:
> On Thu, 27 May 2021 18:57:17 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Wed, May 26, 2021 at 08:00:19PM +0200, Marek Behún wrote:
> > > Add support for HW offloading of the netdev trigger.
> > > 
> > > We need to export the netdev_led_trigger variable so that drivers
> > > may check whether the LED is set to this trigger.  
> > 
> > Without seeing the driver side, it is not obvious to me why this is
> > needed. Please add the driver changes to this patchset, so we can
> > fully see how the API works.
> 
> OK, I will send an implementation for leds-turris-omnia with v2.
> 
> The idea is that the trigger_offload() method should check which
> trigger it should offload. A potential LED controller may be configured
> to link the LED on net activity, or on SATA activity. So the method
> should do something like this:
> 
>   static int my_trigger_offload(struct led_classdev *cdev, bool enable)
>   {
>     if (!enable)
>       return my_disable_hw_triggering(cdev);
> 	
>     if (cdev->trigger == &netdev_led_trigger)
>       return my_offload_netdev_triggering(cdev);
>     else if (cdev->trigger == &blkdev_led_trigger)
>       return my_offload_blkdev_triggering(cdev);
>     else
>       return -EOPNOTSUPP;
>   }

So the hardware driver does not need the contents of the trigger? It
never manipulates the trigger. Maybe to keep the abstraction cleaner,
an enum can be added to the trigger to identify it. The code then
becomes:

static int my_trigger_offload(struct led_classdev *cdev, bool enable)
{
	if (!enable)
        	return my_disable_hw_triggering(cdev);
 	
	switch(cdev->trigger->trigger) {
	case TRIGGER_NETDEV:
	       return my_offload_netdev_triggering(cdev);
	case TRIGGER_BLKDEV:
	       return my_offload_blkdev_triggering(cdev);
	default:
	       return -EOPNOTSUPP;
}	

	Andrew
