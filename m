Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3C231F617
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhBSIwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 03:52:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229879AbhBSIwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 03:52:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613724677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bzW38bag0aKrL8zMi/Uhja163ywErKOZZj1OgGSNVuk=;
        b=JgJPqFdCT90GMDkz//sFa0Y0AxhUQjFpuf2xhZ26LUvzftdNiCdw6sVHh6+46MZxe9MMbG
        EUiGHll78NWDS7/b3REYdyEMhduwx/s8Xkwt5HrjESJGlyHp4uQUDu5g7bpvqiPnAkvVFJ
        VdulWdWiKi69CX4z+JnUWC6kLDZ8wWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-_fgkeNYdPoevbhB3Idx16A-1; Fri, 19 Feb 2021 03:51:15 -0500
X-MC-Unique: _fgkeNYdPoevbhB3Idx16A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B59F107ACE6;
        Fri, 19 Feb 2021 08:51:14 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-40.pek2.redhat.com [10.72.12.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41A675D9C2;
        Fri, 19 Feb 2021 08:51:06 +0000 (UTC)
Subject: Re: [PATCH] net: check if protocol extracted by
 virtio_net_hdr_set_proto is correct
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Balazs Nemeth <bnemeth@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
References: <5e910d11a14da17c41317417fc41d3a9d472c6e7.1613659844.git.bnemeth@redhat.com>
 <CA+FuTSe7srSBnAmFNFBFkDrLmPL5XtxhbXEs1mBytUBuuym2fg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2cc06597-8005-7be8-4094-b20f525afde8@redhat.com>
Date:   Fri, 19 Feb 2021 16:51:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSe7srSBnAmFNFBFkDrLmPL5XtxhbXEs1mBytUBuuym2fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/18 11:50 下午, Willem de Bruijn wrote:
> On Thu, Feb 18, 2021 at 10:01 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>> For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
>> set) based on the type in the virtio net hdr, but the skb could contain
>> anything since it could come from packet_snd through a raw socket. If
>> there is a mismatch between what virtio_net_hdr_set_proto sets and
>> the actual protocol, then the skb could be handled incorrectly later
>> on by gso.
>>
>> The network header of gso packets starts at 14 bytes, but a specially
>> crafted packet could fool the call to skb_flow_dissect_flow_keys_basic
>> as the network header offset in the skb could be incorrect.
>> Consequently, EINVAL is not returned.
>>
>> There are even packets that can cause an infinite loop. For example, a
>> packet with ethernet type ETH_P_MPLS_UC (which is unnoticed by
>> virtio_net_hdr_to_skb) that is sent to a geneve interface will be
>> handled by geneve_build_skb. In turn, it calls
>> udp_tunnel_handle_offloads which then calls skb_reset_inner_headers.
>> After that, the packet gets passed to mpls_gso_segment. That function
>> calculates the mpls header length by taking the difference between
>> network_header and inner_network_header. Since the two are equal
>> (due to the earlier call to skb_reset_inner_headers), it will calculate
>> a header of length 0, and it will not pull any headers. Then, it will
>> call skb_mac_gso_segment which will again call mpls_gso_segment, etc...
>> This leads to the infinite loop.


I remember kernel will validate dodgy gso packets in gso ops. I wonder 
why not do the check there? The reason is that virtio/TUN is not the 
only source for those packets.

Thanks


>>
>> For that reason, address the root cause of the issue: don't blindly
>> trust the information provided by the virtio net header. Instead,
>> check if the protocol in the packet actually matches the protocol set by
>> virtio_net_hdr_set_proto.
>>
>> Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
>> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
>> ---
>>   include/linux/virtio_net.h | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>> index e8a924eeea3d..cf2c53563f22 100644
>> --- a/include/linux/virtio_net.h
>> +++ b/include/linux/virtio_net.h
>> @@ -79,8 +79,13 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>>                  if (gso_type && skb->network_header) {
>>                          struct flow_keys_basic keys;
>>
>> -                       if (!skb->protocol)
>> +                       if (!skb->protocol) {
>> +                               const struct ethhdr *eth = skb_eth_hdr(skb);
>> +
> Unfortunately, cannot assume that the device type is ARPHRD_ETHER.
>
> The underlying approach is sound: packets that have a gso type set in
> the virtio_net_hdr have to be IP packets.
>
>>                                  virtio_net_hdr_set_proto(skb, hdr);
>> +                               if (skb->protocol != eth->h_proto)
>> +                                       return -EINVAL;
>> +                       }
>>   retry:
>>                          if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>>                                                                NULL, 0, 0, 0,
>> --
>> 2.29.2
>>

