Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B8AD524F
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 22:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfJLUIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 16:08:41 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:32817 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfJLUIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 16:08:41 -0400
X-Originating-IP: 209.85.221.172
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
        (Authenticated sender: pshelar@ovn.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id CC2E1FF803
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 20:08:37 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id j21so2810195vki.11
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 13:08:37 -0700 (PDT)
X-Gm-Message-State: APjAAAUE9BPgtFjFVAL221TGqBlTlggzlpF5tLNVM+9vmlbES626mru7
        6g72xD185YYfHGlZK5V4M0IL58vfQRYFLReew2U=
X-Google-Smtp-Source: APXvYqyZ4h0wcQ+X4TopptEOBDnbDcPPhS8AONxPAFA9fN9iYrQo6UvB08RUracT5nphD7cmXHApwUaRRGmq/SC8nB0=
X-Received: by 2002:a1f:5e0e:: with SMTP id s14mr11831516vkb.27.1570910916194;
 Sat, 12 Oct 2019 13:08:36 -0700 (PDT)
MIME-Version: 1.0
References: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com> <20191010043101.GA19339@martin-VirtualBox>
In-Reply-To: <20191010043101.GA19339@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 12 Oct 2019 13:08:26 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CSwAPW7XwyaFV_hxQADmh25a8JMJa0tRXZbnu-2R60Kw@mail.gmail.com>
Message-ID: <CAOrHB_CSwAPW7XwyaFV_hxQADmh25a8JMJa0tRXZbnu-2R60Kw@mail.gmail.com>
Subject: Re: [PATCH net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:31 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Wed, Oct 09, 2019 at 08:29:51AM -0700, Pravin Shelar wrote:
> > On Mon, Oct 7, 2019 at 9:41 PM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > direction though the userspace OVS supports a max depth of 3 labels.
> > > This change enables openvswitch module to support a max depth of
> > > 3 labels in the ingress.
> > >
> > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > ---
> > >  net/openvswitch/actions.c      | 10 +++++++-
> > >  net/openvswitch/flow.c         | 20 ++++++++++-----
> > >  net/openvswitch/flow.h         |  9 ++++---
> > >  net/openvswitch/flow_netlink.c | 55 +++++++++++++++++++++++++++++++++---------
> > >  4 files changed, 72 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > index 3572e11..eb5bed5 100644
> > > --- a/net/openvswitch/actions.c
> > > +++ b/net/openvswitch/actions.c
> > > @@ -178,10 +178,14 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> > >  {
> > >         int err;
> > >
> > > +       if (!key->mpls.num_labels_mask)
> > > +               return -EINVAL;
> > > +
> > >         err = skb_mpls_pop(skb, ethertype);
> > >         if (err)
> > >                 return err;
> > >
> > > +       key->mpls.num_labels_mask >>= 1;
> > >         invalidate_flow_key(key);
> > Since this key is immediately invalidated, what is point of updating
> > the label count?
> >
>
> The num_labels_mask is being checked in the pop_mpls action to see if anymore
> label present to pop.
>
> if (!key->mpls.num_labels_mask)
>         return -EINVAL:
>
> > >         return 0;
> > >  }
> > What about checks in OVS_ACTION_ATTR_PUSH_MPLS?
> >
> The change does not have any impact to the PUSH_MPLS actions.
> It should work as before.
>
Since the MPLS label count is checked in POP, the PUSH action needs to
update the count.

> > > @@ -192,6 +196,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> > >         struct mpls_shim_hdr *stack;
> > >         __be32 lse;
> > >         int err;
> > > +       u32 i = 0;
> > >
> > >         stack = mpls_hdr(skb);
> > >         lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
> > > @@ -199,7 +204,10 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> > >         if (err)
> > >                 return err;
> > >
> > > -       flow_key->mpls.top_lse = lse;
> > > +       for (i = MPLS_LABEL_DEPTH - 1; i > 0; i--)
> > > +               flow_key->mpls.lse[i] = flow_key->mpls.lse[i - 1];
> > > +
> > > +       flow_key->mpls.lse[i] = *mpls_lse;
> > This is changing semantic of mpls-set action. It is looking like
> > mpls-push. Lets keep the MPLS set that sets one or more MPLS lebels.
> >
> > >         return 0;
> > >  }
>
> Not sure if I got your comment correct.
> Just as before, the new code updates the top most label in the flow_key.
I am referring to the for loop which shifts labels to make room new
label been set. I think the set action should over-write labels
specified in set action.

> > >
> > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > index dca3b1e..c101355 100644
> > > --- a/net/openvswitch/flow.c
> > > +++ b/net/openvswitch/flow.c
> > > @@ -699,27 +699,35 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
> > >                         memset(&key->ipv4, 0, sizeof(key->ipv4));
> > >                 }
> > >         } else if (eth_p_mpls(key->eth.type)) {
> > > -               size_t stack_len = MPLS_HLEN;
> > > +               u8 label_count = 1;
> > >
> > > +               memset(&key->mpls, 0, sizeof(key->mpls));
> > >                 skb_set_inner_network_header(skb, skb->mac_len);
> > >                 while (1) {
> > >                         __be32 lse;
> > >
> > > -                       error = check_header(skb, skb->mac_len + stack_len);
> > > +                       error = check_header(skb, skb->mac_len +
> > > +                                            label_count * MPLS_HLEN);
> > I do not think this is right. This way OVS can copy into MPLS labels
> > from next header beyond MPLS. You need parse MPLS header and determine
> > end of MPLS labels.
> >
> The MPLS labels are parsed and then the label count is updated.
> Did i miss anything ?
ok, That is not issue, but I see other difference compared to current
MPLS flow parsing. Currently OVS is keeping top most label in flow.
with this change it will keep bottom three MPLS labels in flows. I
think we need to keep the parsing same as before.


> > >                         if (unlikely(error))
> > >                                 return 0;
> > >
> > >                         memcpy(&lse, skb_inner_network_header(skb), MPLS_HLEN);
> > >
> > > -                       if (stack_len == MPLS_HLEN)
> > > -                               memcpy(&key->mpls.top_lse, &lse, MPLS_HLEN);
> > > +                       if (label_count <= MPLS_LABEL_DEPTH)
> > > +                               memcpy(&key->mpls.lse[label_count - 1], &lse,
> > > +                                      MPLS_HLEN);
> > >
> > > -                       skb_set_inner_network_header(skb, skb->mac_len + stack_len);
> > > +                       skb_set_inner_network_header(skb, skb->mac_len +
> > > +                                                    label_count * MPLS_HLEN);
> > >                         if (lse & htonl(MPLS_LS_S_MASK))
> > >                                 break;
> > >
> > > -                       stack_len += MPLS_HLEN;
> > > +                       label_count++;
> > >                 }
> > > +               if (label_count > MPLS_LABEL_DEPTH)
> > > +                       label_count = MPLS_LABEL_DEPTH;
> > > +
> > > +               key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);
> > >         } else if (key->eth.type == htons(ETH_P_IPV6)) {
> > >                 int nh_len;             /* IPv6 Header + Extensions */
> > >
> > ...
> > ...
> > > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > > index d7559c6..4eb04e9 100644
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
> > > @@ -1628,10 +1628,26 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
> > >
> > >         if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
> > >                 const struct ovs_key_mpls *mpls_key;
> > > +               u32 hdr_len = 0;
> > > +               u32 label_count = 0, i = 0;
> > > +               u32 label_count_mask = 0;
> > No need to initialize these values.
>
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
> > > @@ -2114,13 +2130,22 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
> > >                 ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
> > >                 ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
> > >         } else if (eth_p_mpls(swkey->eth.type)) {
> > > +               u8 i = 0;
> > > +               u8 num_labels;
> > >                 struct ovs_key_mpls *mpls_key;
> > >
> > > -               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> > > +               num_labels = hweight_long(output->mpls.num_labels_mask);
> > > +               if (num_labels >= MPLS_LABEL_DEPTH)
> > > +                       num_labels = MPLS_LABEL_DEPTH;
> > I do not see need for this check. We can copy the value directly from key.
> >
>
> > > +
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
> > > @@ -3068,22 +3093,28 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> > >                         break;
> > >                 }
> > >
> > > -               case OVS_ACTION_ATTR_POP_MPLS:
> > > +               case OVS_ACTION_ATTR_POP_MPLS: {
> > > +                       __be16  proto;
> > >                         if (vlan_tci & htons(VLAN_CFI_MASK) ||
> > >                             !eth_p_mpls(eth_type))
> > >                                 return -EINVAL;
> > >
> > Since this patch is adding support for multiple labels, we need to
> > track depth of the MPLS label stack in MPLS push and pop actions
> > validation to avoid checks in fastpath.
> >
> As mentioned before this change has no impact to the push.
> As before, there is no restriction on the number of pushes we can make.
>
> For the pop_mpls, we coud add a local variable to count the number of pops
> and validate that against MPLS_LABEL_DEPTH ?

Right. lets keep local variable here in flow validation that way we
can avoid the checks in fastpath.

> > > -                       /* Disallow subsequent L2.5+ set and mpls_pop actions
> > > -                        * as there is no check here to ensure that the new
> > > -                        * eth_type is valid and thus set actions could
> > > -                        * write off the end of the packet or otherwise
> > > -                        * corrupt it.
> > > +                       /* Disallow subsequent L2.5+ set actions as there is
> > > +                        * no check here to ensure that the new eth type is
> > > +                        * valid and thus set actions could write off the
> > > +                        * end of the packet or otherwise corrupt it.
> > >                          *
> > >                          * Support for these actions is planned using packet
> > >                          * recirculation.
> > >                          */
> > > -                       eth_type = htons(0);
> > > +
> > > +                       proto = nla_get_be16(a);
> > > +                       if (!eth_p_mpls(proto))
> > > +                               eth_type = htons(0);
> > > +                       else
> > > +                               eth_type =  proto;
> >
> > I do not see any point of changing this validation logic. OVS can not
> > parse beyond MPLS, so lets keep this as it it.
> >
> >
> unlike before, we can have multiple pop actions now.so we need to update
> the eth_type properly if the proto is MPLS.

ok, so as mentioned above we need to keep MPLS label stack depth and
keep track of labels added by PUSH actions and removed by POP. That
was we can validate it better and set eth_type to zero when MPLS label
count reaches to zero.

> > >                         break;
> > > +               }
> > >
> > >                 case OVS_ACTION_ATTR_SET:
> > >                         err = validate_set(a, key, sfa,
> >
> > I would also like to see patch that adds multi label MPLS unit test in
> > system-traffic.at along with this patch.
