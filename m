Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94369125A15
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 04:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLSDvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 22:51:05 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57065 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfLSDvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 22:51:05 -0500
X-Originating-IP: 209.85.222.48
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 0BF4D1C0007
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 03:51:02 +0000 (UTC)
Received: by mail-ua1-f48.google.com with SMTP id 73so1476542uac.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 19:51:02 -0800 (PST)
X-Gm-Message-State: APjAAAWNxqLNR5FAEtMjuY98WcFy7+Iu8jt8feD/olOZUk8sXO8SslUC
        5qeWw85qINjL+7GnRaJlv9oVRBUONYVVl8ascq8=
X-Google-Smtp-Source: APXvYqzydkg4FwlEzFxICK/j3HdrnwbIDQQs0PwVWcrf2MW/b5VG49dDj95lc+E/L5JkFLuMwic1TOJdmq25qYXtYVM=
X-Received: by 2002:ab0:714c:: with SMTP id k12mr4078873uao.124.1576727461637;
 Wed, 18 Dec 2019 19:51:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576648350.git.martin.varghese@nokia.com> <f78a4e44caac82f0f1db5c89dfd30696c2cb192e.1576648350.git.martin.varghese@nokia.com>
In-Reply-To: <f78a4e44caac82f0f1db5c89dfd30696c2cb192e.1576648350.git.martin.varghese@nokia.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 18 Dec 2019 19:50:52 -0800
X-Gmail-Original-Message-ID: <CAOrHB_CTqSYc7TBuVqU64f7TjLQNmggWg69zYxrLwrC0Sgjf=A@mail.gmail.com>
Message-ID: <CAOrHB_CTqSYc7TBuVqU64f7TjLQNmggWg69zYxrLwrC0Sgjf=A@mail.gmail.com>
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

On Tue, Dec 17, 2019 at 10:56 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The existing PUSH MPLS action inserts MPLS header between ethernet header
> and the IP header. Though this behaviour is fine for L3 VPN where an IP
> packet is encapsulated inside a MPLS tunnel, it does not suffice the L2
> VPN (l2 tunnelling) requirements. In L2 VPN the MPLS header should
> encapsulate the ethernet packet.
>
> The new mpls action PTAP_PUSH_MPLS inserts MPLS header at the start of the
> packet or at the start of the l3 header depending on the value of l2 tunnel
> flag in the PTAP_PUSH_MPLS arguments.
>
> POP_MPLS action is extended to support ethertype 0x6558.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2:
>    - PTAP_POP_MPLS action removed.
>    - Special handling for ethertype 0 added in PUSH_MPLS.
>    - Refactored push_mpls function to cater existing push_mpls and
>      ptap_push_mpls actions.
>    - mac len to specify the MPLS header location added in PTAP_PUSH_MPLS
>      arguments.
>
> Changes in v3:
>    - Special handling for ethertype 0 removed.
>    - Added support for ether type 0x6558.
>    - Removed mac len from PTAP_PUSH_MPLS argument list
>    - used l2_tun flag to distinguish l2 and l3 tunnelling.
>    - Extended PTAP_PUSH_MPLS handling to cater PUSH_MPLS action also.
>
> Changes in v4:
>    - Removed extra blank lines.
>    - Replaced bool l2_tun with u16 tun flags in
>      struct ovs_action_ptap_push_mpls.
>
The patch looks almost ready. I have couple of comments.

>  include/uapi/linux/openvswitch.h | 31 +++++++++++++++++++++++++++++++
>  net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
>  net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 89 insertions(+), 6 deletions(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index a87b44c..d9461ce 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -673,6 +673,32 @@ struct ovs_action_push_mpls {
>  };
>
...
...
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index 65c2e34..85fe7df 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
>                 case OVS_ACTION_ATTR_SET_MASKED:
>                 case OVS_ACTION_ATTR_METER:
>                 case OVS_ACTION_ATTR_CHECK_PKT_LEN:
> +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
>                 default:
>                         return true;
>                 }
> @@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>                         [OVS_ACTION_ATTR_METER] = sizeof(u32),
>                         [OVS_ACTION_ATTR_CLONE] = (u32)-1,
>                         [OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
> +                       [OVS_ACTION_ATTR_PTAP_PUSH_MPLS] = sizeof(struct ovs_action_ptap_push_mpls),
>                 };
>                 const struct ovs_action_push_vlan *vlan;
>                 int type = nla_type(a);
> @@ -3072,6 +3074,33 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>                 case OVS_ACTION_ATTR_RECIRC:
>                         break;
>
> +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
Can you change name of this action given this can handle both L2 and
L3 MPLS tunneling?

> +                       const struct ovs_action_ptap_push_mpls *mpls = nla_data(a);
> +
> +                       if (!eth_p_mpls(mpls->mpls_ethertype))
> +                               return -EINVAL;
> +
> +                       if (!(mpls->tun_flags & OVS_MPLS_L2_TUNNEL_FLAG_MASK)) {
> +                               if (vlan_tci & htons(VLAN_CFI_MASK) ||
> +                                   (eth_type != htons(ETH_P_IP) &&
> +                                    eth_type != htons(ETH_P_IPV6) &&
> +                                    eth_type != htons(ETH_P_ARP) &&
> +                                    eth_type != htons(ETH_P_RARP) &&
> +                                    !eth_p_mpls(eth_type)))
> +                                       return -EINVAL;
> +                               mpls_label_count++;
> +                       } else {
> +                               if (mac_proto != MAC_PROTO_NONE) {
It is better to check for 'MAC_PROTO_ETHERNET', rather than this negative test.

> +                                       mpls_label_count = 1;
> +                                       mac_proto = MAC_PROTO_NONE;
> +                               } else {
> +                                       mpls_label_count++;
> +                               }
We need to either disallow combination of L3 and L2 MPLS_PUSH, POP
actions in a action list or keep separate label count. Otherwise it is
impossible to validate mpls labels stack depth in POP actions.

> +                       }
> +                       eth_type = mpls->mpls_ethertype;
> +                       break;
> +               }
> +
>                 case OVS_ACTION_ATTR_PUSH_MPLS: {
>                         const struct ovs_action_push_mpls *mpls = nla_data(a);
>
