Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F403F1B8D18
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 08:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgDZG7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 02:59:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725864AbgDZG7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 02:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587884338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nzpyfv1Z6VEBidKjguuGbAmxFY96l0LyJXnhGt0vsLM=;
        b=bkrY++XlhKnOfQLgDBekNggdb1zb5Bieg373QMOU0/O6m931tN/y4i/Yn+oGP6lNK0aEfY
        nzFJYojJkX0S9kiP/ALZNJQCUUtoFSaUP6LEt+lUf50++D2SwyiUO7mmYJLwqXcwyB4885
        kUD2WvG1FgDDKeKbSKwzlEFWgH8LdDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-aJ0xuxzYOcqNo5y_I5t1WQ-1; Sun, 26 Apr 2020 02:58:53 -0400
X-MC-Unique: aJ0xuxzYOcqNo5y_I5t1WQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89CE91005510;
        Sun, 26 Apr 2020 06:58:51 +0000 (UTC)
Received: from [10.72.13.103] (ovpn-13-103.pek2.redhat.com [10.72.13.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 506925D9CD;
        Sun, 26 Apr 2020 06:58:44 +0000 (UTC)
Subject: Re: [PATCH V2 1/2] vdpa: Support config interrupt in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1587881384-2133-1-git-send-email-lingshan.zhu@intel.com>
 <1587881384-2133-2-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <055fb826-895d-881b-719c-228d0cc9a7bf@redhat.com>
Date:   Sun, 26 Apr 2020 14:58:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587881384-2133-2-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/26 =E4=B8=8B=E5=8D=882:09, Zhu Lingshan wrote:
> This commit implements config interrupt support in
> vhost_vdpa layer.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vhost/vdpa.c       | 47 +++++++++++++++++++++++++++++++++++++=
+++++++++
>   drivers/vhost/vhost.c      |  2 +-
>   drivers/vhost/vhost.h      |  2 ++
>   include/uapi/linux/vhost.h |  2 ++
>   4 files changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 421f02a..b94e349 100644
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
> +	u32 fd;
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
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 1813821..8663139 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -18,6 +18,8 @@
>   typedef void (*vhost_work_fn_t)(struct vhost_work *work);
>  =20
>   #define VHOST_WORK_QUEUED 1
> +#define VHOST_FILE_UNBIND -1


I think it's better to document this in uapi.


> +
>   struct vhost_work {
>   	struct llist_node	  node;
>   	vhost_work_fn_t		  fn;
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 9fe72e4..345acb3 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -140,4 +140,6 @@
>   /* Get the max ring size. */
>   #define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
>  =20
> +/* Set event fd for config interrupt*/
> +#define VHOST_VDPA_SET_CONFIG_CALL	_IOW(VHOST_VIRTIO, 0x77, u32)
>   #endif


Should be "int" instead of "u32".

Thanks

