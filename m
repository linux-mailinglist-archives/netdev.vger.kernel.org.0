Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89200E421C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392157AbfJYDb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:31:29 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38771 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390875AbfJYDb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:31:28 -0400
X-Originating-IP: 209.85.217.54
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id C12B760002
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 03:31:25 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id x20so492164vso.13
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 20:31:25 -0700 (PDT)
X-Gm-Message-State: APjAAAXcbLwmVB+c6v7dskdLYEWdDWJVT/BsS77bGKi8qOXWBcFyCdEs
        o6B6VFtw5gpqfpu3+ftCJfrDTBz1XpelUphFX3Q=
X-Google-Smtp-Source: APXvYqyXjMTYkMEMRoYTNjTUCET4zoEEkCV3IJevmdswDhOishMFHAwh1myZ9Dkg8u17DwlU2tmvnPJUtoPz72XE/9E=
X-Received: by 2002:a05:6102:2436:: with SMTP id l22mr812941vsi.93.1571974284258;
 Thu, 24 Oct 2019 20:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <1571580702-18476-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_B=1RR+qqx938=O32iTH1yQ+S_gLAXS-aA1PLYYtgu6VA@mail.gmail.com>
 <20191022152940.GB23540@martin-VirtualBox> <CAOrHB_Cd_Qr2W7r0JSacPSYujR8er3g_sxEmGme7eFow9zyK-Q@mail.gmail.com>
 <20191023050459.GA25094@martin-VirtualBox>
In-Reply-To: <20191023050459.GA25094@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 24 Oct 2019 20:31:14 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BDbSy-5B4ByMhwEh7E5auKue+EUg_hq90ybrZPv9raPw@mail.gmail.com>
Message-ID: <CAOrHB_BDbSy-5B4ByMhwEh7E5auKue+EUg_hq90ybrZPv9raPw@mail.gmail.com>
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

