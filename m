Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB94EEE27
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390007AbfKDWMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:12:53 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:43135 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389413AbfKDWKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:10:34 -0500
X-Originating-IP: 209.85.217.41
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
        (Authenticated sender: pshelar@ovn.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 65B1140008
        for <netdev@vger.kernel.org>; Mon,  4 Nov 2019 22:10:32 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id m6so5518490vsn.13
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 14:10:32 -0800 (PST)
X-Gm-Message-State: APjAAAXLI3pcsyD8MIl1vkfl5UVDmkKmFjsA/hcW+J6JzECjbA3bIGNL
        Ob9XpbhK+3tja87qqfkA1Vup9qhDNb85r3ZIYXU=
X-Google-Smtp-Source: APXvYqwgMQiFGuI9j9SRhxe0HQ84Di1pbqxzO2kDHLWpcIvwSpvDxN7VmdOdaUNIp07OMcPMwjApwO0f0UgJCtuQhUk=
X-Received: by 2002:a67:eec7:: with SMTP id o7mr12957662vsp.58.1572905430930;
 Mon, 04 Nov 2019 14:10:30 -0800 (PST)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1572618234-6904-6-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_CkZJ+w3LvUyzUZRgnFa1JnkkKY85XsjEMvXD4geAzW4g@mail.gmail.com> <CALDO+SYq2FGK5i=LDxKx8GYAEF=juMRNSXe0URb+rvGog1FYTw@mail.gmail.com>
In-Reply-To: <CALDO+SYq2FGK5i=LDxKx8GYAEF=juMRNSXe0URb+rvGog1FYTw@mail.gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 4 Nov 2019 14:10:18 -0800
X-Gmail-Original-Message-ID: <CAOrHB_CHSY3UQJgwYeP1p7LHHkf8OFdNSUJLvZGxw8SOvdrd0g@mail.gmail.com>
Message-ID: <CAOrHB_CHSY3UQJgwYeP1p7LHHkf8OFdNSUJLvZGxw8SOvdrd0g@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v6 05/10] net: openvswitch: optimize
 flow-mask looking up
To:     William Tu <u9012063@gmail.com>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 4, 2019 at 6:00 AM William Tu <u9012063@gmail.com> wrote:
>
> On Sat, Nov 2, 2019 at 11:50 PM Pravin Shelar <pshelar@ovn.org> wrote:
> >
> > On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > The full looking up on flow table traverses all mask array.
> > > If mask-array is too large, the number of invalid flow-mask
> > > increase, performance will be drop.
> > >
> > > One bad case, for example: M means flow-mask is valid and NULL
> > > of flow-mask means deleted.
> > >
> > > +-------------------------------------------+
> > > | M | NULL | ...                  | NULL | M|
> > > +-------------------------------------------+
> > >
> > > In that case, without this patch, openvswitch will traverses all
> > > mask array, because there will be one flow-mask in the tail. This
> > > patch changes the way of flow-mask inserting and deleting, and the
> > > mask array will be keep as below: there is not a NULL hole. In the
> > > fast path, we can "break" "for" (not "continue") in flow_lookup
> > > when we get a NULL flow-mask.
> > >
> > >          "break"
> > >             v
> > > +-------------------------------------------+
> > > | M | M |  NULL |...           | NULL | NULL|
> > > +-------------------------------------------+
> > >
> > > This patch don't optimize slow or control path, still using ma->max
> > > to traverse. Slow path:
> > > * tbl_mask_array_realloc
> > > * ovs_flow_tbl_lookup_exact
> > > * flow_mask_find
> > >
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > > ---
> > Acked-by: Pravin B Shelar <pshelar@ovn.org>
>
> Nack to this patch.
>
> It makes the mask cache invalid when moving the flow mask
> to fill another hole.
> And the penalty for miss the mask cache is larger than the
> benefit of this patch (avoiding the NULL flow-mask).
>
Hi William,

The cache invalidation would occur in case of changes to flow mask
list. I think in general datapath processing there should not be too
many changes to mask list since a mask is typically shared between
multiple mega flows. Flow-table changes does not always result in mask
list updates. In last round Tonghao has posted number to to support
this patch.
If you are worried about some other use case can you provide
performance numbers, that way we can take this discussion forward.

Thanks,
Pravin.
