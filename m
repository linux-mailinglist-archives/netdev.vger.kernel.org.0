Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5C43B5E94
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhF1NEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:04:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233101AbhF1NEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 09:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624885329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r7byu1zbfajCaS8MrnWP3nYIhI/TdiqozXSgAvZzIrk=;
        b=WwuS2plgHZ5HSBKbzIiAGxcP1RWQwDZCJjE1PYsMt6rd24b6E6cdBx36ZHbdHZoYrGbj5Q
        0lYqJ8nANkkp38EtIucsxLQ9eux/1wm7+EnW2/C8Ts6QYE0dY1vdzB9i4mraCMhygh210b
        qZttCKMjyaoxxqn/exPPAtrg2rVJjTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-zx-ON1NUPxCI9bdEv2Z_0w-1; Mon, 28 Jun 2021 09:02:04 -0400
X-MC-Unique: zx-ON1NUPxCI9bdEv2Z_0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45B54102CC4E;
        Mon, 28 Jun 2021 13:02:02 +0000 (UTC)
Received: from localhost (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0022707D;
        Mon, 28 Jun 2021 13:01:57 +0000 (UTC)
Date:   Thu, 24 Jun 2021 15:46:14 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <YNSatrDFsg+4VvH4@stefanha-x1.localdomain>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-10-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rzw7cfGCkXrQoewn"
Content-Disposition: inline
In-Reply-To: <20210615141331.407-10-xieyongji@bytedance.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rzw7cfGCkXrQoewn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> new file mode 100644
> index 000000000000..f21b2e51b5c8
> --- /dev/null
> +++ b/include/uapi/linux/vduse.h
> @@ -0,0 +1,143 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_VDUSE_H_
> +#define _UAPI_VDUSE_H_
> +
> +#include <linux/types.h>
> +
> +#define VDUSE_API_VERSION	0
> +
> +#define VDUSE_NAME_MAX	256
> +
> +/* the control messages definition for read/write */
> +
> +enum vduse_req_type {
> +	/* Get the state for virtqueue from userspace */
> +	VDUSE_GET_VQ_STATE,
> +	/* Notify userspace to start the dataplane, no reply */
> +	VDUSE_START_DATAPLANE,
> +	/* Notify userspace to stop the dataplane, no reply */
> +	VDUSE_STOP_DATAPLANE,
> +	/* Notify userspace to update the memory mapping in device IOTLB */
> +	VDUSE_UPDATE_IOTLB,
> +};
> +
> +struct vduse_vq_state {
> +	__u32 index; /* virtqueue index */
> +	__u32 avail_idx; /* virtqueue state (last_avail_idx) */
> +};
> +
> +struct vduse_iova_range {
> +	__u64 start; /* start of the IOVA range */
> +	__u64 last; /* end of the IOVA range */

Please clarify whether this describes a closed range [start, last] or an
open range [start, last).

> +};
> +
> +struct vduse_dev_request {
> +	__u32 type; /* request type */
> +	__u32 request_id; /* request id */
> +#define VDUSE_REQ_FLAGS_NO_REPLY	(1 << 0) /* No need to reply */
> +	__u32 flags; /* request flags */
> +	__u32 reserved; /* for future use */
> +	union {
> +		struct vduse_vq_state vq_state; /* virtqueue state */
> +		struct vduse_iova_range iova; /* iova range for updating */
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
> +	union {
> +		struct vduse_vq_state vq_state; /* virtqueue state */
> +		__u32 padding[16]; /* padding */
> +	};
> +};
> +
> +/* ioctls */
> +
> +struct vduse_dev_config {
> +	char name[VDUSE_NAME_MAX]; /* vduse device name */
> +	__u32 vendor_id; /* virtio vendor id */
> +	__u32 device_id; /* virtio device id */
> +	__u64 features; /* device features */
> +	__u64 bounce_size; /* bounce buffer size for iommu */
> +	__u16 vq_size_max; /* the max size of virtqueue */

The VIRTIO specification allows per-virtqueue sizes. A device can have
two virtqueues, where the first one allows up to 1024 descriptors and
the second one allows only 128 descriptors, for example.

This constant seems to impose the constraint that all virtqueues have
the same maximum size. Is this really necessary?

> +	__u16 padding; /* padding */
> +	__u32 vq_num; /* the number of virtqueues */
> +	__u32 vq_align; /* the allocation alignment of virtqueue's metadata */

I'm not sure what this is?

> +	__u32 config_size; /* the size of the configuration space */
> +	__u32 reserved[15]; /* for future use */
> +	__u8 config[0]; /* the buffer of the configuration space */
> +};
> +
> +struct vduse_iotlb_entry {
> +	__u64 offset; /* the mmap offset on fd */
> +	__u64 start; /* start of the IOVA range */
> +	__u64 last; /* last of the IOVA range */

Same here, please specify whether this is an open range or a closed
range.

> +#define VDUSE_ACCESS_RO 0x1
> +#define VDUSE_ACCESS_WO 0x2
> +#define VDUSE_ACCESS_RW 0x3
> +	__u8 perm; /* access permission of this range */
> +};
> +
> +struct vduse_config_update {
> +	__u32 offset; /* offset from the beginning of configuration space */
> +	__u32 length; /* the length to write to configuration space */
> +	__u8 buffer[0]; /* buffer used to write from */
> +};
> +
> +struct vduse_vq_info {
> +	__u32 index; /* virtqueue index */
> +	__u32 avail_idx; /* virtqueue state (last_avail_idx) */
> +	__u64 desc_addr; /* address of desc area */
> +	__u64 driver_addr; /* address of driver area */
> +	__u64 device_addr; /* address of device area */
> +	__u32 num; /* the size of virtqueue */
> +	__u8 ready; /* ready status of virtqueue */
> +};
> +
> +struct vduse_vq_eventfd {
> +	__u32 index; /* virtqueue index */
> +#define VDUSE_EVENTFD_DEASSIGN -1
> +	int fd; /* eventfd, -1 means de-assigning the eventfd */
> +};
> +
> +#define VDUSE_BASE	0x81
> +
> +/* Get the version of VDUSE API. This is used for future extension */
> +#define VDUSE_GET_API_VERSION	_IOR(VDUSE_BASE, 0x00, __u64)
> +
> +/* Set the version of VDUSE API. */
> +#define VDUSE_SET_API_VERSION	_IOW(VDUSE_BASE, 0x01, __u64)
> +
> +/* Create a vduse device which is represented by a char device (/dev/vduse/<name>) */
> +#define VDUSE_CREATE_DEV	_IOW(VDUSE_BASE, 0x02, struct vduse_dev_config)
> +
> +/* Destroy a vduse device. Make sure there are no references to the char device */
> +#define VDUSE_DESTROY_DEV	_IOW(VDUSE_BASE, 0x03, char[VDUSE_NAME_MAX])
> +
> +/*
> + * Get a file descriptor for the first overlapped iova region,
> + * -EINVAL means the iova region doesn't exist.
> + */
> +#define VDUSE_IOTLB_GET_FD	_IOWR(VDUSE_BASE, 0x04, struct vduse_iotlb_entry)
> +
> +/* Get the negotiated features */
> +#define VDUSE_DEV_GET_FEATURES	_IOR(VDUSE_BASE, 0x05, __u64)
> +
> +/* Update the configuration space */
> +#define VDUSE_DEV_UPDATE_CONFIG	_IOW(VDUSE_BASE, 0x06, struct vduse_config_update)
> +
> +/* Get the specified virtqueue's information */
> +#define VDUSE_VQ_GET_INFO	_IOWR(VDUSE_BASE, 0x07, struct vduse_vq_info)
> +
> +/* Setup an eventfd to receive kick for virtqueue */
> +#define VDUSE_VQ_SETUP_KICKFD	_IOW(VDUSE_BASE, 0x08, struct vduse_vq_eventfd)
> +
> +/* Inject an interrupt for specific virtqueue */
> +#define VDUSE_VQ_INJECT_IRQ	_IOW(VDUSE_BASE, 0x09, __u32)

There is not enough documentation to use this header file. For example,
which ioctls are used with /dev/vduse and which are used with
/dev/vduse/<name>?

Please document that ioctl API fully. It will not only help userspace
developers but also define what is part of the interface and what is an
implementation detail that can change in the future.

--rzw7cfGCkXrQoewn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDUmrYACgkQnKSrs4Gr
c8jpNQf/U38QmNZ7son/JwTYEOsP0nXDESgUCXtpFU/+uz0bid8vE2ZWyF4/CHb5
BQ+m8tmQvEwgemJx63M0wPOuYZcVAhAcpmNueiG/1StRW1Qlka3gV17+z2tGKGFf
e97IuZYv2UKMNkkZ/24TJioDRJdfc/TsKqqr4iFKh6aGglipoEKeFxtO5SO3MKDT
u4fOc8D2OvGolYL5m1LgWpXHlccbDZbrPv1y9lg4+4SkQYV5xG0vQOgX1KwOShLk
VjNe47CDQftKnJglOFfiUvcauN+9RVGsRX7JnkmAs0a2ysLWqJzXC8FZLHJBniZH
4ESvFJnW5LRSJTL2iRmFIqu3F7+g0Q==
=z03g
-----END PGP SIGNATURE-----

--rzw7cfGCkXrQoewn--

