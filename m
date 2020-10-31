Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66262A1890
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgJaP2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:28:32 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:21146 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgJaP2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:28:31 -0400
X-Greylist: delayed 75315 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Oct 2020 11:28:29 EDT
Date:   Sat, 31 Oct 2020 15:28:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604158107; bh=D24b1QTO6GHf6iwyWAJrudbdgWCyPCWYsih0g1s8InI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=d/Z7bxtnt8pKsoptGUz2FqDJEVYNaNXqy6V5JiItx4eFQqVjscjtvy+b+9ZXeAfgM
         Kg9BdGwIcuRuqjaNgcrVzxa1+gaZ+GlYJfxzqZu/TPw++DAmuHzrWxCbRHXQqc0f4P
         RM0sSLXJ5hdoJkzAnqE9zCG+YJCiPMZBwRVvUlsdeC/IYoRAqdkQPZtsnPz3pbS3OF
         ipT4Q3ghlvOQwTwzt1QumFeq/Jzx4tLoNitCNHnlepr6+jOGU9gd6ibceRGjvXuQCm
         Tha/7AAVa3kqd64+/iQ5hBbiZJyyhBxctKgBaVeBOUkSHlf3xC8PH5GZD/gbr5/xXv
         aS/VSmT/KYr2g==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next] net: avoid unneeded UDP L4 and fraglist GSO resegmentation
Message-ID: <M198Gc6Cv6mbPMU05Y5E1APGMAAI2aMrpFmUiE58@cp3-web-020.plabs.ch>
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

From: Alexander Lobakin <alobakin@pm.me>
Date: Sat, 31 Oct 2020 14:17:03 +0000

> From: Alexander Lobakin <alobakin@pm.me>
> Date: Sat, 31 Oct 2020 10:31:31 +0000
>
>> On Saturday, 31 October 2020, 2:12, Willem de Bruijn <willemdebruijn.ker=
nel@gmail.com> wrote:
>>
>> Hi Willem,
>>
>>> On Fri, Oct 30, 2020 at 2:33 PM Alexander Lobakin alobakin@pm.me wrote:
>>>
>>>> Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") added a sup=
port
>>>> for fraglist UDP L4 and fraglist GSO not only for local traffic, but a=
lso
>>>> for forwarding. This works well on simple setups, but when any logical
>>>> netdev (e.g. VLAN) is present, kernel stack always performs software
>>>> resegmentation which actually kills the performance.
>>>> Despite the fact that no mainline drivers currently supports fraglist =
GSO,
>>>> this should and can be easily fixed by adding UDP L4 and fraglist GSO =
to
>>>> the list of GSO types that can be passed-through the logical interface=
s
>>>> (NETIF_F_GSO_SOFTWARE). After this change, no resegmentation occurs (i=
f
>>>> a particular driver supports and advertises this), and the performance
>>>> goes on par with e.g. 1:1 forwarding.
>>>> The only logical netdevs that seem to be unaffected to this are bridge
>>>> interfaces, as their code uses full NETIF_F_GSO_MASK.
>>>>
>>>> Tested on MIPS32 R2 router board with a WIP NIC driver in VLAN NAT:
>>>> 20 Mbps baseline, 1 Gbps / link speed with this patch.
>>>>
>>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>>> ---
>>>>  include/linux/netdev_features.h | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_fe=
atures.h
>>>> index 0b17c4322b09..934de56644e7 100644
>>>> --- a/include/linux/netdev_features.h
>>>> +++ b/include/linux/netdev_features.h
>>>> @@ -207,8 +207,8 @@ static inline int find_next_netdev_feature(u64 fea=
ture, unsigned long start)
>>>>  =09=09=09=09 NETIF_F_FSO)
>>>>
>>>>  /* List of features with software fallbacks. */
>>>> -#define NETIF_F_GSO_SOFTWARE=09(NETIF_F_ALL_TSO | \
>>>> -=09=09=09=09 NETIF_F_GSO_SCTP)
>>>> +#define NETIF_F_GSO_SOFTWARE=09(NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP |=
=09     \
>>>> +=09=09=09=09 NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST)
>>>>
>>>>  /*
>>>>   * If one device supports one of these features, then enable them
>>>> --
>>>> 2.29.2
>>>
>>> What exactly do you mean by resegmenting?
>>
>> I mean pts 5-6 from the full path:
>> 1. Our NIC driver advertises a support for fraglists, GSO UDP L4, GSO fr=
aglists.
>> 2. User enables fraglisted GRO via Ethtool.
>> 3. GRO subsystem receives UDP frames from driver and merges the packets =
into
>>    fraglisted GSO skb(s).
>> 4. Networking stack queues it up for xmitting.
>> 5. Virtual device like VLAN doesn't advertise a support for GSO UDP L4 a=
nd
>>    GSO fraglists, so skb_gso_check() doesn't allow to pass this skb as i=
s to
>>    the real driver.
>> 6. Kernel then has to form a bunch of regular UDP skbs from that one and=
 pass
>>    it to the driver instead. This fallback is *extremely* slow for any G=
SO types,
>>    but especially for GSO fraglists.
>> 7. All further processing performs with a series of plain UDP skbs, and =
the
>>    driver gets it one-by-one, despite that it supports UDP L4 and fragli=
sted GSO.
>>
>> That's not OK because:
>> a) logical/virtual netdevs like VLANs, bridges etc. should pass GSO skbs=
 as is;
>> b) even if the final driver doesn't support such type of GSO, this softw=
are
>>    resegmenting should be performed right before it, not in the middle o=
f
>>    processing -- I think I even saw that note somewhere in kernel docume=
ntation,
>>    and it's totally reasonable in terms of performance.
>>
>>> I think it is fine to reenable this again, now that UDP sockets will
>>> segment unexpected UDP GSO packets that may have looped. We previously
>>> added general software support in commit 83aa025f535f ("udp: add gso
>>> support to virtual devices"). Then reduced its scope to egress only in
>>> 8eea1ca82be9 ("gso: limit udp gso to egress-only virtual devices") to
>>> handle that edge case.
>
> Regarding bonding and teaming: I think they should also use
> NETIF_F_GSO_SOFTWARE mask, not NETIF_F_ALL_TSO, as SCTP also has
> a software fallback. This way we could also remove a separate
> advertising of NETIF_F_GSO_UDP_L4, as it will be included in the first.
>
> So, if this one:
> 1. Add NETIF_F_GSO_UDP_L4 and NETIF_F_GSO_FRAGLIST to
>    NETIF_F_GSO_SOFTWARE;
> 2. Change bonding and teaming features mask from NETIF_F_ALL_TSO |
>    NETIF_F_GSO_UDP_L4 to NETIF_F_GSO_SOFTWARE;
> 3. Check that every virtual netdev has NETIF_F_GSO_SOFTWARE _or_
>    NETIF_F_GSO_MASK in its advertising.
>
> is fine for everyone, I'll publish more appropriate and polished v2 soon.
>
>>> If we can enable for all virtual devices again, we could revert those
>>> device specific options.

Just for reference: commit 8eea1ca82be9 ("gso: limit udp gso to
egress-only virtual devices") from May 2018 (4.18-rc1) says:
"Until the udp receive stack supports large packets (UDP GRO), GSO
packets must not loop from the egress to the ingress path".
UDP GRO was actually added in commit e20cf8d3f1f7 ("udp: implement GRO
for plain UDP sockets.") (Nov 2018, 5.0-rc1) and then expanded with
fraglists with commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
(Jan 2020, v5.6-rc1), so there should be no problems with
macvlan/veth/etc. anymore.

>> Thanks,
>> Al
>
> Al

Al

