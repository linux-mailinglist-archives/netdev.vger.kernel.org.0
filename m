Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17FD1C695C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgEFGuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:50:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60306 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726843AbgEFGuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588747817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sj0L9bzOMe10y/BYGkxLOxe7uHdN6rzSZBZfMomA/94=;
        b=gEb3+sLedbYvDTXk0IcwmnR4W1PcLp90p+YhV15Rr5CRKZnqiqgiN/eE+DncRLRL3+YhS2
        Y8MYjc3iIkbiqfdwGGCeaIVh8czf3pyiF1/udpkRX+rJehVYU7M2p7PbK498DdJlSmn0X7
        vEN6TaDnn0xqoTnxSOa3JCL6zX+e8vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-vsPC0njcP5-SPjAR2JWACw-1; Wed, 06 May 2020 02:50:13 -0400
X-MC-Unique: vsPC0njcP5-SPjAR2JWACw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27FE245F;
        Wed,  6 May 2020 06:50:11 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAB196297D;
        Wed,  6 May 2020 06:49:58 +0000 (UTC)
Subject: Re: [PATCH net-next v2 20/33] vhost_net: also populate XDP frame size
From:   Jason Wang <jasowang@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824572308.2172139.1144470511173466125.stgit@firesoul>
 <0a875a6e-8b8d-b55f-2b50-1c8dc0017a92@redhat.com>
Message-ID: <482c0099-a8b7-534e-7c91-a57cd50e9b50@redhat.com>
Date:   Wed, 6 May 2020 14:49:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0a875a6e-8b8d-b55f-2b50-1c8dc0017a92@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 =E4=B8=8B=E5=8D=882:41, Jason Wang wrote:
>
> On 2020/4/30 =E4=B8=8B=E5=8D=887:22, Jesper Dangaard Brouer wrote:
>> In vhost_net_build_xdp() the 'buf' that gets queued via an xdp_buff
>> have embedded a struct tun_xdp_hdr (located at xdp->data_hard_start)
>> which contains the buffer length 'buflen' (with tailroom for
>> skb_shared_info). Also storing this buflen in xdp->frame_sz, does not
>> obsolete struct tun_xdp_hdr, as it also contains a struct
>> virtio_net_hdr with other information.
>>
>> Cc: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>> =C2=A0 drivers/vhost/net.c |=C2=A0=C2=A0=C2=A0 1 +
>> =C2=A0 1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index 2927f02cc7e1..516519dcc8ff 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -747,6 +747,7 @@ static int vhost_net_build_xdp(struct=20
>> vhost_net_virtqueue *nvq,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp->data =3D buf + pad;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp->data_end =3D xdp->data + len;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hdr->buflen =3D buflen;
>> +=C2=A0=C2=A0=C2=A0 xdp->frame_sz =3D buflen;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 --net->refcnt_bias;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 alloc_frag->offset +=3D buflen;
>
>
> Hi Jesper:
>
> As I said in v1, tun will do this for us (patch 19) via hdr->buflen.=20
> So it looks to me this is not necessary?
>
> Thanks=20


Miss your reply. So

Acked-by: Jason Wang <jasowang@redhat.com>


