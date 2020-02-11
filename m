Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FF4158871
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 03:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgBKCwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 21:52:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727667AbgBKCwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 21:52:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581389527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KywBuU09rYNz429kY0Ae4epXMjSlQsHT1yqP8FKWMc=;
        b=IaFne+tJH5eEycUvo1G4behCAaNIc0kPjJkqfPdVkuLPqYIUNCnHXoqm5BcsTZ2x8z0HOp
        DxixjoLVl/c9BhsqLtb38FVCQJ8OuoUHAwBtp7jJ04mbJT/RDDwtpQ6q/s2zBDxWzlfELg
        ikAW9n/Y7npSeq0xS8+t9e0BEYGqeIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-NLmRvZ56OAWtuJp8fyX7Vw-1; Mon, 10 Feb 2020 21:52:05 -0500
X-MC-Unique: NLmRvZ56OAWtuJp8fyX7Vw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17EE510054E3;
        Tue, 11 Feb 2020 02:52:04 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 733365C10E;
        Tue, 11 Feb 2020 02:51:56 +0000 (UTC)
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        netdev@vger.kernel.org
Cc:     linux-um@lists.infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
Date:   Tue, 11 Feb 2020 10:51:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/11 =E4=B8=8A=E5=8D=8812:55, Anton Ivanov wrote:
>
>
> On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>
>> Some of the frames marked as GSO which arrive at
>> virtio_net_hdr_from_skb() have no GSO_TYPE, no
>> fragments (data_len =3D 0) and length significantly shorter
>> than the MTU (752 in my experiments).
>>
>> This is observed on raw sockets reading off vEth interfaces
>> in all 4.x and 5.x kernels I tested.
>>
>> These frames are reported as invalid while they are in fact
>> gso-less frames.
>>
>> This patch marks the vnet header as no-GSO for them instead
>> of reporting it as invalid.
>>
>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>> ---
>> =C2=A0 include/linux/virtio_net.h | 8 ++++++--
>> =C2=A0 1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>> index 0d1fe9297ac6..d90d5cff1b9a 100644
>> --- a/include/linux/virtio_net.h
>> +++ b/include/linux/virtio_net.h
>> @@ -112,8 +112,12 @@ static inline int virtio_net_hdr_from_skb(const=20
>> struct sk_buff *skb,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 hdr->gso_type =3D VIRTIO_NET_HDR_GSO_TCPV4;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if (sinfo-=
>gso_type & SKB_GSO_TCPV6)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 hdr->gso_type =3D VIRTIO_NET_HDR_GSO_TCPV6;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (skb->data_len =3D=3D 0)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 hdr->gso_type =3D VIRTIO_NET_HDR_GSO_NONE;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 el=
se
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sinfo->gso_=
type & SKB_GSO_TCP_ECN)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 hdr->gso_type |=3D VIRTIO_NET_HDR_GSO_ECN;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else
>>
>
> ping.
>

Do you mean gso_size is set but gso_type is not? Looks like a bug elsewhe=
re.

Thanks

