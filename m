Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6002EEF90
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbhAHJ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbhAHJ0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:26:35 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E8FC0612F8
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:25:55 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id y13so1667877ilm.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JJPXlq5r6kmJ9tmwIciSJ/jy5n+AhqM308ZXWIW30M=;
        b=D47lKCZYjYroRoNzd+16Yh/kEJ0twoiXZMIrSoTTE7Qm6jB+9m/VFALjOZXr9Q7D6r
         y86/0hLqhmKa9J7RWWLBBxy/+XiiYZVgZlUGZ1g1+plYYrDX/rontDNzOZoRamNBhA09
         uWKS4em1hjF0W7+1oNtFtrVy93JBUKZTCdfA6ut2RZ+E2MkuliaMFfV23ZHUgDgJU9fy
         O7h5Xw/AMz8CPyoynxNf2zivMZOF3OEnFa31ZBMZgO3Q2V5Pq09prbgks+i8les+HxWm
         +smS/cgRgyhZn7ySdeuYe8hCiZv7dkZ3eet35gDjY6abG6OyvT3dYpUvlOPx4EeUVIwY
         IY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JJPXlq5r6kmJ9tmwIciSJ/jy5n+AhqM308ZXWIW30M=;
        b=LLiJKlgsBIareu4beO85Bhmm4k9jnMDrc8xmKjuU+RnXezgA4j596ktCsb+sz2hMkS
         Lpd4hcWeiyz9Za8o3hKX3+GU3zZToXyv062y54r63Sx4QmNwlGVxuC0gdc2M9QhIypBa
         ojFctczUxmEAun0qdKORaDv+LFFdiunrvyviWrw5AaMcf4yFuB6rUm5MwgfItjUhKUgN
         2L0s9uR+G8Zh+hHPOrU+wu1e344OVvrgR5rYITAT4aDyaTVMQ11VWkzTx0vNR38jdYSC
         dz68E1fl176wwNDe+QgLpMyXDzE8MwSYfjspGSAlyJCpJZVqmsUq9kcxBGdrhIlECBQl
         swMQ==
X-Gm-Message-State: AOAM532+yOolYWuYuCEM4p/2Pj0dUCNuggebKnc5R6lynxx80pAbeBLM
        f3rMjgmbbqFs7VQOCoQEH+3fsEMZ37+aGvwJUENabw==
X-Google-Smtp-Source: ABdhPJxsPixqtwwnvlmnKvcMNRDE4QV0qctqi+7HWVM2nolb+Qc0fMZnHgYR30aSear8HP9jSUQXJR72pzTqcxt2vfQ=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr3048560ili.205.1610097954232;
 Fri, 08 Jan 2021 01:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com> <20210106215539.2103688-2-jesse.brandeburg@intel.com>
In-Reply-To: <20210106215539.2103688-2-jesse.brandeburg@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 10:25:42 +0100
Message-ID: <CANn89iLcRrmXW_MGjuMMnNxWS+kaEnY=Y79hCPuiwiDd_G9=EA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev <netdev@vger.kernel.org>, intel-wired-lan@lists.osuosl.org,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 10:56 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> When drivers call the various receive upcalls to receive an skb
> to the stack, sometimes that stack can drop the packet. The good
> news is that the return code is given to all the drivers of
> NET_RX_DROP or GRO_DROP. The bad news is that no drivers except
> the one "ice" driver that I changed, check the stat and increment
> the dropped count. This is currently leading to packets that
> arrive at the edge interface and are fully handled by the driver
> and then mysteriously disappear.
>
> Rather than fix all drivers to increment the drop stat when
> handling the return code, emulate the already existing statistic
> update for NET_RX_DROP events for the two GRO_DROP locations, and
> increment the dev->rx_dropped associated with the skb.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8fa739259041..ef34043a9550 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6071,6 +6071,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
>                 break;
>
>         case GRO_DROP:
> +               atomic_long_inc(&skb->dev->rx_dropped);
>                 kfree_skb(skb);
>                 break;
>
> @@ -6159,6 +6160,7 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
>                 break;
>
>         case GRO_DROP:
> +               atomic_long_inc(&skb->dev->rx_dropped);
>                 napi_reuse_skb(napi, skb);
>                 break;
>


This is not needed. I think we should clean up ice instead.

Drivers are supposed to have allocated the skb (using
napi_get_frags()) before calling napi_gro_frags()

Only napi_gro_frags() would return GRO_DROP, but we supposedly could
crash at that point, since a driver is clearly buggy.

We probably can remove GRO_DROP completely, assuming lazy drivers are fixed.

diff --git a/net/core/dev.c b/net/core/dev.c
index 8fa739259041aaa03585b5a7b8ebce862f4b7d1d..c9460c9597f1de51957fdcfc7a64ca45bce5af7c
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6223,9 +6223,6 @@ gro_result_t napi_gro_frags(struct napi_struct *napi)
        gro_result_t ret;
        struct sk_buff *skb = napi_frags_skb(napi);

-       if (!skb)
-               return GRO_DROP;
-
        trace_napi_gro_frags_entry(skb);

        ret = napi_frags_finish(napi, skb, dev_gro_receive(napi, skb));
