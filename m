Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1085250040C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 04:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiDNCSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 22:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbiDNCR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 22:17:59 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5334EDE3
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 19:15:36 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2ef4a241cc5so34665627b3.2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 19:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EyNYRIHMuAe14NfG42UC6bW7EHisTJTsbzpFwHXAxYE=;
        b=mhN2PI/XczGH1LPOLgFumsgCAC53Xh7XIpRdSmGoOAazEowtirMA87iL1iYkiU3aLP
         cDQlWfWJY9yvdJ8uyUwpVeV2MftCXqON0hS8jDMdx/wDYzm4SoWh/H+5kmi36m+C0Goq
         3F/1eB8fUA5+McWgFcEC4cDafxfLQb8LOUcoMn79zYGvNKputLXdq0pOK9kSOS6p3bY8
         +hB515ep96878W7/ac+tdn7cIHl0pcjNxHXP/u0JMfRBSxNXpCVOXB/2j6trYedRa0Xs
         xaXvGTnmNQ/vQvo4o8rUsqJt6KSxYXnfoKCtoq0zmM9j3LfP6tY0kzfF7lSTX3+MEvWb
         ejjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EyNYRIHMuAe14NfG42UC6bW7EHisTJTsbzpFwHXAxYE=;
        b=eGFvMbrTWYYbqJ93sGwS3t7X11fKhtLJRKfmm6A9pR5lcMkQzVN+M9Uts1tZ9b0z4q
         2WabVEDk76AfaSjuvFXvlTDSimn13DYYPGxwGFTvyXqqKdUiGT2TOc3RxASOAoFotBgi
         NEyRWvEXNYQYBXnwctcD6/yJC+IoxX7+VjphK+F5wdDWga+a8G8/DlQqfAT+Kx3Pim7s
         FPgYoiAJ/tQRHtdxASqj1khmZ14oQcM+yDnCEhqLB28CBVzlXBKiRp5ADQpanYCWHHxJ
         CfP+yn0ZHFuvvpPo4sXJgDWYsXiNDr4071uOYalnO2UU9WV8yzcOPnQifp40OK7vKELY
         z5BA==
X-Gm-Message-State: AOAM531WDp+CMIt2iPFEV0afEHYj5lVe5UuAUryAuqHO8FNo5Ayek33n
        HSyEkKOeTzzFLsYbIXaQUmczwTO4IkvmCgB0NwTsfw==
X-Google-Smtp-Source: ABdhPJytuMs6w7MXLCClCeKL1doxBRc/t2dwAzon5XDa8KzHqgx/XOUwsie7YJQEkwJ0S1TNQJLJ6EKZap3pqxTCCjM=
X-Received: by 2002:a81:753:0:b0:2eb:ebe9:ff4f with SMTP id
 80-20020a810753000000b002ebebe9ff4fmr325385ywh.255.1649902535724; Wed, 13 Apr
 2022 19:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220414015802.101877-1-wh_bin@126.com>
In-Reply-To: <20220414015802.101877-1-wh_bin@126.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Apr 2022 19:15:24 -0700
Message-ID: <CANn89i+_GjNjjwAZU1VXG5OWFna3Vd1a6F-L7oYvNUObowzvuQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix error return code in tcp_xmit_probe_skb
To:     Hongbin Wang <wh_bin@126.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Wed, Apr 13, 2022 at 6:58 PM Hongbin Wang <wh_bin@126.com> wrote:
>
> When alloc_skb failed, should return ENOMEM


Can you explain which rule mandates this statement ?

The only caller that propagates this error has other "return -1;"

The precise value of the error, we do not care, as long it is negative.

To be clear, this error code is not propagated to user space, so this
patch only adds code churn.


>
>
> Signed-off-by: Hongbin Wang <wh_bin@126.com>
> ---
>  net/ipv4/tcp_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index c221f3bce975..b97c85814d9c 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3996,7 +3996,7 @@ static int tcp_xmit_probe_skb(struct sock *sk, int urgent, int mib)
>         skb = alloc_skb(MAX_TCP_HEADER,
>                         sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
>         if (!skb)
> -               return -1;
> +               return -ENOMEM;
>
>         /* Reserve space for headers and set control bits. */
>         skb_reserve(skb, MAX_TCP_HEADER);
> --
> 2.25.1
>
