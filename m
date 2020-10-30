Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D302A020D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 11:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgJ3KCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 06:02:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgJ3KCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 06:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604052152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vu4Swj5ZddyZ5LlCNkDJhXHFRPfGcHPYwnlBLFF6NdI=;
        b=DifxDmPZHJut5xU6zinPBd6uto8qENjep7gqFPS0+S0ZN5suKivR6s6osTbDEcDM8iNdUo
        g0HpzIgaO9Cm6RbSReROdOrIJz6QC1++yZyKzwkFjrvYTcqus7vTeSCyUeNw5EqgEhSc2N
        7rciaWhEu7XghRjDOLO1iXEdQIeBbBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-HAqy5cglN9SlsxddpB3cEQ-1; Fri, 30 Oct 2020 06:02:29 -0400
X-MC-Unique: HAqy5cglN9SlsxddpB3cEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42B53803620;
        Fri, 30 Oct 2020 10:02:28 +0000 (UTC)
Received: from [10.72.12.248] (ovpn-12-248.pek2.redhat.com [10.72.12.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E34325B4A1;
        Fri, 30 Oct 2020 10:02:19 +0000 (UTC)
Subject: Re: [PATCH] vhost/vsock: add IOTLB API support
To:     Stefano Garzarella <sgarzare@redhat.com>, mst@redhat.com
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <20201029174351.134173-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <751cc074-ae68-72c8-71de-a42458058761@redhat.com>
Date:   Fri, 30 Oct 2020 18:02:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029174351.134173-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/30 上午1:43, Stefano Garzarella wrote:
> This patch enables the IOTLB API support for vhost-vsock devices,
> allowing the userspace to emulate an IOMMU for the guest.
>
> These changes were made following vhost-net, in details this patch:
> - exposes VIRTIO_F_ACCESS_PLATFORM feature and inits the iotlb
>    device if the feature is acked
> - implements VHOST_GET_BACKEND_FEATURES and
>    VHOST_SET_BACKEND_FEATURES ioctls
> - calls vq_meta_prefetch() before vq processing to prefetch vq
>    metadata address in IOTLB
> - provides .read_iter, .write_iter, and .poll callbacks for the
>    chardev; they are used by the userspace to exchange IOTLB messages
>
> This patch was tested with QEMU and a patch applied [1] to fix a
> simple issue:
>      $ qemu -M q35,accel=kvm,kernel-irqchip=split \
>             -drive file=fedora.qcow2,format=qcow2,if=virtio \
>             -device intel-iommu,intremap=on \
>             -device vhost-vsock-pci,guest-cid=3,iommu_platform=on


Patch looks good, but a question:

It looks to me you don't enable ATS which means vhost won't get any 
invalidation request or did I miss anything?

Thanks


>
> [1] https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg09077.html
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   drivers/vhost/vsock.c | 68 +++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 65 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index a483cec31d5c..5e78fb719602 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -30,7 +30,12 @@
>   #define VHOST_VSOCK_PKT_WEIGHT 256
>   
>   enum {
> -	VHOST_VSOCK_FEATURES = VHOST_FEATURES,
> +	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> +			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
> +};
> +
> +enum {
> +	VHOST_VSOCK_BACKEND_FEATURES = (1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2)
>   };
>   
>   /* Used to track all the vhost_vsock instances on the system. */
> @@ -94,6 +99,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>   	if (!vhost_vq_get_backend(vq))
>   		goto out;
>   
> +	if (!vq_meta_prefetch(vq))
> +		goto out;
> +
>   	/* Avoid further vmexits, we're already processing the virtqueue */
>   	vhost_disable_notify(&vsock->dev, vq);
>   
> @@ -449,6 +457,9 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>   	if (!vhost_vq_get_backend(vq))
>   		goto out;
>   
> +	if (!vq_meta_prefetch(vq))
> +		goto out;
> +
>   	vhost_disable_notify(&vsock->dev, vq);
>   	do {
>   		u32 len;
> @@ -766,8 +777,12 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>   	mutex_lock(&vsock->dev.mutex);
>   	if ((features & (1 << VHOST_F_LOG_ALL)) &&
>   	    !vhost_log_access_ok(&vsock->dev)) {
> -		mutex_unlock(&vsock->dev.mutex);
> -		return -EFAULT;
> +		goto err;
> +	}
> +
> +	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
> +		if (vhost_init_device_iotlb(&vsock->dev, true))
> +			goto err;
>   	}
>   
>   	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
> @@ -778,6 +793,10 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>   	}
>   	mutex_unlock(&vsock->dev.mutex);
>   	return 0;
> +
> +err:
> +	mutex_unlock(&vsock->dev.mutex);
> +	return -EFAULT;
>   }
>   
>   static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
> @@ -811,6 +830,18 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
>   		if (copy_from_user(&features, argp, sizeof(features)))
>   			return -EFAULT;
>   		return vhost_vsock_set_features(vsock, features);
> +	case VHOST_GET_BACKEND_FEATURES:
> +		features = VHOST_VSOCK_BACKEND_FEATURES;
> +		if (copy_to_user(argp, &features, sizeof(features)))
> +			return -EFAULT;
> +		return 0;
> +	case VHOST_SET_BACKEND_FEATURES:
> +		if (copy_from_user(&features, argp, sizeof(features)))
> +			return -EFAULT;
> +		if (features & ~VHOST_VSOCK_BACKEND_FEATURES)
> +			return -EOPNOTSUPP;
> +		vhost_set_backend_features(&vsock->dev, features);
> +		return 0;
>   	default:
>   		mutex_lock(&vsock->dev.mutex);
>   		r = vhost_dev_ioctl(&vsock->dev, ioctl, argp);
> @@ -823,6 +854,34 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
>   	}
>   }
>   
> +static ssize_t vhost_vsock_chr_read_iter(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	struct file *file = iocb->ki_filp;
> +	struct vhost_vsock *vsock = file->private_data;
> +	struct vhost_dev *dev = &vsock->dev;
> +	int noblock = file->f_flags & O_NONBLOCK;
> +
> +	return vhost_chr_read_iter(dev, to, noblock);
> +}
> +
> +static ssize_t vhost_vsock_chr_write_iter(struct kiocb *iocb,
> +					struct iov_iter *from)
> +{
> +	struct file *file = iocb->ki_filp;
> +	struct vhost_vsock *vsock = file->private_data;
> +	struct vhost_dev *dev = &vsock->dev;
> +
> +	return vhost_chr_write_iter(dev, from);
> +}
> +
> +static __poll_t vhost_vsock_chr_poll(struct file *file, poll_table *wait)
> +{
> +	struct vhost_vsock *vsock = file->private_data;
> +	struct vhost_dev *dev = &vsock->dev;
> +
> +	return vhost_chr_poll(file, dev, wait);
> +}
> +
>   static const struct file_operations vhost_vsock_fops = {
>   	.owner          = THIS_MODULE,
>   	.open           = vhost_vsock_dev_open,
> @@ -830,6 +889,9 @@ static const struct file_operations vhost_vsock_fops = {
>   	.llseek		= noop_llseek,
>   	.unlocked_ioctl = vhost_vsock_dev_ioctl,
>   	.compat_ioctl   = compat_ptr_ioctl,
> +	.read_iter      = vhost_vsock_chr_read_iter,
> +	.write_iter     = vhost_vsock_chr_write_iter,
> +	.poll           = vhost_vsock_chr_poll,
>   };
>   
>   static struct miscdevice vhost_vsock_misc = {

