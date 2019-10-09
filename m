Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BF2D12C6
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJIPaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:30:05 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46119 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIPaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:30:05 -0400
X-Originating-IP: 209.85.221.172
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 301E91C0017
        for <netdev@vger.kernel.org>; Wed,  9 Oct 2019 15:30:03 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id w3so637534vkm.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:30:03 -0700 (PDT)
X-Gm-Message-State: APjAAAXBtsAHJYdJneDgDgcu+Iho/1qFlN+PJs3ql72IjBrDWBCwEY/F
        3PMlkIYK2wPjg06qj2JFOrcGb3cpc4H83A1qmgM=
X-Google-Smtp-Source: APXvYqyILffaFk0K4zRoTPWg+1DQeLkEa/i6kySDlpVWLmcAvqvUl0rinQDBAFhsrabDL4g/U44U+iQg11d+Cfj+wcM=
X-Received: by 2002:a1f:3a15:: with SMTP id h21mr2362362vka.17.1570635001699;
 Wed, 09 Oct 2019 08:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
In-Reply-To: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 9 Oct 2019 08:29:51 -0700
X-Gmail-Original-Message-ID: <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com>
Message-ID: <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com>
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

On Mon, Oct 7, 2019 at 9:41 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The openvswitch was supporting a MPLS label depth of 1 in the ingress
> direction though the userspace OVS supports a max depth of 3 labels.
> This change enables openvswitch module to support a max depth of
> 3 labels in the ingress.
>
> Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> ---
>  net/openvswitch/actions.c      | 10 +++++++-
>  net/openvswitch/flow.c         | 20 ++++++++++-----
>  net/openvswitch/flow.h         |  9 ++++---
>  net/openvswitch/flow_netlink.c | 55 +++++++++++++++++++++++++++++++++---------
>  4 files changed, 72 insertions(+), 22 deletions(-)
>
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 3572e11..eb5bed5 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -178,10 +178,14 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
>  {
>         int err;
>
> +       if (!key->mpls.num_labels_mask)
> +               return -EINVAL;
> +
>         err = skb_mpls_pop(skb, ethertype);
>         if (err)
>                 return err;
>
> +       key->mpls.num_labels_mask >>= 1;
>         invalidate_flow_key(key);
Since this key is immediately invalidated, what is point of updating
the label count?

>         return 0;
>  }
What about checks in OVS_ACTION_ATTR_PUSH_MPLS?

> @@ -192,6 +196,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
>         struct mpls_shim_hdr *stack;
>         __be32 lse;
>         int err;
> +       u32 i = 0;
>
>         stack = mpls_hdr(skb);
>         lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
> @@ -199,7 +204,10 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
>         if (err)
>                 return err;
>
> -       flow_key->mpls.top_lse = lse;
> +       for (i = MPLS_LABEL_DEPTH - 1; i > 0; i--)
> +               flow_key->mpls.lse[i] = flow_key->mpls.lse[i - 1];
> +
> +       flow_key->mpls.lse[i] = *mpls_lse;
This is changing semantic of mpls-set action. It is looking like
mpls-push. Lets keep the MPLS set that sets one or more MPLS lebels.

