Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7320E10B8
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 06:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbfJWEAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 00:00:02 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:48691 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731556AbfJWEAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 00:00:02 -0400
X-Originating-IP: 209.85.217.43
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (Authenticated sender: pshelar@ovn.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 6AD5CFF804
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 03:59:59 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id l5so1562836vsh.12
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 20:59:59 -0700 (PDT)
X-Gm-Message-State: APjAAAUtpnqPop4BRVTNB8v1Y7tLiliyiMYIvvYzixQsHVL05S1FGNve
        WY3YCBss4/Xj6X8IaEdA861Zb4YSg7r8OHZ3jGg=
X-Google-Smtp-Source: APXvYqyqSUYzDsIFxIXPm6Sf9rX0q0sNI6Q0Z9NYET2fkm5WwCizA2xEVrBEXTPNAvEaMmmoYI64jc9nFosslk8cgxE=
X-Received: by 2002:a67:d113:: with SMTP id u19mr4018018vsi.93.1571803197957;
 Tue, 22 Oct 2019 20:59:57 -0700 (PDT)
MIME-Version: 1.0
References: <1571580702-18476-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_B=1RR+qqx938=O32iTH1yQ+S_gLAXS-aA1PLYYtgu6VA@mail.gmail.com> <20191022152940.GB23540@martin-VirtualBox>
In-Reply-To: <20191022152940.GB23540@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 22 Oct 2019 20:59:46 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Cd_Qr2W7r0JSacPSYujR8er3g_sxEmGme7eFow9zyK-Q@mail.gmail.com>
Message-ID: <CAOrHB_Cd_Qr2W7r0JSacPSYujR8er3g_sxEmGme7eFow9zyK-Q@mail.gmail.com>
Subject: Re: [PATCH v2] Change in Openvswitch to support MPLS label depth of 3
 in ingress direction
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

On Tue, Oct 22, 2019 at 8:29 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Oct 22, 2019 at 12:03:49AM -0700, Pravin Shelar wrote:
> > On Sun, Oct 20, 2019 at 7:12 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > direction though the userspace OVS supports a max depth of 3 labels.
> > > This change enables openvswitch module to support a max depth of
> > > 3 labels in the ingress.
> > >
> > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > > ---
> > > Changes in v2
> > >    - Moved MPLS count validation from datapath to configuration.
> > >    - Fixed set mpls function.
> > >
> > This patch looks pretty close now.
> >
> > >  net/openvswitch/actions.c      |  2 +-
> > >  net/openvswitch/flow.c         | 20 ++++++++++-----
> > >  net/openvswitch/flow.h         |  9 ++++---
> > >  net/openvswitch/flow_netlink.c | 57 +++++++++++++++++++++++++++++++++---------
> > >  4 files changed, 66 insertions(+), 22 deletions(-)
> > >
> > ...
> > > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > > index d7559c6..21de061 100644
> > > --- a/net/openvswitch/flow_netlink.c
> > > +++ b/net/openvswitch/flow_netlink.c
> > > @@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
> > >         [OVS_KEY_ATTR_DP_HASH]   = { .len = sizeof(u32) },
> > >         [OVS_KEY_ATTR_TUNNEL]    = { .len = OVS_ATTR_NESTED,
> > >                                      .next = ovs_tunnel_key_lens, },
> > > -       [OVS_KEY_ATTR_MPLS]      = { .len = sizeof(struct ovs_key_mpls) },
> > > +       [OVS_KEY_ATTR_MPLS]      = { .len = OVS_ATTR_VARIABLE },
> > >         [OVS_KEY_ATTR_CT_STATE]  = { .len = sizeof(u32) },
> > >         [OVS_KEY_ATTR_CT_ZONE]   = { .len = sizeof(u16) },
> > >         [OVS_KEY_ATTR_CT_MARK]   = { .len = sizeof(u32) },
> > > @@ -1628,10 +1628,25 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
> > >
> > >         if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
> > >                 const struct ovs_key_mpls *mpls_key;
> > > +               u32 hdr_len;
> > > +               u32 label_count, label_count_mask, i;
> > >
> > >                 mpls_key = nla_data(a[OVS_KEY_ATTR_MPLS]);
> > > -               SW_FLOW_KEY_PUT(match, mpls.top_lse,
> > > -                               mpls_key->mpls_lse, is_mask);
> > > +               hdr_len = nla_len(a[OVS_KEY_ATTR_MPLS]);
> > > +               label_count = hdr_len / sizeof(struct ovs_key_mpls);
> > > +
> > > +               if (label_count == 0 || label_count > MPLS_LABEL_DEPTH ||
> > > +                   hdr_len % sizeof(struct ovs_key_mpls))
> > > +                       return -EINVAL;
> > > +
> > > +               label_count_mask =  GENMASK(label_count - 1, 0);
> > > +
> > > +               for (i = 0 ; i < label_count; i++)
> > > +                       SW_FLOW_KEY_PUT(match, mpls.lse[i],
> > > +                                       mpls_key[i].mpls_lse, is_mask);
> > > +
> > > +               SW_FLOW_KEY_PUT(match, mpls.num_labels_mask,
> > > +                               label_count_mask, is_mask);
> > >
> > >                 attrs &= ~(1 << OVS_KEY_ATTR_MPLS);
> > >          }
> > > @@ -2114,13 +2129,18 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
> > >                 ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
> > >                 ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
> > >         } else if (eth_p_mpls(swkey->eth.type)) {
> > > +               u8 i, num_labels;
> > >                 struct ovs_key_mpls *mpls_key;
> > >
> > > -               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> > > +               num_labels = hweight_long(output->mpls.num_labels_mask);
> > > +               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS,
> > > +                                 num_labels * sizeof(*mpls_key));
> > >                 if (!nla)
> > >                         goto nla_put_failure;
> > > +
> > >                 mpls_key = nla_data(nla);
> > > -               mpls_key->mpls_lse = output->mpls.top_lse;
> > > +               for (i = 0; i < num_labels; i++)
> > > +                       mpls_key[i].mpls_lse = output->mpls.lse[i];
> > >         }
> > >
> > >         if ((swkey->eth.type == htons(ETH_P_IP) ||
> > > @@ -2957,6 +2977,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> > >         u8 mac_proto = ovs_key_mac_proto(key);
> > >         const struct nlattr *a;
> > >         int rem, err;
> > > +       u32 mpls_label_count = 0;
> > > +
> > > +       if (eth_p_mpls(eth_type))
> > > +               mpls_label_count = hweight_long(key->mpls.num_labels_mask);
> > >
> > The MPLS push and pop action could be part of nested actions in
> > sample, so the count needs to be global count across such nested
> > actions. have a look at validate_and_copy_sample().
> >
> Embedding mpls_label_count in struct sw_flow_actions will not work for clone
>
> I guess we need to move the below code to ovs_nla_copy_actions and extend the  arguments of __ovs_nla_copy_actions to take mpls_label_count also
> if (eth_p_mpls(eth_type))
>                 mpls_label_count = hweight_long(key->mpls.num_labels_mask)
>
>
I am not suggesting changing sw_flow_actions, You can define count
variable in ovs_nla_copy_actions() and pass it as a pointer to nested
function. That can be used to keep track of MPLS labels at all nested
actions.
