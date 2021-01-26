Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BAE303D7C
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391612AbhAZMp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:45:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731323AbhAZKBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 05:01:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611655205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kElVC+jkHLstLVhvoAPiIFDGEp54B3rvncUWM43dOQw=;
        b=DdR/2vq2nEet8tbYkQNIlMz5/Huhmk2JXM5+1LGNEvf2u0nbq50PsdjBSFhVDv6FgzlfpZ
        prgSlB6YGV53fAQIvenmKaHXAki/EuchZefgt+beGPuKhx4LYjQKIVk7/VbXAtFW0qDijU
        pGlSq2O5xyukpq/FgouyDyNpnoVxUhQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-kXrSMgh9PS6y4-sMWhagKQ-1; Tue, 26 Jan 2021 03:17:43 -0500
X-MC-Unique: kXrSMgh9PS6y4-sMWhagKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07CAD107ACF6;
        Tue, 26 Jan 2021 08:17:41 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E668E1A839;
        Tue, 26 Jan 2021 08:17:29 +0000 (UTC)
Subject: Re: [RFC v3 11/11] vduse: Introduce a workqueue for irq injection
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
 <20210119050756.600-5-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9cacd59d-1063-7a1f-9831-8728eb1d1c15@redhat.com>
Date:   Tue, 26 Jan 2021 16:17:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119050756.600-5-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午1:07, Xie Yongji wrote:
> This patch introduces a dedicated workqueue for irq injection
> so that we are able to do some performance tuning for it.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


If we want the split like this.

It might be better to:

1) implement a simple irq injection on the ioctl context in patch 8
2) add the dedicated workqueue injection in this patch

Since my understanding is that

1) the function looks more isolated for readers
2) the difference between sysctl vs workqueue should be more obvious 
than system wq vs dedicated wq
3) a chance to describe why workqueue is needed in the commit log in 
this patch

Thanks


> ---
>   drivers/vdpa/vdpa_user/eventfd.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa_user/eventfd.c b/drivers/vdpa/vdpa_user/eventfd.c
> index dbffddb08908..caf7d8d68ac0 100644
> --- a/drivers/vdpa/vdpa_user/eventfd.c
> +++ b/drivers/vdpa/vdpa_user/eventfd.c
> @@ -18,6 +18,7 @@
>   #include "eventfd.h"
>   
>   static struct workqueue_struct *vduse_irqfd_cleanup_wq;
> +static struct workqueue_struct *vduse_irq_wq;
>   
>   static void vduse_virqfd_shutdown(struct work_struct *work)
>   {
> @@ -57,7 +58,7 @@ static int vduse_virqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
>   	__poll_t flags = key_to_poll(key);
>   
>   	if (flags & EPOLLIN)
> -		schedule_work(&virqfd->inject);
> +		queue_work(vduse_irq_wq, &virqfd->inject);
>   
>   	if (flags & EPOLLHUP) {
>   		spin_lock(&vq->irq_lock);
> @@ -165,11 +166,18 @@ int vduse_virqfd_init(void)
>   	if (!vduse_irqfd_cleanup_wq)
>   		return -ENOMEM;
>   
> +	vduse_irq_wq = alloc_workqueue("vduse-irq", WQ_SYSFS | WQ_UNBOUND, 0);
> +	if (!vduse_irq_wq) {
> +		destroy_workqueue(vduse_irqfd_cleanup_wq);
> +		return -ENOMEM;
> +	}
> +
>   	return 0;
>   }
>   
>   void vduse_virqfd_exit(void)
>   {
> +	destroy_workqueue(vduse_irq_wq);
>   	destroy_workqueue(vduse_irqfd_cleanup_wq);
>   }
>   

