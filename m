Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D544A88C1
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352300AbiBCQmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348320AbiBCQmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:42:08 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17441C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:42:08 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id g14so10650683ybs.8
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PyZlZ5xnp/HqKaz++QDORxWhQWFqxhOlZV2mM+faJ38=;
        b=n9wrpMX6Ea/3uXs1xPEgcTKPjyRlxR572rFfZDVvBU/aD9HiNIPbsiQ5Lmc7y5I1Fg
         BZU9Ba3YsOU0X2TkTAsRzLjLAG3mRO1sevgfIga+KKrvX0sXkhA84oulP4PvFUbc+unM
         imMoqksed0pJr3F365QO6iu+SIdDfZM95LIOJGMVY0pRY8feVejdTlbXdTw/P3kDWG6f
         lz6ARGV0E6Y0vF9Ogq3aXn2PGv1Hy8Zx+g+xLNvcuN2mgJyvj825Sho0T3vAklghOVQV
         ZHe/XSf5om1JXv0P0sRBLFlZAr91j7UuzZuqSSN8AKYLOgpJ0+ySgIoqkA7OvLVEJrIz
         3gUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PyZlZ5xnp/HqKaz++QDORxWhQWFqxhOlZV2mM+faJ38=;
        b=U4IfrnjZGaw7m4zuhG51TQWb11CLYG8RbZHlHYl5B0r2/gwUroBUZlypaJz0S7/30T
         Vv4wUKjD6whV3W3XNNfT3lhabie40xbgyCY6x0ihofXBXgOI9CQMLLjmZX2I4xgpxsRR
         HIhdmLD8MK7rEvFG52+pcS8WA4rnao8CSxo9L411FcCplUrMnsmcHSxrrjZ4XbodS5JJ
         LWNkLrHdP15UsnAYDjjY88peOJ0gRr7r8lRZEW+slyT0b+XcraLkTGUq2KdL40tBWVwG
         lUg21TES6dsgqNFp0N3wanZBYUtDHgwLTfYZ2ogpdJsDZoXAo/tQa/zjPUSaMa4leNl3
         YJbw==
X-Gm-Message-State: AOAM532CDJtPDqXOSdN7jbJT7sk4IEw8G/IQjUlDoElzJv8DGmkG97Ll
        6RNjnJ1V5HSN1+EIpMHYe5JM5+1nd6wce1OBbUtsTg==
X-Google-Smtp-Source: ABdhPJzNwHIPcve7JsWgczl4xlaHXNQhgtimT7MeGo0TAvlAmGF9mNhHfRFFLlZTDS5L8N9LnqiuX14ZAEUCxW5baQE=
X-Received: by 2002:a25:d9c2:: with SMTP id q185mr45710097ybg.293.1643906527022;
 Thu, 03 Feb 2022 08:42:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643902526.git.pabeni@redhat.com> <550566fedb425275bb9d351a565a0220f67d498b.1643902527.git.pabeni@redhat.com>
 <CANn89iLvee2jqB7R7qap9i-_johkbKofHE4ARct18jM_DwdaZg@mail.gmail.com> <20220203162619.13881-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220203162619.13881-1-alexandr.lobakin@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 08:41:55 -0800
Message-ID: <CANn89i+PnPNFpd-eap1n5VPZn__+Q-0BCP46hf+_kVJfw_phYQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: gro: register gso and gro offload on
 separate lists
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 8:28 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Thu, 3 Feb 2022 08:11:43 -0800
>
> > On Thu, Feb 3, 2022 at 7:48 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > So that we know each element in gro_list has valid gro callbacks
> > > (and the same for gso). This allows dropping a bunch of conditional
> > > in fastpath.
> > >
> > > Before:
> > > objdump -t net/core/gro.o | grep " F .text"
> > > 0000000000000bb0 l     F .text  000000000000033c dev_gro_receive
> > >
> > > After:
> > > 0000000000000bb0 l     F .text  0000000000000325 dev_gro_receive
> > >
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  include/linux/netdevice.h |  3 +-
> > >  net/core/gro.c            | 90 +++++++++++++++++++++++----------------
> > >  2 files changed, 56 insertions(+), 37 deletions(-)
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 3213c7227b59..406cb457d788 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -2564,7 +2564,8 @@ struct packet_offload {
> > >         __be16                   type;  /* This is really htons(ether_type). */
> > >         u16                      priority;
> > >         struct offload_callbacks callbacks;
> > > -       struct list_head         list;
> > > +       struct list_head         gro_list;
> > > +       struct list_head         gso_list;
> > >  };
> > >
> >
> > On the other hand, this makes this object bigger, increasing the risk
> > of spanning cache lines.
>
> As you said, GSO callbacks are barely used with most modern NICs.
> Plus GRO and GSO callbacks are used in the completely different
> operations.
> `gro_list` occupies the same place where the `list` previously was.
> Does it make a lot of sense to care about `gso_list` being placed
> in a cacheline separate from `gro_list`?

Not sure what you are asking in this last sentence.

Putting together all struct packet_offload and struct net_offload
would reduce number of cache lines,
but making these objects bigger is conflicting.

Another approach to avoiding conditional tests would be to provide non
NULL values
for all "struct offload_callbacks"  members, just in case we missed something.

I think the test over ptype->type == type should be enough, right ?
