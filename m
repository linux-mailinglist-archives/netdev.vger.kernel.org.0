Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6382A3403
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgKBT0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:26:09 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:28952 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgKBT0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:26:09 -0500
Date:   Mon, 02 Nov 2020 19:25:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604345164; bh=OClcHJg2VAApxXq8dAPegwCDrx67Cj5ovLQfHqPnLYg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=o0koo/W8RqBkXcmI+Mj7FmnY0NssPzuz5NFpX/dy0rdmHhG86lxshW8dEmkQpLnP4
         H+i4HExCO5B19srjhUkZIzqEnqsd2KrdvdQOgxodtGTOJgLck+R9pQo19ZgjpeZ7vH
         EJg56gAqqILBP70slM3EedhT5U96e+UoCX7rpqxC7ZKW4ZcXnMgCcdCAp+ecG0IiEU
         fylY71Vi9yFR2iWPSBJ5a6xljLhHeMzetgy8PNcJ5jtlE9XACLRR8GIc6MhFXSGSzD
         P8Duv9feGCehT10Vri3WDfHAQs5sqEQ17UZwAGFkDAdZJEmWqz/DydS9aW/IhqU1fP
         qbs2/pzL+i+wA==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net-next 2/2] net: bonding, dummy, ifb, team: advertise NETIF_F_GSO_SOFTWARE
Message-ID: <4e2CSI69yKQIvZp3Wwo9pC9lHNAz4osj7w8OdhYUdE@cp7-web-042.plabs.ch>
In-Reply-To: <CA+FuTSd1H6+NjSDcin6KQo9y1KEsDACeAvyr0p5JuDWc-aEh+A@mail.gmail.com>
References: <GtgHtyGO5jHKHT6zGMAzg3TDejXZT0HMQVoqNERZRdM@cp3-web-024.plabs.ch> <CA+FuTSd1H6+NjSDcin6KQo9y1KEsDACeAvyr0p5JuDWc-aEh+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 2 Nov 2020 11:30:17 -0500

Hi!
Thanks for the Ack.

> On Sun, Nov 1, 2020 at 8:17 AM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> Virtual netdevs should use NETIF_F_GSO_SOFTWARE to forward GSO skbs
>> as-is and let the final drivers deal with them when supported.
>> Also remove NETIF_F_GSO_UDP_L4 from bonding and team drivers as it's
>> now included in the "software" list.
>
> The rationale is that it is okay to advertise these features with
> software fallback as bonding/teaming "hardware" features, because
> there will always be a downstream device for which they will be
> implemented, possibly in the software fallback, correct?
>
> That does not apply to dummy or IFB. I guess dummy is fine, because
> xmit is a black hole, and IFB because ingress can safely handle these
> packets? How did you arrive at the choice of changing these two, of
> all virtual devices?

Two points:
1. Exactly, dummy is just dummy, while ifb is an intermediate netdev to
   share resources, so it should be as fine as with other virtual devs.
2. They both advertise NETIF_F_ALL_TSO | NETIF_F_GSO_ENCAP_ALL, which
   assumes that they handle all GSO skbs just like the others (pass
   them as is to the real drivers in case with ifb).

>>
>> Suggested-by: Willem de Bruijn <willemb@google.com>
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>  drivers/net/bonding/bond_main.c | 11 +++++------
>>  drivers/net/dummy.c             |  2 +-
>>  drivers/net/ifb.c               |  3 +--
>>  drivers/net/team/team.c         |  9 ++++-----
>>  4 files changed, 11 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_=
main.c
>> index 84ecbc6fa0ff..71c9677d135f 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1228,14 +1228,14 @@ static netdev_features_t bond_fix_features(struc=
t net_device *dev,
>>  }
>>
>>  #define BOND_VLAN_FEATURES     (NETIF_F_HW_CSUM | NETIF_F_SG | \
>> -                                NETIF_F_FRAGLIST | NETIF_F_ALL_TSO | \
>> +                                NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE=
 | \
