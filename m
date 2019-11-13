Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BFDFA938
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfKMEy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:54:56 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45841 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfKMEy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:54:56 -0500
X-Originating-IP: 209.85.217.45
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id CCFF71C0005;
        Wed, 13 Nov 2019 04:54:53 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id b16so497459vso.10;
        Tue, 12 Nov 2019 20:54:53 -0800 (PST)
X-Gm-Message-State: APjAAAWnE7at9VgipNKtub3F5SbKI+Q2CJ0tc+uPs5SaJ4Orikqa2U7i
        vqquOmrjDloAIADuSpfC934fRylno9oDZmxwRjQ=
X-Google-Smtp-Source: APXvYqzk3ISwf1FnBZ+lvJ9jLIuMi3fxIkLe0ppk+TaEM/ZJ/SVCg0jFPdlyJDjdUTh3q8yGyfl+PdSz9MUAkII6pY0=
X-Received: by 2002:a67:eec7:: with SMTP id o7mr754529vsp.58.1573620892707;
 Tue, 12 Nov 2019 20:54:52 -0800 (PST)
MIME-Version: 1.0
References: <20191112102518.4406-1-mcroce@redhat.com>
In-Reply-To: <20191112102518.4406-1-mcroce@redhat.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 12 Nov 2019 20:54:43 -0800
X-Gmail-Original-Message-ID: <CAOrHB_DK1g74ypO_9arOBW0GLqagakNhfjjM0CEhwgS+-87VLA@mail.gmail.com>
Message-ID: <CAOrHB_DK1g74ypO_9arOBW0GLqagakNhfjjM0CEhwgS+-87VLA@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: add TTL decrement action
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 2:25 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> New action to decrement TTL instead of setting it to a fixed value.
> This action will decrement the TTL and, in case of expired TTL, send the
> packet to userspace via output_userspace() to take care of it.
>
> Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
>
> Tested with a corresponding change in the userspace:
>
>     # ovs-dpctl dump-flows
>     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl,1
>     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl,2
>     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
>     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
>
>     # ping -c1 192.168.0.2 -t 42
>     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 120
>     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 1
>     #
>
> Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  include/uapi/linux/openvswitch.h |  2 ++
>  net/openvswitch/actions.c        | 46 ++++++++++++++++++++++++++++++++
>  net/openvswitch/flow_netlink.c   |  6 +++++
>  3 files changed, 54 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 1887a451c388..a3bdb1ecd1e7 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -890,6 +890,7 @@ struct check_pkt_len_arg {
>   * @OVS_ACTION_ATTR_CHECK_PKT_LEN: Check the packet length and execute a set
>   * of actions if greater than the specified packet length, else execute
>   * another set of actions.
> + * @OVS_ACTION_ATTR_DEC_TTL: Decrement the IP TTL.
>   *
>   * Only a single header can be set with a single %OVS_ACTION_ATTR_SET.  Not all
>   * fields within a header are modifiable, e.g. the IPv4 protocol and fragment
> @@ -925,6 +926,7 @@ enum ovs_action_attr {
>         OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
>         OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
>         OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
> +       OVS_ACTION_ATTR_DEC_TTL,      /* Decrement ttl action */
>
>         __OVS_ACTION_ATTR_MAX,        /* Nothing past this will be accepted
>                                        * from userspace. */
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 12936c151cc0..077b7f309c93 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -1174,6 +1174,43 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
>                              nla_len(actions), last, clone_flow_key);
>  }
>
> +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
> +{
> +       int err;
> +
> +       if (skb->protocol == htons(ETH_P_IPV6)) {
> +               struct ipv6hdr *nh = ipv6_hdr(skb);
> +
> +               err = skb_ensure_writable(skb, skb_network_offset(skb) +
> +                                         sizeof(*nh));
> +               if (unlikely(err))
> +                       return err;
> +
> +               if (nh->hop_limit <= 1)
> +                       return -EHOSTUNREACH;
> +
> +               key->ip.ttl = --nh->hop_limit;
> +       } else {
> +               struct iphdr *nh = ip_hdr(skb);
> +               u8 old_ttl;
> +
> +               err = skb_ensure_writable(skb, skb_network_offset(skb) +
> +                                         sizeof(*nh));
> +               if (unlikely(err))
> +                       return err;
> +
> +               if (nh->ttl <= 1)
> +                       return -EHOSTUNREACH;
> +
> +               old_ttl = nh->ttl--;
> +               csum_replace2(&nh->check, htons(old_ttl << 8),
> +                             htons(nh->ttl << 8));
> +               key->ip.ttl = nh->ttl;
> +       }
> +
> +       return 0;
> +}
> +
>  /* Execute a list of actions against 'skb'. */
>  static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>                               struct sw_flow_key *key,
> @@ -1345,6 +1382,15 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>
>                         break;
>                 }
> +
> +               case OVS_ACTION_ATTR_DEC_TTL:
> +                       err = execute_dec_ttl(skb, key);
> +                       if (err == -EHOSTUNREACH) {
> +                               output_userspace(dp, skb, key, a, attr,
> +                                                len, OVS_CB(skb)->cutlen);
> +                               OVS_CB(skb)->cutlen = 0;
> +                       }
This needs to be programmable rather than fixed action. Can you add
nested actions list as argument to execute in case of this exception.
This way we can implement rate limiting or port redirections for
handling such packet.
