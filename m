Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8643B128A98
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 18:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfLUR0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 12:26:17 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:39695 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLUR0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 12:26:17 -0500
X-Originating-IP: 209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id CA7F3C0004
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 17:26:15 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id b79so8147500vsd.9
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 09:26:15 -0800 (PST)
X-Gm-Message-State: APjAAAUwprhMlIF6bFOnsR1ODNuFwhMDsfpU11ALMN0ZwT5rXXDmdlBI
        /LIhiLp+/6OVZvVSqzFAuR7ozbcVr+CjBh6wQGU=
X-Google-Smtp-Source: APXvYqyzJnXpORZc8zNY2BbbNUGad2VRouiB5tgfb8A40hbv1fY4kA+EthH2zpKGbbZgQg0XEO0Navglppe1jOhIsLY=
X-Received: by 2002:a67:2701:: with SMTP id n1mr12102497vsn.103.1576949174666;
 Sat, 21 Dec 2019 09:26:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576896417.git.martin.varghese@nokia.com> <4cb29736c3fad6d660df246ef75623db0bd4a864.1576896417.git.martin.varghese@nokia.com>
In-Reply-To: <4cb29736c3fad6d660df246ef75623db0bd4a864.1576896417.git.martin.varghese@nokia.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 21 Dec 2019 09:26:04 -0800
X-Gmail-Original-Message-ID: <CAOrHB_AYHNp77eFAottf4YhhfjgYg4DVcCYYH+gXOmYSUE0tZg@mail.gmail.com>
Message-ID: <CAOrHB_AYHNp77eFAottf4YhhfjgYg4DVcCYYH+gXOmYSUE0tZg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
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

On Fri, Dec 20, 2019 at 7:21 PM Martin Varghese
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
> The new mpls action ADD_MPLS inserts MPLS header at the start of the
> packet or at the start of the l3 header depending on the value of l3 tunnel
> flag in the ADD_MPLS arguments.
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
> Changes in v5:
>    - Renamed PTAP_PUSH_MPLS action to ADD_MPLS.
>    - Replaced l2 tunnel flag with l3 tunnel flag.
>    - In ADD_MPLS configuration, the code to check for l2 header is
>      changed from (mac_proto != MAC_PROTO_NONE) to
>      (mac_proto == MAC_PROTO_ETHERNET).
>
>  include/uapi/linux/openvswitch.h | 31 +++++++++++++++++++++++++++++++
>  net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
>  net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 89 insertions(+), 6 deletions(-)
>
Looks good to me.
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
