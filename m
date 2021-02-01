Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17CF30ADFB
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBARfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbhBARet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:34:49 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6777C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:34:09 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id d7so17106072otf.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oe4wUnUrEXeJigbdmJ1Zo8HkG5rVFt/oiu13Xp4cGG0=;
        b=PTLhm003t2nT8U2zXIdgG6IheLGILeyuclP58pkLvAqh3W4k+xXQUoIsFumj+Iab2b
         1XyGBk85FvrAyfi/9KIot6WYeUN6eeFS/AjEcQjRV6YRYrQS7+P7+hTmHN+RYZNchuqA
         5w4nouIvHuGAOFErY81K9U7TgzKlWUB8GXfZ2hzXTj8abMexjbF1kBNLixpSlwfRCf+H
         WwpJ6dZOmYpDtS3YML2ajWUiNBjsrXi3vVrMNx0njQT34x+Tv98HK//m30SfaahGpVso
         YBEFsUeB63iNk/TPJiSJrSThfxqCgMUTCWvV2fKz876Ss8YJiueCakpXKIYxczOF6iy7
         YgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oe4wUnUrEXeJigbdmJ1Zo8HkG5rVFt/oiu13Xp4cGG0=;
        b=YubGfXe0jL1XnuFkUdvPG4N3giwOXSGj5m8DwDKfuXPYWYNCDZurq5G6FBmfM+jhOU
         L4r3IDw/9xWHkomQw82JuiXn6HS5CvSCfkERcTnLyAVUcb/Ig15LJAsjGBXGQSmZ5Vpl
         U4k+pdAYrMRXR4vaAzNQXZBeR55EueNQSPcYMjAhFgGTyd585IBGcbiteDkNEDup8QVF
         G3IT8zH+aZEw8x/L3UnBjXRWXTLp4Rg4Bo453bJ4dt9Tu/HD2fhyX+Qed/o4E2yWpk9N
         fZiay6xOLDGv33YiuraUukaJtYLi6TMrY265+kahEhWiBbhHzOfSn1RJyu7yv5pcALvF
         JG3w==
X-Gm-Message-State: AOAM531L4y/NoS2ZvXYwVyQj6+BdvK3y9TwjHF5nnH+nF3mQr83E4mzM
        Pxn8p24Sm6kbLrvPv6CWePipG82+be1DV0JooNcFEA==
X-Google-Smtp-Source: ABdhPJxrr/hq5HDzOZTvl54Dnj/ZfkzevgF9jQL3LEFJKdu8RT70yqs6H5yc8d/h8SH7bocaOTv5L3JQ3paCPHgPsLo=
X-Received: by 2002:a9d:3bb7:: with SMTP id k52mr13016105otc.251.1612200848825;
 Mon, 01 Feb 2021 09:34:08 -0800 (PST)
MIME-Version: 1.0
References: <20210201160420.2826895-1-elver@google.com> <CALMXkpYaEEv6u1oY3cFSznWsGCeiFRxRJRDS0j+gZxAc8VESZg@mail.gmail.com>
In-Reply-To: <CALMXkpYaEEv6u1oY3cFSznWsGCeiFRxRJRDS0j+gZxAc8VESZg@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Mon, 1 Feb 2021 18:33:56 +0100
Message-ID: <CANpmjNNbK=99yjoWFOmPGHM8BH7U44v9qAyo6ZbC+Vap58iPPQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix up truesize of cloned skb in skb_prepare_for_shift()
To:     Christoph Paasch <christoph.paasch@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>, linmiaohe@huawei.com,
        gnault@redhat.com, dseok.yi@samsung.com, kyk.segfault@gmail.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 at 17:50, Christoph Paasch
<christoph.paasch@gmail.com> wrote:
> On Mon, Feb 1, 2021 at 8:09 AM Marco Elver <elver@google.com> wrote:
> >
> > Avoid the assumption that ksize(kmalloc(S)) == ksize(kmalloc(S)): when
> > cloning an skb, save and restore truesize after pskb_expand_head(). This
> > can occur if the allocator decides to service an allocation of the same
> > size differently (e.g. use a different size class, or pass the
> > allocation on to KFENCE).
> >
> > Because truesize is used for bookkeeping (such as sk_wmem_queued), a
> > modified truesize of a cloned skb may result in corrupt bookkeeping and
> > relevant warnings (such as in sk_stream_kill_queues()).
> >
> > Link: https://lkml.kernel.org/r/X9JR/J6dMMOy1obu@elver.google.com
> > Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> >  net/core/skbuff.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 2af12f7e170c..3787093239f5 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3289,7 +3289,19 @@ EXPORT_SYMBOL(skb_split);
> >   */
> >  static int skb_prepare_for_shift(struct sk_buff *skb)
> >  {
> > -       return skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> > +       int ret = 0;
> > +
> > +       if (skb_cloned(skb)) {
> > +               /* Save and restore truesize: pskb_expand_head() may reallocate
> > +                * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
> > +                * cannot change truesize at this point.
> > +                */
> > +               unsigned int save_truesize = skb->truesize;
> > +
> > +               ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> > +               skb->truesize = save_truesize;
> > +       }
> > +       return ret;
>
> just a few days ago we found out that this also fixes a syzkaller
> issue on MPTCP (https://github.com/multipath-tcp/mptcp_net-next/issues/136).
> I confirmed that this patch fixes the issue for us as well:
>
> Tested-by: Christoph Paasch <christoph.paasch@gmail.com>

That's interesting, because according to your config you did not have
KFENCE enabled. Although it's hard to say what exactly caused the
truesize mismatch in your case, because it clearly can't be KFENCE
that caused ksize(kmalloc(S))!=ksize(kmalloc(S)) for you.

Thanks,
-- Marco
