Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAA41ECAE0
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 09:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgFCH6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 03:58:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbgFCH6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 03:58:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591171119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6s4YwWjWSDJyEzvWoBd/i85+Sheo/GOp6+xMWZwy3wU=;
        b=MPBteHcgty03ZoDTDq6uR3cUBQ0bRKEtQR3A2TkGZC9v4NthBSe8PDcpA9YW8kiob0pLbc
        ALiPDhA6lOdRE9kavz5zyWhJAMvA3zdIhdc1du3siSdB3nmHjpEFHc57jIDkydUakM9fOd
        ySKxI/K/abY+h9D4jZolEs63A3tDWGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-9RybUihZM9iS6EvrhrYauA-1; Wed, 03 Jun 2020 03:58:35 -0400
X-MC-Unique: 9RybUihZM9iS6EvrhrYauA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F08EE800685;
        Wed,  3 Jun 2020 07:58:33 +0000 (UTC)
Received: from [10.72.12.214] (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 582B95C221;
        Wed,  3 Jun 2020 07:58:28 +0000 (UTC)
Subject: Re: [PATCH RFC 07/13] vhost: format-independent API for used buffers
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-8-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6d98f2cc-2084-cde0-c938-4ca01692adf9@redhat.com>
Date:   Wed, 3 Jun 2020 15:58:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602130543.578420-8-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
> Add a new API that doesn't assume used ring, heads, etc.
> For now, we keep the old APIs around to make it easier
> to convert drivers.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/vhost.c | 52 ++++++++++++++++++++++++++++++++++---------
>   drivers/vhost/vhost.h | 17 +++++++++++++-
>   2 files changed, 58 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b4a6e44d56a8..be822f0c9428 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2292,13 +2292,12 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>    * number of output then some number of input descriptors, it's actually two
>    * iovecs, but we pack them into one and note how many of each there were.
>    *
> - * This function returns the descriptor number found, or vq->num (which is
> - * never a valid descriptor number) if none was found.  A negative code is
> - * returned on error. */
> -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> -		      struct iovec iov[], unsigned int iov_size,
> -		      unsigned int *out_num, unsigned int *in_num,
> -		      struct vhost_log *log, unsigned int *log_num)
> + * This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> + * A negative code is returned on error. */
> +int vhost_get_avail_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf,
> +			struct iovec iov[], unsigned int iov_size,
> +			unsigned int *out_num, unsigned int *in_num,
> +			struct vhost_log *log, unsigned int *log_num)
>   {
>   	int ret = fetch_descs(vq);
>   	int i;
> @@ -2311,6 +2310,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   	*out_num = *in_num = 0;
>   	if (unlikely(log))
>   		*log_num = 0;
> +	buf->in_len = buf->out_len = 0;
> +	buf->descs = 0;
>   
>   	for (i = vq->first_desc; i < vq->ndescs; ++i) {
>   		unsigned iov_count = *in_num + *out_num;
> @@ -2340,6 +2341,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   			/* If this is an input descriptor,
>   			 * increment that count. */
>   			*in_num += ret;
> +			buf->in_len += desc->len;
>   			if (unlikely(log && ret)) {
>   				log[*log_num].addr = desc->addr;
>   				log[*log_num].len = desc->len;
> @@ -2355,9 +2357,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   				goto err;
>   			}
>   			*out_num += ret;
> +			buf->out_len += desc->len;
>   		}
>   
> -		ret = desc->id;
> +		buf->id = desc->id;
> +		++buf->descs;
>   
>   		if (!(desc->flags & VRING_DESC_F_NEXT))
>   			break;
> @@ -2365,7 +2369,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   
>   	vq->first_desc = i + 1;
>   
> -	return ret;
> +	return 1;
>   
>   err:
>   	for (i = vq->first_desc; i < vq->ndescs; ++i)
> @@ -2375,7 +2379,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   
>   	return ret;
>   }
> -EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> +EXPORT_SYMBOL_GPL(vhost_get_avail_buf);
> +
> +/* Reverse the effect of vhost_get_avail_buf. Useful for error handling. */
> +void vhost_discard_avail_bufs(struct vhost_virtqueue *vq,
> +			      struct vhost_buf *buf, unsigned count)
> +{
> +	vhost_discard_vq_desc(vq, count);
> +}
> +EXPORT_SYMBOL_GPL(vhost_discard_avail_bufs);
>   
>   static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>   			    struct vring_used_elem *heads,
> @@ -2459,6 +2471,26 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
>   }
>   EXPORT_SYMBOL_GPL(vhost_add_used);
>   
> +int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
> +{
> +	return vhost_add_used(vq, buf->id, buf->in_len);
> +}
> +EXPORT_SYMBOL_GPL(vhost_put_used_buf);
> +
> +int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
> +			  struct vhost_buf *bufs, unsigned count)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < count; ++i) {
> +		vq->heads[i].id = cpu_to_vhost32(vq, bufs[i].id);
> +		vq->heads[i].len = cpu_to_vhost32(vq, bufs[i].in_len);
> +	}
> +
> +	return vhost_add_used_n(vq, vq->heads, count);
> +}
> +EXPORT_SYMBOL_GPL(vhost_put_used_n_bufs);
> +
>   static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>   {
>   	__u16 old, new;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index a67bda9792ec..6c10e99ff334 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -67,6 +67,13 @@ struct vhost_desc {
>   	u16 id;
>   };
>   
> +struct vhost_buf {
> +	u32 out_len;
> +	u32 in_len;
> +	u16 descs;
> +	u16 id;
> +};


So it looks to me the struct vhost_buf can work for both split ring and 
packed ring.

If this is true, we'd better make struct vhost_desc work for both.

Thanks


> +
>   /* The virtqueue structure describes a queue attached to a device. */
>   struct vhost_virtqueue {
>   	struct vhost_dev *dev;
> @@ -193,7 +200,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
>   		      unsigned int *out_num, unsigned int *in_num,
>   		      struct vhost_log *log, unsigned int *log_num);
>   void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
> -
> +int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
> +			struct iovec iov[], unsigned int iov_count,
> +			unsigned int *out_num, unsigned int *in_num,
> +			struct vhost_log *log, unsigned int *log_num);
> +void vhost_discard_avail_bufs(struct vhost_virtqueue *,
> +			      struct vhost_buf *, unsigned count);
>   int vhost_vq_init_access(struct vhost_virtqueue *);
>   int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
>   int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
> @@ -202,6 +214,9 @@ void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
>   			       unsigned int id, int len);
>   void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
>   			       struct vring_used_elem *heads, unsigned count);
> +int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
> +int vhost_put_used_n_bufs(struct vhost_virtqueue *,
> +			  struct vhost_buf *bufs, unsigned count);
>   void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
>   void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
>   bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);

