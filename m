Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2840E3A4EE7
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhFLMl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:41:56 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:42694 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLMl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:41:56 -0400
Received: by mail-wm1-f43.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso10129457wms.1;
        Sat, 12 Jun 2021 05:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wATO3SBIvcHH5zKCoztgf7hTtPEc8pIrXiwcM0mnpqs=;
        b=OK1SUX1TOjQQpyQgo4pmvkfbxVR2Zd5nIEsOWPIseXa0JLb3MRjFQBWV4iLCK1yDWP
         VFoXklRs8RpO/GRHvabmSa61TawAtml+5dfE9fb7toQjAjeJnG+acNrdDoXCgTM3UgQM
         bPBjCr82ej8L/tlZ8GX14GMgV9MNavaF4VKhYjHsvRn55TervHd4GmclDHJyC3lHOlaG
         PxLvmiAX+NGHmQV/W1uxuLMTS/bE7qcNs3TWOBlL6EgHa5ylUe499JOVarBLKSJ2et5U
         heeX3xulVp4yXrKgO5K93DWGXQM99Pr6IJbQZypWvuIIV/E6D39Q/i8Dxi9ub67ZpXfN
         KAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wATO3SBIvcHH5zKCoztgf7hTtPEc8pIrXiwcM0mnpqs=;
        b=lHiUU+7oV1r0dH+IkGbmIXrKmYgPaB1cydo+z/3fCpHk2V5h5hJkMDIGHDVLDDxJ3Q
         DFAoop+1RphA1CUKzQ5Ewg5s8HwGaD2X9aNp883ImbtQFwB80YcsGG6RdpcsUMiCA8tm
         wI4nFtmft1be6SrOKBAkQKrFbLs9M/AjekdGaNTxGTybTksH/PgAeTxglk9h7sXSCNVp
         BGCxEkWgF8pd4skcLZZg9wOlOcaFfvQ2HbHXKSXBYnf3gIvu9vaB6TmBb1TjcUoB3T45
         sj1+dlzY3ctlJKBJLRrmVT8n6STY058HSlmtFogqE5dHPc6vzpAjBGofZYkr4wk18r6C
         UBCg==
X-Gm-Message-State: AOAM531jVl8njZIfL0kRY3ONN0uyQRxX0u1/4HMKUIj4t9QWQD92rfcS
        xlD+GDuBwnUJU7dWLJQ9DdVp8ryO2/lUqJyH3Cs=
X-Google-Smtp-Source: ABdhPJw1k3oLECkOwrb2mi+jgLs5kQCXkmSXHEQOjtL/SYfz6lF2Vy2r9IM1+fho6fILVSszLIt6t/aa6gEOqEsiJKk=
X-Received: by 2002:a05:600c:4ec8:: with SMTP id g8mr24368436wmq.62.1623501535722;
 Sat, 12 Jun 2021 05:38:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210611015812.1626999-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210611015812.1626999-1-mudongliangabcd@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sat, 12 Jun 2021 08:38:44 -0400
Message-ID: <CAB_54W4akfaXse1KRO0oomh5i66wO5rUVZ28h2_PM9CSqNsHtA@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 10 Jun 2021 at 21:58, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> In hwsim_subscribe_all_others, the error handling code performs
> incorrectly if the second hwsim_alloc_edge fails. When this issue occurs,
> it goes to sub_fail, without cleaning the edges allocated before.
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index da9135231c07..366eaae3550a 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -715,6 +715,8 @@ static int hwsim_subscribe_all_others(struct hwsim_phy *phy)
>
>         return 0;
>
> +sub_fail:
> +       hwsim_edge_unsubscribe_me(phy);
>  me_fail:
>         rcu_read_lock();
>         list_for_each_entry_rcu(e, &phy->edges, list) {
> @@ -722,8 +724,6 @@ static int hwsim_subscribe_all_others(struct hwsim_phy *phy)
>                 hwsim_free_edge(e);
>         }
>         rcu_read_unlock();
> -sub_fail:

this goto needs to be removed and all goto cases need to end in
me_fail (better named to be fail only).
In an error case both loops need to be iterated again to cleanup.

- Alex
