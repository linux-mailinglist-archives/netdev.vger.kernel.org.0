Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279E21C6BDD
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgEFIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:34:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24460 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728502AbgEFIez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588754093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFF8NeJjiTbv8THqbxX8heqr35COUx8hMKarYhRqfLk=;
        b=YNpcCB/lKavYcpYhtnHi17wHmr9UQxNDAwTrf9ipgR0/Apkfnube8QVwKeChHPTWQH4prC
        k3fBTp+FqewdEDuCPtsnARuLAwlmH5OJDXarJvbMTm25r72Z7hTRJyGwfEiIpFWgoQeRmd
        OeQvNoKSpYGGqPDd9cI36wFFaiKMwMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-QZzC-7xwPoeKQmxnCxlf7w-1; Wed, 06 May 2020 04:34:49 -0400
X-MC-Unique: QZzC-7xwPoeKQmxnCxlf7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DEF11005510;
        Wed,  6 May 2020 08:34:48 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 963A460BEC;
        Wed,  6 May 2020 08:34:38 +0000 (UTC)
Subject: Re: [PATCH net-next 1/2] virtio-net: don't reserve space for vnet
 header for XDP
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, "Jubran, Samih" <sameehj@amazon.com>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506102123.739f1233@carbon>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3ecb558b-5281-2497-db3c-6aae7d7f882b@redhat.com>
Date:   Wed, 6 May 2020 16:34:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506102123.739f1233@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 =E4=B8=8B=E5=8D=884:21, Jesper Dangaard Brouer wrote:
> On Wed,  6 May 2020 14:16:32 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> We tried to reserve space for vnet header before
>> xdp.data_hard_start. But this is useless since the packet could be
>> modified by XDP which may invalidate the information stored in the
>> header and
> IMHO above statements are wrong. XDP cannot access memory before
> xdp.data_hard_start. Thus, it is safe to store a vnet headers before
> xdp.data_hard_start. (The sfc driver also use this "before" area).


The problem is if we place vnet header before data_hard_start,=20
virtio-net will fail any header adjustment.

Or do you mean to copy vnet header before data_hard_start before=20
processing XDP?


>
>> there's no way for XDP to know the existence of the vnet header curren=
tly.
> It is true that XDP is unaware of this area, which is the way it
> should be.  Currently the area will survive after calling BPF/XDP.
> After your change it will be overwritten in xdp_frame cases.
>
>
>> So let's just not reserve space for vnet header in this case.
> I think this is a wrong approach!
>
> We are working on supporting GRO multi-buffer for XDP.  The vnet header
> contains GRO information (see pahole below sign).


Another note is that since we need reserve room for skb_shared_info, GRO=20
for XDP may probably lead more frag list.


>   It is currently not
> used in the XDP case, but we will be working towards using it.


Good to know that, but I think it can only work when the packet is not=20
modified by XDP?


> There
> are a lot of unanswered questions on how this will be implemented.
> Thus, I cannot layout how we are going to leverage this info yet, but
> your patch are killing this info, which IHMO is going in the wrong
> direction.


I can copy vnet header ahead of data_hard_start, does it work for you?

Thanks


>
>
>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/net/virtio_net.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 11f722460513..98dd75b665a5 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -684,8 +684,8 @@ static struct sk_buff *receive_small(struct net_de=
vice *dev,
>>   			page =3D xdp_page;
>>   		}
>>  =20
>> -		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD + vi->hdr_len;
>> -		xdp.data =3D xdp.data_hard_start + xdp_headroom;
>> +		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD;
>> +		xdp.data =3D xdp.data_hard_start + xdp_headroom + vi->hdr_len;
>>   		xdp.data_end =3D xdp.data + len;
>>   		xdp.data_meta =3D xdp.data;
>>   		xdp.rxq =3D &rq->xdp_rxq;
>> @@ -845,7 +845,7 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
>>   		 * the descriptor on if we get an XDP_TX return code.
>>   		 */
>>   		data =3D page_address(xdp_page) + offset;
>> -		xdp.data_hard_start =3D data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>> +		xdp.data_hard_start =3D data - VIRTIO_XDP_HEADROOM;
>>   		xdp.data =3D data + vi->hdr_len;
>>   		xdp.data_end =3D xdp.data + (len - vi->hdr_len);
>>   		xdp.data_meta =3D xdp.data;
>
>

