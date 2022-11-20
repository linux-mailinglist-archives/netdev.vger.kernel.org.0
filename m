Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A110963154F
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 18:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKTRBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 12:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKTRBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 12:01:11 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82522B1AB
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 09:01:09 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e68so11166238ybh.2
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 09:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lOkLFPOjI8VhVTiQMIbTQ6jeAEJNIIzSKfB293Gbxqg=;
        b=hxirr2QCtloDLZv4UXEHFJkXv4q3Y5tRa5VDwrzFxJ75E2W0ydy/5wJ9dpB98b2OdX
         6iv+7fRpvzobfVOqlUDOVkLs/oUtUsOIpQmBdXlorq6dlHVxaV44YTaGFjOFWSFpEwT8
         AQwPGwB8nt5jqSbNb2h+aIsLIcvZlVikhS64gv7QUA46peD1FfTYvzQKpfoA8H0kXK4y
         3zvYujgBYWfS7BGcIFgPbW7BqI2cJORJ212Lk+Y31CMvGUOeBasCLTdDY0SXJeETeOiP
         WRgxXUsiFdKQ0EUrP/A1oVGlv6O4QKp9CdCImaA2590z8La28JIYY9ZpuzuzeetXsyfv
         9m7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lOkLFPOjI8VhVTiQMIbTQ6jeAEJNIIzSKfB293Gbxqg=;
        b=6iggB+lzZww7RkB6XlqRbYXwMlom/90JWAQopg2hLkQtm+FO/+BOz9FQSrA+1wYfMx
         leU0xmjiuTmCX9wqyxKYOh68aNf8JKbST4A1Euskvd0v/DdnmVqq53EDMzAcoi05Nlav
         wIkzUbrPYAyhZe88azC4KhsNiORNyiowvzHwbjvcCuUnThZWl+zqKP10QxnauCagg80Z
         9Dw2QtyEAKZlMY/w4vLl0YaEAm7lB2u79ESYB9qeFo15iAEE/hJJbD5Ui0iB2eR80o3T
         81IELhpugjHKG9IfwPgrE4A8Vl20E6W8bBEbDW6QBw0+HNB8YRAn1qL9p3UQuS6sWRSg
         S5qw==
X-Gm-Message-State: ANoB5plC7yfO66QHkX2d4W9TsSN/KRAu70+AKIb0Cg6Xji6wlT8qf1pr
        78Toht+aW4cI7Lj98DYLgAmLuA31OLsOLvCJiIVJVg==
X-Google-Smtp-Source: AA0mqf45WGIJ0A03DtuGZg4ltq+t6OmtuOIEKD5G54kdBnVrXCCBUsvo+EjpQEBeJ5stI8uzusXf4pgXoMHEaqiRbqE=
X-Received: by 2002:a25:9c46:0:b0:6d7:8639:bade with SMTP id
 x6-20020a259c46000000b006d78639bademr13448332ybo.427.1668963666003; Sun, 20
 Nov 2022 09:01:06 -0800 (PST)
MIME-Version: 1.0
References: <20221018203258.2793282-1-edumazet@google.com> <162f9155-dfe3-9d78-c59f-f47f7dcf83f5@nvidia.com>
 <CANn89iKwN9tgrNTngYrqWdi_Ti0nb1-02iehJ=tL7oT5wOte2Q@mail.gmail.com>
 <20221103082751.353faa4d@kernel.org> <CANn89iJGcYDqiCHu25X7Eg=s2ypVNLfbNZMomcqvD-7f0SagMw@mail.gmail.com>
 <CAKErNvoCWWHrWGDT+rqKzGgzeaTexss=tNTm0+9Vr-TOH_8y=Q@mail.gmail.com>
 <CANn89iL2Jajn65L7YhqtjTAVMKNpkH0+-zJtQwFVcgrtJwxEWg@mail.gmail.com>
 <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com> <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
 <9f4c2ca9-bc6d-f2bf-6c03-e95affb55aae@nvidia.com> <CANn89iJkdQ9eBkwmWMcf7uKwB=cY8hbwo2Jqdtwo3mpjswAFHg@mail.gmail.com>
 <e1ccfefa-7910-ca96-9c7f-042df2265db6@nvidia.com>
In-Reply-To: <e1ccfefa-7910-ca96-9c7f-042df2265db6@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 20 Nov 2022 09:00:54 -0800
Message-ID: <CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
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

On Sun, Nov 20, 2022 at 8:43 AM Gal Pressman <gal@nvidia.com> wrote:
>
> On 20/11/2022 18:09, Eric Dumazet wrote:
> > On Sat, Nov 19, 2022 at 11:42 PM Gal Pressman <gal@nvidia.com> wrote:
> >> On 10/11/2022 11:08, Gal Pressman wrote:
> >>> On 06/11/2022 10:07, Gal Pressman wrote:
> >>>> It reproduces consistently:
> >>>> ip link set dev eth2 up
> >>>> ip addr add 194.237.173.123/16 dev eth2
> >>>> tc qdisc add dev eth2 clsact
> >>>> tc qdisc add dev eth2 root handle 1: htb default 1 offload
> >>>> tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil
> >>>> 22500.0mbit burst 450000kbit cburst 450000kbit
> >>>> tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst
> >>>> 89900kbit cburst 89900kbit
> >>>> tc qdisc delete dev eth2 clsact
> >>>> tc qdisc delete dev eth2 root handle 1: htb default 1
> >>>>
> >>>> Please let me know if there's anything else you want me to check.
> >>> Hi Eric, did you get a chance to take a look?
> >> No response for quite a long time, Jakub, should I submit a revert?
> > Sorry, I won't have time to look at this before maybe two weeks.
>
> Thanks for the response, Eric.
>
> > If you want to revert a patch which is correct, because some code
> > assumes something wrong,
>
> I am not convinced about the "code assumes something wrong" part, and
> not sure what are the consequences of this WARN being triggered, are you?
>
> > I will simply say this seems not good.
>
> Arguable, it is not that clear that a fix that introduces another issue
> is a good thing, particularly when we don't understand the severity of
> the thing that got broken.

The offload part has been put while assuming a certain (clearly wrong) behavior.

RCU rules are quite the first thing we need to respect in the kernel.

Simply put, when KASAN detects a bug, you can be pretty damn sure it
is a real one.

>
> Two weeks gets us to the end of -rc7, a bit too dangerous to my personal
> taste, but I'm not the one making the calls.

Agreed, please try to find someone at nvidia able to understand what Maxim
was doing in commit ca49bfd90a9dde175d2929dc1544b54841e33804

If something needs stronger rules than standard RCU ones, this should
be articulated.

As I said, I won't be able to work on this before ~2 weeks.
