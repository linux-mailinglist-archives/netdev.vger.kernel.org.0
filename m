Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E2839B81C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFDLkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhFDLkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 07:40:55 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEC2C06174A;
        Fri,  4 Jun 2021 04:38:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f2so8954011wri.11;
        Fri, 04 Jun 2021 04:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k0dxgqgQolqKVajtm5U4OQIDw8CCnCLQgHRHs6gIeAs=;
        b=WKBImY5DcqY5MuWBFPr6NfqvE1VLBacBSFPRXcgn+EHT5Ar6wK/dKeaDqkzeWlgivr
         uuidmp8u10DkIenDBAjX0teP1/NOevLxrv8kXGCaRaKlO80P6Eq/wvKirr8W9V11DJ/1
         dIZvNRvrz93xN8T/pZvQ30lOpUk19lF4APP3XuLoLuqK8EY4y39o9MluZcJWPD/e96uq
         E2AWj4bLeSA1pCxVqJs7m/vZPuM3mu+C7zScZe7x0iX4nONeZsyMlxqbZ7ql+Wnu3msL
         Xk2b3r7RYRp7wu7Ku/WNEnVy7mwGgc/sKHMOHFFVYTSAW2mwWbAkCnDAozIRmthfR3iA
         GLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0dxgqgQolqKVajtm5U4OQIDw8CCnCLQgHRHs6gIeAs=;
        b=TaD8zFg9pnNFPJrLBHZ4fvX9euDwx/spGf4jDNFkuVRobmYtimsfUGOocWiB+7YEiA
         a4+TQgYclMxFJXEE1RG4EQaJtMjCxd4Z7m32b1ifHbXtgVxztUPvpYpJ7ZJjhaAf7j+G
         CXFgk21ZpSk7ajwRzm97grove5EpopVzHDh2ID7GtNB5+CVWqpwbqJdsPg+s/1jNCrbO
         u2cGZQGueJt+Yy1RNo4dz3Er2viwq0nlnpR6Kz0iJLPKEmnZjdeZ7WpBRtz9Ym3nFkof
         JDlo6IU8kEjSapun5BtwbDqfoRdvvntM23sh/zDHVU8agRwYP5maKwdIWZUnlKsVGeiF
         ng4w==
X-Gm-Message-State: AOAM530yQYvMcojN87yo7qXZG0+36dMrQjYGkCAjNupK46mnJGLuaLFI
        HgajbjSaoZsbWd10+ERI5v8=
X-Google-Smtp-Source: ABdhPJyCA3WQOxOVorVnXMB6JOfshczja6/sVN8CFX7lyb0s5fuHeZC47ehq1MpTs/Kln03Jy5pVSg==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr3430238wrt.133.1622806735691;
        Fri, 04 Jun 2021 04:38:55 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id z11sm3656812wrt.36.2021.06.04.04.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 04:38:55 -0700 (PDT)
Date:   Fri, 4 Jun 2021 14:38:50 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] net: kcm: fix memory leak in kcm_sendmsg
Message-ID: <20210604143850.61c1845c@gmail.com>
In-Reply-To: <CAM_iQpU+1UUZhP9wHok4bajmRFeocr8d2mLZ8TtxqwyWuLgMAw@mail.gmail.com>
References: <20210602192640.13597-1-paskripkin@gmail.com>
        <CAM_iQpU+1UUZhP9wHok4bajmRFeocr8d2mLZ8TtxqwyWuLgMAw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Jun 2021 15:32:03 -0700
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Jun 2, 2021 at 12:29 PM Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> >
> > Syzbot reported memory leak in kcm_sendmsg()[1].
> > The problem was in non-freed frag_list in case of error.
> >
> > In the while loop:
> >
> >         if (head == skb)
> >                 skb_shinfo(head)->frag_list = tskb;
> >         else
> >                 skb->next = tskb;
> >
> > frag_list filled with skbs, but nothing was freeing them.
> 
> What do you mean by "nothing was freeing them"?
> 
> I am sure kfree_skb() will free those in frag_list:
> 
>  654 static void skb_release_data(struct sk_buff *skb)
>  655 {
>  656         struct skb_shared_info *shinfo = skb_shinfo(skb);
>  657         int i;
> ...
>  669         if (shinfo->frag_list)
>  670                 kfree_skb_list(shinfo->frag_list);
> 
> 

Indeed. I didn't know about that. Im sorry.

> >
> > backtrace:
> >   [<0000000094c02615>] __alloc_skb+0x5e/0x250 net/core/skbuff.c:198
> >   [<00000000e5386cbd>] alloc_skb include/linux/skbuff.h:1083
> > [inline] [<00000000e5386cbd>] kcm_sendmsg+0x3b6/0xa50
> > net/kcm/kcmsock.c:967 [1] [<00000000f1613a8a>] sock_sendmsg_nosec
> > net/socket.c:652 [inline] [<00000000f1613a8a>]
> > sock_sendmsg+0x4c/0x60 net/socket.c:672
> >
> > Reported-and-tested-by:
> > syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com Fixes:
> > ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module") Cc:
> > stable@vger.kernel.org Signed-off-by: Pavel Skripkin
> > <paskripkin@gmail.com> ---
> >  net/kcm/kcmsock.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> > index 6201965bd822..1c572c8daced 100644
> > --- a/net/kcm/kcmsock.c
> > +++ b/net/kcm/kcmsock.c
> > @@ -1066,6 +1066,11 @@ static int kcm_sendmsg(struct socket *sock,
> > struct msghdr *msg, size_t len) goto partial_message;
> >         }
> >
> > +       if (skb_has_frag_list(head)) {
> > +               kfree_skb_list(skb_shinfo(head)->frag_list);
> > +               skb_shinfo(head)->frag_list = NULL;
> > +       }
> > +
> >         if (head != kcm->seq_skb)
> >                 kfree_skb(head);
> 
> This exact kfree_skb() should free those in frag_list. If the above
> if condition does not meet for some reason, then fix that condition?
> 
> Thanks.

I will debug this today later. I think, this commit should be reverted,
because it's broken. Or I can send next patch on top of this. What do
you think of that, David? 


With regards,
Pavel Skripkin
