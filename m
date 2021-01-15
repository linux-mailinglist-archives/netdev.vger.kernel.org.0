Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40452F7C38
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732423AbhAONMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:12:54 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:16050 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732401AbhAONMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:12:53 -0500
Date:   Fri, 15 Jan 2021 13:12:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610716324; bh=NguSqZkMHbDTllfHQVJGRNdK9JFA+eLh3q6gS3Z/Ceo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RyxOgHcW+HlYzCRFiPADCVIffFe/ZUMSorLLM5SalBq0urQpCtjwgasDsgLp3YW98
         0eNDjhouY9j7KnRtqtfn/DgoomDz7qvs9R1tHOpa0AJ1us79bSFI/piOQkBc8bLfL3
         LQZzGlvBCZ/PheCuYGd2eMmo96KYVgeSdy1H3MS8hoQ9AuZSOXYSphhICDukNxM36m
         uGNuRs7dKtYv41BKiOOkx+V/XmTaF3JsUVTmT7cDaingay2wTd2j0q3Jgk4FV/mLWm
         QDqdoCy9Pqqfc4OplLYK44KbQF1+yJXxLR/ziDGdxP1Ikk4d8h0ZiLtl6b7GNK3N/q
         u5dSaa7BYA3pA==
To:     Dongseok Yi <dseok.yi@samsung.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, namkyu78.kim@samsung.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: RE: [PATCH net] udp: ipv4: manipulate network header of NATed UDP GRO fraglist
Message-ID: <20210115131126.60716-1-alobakin@pm.me>
In-Reply-To: <020101d6eb30$84363170$8ca29450$@samsung.com>
References: <CGME20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704@epcas2p4.samsung.com> <1610690304-167832-1-git-send-email-dseok.yi@samsung.com> <20210115081243.GM9390@gauss3.secunet.de> <01e801d6eb1c$2898c300$79ca4900$@samsung.com> <20210115092752.GN9390@gauss3.secunet.de> <20210115105048.2689-1-alobakin@pm.me> <020101d6eb30$84363170$8ca29450$@samsung.com>
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

From: Dongseok Yi <dseok.yi@samsung.com>
Date: Fri, 15 Jan 2021 20:21:06 +0900

> On 2021-01-15 19:51, Alexander Lobakin wrote:
>> From: Steffen Klassert <steffen.klassert@secunet.com>
>> Date: Fri, 15 Jan 2021 10:27:52 +0100
>>
>>> On Fri, Jan 15, 2021 at 05:55:22PM +0900, Dongseok Yi wrote:
>>>> On 2021-01-15 17:12, Steffen Klassert wrote:
>>>>> On Fri, Jan 15, 2021 at 02:58:24PM +0900, Dongseok Yi wrote:
>>>>>> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
>>>>>> forwarding. Only the header of head_skb from ip_finish_output_gso ->
>>>>>> skb_gso_segment is updated but following frag_skbs are not updated.
>>>>>>
>>>>>> A call path skb_mac_gso_segment -> inet_gso_segment ->
>>>>>> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
>>>>>> does not try to update UDP/IP header of the segment list.
>>>>>
>>>>> We still need to find out why it works for Alexander, but not for you=
.
>>>>> Different usecases?
>>>>
>>>> This patch is not for
>>>> https://lore.kernel.org/patchwork/patch/1364544/
>>>> Alexander might want to call udp_gro_receive_segment even when
>>>> !sk and ~NETIF_F_GRO_FRAGLIST.
>>>
>>> Yes, I know. But he said that fraglist GRO + NAT works for him.
>>> I want to find out why it works for him, but not for you.
>>
>> I found that it worked for me because I advertised fraglist GSO
>> support in my driver (and added actual support for xmitting
>> fraglists). If so, kernel won't resegment GSO into a list of
>> plain packets, so no __udp_gso_segment_list() will be called.
>>
>> I think it will break if I disable fraglist GSO feature through
>> Ethtool, so I could test your patches.
>
> Thanks for the reply. In my case I enabled NETIF_F_GRO_FRAGLIST on
> my driver. It expected that NAT done on each skb of the forwarded
> fraglist.
>
>>
>>>>>
>>>>> I would not like to add this to a generic codepath. I think we can
>>>>> relatively easy copy the full headers in skb_segment_list().
>>>>
>>>> I tried to copy the full headers with the similar approach, but it
>>>> copies length too. Can we keep the length of each skb of the fraglist?
>>>
>>> Ah yes, good point.
>>>
>>> Then maybe you can move your approach into __udp_gso_segment_list()
>>> so that we dont touch generic code.
>>>
>
> Okay, I will move it into __udp_gso_segment_list() on v3.

