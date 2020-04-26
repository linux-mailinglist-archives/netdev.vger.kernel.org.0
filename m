Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90291B8E6E
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgDZJlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:41:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35654 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726122AbgDZJlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 05:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587894103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17hksfwyCJTCUBDrT+a24OdYKmf01qS7RQ93GGRGAUE=;
        b=PToRscjWQJwCY48ie2AOYq6oyMhJuEAul9yfLTgJvUg4g38By8NGp+RpMcwPs/sErqUGmj
        wW4+B6/R3GI4kF9ALYx199bhOHDKdnNO1HRVWybe3BdvSigP7wgmmgzXJjSqJERMBphfjl
        wNUVoGWvdsuXPwBTAYtyl/ASOHoo19o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-VjE_cIJVNDiMv8qyKlDPCA-1; Sun, 26 Apr 2020 05:41:40 -0400
X-MC-Unique: VjE_cIJVNDiMv8qyKlDPCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F23F8014D9;
        Sun, 26 Apr 2020 09:41:38 +0000 (UTC)
Received: from [10.72.13.147] (ovpn-13-147.pek2.redhat.com [10.72.13.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65E0360612;
        Sun, 26 Apr 2020 09:41:32 +0000 (UTC)
Subject: Re: [PATCH V3 1/2] vdpa: Support config interrupt in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1587890572-39093-1-git-send-email-lingshan.zhu@intel.com>
 <1587890572-39093-2-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ec8b274c-657f-38b0-2b7d-77ab735969c3@redhat.com>
Date:   Sun, 26 Apr 2020 17:41:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587890572-39093-2-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/26 =E4=B8=8B=E5=8D=884:42, Zhu Lingshan wrote:
> This commit implements config interrupt support in
> vhost_vdpa layer.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vhost/vdpa.c       | 47 +++++++++++++++++++++++++++++++++++++=
+++++++++
>   drivers/vhost/vhost.c      |  2 +-
>   include/uapi/linux/vhost.h |  4 ++++
>   3 files changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 421f02a..c370ec5 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -21,6 +21,7 @@
>   #include <linux/nospec.h>
>   #include <linux/vhost.h>
>   #include <linux/virtio_net.h>
> +#include <linux/kernel.h>
>  =20
>   #include "vhost.h"
>  =20
> @@ -70,6 +71,7 @@ struct vhost_vdpa {
>   	int nvqs;
>   	int virtio_id;
>   	int minor;
> +	struct eventfd_ctx *config_ctx;
>   };
>  =20
>   static DEFINE_IDA(vhost_vdpa_ida);
> @@ -101,6 +103,17 @@ static irqreturn_t vhost_vdpa_virtqueue_cb(void *p=
rivate)
>   	return IRQ_HANDLED;
>   }
>  =20
> +static irqreturn_t vhost_vdpa_config_cb(void *private)
> +{
> +	struct vhost_vdpa *v =3D private;
> +	struct eventfd_ctx *config_ctx =3D v->config_ctx;
> +
> +	if (config_ctx)
> +		eventfd_signal(config_ctx, 1);
> +
> +	return IRQ_HANDLED;
> +}
> +
>   static void vhost_vdpa_reset(struct vhost_vdpa *v)
>   {
>   	struct vdpa_device *vdpa =3D v->vdpa;
> @@ -288,6 +301,36 @@ static long vhost_vdpa_get_vring_num(struct vhost_=
vdpa *v, u16 __user *argp)
>   	return 0;
>   }
>  =20
> +static void vhost_vdpa_config_put(struct vhost_vdpa *v)
> +{
> +	if (v->config_ctx)
> +		eventfd_ctx_put(v->config_ctx);
> +}
> +
> +static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __use=
r *argp)
> +{
> +	struct vdpa_callback cb;
> +	int fd;
> +	struct eventfd_ctx *ctx;
> +
> +	cb.callback =3D vhost_vdpa_config_cb;
> +	cb.private =3D v->vdpa;
> +	if (copy_from_user(&fd, argp, sizeof(fd)))
> +		return  -EFAULT;
> +
> +	ctx =3D fd =3D=3D VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(fd);
> +	swap(ctx, v->config_ctx);
> +
> +	if (!IS_ERR_OR_NULL(ctx))
> +		eventfd_ctx_put(ctx);
> +
> +	if (IS_ERR(v->config_ctx))
> +		return PTR_ERR(v->config_ctx);
> +
> +	v->vdpa->config->set_config_cb(v->vdpa, &cb);
> +
> +	return 0;
> +}
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int=
 cmd,
>   				   void __user *argp)
>   {
> @@ -398,6 +441,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
>   	case VHOST_SET_LOG_FD:
>   		r =3D -ENOIOCTLCMD;
>   		break;
> +	case VHOST_VDPA_SET_CONFIG_CALL:
> +		r =3D vhost_vdpa_set_config_call(v, argp);
> +		break;
>   	default:
>   		r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
>   		if (r =3D=3D -ENOIOCTLCMD)
> @@ -734,6 +780,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>   	vhost_dev_stop(&v->vdev);
>   	vhost_vdpa_iotlb_free(v);
>   	vhost_vdpa_free_domain(v);
> +	vhost_vdpa_config_put(v);
>   	vhost_dev_cleanup(&v->vdev);
>   	kfree(v->vdev.vqs);
>   	mutex_unlock(&d->mutex);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d450e16..e8f5b20 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1590,7 +1590,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsig=
ned int ioctl, void __user *arg
>   			r =3D -EFAULT;
>   			break;
>   		}
> -		ctx =3D f.fd =3D=3D -1 ? NULL : eventfd_ctx_fdget(f.fd);
> +		ctx =3D f.fd =3D=3D VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(f.f=
d);
>   		if (IS_ERR(ctx)) {
>   			r =3D PTR_ERR(ctx);
>   			break;
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 9fe72e4..0c23496 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -15,6 +15,8 @@
>   #include <linux/types.h>
>   #include <linux/ioctl.h>
>  =20
> +#define VHOST_FILE_UNBIND -1


I think we need a separate patch for introducing this since we touches=20
vhost.c

Thanks


> +
>   /* ioctls */
>  =20
>   #define VHOST_VIRTIO 0xAF
> @@ -140,4 +142,6 @@
>   /* Get the max ring size. */
>   #define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
>  =20
> +/* Set event fd for config interrupt*/
> +#define VHOST_VDPA_SET_CONFIG_CALL	_IOW(VHOST_VIRTIO, 0x77, int)
>   #endif

