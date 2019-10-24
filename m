Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6D3E2F48
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438895AbfJXKnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:43:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53393 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436873AbfJXKnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:43:22 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iNaaL-0003Um-Dg; Thu, 24 Oct 2019 12:43:17 +0200
Date:   Thu, 24 Oct 2019 12:43:17 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
Message-ID: <20191024104317.32bp32krrjmfb36p@linutronix.de>
References: <20191018082817.111480-1-dwagner@suse.de>
 <20191018131532.dsfhyiilsi7cy4cm@linutronix.de>
 <20191022101747.001b6d06@cakuba.netronome.com>
 <20191023074719.gcov5xfrcvns5tlg@beryllium.lan>
 <20191023080640.zcw2f2v7fpanoewm@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191023080640.zcw2f2v7fpanoewm@beryllium.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-23 10:06:40 [+0200], Daniel Wagner wrote:
> Sebastian suggested to try this here:
> 
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -1264,8 +1264,11 @@ static void lan78xx_status(struct lan78xx_net *dev, struct urb *urb)
>                 netif_dbg(dev, link, dev->net, "PHY INTR: 0x%08x\n", intdata);
>                 lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
>  
> -               if (dev->domain_data.phyirq > 0)
> +               if (dev->domain_data.phyirq > 0) {
> +                       local_irq_disable();
>                         generic_handle_irq(dev->domain_data.phyirq);
> +                       local_irq_enable();
> +               }
>         } else
>                 netdev_warn(dev->net,
>                             "unexpected interrupt: 0x%08x\n", intdata);

This should should be applied as a regression fix introduced by commit
   ed194d1367698 ("usb: core: remove local_irq_save() around ->complete() handler")

> While this gets rid of the warning, the networking interface is not
> really stable:
> 
> [   43.999628] nfs: server 192.168.19.2 not responding, still trying
> [   43.999633] nfs: server 192.168.19.2 not responding, still trying
> [   43.999649] nfs: server 192.168.19.2 not responding, still trying
> [   43.999674] nfs: server 192.168.19.2 not responding, still trying
> [   43.999678] nfs: server 192.168.19.2 not responding, still trying
> [   44.006712] nfs: server 192.168.19.2 OK
> [   44.018443] nfs: server 192.168.19.2 OK
> [   44.024765] nfs: server 192.168.19.2 OK
> [   44.025361] nfs: server 192.168.19.2 OK
> [   44.025420] nfs: server 192.168.19.2 OK
> [  256.991659] nfs: server 192.168.19.2 not responding, still trying
> [  256.991664] nfs: server 192.168.19.2 not responding, still trying
> [  256.991669] nfs: server 192.168.19.2 not responding, still trying
> [  256.991685] nfs: server 192.168.19.2 not responding, still trying
> [  256.991713] nfs: server 192.168.19.2 not responding, still trying
> [  256.998797] nfs: server 192.168.19.2 OK
> [  256.999745] nfs: server 192.168.19.2 OK
> [  256.999828] nfs: server 192.168.19.2 OK
> [  257.000438] nfs: server 192.168.19.2 OK
> [  257.004784] nfs: server 192.168.19.2 OK

Since this does not improve the situation as a whole it might be best to
remove the code as suggested by Daniel.

Sebastian
