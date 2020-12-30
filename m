Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE2F2E7714
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 09:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgL3IkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 03:40:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbgL3IkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 03:40:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609317513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gXGRrEKfp1XBbzT9rwci0lnhPFNMUzMfAOk3WaXRwXc=;
        b=NhnYcoT0e05TPRnigG2PVUUkSLkgOJPWu9mXXeBnK41kcbv9/JUzmcHw2RkRlWqQ0tt4eT
        EsmrziYmwa/xs0sfDwYxTgBOEDzueHP6w4jRsMMnehULGNjkGgWiUjPcpend7DPZ1GVjxQ
        455c+1ORLO21EX63NZLGUQ1fmdS1zi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-jAD8VXo4PrC8U1bHMtDoXQ-1; Wed, 30 Dec 2020 03:38:30 -0500
X-MC-Unique: jAD8VXo4PrC8U1bHMtDoXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD14C425E0;
        Wed, 30 Dec 2020 08:38:29 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC291A262;
        Wed, 30 Dec 2020 08:38:22 +0000 (UTC)
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20201228122253-mutt-send-email-mst@kernel.org>
 <CA+FuTScguDWkvk=Lc+GzP=UCK2wjRFNJ_GEn_bniHpCDWdkfjg@mail.gmail.com>
 <20201228162903-mutt-send-email-mst@kernel.org>
 <CA+FuTSffjFZGGwpMkpnTBbHHwnJN7if=0cVf0Des7Db5UFe0bw@mail.gmail.com>
 <1881606476.40780520.1609233449300.JavaMail.zimbra@redhat.com>
 <CA+FuTScycxSHqxvZZRjK9+tpXVV2iTv8vqeFc5U_m2CGDR3jog@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <da66cc7b-826c-cb55-8825-b6d3687a1e3c@redhat.com>
Date:   Wed, 30 Dec 2020 16:38:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTScycxSHqxvZZRjK9+tpXVV2iTv8vqeFc5U_m2CGDR3jog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午10:20, Willem de Bruijn wrote:
> On Tue, Dec 29, 2020 at 4:23 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>>
>> ----- Original Message -----
>>> On Mon, Dec 28, 2020 at 7:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>> On Mon, Dec 28, 2020 at 02:30:31PM -0500, Willem de Bruijn wrote:
>>>>> On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com>
>>>>> wrote:
>>>>>> On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
>>>>>>> From: Willem de Bruijn <willemb@google.com>
>>>>>>>
>>>>>>> Add optional PTP hardware timestamp offload for virtio-net.
>>>>>>>
>>>>>>> Accurate RTT measurement requires timestamps close to the wire.
>>>>>>> Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
>>>>>>> virtio-net header is expanded with room for a timestamp. A host may
>>>>>>> pass receive timestamps for all or some packets. A timestamp is valid
>>>>>>> if non-zero.
>>>>>>>
>>>>>>> The timestamp straddles (virtual) hardware domains. Like PTP, use
>>>>>>> international atomic time (CLOCK_TAI) as global clock base. It is
>>>>>>> guest responsibility to sync with host, e.g., through kvm-clock.
>>>>>>>
>>>>>>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>>>>>>> diff --git a/include/uapi/linux/virtio_net.h
>>>>>>> b/include/uapi/linux/virtio_net.h
>>>>>>> index f6881b5b77ee..0ffe2eeebd4a 100644
>>>>>>> --- a/include/uapi/linux/virtio_net.h
>>>>>>> +++ b/include/uapi/linux/virtio_net.h
>>>>>>> @@ -57,6 +57,7 @@
>>>>>>>                                         * Steering */
>>>>>>>   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
>>>>>>>
>>>>>>> +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI
>>>>>>> receive time */
>>>>>>>   #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
>>>>>>>   #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
>>>>>>>   #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
>>>>>>> @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
>>>>>>>        };
>>>>>>>   };
>>>>>>>
>>>>>>> +struct virtio_net_hdr_v12 {
>>>>>>> +     struct virtio_net_hdr_v1 hdr;
>>>>>>> +     struct {
>>>>>>> +             __le32 value;
>>>>>>> +             __le16 report;
>>>>>>> +             __le16 flow_state;
>>>>>>> +     } hash;
>>>>>>> +     __virtio32 reserved;
>>>>>>> +     __virtio64 tstamp;
>>>>>>> +};
>>>>>>> +
>>>>>>>   #ifndef VIRTIO_NET_NO_LEGACY
>>>>>>>   /* This header comes first in the scatter-gather list.
>>>>>>>    * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it
>>>>>>>    must
>>>>>>
>>>>>> So it looks like VIRTIO_NET_F_RX_TSTAMP should depend on both
>>>>>> VIRTIO_NET_F_RX_TSTAMP and VIRTIO_NET_F_HASH_REPORT then?
>>>>> Do you mean VIRTIO_NET_F_TX_TSTAMP depends on VIRTIO_NET_F_RX_TSTAMP?
>>>>>
>>>>> I think if either is enabled we need to enable the extended layout.
>>>>> Regardless of whether TX_HASH or HASH_REPORT are enabled. If they are
>>>>> not, then those fields are ignored.
>>>> I mean do we waste the 8 bytes for hash if TSTAMP is set but HASH is not?
>>>> If TSTAMP depends on HASH then point is moot.
>>> True, but the two features really are independent.
>>>
>>> I did consider using configurable metadata layout depending on
>>> features negotiated. If there are tons of optional extensions, that
>>> makes sense. But it is more complex and parsing error prone. With a
>>> handful of options each of a few bytes, that did not seem worth the
>>> cost to me at this point.
>> Consider NFV workloads(64B) packet. Most fields of current vnet header
>> is even a burdern.
> Such workloads will not negotiate these features, I imagine.
>
> I think this could only become an issue if a small packet workload
> would want to negotiate one optional feature, without the others.


Yes.


> Even then, the actual cost of a few untouched bytes is negligible, as
> long as the headers don't span cache-lines.


Right. It looks to me with hash report support the current header has 
exceeds 32 bytes which is the cacheline size for some archs. And it can 
be imagined that after two or more features it could be larger than 64 
bytes.


>   I expect it to be cheaper
> than having to parse a dynamic layout.


The only overhead is probably analyzing "type" which should be cheap I 
guess.


>
>> It might be the time to introduce configurable or
>> self-descriptive vnet header.
> I did briefly toy with a type-val encoding. Not type-val-len, as all
> options have fixed length (so far), so length can be left implicit.
> But as each feature is negotiated before hand, the type can be left
> implicit too. Leaving just the data elements tightly packed. As long
> as order is defined.


Right, so in this case there should be even no overhead.


>
>>> And importantly, such a mode can always be added later as a separate
>>> VIRTIO_NET_F_PACKED_HEADER option.
>> What will do feature provide?
> The tightly packed data elements. Strip out the elements for non
> negotiated features. So if either tstamp option is negotiated, but
> hash is not, exclude the 64b of hash fields. Note that I'm not
> actually arguing for this (at this point).


I second for this.

Thanks

