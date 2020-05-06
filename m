Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312881C6924
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgEFGlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:41:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727938AbgEFGlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:41:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588747275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0d+csVvMqYzG+ZaCpxRg5ikMUnSpEUdjcysHHLVaDqo=;
        b=Wqnq7GIPexDjwCuy6oCT06Y61IWPaftI3Y4sJJyAhvVu6fDgD36a87qyWMdJ5bTKQjRo7V
        nB0votyD94YNkiU7fU1PAx1c2CiIZIfCnnXeBaZE8agm7CG3LN4VoLLKJ6QR6fdhCxXAuh
        HLKwFWhlNESTyQnRgzXxTxSlfb55Jo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-G45MKYr0OJCQCBmFEVUHeA-1; Wed, 06 May 2020 02:41:14 -0400
X-MC-Unique: G45MKYr0OJCQCBmFEVUHeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B7E780058A;
        Wed,  6 May 2020 06:41:12 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72E1460BEC;
        Wed,  6 May 2020 06:41:06 +0000 (UTC)
Subject: Re: [PATCH net-next v2 20/33] vhost_net: also populate XDP frame size
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0a875a6e-8b8d-b55f-2b50-1c8dc0017a92@redhat.com>
Date:   Wed, 6 May 2020 14:41:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158824572308.2172139.1144470511173466125.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/30 =E4=B8=8B=E5=8D=887:22, Jesper Dangaard Brouer wrote:
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
> index 2927f02cc7e1..516519dcc8ff 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -747,6 +747,7 @@ static int vhost_net_build_xdp(struct vhost_net_vir=
tqueue *nvq,
>   	xdp->data =3D buf + pad;
>   	xdp->data_end =3D xdp->data + len;
>   	hdr->buflen =3D buflen;
> +	xdp->frame_sz =3D buflen;
>  =20
>   	--net->refcnt_bias;
>   	alloc_frag->offset +=3D buflen;


Hi Jesper:

As I said in v1, tun will do this for us (patch 19) via hdr->buflen. So=20
it looks to me this is not necessary?

Thanks

>
>

