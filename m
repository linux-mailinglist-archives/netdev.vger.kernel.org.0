Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7E130C35
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 03:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgAFCrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 21:47:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727307AbgAFCrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 21:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578278865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jHs+ncyMkPMxI5AsiGIl7F6vLxr1/FM/W1+8uxJ60Q=;
        b=WcWYaDDMlnh9NrAmPeU54hcPN73b8v3UrUFYwIcA3YiuPXxd+1KEDJBdL8YeKcOxljmJKQ
        QhH8k5X4cXAK4riUJVfo73iQn83mIaDB8YrkjhldUKavPFvnqU+HP5T6HdDn5+2zdhUyBf
        0R3VJmAkbEJ5GGg7dtpd/+ZTMNeE0HA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-bEdDg_oCPxqNF6G2z-hkxg-1; Sun, 05 Jan 2020 21:47:44 -0500
X-MC-Unique: bEdDg_oCPxqNF6G2z-hkxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA9DB10054E3;
        Mon,  6 Jan 2020 02:47:42 +0000 (UTC)
Received: from [10.72.12.147] (ovpn-12-147.pek2.redhat.com [10.72.12.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73D9328981;
        Mon,  6 Jan 2020 02:47:37 +0000 (UTC)
Subject: Re: [PATCH v2] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Alistair Delva <adelva@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200105132120.92370-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2d7053b5-295c-4051-a722-7656350bdb74@redhat.com>
Date:   Mon, 6 Jan 2020 10:47:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200105132120.92370-1-mst@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/5 =E4=B8=8B=E5=8D=889:22, Michael S. Tsirkin wrote:
> The only way for guest to control offloads (as enabled by
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) is by sending commands
> through CTRL_VQ. So it does not make sense to
> acknowledge VIRTIO_NET_F_CTRL_GUEST_OFFLOADS without
> VIRTIO_NET_F_CTRL_VQ.
>
> The spec does not outlaw devices with such a configuration, so we have
> to support it. Simply clear VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> Note that Linux is still crashing if it tries to
> change the offloads when there's no control vq.
> That needs to be fixed by another patch.
>
> Reported-by: Alistair Delva <adelva@google.com>
> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if poss=
ible on XDP set")
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Same patch as v1 but update documentation so it's clear it's not
> enough to fix the crash.
>
>   drivers/net/virtio_net.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..7b8805b47f0d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2971,6 +2971,15 @@ static int virtnet_validate(struct virtio_device=
 *vdev)
>   	if (!virtnet_validate_features(vdev))
>   		return -EINVAL;
>  =20
> +	/* VIRTIO_NET_F_CTRL_GUEST_OFFLOADS does not work without
> +	 * VIRTIO_NET_F_CTRL_VQ. Unfortunately spec forgot to
> +	 * specify that VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends
> +	 * on VIRTIO_NET_F_CTRL_VQ so devices can set the later but
> +	 * not the former.
> +	 */
> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> +			__virtio_clear_bit(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);


If it's just because a bug of spec, should we simply fix the bug and=20
fail the negotiation in virtnet_validate_feature()?

Otherwise there would be inconsistency in handling feature dependencies=20
for ctrl vq.

Thanks


> +
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
>   		int mtu =3D virtio_cread16(vdev,
>   					 offsetof(struct virtio_net_config,

