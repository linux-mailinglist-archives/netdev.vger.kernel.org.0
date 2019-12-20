Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274D5127511
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 06:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLTFRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 00:17:24 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:39703 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfLTFRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 00:17:24 -0500
X-Originating-IP: 209.85.222.54
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 44E16240002
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 05:17:21 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id o42so2808941uad.10
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 21:17:21 -0800 (PST)
X-Gm-Message-State: APjAAAWDHdVZA5v+PeTqmsOEcIW3Q5wtIEZIiIjhci+9pzV+xh6MAyHd
        /qmVe7QoiVDF/x1xtHH++eWgDFbia21GkwNL9mA=
X-Google-Smtp-Source: APXvYqzGGXG67iveBrlTGpqB4mlfzNaO5BnGzHRzo108yByiwPgWYZDD8tPhHL5IbW7NHuasTcXjS4QZJy1OcHZXrLI=
X-Received: by 2002:ab0:2006:: with SMTP id v6mr7679273uak.22.1576819040009;
 Thu, 19 Dec 2019 21:17:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576648350.git.martin.varghese@nokia.com>
 <f78a4e44caac82f0f1db5c89dfd30696c2cb192e.1576648350.git.martin.varghese@nokia.com>
 <CAOrHB_CTqSYc7TBuVqU64f7TjLQNmggWg69zYxrLwrC0Sgjf=A@mail.gmail.com>
 <20191219041234.GA2840@martin-VirtualBox> <CAOrHB_B88W_bnQGkE_=fML-6GyLUOzZ5FoL-WbvSCoU-D-d+fA@mail.gmail.com>
 <20191220030428.GA4534@martin-VirtualBox>
In-Reply-To: <20191220030428.GA4534@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 19 Dec 2019 21:17:09 -0800
X-Gmail-Original-Message-ID: <CAOrHB_CcuRDS5qB__+p357jQbRpnHoXqeUO0xVhQD6DrP9ZyOQ@mail.gmail.com>
Message-ID: <CAOrHB_CcuRDS5qB__+p357jQbRpnHoXqeUO0xVhQD6DrP9ZyOQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
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

