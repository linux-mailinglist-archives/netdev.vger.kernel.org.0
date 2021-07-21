Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20B63D0ADA
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 10:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbhGUIGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 04:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232239AbhGUHwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 03:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D3A60232
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626856396;
        bh=OsW20UMQzSzBemmTukwYF2tpKGz9Qmzrx9cJfp851BA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dFhDk5BGL+NRSUIflqPp+7njuwIeTcWM2Jq4wtXnED1kODxwzFUex83wwEuNWpVRj
         dtmqNph45jUzssr0UNPvZ4yBfLmuShvf6pR4/mEaPRv2pEXdy6tZAcCIWxSwYmXXkW
         udjSZk2YP9NlPRnQ8O1Kl97uZN6yn0+oBX4G1jq2tEN5MgUXraiwkLDTYhToXtaSIX
         lS74SCs+SHF9jS75Uy5IY3BOPU3nEA06ekVmKdQSza1Bs2zEqAg/Gr6/HKopuSa86E
         QefweXcluokw4XLmoacy27hEnTk0jqPZpfIFxdepV2G8kFvb1uzrN5UYzKLqN8azHX
         yhrFLy9/7vofg==
Received: by mail-wr1-f50.google.com with SMTP id i94so1240666wri.4
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 01:33:16 -0700 (PDT)
X-Gm-Message-State: AOAM533N69fGtmXs4qmOcG+cMW5Ty9Yfak3/aolY1SZhqHMqQlfLSkDz
        QI6Mil4EPC3RGn2L9MYudEtqVhzRpL6597txmmo=
X-Google-Smtp-Source: ABdhPJyAmkbKKMJpvXWxaW74bSxvWyiYOO8w0mjOM8rO/toaw6Ei40D09ex8BTCrv1QFd2yTdbECFF//pEqlawnsIUo=
X-Received: by 2002:adf:e107:: with SMTP id t7mr41417034wrz.165.1626856395180;
 Wed, 21 Jul 2021 01:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210720142436.2096733-1-arnd@kernel.org> <20210720142436.2096733-3-arnd@kernel.org>
 <20210721072847.GB11257@lst.de>
In-Reply-To: <20210721072847.GB11257@lst.de>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 21 Jul 2021 10:32:59 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3_Pv-hmDvnHgQ23Qfo8jraLSL_aTmE4ROVhvbxAU-e+Q@mail.gmail.com>
Message-ID: <CAK8P3a3_Pv-hmDvnHgQ23Qfo8jraLSL_aTmE4ROVhvbxAU-e+Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] net: socket: rework SIOC?IFMAP ioctls
To:     Christoph Hellwig <hch@lst.de>
Cc:     Networking <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 9:30 AM Christoph Hellwig <hch@lst.de> wrote:
>
> > +static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +     struct ifmap *ifmap = &ifr->ifr_map;
> > +     struct compat_ifmap *cifmap = (struct compat_ifmap *)&ifr->ifr_map;
> > +
> > +     if (in_compat_syscall()) {
>
> Any reason that the cifmap declaration is outside this conditional?

I was going for the slightly shorter version, as moving it into the block
runs into the 80-character limit. I'll change it.

> > +static int dev_setifmap(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +     struct compat_ifmap *cifmap = (struct compat_ifmap *)&ifr->ifr_map;
> > +
> > +     if (!dev->netdev_ops->ndo_set_config)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (in_compat_syscall()) {
>
> Same here.
>
> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

      Arnd
