Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6E010EFB0
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 20:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfLBTBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 14:01:10 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:54675 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfLBTBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 14:01:10 -0500
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
        (Authenticated sender: pshelar@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 37A41100009
        for <netdev@vger.kernel.org>; Mon,  2 Dec 2019 19:01:07 +0000 (UTC)
Received: by mail-vs1-f46.google.com with SMTP id x123so598802vsc.2
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 11:01:07 -0800 (PST)
X-Gm-Message-State: APjAAAVT2Awt/uvq5IVCdYN2EMwQbbaeClceSF2ITbjHsRZ5i1qxDXkE
        zKNs5NXBq1HhEGvjbzK1Ch5H1hrucjLexiuxU54=
X-Google-Smtp-Source: APXvYqyPawjCcgfhA1gR+2HWGSrETk481kydLoZSmKPQHtsyZ83ukWTqXB1CanQ6SwobFpBtyU8p+Xw6I9H3w6MUfuE=
X-Received: by 2002:a67:f07:: with SMTP id 7mr325144vsp.47.1575313265740; Mon,
 02 Dec 2019 11:01:05 -0800 (PST)
MIME-Version: 1.0
References: <1575263991-5915-1-git-send-email-martinvarghesenokia@gmail.com>
In-Reply-To: <1575263991-5915-1-git-send-email-martinvarghesenokia@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 2 Dec 2019 11:00:53 -0800
X-Gmail-Original-Message-ID: <CAOrHB_B8+PG=-TkVU2eOa5jAgBKBTpi8nt7z20Y7Ej0yP6=Oug@mail.gmail.com>
Message-ID: <CAOrHB_B8+PG=-TkVU2eOa5jAgBKBTpi8nt7z20Y7Ej0yP6=Oug@mail.gmail.com>
Subject: Re: [PATCH v3 net] Fixed updating of ethertype in function skb_mpls_pop
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 1, 2019 at 9:20 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The skb_mpls_pop was not updating ethertype of an ethernet packet if the
> packet was originally received from a non ARPHRD_ETHER device.
>
> In the below OVS data path flow, since the device corresponding to port 7
> is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
> the ethertype of the packet even though the previous push_eth action had
> added an ethernet header to the packet.
>
> recirc_id(0),in_port(7),eth_type(0x8847),
> mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
> actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
> pop_mpls(eth_type=0x800),4
>
> Fixes: ed246cee09b9 ("net: core: move pop MPLS functionality from OvS to core helper")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2:
>     - In function skb_mpls_pop check for dev type removed
>       while updating ethertype.
>     - key->mac_proto is checked in function pop_mpls to pass
>       ethernet flag to skb_mpls_pop.
>     - dev type is checked in function tcf_mpls_act to pass
>       ethernet flag to skb_mpls_pop.
>
> Changes in v3:
>     - Fixed header inclusion order.
>     - Removed unwanted braces.
>     - Retain space between function argements and description in the
>       coments of function skb_mpls_pop.
>     - used ovs_key_mac_proto(key) to check if the packet is ethernet.
>     - Added fixes tag.
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
