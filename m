Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B4155C50C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiF0JBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 05:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiF0JBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 05:01:20 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386AC6393
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 02:01:19 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g4so4040300ybg.9
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 02:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sE+c2xBowUT0oZC9mJQkDcVYUMmhR1gbqrppxK7hGZQ=;
        b=EaOtpJG1VTk5K3EQ8AGM1DheeW112pL2+D/Ji/GXydUHnQIKmMQLm+7mzEy7kIf53Q
         c2I6VJbLQe4LotUrbFCadEldgNY4qPzYukLrtw2PVBXDVhU1iE/+8rEKzz5jseLHlIaf
         0uBVTbd9scAsRleKLjLYPlvZwLGUmLMLRVVEOeOvy2cGhWp4hdkWqVEHf3E3298mBfwk
         9UpU7jrIASTXhXWU+2qQqPYxxvECCKgpbCdV23BNSmv7eH1QXqT9v5Th05TgAhrc0wGL
         21LHUj7KowEgMCZsU9/on9bNp9y5C/0t7P69JhvFswJu6eyRIEtN4htNMP7aARHEBzDy
         j/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sE+c2xBowUT0oZC9mJQkDcVYUMmhR1gbqrppxK7hGZQ=;
        b=SALIvJG0Br7OFV+gcm7EvHfh0mEsrfxzSrLLZkGGi3o725NnSkTFyo0th3A6Mb7VHp
         Jr5qbC3ZwGzTRc3zEasgzublhfE7Lpq6iOyqex1wec+LgP9wmcIckiJP2nuqKDgWe+d9
         ZoOX2st53iay4Vhh9aTEr6t4pReut2dRBtE06wHHRpTUjCqemR3p366URkAD+eb75qOv
         V0pqGVarpc6c5WIr2FyKCqQNL/bhOZ9Z6z9seuOxhvrlTAkrStWUPffcw6BKlzz43kpP
         q+S8lRCDotb29Ub/5RyqH2vKHncx/5kFAyF+smV6mWwa2Y8z6FGGY1wKd4uILx0ozfea
         kwjA==
X-Gm-Message-State: AJIora95cwIqPVuG5dOhLE52xZ2SU6Mn0GnVp3OgGAzmL6pp+EUbBtxa
        64hmsxJqpnKJWzxZ1S9Lp3SuqTGaQu4VjwlsJqA/Lw==
X-Google-Smtp-Source: AGRyM1vf0ubueZoJ427sMdcLnwQLYRPIcHlV/NXtwe2cG4KgWMgSwQBjg2vI+ToQ9/fKNI+vfmY3XB6b6+sUaXEMyM4=
X-Received: by 2002:a25:3383:0:b0:66b:6205:1583 with SMTP id
 z125-20020a253383000000b0066b62051583mr12237480ybz.387.1656320478104; Mon, 27
 Jun 2022 02:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220625054524.2445867-1-zys.zljxml@gmail.com>
In-Reply-To: <20220625054524.2445867-1-zys.zljxml@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 11:01:07 +0200
Message-ID: <CANn89iKyovwB1WC0FbGV3tqz2f+0rSShtPjStuEhvyygSjOGrQ@mail.gmail.com>
Subject: Re: [PATCH v2] ipv6/sit: fix ipip6_tunnel_get_prl when memory
 allocation fails
To:     zys.zljxml@gmail.com
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        katrinzhou <katrinzhou@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 25, 2022 at 7:45 AM <zys.zljxml@gmail.com> wrote:
>
> From: katrinzhou <katrinzhou@tencent.com>
>
> Fix an illegal copy_to_user() attempt when the system fails to
> allocate memory for prl due to a lack of memory.

I do not really see an illegal copy_to_user()

c = 0
-> len = 0

if ((len && copy_to_user(a + 1, kp, len)) || put_user(len, &a->datalen))

So the copy_to_user() should not be called ?

I think you should only mention that after this patch, correct error
code is returned (-ENOMEM)


>
> Addresses-Coverity: ("Unused value")
> Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
> Signed-off-by: katrinzhou <katrinzhou@tencent.com>
> ---
>
> Changes in v2:
> - Move the position of label "out"
>
>  net/ipv6/sit.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index c0b138c20992..3330882c0f94 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
>                 kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
>                 NULL;
>
> -       rcu_read_lock();
> -
>         ca = min(t->prl_count, cmax);
>
>         if (!kp) {
> @@ -342,6 +340,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
>         }
>
>         c = 0;
> +       rcu_read_lock();
>         for_each_prl_rcu(t->prl) {
>                 if (c >= cmax)
>                         break;
> @@ -353,7 +352,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
>                 if (kprl.addr != htonl(INADDR_ANY))
>                         break;
>         }
> -out:
> +
>         rcu_read_unlock();
>
>         len = sizeof(*kp) * c;
> @@ -362,7 +361,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
>                 ret = -EFAULT;
>
>         kfree(kp);
> -
> +out:
>         return ret;
>  }
>
> --
> 2.27.0
>
