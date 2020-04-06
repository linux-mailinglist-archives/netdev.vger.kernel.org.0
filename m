Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F25619F6FF
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgDFNeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:34:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50457 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728358AbgDFNeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586180051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Vgo7PmY6XRwUGwyUrdIW6ngf/mYRofULc4TfPkTyZY=;
        b=BvPejWvF62X0MSz4WOnQPwDCcuOdqhbs17F7VAiAlgvk+sl+hntau1izK/X+iXgXT63dDQ
        JQ72OCE8HVjs2mmWWlWCHhZfONUFW0GctMevBxMWGs26leDam6C0XSx3BQYZhI2U8hnmCX
        cLUbsdHzt13NLPucFe+sAChNF4Dry4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-OOOB-UXuOJGo5RROJLVUvg-1; Mon, 06 Apr 2020 09:34:07 -0400
X-MC-Unique: OOOB-UXuOJGo5RROJLVUvg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C015801E5C;
        Mon,  6 Apr 2020 13:34:06 +0000 (UTC)
Received: from [10.72.12.191] (ovpn-12-191.pek2.redhat.com [10.72.12.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD718B19CB;
        Mon,  6 Apr 2020 13:34:01 +0000 (UTC)
Subject: Re: [PATCH] vhost: force spec specified alignment on types
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200406124931.120768-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <045c84ed-151e-a850-9c72-5079bd2775e6@redhat.com>
Date:   Mon, 6 Apr 2020 21:34:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200406124931.120768-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/6 =E4=B8=8B=E5=8D=888:50, Michael S. Tsirkin wrote:
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
> I verified that the produced binary is exactly identical on x86.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> This is my preferred way to handle the ARM incompatibility issues
> (in preference to kconfig hacks).
> I will push this into next now.
> Comments?


I'm not sure if it's too late to fix. It would still be still=20
problematic for the userspace that is using old uapi headers?

Thanks


>
>   drivers/vhost/vhost.h            |  6 ++---
>   include/uapi/linux/virtio_ring.h | 41 ++++++++++++++++++++++++-------=
-
>   2 files changed, 34 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index cc82918158d2..a67bda9792ec 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -74,9 +74,9 @@ struct vhost_virtqueue {
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
>  =20
>   	struct vhost_desc *descs;
> diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virt=
io_ring.h
> index 559f42e73315..cd6e0b2eaf2f 100644
> --- a/include/uapi/linux/virtio_ring.h
> +++ b/include/uapi/linux/virtio_ring.h
> @@ -118,16 +118,6 @@ struct vring_used {
>   	struct vring_used_elem ring[];
>   };
>  =20
> -struct vring {
> -	unsigned int num;
> -
> -	struct vring_desc *desc;
> -
> -	struct vring_avail *avail;
> -
> -	struct vring_used *used;
> -};
> -
>   /* Alignment requirements for vring elements.
>    * When using pre-virtio 1.0 layout, these fall out naturally.
>    */
> @@ -164,6 +154,37 @@ struct vring {
>   #define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
>   #define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)-=
>num])
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
> +struct vring {
> +	unsigned int num;
> +
> +	vring_desc_t *desc;
> +
> +	vring_avail_t *avail;
> +
> +	vring_used_t *used;
> +};
> +
>   static inline void vring_init(struct vring *vr, unsigned int num, voi=
d *p,
>   			      unsigned long align)
>   {

