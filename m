Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590B844937
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393679AbfFMRPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:15:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33330 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbfFMRPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:15:45 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so18652130iop.0
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rW7AuKsoFvg8QG3MVUKDfWxrxeoih81GxhGpTkeWY6k=;
        b=PC8LwApfK8m/f8ZD0albbPWz5U9r/EKNsEfe0puN3E3EfIk/DZZPmbBgsfMJeLdFJy
         wKVWF0/cGUwoRvQot4wha4O6GhrDHaFMfduw3ck2pvl5HJgTGthDEoAMzlBnr0gb5552
         iXnCx/4WQTwStMKbBsWkdNUaf8zfrYrHkDtZX3+AyLB+YN66jRp2zFwJzwVmw3+mV+Q1
         /h8qSnZeOyAXksJ83GxuL5yEXAqVb7XRNw1qBlcaE2VMWs+KP+cPW+Mjh3S++WuO4g0q
         nh5kZG1184x1Z3+VgzVyFTVrScuUb3NNc4UAByNQoDcIdmXwOehLybkDwm/U14Ykg1fx
         ZL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rW7AuKsoFvg8QG3MVUKDfWxrxeoih81GxhGpTkeWY6k=;
        b=UeMV1BLR694oUnsQKZ4antAD30e2OReCtDh3VVzsha39aZU4PGYbHg1dqVQWeBDKPU
         lAe2T2MmZW7bX3OruOURFeHPzrGwKSCyf9HstCKsvBah/UI644nZhrBGOJ0NkmOCWR8I
         1dahfD8QWNIL5mf334f4oeycUOa2mcu1ofp8ezXEgtCDMsUJqb601zSroSjg9XQ2X/z+
         NKUHG/qZ4dy4JSlMRaVZfsTHLr5KBuwG1VhTXX4IC8S+5Pozw/H++VDgY07sqjK6Gbsu
         GIPW7Nd8lS9XPB2z8DosRxBfUPn7dpxqCJssrvEDL5OYjOti7HyPw4jtWWBarvIlxpjQ
         qG1Q==
X-Gm-Message-State: APjAAAXFXcahjy4MIWRvePVbneyS/GpsfhCbZIgmXtBor+XlRtB296jC
        sc+zAGbB41tzjH3rYNzosXT7pw/rZ5AjlsbQNyQ=
X-Google-Smtp-Source: APXvYqwUZCdXD2jodmw67+cBdIdVkYqNgrTTIIPMLUJIqqbL4sk84YzrhpWoL+U+Zue5Z2vTUFFjK10iwJTwdKUAMX4=
X-Received: by 2002:a02:cd82:: with SMTP id l2mr60261540jap.96.1560446145067;
 Thu, 13 Jun 2019 10:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
In-Reply-To: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 13 Jun 2019 10:15:33 -0700
Message-ID: <CAKgT0Uej5CkBJpqsBnB61ozo2kAFKyAH8WY9KVbFQ67ZxPiDag@mail.gmail.com>
Subject: Re: [PATCH net-next] gso: enable udp gso for virtual devices
To:     Jason Baron <jbaron@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Joshua Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 4:14 PM Jason Baron <jbaron@akamai.com> wrote:
>
> Now that the stack supports UDP GRO, we can enable udp gso for virtual
> devices. If packets are looped back locally, and UDP GRO is not enabled
> then they will be segmented to gso_size via udp_rcv_segment(). This
> essentiallly just reverts: 8eea1ca gso: limit udp gso to egress-only
> virtual devices.
>
> Tested by connecting two namespaces via macvlan and then ran
> udpgso_bench_tx:
>
> before:
> udp tx:   2068 MB/s    35085 calls/s  35085 msg/s
>
> after (no UDP_GRO):
> udp tx:   3438 MB/s    58319 calls/s  58319 msg/s
>
> after (UDP_GRO):
> udp tx:   8037 MB/s   136314 calls/s 136314 msg/s
>
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> Co-developed-by: Joshua Hunt <johunt@akamai.com>
> Signed-off-by: Joshua Hunt <johunt@akamai.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c | 5 ++---
>  drivers/net/team/team.c         | 5 ++---
>  include/linux/netdev_features.h | 1 +
>  3 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 4f5b3ba..c4260be 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1120,8 +1120,7 @@ static void bond_compute_features(struct bonding *bond)
>
>  done:
>         bond_dev->vlan_features = vlan_features;
> -       bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
> -                                   NETIF_F_GSO_UDP_L4;
> +       bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
>         bond_dev->mpls_features = mpls_features;
>         bond_dev->gso_max_segs = gso_max_segs;
>         netif_set_gso_max_size(bond_dev, gso_max_size);
> @@ -4308,7 +4307,7 @@ void bond_setup(struct net_device *bond_dev)
>                                 NETIF_F_HW_VLAN_CTAG_RX |
>                                 NETIF_F_HW_VLAN_CTAG_FILTER;
>
> -       bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
> +       bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
>         bond_dev->features |= bond_dev->hw_features;
>  }
>
> diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
> index b48006e..30299e3 100644
> --- a/drivers/net/team/team.c
> +++ b/drivers/net/team/team.c
> @@ -1003,8 +1003,7 @@ static void __team_compute_features(struct team *team)
>         }
>
>         team->dev->vlan_features = vlan_features;
> -       team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
> -                                    NETIF_F_GSO_UDP_L4;
> +       team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
>         team->dev->hard_header_len = max_hard_header_len;
>
>         team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
> @@ -2132,7 +2131,7 @@ static void team_setup(struct net_device *dev)
>                            NETIF_F_HW_VLAN_CTAG_RX |
>                            NETIF_F_HW_VLAN_CTAG_FILTER;
>
> -       dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
> +       dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
>         dev->features |= dev->hw_features;
>  }
>
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 4b19c54..188127c 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -237,6 +237,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>                                  NETIF_F_GSO_GRE_CSUM |                 \
>                                  NETIF_F_GSO_IPXIP4 |                   \
>                                  NETIF_F_GSO_IPXIP6 |                   \
> +                                NETIF_F_GSO_UDP_L4 |                   \
>                                  NETIF_F_GSO_UDP_TUNNEL |               \
>                                  NETIF_F_GSO_UDP_TUNNEL_CSUM)

Are you adding this to NETIF_F_GSO_ENCAP_ALL? Wouldn't it make more
sense to add it to NETIF_F_GSO_SOFTWARE?
