Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20BC410F58
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 07:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhITFqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 01:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhITFqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 01:46:08 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDDFC061574;
        Sun, 19 Sep 2021 22:44:42 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i25so63235697lfg.6;
        Sun, 19 Sep 2021 22:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivxRxXk1jmWb3aes+tkdDqCm6jQIS0oNdYc8DLVRVcM=;
        b=Ln4zRqSiUZgW1oFGYKnets0iGhY6tKiZCYZgPoVDqxqGBRWH8OyKfD1FzZn7KAYs9I
         TCbKaus5OaJki58tBSNsgxCdxxfKBk5n7rDE2XIgVCHUDdxOvUZ+Hqi9OElyv+iKllw/
         6LZzROtjVru2uepL3IoJaa8trD9zZ5wEaiLg8U5rOdCA9l9wcJqkA7YT5stqeYMV0Fby
         RxEq3L8PkOv/lEMe7jjxT0bCt6KiwSj6zAorpbG+OFu8SHPqPp4LNAP+eRjup/nys5XE
         cCnIfpvrsF2dpsBKR/qitqn0l+MqjYL7taezFCpj4ETkDzkuu+h0FxHLYOErVq8ak+nv
         feMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ivxRxXk1jmWb3aes+tkdDqCm6jQIS0oNdYc8DLVRVcM=;
        b=53D0C6BLKcSz4YrxgwqFzZrQyftF9jakHsF1zHDmU4+T5fOx67+vbEvFpWqDz44EfS
         p0rZodcwKiIJgoSrOIjZDGty+oxaJmIloWD+hXAESvhr+XLIGwe3+zEjH4oa/8/VcF5H
         FwuoYPwUFH4H0AN2DNKC6+O9EhGdb/Ha2zD6xhbHtnAtMGBaCgb0fyV7Iun2mSSDv266
         7/4lX3jfLlyIbn3wjs/D1gAgkgdgpniWQomeTEeUQcdrohJyMuRB/72R0/JaSo6eppZV
         YB0x9KvaCOLa3Kl1kYWbjPSbqFYNkL7mqV9875MMlkf//GSh0lpAT94SmTCL0G2RdsOo
         UvLQ==
X-Gm-Message-State: AOAM530lIeSijGHYylKdUEYvKJ6otzHt2l6GxXt4bXGqhbave7pf4AJf
        3QPTq/ICWxcrMxYFg/VMYr8qDvG9rF26wFueG/NFOFkBQE6H6A==
X-Google-Smtp-Source: ABdhPJz2W8YCHXSZNkjWCeQaWDCVVA/VycRTXKRCEWIfLTCeSf50ohoCLe8V9nJajvQzDF2jRA9JTr4GV1QJq0imWEg=
X-Received: by 2002:a2e:580e:: with SMTP id m14mr18457247ljb.82.1632116680413;
 Sun, 19 Sep 2021 22:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210919154337.9243-1-stachecki.tyler@gmail.com> <CAM_iQpUeH7sOWRDfaAsER4HdRJQUuODB-ht0NyEZgnCXEmm2RQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUeH7sOWRDfaAsER4HdRJQUuODB-ht0NyEZgnCXEmm2RQ@mail.gmail.com>
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
Date:   Mon, 20 Sep 2021 01:44:29 -0400
Message-ID: <CAC6wqPVopqP=erynBazgRh2QkB7=Nh-cXxLS2ZvmTzb7E0Gvaw@mail.gmail.com>
Subject: Re: [PATCH] ovs: Only clear tstamp when changing namespaces
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     fankaixi.li@bytedance.com, xiexiaohui.xxh@bytedance.com,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dev@openvswitch.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 7:33 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Sep 19, 2021 at 10:59 AM Tyler J. Stachecki
> <stachecki.tyler@gmail.com> wrote:
> >
> > As of "ovs: clear skb->tstamp in forwarding path", the
> > tstamp is now being cleared unconditionally to fix fq qdisc
> > operation with ovs vports.
> >
> > While this is mostly correct and fixes forwarding for that
> > use case, a slight adjustment is necessary to ensure that
> > the tstamp is cleared *only when the forwarding is across
> > namespaces*.
>
> Hmm? I am sure timestamp has already been cleared when
> crossing netns:
>
> void skb_scrub_packet(struct sk_buff *skb, bool xnet)
> {
> ...
>         if (!xnet)
>                 return;
>
>         ipvs_reset(skb);
>         skb->mark = 0;
>         skb->tstamp = 0;
> }
>
> So, what are you trying to fix?
>
> >
> > Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
> > ---
> >  net/openvswitch/vport.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> > index cf2ce5812489..c2d32a5c3697 100644
> > --- a/net/openvswitch/vport.c
> > +++ b/net/openvswitch/vport.c
> > @@ -507,7 +507,8 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
> >         }
> >
> >         skb->dev = vport->dev;
> > -       skb->tstamp = 0;
> > +       if (dev_net(skb->dev))
>
> Doesn't dev_net() always return a non-NULL pointer?
>
> If you really want to check whether it is cross-netns, you should
> use net_eq() to compare src netns with dst netns, something like:
> if (!net_eq(dev_net(vport->dev), dev_net(skb->dev))).
>
> Thanks.

Sorry if this is a no-op -- I'm admittedly not familiar with this part
of the tree.  I had added this check based on this discussion on the
OVS mailing list:
https://mail.openvswitch.org/pipermail/ovs-discuss/2021-February/050966.html

The motivation to add it was based on the fact that skb_scrub_packet
is doing it conditionally as well, but you seem to indicate that
skb_scrub_packet itself is already being done somewhere?

Cheers,
Tyler
