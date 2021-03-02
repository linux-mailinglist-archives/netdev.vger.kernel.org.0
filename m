Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4134432A366
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382139AbhCBI4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344957AbhCBGvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:51:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614667768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yWsCopsWZPSi41ULNKjBHGlcw6/zU4zCo27Dtmkuins=;
        b=gFzzFvJGdJNYUbQzIEU1xHQPfx+4nWnZKiPR7U5a7kxQGf1+gQRaRGnKOl3WHnrGQf9A3r
        f9CXW6iVhkR8T9ArsyRQcO9ewFdxWv6BUuMhConYz83d9jjqqgYeYiC6jdqZoBnY9Ep1Iy
        QIPacw6NJ/C0dzew5z81E6OW/HyW/Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-uM0QVBUqN-K3HXizDZDIIw-1; Tue, 02 Mar 2021 01:49:24 -0500
X-MC-Unique: uM0QVBUqN-K3HXizDZDIIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52E481005501;
        Tue,  2 Mar 2021 06:49:22 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD1645D71F;
        Tue,  2 Mar 2021 06:49:10 +0000 (UTC)
Subject: Re: [RFC v4 03/11] vhost-iotlb: Add an opaque pointer for vhost IOTLB
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-4-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <41c12b5a-d46c-2b80-d553-82efc3f94147@redhat.com>
Date:   Tue, 2 Mar 2021 14:49:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> Add an opaque pointer for vhost IOTLB. And introduce
> vhost_iotlb_add_range_ctx() to accept it.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/iotlb.c       | 20 ++++++++++++++++----
>   include/linux/vhost_iotlb.h |  3 +++
>   2 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 0fd3f87e913c..5c99e1112cbb 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -36,19 +36,21 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
>   EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
>   
>   /**
> - * vhost_iotlb_add_range - add a new range to vhost IOTLB
> + * vhost_iotlb_add_range_ctx - add a new range to vhost IOTLB
>    * @iotlb: the IOTLB
>    * @start: start of the IOVA range
>    * @last: last of IOVA range
>    * @addr: the address that is mapped to @start
>    * @perm: access permission of this range
> + * @opaque: the opaque pointer for the new mapping
>    *
>    * Returns an error last is smaller than start or memory allocation
>    * fails
>    */
> -int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
> -			  u64 start, u64 last,
> -			  u64 addr, unsigned int perm)
> +int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> +			      u64 start, u64 last,
> +			      u64 addr, unsigned int perm,
> +			      void *opaque)
>   {
>   	struct vhost_iotlb_map *map;
>   
> @@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
>   	map->last = last;
>   	map->addr = addr;
>   	map->perm = perm;
> +	map->opaque = opaque;
>   
>   	iotlb->nmaps++;
>   	vhost_iotlb_itree_insert(map, &iotlb->root);
> @@ -80,6 +83,15 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
>   
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(vhost_iotlb_add_range_ctx);
> +
> +int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
> +			  u64 start, u64 last,
> +			  u64 addr, unsigned int perm)
> +{
> +	return vhost_iotlb_add_range_ctx(iotlb, start, last,
> +					 addr, perm, NULL);
> +}
>   EXPORT_SYMBOL_GPL(vhost_iotlb_add_range);
>   
>   /**
> diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
> index 6b09b786a762..2d0e2f52f938 100644
> --- a/include/linux/vhost_iotlb.h
> +++ b/include/linux/vhost_iotlb.h
> @@ -17,6 +17,7 @@ struct vhost_iotlb_map {
>   	u32 perm;
>   	u32 flags_padding;
>   	u64 __subtree_last;
> +	void *opaque;
>   };
>   
>   #define VHOST_IOTLB_FLAG_RETIRE 0x1
> @@ -29,6 +30,8 @@ struct vhost_iotlb {
>   	unsigned int flags;
>   };
>   
> +int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb, u64 start, u64 last,
> +			      u64 addr, unsigned int perm, void *opaque);
>   int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
>   			  u64 addr, unsigned int perm);
>   void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);

