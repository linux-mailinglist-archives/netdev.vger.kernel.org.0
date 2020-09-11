Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76C0265D44
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgIKKBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIKKAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 06:00:53 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49726C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 03:00:53 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id x19so8920014oix.3
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 03:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+detDlW6s/Bfz5Im7XQLE78s0KVhgipG7d4WqJMGdc=;
        b=uksU3gKXqyp2Pr4C+ovMtY6vGOdyT2okxkIPZrqkpWmntBdsYPiSZChEYolkT+wkV9
         sLWPrA7yHzU+OVCCd6IL2e+H9y0WHGfr6mnH6A6ZxRdF7KqpDB5n6NbXH2frno0NYYZp
         JxgZ2lJIlQa+KCtwTbVkiLhucf7p61SQzeBFJXSh3zvvlIMwrXv+Um0wdD2KFxPqeFbD
         hisuZaOdVZVzZnclvrYAyFRxR++GiMWtnnbIrfG39cxPfMTi7PolmTdrjQG/H184fSeF
         PDu+WSqloOUiDhGfKepmFfTj+hNqwyPDRUruZGq++96BhDYN4a0/dTpzfBHlcgOyS0CC
         glvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+detDlW6s/Bfz5Im7XQLE78s0KVhgipG7d4WqJMGdc=;
        b=t4dGepOgRR5d1hfzIWD2D9yeicQKJloUW6N3LSFi9OOdA5Mxz0JDA0JowoM8GsZsQb
         +2Gx3LWTOFNH27+31gYgFso9E1bn0Q/zGcX/JYqVLer/IyoIKf7KWmUdvUla4tM/6yW0
         IVvshITYod3K0ItGVWIFGa0XoBPxDnsHXk1NIibv0v2fv3U4ePAMLtkucXiV/da354cV
         E/z9sxCCWPLlv3ynSJ8lTFqpoPu7jBHlZfR4WoomyNvE2/Xntp297LBzAzN0NqPW3V+9
         HHDlnW9UCtuIRgNAOOpamp80ZWRQaJEdfBUtrsBNChkxv4nhKvvayt7pTIv6NBOmhlum
         Z0EQ==
X-Gm-Message-State: AOAM533nk+0RbyAhVXan4joCuXM5KA1lqHnnZKyORINpIicumJhuyfdv
        5vlX2oDw5vTfeZhaRt7e5Opz/2KCJ/dvyDzCZ7k=
X-Google-Smtp-Source: ABdhPJzyf66aHKD8KjkD4FoiUv3ZqbqnZPI6GU52g1F8OekaiuRdpY3H1JW3gLNeoWcG1t9EVnrELhlcGQdfgn8+FmI=
X-Received: by 2002:aca:6c6:: with SMTP id 189mr751256oig.134.1599818452695;
 Fri, 11 Sep 2020 03:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200909084510.648706-2-allen.lkml@gmail.com> <20200909.110956.600909796407174509.davem@davemloft.net>
 <CAOMdWSKQxbKzo6z9BBO=0HPCxSs1nt8ArAe5zi_X5cPQhtnUVA@mail.gmail.com> <20200909.143324.405366987951760976.davem@davemloft.net>
In-Reply-To: <20200909.143324.405366987951760976.davem@davemloft.net>
From:   Allen <allen.lkml@gmail.com>
Date:   Fri, 11 Sep 2020 15:30:41 +0530
Message-ID: <CAOMdWSKMc1HDgmeWaqp1Z+kniNNE1Es9PLLo-3b1PwCrjKLw6A@mail.gmail.com>
Subject: Re: [PATCH v2 01/20] ethernet: alteon: convert tasklets to use new
 tasklet_setup() API
To:     David Miller <davem@davemloft.net>
Cc:     jes@trained-monkey.org, Jakub Kicinski <kuba@kernel.org>,
        dougmill@linux.ibm.com, cooldavid@cooldavid.org,
        mlindner@marvell.com, stephen@networkplumber.org,
        borisp@mellanox.com, netdev@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> >
> >> >
> >> > -static void ace_tasklet(unsigned long arg)
> >> > +static void ace_tasklet(struct tasklet_struct *t)
> >> >  {
> >> > -     struct net_device *dev = (struct net_device *) arg;
> >> > -     struct ace_private *ap = netdev_priv(dev);
> >> > +     struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
> >> > +     struct net_device *dev = (struct net_device *)((char *)ap -
> >> > +                             ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
> >> >       int cur_size;
> >> >
> >>
> >> I don't see this is as an improvement.  The 'dev' assignment looks so
> >> incredibly fragile and exposes so many internal details about netdev
> >> object allocation, alignment, and layout.
> >>
> >> Who is going to find and fix this if someone changes how netdev object
> >> allocation works?
> >>
> >
> > Thanks for pointing it out. I'll see if I can fix it to keep it simple.
>
> Just add a backpointer to the netdev from the netdev_priv() if you
> absolutely have too.
>

How does this look?
diff --git a/drivers/net/ethernet/alteon/acenic.c
b/drivers/net/ethernet/alteon/acenic.c
index 8470c836fa18..1a7e4df9b3e9 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -465,6 +465,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
        SET_NETDEV_DEV(dev, &pdev->dev);

        ap = netdev_priv(dev);
+       ap->ndev = dev;
        ap->pdev = pdev;
        ap->name = pci_name(pdev);

@@ -1562,10 +1563,10 @@ static void ace_watchdog(struct net_device
*data, unsigned int txqueue)
 }


-static void ace_tasklet(unsigned long arg)
+static void ace_tasklet(struct tasklet_struct *t)
 {
-       struct net_device *dev = (struct net_device *) arg;
-       struct ace_private *ap = netdev_priv(dev);
+       struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
+       struct net_device *dev = ap->ndev;
        int cur_size;

        cur_size = atomic_read(&ap->cur_rx_bufs);
@@ -2269,7 +2270,7 @@ static int ace_open(struct net_device *dev)
        /*
         * Setup the bottom half rx ring refill handler
         */
-       tasklet_init(&ap->ace_tasklet, ace_tasklet, (unsigned long)dev);
+       tasklet_setup(&ap->ace_tasklet, ace_tasklet);
        return 0;
 }

diff --git a/drivers/net/ethernet/alteon/acenic.h
b/drivers/net/ethernet/alteon/acenic.h
index c670067b1541..265fa601a258 100644
--- a/drivers/net/ethernet/alteon/acenic.h
+++ b/drivers/net/ethernet/alteon/acenic.h
@@ -633,6 +633,7 @@ struct ace_skb
  */
 struct ace_private
 {
+       struct net_device       *ndev;          /* backpointer */
        struct ace_info         *info;
        struct ace_regs __iomem *regs;          /* register base */
        struct ace_skb          *skb;
@@ -776,7 +777,7 @@ static int ace_open(struct net_device *dev);
 static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
                                  struct net_device *dev);
 static int ace_close(struct net_device *dev);
-static void ace_tasklet(unsigned long dev);
+static void ace_tasklet(struct tasklet_struct *t);
 static void ace_dump_trace(struct ace_private *ap);
 static void ace_set_multicast_list(struct net_device *dev);
 static int ace_change_mtu(struct net_device *dev, int new_mtu);

Let me know what you think.

Thanks.