>>                                  NETIF_F_HIGHDMA | NETIF_F_LRO)
>>
>>  #define BOND_ENC_FEATURES      (NETIF_F_HW_CSUM | NETIF_F_SG | \
>> -                                NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
>> +                                NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
>>
>>  #define BOND_MPLS_FEATURES     (NETIF_F_HW_CSUM | NETIF_F_SG | \
>> -                                NETIF_F_ALL_TSO)
>> +                                NETIF_F_GSO_SOFTWARE)
>>
>>
>>  static void bond_compute_features(struct bonding *bond)
>> @@ -1291,8 +1291,7 @@ static void bond_compute_features(struct bonding *=
bond)
>>         bond_dev->vlan_features =3D vlan_features;
>>         bond_dev->hw_enc_features =3D enc_features | NETIF_F_GSO_ENCAP_A=
LL |
>>                                     NETIF_F_HW_VLAN_CTAG_TX |
>> -                                   NETIF_F_HW_VLAN_STAG_TX |
>> -                                   NETIF_F_GSO_UDP_L4;
>> +                                   NETIF_F_HW_VLAN_STAG_TX;
>>  #ifdef CONFIG_XFRM_OFFLOAD
>>         bond_dev->hw_enc_features |=3D xfrm_features;
>>  #endif /* CONFIG_XFRM_OFFLOAD */
>> @@ -4721,7 +4720,7 @@ void bond_setup(struct net_device *bond_dev)
>>                                 NETIF_F_HW_VLAN_CTAG_RX |
>>                                 NETIF_F_HW_VLAN_CTAG_FILTER;
>>
>> -       bond_dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_U=
DP_L4;
>> +       bond_dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL;
>>  #ifdef CONFIG_XFRM_OFFLOAD
>>         bond_dev->hw_features |=3D BOND_XFRM_FEATURES;
>>  #endif /* CONFIG_XFRM_OFFLOAD */
>> diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
>> index bab3a9bb5e6f..f82ad7419508 100644
>> --- a/drivers/net/dummy.c
>> +++ b/drivers/net/dummy.c
>> @@ -124,7 +124,7 @@ static void dummy_setup(struct net_device *dev)
>>         dev->flags &=3D ~IFF_MULTICAST;
>>         dev->priv_flags |=3D IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
>>         dev->features   |=3D NETIF_F_SG | NETIF_F_FRAGLIST;
>> -       dev->features   |=3D NETIF_F_ALL_TSO;
>> +       dev->features   |=3D NETIF_F_GSO_SOFTWARE;
>>         dev->features   |=3D NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F=
_LLTX;
>>         dev->features   |=3D NETIF_F_GSO_ENCAP_ALL;
>>         dev->hw_features |=3D dev->features;
>> diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
>> index 7fe306e76281..fa63d4dee0ba 100644
>> --- a/drivers/net/ifb.c
>> +++ b/drivers/net/ifb.c
>> @@ -187,8 +187,7 @@ static const struct net_device_ops ifb_netdev_ops =
=3D {
>>  };
>>
>>  #define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST =
| \
>> -                     NETIF_F_TSO_ECN | NETIF_F_TSO | NETIF_F_TSO6      =
| \
>> -                     NETIF_F_GSO_ENCAP_ALL                             =
| \
>> +                     NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL      =
| \
>>                       NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX         =
| \
>>                       NETIF_F_HW_VLAN_STAG_TX)
>>
>> diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
>> index 07f1f3933927..b4092127a92c 100644
>> --- a/drivers/net/team/team.c
>> +++ b/drivers/net/team/team.c
>> @@ -975,11 +975,11 @@ static void team_port_disable(struct team *team,
>>  }
>>
>>  #define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
>> -                           NETIF_F_FRAGLIST | NETIF_F_ALL_TSO | \
>> +                           NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
>>                             NETIF_F_HIGHDMA | NETIF_F_LRO)
>>
>>  #define TEAM_ENC_FEATURES      (NETIF_F_HW_CSUM | NETIF_F_SG | \
>> -                                NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
>> +                                NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
>>
>>  static void __team_compute_features(struct team *team)
>>  {
>> @@ -1009,8 +1009,7 @@ static void __team_compute_features(struct team *t=
eam)
>>         team->dev->vlan_features =3D vlan_features;
>>         team->dev->hw_enc_features =3D enc_features | NETIF_F_GSO_ENCAP_=
ALL |
>>                                      NETIF_F_HW_VLAN_CTAG_TX |
>> -                                    NETIF_F_HW_VLAN_STAG_TX |
>> -                                    NETIF_F_GSO_UDP_L4;
>> +                                    NETIF_F_HW_VLAN_STAG_TX;
>>         team->dev->hard_header_len =3D max_hard_header_len;
>>
>>         team->dev->priv_flags &=3D ~IFF_XMIT_DST_RELEASE;
>> @@ -2175,7 +2174,7 @@ static void team_setup(struct net_device *dev)
>>                            NETIF_F_HW_VLAN_CTAG_RX |
>>                            NETIF_F_HW_VLAN_CTAG_FILTER;
>>
>> -       dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4=
;
>> +       dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL;
>>         dev->features |=3D dev->hw_features;
>>         dev->features |=3D NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STA=
G_TX;
>>  }
>> --
>> 2.29.2

Al

