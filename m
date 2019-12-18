Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6A123DAC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 04:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfLRDGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 22:06:52 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:36837 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfLRDGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 22:06:52 -0500
X-Originating-IP: 209.85.221.172
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
        (Authenticated sender: pshelar@ovn.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id F133AFF803;
        Wed, 18 Dec 2019 03:06:49 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id d17so235861vke.5;
        Tue, 17 Dec 2019 19:06:49 -0800 (PST)
X-Gm-Message-State: APjAAAX67OxM+aUM23gzoxSG0OFzLkiHuMOBQSqA26ls82ST4ncn3/co
        8Z9TmxOOvZjAAVkL7i0ZYQeIvQC3IFY/3/I24mc=
X-Google-Smtp-Source: APXvYqzD8iireoXv8JAanpVDju+f5XakAPyM47uBSSoclII/NPzPsi8RDdvcrHbSQ5lcMj6gcu3yT1fCu5z2OsipzlE=
X-Received: by 2002:a05:6122:1065:: with SMTP id k5mr166698vko.14.1576638408420;
 Tue, 17 Dec 2019 19:06:48 -0800 (PST)
MIME-Version: 1.0
References: <20191217155102.46039-1-mcroce@redhat.com>
In-Reply-To: <20191217155102.46039-1-mcroce@redhat.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 17 Dec 2019 19:06:37 -0800
X-Gmail-Original-Message-ID: <CAOrHB_BVf8mXuCUehMy0_Sbq=pgfg7Zu1ivPFT8Y9Zatdj1yPw@mail.gmail.com>
Message-ID: <CAOrHB_BVf8mXuCUehMy0_Sbq=pgfg7Zu1ivPFT8Y9Zatdj1yPw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] openvswitch: add TTL decrement action
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 7:51 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> New action to decrement TTL instead of setting it to a fixed value.
> This action will decrement the TTL and, in case of expired TTL, drop it
> or execute an action passed via a nested attribute.
> The default TTL expired action is to drop the packet.
>
> Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
>
> Tested with a corresponding change in the userspace:
>
>     # ovs-dpctl dump-flows
>     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,1
>     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,2
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
>  include/uapi/linux/openvswitch.h |  22 +++++++
>  net/openvswitch/actions.c        |  71 +++++++++++++++++++++
>  net/openvswitch/flow_netlink.c   | 105 +++++++++++++++++++++++++++++++
>  3 files changed, 198 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index a87b44cd5590..b6684bc04883 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -927,6 +927,7 @@ enum ovs_action_attr {
>         OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
>         OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
>         OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
> +       OVS_ACTION_ATTR_DEC_TTL,       /* Nested OVS_DEC_TTL_ATTR_*. */
>
>         __OVS_ACTION_ATTR_MAX,        /* Nothing past this will be accepted
>                                        * from userspace. */
> @@ -939,6 +940,23 @@ enum ovs_action_attr {
>  };
>
>  #define OVS_ACTION_ATTR_MAX (__OVS_ACTION_ATTR_MAX - 1)
> +enum ovs_dec_ttl_attr {
> +       OVS_DEC_TTL_ATTR_UNSPEC,
> +       OVS_DEC_TTL_ATTR_ACTION_TYPE,    /* Action Type u32 */
> +       OVS_DEC_TTL_ATTR_ACTION,         /* nested action */
> +       __OVS_DEC_TTL_ATTR_MAX,
> +#ifdef __KERNEL__
> +       OVS_DEC_TTL_ATTR_ARG          /* struct sample_arg  */
> +#endif
> +};
> +

I do not see need for type or OVS_DEC_TTL_ACTION_DROP, if there are no
nested action the datapath can drop the packet.

> +#ifdef __KERNEL__
> +struct dec_ttl_arg {
> +       u32 action_type;            /* dec_ttl action type.*/
> +};
> +#endif
> +
> +#define OVS_DEC_TTL_ATTR_MAX (__OVS_DEC_TTL_ATTR_MAX - 1)
>
>  /* Meters. */
>  #define OVS_METER_FAMILY  "ovs_meter"
> @@ -1009,6 +1027,10 @@ enum ovs_ct_limit_attr {
>         __OVS_CT_LIMIT_ATTR_MAX
>  };
>
> +enum ovs_dec_ttl_action {            /*Actions supported by dec_ttl */
> +       OVS_DEC_TTL_ACTION_DROP,
> +       OVS_DEC_TTL_ACTION_USER_SPACE
> +};
>  #define OVS_CT_LIMIT_ATTR_MAX (__OVS_CT_LIMIT_ATTR_MAX - 1)
>
>  #define OVS_ZONE_LIMIT_DEFAULT_ZONE -1
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 4c8395462303..5329668732b1 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -960,6 +960,31 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
>         return ovs_dp_upcall(dp, skb, key, &upcall, cutlen);
>  }
>
> +static int dec_ttl(struct datapath *dp, struct sk_buff *skb,
> +                  struct sw_flow_key *fk, const struct nlattr *attr, bool last)
> +{
> +       struct nlattr *actions;
> +       struct nlattr *dec_ttl_arg;
> +       int rem = nla_len(attr);
> +       const struct dec_ttl_arg *arg;
> +
> +       /* The first action is always OVS_DEC_TTL_ATTR_ARG. */
> +       dec_ttl_arg = nla_data(attr);
> +       arg = nla_data(dec_ttl_arg);
> +       actions = nla_next(dec_ttl_arg, &rem);
> +
> +       switch (arg->action_type) {
> +       case OVS_DEC_TTL_ACTION_DROP:
> +               consume_skb(skb);
> +               break;
> +
> +       case OVS_DEC_TTL_ACTION_USER_SPACE:
> +               return clone_execute(dp, skb, fk, 0, actions, rem, last, false);
> +       }
> +
> +       return 0;
> +}
> +
>  /* When 'last' is true, sample() should always consume the 'skb'.
>   * Otherwise, sample() should keep 'skb' intact regardless what
>   * actions are executed within sample().
> @@ -1176,6 +1201,44 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
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
There is no need to initialize 'nh', just use 'struct ipv6hdr' to get the size.
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
same as above.
> +               if (unlikely(err))
> +                       return err;
> +
> +               nh = ip_hdr(skb);
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
> @@ -1347,6 +1410,14 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>
>                         break;
>                 }
> +
> +               case OVS_ACTION_ATTR_DEC_TTL:
> +                       err = execute_dec_ttl(skb, key);
> +                       if (err == -EHOSTUNREACH) {
Can you use unlikely().

> +                               err = dec_ttl(dp, skb, key, a, true);
> +                               return err;
> +                       }
> +                       break;
>                 }
>
>                 if (unlikely(err)) {
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index 65c2e3458ff5..a9eea2ffb8b0 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -61,6 +61,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
>                 case OVS_ACTION_ATTR_RECIRC:
>                 case OVS_ACTION_ATTR_TRUNC:
>                 case OVS_ACTION_ATTR_USERSPACE:
> +               case OVS_ACTION_ATTR_DEC_TTL:
>                         break;
>
>                 case OVS_ACTION_ATTR_CT:
> @@ -2494,6 +2495,59 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
>         return 0;
>  }
>
> +static int validate_and_copy_dec_ttl(struct net *net, const struct nlattr *attr,
> +                                    const struct sw_flow_key *key,
> +                                    struct sw_flow_actions **sfa,
> +                                    __be16 eth_type, __be16 vlan_tci,
> +                                    u32 mpls_label_count, bool log)
> +{
> +       struct nlattr *attrs[OVS_DEC_TTL_ATTR_MAX + 1] = { 0 };
> +       const struct nlattr *action_type, *action;
> +       struct nlattr *a;
> +       int rem, start, err;
> +       struct dec_ttl_arg arg;
> +
Here we need to validate if eth_type is IPv4 or IPv6.



> +       nla_for_each_nested(a, attr, rem) {
> +               int type = nla_type(a);
> +
> +               if (!type || type > OVS_DEC_TTL_ATTR_MAX || attrs[type])
> +                       return -EINVAL;
> +
> +               attrs[type] = a;
> +       }
> +       if (rem)
> +               return -EINVAL;
> +
> +       action_type = attrs[OVS_DEC_TTL_ATTR_ACTION_TYPE];
> +       if (!action_type || nla_len(action_type) != sizeof(u32))
> +               return -EINVAL;
> +
> +       start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
> +       if (start < 0)
> +               return start;
> +
> +       arg.action_type = nla_get_u32(action_type);
> +       err = ovs_nla_add_action(sfa, OVS_DEC_TTL_ATTR_ARG,
> +                                &arg, sizeof(arg), log);
> +       if (err)
> +               return err;
> +
> +       if (arg.action_type == OVS_DEC_TTL_ACTION_USER_SPACE) {
> +               action = attrs[OVS_DEC_TTL_ATTR_ACTION];
> +               if (!action || (nla_len(action) && nla_len(action) < NLA_HDRLEN))
> +                       return -EINVAL;
> +
> +               err = __ovs_nla_copy_actions(net, action, key, sfa, eth_type,
> +                                            vlan_tci, mpls_label_count, log);
> +               if (err)
> +                       return err;
> +       }
> +
> +       add_nested_action_end(*sfa, start);
> +
> +       return 0;
> +}
> +
>  static int validate_and_copy_clone(struct net *net,
>                                    const struct nlattr *attr,
>                                    const struct sw_flow_key *key,
> @@ -3005,6 +3059,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>                         [OVS_ACTION_ATTR_METER] = sizeof(u32),
>                         [OVS_ACTION_ATTR_CLONE] = (u32)-1,
>                         [OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
> +                       [OVS_ACTION_ATTR_DEC_TTL] = (u32)-1,
>                 };
>                 const struct ovs_action_push_vlan *vlan;
>                 int type = nla_type(a);
> @@ -3233,6 +3288,15 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>                         break;
>                 }
>
> +               case OVS_ACTION_ATTR_DEC_TTL:
> +                       err = validate_and_copy_dec_ttl(net, a, key, sfa,
> +                                                       eth_type, vlan_tci,
> +                                                       mpls_label_count, log);
> +                       if (err)
> +                               return err;
> +                       skip_copy = true;
> +                       break;
> +
>                 default:
>                         OVS_NLERR(log, "Unknown Action type %d", type);
>                         return -EINVAL;
> @@ -3404,6 +3468,41 @@ static int check_pkt_len_action_to_attr(const struct nlattr *attr,
>         return err;
>  }
>
> +static int dec_ttl_action_to_attr(const struct nlattr *att, struct sk_buff *skb)
> +{
> +       struct nlattr *start, *ac_start = NULL, *dec_ttl;
> +       int err = 0, rem = nla_len(att);
> +       const struct dec_ttl_arg *arg;
> +       struct nlattr *actions;
> +
> +       start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_DEC_TTL);
> +       if (!start)
> +               return -EMSGSIZE;
> +
> +       dec_ttl = nla_data(att);
> +       arg = nla_data(dec_ttl);
> +       actions = nla_next(dec_ttl, &rem);
> +
> +       if (nla_put_u32(skb, OVS_DEC_TTL_ATTR_ACTION_TYPE, arg->action_type)) {
> +               nla_nest_cancel(skb, start);
> +               return -EMSGSIZE;
> +       }
> +
> +       if (arg->action_type == OVS_DEC_TTL_ACTION_USER_SPACE) {
> +               ac_start = nla_nest_start_noflag(skb, OVS_DEC_TTL_ATTR_ACTION);
> +               if (!ac_start) {
> +                       nla_nest_cancel(skb, ac_start);
> +                       nla_nest_cancel(skb, start);
> +                       return -EMSGSIZE;
> +               }
> +               err = ovs_nla_put_actions(actions, rem, skb);
> +               nla_nest_end(skb, ac_start);
> +       }
> +       nla_nest_end(skb, start);
> +
> +       return err;
> +}
> +
>  static int set_action_to_attr(const struct nlattr *a, struct sk_buff *skb)
>  {
>         const struct nlattr *ovs_key = nla_data(a);
> @@ -3504,6 +3603,12 @@ int ovs_nla_put_actions(const struct nlattr *attr, int len, struct sk_buff *skb)
>                                 return err;
>                         break;
>
> +               case OVS_ACTION_ATTR_DEC_TTL:
> +                       err = dec_ttl_action_to_attr(a, skb);
> +                       if (err)
> +                               return err;
> +                       break;
> +
>                 default:
>                         if (nla_put(skb, type, nla_len(a), nla_data(a)))
>                                 return -EMSGSIZE;
> --
> 2.23.0
>
