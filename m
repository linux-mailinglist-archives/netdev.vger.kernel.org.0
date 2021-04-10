Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C03D35ACCC
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 13:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhDJLBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 07:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbhDJLBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 07:01:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD274C061763
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 04:00:46 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id c195so9426484ybf.9
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 04:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8DQJVSaUjQNGe8Y0lpiq/r3H4nNp7NGhGr+XrWaz+c=;
        b=VTnHXX+osSuBIin2yn6F5r0CcGi/2W+Iz6nLwwnYQ5ot6ENNNyz5LsdmLgc7uTv9lA
         xdaXlzUBBmkw0v3PAJ1IoFWmMlHiI184t/6q4E6bSuA7LyisSQDLCcE9dy7KsXDCKCWj
         qrR6uGRvjp3z4OuoBhifMB8YpoxjNruKph8YV6VGuydhNuO+RQvIsRe4vDse6HvpNQsF
         d50lR8H57npELrzb0NSvukXpGdoLjdtTX8VGl9SwWRAXUk+b6Eu8x3mOUegs+nVorXns
         zFvAJdHtCfcGwgxgE7CZogwwRH1gNY3t8QIGIWLnF+yf2gOawvpEhrW6ZvpYhwpiq92O
         77jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8DQJVSaUjQNGe8Y0lpiq/r3H4nNp7NGhGr+XrWaz+c=;
        b=gbvJrGGOt7mUswxWi4o/XVq4zqSpyilNFvuDmlwA9f1Hk3VV1P+3xffvhcluvREaA5
         PIHBuREFe2Fao8pcj38FxBv6regCqZj10gORFBbEucaxRdsJXeEfdZQrkAXKrIAk5Yhy
         +6BF1IlN5tv0cjdjgGqGjhOrsq3u4y+XMoGOQMOECDnsj2uHfarzPgUtJBXVHHBgI+6z
         3RvmxYyS9oDeoWqdBA/oYRDJig8B8xW/pfV2Zcsid6A9xbK2PpowYDmjW1wv6q9xOgJl
         H0v1Ps3a5ahJHLiP2+0P//9NmBtzZ2qI7GyyjOHEGKV962PwYyrJlM7p9KU4mOvYcij4
         roOA==
X-Gm-Message-State: AOAM531+BfXvMgFJXbuuLOT93vZJZqHCCaZlPrHvsRWqdkdQ/K58mqQH
        zqs57X/ViYYLkv1iz6yNL8twepxQP3nxThrw1n0nFg==
X-Google-Smtp-Source: ABdhPJy1c0yvqvGLHQRiKUs1CQHeYxl4wNYuB3N7it4WhKn204XaKWFigIJ9FS858TKQTDuJeHfcTxpAtwnikIBpIU4=
X-Received: by 2002:a25:b906:: with SMTP id x6mr23305699ybj.504.1618052445594;
 Sat, 10 Apr 2021 04:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210410095149.3708143-1-phil@philpotter.co.uk> <CANn89iJdoaC9P_Nd=BrXVRyMS43YOg-DX=VciDO89mH_JPVRTg@mail.gmail.com>
In-Reply-To: <CANn89iJdoaC9P_Nd=BrXVRyMS43YOg-DX=VciDO89mH_JPVRTg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 10 Apr 2021 13:00:34 +0200
Message-ID: <CANn89iK4HuKv4AgY5PPWGEEihNEFxGhhqpBp7zv-FfCcJyboDg@mail.gmail.com>
Subject: Re: [PATCH] net: core: sk_buff: zero-fill skb->data in __alloc_skb function
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        linmiaohe <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Marco Elver <elver@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>, vladimir.oltean@nxp.com,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 12:12 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Apr 10, 2021 at 11:51 AM Phillip Potter <phil@philpotter.co.uk> wrote:
> >
> > Zero-fill skb->data in __alloc_skb function of net/core/skbuff.c,
> > up to start of struct skb_shared_info bytes. Fixes a KMSAN-found
> > uninit-value bug reported by syzbot at:
> > https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f
> >
> > Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > ---
> >  net/core/skbuff.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 785daff48030..9ac26cdb5417 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -215,6 +215,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >          * to allow max possible filling before reallocation.
> >          */
> >         size = SKB_WITH_OVERHEAD(ksize(data));
> > +       memset(data, 0, size);
> >         prefetchw(data + size);
>
>
> Certainly not.
>
> There is a difference between kmalloc() and kzalloc()
>
> Here you are basically silencing KMSAN and make it useless.
>
> Please fix the real issue, or stop using KMSAN if it bothers you.

My understanding of the KMSAN bug (when I released it months ago) was
that it was triggered by some invalid assumptions in geneve_xmit()

The syzbot repro sends a packet with a very small size (Ethernet
header only) and no IP/IPv6 header

Fix for ipv4 part (sorry, not much time during week end to test all this)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index e3b2375ac5eb55f544bbc1f309886cc9be189fd1..0a72779bc74bc50c20c34c05b2c525cca829f33c
100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -892,6 +892,9 @@ static int geneve_xmit_skb(struct sk_buff *skb,
struct net_device *dev,
        __be16 sport;
        int err;

+       if (!pskb_network_may_pull(skb, sizeof(struct iphdr))
+               return -EINVAL;
+
        sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
        rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
                              geneve->cfg.info.key.tp_dst, sport);
