Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F135511C4E5
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 05:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfLLETV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 23:19:21 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:32825 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbfLLETV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 23:19:21 -0500
X-Originating-IP: 209.85.222.47
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
        (Authenticated sender: pshelar@ovn.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 1FA9440003
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 04:19:18 +0000 (UTC)
Received: by mail-ua1-f47.google.com with SMTP id z17so355307uac.5
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 20:19:18 -0800 (PST)
X-Gm-Message-State: APjAAAWVBYdGSa+gnqq+9nozsFw7R9yP+6oiORPZe4I5PEs3J+5JMMyA
        B8//I+BRztdlbI/ExvKaCGMJ/5iEdO5PKpA3qCU=
X-Google-Smtp-Source: APXvYqwx7u/1Snfpj6Q8+z6RwwfjP6oin4OFCKVfcc5nEhQU7j8hf0ZqwJVssQ1k0na6acpLvNMrU7bzGeebAlpC3c0=
X-Received: by 2002:ab0:66d4:: with SMTP id d20mr6403982uaq.64.1576124357716;
 Wed, 11 Dec 2019 20:19:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
 <20191211000245.GB2687@martin-VirtualBox> <CAOrHB_D0sjWcFR6KfXidDSk=5pWPMzStF2vU+GRQZ4KCVcm5tA@mail.gmail.com>
 <20191211153900.GA5156@martin-VirtualBox>
In-Reply-To: <20191211153900.GA5156@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 11 Dec 2019 20:19:08 -0800
X-Gmail-Original-Message-ID: <CAOrHB_BCWcyO-v1ige_4i9PM84qxXqd4SXmVvpv31AA8-af26g@mail.gmail.com>
Message-ID: <CAOrHB_BCWcyO-v1ige_4i9PM84qxXqd4SXmVvpv31AA8-af26g@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 7:39 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Dec 10, 2019 at 10:15:19PM -0800, Pravin Shelar wrote:
> > On Tue, Dec 10, 2019 at 4:02 PM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Tue, Dec 10, 2019 at 01:22:56PM -0800, Pravin Shelar wrote:
> > > > On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
> > > > <martinvarghesenokia@gmail.com> wrote:
> > > > >
> > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > >
> > > > > The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> > > > > between ethernet header and the IP header. Though this behaviour is fine
> > > > > for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> > > > > does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> > > > > the MPLS header should encapsulate the ethernet packet.
> > > > >
> > > > > The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> > > > > MPLS header from start of the packet respectively.
> > > > >
> > > > > PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> > > > > @ethertype - Ethertype of MPLS header.
> > > > >
> > > > > PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> > > > > @ethertype - Ethertype of next header following the popped MPLS header.
> > > > >              Value 0 in ethertype indicates the tunnelled packet is
> > > > >              ethernet.
> > > > >
> > > > Did you considered using existing MPLS action to handle L2 tunneling
> > > > packet ? It can be done by adding another parameter to the MPLS
> > > > actions.
> > >
> >
> > >
> > >
> > > Not really.
> > >
> > > Are you suggesting to extend the ovs_action_push_mpls and similarly for pop
> > >
> > > struct ovs_action_push_mpls {
> > >         __be32 mpls_lse;
> > >         __be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> > > +        bool l2_tunnel;
> > > };
> > >
> > > Does not that break the compatibilty with the existing userspace
> > > OVS ?
> > >
> > Right, extending this would not look good. I am fine with new action.
> > But we can design this new action as superset of existing and PTAP
> > functionality, This way in future we can deprecate existing MPLS
> > action in favor of new action.
> > I think if you add mac_len parameter for the action it would take case
> > of both cases.
> Yes i guess so.
> On the similar lines i guess we dont need a new PTAP_POP action as the existing
> pop action pops mpls header from the start of the packet if the skb->mac_len=0
> We just neeed a add a special handling for ethertype 0 is the existing pop
> implementation

Passing next_proto as zero to skb_mpls_pop() would set skb->protocol
to zero. That does not look good. Lets pass mac_len and next_proto for
both Push and Pop action. I am also fine using using boolean to
distinguish between L2 and L3 case. In that case we are dependent on
skb->mac_len.
