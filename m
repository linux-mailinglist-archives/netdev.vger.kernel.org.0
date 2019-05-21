Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D82A247AE
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 07:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfEUFxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 01:53:42 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36548 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbfEUFxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 01:53:41 -0400
Received: by mail-ot1-f68.google.com with SMTP id c3so15267103otr.3
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 22:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JorKV4Kq9yx1/yMVsqWJ2MeYU2dO9nBlXbTrRcE7ghQ=;
        b=qQz1vGteNEwPooazAAaAvv6UTno2o/VebBwbHzqpF2tA0PPkAIY5AjjCn8h9J+FkOs
         ndPenK9u1GFVI28DWe1IikGIiPyi2OHzfL6ZpsUaTcv/BW/Di7ntw0O+9TIY0KRUM6pN
         N92k4XCFGzaPgNUF3hM7CGSuS8H2Zv/SWH4Mlq9U+0X1SmGWvkCKWLVbdM1QvLW+5QzO
         Pf6oKX3WhtT4X9Y9mbzlMw610HY+W5p9b1SzO2dBeOKpDWKtyMF1YmM0r9lfa0iI1Dzx
         X9t/ZT+AvFjGJLPr64yahyP8wGALOt4erd58XczRqwslX5CiSMvmkWzVMpfg/PRo8nhd
         HvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JorKV4Kq9yx1/yMVsqWJ2MeYU2dO9nBlXbTrRcE7ghQ=;
        b=dGENULGeEvbt40/lCnIjbGn0WMi2372YlCicoOE5ADVo6e5WpTMQ1jGP5chwD++L4s
         YLM0vtd1XGLWfErHNkG0u5EZ/ukm654iZVz8e9OH/uPKYEQy0ARVruvu46bJcN440bRS
         DOZ7b2aFjdyZB4I/320uZMR8LiSahZZJUs/yB/soMZL5rtysO2HwcTHqWdHP6MP9xkfj
         iCv/9w8isIkHzJVQKqp3+7qWheiPw/Fn+ixs6FbJRs04+2P2Fl/m+xXneQYae4iCK6VC
         1R8s6mGVj6VstT3huIGbMmsNldI0sc/j76D7/hzo91h2zoBhw4nTG1Top4ngqk5mt2Ef
         pvzg==
X-Gm-Message-State: APjAAAXNTxV67Ce/5IdC77hbxUI5RHus4UuA7WgC/64wzc2MYfnwUV/B
        mpPlpzUjBMuh5MveY1muFpof0PztxSLJR3T6V/Yuowul
X-Google-Smtp-Source: APXvYqzjpUrD3J8gfY6i8iBVLhj9tIyQMLp6eH7fcHFYfR6/XK6s4iq0kzCTzMM85E/cx2o7MP1onbsXdIvLaMYAUco=
X-Received: by 2002:a9d:638f:: with SMTP id w15mr36006618otk.16.1558418021314;
 Mon, 20 May 2019 22:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <1558147343-93724-1-git-send-email-xiangxia.m.yue@gmail.com> <20190520.195319.201742803310676769.davem@davemloft.net>
In-Reply-To: <20190520.195319.201742803310676769.davem@davemloft.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 21 May 2019 13:53:04 +0800
Message-ID: <CAMDZJNWpv89beaNvVvycJ5YqwcKYiFNuP_gYKz_QmsQ2roiRGw@mail.gmail.com>
Subject: Re: [PATCH] net: vxlan: disallow removing to other namespace
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 7:53 AM David Miller <davem@davemloft.net> wrote:
>
> From: xiangxia.m.yue@gmail.com
> Date: Fri, 17 May 2019 19:42:23 -0700
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Don't allow to remove the vxlan device to other namesapce,
> > because we maintain the data of vxlan net device on original
> > net-namespace.
> >
> >     $ ip netns add ns100
> >     $ ip link add vxlan100 type vxlan dstport 4789 external
> >     $ ip link set dev vxlan100 netns ns100
> >     $ ip netns exec ns100 ip link add vxlan200 type vxlan dstport 4789 external
> >     $ ip netns exec ns100 ip link
> >     ...
> >     vxlan200: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >     vxlan100: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >
> > And we should create it on new net-namespace, so disallow removing it.
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> I don't understand this change at all.
>
> You keep saying "Remove" but I think you might mean simply "Move" because
> the NETNS_LOCAL flag prevents moving not removing.
Yes, should change "remove" to "move".

> And why is it bad to allow vxlan devices to be moved between network
> namespaces?  What problem would it cause and can you guarantee that
> you are not breaking an existing user?

The problem is that we create one vxlan netdevice(e.g dstport 4789 and
external), and move it to
one net-namespace, and then we hope create one again(dstport 4789 and
external) and move it to other net-namespace, but we can't create it.

$ ip netns add ns100
$ ip link add vxlan100 type vxlan dstport 4789 external
$ ip link set dev vxlan100 netns ns100
$ ip link add vxlan200 type vxlan dstport 4789 external
RTNETLINK answers: File exists

The better way is that we should create directly it in the
net-namespace. To avoid confuse user, disallow moving it to other
net-namespace.

> I'm not applying this as-is.
