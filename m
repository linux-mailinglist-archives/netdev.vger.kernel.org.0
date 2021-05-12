Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDFE37B435
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 04:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhELCmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 22:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhELCmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 22:42:16 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A11C061761;
        Tue, 11 May 2021 19:39:51 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id e11so14165068ljn.13;
        Tue, 11 May 2021 19:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BZrN9CKOIbxr+u9v7iLlbrVLgfzLx8ReH7EGaaO9x1I=;
        b=lbLifQDNCpqVolfi042QXh5WuwbLtkYvVO4+OKYLT1ZYeN0GZPdt6v0ZC01Ycp/AbC
         yJCUY6OLXls/8Uo/drc0huwWw41jxoKhZdjhuuZWpNteeOaTFUIVMHloI2IED1SmrhdV
         y7jdjA8mhzAA0tplfiMoCbYSeGmGJ0Ys28mA/qD0nWsVX8fTVdVWbfQKwfmRdrlINyvp
         xJl5DhqcNUqolDr56E6xNuBMzjpqsmpIpAZbKbVqCsM5SqJQ9Yiq/C5HPbEWpxn+4Fjl
         X3cDGlA0f9Sj+HiLpKZf9pnh5XDHEEx48gDlUj7bwlbmzWRqChr++rsGHefWQ/Rmnkzj
         iKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZrN9CKOIbxr+u9v7iLlbrVLgfzLx8ReH7EGaaO9x1I=;
        b=kpRqdX8tDZCzUxcaL/ZWuaagOnE4yhAkOzj9DoCmcht0xOGQpBWJ3OU+25UGvfodex
         IFlAvi/7Z74C1g8DOqzPy3UvTnudlxKKSFa8uy1+csgyohJfMSTc1EOP/U913V/SSe2T
         zlr2ziIEqYzfe7h9C5492oz502kjcWdBblVnBKNUHCUDO5tKkvJxvGu9xQQQQ/b8Ocj6
         QSsuGAaePjvFbMTMy1aXpoCjT2Z4b/Eiz8UnLxYiEy6e/wworuAPto8j+kPtjJ5JGNCm
         WyXRFgjbsl9K2jPSIjESLtZ3xpyEraCHiYWOx2d9joWOIsEs0vo0wvw6BRFzp1pHa+49
         YAGg==
X-Gm-Message-State: AOAM531z3vnP5a5AUnQt3bT/lNY5369A/3WBk1Vxv04UgDGzmjwLskXX
        jUXscNn3fYFEcRzcAZxPjJLAD3u7U7bmK4jxdI4=
X-Google-Smtp-Source: ABdhPJwUNWoD0sHexnPdDFMVCMFGnuaVCaQuZqImmT6XeZa5ItR8WaL/uitw2bleALjA3lJb1ACEe7B+DMbmJxgwQNg=
X-Received: by 2002:a2e:a606:: with SMTP id v6mr27851429ljp.289.1620787189542;
 Tue, 11 May 2021 19:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210511190518.8901-1-gatis@mikrotik.com> <20210511190518.8901-3-gatis@mikrotik.com>
In-Reply-To: <20210511190518.8901-3-gatis@mikrotik.com>
From:   Chris Snook <chris.snook@gmail.com>
Date:   Tue, 11 May 2021 19:39:38 -0700
Message-ID: <CAMXMK6tkPYLLQzq65uFVd-aCWaVHSne16MBEo7o6fGDTDA0rpw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] atl1c: improve performance by avoiding
 unnecessary pcie writes on xmit
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increases in latency tend to hurt more on single-queue devices. Has
this been tested on the original gigabit atl1c?

- Chris

On Tue, May 11, 2021 at 12:05 PM Gatis Peisenieks <gatis@mikrotik.com> wrote:
>
> The kernel has xmit_more facility that hints the networking driver xmit
> path about whether more packets are coming soon. This information can be
> used to avoid unnecessary expensive PCIe transaction per tx packet at a
> slight increase in latency.
>
> Max TX pps on Mikrotik 10/25G NIC in a Threadripper 3960X system
> improved from 1150Kpps to 1700Kpps.
>
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 28c30d5288e4..2a8ab51b0ed9 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2211,8 +2211,8 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
>         return -1;
>  }
>
> -static void atl1c_tx_queue(struct atl1c_adapter *adapter, struct sk_buff *skb,
> -                          struct atl1c_tpd_desc *tpd, enum atl1c_trans_queue type)
> +static void atl1c_tx_queue(struct atl1c_adapter *adapter,
> +                          enum atl1c_trans_queue type)
>  {
>         struct atl1c_tpd_ring *tpd_ring = &adapter->tpd_ring[type];
>         u16 reg;
> @@ -2238,6 +2238,7 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>
>         if (atl1c_tpd_avail(adapter, type) < tpd_req) {
>                 /* no enough descriptor, just stop queue */
> +               atl1c_tx_queue(adapter, type);
>                 netif_stop_queue(netdev);
>                 return NETDEV_TX_BUSY;
>         }
> @@ -2246,6 +2247,7 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>
>         /* do TSO and check sum */
>         if (atl1c_tso_csum(adapter, skb, &tpd, type) != 0) {
> +               atl1c_tx_queue(adapter, type);
>                 dev_kfree_skb_any(skb);
>                 return NETDEV_TX_OK;
>         }
> @@ -2270,8 +2272,11 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>                 atl1c_tx_rollback(adapter, tpd, type);
>                 dev_kfree_skb_any(skb);
>         } else {
> -               netdev_sent_queue(adapter->netdev, skb->len);
> -               atl1c_tx_queue(adapter, skb, tpd, type);
> +               bool more = netdev_xmit_more();
> +
> +               __netdev_sent_queue(adapter->netdev, skb->len, more);
> +               if (!more)
> +                       atl1c_tx_queue(adapter, type);
>         }
>
>         return NETDEV_TX_OK;
> --
> 2.31.1
>
