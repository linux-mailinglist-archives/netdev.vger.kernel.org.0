Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FA01B96CB
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 07:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgD0Fug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 01:50:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38974 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbgD0Fuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 01:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587966634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGWcBqLfmDI6LvNAc0dnF3uc/R3HdjACKdZKz3JJGhI=;
        b=WgduSMvvuCc5pUvzbkLvzhQLXFu8w+73a5Sf4zd3mz8OYRS8Jf/mRRH2XhAarNjO8ADhDf
        2coy/b6OG9lo6uViOoqihmRl06biOMpFx2wutUXeNmOJlJ88BvENfcorZMUAbkOyssHvFk
        BfPulu7UlA7rVM/HzOvNYu5nPzn/K0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-TS4_BGqzOe-4bOVr1BpJBg-1; Mon, 27 Apr 2020 01:50:32 -0400
X-MC-Unique: TS4_BGqzOe-4bOVr1BpJBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F6E9872FE1;
        Mon, 27 Apr 2020 05:50:29 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D216360CD3;
        Mon, 27 Apr 2020 05:50:17 +0000 (UTC)
Subject: Re: [PATCH net-next 20/33] vhost_net: also populate XDP frame size
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
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757174266.1370371.14475202001364271065.stgit@firesoul>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8ebbd5d8-e256-3d6b-7cc1-dd3d29be3504@redhat.com>
Date:   Mon, 27 Apr 2020 13:50:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158757174266.1370371.14475202001364271065.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/23 =E4=B8=8A=E5=8D=8812:09, Jesper Dangaard Brouer wrote:
> In vhost_net_build_xdp() the 'buf' that gets queued via an xdp_buff
> have embedded a struct tun_xdp_hdr (located at xdp->data_hard_start)
> which contains the buffer length 'buflen' (with tailroom for
> skb_shared_info). Also storing this buflen in xdp->frame_sz, does not
> obsolete struct tun_xdp_hdr, as it also contains a struct
> virtio_net_hdr with other information.
>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/vhost/net.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 87469d67ede8..69af007e22f4 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -745,6 +745,7 @@ static int vhost_net_build_xdp(struct vhost_net_vir=
tqueue *nvq,
>   	xdp->data =3D buf + pad;
>   	xdp->data_end =3D xdp->data + len;
>   	hdr->buflen =3D buflen;
> +	xdp->frame_sz =3D buflen;
>  =20
>   	--net->refcnt_bias;
>   	alloc_frag->offset +=3D buflen;


Tun_xdp_one() will use hdr->buflen as the frame_sz (patch 19), so it=20
looks to me there's no need to do this?

Thanks


>
>

