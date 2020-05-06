Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025081C6935
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEFGoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:44:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726843AbgEFGoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588747442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fLJ7tzkQRnX/e2EOBzrs4sawlbSbrVa/ew+7YuNUqzc=;
        b=ZwKCBkN4u6uLW1gls8qW9R12U6WK2txQNrztOV6/EEkoQQ2+dN0BRu2pjNQdMm1FQjio6a
        S24B1jOo1kj++DIY76+zIAfXi3P49WpCMCncvDlnsnbxhQbwixxYCrSNnZlQAaRUKwdYQ+
        3kVe54bdw6SP2IjNhrzyHqAB9/Zcw+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-uZIIn0n5NBy_MFYyCmgfYA-1; Wed, 06 May 2020 02:44:01 -0400
X-MC-Unique: uZIIn0n5NBy_MFYyCmgfYA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C4245F;
        Wed,  6 May 2020 06:43:58 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A49A8605DF;
        Wed,  6 May 2020 06:43:47 +0000 (UTC)
Subject: Re: [PATCH net-next 20/33] vhost_net: also populate XDP frame size
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
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
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757174266.1370371.14475202001364271065.stgit@firesoul>
 <8ebbd5d8-e256-3d6b-7cc1-dd3d29be3504@redhat.com>
 <20200430115415.5e4c815e@carbon>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e7d77cd5-ecad-2ac6-ae62-cace7a66a874@redhat.com>
Date:   Wed, 6 May 2020 14:43:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430115415.5e4c815e@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/30 =E4=B8=8B=E5=8D=885:54, Jesper Dangaard Brouer wrote:
> On Mon, 27 Apr 2020 13:50:15 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2020/4/23 =E4=B8=8A=E5=8D=8812:09, Jesper Dangaard Brouer wrote:
>>> In vhost_net_build_xdp() the 'buf' that gets queued via an xdp_buff
>>> have embedded a struct tun_xdp_hdr (located at xdp->data_hard_start)
>>> which contains the buffer length 'buflen' (with tailroom for
>>> skb_shared_info). Also storing this buflen in xdp->frame_sz, does not
>>> obsolete struct tun_xdp_hdr, as it also contains a struct
>>> virtio_net_hdr with other information.
>>>
>>> Cc: Jason Wang <jasowang@redhat.com>
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>> ---
>>>    drivers/vhost/net.c |    1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>>> index 87469d67ede8..69af007e22f4 100644
>>> --- a/drivers/vhost/net.c
>>> +++ b/drivers/vhost/net.c
>>> @@ -745,6 +745,7 @@ static int vhost_net_build_xdp(struct vhost_net_v=
irtqueue *nvq,
>>>    	xdp->data =3D buf + pad;
>>>    	xdp->data_end =3D xdp->data + len;
>>>    	hdr->buflen =3D buflen;
>>> +	xdp->frame_sz =3D buflen;
>>>   =20
>>>    	--net->refcnt_bias;
>>>    	alloc_frag->offset +=3D buflen;
>>
>> Tun_xdp_one() will use hdr->buflen as the frame_sz (patch 19), so it
>> looks to me there's no need to do this?
> I was thinking to go the "other way", meaning let tun_xdp_one() use
> xdp->frame_sz, which gets set here.  This would allow us to refactor
> the code, and drop struct tun_xdp_hdr, as (see pahole below) it only
> carries 'buflen' and the remaining part comes from struct
> virtio_net_hdr, which could be used directly instead.
>
> As this will be a code refactor, I would prefer we do it after this
> patchseries is agreed upon.
>
> $ pahole -C tun_xdp_hdr drivers/net/tap.o
> struct tun_xdp_hdr {
> 	int                        buflen;               /*     0     4 */
> 	struct virtio_net_hdr gso;                       /*     4    10 */
>
> 	/* size: 16, cachelines: 1, members: 2 */
> 	/* padding: 2 */
> 	/* last cacheline: 16 bytes */
> };


Ok I get this.

Thanks


