Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B4F2B25F6
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgKMUy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgKMUyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:54:25 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34261C0617A6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:25 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id t11so12281381edj.13
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5rQJ8Zivr+ADxZ9d4wLHPAMzU5Jegx9FQeksFM+wje8=;
        b=mIlVor2HKWWsuQb3+Bkhjo70BliTh90H6AT+AXTAFAoguY12Ipr6Wea9L0qq4eHVz2
         D3S02iG17F6X/cxhRvLia32SDAgg1WDKVkNPPvHcKhm9g/+Uq7W2gvsoQKeqcB///eY1
         GM8DXvOIVju8D31WAw0zoRJALkbpUGnaWuZSH8UzNso2rh7KhtX9HTXweiWkajmn7Z3k
         voEK8JvEPB8HjZbvK2nAU5L9Or/kt7RaeYwPxkNu+Z6GzYx5fS40a4aabnxWSEp89Fd3
         1g8ZdYQXcDx1UJReM+BqTF/5+1yTIos0fBOvo/IdEqN0GMR9dOOz3QRY+YCwA6bxQ+lp
         Dqgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5rQJ8Zivr+ADxZ9d4wLHPAMzU5Jegx9FQeksFM+wje8=;
        b=VyKcQ9sK6MrmuAYq715uVPjm0yPu2pyvHZLD1ks+QLGuqAB8CzlU64a6BXEV4FaRHu
         22SQRoFFxvm8RZvrMvuOV6adkNe92/zLtGVJXpkaPZKB1K8kZfetLyIoWP7SUV41l2TK
         j6i0Jp3/4iknYvysUh/bPb8Ek5c6N1ltFTnF2/ThfonTSm/jeFGv5ACMwtKGlL8aByxg
         oGaLt9UshOi7fixjn4MK+Hg17Tc9WbQzXg2mL5FfUdJPzGUA9swmvZLGEs0bkPRsOnt+
         vYbnOS/Lrh4Qnoakrhhz/YFUWHVML8m1cQ6kt3O/VYSy0is5I/XCrKJs7Xl8AQTbKaJi
         DeJw==
X-Gm-Message-State: AOAM533W/eo6e3RKcfjrcDFbqEnEW0iXAQRYe82n/KDv37POOkq3TwsG
        1tQ4Cwjyhdt1QGGKKePTfiJzb6+u2EMf01Poy1wyYBGXHl4=
X-Google-Smtp-Source: ABdhPJx1s8phjyoXjTb35KkvZc75MK2Ukmz7+A9poKzS0Sy9hGxQOc9Ogf7xiGD96ZKM6mTcucOn797xuf8wJjfxpRs=
X-Received: by 2002:aa7:df81:: with SMTP id b1mr4379400edy.365.1605300863914;
 Fri, 13 Nov 2020 12:54:23 -0800 (PST)
MIME-Version: 1.0
References: <20200922214112.19591-1-hauke@hauke-m.de> <20200923.180140.957870805702877808.davem@davemloft.net>
In-Reply-To: <20200923.180140.957870805702877808.davem@davemloft.net>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 13 Nov 2020 21:54:13 +0100
Message-ID: <CAFBinCA8qOhVPeLDugs4pvXsEOfC8V5jbPmgP_qZUjQdGG-NgQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: lantiq: Add locking for TX DMA channel
To:     David Miller <davem@davemloft.net>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, kuba@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 3:01 AM David Miller <davem@davemloft.net> wrote:
>
> From: Hauke Mehrtens <hauke@hauke-m.de>
> Date: Tue, 22 Sep 2020 23:41:12 +0200
>
> > The TX DMA channel data is accessed by the xrx200_start_xmit() and the
> > xrx200_tx_housekeeping() function from different threads. Make sure the
> > accesses are synchronized by acquiring the netif_tx_lock() in the
> > xrx200_tx_housekeeping() function too. This lock is acquired by the
> > kernel before calling xrx200_start_xmit().
> >
> > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>
> Applied [...]
what is the procedure to have this patch included in the 5.4 and 5.9
-stable trees as well?
this commit is already in mainline as f9317ae5523f99999fb54c513ebabbb2bc887ddf

After more testing other users have confirmed that this patch works
In hindsight it should have carried Fixes: fe1a56420cf2ec ("net:
lantiq: Add Lantiq / Intel VRX200 Ethernet driver")


Thank you!
Martin
