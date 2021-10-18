Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADBB432459
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhJRRDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231894AbhJRRDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 13:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44EF1604D2;
        Mon, 18 Oct 2021 17:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634576502;
        bh=Av85IzgjOQuZnSY8coC4aSGyh0ererNkt1NuiSRDWns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pfcItBDlTvc917rUYeDYNuwkeY/Eo0KsRYwe0Ow/iCg/KaGmjUmcGBJIJJnuQb9ew
         9XcdC0A2K1m9/h5nAas2H78dhONHcOHGHp/bVnpG00VIO5gwuCdeD3/6nDyCEyuOuz
         qXz/EetI/QzyRCJlwx0yQTwoNYzbXKJ4ZCbFZ78Ao3A73XlZnfGhwL5tNoUeb7bUjn
         915hTwt7e9C0qahSUVQs8sVgaT1LYgN07l+Tm55n15it80bgVvOqMAYPcal9DSF3Mx
         fnSclYuLAzOVYSCmbmZIsIcChGbVps6o4e3V59PSqnWSsqHmSNwff9nmrW8ZQeUY4N
         I+2f8z/bg4Tfg==
Date:   Mon, 18 Oct 2021 10:01:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Taras Chornyi [C]" <tchornyi@marvell.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Vadym Kochan [C]" <vkochan@marvell.com>
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use
 eth_hw_addr_set_port()
Message-ID: <20211018100141.53844c4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CO6PR18MB4083DDE34183B96B4D882D60C4BC9@CO6PR18MB4083.namprd18.prod.outlook.com>
References: <20211015193848.779420-1-kuba@kernel.org>
        <20211015193848.779420-4-kuba@kernel.org>
        <20211015235130.6sulfh2ouqt3dgfh@skbuf>
        <CO6PR18MB4083DDE34183B96B4D882D60C4BC9@CO6PR18MB4083.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 16:54:00 +0000 Taras Chornyi [C] wrote:
> > @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
> >       /* firmware requires that port's MAC address consist of the first
> >        * 5 bytes of the base MAC address
> >        */
> > -     memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> > -     dev->dev_addr[dev->addr_len - 1] = port->fp_id;
> > +     memcpy(addr, sw->base_mac, dev->addr_len - 1);  
> 
> This code is a bit buggy.  We do care about the last byte of the base mac address.
> For example if base mac is xx:xx:xx:xx:xx:10 first port mac should be  xx:xx:xx:xx:xx:11

Thanks for the reply, does it mean we can assume base_mac will be valid
or should we add a check like below?

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index b667f560b931..966f94c6c7a6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -338,11 +338,14 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
                goto err_port_init;
        }
 
-       /* firmware requires that port's MAC address consist of the first
-        * 5 bytes of the base MAC address
-        */
-       memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
-       dev->dev_addr[dev->addr_len - 1] = port->fp_id;
+       eth_hw_addr_set_port(dev, sw->base_mac, port->fp_id);
+       if (memcmp(dev->dev_addr, sw->base_mac, ETH_ALEN - 1)) {
+               /* firmware requires that port's MAC address consists
+                * of the first 5 bytes of the base MAC address
+                */
+               dev_warn(prestera_dev(sw), "Port MAC address overflows the base for port(%u)\n", id);
+               dev_addr_mod(dev, 0, sw->base_mac, ETH_ALEN - 1);
+       }
 
        err = prestera_hw_port_mac_set(port, dev->dev_addr);
        if (err) {
