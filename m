Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C7E3E8BAF
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhHKIXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhHKIXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:23:08 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DC7C061765;
        Wed, 11 Aug 2021 01:22:45 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id a12so1438297qtb.2;
        Wed, 11 Aug 2021 01:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eEnuBMR/WnzPZPA20qRiqb5scqrJQbYWGRrwuQxUhMs=;
        b=K3C173d60/4sSqlsEN+39FKEs527NPiKZB/WU8Bpw52zd6c+oXH+GW1YbvlNB1Krhp
         JCiQ4NQdukC+kWrA9pHjsV+rtgNZsp/oC2dDAcP2WqSn3EHRsX72LTJTwnGKWwPOb1UK
         cXrgFM3O7F5RIIhGlJZXENg7noZUd6Ej9WSQsGKSc7XdALyGnysa/MpR4/c9Cyi03v4l
         t7Wg1T1VK5QEuPsYu4ufRlsoLyaXh0LiwkTVfH6/UvMVossULwa6oNz3TrUR3HE3Ozz5
         0hJT5bgVTgSd6EDo6WzO62HHHl9NBN8l4vrx+WHkO0X0VZg04onPiX0Tg7UyrEcB1L/7
         MNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eEnuBMR/WnzPZPA20qRiqb5scqrJQbYWGRrwuQxUhMs=;
        b=S2KRQjGDy4pqmemK1VM9USRpkTwndchQQt1mLdT7khCzeExDZF7uVxQ97ryrYIxEjI
         JZtPoA7stdVphvi5bRoPvmEPkFMZdIj0u6qhk57oqrehwuQKzKLEDpN5lzTPBw4r6cXa
         x7KbmT6zQhKpK0m6LQtPi8LPbYR+h3pSHkZxNrID4NEBXa0JfxD3+y/Z5nHs82E2VWnG
         aWr5RlW1QEbFAdAcp0gfvYLQ7mQjyi7t11arIW0a4scKt/wYXNwSgFBF4oHHXLlbbleJ
         Pah4oselWtZTF3mx37Tz4aISrCDuqiuGOB8jAfsCKBixD+7JgiZpVvxZ782ZCEwvDILD
         nyDA==
X-Gm-Message-State: AOAM530bWPJtTdaK/5P6ijVIF5exCKc8n80frSXNbc0yi2QvkbYStzTx
        uxXahB8vnARSReuvYVykvIl2gJbR9qy4x5Pa2w==
X-Google-Smtp-Source: ABdhPJwxKZ6HsSCdOm3X9DNHoQWaccRvswMhJUbRABOw4s1jSJqyw5HuS4t13OPI0hT+CU1io0Nhut4pu8JCbtUHGl4=
X-Received: by 2002:ac8:59d1:: with SMTP id f17mr16862703qtf.86.1628670164100;
 Wed, 11 Aug 2021 01:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210731055738.16820-1-joamaki@gmail.com>
 <20210731055738.16820-2-joamaki@gmail.com> <2bb53e7c-0a2f-5895-3d8b-aa43fd03ff52@redhat.com>
In-Reply-To: <2bb53e7c-0a2f-5895-3d8b-aa43fd03ff52@redhat.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Wed, 11 Aug 2021 10:22:33 +0200
Message-ID: <CAHn8xckOsLD463JW2rc1LhjjY0FQ-aRNqSif_SJ6GT9bAH7VqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/7] net: bonding: Refactor bond_xmit_hash for
 use with xdp_buff
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

Thanks for catching this. You're right, this will NULL deref if XDP
bonding is used with the VLAN_SRCMAC xmit policy. I think what
happened was that a very early version restricted the xmit policies
that were applicable, but it got dropped when this was refactored.
I'll look into this today and will add in support (or refuse) the
VLAN_SRCMAC xmit policy and extend the tests to cover this.

