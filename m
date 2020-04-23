Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A991B5B1A
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgDWMKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:10:54 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32503 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726262AbgDWMKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587643851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrNu4ms8rXXb3JsHV0Q+/ynNjwlXCr8yD8L2k3eEhsE=;
        b=NFU5oPwEURiryvR2CBG+gnejlYmDp3Sg/VaApf+nO9nNSH/HB01gc7aOJLFmZ5Tel6fIZ0
        OLzNul5/kpZYRuExkgIEA1ZQMaXJJywUuRMR+46CpfReM/yjEQF3wHtO/bP9OsfZRFF+lr
        jrasYHxBdMZHVcXxB45VgpcmQJIo9oM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-TepEbs-MM-ObA1-Mamh-7g-1; Thu, 23 Apr 2020 08:10:47 -0400
X-MC-Unique: TepEbs-MM-ObA1-Mamh-7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EEE8107ACCA;
        Thu, 23 Apr 2020 12:10:46 +0000 (UTC)
Received: from [10.72.12.140] (ovpn-12-140.pek2.redhat.com [10.72.12.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7E205D70A;
        Thu, 23 Apr 2020 12:10:40 +0000 (UTC)
Subject: Re: [PATCH v4] virtio: force spec specified alignment on types
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200422145510.442277-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7ea553de-7a27-0aa0-4afb-d167147fd155@redhat.com>
Date:   Thu, 23 Apr 2020 20:10:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422145510.442277-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/22 =E4=B8=8B=E5=8D=8810:58, Michael S. Tsirkin wrote:
> The ring element addresses are passed between components with different
> alignments assumptions. Thus, if guest/userspace selects a pointer and
> host then gets and dereferences it, we might need to decrease the
> compiler-selected alignment to prevent compiler on the host from
> assuming pointer is aligned.
>
> This actually triggers on ARM with -mabi=3Dapcs-gnu - which is a
> deprecated configuration, but it seems safer to handle this
> generally.
>
> Note that userspace that allocates the memory is actually OK and does
> not need to be fixed, but userspace that gets it from guest or another
> process does need to be fixed. The later doesn't generally talk to the
> kernel so while it might be buggy it's not talking to the kernel in the
> buggy way - it's just using the header in the buggy way - so fixing
> header and asking userspace to recompile is the best we can do.
>
> I verified that the produced kernel binary on x86 is exactly identical
> before and after the change.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> changes since v3:
> 	use __attribute__((aligned(X))) instead of __aligned,
> 	to avoid dependency on that macro
>
>   drivers/vhost/vhost.c            |  8 +++---
>   drivers/vhost/vhost.h            |  6 ++---
>   drivers/vhost/vringh.c           |  6 ++---
>   include/linux/vringh.h           |  6 ++---
>   include/uapi/linux/virtio_ring.h | 46 ++++++++++++++++++++++++-------=
-
>   5 files changed, 48 insertions(+), 24 deletions(-)


Acked-by: Jason Wang <jasowang@redhat.com>

(I think we can then remove the BUILD_BUG_ON() in vhost?)

Thanks


> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d450e16c5c25..bc77b0f465fd 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1244,9 +1244,9 @@ static int vhost_iotlb_miss(struct vhost_virtqueu=
e *vq, u64 iova, int access)
>   }
>  =20
>   static bool vq_access_ok(struct vhost_virtqueue *vq, unsigned int num=
,
> -			 struct vring_desc __user *desc,
> -			 struct vring_avail __user *avail,
> -			 struct vring_used __user *used)
> +			 vring_desc_t __user *desc,
> +			 vring_avail_t __user *avail,
> +			 vring_used_t __user *used)
>  =20
>   {
>   	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
> @@ -2301,7 +2301,7 @@ static int __vhost_add_used_n(struct vhost_virtqu=
eue *vq,
>   			    struct vring_used_elem *heads,
>   			    unsigned count)
>   {
> -	struct vring_used_elem __user *used;
> +	vring_used_elem_t __user *used;
>   	u16 old, new;
>   	int start;
>  =20
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index f8403bd46b85..60cab4c78229 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -67,9 +67,9 @@ struct vhost_virtqueue {
>   	/* The actual ring of buffers. */
>   	struct mutex mutex;
>   	unsigned int num;
> -	struct vring_desc __user *desc;
> -	struct vring_avail __user *avail;
> -	struct vring_used __user *used;
> +	vring_desc_t __user *desc;
> +	vring_avail_t __user *avail;
> +	vring_used_t __user *used;
>   	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
>   	struct file *kick;
>   	struct eventfd_ctx *call_ctx;
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index ba8e0d6cfd97..e059a9a47cdf 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -620,9 +620,9 @@ static inline int xfer_to_user(const struct vringh =
*vrh,
>    */
>   int vringh_init_user(struct vringh *vrh, u64 features,
>   		     unsigned int num, bool weak_barriers,
> -		     struct vring_desc __user *desc,
> -		     struct vring_avail __user *avail,
> -		     struct vring_used __user *used)
> +		     vring_desc_t __user *desc,
> +		     vring_avail_t __user *avail,
> +		     vring_used_t __user *used)
>   {
>   	/* Sane power of 2 please! */
>   	if (!num || num > 0xffff || (num & (num - 1))) {
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 9e2763d7c159..59bd50f99291 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -105,9 +105,9 @@ struct vringh_kiov {
>   /* Helpers for userspace vrings. */
>   int vringh_init_user(struct vringh *vrh, u64 features,
>   		     unsigned int num, bool weak_barriers,
> -		     struct vring_desc __user *desc,
> -		     struct vring_avail __user *avail,
> -		     struct vring_used __user *used);
> +		     vring_desc_t __user *desc,
> +		     vring_avail_t __user *avail,
> +		     vring_used_t __user *used);
>  =20
>   static inline void vringh_iov_init(struct vringh_iov *iov,
>   				   struct iovec *iovec, unsigned num)
> diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virt=
io_ring.h
> index 9223c3a5c46a..476d3e5c0fe7 100644
> --- a/include/uapi/linux/virtio_ring.h
> +++ b/include/uapi/linux/virtio_ring.h
> @@ -86,6 +86,13 @@
>    * at the end of the used ring. Guest should ignore the used->flags f=
ield. */
>   #define VIRTIO_RING_F_EVENT_IDX		29
>  =20
> +/* Alignment requirements for vring elements.
> + * When using pre-virtio 1.0 layout, these fall out naturally.
> + */
> +#define VRING_AVAIL_ALIGN_SIZE 2
> +#define VRING_USED_ALIGN_SIZE 4
> +#define VRING_DESC_ALIGN_SIZE 16
> +
>   /* Virtio ring descriptors: 16 bytes.  These can chain together via "=
next". */
>   struct vring_desc {
>   	/* Address (guest-physical). */
> @@ -112,29 +119,46 @@ struct vring_used_elem {
>   	__virtio32 len;
>   };
>  =20
> +typedef struct vring_used_elem __attribute__((aligned(VRING_USED_ALIGN=
_SIZE)))
> +	vring_used_elem_t;
> +
>   struct vring_used {
>   	__virtio16 flags;
>   	__virtio16 idx;
> -	struct vring_used_elem ring[];
> +	vring_used_elem_t ring[];
>   };
>  =20
> +/*
> + * The ring element addresses are passed between components with diffe=
rent
> + * alignments assumptions. Thus, we might need to decrease the compile=
r-selected
> + * alignment, and so must use a typedef to make sure the aligned attri=
bute
> + * actually takes hold:
> + *
> + * https://gcc.gnu.org/onlinedocs//gcc/Common-Type-Attributes.html#Com=
mon-Type-Attributes
> + *
> + * When used on a struct, or struct member, the aligned attribute can =
only
> + * increase the alignment; in order to decrease it, the packed attribu=
te must
> + * be specified as well. When used as part of a typedef, the aligned a=
ttribute
> + * can both increase and decrease alignment, and specifying the packed
> + * attribute generates a warning.
> + */
> +typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SIZE=
)))
> +	vring_desc_t;
> +typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_SI=
ZE)))
> +	vring_avail_t;
> +typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SIZE=
)))
> +	vring_used_t;
> +
>   struct vring {
>   	unsigned int num;
>  =20
> -	struct vring_desc *desc;
> +	vring_desc_t *desc;
>  =20
> -	struct vring_avail *avail;
> +	vring_avail_t *avail;
>  =20
> -	struct vring_used *used;
> +	vring_used_t *used;
>   };
>  =20
> -/* Alignment requirements for vring elements.
> - * When using pre-virtio 1.0 layout, these fall out naturally.
> - */
> -#define VRING_AVAIL_ALIGN_SIZE 2
> -#define VRING_USED_ALIGN_SIZE 4
> -#define VRING_DESC_ALIGN_SIZE 16
> -
>   #ifndef VIRTIO_RING_NO_LEGACY
>  =20
>   /* The standard layout for the ring is a continuous chunk of memory w=
hich looks

