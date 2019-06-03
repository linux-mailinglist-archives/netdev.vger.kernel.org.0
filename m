Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8868232A1C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 09:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfFCHyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 03:54:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37394 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfFCHyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 03:54:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so1684698wmg.2;
        Mon, 03 Jun 2019 00:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vxn++X6GnNn7FvRm2GLwCr6U91lHVxlpb9LxLQUYoh8=;
        b=UaA55vFXUfkwbZG1fE7WZ3BEU/NRz3EniJlHgVBM/EDOoI+hIjRj09/ae1Pl4bHi9b
         Rh0+ZR+hWmbGNRI24pI29x0wGunvVOsLfbNgkJk1kzx3SVl/klB+IuEyzfp2oY9s9zdF
         wm5ciRxDVw12GbJ0SfU8YpQl27uoRnFxeaTv4RDr+3Q6F5bf38Oy0djTORRtPA55Q7lr
         gSJut3+7O3lkELl0qvFS87+AMZQT7i2zBlBXZzjBJJJvIXo7bk1/0mdRz4ZURgGMvLmM
         IwJdpJ1NpWDp3CdNKNjR0BlaCg5N0atpWN838Y0INAuA8kHuEqYRCBKVDqszMJshdVZK
         nNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vxn++X6GnNn7FvRm2GLwCr6U91lHVxlpb9LxLQUYoh8=;
        b=DtaPX48hcQUlYuEWXkdpz07zcSieDaVGpViYuavlSEr9IoqXFLcE1hk+chnkAp+a2b
         pcDbxBNPzb9nl34tfEbu1QHm3zl5cJj+qc4XL3xCKA5bI76vznHNUqm7KB7si5HcNbcK
         ptEsHLks/AdjSRzIfgMP9oDv33h1rgmPcckXhseklSDL2lF9Oa1F4+xg9f8ZAG2h1384
         rmqRuqGqQoaZApv/w2CFezjL7e8YbGJ/ksHgWZAg9zaB3nkcYAcrZbH6EhXn9AV3e5vo
         7jgnvAJzhhMM3ZXPWneOhaicACKId+wrBsHA2y82s2AWycSdholsj/bm/Xmm2EgOBIZu
         8cqA==
X-Gm-Message-State: APjAAAWCNnvc4Oky1BFdRnsLrPC6Y1SrkAiWIWAVLM/rgrdO42Hg9KN+
        CzOB06m+Le335o2fd9JdsYEmrmIhPmwxj9TbZeU=
X-Google-Smtp-Source: APXvYqw9kMPf+INXeMqlOFlFgNgw0nEIS42SjTDd0sxR9d2hrhqUuyp/FltCIycXfO33ebmylOwNZSqfjQ0mSG0kHZc=
X-Received: by 2002:a1c:eb16:: with SMTP id j22mr1122553wmh.56.1559548447660;
 Mon, 03 Jun 2019 00:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <1559532216-12114-1-git-send-email-92siuyang@gmail.com>
In-Reply-To: <1559532216-12114-1-git-send-email-92siuyang@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 3 Jun 2019 15:53:56 +0800
Message-ID: <CADvbK_eUYhP=pSLqHdBp8E3-NJP28=jErSSvW5moO9WVK=X8XQ@mail.gmail.com>
Subject: Re: [PATCH] ipvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.
To:     Young Xiao <92siuyang@gmail.com>
Cc:     davem <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, petrm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com, uehaibing@huawei.com,
        Hangbin Liu <liuhangbin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 11:22 AM Young Xiao <92siuyang@gmail.com> wrote:
>
> Clearing the IFF_ALLMULTI flag on a down interface could cause an allmulti
> overflow on the underlying interface.
>
> Attempting the set IFF_ALLMULTI on the underlying interface would cause an
> error and the log message:
>
> "allmulti touches root, set allmulti failed."
s/root/roof

I guess this patch was inspired by:

commit bbeb0eadcf9fe74fb2b9b1a6fea82cd538b1e556
Author: Peter Christensen <pch@ordbogen.com>
Date:   Thu May 8 11:15:37 2014 +0200

    macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

I could trigger this error on macvlan prior to this patch with:

  # ip link add mymacvlan1 link eth2 type macvlan mode bridge
  # ip link set mymacvlan1 up
  # ip link set mymacvlan1 allmulticast on
  # ip link set mymacvlan1 down
  # ip link set mymacvlan1 allmulticast off
  # ip link set mymacvlan1 allmulticast on

but not on ipvlan, could you?

macvlan had this problem, as lowerdev's allmulticast is cleared when doing
dev_stop and set when doing dev_open, which doesn't happen on ipvlan.

So I'd think this patch fixes nothing unless you want to add
dev_set_allmulti(1/-1) in ipvlan_open/stop(), but that's another topic.

did I miss something?

>
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index bbeb162..523bb83 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -242,8 +242,10 @@ static void ipvlan_change_rx_flags(struct net_device *dev, int change)
>         struct ipvl_dev *ipvlan = netdev_priv(dev);
>         struct net_device *phy_dev = ipvlan->phy_dev;
>
> -       if (change & IFF_ALLMULTI)
> -               dev_set_allmulti(phy_dev, dev->flags & IFF_ALLMULTI? 1 : -1);
> +       if (dev->flags & IFF_UP) {
> +               if (change & IFF_ALLMULTI)
> +                       dev_set_allmulti(phy_dev, dev->flags & IFF_ALLMULTI ? 1 : -1);
> +       }
>  }
>
>  static void ipvlan_set_multicast_mac_filter(struct net_device *dev)
> --
> 2.7.4
>
