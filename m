Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFF311A457
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 07:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfLKGQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 01:16:13 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60507 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLKGQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 01:16:13 -0500
X-Originating-IP: 209.85.217.48
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 9FDC2240006
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 06:16:10 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id t12so14928940vso.13
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 22:16:10 -0800 (PST)
X-Gm-Message-State: APjAAAUF1mNwAZUJBU+FmvYOKKc9U5R4wf3KpkzgZXIbd2iGzAPfiNgh
        y/hbFcSmaMDtlpw4Yk/77OQ+59n+qbFpPTdqpBM=
X-Google-Smtp-Source: APXvYqwLfzuSPi/TOv3FXT6dHj3ugCb2XROF01UfeNkhNWLgG6wlU76GF9uzFRUoFsVrK3GEbEiWBEXb09yD4jJ+XTU=
X-Received: by 2002:a67:2701:: with SMTP id n1mr1125862vsn.103.1576044969286;
 Tue, 10 Dec 2019 22:16:09 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575964218.git.martin.varghese@nokia.com> <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
In-Reply-To: <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 10 Dec 2019 22:15:57 -0800
X-Gmail-Original-Message-ID: <CAOrHB_BKv3EvdoNc6HxN6a5cMAhmrSOa57MeaF1kCWss_NTZHQ@mail.gmail.com>
Message-ID: <CAOrHB_BKv3EvdoNc6HxN6a5cMAhmrSOa57MeaF1kCWss_NTZHQ@mail.gmail.com>
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

On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> between ethernet header and the IP header. Though this behaviour is fine
> for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> the MPLS header should encapsulate the ethernet packet.
>
> The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> MPLS header from start of the packet respectively.
>
> PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> @ethertype - Ethertype of MPLS header.
>
> PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> @ethertype - Ethertype of next header following the popped MPLS header.
>              Value 0 in ethertype indicates the tunnelled packet is
>              ethernet.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
>  include/uapi/linux/openvswitch.h |  2 ++
>  net/openvswitch/actions.c        | 40 ++++++++++++++++++++++++++++++++++++++++
>  net/openvswitch/flow_netlink.c   | 21 +++++++++++++++++++++
>  3 files changed, 63 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index a87b44c..af05062 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -927,6 +927,8 @@ enum ovs_action_attr {
>         OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
>         OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
>         OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
> +       OVS_ACTION_ATTR_PTAP_PUSH_MPLS,    /* struct ovs_action_push_mpls. */
> +       OVS_ACTION_ATTR_PTAP_POP_MPLS,     /* __be16 ethertype. */
>
>         __OVS_ACTION_ATTR_MAX,        /* Nothing past this will be accepted
>                                        * from userspace. */
What about MPLS set action? does existing action works with PTAP MPLS?


> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 4c83954..d43c37e 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -160,6 +160,38 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>                               struct sw_flow_key *key,
>                               const struct nlattr *attr, int len);
>
> +static int push_ptap_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> +                         const struct ovs_action_push_mpls *mpls)
> +{
> +       int err;
> +
> +       err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
> +                           0, false);
> +       if (err)
> +               return err;
> +
> +       key->mac_proto = MAC_PROTO_NONE;
> +       invalidate_flow_key(key);
> +       return 0;
> +}
> +
Can you factor out code from existing MPLS action to avoid code duplication.

> +static int ptap_pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> +                        const __be16 ethertype)
> +{
> +       int err;
> +
> +       err = skb_mpls_pop(skb, ethertype, skb->mac_len,
> +                          ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
> +       if (err)
> +               return err;
> +
Why is mac_len passed here? given MPLS is topmost header I do not see
any need to move headers during pop operation.
