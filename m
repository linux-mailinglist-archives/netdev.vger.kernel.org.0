Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32E15B7C7
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 04:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgBMDbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 22:31:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20223 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729432AbgBMDbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 22:31:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581564712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x48Xkc/52KhxaaQHOFtPu2ZMXbY1JrtqvmLAgLZ6e18=;
        b=f56hXAbVG0xt+fOpk8wdrJnSIHfHglYwz11krUjAqqOalFatHln3FhDWd0dStisvRcn99C
        nM53whYrb5kWx6hCjGZhf/Nn4MmH+8alrdLFqrXaDGUvNBDI/TnHOdfv3QAlULv2Rw7/GW
        MGvUT5EX1bDsPQPlk+bMeKe945jFCuw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-qgUXa6ttM3qy-xfPilOMbw-1; Wed, 12 Feb 2020 22:31:45 -0500
X-MC-Unique: qgUXa6ttM3qy-xfPilOMbw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6555D1005502;
        Thu, 13 Feb 2020 03:31:44 +0000 (UTC)
Received: from [10.72.13.212] (ovpn-13-212.pek2.redhat.com [10.72.13.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3CA35C1B2;
        Thu, 13 Feb 2020 03:31:39 +0000 (UTC)
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <71193f51-9606-58ba-39d7-904bc9fbd29a@redhat.com>
Date:   Thu, 13 Feb 2020 11:31:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/13 =E4=B8=8A=E5=8D=881:38, Anton Ivanov wrote:
>
>
> On 11/02/2020 10:37, Michael S. Tsirkin wrote:
>> On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
>>> On 11/02/2020 02:51, Jason Wang wrote:
>>>>
>>>> On 2020/2/11 =E4=B8=8A=E5=8D=8812:55, Anton Ivanov wrote:
>>>>>
>>>>>
>>>>> On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
>>>>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>>
>>>>>> Some of the frames marked as GSO which arrive at
>>>>>> virtio_net_hdr_from_skb() have no GSO_TYPE, no
>>>>>> fragments (data_len =3D 0) and length significantly shorter
>>>>>> than the MTU (752 in my experiments).
>>>>>>
>>>>>> This is observed on raw sockets reading off vEth interfaces
>>>>>> in all 4.x and 5.x kernels I tested.
>>>>>>
>>>>>> These frames are reported as invalid while they are in fact
>>>>>> gso-less frames.
>>>>>>
>>>>>> This patch marks the vnet header as no-GSO for them instead
>>>>>> of reporting it as invalid.
>>>>>>
>>>>>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>> ---
>>>>>> =C2=A0=C2=A0 include/linux/virtio_net.h | 8 ++++++--
>>>>>> =C2=A0=C2=A0 1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net=
.h
>>>>>> index 0d1fe9297ac6..d90d5cff1b9a 100644
>>>>>> --- a/include/linux/virtio_net.h
>>>>>> +++ b/include/linux/virtio_net.h
>>>>>> @@ -112,8 +112,12 @@ static inline int
>>>>>> virtio_net_hdr_from_skb(const struct sk_buff *skb,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 hdr->gso_type =3D VIRTIO_NET_HDR_GSO_TCPV4;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else =
if (sinfo->gso_type & SKB_GSO_TCPV6)
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 hdr->gso_type =3D VIRTIO_NET_HDR_GSO_TCPV6;
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return -EINVAL;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (skb->data_len =3D=3D 0)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 hdr->gso_type =3D VIRTIO_NET_HDR_GSO_NONE;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 else
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (s=
info->gso_type & SKB_GSO_TCP_ECN)
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 hdr->gso_type |=3D VIRTIO_NET_HDR_GSO_ECN;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else
>>>>>>
>>>>>
>>>>> ping.
>>>>>
>>>>
>>>> Do you mean gso_size is set but gso_type is not? Looks like a bug
>>>> elsewhere.
>>>>
>>>> Thanks
>>>>
>>>>
>>> Yes.
>>>
>>> I could not trace it where it is coming from.
>>>
>>> I see it when doing recvmmsg on raw sockets in the UML vector network
>>> drivers.
>>>
>>
>> I think we need to find the culprit and fix it there, lots of other=20
>> things
>> can break otherwise.
>> Just printing out skb->dev->name should do the trick, no?
>
> The printk in virtio_net_hdr_from_skb says NULL.
>
> That is probably normal for a locally originated frame.
>
> I cannot reproduce this with network traffic by the way - it happens=20
> only if the traffic is locally originated on the host.
>
> A,


Or maybe you can try add dump_stack() there.

Thanks



