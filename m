Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053B29C61B
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 22:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfHYUi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 16:38:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48519 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbfHYUi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 16:38:57 -0400
X-Originating-IP: 209.85.217.54
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (Authenticated sender: pshelar@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 6D51EE0003
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:38:54 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id y62so9627529vsb.6
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 13:38:54 -0700 (PDT)
X-Gm-Message-State: APjAAAXh6xi+M/IEKA5QVH3beBuueWVkEp4tL33u+F+nOUV9pHQyfGlv
        NDPE0Z/d7RzRGKpeZnmh5KsYb1n4xvYOHY1zrUI=
X-Google-Smtp-Source: APXvYqz6q+NabJf+IaOJNGw87dIWz3QrR7bWj/W/wDlGB13Tb/DJMOdfg9llZwDOpvpgB0y6i3x6fgqDvE8ZgTeRodM=
X-Received: by 2002:a67:f98c:: with SMTP id b12mr8259575vsq.47.1566765533086;
 Sun, 25 Aug 2019 13:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190824165846.79627-1-jpettit@ovn.org> <CAOrHB_AU1gQ74L5WawyA4THhh=MG8YZhcvkkxnKgRG+5m-436g@mail.gmail.com>
In-Reply-To: <CAOrHB_AU1gQ74L5WawyA4THhh=MG8YZhcvkkxnKgRG+5m-436g@mail.gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 25 Aug 2019 13:40:58 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BKd=QKR_ScO+r7qAyZaniEbFur+iup1iXbtiycaFawjw@mail.gmail.com>
Message-ID: <CAOrHB_BKd=QKR_ScO+r7qAyZaniEbFur+iup1iXbtiycaFawjw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] openvswitch: Properly set L4 keys on "later" IP fragments.
To:     Justin Pettit <jpettit@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 9:54 AM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Sat, Aug 24, 2019 at 9:58 AM Justin Pettit <jpettit@ovn.org> wrote:
> >
> > When IP fragments are reassembled before being sent to conntrack, the
> > key from the last fragment is used.  Unless there are reordering
> > issues, the last fragment received will not contain the L4 ports, so the
> > key for the reassembled datagram won't contain them.  This patch updates
> > the key once we have a reassembled datagram.
> >
> > Signed-off-by: Justin Pettit <jpettit@ovn.org>
> > ---
> >  net/openvswitch/conntrack.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > index 848c6eb55064..f40ad2a42086 100644
> > --- a/net/openvswitch/conntrack.c
> > +++ b/net/openvswitch/conntrack.c
> > @@ -524,6 +524,10 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
> >                 return -EPFNOSUPPORT;
> >         }
> >
> > +       /* The key extracted from the fragment that completed this datagram
> > +        * likely didn't have an L4 header, so regenerate it. */
> > +       ovs_flow_key_update(skb, key);
> > +
> >         key->ip.frag = OVS_FRAG_TYPE_NONE;
> >         skb_clear_hash(skb);
> >         skb->ignore_df = 1;
> > --
>
> Looks good to me.
>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>
Actually I am not sure about this change. caller of this function
(ovs_ct_execute()) does skb-pull and push of L2 header, calling
ovs_flow_key_update() is not safe here, it expect skb data to point to
L2 header.
