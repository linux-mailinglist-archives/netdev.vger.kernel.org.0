Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1AB9DD06
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 07:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfH0FK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 01:10:56 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:39845 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfH0FK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 01:10:56 -0400
X-Originating-IP: 209.85.221.169
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
        (Authenticated sender: pshelar@ovn.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 1D97C40002
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 05:10:53 +0000 (UTC)
Received: by mail-vk1-f169.google.com with SMTP id x20so4494685vkd.6
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 22:10:53 -0700 (PDT)
X-Gm-Message-State: APjAAAVX7ibClaV4dfVNIUYu0sLEGAG+wGp79IA3BtAqpHqX1f+HG7rn
        s2cC1npCtOg5qlHdbNsGVVT6TH6SkL2oA6L+8RY=
X-Google-Smtp-Source: APXvYqxqQO1MLqkQi0KhnuDHwA8GBfsBcuZsrspulOz90a/hwkqopZkmVkvPRrmwCOCIw1jPOvzz4PvzZtcn44JCn+8=
X-Received: by 2002:a1f:591:: with SMTP id 139mr10014797vkf.23.1566882652804;
 Mon, 26 Aug 2019 22:10:52 -0700 (PDT)
MIME-Version: 1.0
References: <1566852359-8028-1-git-send-email-gvrose8192@gmail.com>
In-Reply-To: <1566852359-8028-1-git-send-email-gvrose8192@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 26 Aug 2019 22:13:01 -0700
X-Gmail-Original-Message-ID: <CAOrHB_B3MZF4UyZgemTYr1uG0bEg0La6ShsJ8hpeVSvjceDdEA@mail.gmail.com>
Message-ID: <CAOrHB_B3MZF4UyZgemTYr1uG0bEg0La6ShsJ8hpeVSvjceDdEA@mail.gmail.com>
Subject: Re: [PATCH V2 net 1/2] openvswitch: Properly set L4 keys on "later"
 IP fragments
To:     Greg Rose <gvrose8192@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 1:46 PM Greg Rose <gvrose8192@gmail.com> wrote:
>
> When IP fragments are reassembled before being sent to conntrack, the
> key from the last fragment is used.  Unless there are reordering
> issues, the last fragment received will not contain the L4 ports, so the
> key for the reassembled datagram won't contain them.  This patch updates
> the key once we have a reassembled datagram.
>
> The handle_fragments() function works on L3 headers so we pull the L3/L4
> flow key update code from key_extract into a new function
> 'key_extract_l3l4'.  Then we add a another new function
> ovs_flow_key_update_l3l4() and export it so that it is accessible by
> handle_fragments() for conntrack packet reassembly.
>
> Co-authored by: Justin Pettit <jpettit@ovn.org>
> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
> ---
>  net/openvswitch/conntrack.c |   5 ++
>  net/openvswitch/flow.c      | 161 ++++++++++++++++++++++++++------------------
>  net/openvswitch/flow.h      |   1 +
>  3 files changed, 101 insertions(+), 66 deletions(-)
>
...
...
>
> +/**
> + * key_extract - extracts a flow key from an Ethernet frame.
> + * @skb: sk_buff that contains the frame, with skb->data pointing to the
> + * Ethernet header
> + * @key: output flow key
> + *
> + * The caller must ensure that skb->len >= ETH_HLEN.
> + *
> + * Returns 0 if successful, otherwise a negative errno value.
> + *
> + * Initializes @skb header fields as follows:
> + *
> + *    - skb->mac_header: the L2 header.
> + *
> + *    - skb->network_header: just past the L2 header, or just past the
> + *      VLAN header, to the first byte of the L2 payload.
> + *
> + *    - skb->transport_header: If key->eth.type is ETH_P_IP or ETH_P_IPV6
> + *      on output, then just past the IP header, if one is present and
> + *      of a correct length, otherwise the same as skb->network_header.
> + *      For other key->eth.type values it is left untouched.
> + *
> + *    - skb->protocol: the type of the data starting at skb->network_header.
> + *      Equals to key->eth.type.
> + */
> +static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
> +{
> +       struct ethhdr *eth;
> +
> +       /* Flags are always used as part of stats */
> +       key->tp.flags = 0;
> +
> +       skb_reset_mac_header(skb);
> +
> +       /* Link layer. */
> +       clear_vlan(key);
> +       if (ovs_key_mac_proto(key) == MAC_PROTO_NONE) {
> +               if (unlikely(eth_type_vlan(skb->protocol)))
> +                       return -EINVAL;
> +
> +               skb_reset_network_header(skb);
> +               key->eth.type = skb->protocol;
> +       } else {
> +               eth = eth_hdr(skb);
> +               ether_addr_copy(key->eth.src, eth->h_source);
> +               ether_addr_copy(key->eth.dst, eth->h_dest);
> +
> +               __skb_pull(skb, 2 * ETH_ALEN);
> +               /* We are going to push all headers that we pull, so no need to
> +                * update skb->csum here.
> +                */
> +
> +               if (unlikely(parse_vlan(skb, key)))
> +                       return -ENOMEM;
> +
> +               key->eth.type = parse_ethertype(skb);
> +               if (unlikely(key->eth.type == htons(0)))
> +                       return -ENOMEM;
> +
> +               /* Multiple tagged packets need to retain TPID to satisfy
> +                * skb_vlan_pop(), which will later shift the ethertype into
> +                * skb->protocol.
> +                */
> +               if (key->eth.cvlan.tci & htons(VLAN_CFI_MASK))
> +                       skb->protocol = key->eth.cvlan.tpid;
> +               else
> +                       skb->protocol = key->eth.type;
> +
> +               skb_reset_network_header(skb);
> +               __skb_push(skb, skb->data - skb_mac_header(skb));
> +       }
> +
> +       skb_reset_mac_len(skb);
> +
> +       /* Fill out L3/L4 key info, if any */
> +       return key_extract_l3l4(skb, key);
> +}
> +
> +/* In the case of conntrack fragment handling it expects L3 headers,
> + * add a helper.
> + */
> +int ovs_flow_key_update_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
> +{
> +       int res;
> +
> +       res = key_extract_l3l4(skb, key);
> +       if (!res)
> +               key->mac_proto &= ~SW_FLOW_KEY_INVALID;
> +
Since this is not full key extract, this flag can not be unset.

Otherwise looks good.
