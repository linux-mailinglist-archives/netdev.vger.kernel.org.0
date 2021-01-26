Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139D9304496
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbhAZRFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:05:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389711AbhAZIMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:12:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611648634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djhTRJGJg3J6BeW0ceDPJuujST4T2Jt9ExZ596qYokQ=;
        b=ROGAAZ+Rlruvu0uUntptfOD2BR1CwBTA9DkZmJQxFh821+l56ZTdg5vvsDRYND2rzucxMZ
        dVRjd+4O1oqKXtMYg1GibFG7zru/mLa/bc1lkowJtOfHcgjJPe258tBw+dhIcDharOm16Q
        Os+YsTv+pVT9zWfaDR7AAHi5U5CkwzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-9NkikARFNxGCYD4QHeGSrw-1; Tue, 26 Jan 2021 03:10:32 -0500
X-MC-Unique: 9NkikARFNxGCYD4QHeGSrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1FF51005D6E;
        Tue, 26 Jan 2021 08:10:17 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C5EE77BE1;
        Tue, 26 Jan 2021 08:09:48 +0000 (UTC)
Subject: Re: [RFC v3 10/11] vduse: grab the module's references until there is
 no vduse device
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-4-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <406479e4-a4f8-63f3-38f5-b1c3bb6e31ab@redhat.com>
Date:   Tue, 26 Jan 2021 16:09:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119050756.600-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午1:07, Xie Yongji wrote:
> The module should not be unloaded if any vduse device exists.
> So increase the module's reference count when creating vduse
> device. And the reference count is kept until the device is
> destroyed.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Looks like a bug fix. If yes, let's squash this into patch 8.

Thanks


> ---
>   drivers/vdpa/vdpa_user/vduse_dev.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index 4d21203da5b6..003aeb281bce 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -978,6 +978,7 @@ static int vduse_destroy_dev(u32 id)
>   	kfree(dev->vqs);
>   	vduse_domain_destroy(dev->domain);
>   	vduse_dev_destroy(dev);
> +	module_put(THIS_MODULE);
>   
>   	return 0;
>   }
> @@ -1022,6 +1023,7 @@ static int vduse_create_dev(struct vduse_dev_config *config)
>   
>   	dev->connected = true;
>   	list_add(&dev->list, &vduse_devs);
> +	__module_get(THIS_MODULE);
>   
>   	return fd;
>   err_fd:

