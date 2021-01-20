Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6632FC9F7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 05:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbhATE0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 23:26:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731683AbhATEZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 23:25:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611116665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jIuh7SxU93BuybyBivroDVvSIaVYcMTbwm+jPxQBIoI=;
        b=AlacIp37xqliptgyseY8BKg0L15OCJaxynKnnbwHKxn++fVW8EPyPP9xCaP9tXvdcjcdes
        eO15TWgING2oZby03Thxh3VRXWpnsn3sxV3vEukFBu7VYdq6+HdOufWoYQBSGcrpuSMoIh
        YTkR+xs2qtg/DDjjJDlh0Zkc/jAapEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-lp2UjuhQMDGbIaW0q_X0HA-1; Tue, 19 Jan 2021 23:24:22 -0500
X-MC-Unique: lp2UjuhQMDGbIaW0q_X0HA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78A1F800D53;
        Wed, 20 Jan 2021 04:24:20 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43D835D74B;
        Wed, 20 Jan 2021 04:24:08 +0000 (UTC)
Subject: Re: [RFC v3 01/11] eventfd: track eventfd_signal() recursion depth
 separately in different cases
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e8a2cc15-80f5-01e0-75ec-ea6281fda0eb@redhat.com>
Date:   Wed, 20 Jan 2021 12:24:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119045920.447-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午12:59, Xie Yongji wrote:
> Now we have a global percpu counter to limit the recursion depth
> of eventfd_signal(). This can avoid deadlock or stack overflow.
> But in stack overflow case, it should be OK to increase the
> recursion depth if needed. So we add a percpu counter in eventfd_ctx
> to limit the recursion depth for deadlock case. Then it could be
> fine to increase the global percpu counter later.


I wonder whether or not it's worth to introduce percpu for each eventfd.

How about simply check if eventfd_signal_count() is greater than 2?

Thanks


>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   fs/aio.c                |  3 ++-
>   fs/eventfd.c            | 20 +++++++++++++++++++-
>   include/linux/eventfd.h |  5 +----
>   3 files changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 1f32da13d39e..5d82903161f5 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1698,7 +1698,8 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>   		list_del(&iocb->ki_list);
>   		iocb->ki_res.res = mangle_poll(mask);
>   		req->done = true;
> -		if (iocb->ki_eventfd && eventfd_signal_count()) {
> +		if (iocb->ki_eventfd &&
> +			eventfd_signal_count(iocb->ki_eventfd)) {
>   			iocb = NULL;
>   			INIT_WORK(&req->work, aio_poll_put_work);
>   			schedule_work(&req->work);
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index e265b6dd4f34..2df24f9bada3 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -25,6 +25,8 @@
>   #include <linux/idr.h>
>   #include <linux/uio.h>
>   
> +#define EVENTFD_WAKE_DEPTH 0
> +
>   DEFINE_PER_CPU(int, eventfd_wake_count);
>   
>   static DEFINE_IDA(eventfd_ida);
> @@ -42,9 +44,17 @@ struct eventfd_ctx {
>   	 */
>   	__u64 count;
>   	unsigned int flags;
> +	int __percpu *wake_count;
>   	int id;
>   };
>   
> +bool eventfd_signal_count(struct eventfd_ctx *ctx)
> +{
> +	return (this_cpu_read(*ctx->wake_count) ||
> +		this_cpu_read(eventfd_wake_count) > EVENTFD_WAKE_DEPTH);
> +}
> +EXPORT_SYMBOL_GPL(eventfd_signal_count);
> +
>   /**
>    * eventfd_signal - Adds @n to the eventfd counter.
>    * @ctx: [in] Pointer to the eventfd context.
> @@ -71,17 +81,19 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>   	 * it returns true, the eventfd_signal() call should be deferred to a
>   	 * safe context.
>   	 */
> -	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
> +	if (WARN_ON_ONCE(eventfd_signal_count(ctx)))
>   		return 0;
>   
>   	spin_lock_irqsave(&ctx->wqh.lock, flags);
>   	this_cpu_inc(eventfd_wake_count);
> +	this_cpu_inc(*ctx->wake_count);
>   	if (ULLONG_MAX - ctx->count < n)
>   		n = ULLONG_MAX - ctx->count;
>   	ctx->count += n;
>   	if (waitqueue_active(&ctx->wqh))
>   		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
>   	this_cpu_dec(eventfd_wake_count);
> +	this_cpu_dec(*ctx->wake_count);
>   	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
>   
>   	return n;
> @@ -92,6 +104,7 @@ static void eventfd_free_ctx(struct eventfd_ctx *ctx)
>   {
>   	if (ctx->id >= 0)
>   		ida_simple_remove(&eventfd_ida, ctx->id);
> +	free_percpu(ctx->wake_count);
>   	kfree(ctx);
>   }
>   
> @@ -423,6 +436,11 @@ static int do_eventfd(unsigned int count, int flags)
>   
>   	kref_init(&ctx->kref);
>   	init_waitqueue_head(&ctx->wqh);
> +	ctx->wake_count = alloc_percpu(int);
> +	if (!ctx->wake_count) {
> +		kfree(ctx);
> +		return -ENOMEM;
> +	}
>   	ctx->count = count;
>   	ctx->flags = flags;
>   	ctx->id = ida_simple_get(&eventfd_ida, 0, 0, GFP_KERNEL);
> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> index fa0a524baed0..1a11ebbd74a9 100644
> --- a/include/linux/eventfd.h
> +++ b/include/linux/eventfd.h
> @@ -45,10 +45,7 @@ void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
>   
>   DECLARE_PER_CPU(int, eventfd_wake_count);
>   
> -static inline bool eventfd_signal_count(void)
> -{
> -	return this_cpu_read(eventfd_wake_count);
> -}
> +bool eventfd_signal_count(struct eventfd_ctx *ctx);
>   
>   #else /* CONFIG_EVENTFD */
>   

