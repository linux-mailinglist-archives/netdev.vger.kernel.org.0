Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9589111DC8C
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 04:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbfLMDRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 22:17:10 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:49775 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731565AbfLMDRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 22:17:10 -0500
X-Originating-IP: 209.85.221.180
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
        (Authenticated sender: pshelar@ovn.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id D6600FF804
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 03:17:07 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id u6so338068vkn.13
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 19:17:07 -0800 (PST)
X-Gm-Message-State: APjAAAWrNdJk3GAaRj+J6pLmNCcLl7R2tCWX8m70X5uoGm4SgalJGkl0
        NJzn+210WBRtJPF1CxwgkZmb4hP4pl/YGGBwLI0=
X-Google-Smtp-Source: APXvYqy09rhTy/6ytX8HKnIbU7pbx9o0zpZagS2ZDnrXWPUh5ujkglk1HydMjl8RLPCFVyEmes+n/8QnS910IYd5Jw8=
X-Received: by 2002:a05:6122:1065:: with SMTP id k5mr11964215vko.14.1576207026434;
 Thu, 12 Dec 2019 19:17:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576157907.git.martin.varghese@nokia.com> <20aaa5257be38bb50e04b1e596ad05b7deea5ddc.1576157907.git.martin.varghese@nokia.com>
In-Reply-To: <20aaa5257be38bb50e04b1e596ad05b7deea5ddc.1576157907.git.martin.varghese@nokia.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 12 Dec 2019 19:16:54 -0800
X-Gmail-Original-Message-ID: <CAOrHB_DBWCgDXNBry6SxTx3pe7brnYqOEiWHzbDtz6zy4d3HCQ@mail.gmail.com>
Message-ID: <CAOrHB_DBWCgDXNBry6SxTx3pe7brnYqOEiWHzbDtz6zy4d3HCQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
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

On Thu, Dec 12, 2019 at 6:35 AM Martin Varghese
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
> The new mpls action PTAP_PUSH_MPLS inserts MPLS header at specified offset
> from the start of packet.
>
> A special handling is added for ethertype 0 in the existing POP MPLS action.
> Value 0 in ethertype indicates the tunnelled packet is ethernet.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
>  include/uapi/linux/openvswitch.h | 21 ++++++++++++++++++++-
>  net/openvswitch/actions.c        | 26 ++++++++++++++++++++------
>  net/openvswitch/flow_netlink.c   | 15 +++++++++++++++
>  3 files changed, 55 insertions(+), 7 deletions(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index a87b44c..aaf7d3a 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -673,6 +673,23 @@ struct ovs_action_push_mpls {
>  };
>
>  /**
> + * struct ovs_action_ptap_push_mpls - %OVS_ACTION_ATTR_PTAP_PUSH_MPLS action
> + * argument.
> + * @mpls_lse: MPLS label stack entry to push.
> + * @mpls_ethertype: Ethertype to set in the encapsulating ethernet frame.
> + * @mac_len: Offset from start of packet at which MPLS header is pushed.
> + *
> + * The only values @mpls_ethertype should ever be given are %ETH_P_MPLS_UC and
> + * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are rejected.
> + */
> +struct ovs_action_ptap_push_mpls {
> +       __be32 mpls_lse;
> +       __be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> +       __u16 mac_len;
> +};
> +
Can you make changes according to comments in other thread.
