Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B902F484C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAMKGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:06:16 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:50035 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbhAMKGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 05:06:15 -0500
Date:   Wed, 13 Jan 2021 10:05:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610532327; bh=3cMP6aCGpwdrhC9aDRMC5OocIsu8kiFlHn7rlrVByGs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=D8JWBbn9AoasAMJl2qT4ZipOZpgjg1guuhDDW691mwaz2qDzASMcvwm+OEfd1k+7g
         66BRcC8oCghHEtSoEhAQfeGcHyJu0qxBBbyqRPSCfv/Zfs5vBFbdIKkEF864erZTIM
         P0bU/x+HjrTln5wjudx5TKY1++B/AbiBdnb3pxbePrBTml4vAH0f5WJJgWlJnhQGOt
         NyUuGGrJ9exILBDx4YRx3INS7Llgx/6tRdKqEsGQSeneAkVTgw3vdofTfzSpAEtmpj
         v7nPucVFA9N7xA/YYzSfh0zXjHYn+sja+Gx9+rFisYpHnquI2IuE9wQyqqBeDmTyVs
         eJkxFrjrsFC0Q==
To:     Dongseok Yi <dseok.yi@samsung.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     'Alexander Lobakin' <alobakin@pm.me>,
        'Alexander Duyck' <alexander.duyck@gmail.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Eric Dumazet' <edumazet@google.com>,
        'Edward Cree' <ecree@solarflare.com>,
        'Willem de Bruijn' <willemb@google.com>,
        'Steffen Klassert' <steffen.klassert@secunet.com>,
        'Alexey Kuznetsov' <kuznet@ms2.inr.ac.ru>,
        'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: RE: [PATCH net-next] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210113100438.2061-1-alobakin@pm.me>
In-Reply-To: <001401d6e960$87cab7b0$97602710$@samsung.com>
References: <20210112211536.261172-1-alobakin@pm.me> <CGME20210113031405epcas2p265f8a05fd83cf818e8ef4cabd6c687b2@epcas2p2.samsung.com> <6fb72534-d4d4-94d8-28d1-aabf16e11488@gmail.com> <001401d6e960$87cab7b0$97602710$@samsung.com>
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

From: "'Alexander Lobakin'" <alobakin@pm.me>

From: Dongseok Yi" <dseok.yi@samsung.com>
Date: Wed, 13 Jan 2021 12:59:45 +0900

> On 2021-01-13 12:10, Alexander Duyck wrote:
>> On 1/12/21 1:16 PM, Alexander Lobakin wrote:
>>> Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
>>> not only added a support for fraglisted UDP GRO, but also tweaked
>>> some logics the way that non-fraglisted UDP GRO started to work for
>>> forwarding too.
>>> Tests showed that currently forwarding and NATing of plain UDP GRO
>>> packets are performed fully correctly, regardless if the target
>>> netdevice has a support for hardware/driver GSO UDP L4 or not.
>>> Add the last element and allow to form plain UDP GRO packets if
>>> there is no socket -> we are on forwarding path.
>>>
>
> Your patch is very similar with the RFC what I submitted but has
> different approach. My concern was NAT forwarding.
> https://lore.kernel.org/patchwork/patch/1362257/

Not really. You tried to forbid forwarding of fraglisted UDP GRO
packets, I allow forwarding of plain UDP GRO packets.
With my patch on, you can switch between plain and fraglisted UDP GRO
with the command:

ethtool -K eth0 rx-gro-list on/off

> Nevertheless, I agreed with your idea that allow fraglisted UDP GRO
> if there is socket.

Recheck my change. There's ||, not &&.

As I said in the commit message, forwarding and NATing of plain
UDP GRO packets are performed correctly, both with and without
driver-side support, so it's safe to enable.

Also, as I said in reply to your RFC, NATing of UDP GRO fraglists
is performed correctly if driver is aware of it and advertises a
support for fraglist GSO.
If not, then there may be problems you described. But the idea to
forbid forwarding and NATing of any UDP GRO skbs is an absolute
overkill.

>>> Plain UDP GRO forwarding even shows better performance than fraglisted
>>> UDP GRO in some cases due to not wasting one skbuff_head per every
>>> segment.
>>>
>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>> ---
>>>   net/ipv4/udp_offload.c | 5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>>> index ff39e94781bf..9d71df3d52ce 100644
>>> --- a/net/ipv4/udp_offload.c
>>> +++ b/net/ipv4/udp_offload.c
>>> @@ -460,12 +460,13 @@ struct sk_buff *udp_gro_receive(struct list_head =
*head, struct sk_buff *skb,
>>>   =09if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
>>>   =09=09NAPI_GRO_CB(skb)->is_flist =3D sk ? !udp_sk(sk)->gro_enabled: 1=
;
>
> is_flist can be true even if !sk.
>
>>>
>>> -=09if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) =
{
>>> +=09if (!sk || (sk && udp_sk(sk)->gro_enabled) ||
>
> Actually sk would be NULL by udp_encap_needed_key in udp4_gro_receive
> or udp6_gro_receive.
>
>>> +=09    NAPI_GRO_CB(skb)->is_flist) {
>>>   =09=09pp =3D call_gro_receive(udp_gro_receive_segment, head, skb);
>
> udp_gro_receive_segment will check is_flist first and try to do
> fraglisted UDP GRO. Can you check what I'm missing?

I think you miss that is_flist is set to true *only* if the receiving
netdevice has NETIF_F_GRO_FRAGLIST feature on.
If it's not, stack will form a non-fraglisted UDP GRO skb. That was
tested multiple times.

>>>   =09=09return pp;
>>>   =09}
>>>
>>
>> The second check for sk in "(sk && udp_sk(sk)->gro_enabled)" is
>> redundant and can be dropped. You already verified it is present when
>> you checked for !sk before the logical OR.

Alex are right, I'll simplify the condition in v2. Thanks!

> Sorry, Alexander Duyck. I believe Alexander Lobakin will answer this.
>
>>> -=09if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
>>> +=09if (NAPI_GRO_CB(skb)->encap_mark ||
>>>   =09    (skb->ip_summed !=3D CHECKSUM_PARTIAL &&
>>>   =09     NAPI_GRO_CB(skb)->csum_cnt =3D=3D 0 &&
>>>   =09     !NAPI_GRO_CB(skb)->csum_valid) ||
>>>

Al

