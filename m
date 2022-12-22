Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB1D654707
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 21:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbiLVURG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 15:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiLVURD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 15:17:03 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A241055F
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 12:17:03 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 192so3242749ybt.6
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 12:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv0h4nLJ0UYzP4Ya8dEUSJB7gtqXoOnzWfQ4wI1GlDU=;
        b=A0minykmthcj4S5byxk6QSz3G8x3OglpY7Hh3jgk/35A8i4nTvtc1g36HbO4zpmQkI
         yJ7faWKJs40uuYcBfrhzPbMzUQXxYrT+5ygpiSjxaV/lP6N1PjLefZpAxiOSVtNF3PyD
         cVzFpAVz+oFlN0tNVMoQnbbJ4/4BEP4ypoG1ivrwodwVd6gmyKbplGcbbKIbJ5gSdUQ7
         OYBjVofFFRJMKGkSuIc7xnaNsZhqnbsPOwqNNtKACR5DKyMfvZzEl0pHV/NOB949Fapx
         rstdLHqvMBUvGC7PxXRcIYsgmjHcjnKW3MaKZYO+ydCHmKMObh85O7jgNyQkcL/zFoWl
         fIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wv0h4nLJ0UYzP4Ya8dEUSJB7gtqXoOnzWfQ4wI1GlDU=;
        b=Q966nY2CO78SizZNyEU2W/CRx8h99z2dBcbx/AM6XV/L5BatdcVIYNYsqbgXXWPtan
         pnRTIkJxDrQy4T/ORLLbfoSkwWj2sDExtW1pqgvYnMkWZ3YIDBKN8vWFnTa7TTz+aZSZ
         deIf9rgB8kFkIMzp+sBLD43Y3lqwStINJ2dYX4CiB90PrmZyo8M8uEMt7qPs1ZFuw+4O
         WPa/2eoe0Yu3nvavn4kWXTZnlsPQoXSYewXQPQIaH/6Ly6So2ZhC52O38/Qw/Dmytrk2
         H3STqSdanD98qu4hnKLwHo1EMja+jXgh+g/InlNvwK/WMFg2b9fLxQBuSAd3O3PbQUY8
         h7ZA==
X-Gm-Message-State: AFqh2kqUj7pzliTuS4FQrXV2d9THzLEKyMCsKtQ5H6/iYsJBV6x/NuaY
        Kixjm5atc3HucAx/CmqMXcjzyKdY4J3svV4GuiRAZQ==
X-Google-Smtp-Source: AMrXdXsQhzS6TimuXvyBhckZYil33BfCtm7D5qpayOmenZkdBGP66tg65gE1pg3xhQ9Ba3IvzShZ6V5TDp/PhussOuo=
X-Received: by 2002:a25:b87:0:b0:6dd:7395:72bc with SMTP id
 129-20020a250b87000000b006dd739572bcmr862218ybl.533.1671740222095; Thu, 22
 Dec 2022 12:17:02 -0800 (PST)
MIME-Version: 1.0
References: <20221222191005.71787-1-maheshb@google.com>
In-Reply-To: <20221222191005.71787-1-maheshb@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 22 Dec 2022 15:16:25 -0500
Message-ID: <CACSApvbGDoO+fwizJK+y-aufi66Zd-xB60-f8KF5WZOJZ8mqcw@mail.gmail.com>
Subject: Re: [PATCH next] sysctl: expose all net/core sysctls inside netns
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 2:10 PM Mahesh Bandewar <maheshb@google.com> wrote:
>
> All were not visible to the non-priv users inside netns. However,
> with 4ecb90090c84 ("sysctl: allow override of /proc/sys/net with
> CAP_NET_ADMIN"), these vars are protected from getting modified.
> A proc with capable(CAP_NET_ADMIN) can change the values so
> not having them visible inside netns is just causing nuisance to
> process that check certain values (e.g. net.core.somaxconn) and
> see different behavior in root-netns vs. other-netns
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thanks!

> ---
>  net/core/sysctl_net_core.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 5b1ce656baa1..e7b98162c632 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -643,11 +643,6 @@ static __net_init int sysctl_core_net_init(struct net *net)
>
>                 for (tmp = tbl; tmp->procname; tmp++)
>                         tmp->data += (char *)net - (char *)&init_net;
> -
> -               /* Don't export any sysctls to unprivileged users */
> -               if (net->user_ns != &init_user_ns) {
> -                       tbl[0].procname = NULL;
> -               }
>         }
>
>         net->core.sysctl_hdr = register_net_sysctl(net, "net/core", tbl);
> --
> 2.39.0.314.g84b9a713c41-goog
