Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B879032A359
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382130AbhCBI4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347838AbhCBGpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:45:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614667463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGyarxAsRNm8uMESl4edL1CyhRJbWc98p5w3NIlaIWI=;
        b=bXfyjLJvFWWFh0rGjJIfwifGUohULnoWJoo/IwecEC0S++DvFig14TZWsTceCc8QqcLGdV
        sMTK3P2EOLGz/6bTLIMyWWaTH73vb60atQqOpdC2VFgYK1NzahF+rbbYPIFz7mja8ua7mi
        H5TyG1+L1C9Ed+fiBzfJqmZPHDza8z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-iq46B30zMAK1-c24fAjiyQ-1; Tue, 02 Mar 2021 01:44:19 -0500
X-MC-Unique: iq46B30zMAK1-c24fAjiyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC05018B6141;
        Tue,  2 Mar 2021 06:44:16 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD9AE5D766;
        Tue,  2 Mar 2021 06:44:03 +0000 (UTC)
Subject: Re: [RFC v4 01/11] eventfd: Increase the recursion depth of
 eventfd_signal()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <22e96bd6-0113-ef01-376e-0776d7bdbcd8@redhat.com>
Date:   Tue, 2 Mar 2021 14:44:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> Increase the recursion depth of eventfd_signal() to 1. This
> is the maximum recursion depth we have found so far.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>

It might be useful to explain how/when we can reach for this condition.

Thanks


> ---
>   fs/eventfd.c            | 2 +-
>   include/linux/eventfd.h | 5 ++++-
>   2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index e265b6dd4f34..cc7cd1dbedd3 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -71,7 +71,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>   	 * it returns true, the eventfd_signal() call should be deferred to a
>   	 * safe context.
>   	 */
> -	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
> +	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH))
>   		return 0;
>   
>   	spin_lock_irqsave(&ctx->wqh.lock, flags);
> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> index fa0a524baed0..886d99cd38ef 100644
> --- a/include/linux/eventfd.h
> +++ b/include/linux/eventfd.h
> @@ -29,6 +29,9 @@
>   #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
>   #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
>   
> +/* Maximum recursion depth */
> +#define EFD_WAKE_DEPTH 1
> +
>   struct eventfd_ctx;
>   struct file;
>   
> @@ -47,7 +50,7 @@ DECLARE_PER_CPU(int, eventfd_wake_count);
>   
>   static inline bool eventfd_signal_count(void)
>   {
> -	return this_cpu_read(eventfd_wake_count);
> +	return this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH;
>   }
>   
>   #else /* CONFIG_EVENTFD */

