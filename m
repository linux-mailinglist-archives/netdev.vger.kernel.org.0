Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CE13D9FF7
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 11:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhG2JAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 05:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234936AbhG2JAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 05:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E270E60EB2;
        Thu, 29 Jul 2021 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627549213;
        bh=iKCa5zaatMGxfmjPygB9q8yUR26Gr2lGQvSccgKgkHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fC4m4iItZ4VRU1damAIBbCj4ko+1mwl+raqKpdAzq6vrXPLQuSGLdUjrWhTv7t73P
         Q27zsIqk2Adz0zw/GAlY4a+cwBHhNp7fP9APYomkUEGsALG6IDvdiS6lIL67qALqTI
         dJYqcxXgj+U/og9rbSP6uY8uh+xftfoT3Yp9Qz6Q=
Date:   Thu, 29 Jul 2021 11:00:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <YQJuG7zrzdWm+ieZ@kroah.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-17-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729073503.187-17-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 03:35:02PM +0800, Xie Yongji wrote:
> +/*
> + * The basic configuration of a VDUSE device, which is used by
> + * VDUSE_CREATE_DEV ioctl to create a VDUSE device.
> + */
> +struct vduse_dev_config {

Please document this structure using kernel doc so we know what all the
fields are.

> +#define VDUSE_NAME_MAX	256
> +	char name[VDUSE_NAME_MAX]; /* vduse device name, needs to be NUL terminated */
> +	__u32 vendor_id; /* virtio vendor id */
> +	__u32 device_id; /* virtio device id */
> +	__u64 features; /* virtio features */
> +	__u32 vq_num; /* the number of virtqueues */
> +	__u32 vq_align; /* the allocation alignment of virtqueue's metadata */
> +	__u32 reserved[13]; /* for future use */

This HAS to be tested to be all 0, otherwise you can never use it in the
future.  I did not see the code doing that at all.

> +	__u32 config_size; /* the size of the configuration space */
> +	__u8 config[0]; /* the buffer of the configuration space */

config[]; please instead?  I thought we were getting rid of all of the
0-length arrays in the kernel tree.

> +};
> +
> +/* Create a VDUSE device which is represented by a char device (/dev/vduse/$NAME) */
> +#define VDUSE_CREATE_DEV	_IOW(VDUSE_BASE, 0x02, struct vduse_dev_config)
> +
> +/*
> + * Destroy a VDUSE device. Make sure there are no more references
> + * to the char device (/dev/vduse/$NAME).
> + */
> +#define VDUSE_DESTROY_DEV	_IOW(VDUSE_BASE, 0x03, char[VDUSE_NAME_MAX])
> +
> +/* The ioctls for VDUSE device (/dev/vduse/$NAME) */
> +
> +/*
> + * The information of one IOVA region, which is retrieved from
> + * VDUSE_IOTLB_GET_FD ioctl.
> + */
> +struct vduse_iotlb_entry {
> +	__u64 offset; /* the mmap offset on returned file descriptor */
> +	__u64 start; /* start of the IOVA range: [start, last] */
> +	__u64 last; /* last of the IOVA range: [start, last] */
> +#define VDUSE_ACCESS_RO 0x1
> +#define VDUSE_ACCESS_WO 0x2
> +#define VDUSE_ACCESS_RW 0x3
> +	__u8 perm; /* access permission of this region */
> +};
> +
> +/*
> + * Find the first IOVA region that overlaps with the range [start, last]
> + * and return the corresponding file descriptor. Return -EINVAL means the
> + * IOVA region doesn't exist. Caller should set start and last fields.
> + */
> +#define VDUSE_IOTLB_GET_FD	_IOWR(VDUSE_BASE, 0x10, struct vduse_iotlb_entry)
> +
> +/*
> + * Get the negotiated virtio features. It's a subset of the features in
> + * struct vduse_dev_config which can be accepted by virtio driver. It's
> + * only valid after FEATURES_OK status bit is set.
> + */
> +#define VDUSE_DEV_GET_FEATURES	_IOR(VDUSE_BASE, 0x11, __u64)
> +
> +/*
> + * The information that is used by VDUSE_DEV_SET_CONFIG ioctl to update
> + * device configuration space.
> + */
> +struct vduse_config_data {
> +	__u32 offset; /* offset from the beginning of configuration space */
> +	__u32 length; /* the length to write to configuration space */
> +	__u8 buffer[0]; /* buffer used to write from */

again, buffer[];?

> +};
> +
> +/* Set device configuration space */
> +#define VDUSE_DEV_SET_CONFIG	_IOW(VDUSE_BASE, 0x12, struct vduse_config_data)
> +
> +/*
> + * Inject a config interrupt. It's usually used to notify virtio driver
> + * that device configuration space has changed.
> + */
> +#define VDUSE_DEV_INJECT_CONFIG_IRQ	_IO(VDUSE_BASE, 0x13)
> +
> +/*
> + * The basic configuration of a virtqueue, which is used by
> + * VDUSE_VQ_SETUP ioctl to setup a virtqueue.
> + */
> +struct vduse_vq_config {
> +	__u32 index; /* virtqueue index */
> +	__u16 max_size; /* the max size of virtqueue */
> +};
> +
> +/*
> + * Setup the specified virtqueue. Make sure all virtqueues have been
> + * configured before the device is attached to vDPA bus.
> + */
> +#define VDUSE_VQ_SETUP		_IOW(VDUSE_BASE, 0x14, struct vduse_vq_config)
> +
> +struct vduse_vq_state_split {
> +	__u16 avail_index; /* available index */
> +};
> +
> +struct vduse_vq_state_packed {
> +	__u16 last_avail_counter:1; /* last driver ring wrap counter observed by device */
> +	__u16 last_avail_idx:15; /* device available index */

Bit fields in a user structure?  Are you sure this is going to work
well?  Why not just make this a __u16 and then mask off what you want so
that you do not run into endian issues?

> +	__u16 last_used_counter:1; /* device ring wrap counter */
> +	__u16 last_used_idx:15; /* used index */
> +};
> +
> +/*
> + * The information of a virtqueue, which is retrieved from
> + * VDUSE_VQ_GET_INFO ioctl.
> + */
> +struct vduse_vq_info {
> +	__u32 index; /* virtqueue index */
> +	__u32 num; /* the size of virtqueue */
> +	__u64 desc_addr; /* address of desc area */
> +	__u64 driver_addr; /* address of driver area */
> +	__u64 device_addr; /* address of device area */
> +	union {
> +		struct vduse_vq_state_split split; /* split virtqueue state */
> +		struct vduse_vq_state_packed packed; /* packed virtqueue state */
> +	};
> +	__u8 ready; /* ready status of virtqueue */
> +};
> +
> +/* Get the specified virtqueue's information. Caller should set index field. */
> +#define VDUSE_VQ_GET_INFO	_IOWR(VDUSE_BASE, 0x15, struct vduse_vq_info)
> +
> +/*
> + * The eventfd configuration for the specified virtqueue. It's used by
> + * VDUSE_VQ_SETUP_KICKFD ioctl to setup kick eventfd.
> + */
> +struct vduse_vq_eventfd {
> +	__u32 index; /* virtqueue index */
> +#define VDUSE_EVENTFD_DEASSIGN -1
> +	int fd; /* eventfd, -1 means de-assigning the eventfd */

Don't we have a file descriptor type?  I could be wrong.

> +};
> +
> +/*
> + * Setup kick eventfd for specified virtqueue. The kick eventfd is used
> + * by VDUSE kernel module to notify userspace to consume the avail vring.
> + */
> +#define VDUSE_VQ_SETUP_KICKFD	_IOW(VDUSE_BASE, 0x16, struct vduse_vq_eventfd)
> +
> +/*
> + * Inject an interrupt for specific virtqueue. It's used to notify virtio driver
> + * to consume the used vring.
> + */
> +#define VDUSE_VQ_INJECT_IRQ	_IOW(VDUSE_BASE, 0x17, __u32)
> +
> +/* The control messages definition for read/write on /dev/vduse/$NAME */
> +
> +enum vduse_req_type {
> +	/* Get the state for specified virtqueue from userspace */
> +	VDUSE_GET_VQ_STATE,
> +	/* Set the device status */
> +	VDUSE_SET_STATUS,
> +	/*
> +	 * Notify userspace to update the memory mapping for specified
> +	 * IOVA range via VDUSE_IOTLB_GET_FD ioctl
> +	 */
> +	VDUSE_UPDATE_IOTLB,
> +};
> +
> +struct vduse_vq_state {
> +	__u32 index; /* virtqueue index */
> +	union {
> +		struct vduse_vq_state_split split; /* split virtqueue state */
> +		struct vduse_vq_state_packed packed; /* packed virtqueue state */
> +	};
> +};
> +
> +struct vduse_dev_status {
> +	__u8 status; /* device status */
> +};
> +
> +struct vduse_iova_range {
> +	__u64 start; /* start of the IOVA range: [start, end] */
> +	__u64 last; /* last of the IOVA range: [start, end] */
> +};
> +
> +struct vduse_dev_request {
> +	__u32 type; /* request type */
> +	__u32 request_id; /* request id */
> +	__u32 reserved[2]; /* for future use */

Again, this HAS to be checked to be 0 and aborted if not, otherwise you
can never use it in the future.

> +	union {
> +		struct vduse_vq_state vq_state; /* virtqueue state, only use index */
> +		struct vduse_dev_status s; /* device status */
> +		struct vduse_iova_range iova; /* IOVA range for updating */
> +		__u32 padding[16]; /* padding */
> +	};
> +};
> +
> +struct vduse_dev_response {
> +	__u32 request_id; /* corresponding request id */
> +#define VDUSE_REQ_RESULT_OK	0x00
> +#define VDUSE_REQ_RESULT_FAILED	0x01
> +	__u32 result; /* the result of request */
> +	__u32 reserved[2]; /* for future use */

Same here, you have to check this.

> +	union {
> +		struct vduse_vq_state vq_state; /* virtqueue state */
> +		__u32 padding[16]; /* padding */

Check this padding too.

thanks,

greg k-h
