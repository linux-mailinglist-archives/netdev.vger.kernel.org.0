Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DD119C3E2
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbgDBOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:21:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36692 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732970AbgDBOVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585837283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rz5cHS4VTwbzrEglnf6iJdvfJeJuFYnGpHx5cg1Sn5I=;
        b=Htb189syPyrU31ufeNYiee091PNAALSL/LuzztWwxTVXW5vhoyF1Zb6fsmuxO+KRZxLQmZ
        gL1uDBdtNjtCycTeTPa09GGezgkkxLBMi0ZEtJnpCyw/mjG7C7Hw+MM9im+uSeo2pb3k+N
        FBqKyk0aumSjo/3FwHZX4VCYiKHFWbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-EBVCtGpVPMW_QfhaVWx5Tg-1; Thu, 02 Apr 2020 10:21:20 -0400
X-MC-Unique: EBVCtGpVPMW_QfhaVWx5Tg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1E6EA0CC2;
        Thu,  2 Apr 2020 14:21:18 +0000 (UTC)
Received: from [10.72.12.172] (ovpn-12-172.pek2.redhat.com [10.72.12.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFBA0391;
        Thu,  2 Apr 2020 14:21:13 +0000 (UTC)
Subject: Re: [PATCH v2] virtio/test: fix up after IOTLB changes
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200402125406.9275-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9e71c603-300a-e13f-dcef-bc4f9386ac0e@redhat.com>
Date:   Thu, 2 Apr 2020 22:21:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200402125406.9275-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/2 =E4=B8=8B=E5=8D=888:55, Michael S. Tsirkin wrote:
> Allow building vringh without IOTLB (that's the case for userspace
> builds, will be useful for CAIF/VOD down the road too).
> Update for API tweaks.
> Don't include vringh with userspace builds.
>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> changes from v1:
> 	use IS_REACHEABLE to fix error reported by build bot


Acked-by: Jason Wang <jasowang@redhat.com>



>
>   drivers/vhost/test.c              | 4 ++--
>   drivers/vhost/vringh.c            | 5 +++++
>   include/linux/vringh.h            | 6 ++++++
>   tools/virtio/Makefile             | 5 +++--
>   tools/virtio/generated/autoconf.h | 0
>   5 files changed, 16 insertions(+), 4 deletions(-)
>   create mode 100644 tools/virtio/generated/autoconf.h
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
> index ee0491f579ac..ba8e0d6cfd97 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -13,9 +13,11 @@
>   #include <linux/uaccess.h>
>   #include <linux/slab.h>
>   #include <linux/export.h>
> +#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
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
> +#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
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
> index bd0503ca6f8f..9e2763d7c159 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -14,8 +14,10 @@
>   #include <linux/virtio_byteorder.h>
>   #include <linux/uio.h>
>   #include <linux/slab.h>
> +#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
>   #include <linux/dma-direction.h>
>   #include <linux/vhost_iotlb.h>
> +#endif
>   #include <asm/barrier.h>
>  =20
>   /* virtio_ring with information needed for host access. */
> @@ -254,6 +256,8 @@ static inline __virtio64 cpu_to_vringh64(const stru=
ct vringh *vrh, u64 val)
>   	return __cpu_to_virtio64(vringh_is_little_endian(vrh), val);
>   }
>  =20
> +#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
> +
>   void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb);
>  =20
>   int vringh_init_iotlb(struct vringh *vrh, u64 features,
> @@ -284,4 +288,6 @@ void vringh_notify_disable_iotlb(struct vringh *vrh=
);
>  =20
>   int vringh_need_notify_iotlb(struct vringh *vrh);
>  =20
> +#endif /* CONFIG_VHOST_IOTLB */
> +
>   #endif /* _LINUX_VRINGH_H */
> diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
> index f33f32f1d208..b587b9a7a124 100644
> --- a/tools/virtio/Makefile
> +++ b/tools/virtio/Makefile
> @@ -4,7 +4,7 @@ test: virtio_test vringh_test
>   virtio_test: virtio_ring.o virtio_test.o
>   vringh_test: vringh_test.o vringh.o virtio_ring.o
>  =20
> -CFLAGS +=3D -g -O2 -Werror -Wall -I. -I../include/ -I ../../usr/includ=
e/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-commo=
n -MMD -U_FORTIFY_SOURCE
> +CFLAGS +=3D -g -O2 -Werror -Wall -I. -I../include/ -I ../../usr/includ=
e/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-commo=
n -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
>   vpath %.c ../../drivers/virtio ../../drivers/vhost
>   mod:
>   	${MAKE} -C `pwd`/../.. M=3D`pwd`/vhost_test V=3D${V}
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
> diff --git a/tools/virtio/generated/autoconf.h b/tools/virtio/generated=
/autoconf.h
> new file mode 100644
> index 000000000000..e69de29bb2d1

