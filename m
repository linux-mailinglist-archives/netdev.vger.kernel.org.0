Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2130AD10
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhBAQvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhBAQvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:51:10 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2702C061573;
        Mon,  1 Feb 2021 08:50:28 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id i8so8980190ejc.7;
        Mon, 01 Feb 2021 08:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=28aWbeuxYU/d3zJdSw4FejdOSZ9mEcviBMdx8cpNqHs=;
        b=YYB38wSZfAblKXtyMsYf35SYzEdm9cfOvaNlKacJ8HD1JxJZtVSUsQrifmWZgso1gm
         KzdTouGU1XjeqFjPmRf4TiCCG+If7iZQogIzNKP2sKh39Dy2/sDQ/M9eedtfKVqGUTdR
         +gFa3x4VUUFQA4OhrqPR57ZjbxblwQhp1qj3v6A/mKxx3eFbjMmn6srposj06ubkZGkA
         qfa10UfUdDPjK3WaR6qh3i3lTBPAp/ATOqNJ1lKkaxJgYgEc8L8oypG+BoeCE+BtWp14
         deRpJxOhFVmLIJOU6uSO2Y0ArBZjrVfMiiVqj4S1OVr1b/lzUdNVPe27ReA3RI4t7Qj3
         wtHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28aWbeuxYU/d3zJdSw4FejdOSZ9mEcviBMdx8cpNqHs=;
        b=We67QaowrhpsA48LSz3bvBus6VJySGxsOQIJSrRly2YJILKOG9kpd/CZdsOmwdobU/
         +JRHcTPTu2G5SUmj7m7uoiN/z1TxmlffwXETqBmrD95AODnvdrPT/wDc59jC0G/hGhgo
         GUxpVFrbEJum29LpP233UQZmAWXhVGu3ILIlJCxOTTCgYl5d3iJrbJXa7CcS54Gsl2/4
         5O/97Abmi+wFq34BgLyHbhQ/dZpdqgXbj0y3WLpnKShXkpSdh2qIN1IB4bVgNwvuBfxj
         dQ+Wag4zOBTuWgndNFlw9Q4qglxKoZFapPB2IpnmAGmIfnompVlKZUgTHtgVeY17oDnJ
         DabQ==
X-Gm-Message-State: AOAM533WJEShHMwQfvOTVKXEB2X7BQZdsVHiU5n+dqinLV4RD/Cj7nKH
        7J0kpmzvvIJGOfwO5cZn/g+0Z8lvPvs6jdDXaG0=
X-Google-Smtp-Source: ABdhPJxNX/Zc2WZKU5j38fRhdm0PlBgCbf8SmuqspoQjHSPvUvWFmTIkDdyc+pA7KD4ZzZ8geIkh9iYEHc7gxABPI/M=
X-Received: by 2002:a17:906:719:: with SMTP id y25mr11628409ejb.180.1612198227459;
 Mon, 01 Feb 2021 08:50:27 -0800 (PST)
MIME-Version: 1.0
References: <20210201160420.2826895-1-elver@google.com>
In-Reply-To: <20210201160420.2826895-1-elver@google.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Mon, 1 Feb 2021 08:50:16 -0800
Message-ID: <CALMXkpYaEEv6u1oY3cFSznWsGCeiFRxRJRDS0j+gZxAc8VESZg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix up truesize of cloned skb in skb_prepare_for_shift()
To:     Marco Elver <elver@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kasan-dev@googlegroups.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>, linmiaohe@huawei.com,
        gnault@redhat.com, dseok.yi@samsung.com, kyk.segfault@gmail.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>, glider@google.com,
        syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 8:09 AM Marco Elver <elver@google.com> wrote:
>
> Avoid the assumption that ksize(kmalloc(S)) == ksize(kmalloc(S)): when
> cloning an skb, save and restore truesize after pskb_expand_head(). This
> can occur if the allocator decides to service an allocation of the same
> size differently (e.g. use a different size class, or pass the
> allocation on to KFENCE).
>
> Because truesize is used for bookkeeping (such as sk_wmem_queued), a
> modified truesize of a cloned skb may result in corrupt bookkeeping and
> relevant warnings (such as in sk_stream_kill_queues()).
>
> Link: https://lkml.kernel.org/r/X9JR/J6dMMOy1obu@elver.google.com
> Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  net/core/skbuff.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 2af12f7e170c..3787093239f5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3289,7 +3289,19 @@ EXPORT_SYMBOL(skb_split);
>   */
>  static int skb_prepare_for_shift(struct sk_buff *skb)
>  {
> -       return skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> +       int ret = 0;
> +
> +       if (skb_cloned(skb)) {
> +               /* Save and restore truesize: pskb_expand_head() may reallocate
> +                * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
> +                * cannot change truesize at this point.
> +                */
> +               unsigned int save_truesize = skb->truesize;
> +
> +               ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> +               skb->truesize = save_truesize;
> +       }
> +       return ret;

just a few days ago we found out that this also fixes a syzkaller
issue on MPTCP (https://github.com/multipath-tcp/mptcp_net-next/issues/136).
I confirmed that this patch fixes the issue for us as well:

Tested-by: Christoph Paasch <christoph.paasch@gmail.com>





>  }
>
>  /**
>
> base-commit: 14e8e0f6008865d823a8184a276702a6c3cbef3d
> --
> 2.30.0.365.g02bc693789-goog
>
