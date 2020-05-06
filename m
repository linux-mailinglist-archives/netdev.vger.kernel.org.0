Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13CC1C690D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgEFGif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:38:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21961 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727879AbgEFGie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:38:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588747112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAGX7ieJWnKg6o+Mvr+RcVA2IUtXEmAgF0tWsnQPrmA=;
        b=ShGrlc9JHhW/jz080f6hn2NZUsvPw9UH/9no3y8tkMBqLMnczdETmyvWclKsdrpLB5Q7LS
        EFUN+qM56EQjqnhpn5s8uA9Gi9DRNa3YRHe6MOtQrSrFdSKlRvj/jk13NjNPbxzuXhUGTT
        BAueSp3FYtX0KBRWAsWNT1swzzR1V3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-bmnkPDwdNMqDNPwqLDKhjg-1; Wed, 06 May 2020 02:38:28 -0400
X-MC-Unique: bmnkPDwdNMqDNPwqLDKhjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D49E7800687;
        Wed,  6 May 2020 06:38:25 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE54060C18;
        Wed,  6 May 2020 06:38:12 +0000 (UTC)
Subject: Re: [PATCH net-next 21/33] virtio_net: add XDP frame size in two code
 paths
From:   Jason Wang <jasowang@redhat.com>
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
 <158757174774.1370371.14395462229209766397.stgit@firesoul>
 <3958d9c6-a7d1-6a3d-941d-0a2915cc6b09@redhat.com>
 <20200427163224.6445d4bb@carbon>
 <d939445b-9713-2b2f-9830-38c2867bb963@redhat.com>
Message-ID: <a197ea65-eb78-23aa-eab3-406f95edc199@redhat.com>
Date:   Wed, 6 May 2020 14:38:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d939445b-9713-2b2f-9830-38c2867bb963@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/28 =E4=B8=8B=E5=8D=885:50, Jason Wang wrote:
>
> On 2020/4/27 =E4=B8=8B=E5=8D=8810:32, Jesper Dangaard Brouer wrote:
>> On Mon, 27 Apr 2020 15:21:02 +0800
>> Jason Wang<jasowang@redhat.com> wrote:
>>
>>> On 2020/4/23 =E4=B8=8A=E5=8D=8812:09, Jesper Dangaard Brouer wrote:
>>>> The virtio_net driver is running inside the guest-OS. There are two
>>>> XDP receive code-paths in virtio_net, namely receive_small() and
>>>> receive_mergeable(). The receive_big() function does not support XDP=
.
>>>>
>>>> In receive_small() the frame size is available in buflen. The buffer
>>>> backing these frames are allocated in add_recvbuf_small() with same
>>>> size, except for the headroom, but tailroom have reserved room for
>>>> skb_shared_info. The headroom is encoded in ctx pointer as a value.
>>>>
>>>> In receive_mergeable() the frame size is more dynamic. There are two
>>>> basic cases: (1) buffer size is based on a exponentially weighted
>>>> moving average (see DECLARE_EWMA) of packet length. Or (2) in case
>>>> virtnet_get_headroom() have any headroom then buffer size is
>>>> PAGE_SIZE. The ctx pointer is this time used for encoding two values=
;
>>>> the buffer len "truesize" and headroom. In case (1) if the rx buffer
>>>> size is underestimated, the packet will have been split over more
>>>> buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
>>>> buffer area). If that happens the XDP path does a xdp_linearize_page
>>>> operation.
>>>>
>>>> Cc: Jason Wang<jasowang@redhat.com>
>>>> Signed-off-by: Jesper Dangaard Brouer<brouer@redhat.com>
>>>> ---
>>>> =C2=A0=C2=A0 drivers/net/virtio_net.c |=C2=A0=C2=A0 15 ++++++++++++-=
--
>>>> =C2=A0=C2=A0 1 file changed, 12 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index 11f722460513..1df3676da185 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -689,6 +689,7 @@ static struct sk_buff *receive_small(struct=20
>>>> net_device *dev,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.dat=
a_end =3D xdp.data + len;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.dat=
a_meta =3D xdp.data;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.rxq=
 =3D &rq->xdp_rxq;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.frame_sz =3D buflen;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 orig_da=
ta =3D xdp.data;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 act =3D=
 bpf_prog_run_xdp(xdp_prog, &xdp);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stats->=
xdp_packets++;
>>>> @@ -797,10 +798,11 @@ static struct sk_buff=20
>>>> *receive_mergeable(struct net_device *dev,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int offset =3D buf - page_addre=
ss(page);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct sk_buff *head_skb, *curr=
_skb;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bpf_prog *xdp_prog;
>>>> -=C2=A0=C2=A0=C2=A0 unsigned int truesize;
>>>> +=C2=A0=C2=A0=C2=A0 unsigned int truesize =3D mergeable_ctx_to_trues=
ize(ctx);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int headroom =3D merge=
able_ctx_to_headroom(ctx);
>>>> -=C2=A0=C2=A0=C2=A0 int err;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int metasize =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0 unsigned int frame_sz;
>>>> +=C2=A0=C2=A0=C2=A0 int err;
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 head_skb =3D NULL;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stats->bytes +=3D len - vi->hdr=
_len;
>>>> @@ -821,6 +823,11 @@ static struct sk_buff=20
>>>> *receive_mergeable(struct net_device *dev,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unl=
ikely(hdr->hdr.gso_type))
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 goto err_xdp;
>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Buffers =
with headroom use PAGE_SIZE as alloc size,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * see add_recvbuf_=
mergeable() + get_mergeable_buf_len()
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 frame_sz =3D headroom ? =
PAGE_SIZE : truesize;
>>>> +
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* This=
 happens when rx buffer size is underestimated
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=
 or headroom is not enough because of the buffer
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=
 was refilled before XDP is set. This should only
>>>> @@ -834,6 +841,8 @@ static struct sk_buff *receive_mergeable(struct=20
>>>> net_device *dev,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page, offset,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VIRTIO_XDP_HEADROOM,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &len);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
frame_sz =3D PAGE_SIZE;
>>> Should this be PAGE_SIZE -=C2=A0 SKB_DATA_ALIGN(sizeof(struct=20
>>> skb_shared_info))?
>> No, frame_sz include the SKB_DATA_ALIGN(sizeof(struct=20
>> skb_shared_info)) length.
>
>
> Ok, consider mergeable buffer path depends on the truesize which is=20
> encoded in ctx.
>
> It looks to the the calculation in add_recvfbuf_mergeable() is wrong,=20
> we need count both headroom and tailroom there.
>
> We probably need the attached 2 patches to fix this.
>
> (untested, will test it tomorrow).


Sorry for the late reply. I gave a test and post the attached two=20
patches (with minor tweaks).

It looks to me they are required for this patch to work since=20
data_hard_start excludes vnet hdr len without the attached patches which=20
means PAGE_SIZE could not be used as frame_sz.

Thanks


>
> Thanks

