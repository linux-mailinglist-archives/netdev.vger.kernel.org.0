Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6904911DC
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 23:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243658AbiAQWoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 17:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237619AbiAQWoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 17:44:02 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5994FC061574;
        Mon, 17 Jan 2022 14:44:02 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id g81-20020a1c9d54000000b0034cd1acd9b5so1376696wme.1;
        Mon, 17 Jan 2022 14:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wao4zNgGs9ZKNZbt2qayI01/XFGowYUKQrNSetaj2LY=;
        b=A/aSkySXAtUPt4vln9q5nyQym03kwx5QcKNTPHqtQOHVJN7raMjYotqF2qbi4m/OwT
         1L6PkFG6xqWGPrXGYBL1upiG2I6hY1sL4NJrQOuyrhBrHaW2UJ8+2Y5i9DW3y/nL/oWe
         ukWqlshoX1xETKh7m+dEFZrYLjqBoBxjvvfvQoNqsJIV1Q6YcyAs0EoDDXaLrJiKgIWM
         1U2da+2M+aud/sCSJ3uAvl1JlcbryUZBkw/bvevD1V8K3fRBCD9yzybF+nCyMV3PalyV
         6eYz6/2lhAlZfFk1N2kvZ4//i3QmcfuH82U3+nDvrtOT3ZVFyuis/dML8e8ALejhBa48
         I02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wao4zNgGs9ZKNZbt2qayI01/XFGowYUKQrNSetaj2LY=;
        b=CzPbnvsyI8/xrLhHlHJWFbBv176JDzdOx+aQwY7/6ZU1RteOq9KWiCysNE7v+SU3BZ
         JBNfpoEnaj144EsKkuL5UfN+0p0oEwPhQ7QPIYKOBcp6tDyqM2QftkCJxS9FGunqLTov
         hMtVqc66cwcxinH6eW3cOjW1JvY4g0rxpO4qHkkGn0AFDuU8JSXBAcoj16Rm78bZaVHG
         VAzKqXmsliELE8bLrvR4K4LjjVbLSuqv4Moqu1ITVWbn+KmSu0gWCMkT1N9c2yRnIva9
         3WprJk0RgOR2KDCKVXI3J19k0CTjvtlAH6b87GXM3aKO/oI342WmoWn6AAefBe/bRRu5
         MbXg==
X-Gm-Message-State: AOAM533Zd87IrXT99C1KA4/z0AHUZSBN8mrqsqU3ymJ+ZVFbpjS52aHO
        +FqEobSRrR2QY/mTy9Wh12h0hTyv8IX37rfqY5k=
X-Google-Smtp-Source: ABdhPJyL58sAM8T6BbJ0TLFb0ZO9PYpAbLLBdRpgLkUDdtCXsSmV+4YUzHFTzOjz55/alteSgytrzoytPY/YNqLRCwU=
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr29835529wmh.185.1642459441022;
 Mon, 17 Jan 2022 14:44:01 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com> <20220117115440.60296-28-miquel.raynal@bootlin.com>
In-Reply-To: <20220117115440.60296-28-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 17:43:49 -0500
Message-ID: <CAB_54W562uzk3NzXDTgRLbQzi=hgQDntJOqmMDVZwaJ_eDZZMQ@mail.gmail.com>
Subject: Re: [PATCH v3 27/41] net: mac802154: Introduce a tx queue flushing mechanism
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
>
>         /* stop hardware - this must stop RX */
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index 0291e49058f2..37d5438fdb3f 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
>
>  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
>  void ieee802154_xmit_sync_worker(struct work_struct *work);
> +void ieee802154_sync_tx(struct ieee802154_local *local);
>  netdev_tx_t
>  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  netdev_tx_t
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index de5ecda80472..d1fd2cc67cbe 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -48,6 +48,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
>
>         kfree_skb(skb);
>         atomic_dec(&local->phy->ongoing_txs);
> +       wake_up(&local->phy->sync_txq);

if (atomic_dec_and_test(&hw->phy->ongoing_txs))
      wake_up(&hw->phy->sync_txq);

>         netdev_dbg(dev, "transmission failed\n");
>  }
>
> @@ -117,6 +118,11 @@ ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
>         return ieee802154_tx(local, skb);
>  }
>
> +void ieee802154_sync_tx(struct ieee802154_local *local)
> +{
> +       wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongoing_txs));
> +}
> +
>  netdev_tx_t
>  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
> diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> index db2ac53b937e..230fe3390df7 100644
> --- a/net/mac802154/util.c
> +++ b/net/mac802154/util.c
> @@ -90,6 +90,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
>  after_wakeup:
>         dev_consume_skb_any(skb);
>         atomic_dec(&hw->phy->ongoing_txs);
> +       wake_up(&hw->phy->sync_txq);

if (atomic_dec_and_test(&hw->phy->ongoing_txs))
      wake_up(&hw->phy->sync_txq);

- Alex