On Thu, Dec 19, 2019 at 7:04 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Dec 19, 2019 at 05:07:25PM -0800, Pravin Shelar wrote:
> > On Wed, Dec 18, 2019 at 8:12 PM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Wed, Dec 18, 2019 at 07:50:52PM -0800, Pravin Shelar wrote:
> > > > On Tue, Dec 17, 2019 at 10:56 PM Martin Varghese
> > > > <martinvarghesenokia@gmail.com> wrote:
> > > > >
> > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > >
> > > > > The existing PUSH MPLS action inserts MPLS header between ethernet header
> > > > > and the IP header. Though this behaviour is fine for L3 VPN where an IP
> > > > > packet is encapsulated inside a MPLS tunnel, it does not suffice the L2
> > > > > VPN (l2 tunnelling) requirements. In L2 VPN the MPLS header should
> > > > > encapsulate the ethernet packet.
> > > > >
> > > > > The new mpls action PTAP_PUSH_MPLS inserts MPLS header at the start of the
> > > > > packet or at the start of the l3 header depending on the value of l2 tunnel
> > > > > flag in the PTAP_PUSH_MPLS arguments.
> > > > >
> > > > > POP_MPLS action is extended to support ethertype 0x6558.
> > > > >
> > > > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > > > > ---
> > > > > Changes in v2:
> > > > >    - PTAP_POP_MPLS action removed.
> > > > >    - Special handling for ethertype 0 added in PUSH_MPLS.
> > > > >    - Refactored push_mpls function to cater existing push_mpls and
> > > > >      ptap_push_mpls actions.
> > > > >    - mac len to specify the MPLS header location added in PTAP_PUSH_MPLS
> > > > >      arguments.
> > > > >
> > > > > Changes in v3:
> > > > >    - Special handling for ethertype 0 removed.
> > > > >    - Added support for ether type 0x6558.
> > > > >    - Removed mac len from PTAP_PUSH_MPLS argument list
> > > > >    - used l2_tun flag to distinguish l2 and l3 tunnelling.
> > > > >    - Extended PTAP_PUSH_MPLS handling to cater PUSH_MPLS action also.
> > > > >
> > > > > Changes in v4:
> > > > >    - Removed extra blank lines.
> > > > >    - Replaced bool l2_tun with u16 tun flags in
> > > > >      struct ovs_action_ptap_push_mpls.
> > > > >
> > > > The patch looks almost ready. I have couple of comments.
> > > >
> > > > >  include/uapi/linux/openvswitch.h | 31 +++++++++++++++++++++++++++++++
> > > > >  net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
> > > > >  net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 89 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > > > > index a87b44c..d9461ce 100644
> > > > > --- a/include/uapi/linux/openvswitch.h
> > > > > +++ b/include/uapi/linux/openvswitch.h
> > > > > @@ -673,6 +673,32 @@ struct ovs_action_push_mpls {
> > > > >  };
> > > > >
> > > > ...
> > > > ...
> > > > > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > > > > index 65c2e34..85fe7df 100644
> > > > > --- a/net/openvswitch/flow_netlink.c
> > > > > +++ b/net/openvswitch/flow_netlink.c
> > > > > @@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
> > > > >                 case OVS_ACTION_ATTR_SET_MASKED:
> > > > >                 case OVS_ACTION_ATTR_METER:
> > > > >                 case OVS_ACTION_ATTR_CHECK_PKT_LEN:
> > > > > +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
> > > > >                 default:
> > > > >                         return true;
> > > > >                 }
> > > > > @@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> > > > >                         [OVS_ACTION_ATTR_METER] = sizeof(u32),
> > > > >                         [OVS_ACTION_ATTR_CLONE] = (u32)-1,
> > > > >                         [OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
> > > > > +                       [OVS_ACTION_ATTR_PTAP_PUSH_MPLS] = sizeof(struct ovs_action_ptap_push_mpls),
> > > > >                 };
> > > > >                 const struct ovs_action_push_vlan *vlan;
> > > > >                 int type = nla_type(a);
> > > > > @@ -3072,6 +3074,33 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> > > > >                 case OVS_ACTION_ATTR_RECIRC:
> > > > >                         break;
> > > > >
> > > > > +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
> > > > Can you change name of this action given this can handle both L2 and
> > > > L3 MPLS tunneling?
> > > >
> > > > > +                       const struct ovs_action_ptap_push_mpls *mpls = nla_data(a);
> > > > > +
> > > > > +                       if (!eth_p_mpls(mpls->mpls_ethertype))
> > > > > +                               return -EINVAL;
> > > > > +
> > > > > +                       if (!(mpls->tun_flags & OVS_MPLS_L2_TUNNEL_FLAG_MASK)) {
> > > > > +                               if (vlan_tci & htons(VLAN_CFI_MASK) ||
> > > > > +                                   (eth_type != htons(ETH_P_IP) &&
> > > > > +                                    eth_type != htons(ETH_P_IPV6) &&
> > > > > +                                    eth_type != htons(ETH_P_ARP) &&
> > > > > +                                    eth_type != htons(ETH_P_RARP) &&
> > > > > +                                    !eth_p_mpls(eth_type)))
> > > > > +                                       return -EINVAL;
> > > > > +                               mpls_label_count++;
> > > > > +                       } else {
> > > > > +                               if (mac_proto != MAC_PROTO_NONE) {
> > > > It is better to check for 'MAC_PROTO_ETHERNET', rather than this negative test.
> > > >
> > > The idea is that if you have a l2 header you need to reset the mpls label count
> > > Either way fine for me.Let me know
> > Lets change it to  "if (mac_proto  == MAC_PROTO_ETHERNET)"
> >
> Yes, but it will not work for a hypothetical case where l2
> is no ethernet.
At this point it would be clear if you just check with MAC_PROTO_ETHERNET.

> > > > > +                                       mpls_label_count = 1;
> > > > > +                                       mac_proto = MAC_PROTO_NONE;
> > > > > +                               } else {
> > > > > +                                       mpls_label_count++;
> > > > > +                               }
> > > > We need to either disallow combination of L3 and L2 MPLS_PUSH, POP
> > > > actions in a action list or keep separate label count. Otherwise it is
> > > > impossible to validate mpls labels stack depth in POP actions.
> > > >
> > >
> > > I assume it is taken in care in the above block
> > >
> > > let us consider the different cases
> > >
> > > 1.
> > >   Incoming Packet - ETH|IP|Payload
> > >   Actions = push_mpls(0x1),push_mpls(0x2),ptap_push_mpls(0x03)
> > >   Resulting packet - MPLS(3)|Eth|MPLS(2)|MPLS(1)|IP|Payload
> > >   Total Mpls count = 1
> > >
> > >   Since the total MPLS count = 1,ony one POP will be allowed and a recirc is need to
> > >   parse the inner packets
> > >
> > > 2. Incoming Packet - ETH|MPLS(1)|IP|Payload
> > >    Actions = ptap_push_mpls(0x03)
> > >    Resulting packet - MPLS(3)|Eth|MPLS(1)|IP|Payload
> > >    Total Mpls count = 1
> > >
> > >    Since the total MPLS count = 1,ony one POP will be allowed and a recirc is need to
> > >    parse the inner packets
> > >
> > > 3. Incoming Packet - MPLS(1)|IP|Payload
> > >    Actions = ptap_push_mpls(0x03)
> > >    Resulting packet - MPLS(3)|MPLS(1)|IP|Payload
> > >    Total Mpls count = 2
> > >
> > >    Since the total MPLS acount is 2 , 2 pops are allowd
> > >
> > >
> > > Is there any other case ?
> > >
> > I was think case of action list: PUSH_MPLS_L2, PUSH_MPLS_L3, ....,
> > POP_MPLS_L2, POP_MPLS_L2
> > This action will pass the validation. It would also work fine in
> > datapath since POP action can detect L2 and L3 packet dynamically. But
> > it is inconsistent with actions intention.
>
> I couldnt get the concern correctly.

My concern is more about separating L3 MPLS vs PTAP cases.
I guess its not that big deal. so I am fine with current validation.

Thanks.
> THere is no POPMPLS l2.There is only one type of MPLS POP
> the pop MPLS always removes MPLS header after mac header
>
> In the case of POP_MPLS:0x6558 the ethernet header should not be
> present as we dont support ethernet in ethernet.We have the validation
> in flow_netlink.c
> So for the POP_MPLS:0x6558 to work ,it should be preceeded by a pop_eth
> if is a ethernet packet.
>
> Considering the action above.
> Incomming packet - ETH|IP|Payload
> 1 Actions - push_mpls_l2
> outgoing packet -  l2 MPLS label|eth|IP - ( Packet is l3 now)
> 2 Actions  - Push_mpls_l2
> outgoing packet  | L3 MPLS Label| l2 MPLS label|eth|IP.
>
> 2 actions - POP_MPLS,POP_MPLS
> outgoing packet - ETH |IP|Payload  (Packet is l2 now)
>
>
>
>
>
>
>
