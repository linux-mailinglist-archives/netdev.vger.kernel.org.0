Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1095D19BAD4
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 06:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgDBECJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 00:02:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725890AbgDBECJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 00:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585800128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+zSv1WA+rPbGSzOupPYuZO2qP78Tb9ejg8WqBI3qnMo=;
        b=Zq/0G99Y+8TMIbhsq98MXKsY1qWepSwQLR5HWmM0bSh8l/zgRj0iQGKUowIMZCO/3UOZlo
        Yc1KmA/topYXYN0gXahWa/3Ya7xbQJMwAbVCmkMu+Os7rroXxvy/mj7OrynB/T48b2W2jv
        uqB68aicSGrxSa/48yLtaBZDUZhIZEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-LUxoOoOCPzGXTIuUcfvDzQ-1; Thu, 02 Apr 2020 00:02:04 -0400
X-MC-Unique: LUxoOoOCPzGXTIuUcfvDzQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2816E107ACC4;
        Thu,  2 Apr 2020 04:02:03 +0000 (UTC)
Received: from [10.72.13.209] (ovpn-13-209.pek2.redhat.com [10.72.13.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F012719C69;
        Thu,  2 Apr 2020 04:01:57 +0000 (UTC)
Subject: Re: [PATCH] virtio/test: fix up after IOTLB changes
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200401165100.276039-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <921fe999-e183-058d-722a-1a6a6ab066e0@redhat.com>
Date:   Thu, 2 Apr 2020 12:01:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200401165100.276039-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/2 =E4=B8=8A=E5=8D=8812:51, Michael S. Tsirkin wrote:
> Allow building vringh without IOTLB (that's the case for userspace
> builds, will be useful for CAIF/VOD down the road too).
> Update for API tweaks.
> Don't include vringh with kernel builds.


I'm not quite sure we need this.

E.g the userspace accessor is not used by CAIF/VOP.


>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/test.c   | 4 ++--
>   drivers/vhost/vringh.c | 5 +++++
>   include/linux/vringh.h | 2 ++
>   tools/virtio/Makefile  | 3 ++-
>   4 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 394e2e5c772d..9a3a09005e03 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -120,7 +120,7 @@ static int vhost_test_open(struct inode *inode, str=
uct file *f)
>   	vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
>   	n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
>   	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> -		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
> +		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
>  =20
>   	f->private_data =3D n;
>  =20
> @@ -225,7 +225,7 @@ static long vhost_test_reset_owner(struct vhost_tes=
t *n)
>   {
>   	void *priv =3D NULL;
>   	long err;
> -	struct vhost_umem *umem;
> +	struct vhost_iotlb *umem;
>  =20
>   	mutex_lock(&n->dev.mutex);
>   	err =3D vhost_dev_check_owner(&n->dev);
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index ee0491f579ac..878e565dfffe 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -13,9 +13,11 @@
>   #include <linux/uaccess.h>
>   #include <linux/slab.h>
>   #include <linux/export.h>
> +#ifdef VHOST_IOTLB


Kbuild bot reports build issues with this.

It looks to me we should use #if IS_ENABLED(CONFIG_VHOST_IOTLB) here and=20
following checks.

Thanks


>   #include <linux/bvec.h>
>   #include <linux/highmem.h>
>   #include <linux/vhost_iotlb.h>
> +#endif
>   #include <uapi/linux/virtio_config.h>
>  =20
>   static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
> @@ -1059,6 +1061,8 @@ int vringh_need_notify_kern(struct vringh *vrh)
>   }
>   EXPORT_SYMBOL(vringh_need_notify_kern);
>  =20
> +#ifdef VHOST_IOTLB
> +
>   static int iotlb_translate(const struct vringh *vrh,
>   			   u64 addr, u64 len, struct bio_vec iov[],
>   			   int iov_size, u32 perm)
> @@ -1416,5 +1420,6 @@ int vringh_need_notify_iotlb(struct vringh *vrh)
>   }
>   EXPORT_SYMBOL(vringh_need_notify_iotlb);
>  =20
> +#endif
>  =20
>   MODULE_LICENSE("GPL");
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index bd0503ca6f8f..ebff121c0b02 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -14,8 +14,10 @@
>   #include <linux/virtio_byteorder.h>
>   #include <linux/uio.h>
>   #include <linux/slab.h>
> +#ifdef VHOST_IOTLB
>   #include <linux/dma-direction.h>
>   #include <linux/vhost_iotlb.h>
> +#endif
>   #include <asm/barrier.h>
>  =20
>   /* virtio_ring with information needed for host access. */
> diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
> index f33f32f1d208..d3f152f4660b 100644
> --- a/tools/virtio/Makefile
> +++ b/tools/virtio/Makefile
> @@ -22,7 +22,8 @@ OOT_CONFIGS=3D\
>   	CONFIG_VHOST=3Dm \
>   	CONFIG_VHOST_NET=3Dn \
>   	CONFIG_VHOST_SCSI=3Dn \
> -	CONFIG_VHOST_VSOCK=3Dn
> +	CONFIG_VHOST_VSOCK=3Dn \
> +	CONFIG_VHOST_RING=3Dn
>   OOT_BUILD=3DKCFLAGS=3D"-I "${OOT_VHOST} ${MAKE} -C ${OOT_KSRC} V=3D${=
V}
>   oot-build:
>   	echo "UNSUPPORTED! Don't use the resulting modules in production!"

