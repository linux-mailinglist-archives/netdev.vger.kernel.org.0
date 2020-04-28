Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C531BBA56
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgD1Juw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:50:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37073 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727030AbgD1Juw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588067449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YY4Z8KJY6fpWDZW10XJGSz5MVM61kpLdGFusTxx053A=;
        b=XqlwSatoAD+YLobkKSpncOy2fvqIIp4Goq1r9njOQErufw9peY8qZoNUBoxi0x/c1u2Zzk
        Zj4CqUiAe+M2HrI1uA9PYB5qmG8qcZy8d8D1/utkbKNv+9wlhvymLW2Rozg+PN/LAM2h5N
        ooySmMwuFYWsNkw6vgjtOgULNVr/rgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354--cCEzIpbNdW3CH1G655WWA-1; Tue, 28 Apr 2020 05:50:45 -0400
X-MC-Unique: -cCEzIpbNdW3CH1G655WWA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DB9F1005510;
        Tue, 28 Apr 2020 09:50:43 +0000 (UTC)
Received: from [10.72.13.37] (ovpn-13-37.pek2.redhat.com [10.72.13.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E5745D9E2;
        Tue, 28 Apr 2020 09:50:29 +0000 (UTC)
Subject: Re: [PATCH net-next 21/33] virtio_net: add XDP frame size in two code
 paths
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d939445b-9713-2b2f-9830-38c2867bb963@redhat.com>
Date:   Tue, 28 Apr 2020 17:50:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427163224.6445d4bb@carbon>
Content-Type: multipart/mixed;
 boundary="------------8EF42C08D3649D0A144D3F9E"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------8EF42C08D3649D0A144D3F9E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 2020/4/27 =E4=B8=8B=E5=8D=8810:32, Jesper Dangaard Brouer wrote:
> On Mon, 27 Apr 2020 15:21:02 +0800
> Jason Wang<jasowang@redhat.com>  wrote:
>
>> On 2020/4/23 =E4=B8=8A=E5=8D=8812:09, Jesper Dangaard Brouer wrote:
>>> The virtio_net driver is running inside the guest-OS. There are two
>>> XDP receive code-paths in virtio_net, namely receive_small() and
>>> receive_mergeable(). The receive_big() function does not support XDP.
>>>
>>> In receive_small() the frame size is available in buflen. The buffer
>>> backing these frames are allocated in add_recvbuf_small() with same
>>> size, except for the headroom, but tailroom have reserved room for
>>> skb_shared_info. The headroom is encoded in ctx pointer as a value.
>>>
>>> In receive_mergeable() the frame size is more dynamic. There are two
>>> basic cases: (1) buffer size is based on a exponentially weighted
>>> moving average (see DECLARE_EWMA) of packet length. Or (2) in case
>>> virtnet_get_headroom() have any headroom then buffer size is
>>> PAGE_SIZE. The ctx pointer is this time used for encoding two values;
>>> the buffer len "truesize" and headroom. In case (1) if the rx buffer
>>> size is underestimated, the packet will have been split over more
>>> buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
>>> buffer area). If that happens the XDP path does a xdp_linearize_page
>>> operation.
>>>
>>> Cc: Jason Wang<jasowang@redhat.com>
>>> Signed-off-by: Jesper Dangaard Brouer<brouer@redhat.com>
>>> ---
>>>    drivers/net/virtio_net.c |   15 ++++++++++++---
>>>    1 file changed, 12 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 11f722460513..1df3676da185 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -689,6 +689,7 @@ static struct sk_buff *receive_small(struct net_d=
evice *dev,
>>>    		xdp.data_end =3D xdp.data + len;
>>>    		xdp.data_meta =3D xdp.data;
>>>    		xdp.rxq =3D &rq->xdp_rxq;
>>> +		xdp.frame_sz =3D buflen;
>>>    		orig_data =3D xdp.data;
>>>    		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
>>>    		stats->xdp_packets++;
>>> @@ -797,10 +798,11 @@ static struct sk_buff *receive_mergeable(struct=
 net_device *dev,
>>>    	int offset =3D buf - page_address(page);
>>>    	struct sk_buff *head_skb, *curr_skb;
>>>    	struct bpf_prog *xdp_prog;
>>> -	unsigned int truesize;
>>> +	unsigned int truesize =3D mergeable_ctx_to_truesize(ctx);
>>>    	unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
>>> -	int err;
>>>    	unsigned int metasize =3D 0;
>>> +	unsigned int frame_sz;
>>> +	int err;
>>>   =20
>>>    	head_skb =3D NULL;
>>>    	stats->bytes +=3D len - vi->hdr_len;
>>> @@ -821,6 +823,11 @@ static struct sk_buff *receive_mergeable(struct =
net_device *dev,
>>>    		if (unlikely(hdr->hdr.gso_type))
>>>    			goto err_xdp;
>>>   =20
>>> +		/* Buffers with headroom use PAGE_SIZE as alloc size,
>>> +		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
>>> +		 */
>>> +		frame_sz =3D headroom ? PAGE_SIZE : truesize;
>>> +
>>>    		/* This happens when rx buffer size is underestimated
>>>    		 * or headroom is not enough because of the buffer
>>>    		 * was refilled before XDP is set. This should only
>>> @@ -834,6 +841,8 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>>>    						      page, offset,
>>>    						      VIRTIO_XDP_HEADROOM,
>>>    						      &len);
>>> +			frame_sz =3D PAGE_SIZE;
>> Should this be PAGE_SIZE -=C2=A0 SKB_DATA_ALIGN(sizeof(struct skb_shar=
ed_info))?
> No, frame_sz include the SKB_DATA_ALIGN(sizeof(struct skb_shared_info))=
 length.


Ok, consider mergeable buffer path depends on the truesize which is=20
encoded in ctx.

It looks to the the calculation in add_recvfbuf_mergeable() is wrong, we=20
need count both headroom and tailroom there.

We probably need the attached 2 patches to fix this.

(untested, will test it tomorrow).

Thanks



--------------8EF42C08D3649D0A144D3F9E
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-virtio-net-fix-the-XDP-truesize-calculation-for-merg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-virtio-net-fix-the-XDP-truesize-calculation-for-merg.pa";
 filename*1="tch"

From c2778eb8ee4b7558bccb53f2fc7f1b0aaf1fcb58 Mon Sep 17 00:00:00 2001
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 28 Apr 2020 11:37:39 +0800
Subject: [PATCH 2/2] virtio-net: fix the XDP truesize calculation for
 mergeable buffers

We should not exclude headroom and tailroom when XDP is set. So this
patch fixes this by initializing the truesize from PAGE_SIZE when XDP
is set.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9bdaf2425e6e..f9ba5275e447 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1172,7 +1172,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	char *buf;
 	void *ctx;
 	int err;
-	unsigned int len, hole;
+	unsigned int len, hole, truesize;
 
 	/* Extra tailroom is needed to satisfy XDP's assumption. This
 	 * means rx frags coalescing won't work, but consider we've
@@ -1182,6 +1182,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
 		return -ENOMEM;
 
+	truesize = headroom ? PAGE_SIZE: len;
 	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
 	buf += headroom; /* advance address leaving hole at front of pkt */
 	get_page(alloc_frag->page);
@@ -1193,11 +1194,12 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 		 * the current buffer.
 		 */
 		len += hole;
+		truesize += hole;
 		alloc_frag->offset += hole;
 	}
 
 	sg_init_one(rq->sg, buf, len);
-	ctx = mergeable_len_to_ctx(len, headroom);
+	ctx = mergeable_len_to_ctx(truesize, headroom);
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0)
 		put_page(virt_to_head_page(buf));
-- 
2.20.1


--------------8EF42C08D3649D0A144D3F9E
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-virtio-net-don-t-reserve-space-for-vnet-header-for-X.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-virtio-net-don-t-reserve-space-for-vnet-header-for-X.pa";
 filename*1="tch"

From 307ac87e823fde059be3bb5a7bdd3ffd3b18521d Mon Sep 17 00:00:00 2001
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 28 Apr 2020 11:31:47 +0800
Subject: [PATCH 1/2] virtio-net: don't reserve space for vnet header for XDP

We tried to reserve space for vnet header before
xdp.data_hard_start. But this is useless since the packet could be
modified by XDP which may invalidate the information stored in the
header and there's no way for XDP to know the existence of the vnet
header currently.

So let's just not reserve space for vnet header in this case.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2fe7a3188282..9bdaf2425e6e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -681,8 +681,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			page = xdp_page;
 		}
 
-		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
-		xdp.data = xdp.data_hard_start + xdp_headroom;
+		xdp.data_hard_start = buf + VIRTNET_RX_PAD;
+		xdp.data = xdp.data_hard_start + xdp_headroom + vi->hdr_len;;
 		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
 		xdp.rxq = &rq->xdp_rxq;
@@ -837,7 +837,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		 * the descriptor on if we get an XDP_TX return code.
 		 */
 		data = page_address(xdp_page) + offset;
-		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
+		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM;
 		xdp.data = data + vi->hdr_len;
 		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
-- 
2.20.1


--------------8EF42C08D3649D0A144D3F9E--

