Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEBA4BFF34
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiBVQtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiBVQto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:49:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5035916A5A5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645548556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vz9nNDvyvDMTdhA9MOOdkPb7DZP5KSBUZs6KelrdH10=;
        b=XVpQFOJ0IEHE9zZ0tSap//WmJJ6XYy4p0IfKo1BdxtwLC9PEd9vHVBahoRuRTZJ8KPODmp
        UAzv0ueaLgzz6hj4ej4mMXSnmbuT2SVvbeu7+RnVYbLgQeErsdrDXfLpPsfreWPiPoGhlm
        aAGtBuRlAfvHD5JkPV06TTWP5EhRINI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-p5Vh5Qc4PXe_azqchgwlnw-1; Tue, 22 Feb 2022 11:49:13 -0500
X-MC-Unique: p5Vh5Qc4PXe_azqchgwlnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 335201091DA0;
        Tue, 22 Feb 2022 16:49:11 +0000 (UTC)
Received: from localhost (unknown [10.39.193.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0408F837A9;
        Tue, 22 Feb 2022 16:48:58 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 08/15] vfio: Have the core code decode the
 VFIO_DEVICE_FEATURE ioctl
In-Reply-To: <20220220095716.153757-9-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-9-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 22 Feb 2022 17:48:57 +0100
Message-ID: <87o82y7sp2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> Invoke a new device op 'device_feature' to handle just the data array
> portion of the command. This lifts the ioctl validation to the core code
> and makes it simpler for either the core code, or layered drivers, to
> implement their own feature values.
>
> Provide vfio_check_feature() to consolidate checking the flags/etc against
> what the driver supports.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c      |  1 +
>  drivers/vfio/pci/vfio_pci_core.c | 94 +++++++++++++-------------------
>  drivers/vfio/vfio.c              | 46 ++++++++++++++--
>  include/linux/vfio.h             | 32 +++++++++++
>  include/linux/vfio_pci_core.h    |  2 +
>  5 files changed, 114 insertions(+), 61 deletions(-)
>

(...)

> +static int vfio_ioctl_device_feature(struct vfio_device *device,
> +				     struct vfio_device_feature __user *arg)
> +{
> +	size_t minsz = offsetofend(struct vfio_device_feature, flags);
> +	struct vfio_device_feature feature;
> +
> +	if (copy_from_user(&feature, arg, minsz))
> +		return -EFAULT;
> +
> +	if (feature.argsz < minsz)
> +		return -EINVAL;
> +
> +	/* Check unknown flags */
> +	if (feature.flags &
> +	    ~(VFIO_DEVICE_FEATURE_MASK | VFIO_DEVICE_FEATURE_SET |
> +	      VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_PROBE))
> +		return -EINVAL;
> +
> +	/* GET & SET are mutually exclusive except with PROBE */
> +	if (!(feature.flags & VFIO_DEVICE_FEATURE_PROBE) &&
> +	    (feature.flags & VFIO_DEVICE_FEATURE_SET) &&
> +	    (feature.flags & VFIO_DEVICE_FEATURE_GET))
> +		return -EINVAL;
> +
> +	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
> +	default:
> +		if (unlikely(!device->ops->device_feature))
> +			return -EINVAL;
> +		return device->ops->device_feature(device, feature.flags,
> +						   arg->data,
> +						   feature.argsz - minsz);
> +	}
> +}
> +
>  static long vfio_device_fops_unl_ioctl(struct file *filep,
>  				       unsigned int cmd, unsigned long arg)
>  {
>  	struct vfio_device *device = filep->private_data;
>  
> -	if (unlikely(!device->ops->ioctl))
> -		return -EINVAL;
> -
> -	return device->ops->ioctl(device, cmd, arg);
> +	switch (cmd) {
> +	case VFIO_DEVICE_FEATURE:
> +		return vfio_ioctl_device_feature(device, (void __user *)arg);
> +	default:
> +		if (unlikely(!device->ops->ioctl))
> +			return -EINVAL;
> +		return device->ops->ioctl(device, cmd, arg);
> +	}
>  }

One not-that-obvious change this is making is how VFIO_DEVICE_* ioctls
are processed. With this patch, VFIO_DEVICE_FEATURE is handled a bit
differently to other ioctl commands that are passed directly to the
device; here we have the common handling first, then control is passed
to the device. When I read in Documentation/driver-api/vfio.rst

"The ioctl interface provides a direct pass through for VFIO_DEVICE_*
ioctls."

I would not really expect that behaviour. No objection to introducing
it, but I think that needs a note in the doc, as you only see that if
you actually read the implementation (and not just the header and the
docs).