On Wed, Aug 11, 2021 at 3:52 AM Jonathan Toppins <jtoppins@redhat.com> wrote:
>
> On 7/31/21 1:57 AM, Jussi Maki wrote:
> > In preparation for adding XDP support to the bonding driver
> > refactor the packet hashing functions to be able to work with
> > any linear data buffer without an skb.
> >
> > Signed-off-by: Jussi Maki <joamaki@gmail.com>
> > ---
> >   drivers/net/bonding/bond_main.c | 147 +++++++++++++++++++-------------
> >   1 file changed, 90 insertions(+), 57 deletions(-)
> >
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index d22d78303311..dcec5cc4dab1 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -3611,55 +3611,80 @@ static struct notifier_block bond_netdev_notifier = {
> >
> >   /*---------------------------- Hashing Policies -----------------------------*/
> >
> > +/* Helper to access data in a packet, with or without a backing skb.
> > + * If skb is given the data is linearized if necessary via pskb_may_pull.
> > + */
> > +static inline const void *bond_pull_data(struct sk_buff *skb,
> > +                                      const void *data, int hlen, int n)
> > +{
> > +     if (likely(n <= hlen))
> > +             return data;
> > +     else if (skb && likely(pskb_may_pull(skb, n)))
> > +             return skb->head;
> > +
> > +     return NULL;
> > +}
> > +
> >   /* L2 hash helper */
> > -static inline u32 bond_eth_hash(struct sk_buff *skb)
> > +static inline u32 bond_eth_hash(struct sk_buff *skb, const void *data, int mhoff, int hlen)
> >   {
> > -     struct ethhdr *ep, hdr_tmp;
> > +     struct ethhdr *ep;
> >
> > -     ep = skb_header_pointer(skb, 0, sizeof(hdr_tmp), &hdr_tmp);
> > -     if (ep)
> > -             return ep->h_dest[5] ^ ep->h_source[5] ^ ep->h_proto;
> > -     return 0;
> > +     data = bond_pull_data(skb, data, hlen, mhoff + sizeof(struct ethhdr));
> > +     if (!data)
> > +             return 0;
> > +
> > +     ep = (struct ethhdr *)(data + mhoff);
> > +     return ep->h_dest[5] ^ ep->h_source[5] ^ ep->h_proto;
> >   }
> >
> > -static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
> > -                      int *noff, int *proto, bool l34)
> > +static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk, const void *data,
> > +                      int hlen, __be16 l2_proto, int *nhoff, int *ip_proto, bool l34)
> >   {
> >       const struct ipv6hdr *iph6;
> >       const struct iphdr *iph;
> >
> > -     if (skb->protocol == htons(ETH_P_IP)) {
> > -             if (unlikely(!pskb_may_pull(skb, *noff + sizeof(*iph))))
> > +     if (l2_proto == htons(ETH_P_IP)) {
> > +             data = bond_pull_data(skb, data, hlen, *nhoff + sizeof(*iph));
> > +             if (!data)
> >                       return false;
> > -             iph = (const struct iphdr *)(skb->data + *noff);
> > +
> > +             iph = (const struct iphdr *)(data + *nhoff);
> >               iph_to_flow_copy_v4addrs(fk, iph);
> > -             *noff += iph->ihl << 2;
> > +             *nhoff += iph->ihl << 2;
> >               if (!ip_is_fragment(iph))
> > -                     *proto = iph->protocol;
> > -     } else if (skb->protocol == htons(ETH_P_IPV6)) {
> > -             if (unlikely(!pskb_may_pull(skb, *noff + sizeof(*iph6))))
> > +                     *ip_proto = iph->protocol;
> > +     } else if (l2_proto == htons(ETH_P_IPV6)) {
> > +             data = bond_pull_data(skb, data, hlen, *nhoff + sizeof(*iph6));
> > +             if (!data)
> >                       return false;
> > -             iph6 = (const struct ipv6hdr *)(skb->data + *noff);
> > +
> > +             iph6 = (const struct ipv6hdr *)(data + *nhoff);
> >               iph_to_flow_copy_v6addrs(fk, iph6);
> > -             *noff += sizeof(*iph6);
> > -             *proto = iph6->nexthdr;
> > +             *nhoff += sizeof(*iph6);
> > +             *ip_proto = iph6->nexthdr;
> >       } else {
> >               return false;
> >       }
> >
> > -     if (l34 && *proto >= 0)
> > -             fk->ports.ports = skb_flow_get_ports(skb, *noff, *proto);
> > +     if (l34 && *ip_proto >= 0)
> > +             fk->ports.ports = __skb_flow_get_ports(skb, *nhoff, *ip_proto, data, hlen);
> >
> >       return true;
> >   }
> >
> > -static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> > +static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, const void *data, int mhoff, int hlen)
> >   {
> > -     struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> > +     struct ethhdr *mac_hdr;
> >       u32 srcmac_vendor = 0, srcmac_dev = 0;
> >       u16 vlan;
> >       int i;
> >
> > +     data = bond_pull_data(skb, data, hlen, mhoff + sizeof(struct ethhdr));
> > +     if (!data)
> > +             return 0;
> > +     mac_hdr = (struct ethhdr *)(data + mhoff);
>
> The XDP changes are not introduced in this patch but this section looks
> consistent in later patches in the series. So assuming the XDP buff
> passed gets to this point how will a NULL dereference be avoided given
> skb == NULL, in the XDP call path, as skb is dereferenced later in the
> function?
>
> By this section:
> ...
>         if (!skb_vlan_tag_present(skb))
>                 return srcmac_vendor ^ srcmac_dev;
>
>         vlan = skb_vlan_tag_get(skb);
> ...
>
> referencing net-next/master id: d1a4e0a9576fd2b29a0d13b306a9f52440908ab4
>
>
> > +
> >       for (i = 0; i < 3; i++)
> >               srcmac_vendor = (srcmac_vendor << 8) | mac_hdr->h_source[i];
> >
> > @@ -3675,26 +3700,25 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> >   }
> >
> >   /* Extract the appropriate headers based on bond's xmit policy */
> > -static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
> > -                           struct flow_keys *fk)
> > +static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb, const void *data,
> > +                           __be16 l2_proto, int nhoff, int hlen, struct flow_keys *fk)
> >   {
> >       bool l34 = bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER34;
> > -     int noff, proto = -1;
> > +     int ip_proto = -1;
> >
> >       switch (bond->params.xmit_policy) {
> >       case BOND_XMIT_POLICY_ENCAP23:
> >       case BOND_XMIT_POLICY_ENCAP34:
> >               memset(fk, 0, sizeof(*fk));
> >               return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
> > -                                       fk, NULL, 0, 0, 0, 0);
> > +                                       fk, data, l2_proto, nhoff, hlen, 0);
> >       default:
> >               break;
> >       }
> >
> >       fk->ports.ports = 0;
> >       memset(&fk->icmp, 0, sizeof(fk->icmp));
> > -     noff = skb_network_offset(skb);
> > -     if (!bond_flow_ip(skb, fk, &noff, &proto, l34))
> > +     if (!bond_flow_ip(skb, fk, data, hlen, l2_proto, &nhoff, &ip_proto, l34))
> >               return false;
> >
> >       /* ICMP error packets contains at least 8 bytes of the header
> > @@ -3702,22 +3726,20 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
> >        * to correlate ICMP error packets within the same flow which
> >        * generated the error.
> >        */
> > -     if (proto == IPPROTO_ICMP || proto == IPPROTO_ICMPV6) {
> > -             skb_flow_get_icmp_tci(skb, &fk->icmp, skb->data,
> > -                                   skb_transport_offset(skb),
> > -                                   skb_headlen(skb));
> > -             if (proto == IPPROTO_ICMP) {
> > +     if (ip_proto == IPPROTO_ICMP || ip_proto == IPPROTO_ICMPV6) {
> > +             skb_flow_get_icmp_tci(skb, &fk->icmp, data, nhoff, hlen);
> > +             if (ip_proto == IPPROTO_ICMP) {
> >                       if (!icmp_is_err(fk->icmp.type))
> >                               return true;
> >
> > -                     noff += sizeof(struct icmphdr);
> > -             } else if (proto == IPPROTO_ICMPV6) {
> > +                     nhoff += sizeof(struct icmphdr);
> > +             } else if (ip_proto == IPPROTO_ICMPV6) {
> >                       if (!icmpv6_is_err(fk->icmp.type))
> >                               return true;
> >
> > -                     noff += sizeof(struct icmp6hdr);
> > +                     nhoff += sizeof(struct icmp6hdr);
> >               }
> > -             return bond_flow_ip(skb, fk, &noff, &proto, l34);
> > +             return bond_flow_ip(skb, fk, data, hlen, l2_proto, &nhoff, &ip_proto, l34);
> >       }
> >
> >       return true;
> > @@ -3733,33 +3755,26 @@ static u32 bond_ip_hash(u32 hash, struct flow_keys *flow)
> >       return hash >> 1;
> >   }
> >
> > -/**
> > - * bond_xmit_hash - generate a hash value based on the xmit policy
> > - * @bond: bonding device
> > - * @skb: buffer to use for headers
> > - *
> > - * This function will extract the necessary headers from the skb buffer and use
> > - * them to generate a hash based on the xmit_policy set in the bonding device
> > +/* Generate hash based on xmit policy. If @skb is given it is used to linearize
> > + * the data as required, but this function can be used without it if the data is
> > + * known to be linear (e.g. with xdp_buff).
> >    */
> > -u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> > +static u32 __bond_xmit_hash(struct bonding *bond, struct sk_buff *skb, const void *data,
> > +                         __be16 l2_proto, int mhoff, int nhoff, int hlen)
> >   {
> >       struct flow_keys flow;
> >       u32 hash;
> >
> > -     if (bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP34 &&
> > -         skb->l4_hash)
> > -             return skb->hash;
> > -
> >       if (bond->params.xmit_policy == BOND_XMIT_POLICY_VLAN_SRCMAC)
> > -             return bond_vlan_srcmac_hash(skb);
> > +             return bond_vlan_srcmac_hash(skb, data, mhoff, hlen);
> >
> >       if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER2 ||
> > -         !bond_flow_dissect(bond, skb, &flow))
> > -             return bond_eth_hash(skb);
> > +         !bond_flow_dissect(bond, skb, data, l2_proto, nhoff, hlen, &flow))
> > +             return bond_eth_hash(skb, data, mhoff, hlen);
> >
> >       if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER23 ||
> >           bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP23) {
> > -             hash = bond_eth_hash(skb);
> > +             hash = bond_eth_hash(skb, data, mhoff, hlen);
> >       } else {
> >               if (flow.icmp.id)
> >                       memcpy(&hash, &flow.icmp, sizeof(hash));
> > @@ -3770,6 +3785,25 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> >       return bond_ip_hash(hash, &flow);
> >   }
> >
> > +/**
> > + * bond_xmit_hash - generate a hash value based on the xmit policy
> > + * @bond: bonding device
> > + * @skb: buffer to use for headers
> > + *
> > + * This function will extract the necessary headers from the skb buffer and use
> > + * them to generate a hash based on the xmit_policy set in the bonding device
> > + */
> > +u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> > +{
> > +     if (bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP34 &&
> > +         skb->l4_hash)
> > +             return skb->hash;
> > +
> > +     return __bond_xmit_hash(bond, skb, skb->head, skb->protocol,
> > +                             skb->mac_header, skb->network_header,
> > +                             skb_headlen(skb));
> > +}
> > +
> >   /*-------------------------- Device entry points ----------------------------*/
> >
> >   void bond_work_init_all(struct bonding *bond)
> > @@ -4399,8 +4433,7 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
> >       return bond_tx_drop(bond_dev, skb);
> >   }
> >
> > -static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond,
> > -                                                   struct sk_buff *skb)
> > +static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond)
> >   {
> >       return rcu_dereference(bond->curr_active_slave);
> >   }
> > @@ -4414,7 +4447,7 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
> >       struct bonding *bond = netdev_priv(bond_dev);
> >       struct slave *slave;
> >
> > -     slave = bond_xmit_activebackup_slave_get(bond, skb);
> > +     slave = bond_xmit_activebackup_slave_get(bond);
> >       if (slave)
> >               return bond_dev_queue_xmit(bond, skb, slave->dev);
> >
> > @@ -4712,7 +4745,7 @@ static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
> >               slave = bond_xmit_roundrobin_slave_get(bond, skb);
> >               break;
> >       case BOND_MODE_ACTIVEBACKUP:
> > -             slave = bond_xmit_activebackup_slave_get(bond, skb);
> > +             slave = bond_xmit_activebackup_slave_get(bond);
> >               break;
> >       case BOND_MODE_8023AD:
> >       case BOND_MODE_XOR:
> >
>
