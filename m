Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92591B1C05
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 04:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgDUCjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 22:39:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26374 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726013AbgDUCjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 22:39:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587436770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmunxmRPWgsddlc22setU4RrPRi7Q8TgmUrkV++FWQ0=;
        b=RpyVpNCWna/wX5c9CFJrslMXY0dMABUjCqkIAOk2Xsb2tLE/ja9PhN6i/NEA8Dr9j5Qf0o
        GinQp2B9pJQ4zAdloDa/po3hlCI0h4uHVx4X+mjGRZpxCU7CxAzjzYKt2aM3aRSo3r/T27
        TugmqrM2sTh4HFetStGvszxdtoWK06s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-897cG6v6OymdM3U0rEwCQA-1; Mon, 20 Apr 2020 22:39:26 -0400
X-MC-Unique: 897cG6v6OymdM3U0rEwCQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E70C8017F3;
        Tue, 21 Apr 2020 02:39:25 +0000 (UTC)
Received: from [10.72.12.74] (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACD1C48;
        Tue, 21 Apr 2020 02:39:20 +0000 (UTC)
Subject: Re: [PATCH v3] virtio: force spec specified alignment on types
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200420204448.377168-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a4939aeb-ed9d-a6af-1c70-c6c2513e86e2@redhat.com>
Date:   Tue, 21 Apr 2020 10:39:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200420204448.377168-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/21 =E4=B8=8A=E5=8D=884:46, Michael S. Tsirkin wrote:
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
> changes from v2:
> 	add vring_used_elem_t to ensure alignment for substructures
> changes from v1:
> 	swicth all __user to the new typedefs
>
>   drivers/vhost/vhost.c            |  8 +++---
>   drivers/vhost/vhost.h            |  6 ++---
>   drivers/vhost/vringh.c           |  6 ++---
>   include/linux/vringh.h           |  6 ++---
>   include/uapi/linux/virtio_ring.h | 43 ++++++++++++++++++++++++-------=
-
>   5 files changed, 45 insertions(+), 24 deletions(-)
>
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
> index 9223c3a5c46a..b2c20f794472 100644
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
> @@ -112,29 +119,43 @@ struct vring_used_elem {
>   	__virtio32 len;
>   };
>  =20
> +typedef struct vring_used_elem __aligned(VRING_USED_ALIGN_SIZE)
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
> + * alignment, and so must use a typedef to make sure the __aligned att=
ribute
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
> +typedef struct vring_desc __aligned(VRING_DESC_ALIGN_SIZE) vring_desc_=
t;
> +typedef struct vring_avail __aligned(VRING_AVAIL_ALIGN_SIZE) vring_ava=
il_t;
> +typedef struct vring_used __aligned(VRING_USED_ALIGN_SIZE) vring_used_=
t;


I wonder whether we can simply use __attribute__(packed) instead?

Thanks


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

