Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D782E2398
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 03:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgLXCN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 21:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbgLXCN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 21:13:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608775920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swnlJja9vV9IaQUf+Cmbgo9v/rpw1W8NO8amK8k/76w=;
        b=DJOGalbOJFLfxb39NGRcpkXbD7uCe5cdky5+SnxrDsXfiioaxck9LLcCdQr9wsE/ABQ6SK
        AGnXbmQSKqGGiuT3t+88TrTJrOlXIk28Cw9oMWSBHc8gS2aV9Wj0rrB4SLZhALyVOqpqpP
        OBvV3eQwofVOppTcXc0YCoidShU0o/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-kM5oObpROuyJDzDHe6-P1A-1; Wed, 23 Dec 2020 21:11:55 -0500
X-MC-Unique: kM5oObpROuyJDzDHe6-P1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C510107ACE6;
        Thu, 24 Dec 2020 02:11:54 +0000 (UTC)
Received: from [10.72.13.109] (ovpn-13-109.pek2.redhat.com [10.72.13.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C11B5D9C6;
        Thu, 24 Dec 2020 02:11:42 +0000 (UTC)
Subject: Re: [PATCH v2] vhost/vsock: add IOTLB API support
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20201223143638.123417-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <28e8b1cf-513a-5bc6-096d-432dfa6620cb@redhat.com>
Date:   Thu, 24 Dec 2020 10:11:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201223143638.123417-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/23 下午10:36, Stefano Garzarella wrote:
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
> This patch was tested specifying "intel_iommu=strict" in the guest
> kernel command line. I used QEMU with a patch applied [1] to fix a
> simple issue (that patch was merged in QEMU v5.2.0):
>      $ qemu -M q35,accel=kvm,kernel-irqchip=split \
>             -drive file=fedora.qcow2,format=qcow2,if=virtio \
>             -device intel-iommu,intremap=on,device-iotlb=on \
>             -device vhost-vsock-pci,guest-cid=3,iommu_platform=on,ats=on
>
> [1] https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg09077.html
>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>
> The patch is the same of v1, but I re-tested it with:
> - QEMU v5.2.0-551-ga05f8ecd88
> - Linux 5.9.15 (host)
> - Linux 5.9.15 and 5.10.0 (guest)
> Now, enabling 'ats' it works well, there are just a few simple changes.
>
> v1: https://www.spinics.net/lists/kernel/msg3716022.html
> v2:
> - updated commit message about QEMU version and string used to test
> - rebased on mst/vhost branch
>
> Thanks,
> Stefano
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

