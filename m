Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807831B96CE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 07:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgD0Fvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 01:51:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38201 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726273AbgD0Fvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 01:51:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587966706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HA5YF2XFDeMYbmR1kwdZIk4isuEvjkDHtzFXH9NPg1s=;
        b=A29wO4tdPNsVVCmu5hmsMmZ5VBn/N5Cap5fGsJ6a6dQtGJZMSyTHpLoiNyLV8M/2sVYHma
        rFXA4iOWeFKuG5zHm+p5QLRKUT2TrpHIefLSrkTu4DN7sguRLqig93Geftbx5kVjhZycmP
        Rl/8p6JZLqj4IJWnII7QO/OgzD3eit0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-qOMalXLQNWuu-0EaHv4CfA-1; Mon, 27 Apr 2020 01:51:41 -0400
X-MC-Unique: qOMalXLQNWuu-0EaHv4CfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8521F1899520;
        Mon, 27 Apr 2020 05:51:39 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC85760CD3;
        Mon, 27 Apr 2020 05:51:27 +0000 (UTC)
Subject: Re: [PATCH net-next 19/33] tun: add XDP frame size
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
 <158757173758.1370371.17195673814740376146.stgit@firesoul>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2790cb0a-d952-447f-8378-9e4c1ad49fa6@redhat.com>
Date:   Mon, 27 Apr 2020 13:51:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158757173758.1370371.17195673814740376146.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/23 =E4=B8=8A=E5=8D=8812:08, Jesper Dangaard Brouer wrote:
> The tun driver have two code paths for running XDP (bpf_prog_run_xdp).
> In both cases 'buflen' contains enough tailroom for skb_shared_info.
>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/tun.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 44889eba1dbc..c54f967e2c66 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1671,6 +1671,7 @@ static struct sk_buff *tun_build_skb(struct tun_s=
truct *tun,
>   		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end =3D xdp.data + len;
>   		xdp.rxq =3D &tfile->xdp_rxq;
> +		xdp.frame_sz =3D buflen;
>  =20
>   		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
>   		if (act =3D=3D XDP_REDIRECT || act =3D=3D XDP_TX) {
> @@ -2411,6 +2412,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>   		}
>   		xdp_set_data_meta_invalid(xdp);
>   		xdp->rxq =3D &tfile->xdp_rxq;
> +		xdp->frame_sz =3D buflen;
>  =20
>   		act =3D bpf_prog_run_xdp(xdp_prog, xdp);
>   		err =3D tun_xdp_act(tun, xdp_prog, xdp, act);
>
>

