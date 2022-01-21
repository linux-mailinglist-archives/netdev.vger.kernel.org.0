Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0520049684F
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 00:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiAUXpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 18:45:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbiAUXpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 18:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gKF9AvJvtxDPWBGc9jdPUqD004sDg3ZMvVimzLe72ek=; b=EeWmxuHWyzxhZo/I9FrZYUi58g
        LYGaXiNc1TkiVrJ27pvJKMm7oMttggujs2YA/wouiuQYou+BzbDc2WZ3tufZ9ZO4+WZ2IXTmTDQmw
        ihUAF8KcAX8PWHQiLyXfUKbuJ/5L3y1YVL8qI7KrC7a6gIrV1+G9SI7RgkA1v13WcD7g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nB3bN-002BJ1-Hy; Sat, 22 Jan 2022 00:45:53 +0100
Date:   Sat, 22 Jan 2022 00:45:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Trofimovich <slyich@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: atl1c drivers run 'napi/eth%d-385' named threads with
 unsubstituted %d
Message-ID: <YetFsbw6885xUwSg@lunn.ch>
References: <YessW5YR285JeLf5@nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YessW5YR285JeLf5@nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 09:57:47PM +0000, Sergei Trofimovich wrote:
> Hia atl1c maintainers!
> 
> This cosmetics bothered me for some time: atl1c driver
> shows unexpanded % in kernel thread names. Looks like a
> minor bug:
> 
>     $ ping -f 172.16.0.1  # host1
>     $ top  # host2
>     ...
>     621 root 20 0 0 0 0 S 11.0 0.0 0:05.01 napi/eth%d-385
>     622 root 20 0 0 0 0 S  5.6 0.0 0:02.64 napi/eth%d-386
>     ...
> 
> Was happening for a few years. Likely not a recent regression.
> 
> System:
> - linux-5.16.1
> - x86_64
> - 02:00.0 Ethernet controller: Qualcomm Atheros AR8151 v2.0 Gigabit Ethernet (rev c0)
> 
> >From what I understand thread name comes from somewhere around:
> 
>   net/core/dev.c:
>     int dev_set_threaded(struct net_device *dev, bool threaded)
>     ...
>         err = napi_kthread_create(napi);
>     ...
>     static int napi_kthread_create(struct napi_struct *n)
>     ...
>         n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
> 
>   drivers/net/ethernet/atheros/atl1c/atl1c_main.c:
>     static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>     ...
>         dev_set_threaded(netdev, true);
> 
>   ${somewhere} (not sure where):
>     ...
>       strcpy(netdev->name, "eth%d");
> 
> I was not able to pinpoint where expansion should ideally happen.
> Looks like many driver do `strcpy(netdev->name, "eth%d");` style
> initialization and almost none call `dev_set_threaded(netdev, true);`.
> 
> Can you help me find it out how it should be fixed?

Hi Sergei

This is a fun one.

So, the driver does the usual alloc_etherdev_mq()

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/atheros/atl1c/atl1c_main.c#L2703

which ends up here:

https://elixir.bootlin.com/linux/latest/source/net/ethernet/eth.c#L391

struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
                                      unsigned int rxqs)
{
        return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
                                ether_setup, txqs, rxqs);
}

So at this point in time, the device has the name "eth%d".

The normal flow is that sometime later in probe, it calls
register_netdev().

https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L10454

if you follow that down, you get to: __dev_alloc_name(), which does
the expansion of the %d to an actual number:

https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L1087

So between alloc_etherdev_mq() and register_netdev(), the device name
is not valid. And as you pointed out, dev_set_threaded() tries to use
the name, and is called between these two.

The atl1c driver appears to be the only driver actually doing
this. There is a sysfs interface which can call dev_set_threaded(),
but the sysfs interface is probably not available until after
register_netdev() has given the interface its name.

There is a fix for atl1c. Any time after alloc_etherdev_mq(), the
driver can call dev_alloc_name().

So please give this a try. I've not even compile tested it...

iff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index da595242bc13..983a52f77bda 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2706,6 +2706,10 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
                goto err_alloc_etherdev;
        }
 
+       err = dev_alloc_name(netdev, netdev->name);
+       if (err < 0)
+               goto err_init_netdev;
+
        err = atl1c_init_netdev(netdev, pdev);
        if (err) {
                dev_err(&pdev->dev, "init netdevice failed\n");

If this works, i can turn it into a real patch submission.

   Andrew
