Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5530C2B1C
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfI3XvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:51:25 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45903 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbfI3XvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:51:25 -0400
Received: by mail-io1-f67.google.com with SMTP id c25so42985839iot.12
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 16:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cCjtXz6belJKouEGUeQFtc0wC458KDHpR8ncpO1cIrs=;
        b=nZ+599k2zepiGaaTQMsQKZP6u+VPRtClJF/OK09YCqs2XfZDZa8kub6YricuxG+kMI
         3I3DNIpE8de+bJKU7dvNujK2MQ2zAdhOQ8IaTHoRMYM/hIP9IV1DbWXBSVw4OgE9X+gl
         xDEZVCelQ3ZNQW76Q1YWAMn/egX8gPjkWrfBHQmdUZZ7hGYMgxFcvKeI8jNkXySScOY6
         /uvBjBf1cOuOiAvxhjxoMvxZBMZZbad8QYByIycgBuyJaFQ9bmiTsikXM4ox3A29G7GU
         /wHqdBavc4ep+GWSCTYb37dywck1Ak3f49sZpM4g2RGZYeTw9EhxR5f6SKuPglwjYUQZ
         RsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cCjtXz6belJKouEGUeQFtc0wC458KDHpR8ncpO1cIrs=;
        b=EHouWntPa8zhDHw5sBn7MsLT2jDJ2t0zAdBQUYlWD0BNBtWCKNzteE3dyaadKjzAWe
         6Ykv1wzjJQ7JEakLQy1wp3TCLJjvjNvSXMGCjDdpOGKRbdYRC5KDoF+EXHxtqToy3sf+
         csc1ld1LK43ExqHiiuZtAPO3SI23ohgLFxLpPbm0EhuvGbZKh5BhS9NhNWjlMg6WiusD
         3CWGCMnLs3sOph9DoAXi3JHAnCpS6NAzPdK0iPzoHHEMHn2FyC0M146Zo+ApqPOSobg+
         7rNDot3yTbQ0SIOvZ5HOUXHwigxtjpuUDE2+9XugTmWKdY5bYBW4dPhK6cwEZQFMwl6B
         qOQg==
X-Gm-Message-State: APjAAAWoWyYzNqOEsT9rzRe6lIjyPXGh8q8JSq9Cqawo12EB9i28T4Qf
        B2dFyLQmF8hSym8OS4rP/hgtx6u98/QUTITSGW4=
X-Google-Smtp-Source: APXvYqxA2G7mlXWSV/FMmm9EwVwdlNCw/eXtcfV/F+egJe6fvbVp1ZyKJqiyJhncl6nvkfcSQTpbkrz+Z3B8GlYWp/Q=
X-Received: by 2002:a6b:da06:: with SMTP id x6mr461495iob.42.1569887484044;
 Mon, 30 Sep 2019 16:51:24 -0700 (PDT)
MIME-Version: 1.0
References: <1569881518-21885-1-git-send-email-johunt@akamai.com>
In-Reply-To: <1569881518-21885-1-git-send-email-johunt@akamai.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Sep 2019 16:51:13 -0700
Message-ID: <CAKgT0Ue092M4pMa8EjrqdF6KADK8WtFhA=17K3fuqW5=xKAeNg@mail.gmail.com>
Subject: Re: [PATCH 1/2] udp: fix gso_segs calculations
To:     Josh Hunt <johunt@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 3:15 PM Josh Hunt <johunt@akamai.com> wrote:
>
> Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
> added gso_segs calculation, but incorrectly got sizeof() the pointer and
> not the underlying data type. It also does not account for v6 UDP GSO segs.
>
> Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  net/ipv4/udp.c | 2 +-
>  net/ipv6/udp.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index cf755156a684..be98d0b8f014 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -856,7 +856,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
>
>                 skb_shinfo(skb)->gso_size = cork->gso_size;
>                 skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
> -               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(uh),
> +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
>                                                          cork->gso_size);
>                 goto csum_partial;
>         }
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index aae4938f3dea..eb9a9934ac05 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1143,6 +1143,8 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
>
>                 skb_shinfo(skb)->gso_size = cork->gso_size;
>                 skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
> +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
> +                                                        cork->gso_size);
>                 goto csum_partial;
>         }
>

Fix looks good to me.

You might also want to add the original commit since you are also
addressing IPv6 changes which are unrelated to my commit that your
referenced:
Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
