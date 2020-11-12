Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED912AFC24
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgKLBc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbgKLBMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 20:12:12 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A4BC061A04
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 17:11:17 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id i12so2901832qtj.0
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 17:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQQ773MLU3LO8XaBMHxqexPd5CEQWRgyoO5mL30aFOw=;
        b=RBaSkk5mo93uf6SE2IEkBOJo6bct6eXqdKZJ2LtH9LuuShOHh/WQjjWlyVzEGu/44i
         cPhoCNpCQJvVoyuIlXWKKpTjYwxzSfnLGqriEYQ9TSc1MS84Bwl2EGsrm54UvYW8rDWr
         M+/wgrK3vwO8ZeO2ANEeKnA/mcNEwF+VtX+RA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQQ773MLU3LO8XaBMHxqexPd5CEQWRgyoO5mL30aFOw=;
        b=oc/0V2FEvJn1bfKbtduLBUzBe++ssm+V+wqeqrNG9CuyR9XiQY/WCfji+VhWdjrnP3
         UrvWHaWdGUUyfxak8Ocj5djiosVrj97RaF9IMkU6dtR63Kg+v2H0tFh+n1K67PhGqvFd
         7BWFM9ZO18P3Q4bNFuM2BRyWUFiQFhwA83+9HkJswQrTCB1HP1X7zihr+R0dx+kc4hIm
         gEavKYUazjgQXJJVyR6AfAVwX5igLhe1gutq3h5NCGbrnJvNfiBETlORncVF29oA7DLc
         tfc0nvNPWMbq4E2db+Hv31+4UGdZGK77gM2on0nXPeOHjUnpjeGsfCGuzXa7KJJ+o7Km
         UBSA==
X-Gm-Message-State: AOAM532w5WBvOAoj5/20DcYh5role0P33ij2vlI11PU5WpGEouTKwx06
        KiE9viisIImN2Dj8GnA/4VS2ePwmacFwyvbO536gRncY4OtGxQ==
X-Google-Smtp-Source: ABdhPJyNjR2T7Oe0RL4rbxwYywj+uTte4M8A5AP1CwcymGs285uHvzKDscsEw6W3RiWBB89J6ug95aPATMEnZQFpxhE=
X-Received: by 2002:aed:3325:: with SMTP id u34mr27146415qtd.263.1605143476860;
 Wed, 11 Nov 2020 17:11:16 -0800 (PST)
MIME-Version: 1.0
References: <20201112004021.834673-1-joel@jms.id.au> <20201111165716.760829aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111165716.760829aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 12 Nov 2020 01:11:04 +0000
Message-ID: <CACPK8Xd3MfTbp2184e6Hp7D4U40ku0vqw=pb5E7mamddMGnj3A@mail.gmail.com>
Subject: Re: [PATCH] net/ncsi: Fix re-registering ncsi device
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 at 00:57, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 12 Nov 2020 11:10:21 +1030 Joel Stanley wrote:
> > If a user unbinds and re-binds a ncsi aware driver, the kernel will
> > attempt to register the netlink interface at runtime. The structure is
> > marked __ro_after_init so this fails at this point.
>
> netlink family should be registered at module init and unregistered at
> unload. That's a better fix IMO.

I don't follow, isn't that what is implemented already?

Perhaps I'm getting confused because the systems that use this code
build the drivers in. The bug I'm seeing is when we unbind and re-bind
the driver without any module loading or unloading.