On Tue, Oct 22, 2019 at 10:05 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Oct 22, 2019 at 08:59:46PM -0700, Pravin Shelar wrote:
> > On Tue, Oct 22, 2019 at 8:29 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Tue, Oct 22, 2019 at 12:03:49AM -0700, Pravin Shelar wrote:
> > > > On Sun, Oct 20, 2019 at 7:12 AM Martin Varghese
> > > > <martinvarghesenokia@gmail.com> wrote:
> > > > >
> > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > >
> > > > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > > > direction though the userspace OVS supports a max depth of 3 labels.
> > > > > This change enables openvswitch module to support a max depth of
> > > > > 3 labels in the ingress.
> > > > >
> > > > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > > > > ---
> > > > > Changes in v2
> > > > >    - Moved MPLS count validation from datapath to configuration.
> > > > >    - Fixed set mpls function.
> > > > >
> > > > This patch looks pretty close now.
> > > >
> > > > >  net/openvswitch/actions.c      |  2 +-
> > > > >  net/openvswitch/flow.c         | 20 ++++++++++-----
> > > > >  net/openvswitch/flow.h         |  9 ++++---
> > > > >  net/openvswitch/flow_netlink.c | 57 +++++++++++++++++++++++++++++++++---------
> > > > >  4 files changed, 66 insertions(+), 22 deletions(-)
> > > > >
> > > > ...
> > > > > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > > > > index d7559c6..21de061 100644
> > > > > --- a/net/openvswitch/flow_netlink.c
> > > > > +++ b/net/openvswitch/flow_netlink.c
> > > > > @@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
> > > > >         [OVS_KEY_ATTR_DP_HASH]   = { .len = sizeof(u32) },
> > > > >         [OVS_KEY_ATTR_TUNNEL]    = { .len = OVS_ATTR_NESTED,
> > > > >                                      .next = ovs_tunnel_key_lens, },
> > > > > -       [OVS_KEY_ATTR_MPLS]      = { .len = sizeof(struct ovs_key_mpls) },
> > > > > +       [OVS_KEY_ATTR_MPLS]      = { .len = OVS_ATTR_VARIABLE },
> > > > >         [OVS_KEY_ATTR_CT_STATE]  = { .len = sizeof(u32) },
> > > > >         [OVS_KEY_ATTR_CT_ZONE]   = { .len = sizeof(u16) },
> > > > >         [OVS_KEY_ATTR_CT_MARK]   = { .len = sizeof(u32) },
> > > > > @@ -1628,10 +1628,25 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
> > > > >
> > > > >         if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
> > > > >                 const struct ovs_key_mpls *mpls_key;
> > > > > +               u32 hdr_len;
> > > > > +               u32 label_count, label_count_mask, i;
> > > > >
> > > > >                 mpls_key = nla_data(a[OVS_KEY_ATTR_MPLS]);
> > > > > -               SW_FLOW_KEY_PUT(match, mpls.top_lse,
> > > > > -                               mpls_key->mpls_lse, is_mask);
> > > > > +               hdr_len = nla_len(a[OVS_KEY_ATTR_MPLS]);
> > > > > +               label_count = hdr_len / sizeof(struct ovs_key_mpls);
> > > > > +
> > > > > +               if (label_count == 0 || label_count > MPLS_LABEL_DEPTH ||
> > > > > +                   hdr_len % sizeof(struct ovs_key_mpls))
> > > > > +                       return -EINVAL;
> > > > > +
> > > > > +               label_count_mask =  GENMASK(label_count - 1, 0);
> > > > > +
> > > > > +               for (i = 0 ; i < label_count; i++)
> > > > > +                       SW_FLOW_KEY_PUT(match, mpls.lse[i],
> > > > > +                                       mpls_key[i].mpls_lse, is_mask);
> > > > > +
> > > > > +               SW_FLOW_KEY_PUT(match, mpls.num_labels_mask,
> > > > > +                               label_count_mask, is_mask);
> > > > >
> > > > >                 attrs &= ~(1 << OVS_KEY_ATTR_MPLS);
> > > > >          }
> > > > > @@ -2114,13 +2129,18 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
> > > > >                 ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
> > > > >                 ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
> > > > >         } else if (eth_p_mpls(swkey->eth.type)) {
> > > > > +               u8 i, num_labels;
> > > > >                 struct ovs_key_mpls *mpls_key;
> > > > >
> > > > > -               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> > > > > +               num_labels = hweight_long(output->mpls.num_labels_mask);
> > > > > +               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS,
> > > > > +                                 num_labels * sizeof(*mpls_key));
> > > > >                 if (!nla)
> > > > >                         goto nla_put_failure;
> > > > > +
> > > > >                 mpls_key = nla_data(nla);
> > > > > -               mpls_key->mpls_lse = output->mpls.top_lse;
> > > > > +               for (i = 0; i < num_labels; i++)
> > > > > +                       mpls_key[i].mpls_lse = output->mpls.lse[i];
> > > > >         }
> > > > >
> > > > >         if ((swkey->eth.type == htons(ETH_P_IP) ||
> > > > > @@ -2957,6 +2977,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> > > > >         u8 mac_proto = ovs_key_mac_proto(key);
> > > > >         const struct nlattr *a;
> > > > >         int rem, err;
> > > > > +       u32 mpls_label_count = 0;
> > > > > +
> > > > > +       if (eth_p_mpls(eth_type))
> > > > > +               mpls_label_count = hweight_long(key->mpls.num_labels_mask);
> > > > >
> > > > The MPLS push and pop action could be part of nested actions in
> > > > sample, so the count needs to be global count across such nested
> > > > actions. have a look at validate_and_copy_sample().
> > > >
> > > Embedding mpls_label_count in struct sw_flow_actions will not work for clone
> > >
> > > I guess we need to move the below code to ovs_nla_copy_actions and extend the  arguments of __ovs_nla_copy_actions to take mpls_label_count also
> > > if (eth_p_mpls(eth_type))
> > >                 mpls_label_count = hweight_long(key->mpls.num_labels_mask)
> > >
> > >
> > I am not suggesting changing sw_flow_actions, You can define count
> > variable in ovs_nla_copy_actions() and pass it as a pointer to nested
> > function. That can be used to keep track of MPLS labels at all nested
> > actions.
>
> Actions clone & sample does a clone of SKB correct?

You can pass pointer to a separate (cloned) variable when verifying
those actions in those cases.

> Hence shouldn't they maintain a seperate mpls_label count for each nested action set
> I assume instead of passing as pointer from ovs_nla_copy_actions ,if passed by value it should
> solve the problem.Need to try that though.
