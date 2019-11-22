Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506E2105E97
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 03:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKVCWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 21:22:44 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49309 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfKVCWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 21:22:44 -0500
X-Originating-IP: 209.85.221.177
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id C296C60003
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 02:22:42 +0000 (UTC)
Received: by mail-vk1-f177.google.com with SMTP id p78so1285184vkp.8
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 18:22:42 -0800 (PST)
X-Gm-Message-State: APjAAAXeYNkkWhtdSV7O11y9EZ+N54gphnnya2H7K7UQNkyemhtcAwBw
        BevPheY4y2wiyuQHdgnUPbtQZ5nYFZ7t2qvKCME=
X-Google-Smtp-Source: APXvYqyaxhPMwJp2SZQHyYzbb9zGK3qHjk4UMX2SdSEvovc3NhmTe9U2bzrzHVG0EkOI3kz6dLFHx/rgL9S4ZhG3wj4=
X-Received: by 2002:ac5:c2c3:: with SMTP id i3mr7917291vkk.17.1574389361380;
 Thu, 21 Nov 2019 18:22:41 -0800 (PST)
MIME-Version: 1.0
References: <1574338995-14657-1-git-send-email-martinvarghesenokia@gmail.com>
In-Reply-To: <1574338995-14657-1-git-send-email-martinvarghesenokia@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 21 Nov 2019 18:22:29 -0800
X-Gmail-Original-Message-ID: <CAOrHB_De_A=jY-fBqJjXDQKemEOOfJtpvqGR_bi3_-x8+od2eg@mail.gmail.com>
Message-ID: <CAOrHB_De_A=jY-fBqJjXDQKemEOOfJtpvqGR_bi3_-x8+od2eg@mail.gmail.com>
Subject: Re: [PATCH net-next] Enhanced skb_mpls_pop to update ethertype of the
 packet in all the cases when an ethernet header is present is the packet.
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

On Thu, Nov 21, 2019 at 4:23 AM Martin Varghese
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
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
>  include/linux/skbuff.h    | 3 ++-
>  net/core/skbuff.c         | 8 +++++---
>  net/openvswitch/actions.c | 2 +-
>  net/sched/act_mpls.c      | 2 +-
>  4 files changed, 9 insertions(+), 6 deletions(-)
>
...
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 867e61d..8ac377d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5529,12 +5529,14 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
>   * @skb: buffer
>   * @next_proto: ethertype of header after popped MPLS header
>   * @mac_len: length of the MAC header
> - *
> + * @ethernet: flag to indicate if ethernet header is present in packet
> + *           ignored for device type ARPHRD_ETHER
>   * Expects skb->data at mac header.
>   *
>   * Returns 0 on success, -errno otherwise.
>   */
> -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> +                bool ethernet)
>  {
>         int err;
>
> @@ -5553,7 +5555,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
>         skb_reset_mac_header(skb);
>         skb_set_network_header(skb, mac_len);
>
> -       if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> +       if ((skb->dev && skb->dev->type == ARPHRD_ETHER) || ethernet) {
>                 struct ethhdr *hdr;
Lets move the dev-type check to caller. That would also avoid one more
argument to this function.

>
>                 /* use mpls_hdr() to get ethertype to account for VLANs. */
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 12936c1..9e5d274 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -179,7 +179,7 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
>  {
>         int err;
>
> -       err = skb_mpls_pop(skb, ethertype, skb->mac_len);
> +       err = skb_mpls_pop(skb, ethertype, skb->mac_len, true);
>         if (err)
OVS supports L3 packets, you need to check flow key for type of packet
(ovs_key_mac_proto()) under process.
