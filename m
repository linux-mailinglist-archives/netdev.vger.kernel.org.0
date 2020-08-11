Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151AF2422B3
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 01:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgHKXDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 19:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHKXDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 19:03:03 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBB4C06174A;
        Tue, 11 Aug 2020 16:03:03 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y18so37818ilp.10;
        Tue, 11 Aug 2020 16:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QQI+D9apjuGTk7RqRIkrIxzr1ODPo5dCRfIgzB3j/pE=;
        b=izB3B4ocv4H8XIdypDbeaBhizopoZWB683/KBMpD7isRWQ4VKUDjm4XUbO1h2OojEd
         iCtDu5YutliTUYoxaDjNF1r7S/TNFFOUoItxRPnEFT4xH3QFa84pasHvBslnHD/LpSgL
         0dO1rDY9WBKW9gKkZ/MVTzbbhIYUmCrB2JBl15ocZmB8CFV/49ci4Y0rGxN+YmBB8IOC
         9+SXufMagopOFi+5woxe4Ur+/BzjscZ0oYl5XZCELyK6XLHnSpd81NVR/JEV5P4xTLjg
         9ASNIA9xFnk/e8K2Ne/N07Y187bwVlQBNxro5Ranw1XVZuOKC4yhRfw7GwRBZtPjWBMZ
         tAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QQI+D9apjuGTk7RqRIkrIxzr1ODPo5dCRfIgzB3j/pE=;
        b=bvODhmKI30swb5GAY5tPJBRE7RvLqBLbxt2FBajPq/S/8Qc6xW6AkLlDt9OVS00iAA
         5zLFOjQXcsgGom/VW+4asJ77BzqHKAV15og2Gbn0as8yttejZERSPfK2l3B/bKHV6RcB
         ez21BFd1Tvhag+VSIiKnRMCQ/RG2MfheHr9ccLZvLsrmZ5SRyGU1CrUQKERMEgShuLuH
         SHkPQDoxF89QAIg4fUUDCTI/OrNS/iLXxBST+6spEOU+7EGeM/7ved1MiseiU2sEsheS
         /FVu0MFc2Ux02RuHxJIz74AuqzuP34IvzUSXo9TeKC3LlMOdKwFQJmRHygC7Kn5Nt2wt
         LuAQ==
X-Gm-Message-State: AOAM532su6EmHV14qSBsvZKfC461XyYXu6c6OzlEPdhJ+TvfRg7S6MqI
        iVLFu5PboP3K6waos+JI9bg7JUFrEiBbgPL3ph01yspG
X-Google-Smtp-Source: ABdhPJz0W4lhUp4ywYkL9orfL2in8i8It0F3WoU6CTUNdhv05whtP7iWyJpNtiTxlEfFqWNJN2Mbfvn6GbBODQ/8muA=
X-Received: by 2002:a92:8b84:: with SMTP id i126mr26216996ild.238.1597186982440;
 Tue, 11 Aug 2020 16:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200810121658.54657-1-linmiaohe@huawei.com>
In-Reply-To: <20200810121658.54657-1-linmiaohe@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 Aug 2020 16:02:51 -0700
Message-ID: <CAM_iQpW6R5=J0VPwNimOLJRrhwUh--aknpbksizzs0o6Q-gxFA@mail.gmail.com>
Subject: Re: [PATCH] net: Fix potential memory leak in proto_register()
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Kees Cook <keescook@chromium.org>, zhang.lin16@zte.com.cn,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 5:19 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>
> If we failed to assign proto idx, we free the twsk_slab_name but forget to
> free the twsk_slab. Add a helper function tw_prot_cleanup() to free these
> together and also use this helper function in proto_unregister().
>
> Fixes: b45ce32135d1 ("sock: fix potential memory leak in proto_register()")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/core/sock.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 49cd5ffe673e..c9083ad44ea1 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3406,6 +3406,16 @@ static void sock_inuse_add(struct net *net, int val)
>  }
>  #endif
>
> +static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot)
> +{
> +       if (!twsk_prot)
> +               return;
> +       kfree(twsk_prot->twsk_slab_name);
> +       twsk_prot->twsk_slab_name = NULL;
> +       kmem_cache_destroy(twsk_prot->twsk_slab);

Hmm, are you sure you can free the kmem cache name before
kmem_cache_destroy()? To me, it seems kmem_cache_destroy()
frees the name via slab_kmem_cache_release() via kfree_const().
With your patch, we have a double-free on the name?

Or am I missing anything?

Thanks.
