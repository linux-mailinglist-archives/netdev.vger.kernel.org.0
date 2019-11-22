Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A56106687
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKVGeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:34:06 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36995 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfKVGeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 01:34:05 -0500
X-Originating-IP: 209.85.222.47
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 455E91C0007
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 06:34:03 +0000 (UTC)
Received: by mail-ua1-f47.google.com with SMTP id l38so1825053uad.4
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 22:34:03 -0800 (PST)
X-Gm-Message-State: APjAAAUzot0tGurhX3w0y+1hELmGBmmfMZ4NHGkCqUveO83j3GrmOaE5
        5aSBrIgKQ6T/Gs3z2k36AlStfkLT5+eC6Gs3MvY=
X-Google-Smtp-Source: APXvYqxAi4tYafkQQSePlhs5swGRZ2iwPJfvwXsD5DMxxnSaQeCK8QzEm7uEuFsZBq9X4hDcZiUGryy/zXZfiwVsmkg=
X-Received: by 2002:ab0:694e:: with SMTP id c14mr8931558uas.118.1574404441831;
 Thu, 21 Nov 2019 22:34:01 -0800 (PST)
MIME-Version: 1.0
References: <1574338995-14657-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_De_A=jY-fBqJjXDQKemEOOfJtpvqGR_bi3_-x8+od2eg@mail.gmail.com> <20191122051253.GA19664@martin-VirtualBox>
In-Reply-To: <20191122051253.GA19664@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 21 Nov 2019 22:33:49 -0800
X-Gmail-Original-Message-ID: <CAOrHB_D4tD_1_GGjn2_sMyWXMS+NHJLWT6rTjrUYJECHOkwWkg@mail.gmail.com>
Message-ID: <CAOrHB_D4tD_1_GGjn2_sMyWXMS+NHJLWT6rTjrUYJECHOkwWkg@mail.gmail.com>
Subject: Re: [PATCH net-next] Enhanced skb_mpls_pop to update ethertype of the
 packet in all the cases when an ethernet header is present is the packet.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 9:13 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Nov 21, 2019 at 06:22:29PM -0800, Pravin Shelar wrote:
> > On Thu, Nov 21, 2019 at 4:23 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The skb_mpls_pop was not updating ethertype of an ethernet packet if the
> > > packet was originally received from a non ARPHRD_ETHER device.
> > >
> > > In the below OVS data path flow, since the device corresponding to port 7
> > > is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
> > > the ethertype of the packet even though the previous push_eth action had
> > > added an ethernet header to the packet.
> > >
> > > recirc_id(0),in_port(7),eth_type(0x8847),
> > > mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
> > > actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
> > > pop_mpls(eth_type=0x800),4
> > >
> > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > > ---
> > >  include/linux/skbuff.h    | 3 ++-
> > >  net/core/skbuff.c         | 8 +++++---
> > >  net/openvswitch/actions.c | 2 +-
> > >  net/sched/act_mpls.c      | 2 +-
> > >  4 files changed, 9 insertions(+), 6 deletions(-)
> > >
> > ...
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 867e61d..8ac377d 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5529,12 +5529,14 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
> > >   * @skb: buffer
> > >   * @next_proto: ethertype of header after popped MPLS header
> > >   * @mac_len: length of the MAC header
> > > - *
> > > + * @ethernet: flag to indicate if ethernet header is present in packet
> > > + *           ignored for device type ARPHRD_ETHER
> > >   * Expects skb->data at mac header.
> > >   *
> > >   * Returns 0 on success, -errno otherwise.
> > >   */
> > > -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> > > +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> > > +                bool ethernet)
> > >  {
> > >         int err;
> > >
> > > @@ -5553,7 +5555,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> > >         skb_reset_mac_header(skb);
> > >         skb_set_network_header(skb, mac_len);
> > >
> > > -       if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> > > +       if ((skb->dev && skb->dev->type == ARPHRD_ETHER) || ethernet) {
> > >                 struct ethhdr *hdr;
> > Lets move the dev-type check to caller. That would also avoid one more
> > argument to this function.
>
>
> To have only the ethernet flag check in the function like below ?
>  If (ethernet) {
>      /*pseudo*/   Update ethertype
>  }
> And pass the flag to the function considering the device type
> Fo example in case of tc.
>
> if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
>                                  (skb->dev && skb->dev->type == ARPHRD_ETHER))).
>
>
> But how do we avoid an argument here ? I am missing anything ?

Right, I wanted to say new predicate can be eliminated.

> >
> > >
> > >                 /* use mpls_hdr() to get ethertype to account for VLANs. */
> > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > index 12936c1..9e5d274 100644
> > > --- a/net/openvswitch/actions.c
> > > +++ b/net/openvswitch/actions.c
> > > @@ -179,7 +179,7 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> > >  {
> > >         int err;
> > >
> > > -       err = skb_mpls_pop(skb, ethertype, skb->mac_len);
> > > +       err = skb_mpls_pop(skb, ethertype, skb->mac_len, true);
> > >         if (err)
> > OVS supports L3 packets, you need to check flow key for type of packet
> > (ovs_key_mac_proto()) under process.
>
>
> Yes I missed that.
>         err = skb_mpls_pop(skb, ethertype, skb->mac_len, ovs_key_mac_proto())); ?
>        or
>         err = skb_mpls_pop(skb, ethertype, skb->mac_len, key->mac_proto = MAC_PROTO_ETHERNET)
I like the second which is more explicit.
