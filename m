Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEAB333D2D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhCJM6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:58:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232638AbhCJM6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:58:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615381122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=focYiE8f6AZlwFwtTWyFc1fGn5rNUZQWCBuImpia4/w=;
        b=V4lLFObT4mUQBI0GvseH0lTKYUcFnTVnUEV8iNLV3g0fCv0K6qWvf8aTCjlQaVaT4zaVbs
        1kv7jqzmZt9VnK8K7UGRGgZ2zrj27PUU8yoVinC64/91AGuTHNYGAycORsavLkkDiY0lEw
        3TQP4kfdNao7hMJ1bV9lZ5IQqPcPStY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-mZVwZQJ_MeK5xzM2jKWTiw-1; Wed, 10 Mar 2021 07:58:40 -0500
X-MC-Unique: mZVwZQJ_MeK5xzM2jKWTiw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D16891084D68;
        Wed, 10 Mar 2021 12:58:37 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-26.pek2.redhat.com [10.72.12.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0995960C0F;
        Wed, 10 Mar 2021 12:58:31 +0000 (UTC)
Subject: Re: [RFC v4 07/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-8-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2c7446dd-38f8-a06a-e423-6744c6a7207f@redhat.com>
Date:   Wed, 10 Mar 2021 20:58:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-8-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> +
> +	switch (cmd) {
> +	case VDUSE_IOTLB_GET_FD: {
> +		struct vduse_iotlb_entry entry;
> +		struct vhost_iotlb_map *map;
> +		struct vdpa_map_file *map_file;
> +		struct file *f = NULL;
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(&entry, argp, sizeof(entry)))
> +			break;
> +
> +		spin_lock(&dev->iommu_lock);
> +		map = vhost_iotlb_itree_first(dev->iommu, entry.start,
> +					      entry.last);
> +		if (map) {
> +			map_file = (struct vdpa_map_file *)map->opaque;
> +			f = get_file(map_file->file);
> +			entry.offset = map_file->offset;
> +			entry.start = map->start;
> +			entry.last = map->last;
> +			entry.perm = map->perm;
> +		}
> +		spin_unlock(&dev->iommu_lock);
> +		if (!f) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +		if (copy_to_user(argp, &entry, sizeof(entry))) {
> +			fput(f);
> +			ret = -EFAULT;
> +			break;
> +		}
> +		ret = get_unused_fd_flags(perm_to_file_flags(entry.perm));
> +		if (ret < 0) {
> +			fput(f);
> +			break;
> +		}
> +		fd_install(ret, f);


So at least we need to use receice_fd_user() here to give a chance to be 
hooked into security module.

Consider this is bascially a kind of passing file descriptor implicitly. 
We need to be careful if any security stufss is missed.

(Have a quick glance at scm_send/recv, feel ok but need to double check).

Thanks


> +		break;
> +	}

