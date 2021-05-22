Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4521238D4B1
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 11:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhEVJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 05:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhEVJKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 05:10:21 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B55C061574
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 02:08:56 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j6so30550052lfr.11
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 02:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sjhn9KsqMSp1BoKveCdWGhZPcyNCbVQ54hN/N+Flmz8=;
        b=Sp0qZmPnH8CTgJ33JEdEZblBCd762zWSPeMta+JqnDSwHTZwla5JVt+t3WoM1BWw4a
         s9zPlv5ZbbBGPCLnFv48+SbcNwbAMU5v7QftrPcvTSRA8zH3YC8XRur+zaowkQiOIxDm
         blfo/xTPCgGjfYTfe2tsRVTMbb6u2Evs0eiT7U9MsU87tY9TgO+8LGqf5s1nMaVANKH4
         +9OYVp0EOS293bLowRM0pqFr1c2DDiVTQtXQoCSH37ZAcZnPDeuQRqNoP9+Nmd5mGq5F
         6GqjUPW2qVwRvMIcZu/i3p1FfVGUI7qJUq5ejvbvsCb3lfhEcc54hXW2/xQWJ+9x8Ubc
         WdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sjhn9KsqMSp1BoKveCdWGhZPcyNCbVQ54hN/N+Flmz8=;
        b=o97rNFDiYmp1HVvrr9AO63b4WLG6WTxkq3oO1lSYteR4lZkEcGn+4Rg61rTOBFoyhv
         S8UU+F+ojINJ0UGGRUsImXO2fU+4UMMWvuCYLRYZaGYMgM9TIL28FwTOHAJ9hUSGkkq2
         F0HP3SLLO0c3qtMC8AtFCyqEY6PRpmupfk29nUvF6MchQ8klxj3t1brCyZqnSSxhHbRy
         M0YrEPAG+4Tnz26QNx4s9Bw8+old8HK3AkhCUqz6N3vPmg1RVaE2G+2QDnTJgjm5cE3H
         wSrut9M+BMCyyqOtNc3dGhZ9VGxPzDfdPff7Yr+yMtHokyWv40eELqvTMcNulU8YUMvx
         WS/g==
X-Gm-Message-State: AOAM531eg/rP5csDxdznQaYCTBPObdqu1RcThw6FQR1c7rIEIq+Wy3nM
        nL0nlNt5IDs+7TqZz/kAG4nbszSLD6Q6Y86WLpbDCA==
X-Google-Smtp-Source: ABdhPJxtrujQjxgEQxMgSJcfpFacOYFoG42OqCexmsfy+Er336j/5/HgPfJblbT/bkMk+PuNS27xV+SMGqj60TM1/Fg=
X-Received: by 2002:ac2:5459:: with SMTP id d25mr4999478lfn.560.1621674534622;
 Sat, 22 May 2021 02:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210521124859.101012-1-zong.li@sifive.com> <b4088995-605e-85ca-2f07-47d2654ac2c8@gmail.com>
In-Reply-To: <b4088995-605e-85ca-2f07-47d2654ac2c8@gmail.com>
From:   Zong Li <zong.li@sifive.com>
Date:   Sat, 22 May 2021 17:08:44 +0800
Message-ID: <CANXhq0rQqeGO_LM233bB8Kg5XD_Q7xrtOhVrYeuCxXj29N3+Rg@mail.gmail.com>
Subject: Re: [PATCH] net: macb: ensure the device is available before
 accessing GEMGXL control registers
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Michael Turquette <mturquette@baylibre.com>,
        geert@linux-m68k.org, Yixun Lan <yixun.lan@gmail.com>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 22, 2021 at 12:51 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/21/2021 5:48 AM, Zong Li wrote:
> > If runtime power menagement is enabled, the gigabit ethernet PLL would
> > be disabled after macb_probe(). During this period of time, the system
> > would hang up if we try to access GEMGXL control registers.
> >
> > We can't put runtime_pm_get/runtime_pm_put/ there due to the issue of
> > sleep inside atomic section (7fa2955ff70ce453 ("sh_eth: Fix sleeping
> > function called from invalid context"). Add the similar flag to ensure
> > the device is available before accessing GEMGXL device.
> >
> > Signed-off-by: Zong Li <zong.li@sifive.com>
> > ---
> >  drivers/net/ethernet/cadence/macb.h      | 2 ++
> >  drivers/net/ethernet/cadence/macb_main.c | 7 +++++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> > index d8d87213697c..acf5242ce715 100644
> > --- a/drivers/net/ethernet/cadence/macb.h
> > +++ b/drivers/net/ethernet/cadence/macb.h
> > @@ -1309,6 +1309,8 @@ struct macb {
> >
> >       u32     rx_intr_mask;
> >
> > +     unsigned int is_opened;
> > +
> >       struct macb_pm_data pm_data;
> >       const struct macb_usrio_config *usrio;
> >  };
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index 6bc7d41d519b..e079ed10ad91 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -2781,6 +2781,8 @@ static int macb_open(struct net_device *dev)
> >       if (bp->ptp_info)
> >               bp->ptp_info->ptp_init(dev);
> >
> > +     bp->is_opened = 1;
> > +
> >       return 0;
> >
> >  reset_hw:
> > @@ -2818,6 +2820,8 @@ static int macb_close(struct net_device *dev)
> >       if (bp->ptp_info)
> >               bp->ptp_info->ptp_remove(dev);
> >
> > +     bp->is_opened = 0;
> > +
> >       pm_runtime_put(&bp->pdev->dev);
> >
> >       return 0;
> > @@ -2867,6 +2871,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
> >       struct gem_stats *hwstat = &bp->hw_stats.gem;
> >       struct net_device_stats *nstat = &bp->dev->stats;
> >
> > +     if (!bp->is_opened)
> > +             return nstat;
>
> The canonical way to do this check is to use netif_running(), and not
> open code a boolean tracking whether a network device is opened or not.

Yes, I have tried this and it worked. Let me change it in the next version.

> --
> Florian
