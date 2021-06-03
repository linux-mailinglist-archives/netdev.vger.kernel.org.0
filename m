Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19D039AE1C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhFCWeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbhFCWeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 18:34:12 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BA1C061756;
        Thu,  3 Jun 2021 15:32:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y15so6001066pfl.4;
        Thu, 03 Jun 2021 15:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VUfhHlJEUkLIR0EIxU6jXP1bVKyAro32mftomoJHVSQ=;
        b=dUPVKRvL4ucDTigXFTP29OZzBupoPFAqKnumC/amO0ZZob6v9CW5aE4LOAqGxSf8wr
         ANTBNXdTwzx5qLAEqsY0zwPXZIx6ivvToN4ROae9vwyVyWlzoasf45Ox7dB46fDqOYZK
         iPcfopWe8E3qRgMt5BMYXfcgNfns7gNV7kHNZHtew3gwZ2E4NRXEGnNgJQpSwH2iJMCh
         jaoruUrycy6WDokpMWZC7egJxhYWTzLCjfEThi6hvCdTvxgj0gNN0ZtqrKUrmqIltoux
         Fk7/XOj4c/3WhFXPst67wIAQXDZxqAKKPpCQdJOlc8SvfBINGYo1sFqzkr2heuecq6pY
         /Kbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VUfhHlJEUkLIR0EIxU6jXP1bVKyAro32mftomoJHVSQ=;
        b=MfXYNwKUK3NeWuUpuOoeYbEgXHtTp1FSIcN6iCXbTz1RT7er4vx65zH/o7kTLWYUi/
         OdCETT17SAgCkK+cTHxkY2jOfBS6rLABAqLM70DM55Gs4JrsvUl+35QviDJ3WpqpLeCd
         6TXtn4yw1ElUpwBWYcnZu7DkkEyxxTZEQjtBNUpEL6F+Ca2Wh8nx11s+uefQg3rTTuLI
         yGbwewWbxjtgQlZcHdA6lWblVnsZUtZpbDPXX4+JqXlK4km6GE8KjoWfIvvOCMU025VV
         J7ARfzpQMMnAzSQVghrrZsd8xp2TWfKrssyqNDV8654VCvB4awOVISbqcyk9HtApl4ix
         qatg==
X-Gm-Message-State: AOAM530UhQfw7ovtvn926adnMLaIu7sYfR6GP4cFDhxF7Bd6fCDayD/C
        gtVLcZmLCcKsNfb0rQawzXSFybbAJmdmWC8KISDO1cNi1H3vPQ==
X-Google-Smtp-Source: ABdhPJzOTpRU3MtYwgO5eoq3M8jObwOxfDBiaRLRIFQsvqlRRCSPIIi4n0fauN6h3W6Gzr4IxnzGjlhxqWzJRB8nn/Y=
X-Received: by 2002:a63:571d:: with SMTP id l29mr1628701pgb.179.1622759534685;
 Thu, 03 Jun 2021 15:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210602192640.13597-1-paskripkin@gmail.com>
In-Reply-To: <20210602192640.13597-1-paskripkin@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 3 Jun 2021 15:32:03 -0700
Message-ID: <CAM_iQpU+1UUZhP9wHok4bajmRFeocr8d2mLZ8TtxqwyWuLgMAw@mail.gmail.com>
Subject: Re: [PATCH] net: kcm: fix memory leak in kcm_sendmsg
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 12:29 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Syzbot reported memory leak in kcm_sendmsg()[1].
> The problem was in non-freed frag_list in case of error.
>
> In the while loop:
>
>         if (head == skb)
>                 skb_shinfo(head)->frag_list = tskb;
>         else
>                 skb->next = tskb;
>
> frag_list filled with skbs, but nothing was freeing them.

What do you mean by "nothing was freeing them"?

I am sure kfree_skb() will free those in frag_list:

 654 static void skb_release_data(struct sk_buff *skb)
 655 {
 656         struct skb_shared_info *shinfo = skb_shinfo(skb);
 657         int i;
...
 669         if (shinfo->frag_list)
 670                 kfree_skb_list(shinfo->frag_list);


>
> backtrace:
>   [<0000000094c02615>] __alloc_skb+0x5e/0x250 net/core/skbuff.c:198
>   [<00000000e5386cbd>] alloc_skb include/linux/skbuff.h:1083 [inline]
>   [<00000000e5386cbd>] kcm_sendmsg+0x3b6/0xa50 net/kcm/kcmsock.c:967 [1]
>   [<00000000f1613a8a>] sock_sendmsg_nosec net/socket.c:652 [inline]
>   [<00000000f1613a8a>] sock_sendmsg+0x4c/0x60 net/socket.c:672
>
> Reported-and-tested-by: syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com
> Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  net/kcm/kcmsock.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 6201965bd822..1c572c8daced 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -1066,6 +1066,11 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>                 goto partial_message;
>         }
>
> +       if (skb_has_frag_list(head)) {
> +               kfree_skb_list(skb_shinfo(head)->frag_list);
> +               skb_shinfo(head)->frag_list = NULL;
> +       }
> +
>         if (head != kcm->seq_skb)
>                 kfree_skb(head);

This exact kfree_skb() should free those in frag_list. If the above
if condition does not meet for some reason, then fix that condition?

Thanks.