>         return 0;
>  }
>
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index dca3b1e..c101355 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -699,27 +699,35 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
>                         memset(&key->ipv4, 0, sizeof(key->ipv4));
>                 }
>         } else if (eth_p_mpls(key->eth.type)) {
> -               size_t stack_len = MPLS_HLEN;
> +               u8 label_count = 1;
>
> +               memset(&key->mpls, 0, sizeof(key->mpls));
>                 skb_set_inner_network_header(skb, skb->mac_len);
>                 while (1) {
>                         __be32 lse;
>
> -                       error = check_header(skb, skb->mac_len + stack_len);
> +                       error = check_header(skb, skb->mac_len +
> +                                            label_count * MPLS_HLEN);
I do not think this is right. This way OVS can copy into MPLS labels
from next header beyond MPLS. You need parse MPLS header and determine
end of MPLS labels.

>                         if (unlikely(error))
>                                 return 0;
>
>                         memcpy(&lse, skb_inner_network_header(skb), MPLS_HLEN);
>
> -                       if (stack_len == MPLS_HLEN)
> -                               memcpy(&key->mpls.top_lse, &lse, MPLS_HLEN);
> +                       if (label_count <= MPLS_LABEL_DEPTH)
> +                               memcpy(&key->mpls.lse[label_count - 1], &lse,
> +                                      MPLS_HLEN);
>
> -                       skb_set_inner_network_header(skb, skb->mac_len + stack_len);
> +                       skb_set_inner_network_header(skb, skb->mac_len +
> +                                                    label_count * MPLS_HLEN);
>                         if (lse & htonl(MPLS_LS_S_MASK))
>                                 break;
>
> -                       stack_len += MPLS_HLEN;
> +                       label_count++;
>                 }
> +               if (label_count > MPLS_LABEL_DEPTH)
> +                       label_count = MPLS_LABEL_DEPTH;
> +
> +               key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);
>         } else if (key->eth.type == htons(ETH_P_IPV6)) {
>                 int nh_len;             /* IPv6 Header + Extensions */
>
...
...
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index d7559c6..4eb04e9 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
>         [OVS_KEY_ATTR_DP_HASH]   = { .len = sizeof(u32) },
>         [OVS_KEY_ATTR_TUNNEL]    = { .len = OVS_ATTR_NESTED,
>                                      .next = ovs_tunnel_key_lens, },
> -       [OVS_KEY_ATTR_MPLS]      = { .len = sizeof(struct ovs_key_mpls) },
> +       [OVS_KEY_ATTR_MPLS]      = { .len = OVS_ATTR_VARIABLE },
>         [OVS_KEY_ATTR_CT_STATE]  = { .len = sizeof(u32) },
>         [OVS_KEY_ATTR_CT_ZONE]   = { .len = sizeof(u16) },
>         [OVS_KEY_ATTR_CT_MARK]   = { .len = sizeof(u32) },
> @@ -1628,10 +1628,26 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
>
>         if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
>                 const struct ovs_key_mpls *mpls_key;
> +               u32 hdr_len = 0;
> +               u32 label_count = 0, i = 0;
> +               u32 label_count_mask = 0;
No need to initialize these values.
>
>                 mpls_key = nla_data(a[OVS_KEY_ATTR_MPLS]);
> -               SW_FLOW_KEY_PUT(match, mpls.top_lse,
> -                               mpls_key->mpls_lse, is_mask);
> +               hdr_len = nla_len(a[OVS_KEY_ATTR_MPLS]);
> +               label_count = hdr_len / sizeof(struct ovs_key_mpls);
> +
> +               if (label_count == 0 || label_count > MPLS_LABEL_DEPTH ||
> +                   hdr_len % sizeof(struct ovs_key_mpls))
> +                       return -EINVAL;
> +
> +               label_count_mask =  GENMASK(label_count - 1, 0);
> +
> +               for (i = 0 ; i < label_count; i++)
> +                       SW_FLOW_KEY_PUT(match, mpls.lse[i],
> +                                       mpls_key[i].mpls_lse, is_mask);
> +
> +               SW_FLOW_KEY_PUT(match, mpls.num_labels_mask,
> +                               label_count_mask, is_mask);
>
>                 attrs &= ~(1 << OVS_KEY_ATTR_MPLS);
>          }
> @@ -2114,13 +2130,22 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
>                 ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
>                 ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
>         } else if (eth_p_mpls(swkey->eth.type)) {
> +               u8 i = 0;
> +               u8 num_labels;
>                 struct ovs_key_mpls *mpls_key;
>
> -               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> +               num_labels = hweight_long(output->mpls.num_labels_mask);
> +               if (num_labels >= MPLS_LABEL_DEPTH)
> +                       num_labels = MPLS_LABEL_DEPTH;
I do not see need for this check. We can copy the value directly from key.

> +
> +               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS,
> +                                 num_labels * sizeof(*mpls_key));
>                 if (!nla)
>                         goto nla_put_failure;
> +
>                 mpls_key = nla_data(nla);
> -               mpls_key->mpls_lse = output->mpls.top_lse;
> +               for (i = 0; i < num_labels; i++)
> +                       mpls_key[i].mpls_lse = output->mpls.lse[i];
>         }
>
>         if ((swkey->eth.type == htons(ETH_P_IP) ||
> @@ -3068,22 +3093,28 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>                         break;
>                 }
>
> -               case OVS_ACTION_ATTR_POP_MPLS:
> +               case OVS_ACTION_ATTR_POP_MPLS: {
> +                       __be16  proto;
>                         if (vlan_tci & htons(VLAN_CFI_MASK) ||
>                             !eth_p_mpls(eth_type))
>                                 return -EINVAL;
>
Since this patch is adding support for multiple labels, we need to
track depth of the MPLS label stack in MPLS push and pop actions
validation to avoid checks in fastpath.

> -                       /* Disallow subsequent L2.5+ set and mpls_pop actions
> -                        * as there is no check here to ensure that the new
> -                        * eth_type is valid and thus set actions could
> -                        * write off the end of the packet or otherwise
> -                        * corrupt it.
> +                       /* Disallow subsequent L2.5+ set actions as there is
> +                        * no check here to ensure that the new eth type is
> +                        * valid and thus set actions could write off the
> +                        * end of the packet or otherwise corrupt it.
>                          *
>                          * Support for these actions is planned using packet
>                          * recirculation.
>                          */
> -                       eth_type = htons(0);
> +
> +                       proto = nla_get_be16(a);
> +                       if (!eth_p_mpls(proto))
> +                               eth_type = htons(0);
> +                       else
> +                               eth_type =  proto;

I do not see any point of changing this validation logic. OVS can not
parse beyond MPLS, so lets keep this as it it.


>                         break;
> +               }
>
>                 case OVS_ACTION_ATTR_SET:
>                         err = validate_set(a, key, sfa,

I would also like to see patch that adds multi label MPLS unit test in
system-traffic.at along with this patch.
