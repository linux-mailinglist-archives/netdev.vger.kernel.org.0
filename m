Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4821FB52A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgFPO4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbgFPO4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:56:30 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8614CC0613EF;
        Tue, 16 Jun 2020 07:56:29 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id q19so21841890eja.7;
        Tue, 16 Jun 2020 07:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UBODMToDGTxlCalS6Z2hG3h1HW+N0PDRI8iyq9MQZQ0=;
        b=tU2Lu70EhO2VSwXixs4LvyozzvHNBLDX1lMVYhsH34U2WJD0SrO+UFu1FG8+ilawMM
         s4wnf0raGT5HJ6IAG/+XZjxRWmjMqtDx410PcQ1/B2izfnjfUizeHAn8DRrsv9UZI0Fm
         7JuZ5LHhBZHG7aIoxVrOdhIvinypKyZKKLLdOTRVWBrbIFjeiSfZl9uq76ADgGnxl5MT
         SR6Z6c5vTKE9Fc/oEvdJHJ+H1IB6Yp/WkwHwLAQZTpeBPqIbwyOUNjQu75BvSKHdwMcU
         vkNH4ezbnAty5c7iptFet4S48gm44q/EnIYDD25KydLeB91Ih5EGH44kRapde6CRWGNg
         rTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UBODMToDGTxlCalS6Z2hG3h1HW+N0PDRI8iyq9MQZQ0=;
        b=IjCRL6TA+ZPoRpqch7ylWnrjFxCE8nUWpcQtfF98bX83R7D+L3njIlRRSNkj+U3eF8
         PU69yFpWxQfy9/ODkPWoMTr1wjpqH9q6KFUp32OFFSGVnoX29uKezB9PBQM6Pvpr80+N
         SKS1qfzQ56955Jeat3by8B/XscLEMQqpZoJyxNuKk7rH2iUXfq8xRNizzyW7EnePYLgG
         9U2NRa2kbq8Okko0rESlshLXQWbO2cDgRrwcJ4Ewn2w8eTKN/o/Aszt6HzWoTAWLg7eL
         Wx+NqkTDnzd7IVFZQs/5B/Q2sJrVpUiEIvrkxPbCy9mNfX2VMWAU9gIvqdFwMBKf07zU
         RXOQ==
X-Gm-Message-State: AOAM532RvaDchrHwYGcw2BijiRQFg2UuhpLEHTecLuW3CI5//dACvBMn
        bu+iAiJKlah1jluMyBTXwqtBBEAxVtaPHa4dS3ObzNCL
X-Google-Smtp-Source: ABdhPJxQNsZTwxUR1yYmcxDHZlYSdVS9VScGb5TA3fpe40I6LtePnsty370NyZSoFj3E/kjt/P2XecRwYXeShdZUSqc=
X-Received: by 2002:a17:906:851:: with SMTP id f17mr3012520ejd.396.1592319388216;
 Tue, 16 Jun 2020 07:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200616144118.3902244-1-olteanv@gmail.com> <20200616144118.3902244-3-olteanv@gmail.com>
 <acb765da28bde4dff4fc2cd9ea661fa1b3486947.camel@infinera.com>
In-Reply-To: <acb765da28bde4dff4fc2cd9ea661fa1b3486947.camel@infinera.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 17:56:17 +0300
Message-ID: <CA+h21hoz_LJgvCiVeuPTUVHN2Nu9wWAVnzz9GS2bo=y+Y1hLJA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "madalin.bucur@oss.nxp.com" <madalin.bucur@oss.nxp.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On Tue, 16 Jun 2020 at 17:51, Joakim Tjernlund
<Joakim.Tjernlund@infinera.com> wrote:
>
> On Tue, 2020-06-16 at 17:41 +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The dpaa-eth driver probes on compatible string for the MAC node, and
> > the fman/mac.c driver allocates a dpaa-ethernet platform device that
> > triggers the probing of the dpaa-eth net device driver.
> >
> > All of this is fine, but the problem is that the struct device of the
> > dpaa_eth net_device is 2 parents away from the MAC which can be
> > referenced via of_node. So of_find_net_device_by_node can't find it, and
> > DSA switches won't be able to probe on top of FMan ports.
> >
> > It would be a bit silly to modify a core function
> > (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> > just for one driver. We're just 1 step away from implementing full
> > recursion.
> >
> > On T1040, the /sys/class/net/eth0 symlink currently points to:
> >
> > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
>
> Just want to point out that on 4.19.x, the above patch still exists:
> cd /sys
> find -name eth0
> ./devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> ./class/net/eth
>

By 'current' I mean 'the net tree just before this patch is applied',
i.e. a v5.7 tree with "dpaa_eth: fix usage as DSA master, try 3"
reverted.

> >
> > which pretty much illustrates the problem. The closest of_node we've got
> > is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
> > which is what we'd like to be able to reference from DSA as host port.
> >
> > For of_find_net_device_by_node to find the eth0 port, we would need the
> > parent of the eth0 net_device to not be the "dpaa-ethernet" platform
> > device, but to point 1 level higher, aka the "fsl,fman-memac" node
> > directly. The new sysfs path would look like this:
> >
> > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0
> >
> > Actually this has worked before, through the SET_NETDEV_DEV mechanism,
> > which sets the parent of the net_device as the parent of the platform
> > device. But the device which was set as sysfs parent was inadvertently
> > changed through commit 060ad66f9795 ("dpaa_eth: change DMA device"),
> > which did not take into consideration the effect it would have upon
> > of_find_net_device_by_node. So restore the old sysfs parent to make that
> > work correctly.
> >
> > Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index c4416a5f8816..2972244e6eb0 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -2914,7 +2914,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
> >         }
> >
> >         /* Do this here, so we can be verbose early */
> > -       SET_NETDEV_DEV(net_dev, dev);
> > +       SET_NETDEV_DEV(net_dev, dev->parent);
> >         dev_set_drvdata(dev, net_dev);
> >
> >         priv = netdev_priv(net_dev);
> > --
> > 2.25.1
> >
>

Thanks,
-Vladimir
