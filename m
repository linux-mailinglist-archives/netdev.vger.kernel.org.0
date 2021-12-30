Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1FD482043
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbhL3U1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242088AbhL3U1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:27:53 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DD7C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:27:53 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id t14so13861785ljh.8
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mePHYITDtfghfro4MGNRwq65ErOjyrNYu53NHeXUCx8=;
        b=lhdKOrbqh+6t+h27KSv6Oxtq8wcJJBRjWRqDGIAmILOq1Jj8KI654Iv7Q/7be19vlS
         Y8GcrtM7eDBOFRI5BNu78LgsCs8m4L99T5NlXjs4kB2kQbH6tLCIBMuPDGcb+WeE/ocC
         JknMHA2mtOnI5gZsLB4+LqOssi2/Pkhg49QMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mePHYITDtfghfro4MGNRwq65ErOjyrNYu53NHeXUCx8=;
        b=4RAGosKcyXpf6BjZ9b19iTOmeXHlatcfFMx+jE8k9AddB2Z8v3h/t0VqdgIbt4lr+U
         9oqsAyg3ZFlPXuzxjHrisdSJd8xdNy9DuMyI0IEnEhCUpohkYqklrrqMJUCc+9XvSJrq
         PY2x6MNYxWYlw+XG05VdVCW2nbVGLFSkJkjpe+YOIshijGZLvz7cjkVwvYX8gPNpxUej
         1iDSUeGn+MM55TKPURlojl+IAOlfucioziFxJBfeCz6Tls8jFJHowcJ+FeSq0LKMNo1e
         L1Ynk4w5CkfCORABpEs+c4BCyG9udrjJ8cgzh18OElIL4vOH2nqWRnc8UiCrPyrftnbZ
         NWNg==
X-Gm-Message-State: AOAM5310Eo3F39fWLxOH05xEGYm/N0fMN76Ks8ZAG6CA8XYE+ChuATb6
        NA7Pzqw3OMO/R2kbYqModCD2LYRwXG0xl2fRSPX6Wg==
X-Google-Smtp-Source: ABdhPJwGW8razltUiCWZZ9k4++59t1PmHN3Vc/h9CmmDYgdVJtfWzLQMCJoMZdg2+Ye9qO67coEIJaWZGPnMdQr0OrI=
X-Received: by 2002:a2e:a4d2:: with SMTP id p18mr26781652ljm.471.1640896071195;
 Thu, 30 Dec 2021 12:27:51 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com> <Yc30mG7tPQIT2HZK@lunn.ch>
In-Reply-To: <Yc30mG7tPQIT2HZK@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 12:27:38 -0800
Message-ID: <CAOkoqZk0O0NidoHuAf4Qbp3e35P7jbPKMYXS=56XWgMx1BceYg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 10:04 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static void fun_get_pauseparam(struct net_device *netdev,
> > +                            struct ethtool_pauseparam *pause)
> > +{
> > +     const struct funeth_priv *fp = netdev_priv(netdev);
> > +     u8 active_pause = fp->active_fc;
> > +
> > +     pause->rx_pause = active_pause & FUN_PORT_CAP_RX_PAUSE;
> > +     pause->tx_pause = active_pause & FUN_PORT_CAP_TX_PAUSE;
> > +     pause->autoneg = !!(fp->advertising & FUN_PORT_CAP_AUTONEG);
> > +}
> > +
> > +static int fun_set_pauseparam(struct net_device *netdev,
> > +                           struct ethtool_pauseparam *pause)
> > +{
> > +     struct funeth_priv *fp = netdev_priv(netdev);
> > +     u64 new_advert;
> > +
> > +     if (fp->port_caps & FUN_PORT_CAP_VPORT)
> > +             return -EOPNOTSUPP;
> > +     if (pause->autoneg && !(fp->advertising & FUN_PORT_CAP_AUTONEG))
> > +             return -EINVAL;
> > +     if (pause->tx_pause & !(fp->port_caps & FUN_PORT_CAP_TX_PAUSE))
> > +             return -EINVAL;
> > +     if (pause->rx_pause & !(fp->port_caps & FUN_PORT_CAP_RX_PAUSE))
> > +             return -EINVAL;
> > +
>
> I _think_ this is wrong. pause->autoneg means we are autoneg'ing
> pause, not that we are using auto-neg in general. The user can have
> autoneg turned on, but force pause by setting pause->autoneg to False.
> In that case, the pause->rx_pause and pause->tx_pause are given direct
> to the MAC, not auto negotiated.

Having this mixed mode needs device FW support, which isn't there today.
If you force pause, then the link flaps and negotiates FW will apply the new
negotiated settings. For your scenario you'd want it to support only partial
application. Meanwhile the partner doesn't know we don't obey the negotiated
settings so I am suspicious that all of this would work.

>
> > +static void fun_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> > +{
> > +     wol->supported = 0;
> > +     wol->wolopts = 0;
> > +}
>
> Not required. If you don't provide the callback, the core will return
> -EOPNOTSUPP.

OK

>
> > +static void fun_get_drvinfo(struct net_device *netdev,
> > +                         struct ethtool_drvinfo *info)
> > +{
> > +     const struct funeth_priv *fp = netdev_priv(netdev);
> > +
> > +     strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> > +     strcpy(info->fw_version, "N/A");
>
> Don't set it, if you have nothing useful to put in it.

OK

>
>       Andrew
