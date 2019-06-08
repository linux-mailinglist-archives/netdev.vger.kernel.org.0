Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92B6399D3
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 02:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfFHALV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 20:11:21 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:33180 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbfFHALV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 20:11:21 -0400
Received: by mail-it1-f193.google.com with SMTP id v193so5709025itc.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 17:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+RNHLLsyJellmSnIDZ7+LvEICMewTFh/MY6WcIKuVk0=;
        b=BYPcwoKqfSaruMOmHGR1badqlmrDfaB8wc1WGXHnDuD62Wl8sW8dMccs8UyCOSkboq
         aICV2YI/5ALQrrceC52qv0JK1anf8QMVqKa3eD5tj5N206uEe7AH9i3wigxB+Cs6LonZ
         v8ELgTiHue1z1LpnLeYhNaLK5SXujPq26PHxsI/m/EQqtx1JZetoA4Ubd3ZwtYzZJrk7
         FPFrRwpspeLPUqSx/RsI+pdJ8kAkXJyvz36qHBzkaoZBhmKR4ediBa5Dwdp8bHLTctiI
         ogJ3/yQ0RYgshOQi1O/eb01MXUuZC9oFft0hjGOacQKhQz3tCX5HJHepaoYvZttQoXPY
         +rNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+RNHLLsyJellmSnIDZ7+LvEICMewTFh/MY6WcIKuVk0=;
        b=SqdA8Nc0fGXC3ZUVltYM6RhkFevvRKWY9eJgnzfITQNfb6lC6c/QgY018CneZc3Axu
         cRaPGtBG2H7ZvFprHqOivb13Npn6/WGO+QvekdVEewAOJpp8ULWvdYO4YkcIssOaOgY3
         0bm0crdLqcSQNE3AbCJ9kFg/bADcJ9OLhdenLWzrZAaCluUjsd5uGS+C0z2jNbgVHAM5
         6F+33kO099GddaptBrkkJAzUb9HlEIgOfs8MO+Ff2qPib7jQ7XExNZvMy9GmqtZ0nz0M
         srySNg2vpA2/N9eSxhTXP89f3dFNNbBcf2UIN7Y4+7FLdwkfgkkCKB+duKl9wd+UQmzw
         hT0A==
X-Gm-Message-State: APjAAAXfYMRQ4Hac7ePDPFEUVXd+QrOw+e9pOKMrmQhnBwBdufRED44C
        ZaOKN0kVSN7hy2pnRoRnxTtwLLrNRYfloUfKxEPI4Q==
X-Google-Smtp-Source: APXvYqwxTvv8iST/+oX9HOh8CJ3sAph0cKp9iblXVS+Nhpi3fdRGALzjQkPxNSsvn/qIgCDjUzt5PBNqtM9NU+PCeGo=
X-Received: by 2002:a24:6e55:: with SMTP id w82mr6140217itc.17.1559952680222;
 Fri, 07 Jun 2019 17:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190607230610.10349-1-dsahern@kernel.org> <20190607230610.10349-10-dsahern@kernel.org>
In-Reply-To: <20190607230610.10349-10-dsahern@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 7 Jun 2019 17:11:09 -0700
Message-ID: <CAEA6p_BHrHUAgF_Ca4=zRc2iH6WBOGPkLK+a3_h43zmn6uZKWA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 09/20] ipv6: Handle all fib6_nh in a nexthop
 in rt6_do_redirect
To:     David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, Martin KaFai Lau <kafai@fb.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 4:06 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Use nexthop_for_each_fib6_nh and fib6_nh_find_match to find the
> fib6_nh in a nexthop that correlates to the device and gateway
> in the rt6_info.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  net/ipv6/route.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 2eb6754c6d11..1c6cff699a76 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3903,7 +3903,25 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
>         if (!res.f6i)
>                 goto out;
>
> -       res.nh = res.f6i->fib6_nh;
> +       if (res.f6i->nh) {
> +               struct fib6_nh_match_arg arg = {
> +                       .dev = dst->dev,
> +                       .gw = &rt->rt6i_gateway,
> +               };
> +
> +               nexthop_for_each_fib6_nh(res.f6i->nh,
> +                                        fib6_nh_find_match, &arg);
> +
> +               /* fib6_info uses a nexthop that does not have fib6_nh
> +                * using the dst->dev. Should be impossible
> +                */
> +               if (!arg.match)
> +                       return;
I don't think you can directly return here. We are still holding
rcu_read_lock() here. Probably need "goto out"...


> +               res.nh = arg.match;
> +       } else {
> +               res.nh = res.f6i->fib6_nh;
> +       }
> +
>         res.fib6_flags = res.f6i->fib6_flags;
>         res.fib6_type = res.f6i->fib6_type;
>         nrt = ip6_rt_cache_alloc(&res, &msg->dest, NULL);
> --
> 2.11.0
>
