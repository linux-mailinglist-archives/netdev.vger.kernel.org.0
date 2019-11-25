Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 734DD108853
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 06:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfKYFch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 00:32:37 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:59669 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfKYFch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 00:32:37 -0500
X-Originating-IP: 209.85.222.45
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
        (Authenticated sender: pshelar@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 458E61BF203
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 05:32:34 +0000 (UTC)
Received: by mail-ua1-f45.google.com with SMTP id w10so3989343uar.12
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 21:32:34 -0800 (PST)
X-Gm-Message-State: APjAAAWs18LVTB2Vs+K7OERck6Ta3TfzE0sE+U4kaiWoePNBsNotdPWp
        Mtd8yt6AIPmjQJqEvhoz+zjdXOK1UfY9q/Z5bgc=
X-Google-Smtp-Source: APXvYqzOTaUBCUqnY0tsHlh3SQWA3wRjo9sriLn7+FlMa7tM/Amkd6VH9n8hXZVPwpxTI6EwHBYIzKr/MR3bLnNuHh0=
X-Received: by 2002:ab0:14e8:: with SMTP id f37mr16765437uae.64.1574659952848;
 Sun, 24 Nov 2019 21:32:32 -0800 (PST)
MIME-Version: 1.0
References: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
In-Reply-To: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 24 Nov 2019 21:32:21 -0800
X-Gmail-Original-Message-ID: <CAOrHB_AeJFYsvTLigMDB=j4XDsDsHR0sKADK33P5Qf7BiMVrug@mail.gmail.com>
Message-ID: <CAOrHB_AeJFYsvTLigMDB=j4XDsDsHR0sKADK33P5Qf7BiMVrug@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] Enhanced skb_mpls_pop to update ethertype of
 the packet in all the cases when an ethernet header is present is the packet.
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

On Sat, Nov 23, 2019 at 2:35 AM Martin Varghese
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
> Changes in v2:
>     - check for dev type removed while updating ethertype
>       in function skb_mpls_pop.
>     - key->mac_proto is checked in function pop_mpls to pass
>       ethernt flag to skb_mpls_pop.
>     - dev type is checked in function tcf_mpls_act to pass
>       ethernet flag to skb_mpls_pop.
>
>  include/linux/skbuff.h    | 3 ++-
>  net/core/skbuff.c         | 7 ++++---
>  net/openvswitch/actions.c | 4 +++-
>  net/sched/act_mpls.c      | 4 +++-
>  4 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index dfe02b6..70204b9 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3530,7 +3530,8 @@ int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
>  int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
>  int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
>                   int mac_len);
> -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len);
> +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> +                bool ethernet);
>  int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
>  int skb_mpls_dec_ttl(struct sk_buff *skb);
>  struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 867e61d..988eefb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5529,12 +5529,13 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
>   * @skb: buffer
>   * @next_proto: ethertype of header after popped MPLS header
>   * @mac_len: length of the MAC header
> - *
> + * @ethernet: flag to indicate if ethernet header is present in packet
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
> @@ -5553,7 +5554,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
>         skb_reset_mac_header(skb);
>         skb_set_network_header(skb, mac_len);
>
> -       if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> +       if (ethernet) {
>                 struct ethhdr *hdr;
>
>                 /* use mpls_hdr() to get ethertype to account for VLANs. */
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 12936c1..264c3c0 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -179,7 +179,9 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
>  {
>         int err;
>
> -       err = skb_mpls_pop(skb, ethertype, skb->mac_len);
> +       err = skb_mpls_pop(skb, ethertype, skb->mac_len,
> +                          (key->mac_proto & ~SW_FLOW_KEY_INVALID)
> +                           == MAC_PROTO_ETHERNET);
>         if (err)
>                 return err;
>
Why you are not using ovs_key_mac_proto() here?

> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> index 4d8c822..f919f95 100644
> --- a/net/sched/act_mpls.c
> +++ b/net/sched/act_mpls.c
> @@ -13,6 +13,7 @@
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
>  #include <net/tc_act/tc_mpls.h>
> +#include <linux/if_arp.h>
>
>  static unsigned int mpls_net_id;
>  static struct tc_action_ops act_mpls_ops;
> @@ -76,7 +77,8 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
>
>         switch (p->tcfm_action) {
>         case TCA_MPLS_ACT_POP:
> -               if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
> +               if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
> +                                (skb->dev && skb->dev->type == ARPHRD_ETHER)))
>                         goto drop;
>                 break;
>         case TCA_MPLS_ACT_PUSH:
> --
> 1.8.3.1
>