I'll take this one. We also need to cover cases with altered headroom
size, e.g. when the NIC is behind the switch and sends packets with
CPU tags that is being added prior to resegmentation.
The base suggested by Steffen in good enough, just needs a bit more
handling. I'll publish a final fix soon.

>>>>
>>>>>
>>>>> I think about something like the (completely untested) patch below:
>>>>>
>>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>>> index f62cae3f75d8..63ae7f79fad7 100644
>>>>> --- a/net/core/skbuff.c
>>>>> +++ b/net/core/skbuff.c
>>>>> @@ -3651,13 +3651,14 @@ struct sk_buff *skb_segment_list(struct sk_bu=
ff *skb,
>>>>>  =09=09=09=09 unsigned int offset)
>>>>>  {
>>>>>  =09struct sk_buff *list_skb =3D skb_shinfo(skb)->frag_list;
>>>>> +=09unsigned int doffset =3D skb->data - skb_mac_header(skb);
>>>>>  =09unsigned int tnl_hlen =3D skb_tnl_header_len(skb);
>>>>>  =09unsigned int delta_truesize =3D 0;
>>>>>  =09unsigned int delta_len =3D 0;
>>>>>  =09struct sk_buff *tail =3D NULL;
>>>>>  =09struct sk_buff *nskb;
>>>>>
>>>>> -=09skb_push(skb, -skb_network_offset(skb) + offset);
>>>>> +=09skb_push(skb, doffset);
>>>>>
>>>>>  =09skb_shinfo(skb)->frag_list =3D NULL;
>>>>>
>>>>> @@ -3675,7 +3676,7 @@ struct sk_buff *skb_segment_list(struct sk_buff=
 *skb,
>>>>>  =09=09delta_len +=3D nskb->len;
>>>>>  =09=09delta_truesize +=3D nskb->truesize;
>>>>>
>>>>> -=09=09skb_push(nskb, -skb_network_offset(nskb) + offset);
>>>>> +=09=09skb_push(nskb, doffset);
>>>>>
>>>>>  =09=09skb_release_head_state(nskb);
>>>>>  =09=09 __copy_skb_header(nskb, skb);
>>>>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>>>>> index ff39e94781bf..1181398378b8 100644
>>>>> --- a/net/ipv4/udp_offload.c
>>>>> +++ b/net/ipv4/udp_offload.c
>>>>> @@ -190,9 +190,22 @@ EXPORT_SYMBOL(skb_udp_tunnel_segment);
>>>>>  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
>>>>>  =09=09=09=09=09      netdev_features_t features)
>>>>>  {
>>>>> +=09struct sk_buff *list_skb =3D skb_shinfo(skb)->frag_list;
>>>>>  =09unsigned int mss =3D skb_shinfo(skb)->gso_size;
>>>>> +=09unsigned int offset;
>>>>>
>>>>> -=09skb =3D skb_segment_list(skb, features, skb_mac_header_len(skb));
>>>>> +=09skb_headers_offset_update(list_skb, skb_headroom(list_skb) - skb_=
headroom(skb));
>>>>> +
>>>>> +=09/* Check for header changes and copy the full header in that case=
. */
>>>>> +=09if ((udp_hdr(skb)->dest =3D=3D udp_hdr(list_skb)->dest) &&
>>>>> +=09    (udp_hdr(skb)->source =3D=3D udp_hdr(list_skb)->source) &&
>>>>> +=09    (ip_hdr(skb)->daddr =3D=3D ip_hdr(list_skb)->daddr) &&
>>>>> +=09    (ip_hdr(skb)->saddr =3D=3D ip_hdr(list_skb)->saddr))
>>>>> +=09=09offset =3D skb_mac_header_len(skb);
>>>>> +=09else
>>>>> +=09=09offset =3D skb->data - skb_mac_header(skb);
>>>>> +
>>>>> +=09skb =3D skb_segment_list(skb, features, offset);
>>>>>  =09if (IS_ERR(skb))
>>>>>  =09=09return skb;
>>>>>
>>>>>
>>>>> After that you can apply the CSUM magic in __udp_gso_segment_list().
>>
>> I'll test and let you know if it works. If doesn't, I think I'll be
>> able to get a working one based on this.
>>
>>>> Sorry, I don't know CSUM magic well. Is it used for checksum
>>>> incremental update too?
>>>
>>> With that I meant the checksum updating you did in your patch.
>
> Ah, I see.
>
>>
>> Thanks,
>> Al

Al

