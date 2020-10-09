Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E57F288100
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgJIEFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgJIEFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602216343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YKXcX1Zdg1COG+JHgP7kxCkfawMp8ssx2TcF3Bvm0fI=;
        b=TTwroaamE2V/V7AqPCfK5KlBszS5iOb37Dk+/jhbbEf5U0a7coi4awOVa4g1Xp127gkhny
        jrYAOytxgcmThliTRUIhVfRph9aS/j2bhux9QPPYrKn8d5L3+nN+I1cZleQca3FR3OqfOI
        JJ65iNFwm1VjFwr2e6y2Hip4nYj6Oio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-MQnK_CGjM6qCMDUK3oEmaQ-1; Fri, 09 Oct 2020 00:05:41 -0400
X-MC-Unique: MQnK_CGjM6qCMDUK3oEmaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06F5280B70A;
        Fri,  9 Oct 2020 04:05:40 +0000 (UTC)
Received: from [10.72.13.133] (ovpn-13-133.pek2.redhat.com [10.72.13.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BB42100164C;
        Fri,  9 Oct 2020 04:05:20 +0000 (UTC)
Subject: Re: [PATCH v2] vringh: fix __vringh_iov() when riov and wiov are
 different
To:     Stefano Garzarella <sgarzare@redhat.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
References: <20201008204256.162292-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8d84abcb-2f2e-8f24-039f-447e8686b878@redhat.com>
Date:   Fri, 9 Oct 2020 12:05:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008204256.162292-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/9 上午4:42, Stefano Garzarella wrote:
> If riov and wiov are both defined and they point to different
> objects, only riov is initialized. If the wiov is not initialized
> by the caller, the function fails returning -EINVAL and printing
> "Readable desc 0x... after writable" error message.
>
> This issue happens when descriptors have both readable and writable
> buffers (eg. virtio-blk devices has virtio_blk_outhdr in the readable
> buffer and status as last byte of writable buffer) and we call
> __vringh_iov() to get both type of buffers in two different iovecs.
>
> Let's replace the 'else if' clause with 'if' to initialize both
> riov and wiov if they are not NULL.
>
> As checkpatch pointed out, we also avoid crashing the kernel
> when riov and wiov are both NULL, replacing BUG() with WARN_ON()
> and returning -EINVAL.


It looks like I met the exact similar issue when developing ctrl vq 
support (which requires both READ and WRITE descriptor).

While I was trying to fix the issue I found the following comment:

  * Note that you may need to clean up riov and wiov, even on error!
  */
int vringh_getdesc_iotlb(struct vringh *vrh,

I saw some driver call vringh_kiov_cleanup().

So I just follow to use that.

I'm not quite sure which one is better.

Thanks


>
> Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   drivers/vhost/vringh.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index e059a9a47cdf..8bd8b403f087 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -284,13 +284,14 @@ __vringh_iov(struct vringh *vrh, u16 i,
>   	desc_max = vrh->vring.num;
>   	up_next = -1;
>   
> +	/* You must want something! */
> +	if (WARN_ON(!riov && !wiov))
> +		return -EINVAL;
> +
>   	if (riov)
>   		riov->i = riov->used = 0;
> -	else if (wiov)
> +	if (wiov)
>   		wiov->i = wiov->used = 0;
> -	else
> -		/* You must want something! */
> -		BUG();
>   
>   	for (;;) {
>   		void *addr;

