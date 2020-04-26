Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952C11B8B95
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgDZDHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:07:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24572 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726110AbgDZDHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587870435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1MicnzhZx2u3w8NPjiKXXdCFazde/j1mUrPvZOE1Hk=;
        b=b/dEGlsOxK6jgFJcfu/M7CunUrpqMTaMchq9Fe4OBTFmg38JKxY1OrulLoJvu3Iovn0zpo
        4SUyEWao2rFEkQivK4wBEPBi+WKOfaFwPLGvZCfU5RSsd3PLk0YAFifUETGSOGH4Z+J3xa
        OkZ9Zmpdu7/LlVckX6ILSs3DDk/W1eE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-wWW3QRZlNf-4qS8M6O2DLQ-1; Sat, 25 Apr 2020 23:07:13 -0400
X-MC-Unique: wWW3QRZlNf-4qS8M6O2DLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6812F800D24;
        Sun, 26 Apr 2020 03:07:11 +0000 (UTC)
Received: from [10.72.13.103] (ovpn-13-103.pek2.redhat.com [10.72.13.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F5B75D9CC;
        Sun, 26 Apr 2020 03:07:05 +0000 (UTC)
Subject: Re: [PATCH 1/2] vdpa: Support config interrupt in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1587722659-1300-1-git-send-email-lingshan.zhu@intel.com>
 <1587722659-1300-2-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cb656c27-22a8-3a18-9e3a-68fa0c3ff06b@redhat.com>
Date:   Sun, 26 Apr 2020 11:07:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587722659-1300-2-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/24 =E4=B8=8B=E5=8D=886:04, Zhu Lingshan wrote:
> This commit implements config interrupt support in
> vhost_vdpa layer.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


One should be sufficient.


> ---
>   drivers/vhost/vdpa.c             | 53 +++++++++++++++++++++++++++++++=
+++++++++
>   include/uapi/linux/vhost.h       |  2 ++
>   include/uapi/linux/vhost_types.h |  2 ++
>   3 files changed, 57 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 421f02a..f1f69bf 100644
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
> @@ -288,6 +301,42 @@ static long vhost_vdpa_get_vring_num(struct vhost_=
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
> +	vhost_config_file file;
> +	struct eventfd_ctx *ctx;
> +
> +	cb.callback =3D vhost_vdpa_config_cb;
> +	cb.private =3D v->vdpa;
> +	if (copy_from_user(&file, argp, sizeof(file)))
> +		return  -EFAULT;
> +
> +	if (file.fd =3D=3D -1) {
> +		vhost_vdpa_config_put(v);
> +		v->config_ctx =3D NULL;
> +		return PTR_ERR(v->config_ctx);
> +	}
> +
> +	ctx =3D eventfd_ctx_fdget(file.fd);


You may simply did ctx =3D f.fd =3D=3D -1 ? NULL : eventfd_ctx_fdget(f.fd=
);

Then there's no need for the specialized action for -1 above.


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
> @@ -398,6 +447,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
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
> @@ -734,6 +786,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>   	vhost_dev_stop(&v->vdev);
>   	vhost_vdpa_iotlb_free(v);
>   	vhost_vdpa_free_domain(v);
> +	vhost_vdpa_config_put(v);
>   	vhost_dev_cleanup(&v->vdev);
>   	kfree(v->vdev.vqs);
>   	mutex_unlock(&d->mutex);
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 9fe72e4..c474a35 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -140,4 +140,6 @@
>   /* Get the max ring size. */
>   #define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
>  =20
> +/* Set event fd for config interrupt*/
> +#define VHOST_VDPA_SET_CONFIG_CALL	_IOW(VHOST_VIRTIO, 0x77, vhost_conf=
ig_file)
>   #endif
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhos=
t_types.h
> index 669457c..6759aefb 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -27,6 +27,8 @@ struct vhost_vring_file {
>  =20
>   };
>  =20
> +typedef struct vhost_vring_file vhost_config_file;
> +


I wonder maybe this is the best approach. Maybe it's better to use=20
vhost_vring_file or just use a int (but need document the -1 action).

Thanks


>   struct vhost_vring_addr {
>   	unsigned int index;
>   	/* Option flags. */

