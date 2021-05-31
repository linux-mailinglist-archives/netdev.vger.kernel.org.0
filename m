Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219093954D9
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 06:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEaE6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 00:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhEaE6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 00:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D886961057;
        Mon, 31 May 2021 04:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622436988;
        bh=ZmSvGxgElt/PTBdcjud8xAVC3SnaA7rmloK6j6Sv88s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iECVcrjdtpBEoiSTdgPnfA9VaCZX3lXZXVFRxcs36qIJm/fGdtrOg6ursZ+ZUev6p
         SG3ywHs9kGpchB+/l0NRmeD5iCcyzHVz+3Q08ImQ4cRhhwQaCcDa7NSr6UaWFTEGuz
         2HuPqdeBd30igoYiQHo8xDIOag1dwVriDuvzZSlQ=
Date:   Mon, 31 May 2021 06:56:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <YLRsehBRAiCJEDl0@kroah.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-12-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517095513.850-12-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 05:55:12PM +0800, Xie Yongji wrote:
> +struct vduse_dev {
> +	struct vduse_vdpa *vdev;
> +	struct device dev;
> +	struct cdev cdev;

You now have 2 reference counted devices controling the lifespace of a
single structure.  A mess that is guaranteed to go wrong.  Please never
do this.

> +	struct vduse_virtqueue *vqs;
> +	struct vduse_iova_domain *domain;
> +	char *name;
> +	struct mutex lock;
> +	spinlock_t msg_lock;
> +	atomic64_t msg_unique;

Why do you need an atomic and a lock?

> +	wait_queue_head_t waitq;
> +	struct list_head send_list;
> +	struct list_head recv_list;
> +	struct list_head list;
> +	struct vdpa_callback config_cb;
> +	struct work_struct inject;
> +	spinlock_t irq_lock;
> +	unsigned long api_version;
> +	bool connected;
> +	int minor;
> +	u16 vq_size_max;
> +	u32 vq_num;
> +	u32 vq_align;
> +	u32 config_size;
> +	u32 device_id;
> +	u32 vendor_id;
> +};
> +
> +struct vduse_dev_msg {
> +	struct vduse_dev_request req;
> +	struct vduse_dev_response resp;
> +	struct list_head list;
> +	wait_queue_head_t waitq;
> +	bool completed;
> +};
> +
> +struct vduse_control {
> +	unsigned long api_version;

u64?

> +};
> +
> +static unsigned long max_bounce_size = (64 * 1024 * 1024);
> +module_param(max_bounce_size, ulong, 0444);
> +MODULE_PARM_DESC(max_bounce_size, "Maximum bounce buffer size. (default: 64M)");
> +
> +static unsigned long max_iova_size = (128 * 1024 * 1024);
> +module_param(max_iova_size, ulong, 0444);
> +MODULE_PARM_DESC(max_iova_size, "Maximum iova space size (default: 128M)");
> +
> +static bool allow_unsafe_device_emulation;
> +module_param(allow_unsafe_device_emulation, bool, 0444);
> +MODULE_PARM_DESC(allow_unsafe_device_emulation, "Allow emulating unsafe device."
> +	" We must make sure the userspace device emulation process is trusted."
> +	" Otherwise, don't enable this option. (default: false)");
> +

This is not the 1990's anymore, please never use module parameters, make
these per-device attributes if you really need them.

> +static int vduse_init(void)
> +{
> +	int ret;
> +
> +	if (max_bounce_size >= max_iova_size)
> +		return -EINVAL;
> +
> +	ret = misc_register(&vduse_misc);
> +	if (ret)
> +		return ret;
> +
> +	vduse_class = class_create(THIS_MODULE, "vduse");

If you have a misc device, you do not need to create a class at the same
time.  Why are you doing both here?  Just stick with the misc device, no
need for anything else.

> +	if (IS_ERR(vduse_class)) {
> +		ret = PTR_ERR(vduse_class);
> +		goto err_class;
> +	}
> +	vduse_class->devnode = vduse_devnode;
> +
> +	ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");

Wait, you want a whole major?  What is the misc device for?

> +MODULE_VERSION(DRV_VERSION);

MODULE_VERSION() makes no sense when the code is merged into the kernel
tree, so you can just drop that.

thanks,

greg k-h
